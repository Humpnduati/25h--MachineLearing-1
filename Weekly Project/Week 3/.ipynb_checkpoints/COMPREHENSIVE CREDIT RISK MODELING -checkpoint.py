import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV, StratifiedKFold
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix, roc_auc_score, roc_curve, precision_recall_curve
from sklearn.feature_selection import SelectFromModel, RFE
from sklearn.impute import SimpleImputer
from imblearn.over_sampling import SMOTE
from imblearn.pipeline import Pipeline as ImbPipeline
import warnings
warnings.filterwarnings('ignore')


class CreditRiskModeler:
    """Credit Risk Modeling Class"""
    
    def __init__(self, data_path):
        self.data_path = data_path
        self.df = None
        self.X = None
        self.y = None
        self.X_train = None
        self.X_test = None
        self.y_train = None
        self.y_test = None
        self.best_model = None
        self.feature_names = None
        self.results = {}
        self.scaler = StandardScaler()
        
    def load_and_rename_data(self):
        """Load and rename columns professionally"""
       
        # Column mapping
        
        column_map = {
            'V1': 'Customer_ID', 'V2': 'Bounced_First_EMI', 'V3': 'Bounces_12M',
            'V4': 'Max_MOB', 'V5': 'Bounces_While_Repaying', 'V6': 'EMI',
            'V7': 'Loan_Amount', 'V8': 'Tenure', 'V9': 'Dealer_Code',
            'V10': 'Product_Code', 'V11': 'Advance_EMI_Paid', 'V12': 'Interest_Rate',
            'V13': 'Gender', 'V14': 'Employment_Type', 'V15': 'Resident_Type',
            'V16': 'DOB', 'V17': 'Age_At_Loan', 'V18': 'Total_Loans',
            'V19': 'Secured_Loans', 'V20': 'Unsecured_Loans', 'V21': 'Max_Live_Sanctioned',
            'V22': 'New_Loans_3M', 'V23': 'Live_Secured_Amount', 'V24': 'Live_Unsecured_Amount',
            'V25': 'Max_Two_Wheeler_Loan', 'V26': 'Months_Since_Last_Personal_Loan',
            'V27': 'Months_Since_First_Durable_Loan', 'V28': 'Times_30DPD_6M',
            'V29': 'Times_60DPD_6M', 'V30': 'Times_90DPD_3M', 'V31': 'Tier', 'V32': 'Default'
        }
        
        self.df = pd.read_csv(self.data_path)
        self.df = self.df.rename(columns = column_map)
        
        # Drop irrelevant columns efficiently
        
        cols_to_drop = ['Months_Since_First_Durable_Loan', 'Months_Since_Last_Personal_Loan',
                       'Max_Live_Sanctioned', 'Live_Secured_Amount', 'Live_Unsecured_Amount',
                       'Max_Two_Wheeler_Loan', 'DOB']    # Added DOB since we have Age_At_Loan
        
        self.df = self.df.drop([col for col in cols_to_drop if col in self.df.columns], axis = 1)
        
        return self.df.shape

    def handle_missing_values(self):
        """Professional missing value handling with strategy"""
        
        # Drop critical missing values
        
        self.df = self.df.dropna(subset = ['Loan_Amount', 'Gender', 'Default'])
        
        # Strategy: Separate numerical and categorical
        
        num_cols = self.df.select_dtypes(include = [np.number]).columns
        cat_cols = self.df.select_dtypes(include = ['object']).columns
        
        # Numerical: Median for <30% missing, else drop
        
        for col in num_cols:
            if col != 'Default' and self.df[col].isnull().sum() > 0:
                missing_pct = self.df[col].isnull().mean()
                if missing_pct < 0.3:
                    self.df[col].fillna(self.df[col].median(), inplace = True)
                else:
                    self.df.drop(col, axis = 1, inplace = True)
        
        # Categorical: Mode for <30% missing, else 'Unknown'
        
        for col in cat_cols:
            if self.df[col].isnull().sum() > 0:
                missing_pct = self.df[col].isnull().mean()
                if missing_pct < 0.3:
                    mode_val = self.df[col].mode()[0] if not self.df[col].mode().empty else 'Unknown'
                    self.df[col].fillna(mode_val, inplace = True)
                else:
                    self.df[col].fillna('Unknown', inplace = True)
        
        return self.df.isnull().sum().sum()

    def create_features(self):
        """Create powerful financial features efficiently"""
        
        # Financial ratios
        
        if all(col in self.df.columns for col in ['EMI', 'Loan_Amount']):
            self.df['EMI_to_Income_Ratio'] = self.df['EMI'] / (self.df['Loan_Amount'] + 1)
        
        if all(col in self.df.columns for col in ['Bounces_12M', 'Tenure']):
            self.df['Bounce_Rate'] = self.df['Bounces_12M'] / (self.df['Tenure'] + 1)
        
        # Payment behavior composite
        
        due_columns = ['Times_30DPD_6M', 'Times_60DPD_6M', 'Times_90DPD_3M']
        weights = [1, 2, 3]
        payment_score = 0
        for col, weight in zip(due_columns, weights):
            if col in self.df.columns:
                payment_score += self.df[col] * weight
        self.df['Payment_Risk_Score'] = payment_score
        
        # Age features
        
        if 'Age_At_Loan' in self.df.columns:
            bins = [0, 25, 35, 45, 55, 100]
            labels = ['18-25', '26-35', '36-45', '46-55', '55+']
            self.df['Age_Group'] = pd.cut(self.df['Age_At_Loan'], bins = bins, labels = labels)
            
            # Convert to object type to avoid category dtype issues
            
            self.df['Age_Group'] = self.df['Age_Group'].astype(object)
        
        # Loan composition ratio
        
        if all(col in self.df.columns for col in ['Secured_Loans', 'Total_Loans']):
            self.df['Secured_Loan_Ratio'] = self.df['Secured_Loans'] / (self.df['Total_Loans'] + 1)
        
        return len(self.df.columns)

    def encode_features(self):
        """Efficient feature encoding"""
        
        # Label encode categorical variables
        
        label_encoders = {}
        cat_cols = self.df.select_dtypes(include = ['object', 'category']).columns
        
        for col in cat_cols:
            if col in self.df.columns and col != 'Customer_ID':
                le = LabelEncoder()
                self.df[col] = le.fit_transform(self.df[col].astype(str))
                label_encoders[col] = le
        
        return label_encoders

    def select_features(self):
        """Advanced feature selection"""
        
        # Prepare data
        
        self.X = self.df.drop(['Customer_ID', 'Default'], axis = 1, errors = 'ignore')
        self.y = self.df['Default']
        
        # Separate numerical and categorical features
        
        numerical_cols = self.X.select_dtypes(include = [np.number]).columns
        categorical_cols = self.X.select_dtypes(exclude = [np.number]).columns
        
        # Remove constant numerical features
        
        constant_numerical = []
        for col in numerical_cols:
            if self.X[col].std() == 0:
                constant_numerical.append(col)
        
        # Remove constant categorical features
        
        constant_categorical = []
        for col in categorical_cols:
            if self.X[col].nunique() <= 1:
                constant_categorical.append(col)
        
        self.X = self.X.drop(constant_numerical + constant_categorical, axis = 1)
        
        # Update column lists after removing constants
        
        numerical_cols = self.X.select_dtypes(include = [np.number]).columns
        categorical_cols = self.X.select_dtypes(exclude = [np.number]).columns
        
        # Use Random Forest for feature selection (only on numerical features)
        
        if len(numerical_cols) > 0:
            rf = RandomForestClassifier(n_estimators = 100, random_state = 42, n_jobs = -1)
            rf.fit(self.X[numerical_cols], self.y)
            
            # Select top numerical features based on importance
            
            importance_df = pd.DataFrame({
                'feature': numerical_cols,
                'importance': rf.feature_importances_
            }).sort_values('importance', ascending = False)
            
            # Keep numerical features with importance > 0.01
            
            selected_numerical = importance_df[importance_df['importance'] > 0.01]['feature'].tolist()
            
            if len(selected_numerical) < 5:   # Ensure minimum numerical features
                selected_numerical = importance_df.head(10)['feature'].tolist()
            
            # Combine selected numerical features with all categorical features
            
            selected_features = selected_numerical + categorical_cols.tolist()
            
            self.X = self.X[selected_features]
            self.feature_names = selected_features
        else:
            
            # If no numerical features, use all remaining features
            
            self.feature_names = self.X.columns.tolist()
        
        return len(self.feature_names)

    def prepare_data(self, test_size = 0.3):
        """Prepare train/test splits with proper scaling"""
        
        # Split data
        
        self.X_train, self.X_test, self.y_train, self.y_test = train_test_split(
            self.X, self.y, test_size = test_size, random_state = 42, stratify = self.y
        )
        
        # Scale features
        
        self.X_train_scaled = self.scaler.fit_transform(self.X_train)
        self.X_test_scaled = self.scaler.transform(self.X_test)
        
        return self.X_train.shape, self.X_test.shape

    def evaluate_model(self, model, X_train, y_train, X_test, y_test, name):
        """Comprehensive model evaluation"""
        
        # Train model
        
        model.fit(X_train, y_train)
        
        # Predictions
        
        y_pred = model.predict(X_test)
        y_pred_proba = model.predict_proba(X_test)[:, 1]
        
        # Metrics
        
        accuracy = (y_pred == y_test).mean()
        auc = roc_auc_score(y_test, y_pred_proba)
        
        # Cross-validation
        
        cv_scores = cross_val_score(model, X_train, y_train, cv = 5, scoring = 'roc_auc', n_jobs = -1)
        
        return {
            'model': model,
            'accuracy': accuracy,
            'auc': auc,
            'cv_mean': cv_scores.mean(),
            'cv_std': cv_scores.std(),
            'y_pred': y_pred,
            'y_pred_proba': y_pred_proba
        }

    def train_models(self):
        """Train and compare multiple models efficiently"""
        models = {
            'Logistic Regression': LogisticRegression(random_state = 42, max_iter = 1000, n_jobs = -1),
            'Random Forest': RandomForestClassifier(random_state = 42, n_jobs = -1),
            'Gradient Boosting': GradientBoostingClassifier(random_state = 42)
        }
        
        # Train without SMOTE
        
        for name, model in models.items():
            if name == 'Logistic Regression':
                X_tr, X_te = self.X_train_scaled, self.X_test_scaled
            else:
                X_tr, X_te = self.X_train, self.X_test
            
            self.results[name] = self.evaluate_model(
                model, X_tr, self.y_train, X_te, self.y_test, name
            )
        
        # Train with SMOTE for best model 
        
        best_model_name = max(self.results.keys(), key = lambda x: self.results[x]['auc'])
        best_result = self.results[best_model_name]
        
        # Create pipeline with SMOTE for the best model
        
        if best_model_name == 'Logistic Regression':
            base_model = LogisticRegression(random_state = 42, max_iter = 1000)
            
            # Create pipeline with SMOTE and scaling
            
            smote_pipeline = ImbPipeline([
                ('smote', SMOTE(random_state = 42)),
                ('scaler', StandardScaler()),
                ('model', base_model)
            ])
            
            # Fit on original unscaled training data
            
            smote_pipeline.fit(self.X_train, self.y_train)
            
            # Predict on scaled test data
            
            y_pred = smote_pipeline.predict(self.X_test)
            y_pred_proba = smote_pipeline.predict_proba(self.X_test)[:, 1]
            
        else:
            base_model = models[best_model_name]
            
            # Create pipeline with SMOTE
            
            smote_pipeline = ImbPipeline([
                ('smote', SMOTE(random_state = 42)),
                ('model', base_model)
            ])
            
            # Fit and predict
            
            smote_pipeline.fit(self.X_train, self.y_train)
            y_pred = smote_pipeline.predict(self.X_test)
            y_pred_proba = smote_pipeline.predict_proba(self.X_test)[:, 1]
        
        # Calculate metrics for SMOTE model
        
        accuracy = (y_pred == self.y_test).mean()
        auc = roc_auc_score(self.y_test, y_pred_proba)
        
        # Cross-validation for SMOTE model
        
        if best_model_name == 'Logistic Regression':
            cv_pipeline = ImbPipeline([
                ('smote', SMOTE(random_state = 42)),
                ('scaler', StandardScaler()),
                ('model', base_model)
            ])
        else:
            cv_pipeline = ImbPipeline([
                ('smote', SMOTE(random_state = 42)),
                ('model', base_model)
            ])
        
        cv_scores = cross_val_score(cv_pipeline, self.X_train, self.y_train, 
                                   cv = 5, scoring = 'roc_auc', n_jobs = -1)
        
        self.results[f'{best_model_name}_SMOTE'] = {
            'model': smote_pipeline,
            'accuracy': accuracy,
            'auc': auc,
            'cv_mean': cv_scores.mean(),
            'cv_std': cv_scores.std(),
            'y_pred': y_pred,
            'y_pred_proba': y_pred_proba
        }
        
        return self.results

    def optimize_best_model(self):
        """Hyperparameter optimization for best model"""
        
        # Identify best model
        best_model_name = max(self.results.keys(), key=lambda x: self.results[x]['auc'])
        best_result = self.results[best_model_name]
        
        # Parameter grids
        param_grids = {
            'Logistic Regression': {
                'model__C': [0.1, 1, 10, 100],
                'model__penalty': ['l1', 'l2'],
                'model__solver': ['liblinear']
            },
            'Random Forest': {
                'model__n_estimators': [100, 200],
                'model__max_depth': [10, 20, None],
                'model__min_samples_split': [2, 5]
            },
            'Gradient Boosting': {
                'model__n_estimators': [100, 200],
                'model__learning_rate': [0.05, 0.1],
                'model__max_depth': [3, 4]
            }
        }
        
        base_model_name = best_model_name.replace('_SMOTE', '')
        
        if base_model_name in param_grids:
            
            # Create appropriate pipeline
            
            if 'SMOTE' in best_model_name:
                if base_model_name == 'Logistic Regression':
                    pipeline = ImbPipeline([
                        ('smote', SMOTE(random_state = 42)),
                        ('scaler', StandardScaler()),
                        ('model', LogisticRegression(random_state = 42, max_iter = 1000))
                    ])
                else:
                    model_map = {
                        'Random Forest': RandomForestClassifier(random_state = 42),
                        'Gradient Boosting': GradientBoostingClassifier(random_state = 42)
                    }
                    pipeline = ImbPipeline([
                        ('smote', SMOTE(random_state = 42)),
                        ('model', model_map[base_model_name])
                    ])
            else:
                if base_model_name == 'Logistic Regression':
                    pipeline = ImbPipeline([
                        ('scaler', StandardScaler()),
                        ('model', LogisticRegression(random_state = 42, max_iter = 1000))
                    ])
                else:
                    model_map = {
                        'Random Forest': RandomForestClassifier(random_state = 42),
                        'Gradient Boosting': GradientBoostingClassifier(random_state = 42)
                    }
                    pipeline = ImbPipeline([
                        ('model', model_map[base_model_name])
                    ])
            
            # Grid search with cross-validation
            
            grid_search = GridSearchCV(
                pipeline, param_grids[base_model_name], 
                cv = 5, scoring = 'roc_auc', n_jobs = -1, verbose = 0
            )
            
            grid_search.fit(self.X_train, self.y_train)
            
            # Store optimized model
            
            self.best_model = grid_search.best_estimator_
            
            # Evaluate optimized model
            
            y_pred = self.best_model.predict(self.X_test)
            y_pred_proba = self.best_model.predict_proba(self.X_test)[:, 1]
            
            accuracy = (y_pred == self.y_test).mean()
            auc = roc_auc_score(self.y_test, y_pred_proba)
            
            cv_scores = cross_val_score(self.best_model, self.X_train, self.y_train, 
                                      cv = 5, scoring = 'roc_auc', n_jobs = -1)
            
            self.results['Optimized'] = {
                'model': self.best_model,
                'accuracy': accuracy,
                'auc': auc,
                'cv_mean': cv_scores.mean(),
                'cv_std': cv_scores.std(),
                'y_pred': y_pred,
                'y_pred_proba': y_pred_proba
            }
            
            return grid_search.best_params_
        
        return None

    def generate_credit_scores(self):
        """Generate credit scores from probabilities"""
        if self.best_model is not None:
            
            # Use optimized model
            
            probabilities = self.best_model.predict_proba(self.X_test)[:, 1]
        else:
            
            # Use best available model
            
            best_model_name = max(self.results.keys(), key = lambda x: self.results[x]['auc'])
            model = self.results[best_model_name]['model']
            probabilities = model.predict_proba(self.X_test)[:, 1]
        
        # Convert to credit scores (300-850 scale)
        
        min_score, max_score = 300, 850
        
        # Use percentile-based scaling for better distribution
        
        p5 = np.percentile(probabilities, 5)
        p95 = np.percentile(probabilities, 95)
        
        # Scale probabilities to credit scores (inverse relationship - higher probability of default = lower score)
        
        scaled_probs = (probabilities - p5) / (p95 - p5)
        scaled_probs = np.clip(scaled_probs, 0, 1)
        
        # Inverse relationship: higher default probability = lower credit score
        
        credit_scores = max_score - (scaled_probs * (max_score - min_score))
        
        return credit_scores

    def categorize_customers(self, credit_scores):
        """Categorize customers based on credit scores"""
        
        categories = []
        for score in credit_scores:
            if score >= 750:
                categories.append('Excellent')
            elif score >= 700:
                categories.append('Good')
            elif score >= 650:
                categories.append('Fair')
            elif score >= 600:
                categories.append('Poor')
            else:
                categories.append('Very Poor')
        
        return categories

    def create_summary_report(self):
        """Create comprehensive business report"""
        
        # Generate credit scores
        
        credit_scores = self.generate_credit_scores()
        categories = self.categorize_customers(credit_scores)
        
        # Create results dataframe
        
        results_df = pd.DataFrame({
            'Customer_ID': self.df.loc[self.y_test.index, 'Customer_ID'].values if 'Customer_ID' in self.df.columns else range(len(self.y_test)),
            'Credit_Score': credit_scores,
            'Category': categories,
            'Default_Probability': self.results['Optimized']['y_pred_proba'] if 'Optimized' in self.results else 
                                 self.results[max(self.results.keys(), key = lambda x: self.results[x]['auc'])]['y_pred_proba'],
            'Predicted_Default': self.results['Optimized']['y_pred'] if 'Optimized' in self.results else 
                               self.results[max(self.results.keys(), key = lambda x: self.results[x]['auc'])]['y_pred'],
            'Actual_Default': self.y_test.values
        })
        
        # Summary statistics
        
        summary = results_df.groupby('Category').agg({
            'Actual_Default': ['count', 'mean'],
            'Credit_Score': ['min', 'max', 'mean'],
            'Default_Probability': 'mean'
        }).round(2)
        
        summary.columns = ['Count', 'Default_Rate', 'Min_Score', 'Max_Score', 'Avg_Score', 'Avg_Default_Prob']
        summary['Default_Rate'] = (summary['Default_Rate'] * 100).round(1)
        summary['Avg_Default_Prob'] = (summary['Avg_Default_Prob'] * 100).round(1)
        
        return results_df, summary

    def plot_results(self):
        """Professional visualization of results"""
        
        fig, axes = plt.subplots(2, 2, figsize=(15, 12))
        
        # 1. Model Comparison
        
        model_names = [name for name in self.results.keys() if 'Optimized' not in name]
        auc_scores = [self.results[name]['auc'] for name in model_names]
        
        axes[0,0].barh(model_names, auc_scores)
        axes[0,0].set_xlabel('AUC Score')
        axes[0,0].set_title('Model Performance Comparison')
        axes[0,0].axvline(x = 0.5, color = 'red', linestyle = '--')
        for i, v in enumerate(auc_scores):
            axes[0,0].text(v + 0.01, i, f'{v:.3f}', va = 'center')
        
        # 2. ROC Curves
        
        for name, result in self.results.items():
            fpr, tpr, _ = roc_curve(self.y_test, result['y_pred_proba'])
            axes[0,1].plot(fpr, tpr, label=f'{name} (AUC = {result["auc"]:.3f})')
        
        axes[0,1].plot([0, 1], [0, 1], 'k--', label = 'Random')
        axes[0,1].set_xlabel('False Positive Rate')
        axes[0,1].set_ylabel('True Positive Rate')
        axes[0,1].set_title('ROC Curves')
        axes[0,1].legend()
        
        # 3. Feature Importance (if available)
        
        if self.best_model and hasattr(self.best_model.named_steps['model'], 'feature_importances_'):
            importance_df = pd.DataFrame({
                'feature': self.feature_names,
                'importance': self.best_model.named_steps['model'].feature_importances_
            }).sort_values('importance', ascending = False).head(10)
            
            axes[1,0].barh(importance_df['feature'], importance_df['importance'])
            axes[1,0].set_xlabel('Importance')
            axes[1,0].set_title('Top 10 Feature Importances')
            for i, v in enumerate(importance_df['importance']):
                axes[1,0].text(v + 0.01, i, f'{v:.3f}', va = 'center')
        
        # 4. Credit Score Distribution
        
        credit_scores = self.generate_credit_scores()
        axes[1,1].hist(credit_scores, bins = 30, alpha = 0.7, edgecolor = 'black')
        axes[1,1].axvline(x = 600, color = 'red', linestyle = '--', label = 'Risk Threshold (600)')
        axes[1,1].set_xlabel('Credit Score')
        axes[1,1].set_ylabel('Frequency')
        axes[1,1].set_title('Credit Score Distribution')
        axes[1,1].legend()
        
        plt.tight_layout()
        plt.show()

    def run_complete_analysis(self):
        """Credit risk analysis"""
        print('=== CREDIT RISK MODELING ===')
        print('1. Loading and preprocessing data...')
        shape = self.load_and_rename_data()
        print(f'   Loaded dataset with {shape[0]} rows and {shape[1]} columns')
        
        print('2. Handling missing values...')
        remaining_missing = self.handle_missing_values()
        print(f'   Remaining missing values: {remaining_missing}')
        
        print('3. Creating advanced features...')
        num_features = self.create_features()
        print(f'   Total features after engineering: {num_features}')
        
        print('4. Encoding categorical variables...')
        self.encode_features()
        print('   Encoding completed')
        
        print('5. Selecting optimal features...')
        num_selected = self.select_features()
        print(f'   Selected {num_selected} optimal features')
        
        print('6. Preparing training data...')
        train_shape, test_shape = self.prepare_data()
        print(f'   Training set: {train_shape}, Test set: {test_shape}')
        
        print('7. Training multiple models...')
        self.train_models()
        print('   Model training completed')
        
        print('8. Optimizing best model...')
        best_params = self.optimize_best_model()
        if best_params:
            print(f'   Best parameters: {best_params}')
        
        print('9. Generating credit scores...')
        credit_scores = self.generate_credit_scores()
        print(f'   Generated credit scores for {len(credit_scores)} customers')
        
        print('10. Creating business report...')
        results_df, summary = self.create_summary_report()
        
        # Print results
        
        print('\n' + "=" * 60)
        print('MODEL PERFORMANCE SUMMARY')
        print("=" * 60)
        for name, result in self.results.items():
            print(f'{name:25} AUC: {result['auc']:.4f} | Accuracy: {result['accuracy']:.4f} | CV Score: {result['cv_mean']:.4f} ± {result['cv_std']:.4f}')
        
        print('\n' + "=" * 60)
        print('CUSTOMER CATEGORIZATION SUMMARY')
        print("=" * 60)
        print(summary)
        
        # Plot results
        
        self.plot_results()
        
        return results_df, summary


if __name__ == "__main__":
    
    # Initialize modeler
    
    modeler = CreditRiskModeler('raw-data.csv')
    
    # Run complete analysis
    
    try:
        results, summary = modeler.run_complete_analysis()
        
        # Save results
        
        results.to_csv('credit_risk_results.csv', index = False)
        summary.to_csv('customer_categorization_summary.csv')
        
        
        print('Results saved to credit_risk_results.csv')
        print('Summary saved to customer_categorization_summary.csv')
        
        # Print key insights
        
        print('\n' + "=" * 60)
        print('KEY BUSINESS INSIGHTS')
        print("=" * 60)
        print(f'Total customers analyzed: {len(results)}')
        print(f'Average credit score: {results['Credit_Score'].mean():.1f}')
        print(f'Default rate in portfolio: {results['Actual_Default'].mean()*100:.1f}%')
        
        # Risk distribution
        
        risk_dist = results['Category'].value_counts()
        print('\nRisk Distribution:')
        for category, count in risk_dist.items():
            pct = (count / len(results)) * 100
            print(f'  {category}: {count} customers ({pct:.1f}%)')
            
    except Exception as e:
        print(f'Error during analysis: {e}')
        import traceback
        traceback.print_exc()
        print('Please check your data file and ensure it has the correct format.')