import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime
import warnings
warnings.filterwarnings('ignore')

# Set style for plots
plt.style.use('seaborn-v0_8')
sns.set_palette("viridis")

# Load the dataset
df = pd.read_csv('/home/humpnduati/DATA_SCIENCE/25h--MachineLearing-1/Weekly Project/Week 1/chip_dataset.csv')

# 1. Explore missingness in the dataset
print("Initial Dataset Shape:", df.shape)
print("\nMissing Values Overview:")
missing_summary = pd.DataFrame({
    'Missing_Count': df.isnull().sum(),
    'Missing_Percentage': (df.isnull().sum() / len(df)) * 100
})
print(missing_summary.sort_values('Missing_Percentage', ascending=False))

# 2. Strategy for handling missing values
print("\n=== Missing Value Handling Strategy ===")

# Create a copy to avoid chained assignment warnings
df_clean = df.copy()

# Drop columns with high missingness
columns_to_drop = ['FP16 GFLOPS', 'FP32 GFLOPS', 'FP64 GFLOPS']  # Mostly missing
df_clean = df_clean.drop(columns=columns_to_drop)
print(f"Dropped columns: {columns_to_drop}")

# Handle missing values for remaining columns
# For categorical columns
categorical_cols = df_clean.select_dtypes(include=['object']).columns
for col in categorical_cols:
    missing_pct = (df_clean[col].isnull().sum() / len(df_clean)) * 100
    if missing_pct > 0:
        print(f"{col}: {missing_pct:.2f}% missing - imputing with mode")
        mode_val = df_clean[col].mode()[0] if not df_clean[col].mode().empty else 'Unknown'
        df_clean[col] = df_clean[col].fillna(mode_val)

# For numerical columns - ensure they are numeric first
numerical_cols = ['Process Size (nm)', 'TDP (W)', 'Die Size (mm^2)', 'Transistors (million)', 'Freq (GHz)']
for col in numerical_cols:
    # Convert to numeric, coercing errors to NaN
    df_clean[col] = pd.to_numeric(df_clean[col], errors='coerce')
    
    missing_pct = (df_clean[col].isnull().sum() / len(df_clean)) * 100
    if missing_pct > 0:
        print(f"{col}: {missing_pct:.2f}% missing - imputing with median")
        median_val = df_clean[col].median()
        df_clean[col] = df_clean[col].fillna(median_val)

# 4. Transform temporal data to datetime format with explicit format
# Convert dates with explicit format to avoid warnings
def parse_date(date_str):
    if pd.isna(date_str):
        return pd.NaT
    
    # Try different date formats
    formats = [
        '%m/%d/%y',  # 6/5/00
        '%m/%d/%Y',  # 6/5/2000
        '%Y',        # 2000
        '%Y-%m-%d',  # 2000-06-05
    ]
    
    for fmt in formats:
        try:
            return pd.to_datetime(date_str, format=fmt)
        except:
            continue
    
    # If all formats fail, return NaT
    return pd.NaT

df_clean['Release Date'] = df_clean['Release Date'].apply(parse_date)
print(f"Date range: {df_clean['Release Date'].min()} to {df_clean['Release Date'].max()}")

# Extract year from release date for time series analysis
df_clean['Release Year'] = df_clean['Release Date'].dt.year

# 5. Perform EDA and validate assumptions
print("\n=== EDA and Validation of Assumptions ===")

# Create a function for plotting to avoid code repetition
def create_scatter_plot(data, x_col, y_col, hue_col=None, log_y=False, title="", x_label="", y_label=""):
    plt.figure(figsize=(12, 8))
    if hue_col:
        for value in data[hue_col].unique():
            subset = data[data[hue_col] == value]
            plt.scatter(subset[x_col], subset[y_col], alpha=0.7, label=value)
        plt.legend()
    else:
        plt.scatter(data[x_col], data[y_col], alpha=0.7)
    
    if log_y:
        plt.yscale('log')
    
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.title(title)
    plt.grid(True, which="both", ls="--")
    plt.show()

# Assumption 1: Moore's Law still holds, especially in GPUs
print("\n1. Validating Moore's Law (Transistors over time)")
vendors_to_plot = ['AMD', 'NVIDIA', 'Intel']
vendor_data = df_clean[df_clean['Vendor'].isin(vendors_to_plot)]
create_scatter_plot(
    vendor_data, 'Release Year', 'Transistors (million)', 
    hue_col='Vendor', log_y=True,
    title="Moore's Law: Transistor Count Over Time",
    x_label="Release Year", 
    y_label="Transistors (million, log scale)"
)

# Assumption 2: Dennard Scaling is still valid in general
print("\n2. Validating Dennard Scaling (Power Density)")

# Calculate power density (TDP/Die Size) - ensure both are numeric
df_clean['Power Density'] = df_clean['TDP (W)'] / df_clean['Die Size (mm^2)']

# Update vendor_data to include the new Power Density column
vendor_data = df_clean[df_clean['Vendor'].isin(vendors_to_plot)]

create_scatter_plot(
    vendor_data, 'Release Year', 'Power Density', 
    hue_col='Vendor',
    title="Dennard Scaling: Power Density Over Time",
    x_label="Release Year", 
    y_label="Power Density (W/mm²)"
)

# Separate CPUs and GPUs
cpus = df_clean[df_clean['Type'] == 'CPU'].copy()
gpus = df_clean[df_clean['Type'] == 'GPU'].copy()

# Assumption 3: CPUs have higher frequencies, but GPUs are catching up
print("\n3. Comparing CPU and GPU Frequencies")

# Combine CPU and GPU data with a type indicator
cpu_gpu_data = pd.concat([
    cpus.assign(Type='CPU'),
    gpus.assign(Type='GPU')
], ignore_index=True)

create_scatter_plot(
    cpu_gpu_data, 'Release Year', 'Freq (GHz)', 
    hue_col='Type',
    title="CPU vs GPU Frequencies Over Time",
    x_label="Release Year", 
    y_label="Frequency (GHz)"
)

# Assumption 4: GPU performance doubles every 1.5 years
print("\n4. GPU Performance Doubling (Transistors as proxy)")

if not gpus.empty:
    gpu_transistors = gpus.groupby('Release Year')['Transistors (million)'].mean()

    plt.figure(figsize=(12, 8))
    plt.plot(gpu_transistors.index, gpu_transistors.values, marker='o')
    plt.yscale('log')
    plt.xlabel('Release Year')
    plt.ylabel('Average Transistors (million, log scale)')
    plt.title("GPU Transistor Count Over Time (Performance Proxy)")
    plt.grid(True, which="both", ls="--")

    # Add reference lines for doubling every 1.5 years
    if not gpu_transistors.empty:
        current_val = gpu_transistors.iloc[0]
        current_year = gpu_transistors.index[0]
        while current_year <= gpu_transistors.index[-1]:
            plt.axvline(x=current_year, color='r', linestyle='--', alpha=0.3)
            current_val *= 2
            current_year += 1.5

    plt.show()
else:
    print("No GPU data available for analysis")

# Assumption 5: GPU performance improvement factors
print("\n5. GPU Performance Improvement Factors")

if not gpus.empty:
    gpu_yearly = gpus.groupby('Release Year').agg({
        'Process Size (nm)': 'mean',
        'Die Size (mm^2)': 'mean',
        'Freq (GHz)': 'mean',
        'Transistors (million)': 'mean'
    }).reset_index()

    fig, axes = plt.subplots(2, 2, figsize=(15, 10))
    axes = axes.flatten()

    metrics = ['Process Size (nm)', 'Die Size (mm^2)', 'Freq (GHz)', 'Transistors (million)']
    titles = ['Process Size Reduction', 'Die Size Growth', 'Frequency Increase', 'Transistor Count Growth']

    for i, metric in enumerate(metrics):
        axes[i].plot(gpu_yearly['Release Year'], gpu_yearly[metric], marker='o')
        axes[i].set_title(titles[i])
        axes[i].set_xlabel('Release Year')
        axes[i].set_ylabel(metric)
        if metric == 'Process Size (nm)':
            axes[i].invert_yaxis()  # Smaller process is better
        if metric in ['Die Size (mm^2)', 'Transistors (million)']:
            axes[i].set_yscale('log')

    plt.tight_layout()
    plt.show()
else:
    print("No GPU data available for analysis")

# Assumption 6: High-end GPUs use new technologies first
print("\n6. High-end GPUs Use New Technologies First")

if not gpus.empty:
    # Identify high-end GPUs (assuming larger die size and more transistors indicate high-end)
    gpus['High End'] = (gpus['Die Size (mm^2)'] > gpus['Die Size (mm^2)'].median()) & \
                       (gpus['Transistors (million)'] > gpus['Transistors (million)'].median())

    create_scatter_plot(
        gpus, 'Release Year', 'Process Size (nm)', 
        hue_col='High End',
        title="Process Size Adoption: High-end vs Low-end GPUs",
        x_label="Release Year", 
        y_label="Process Size (nm)"
    )
else:
    print("No GPU data available for analysis")

# Assumption 7: Process Size comparison by vendor
print("\n7. Process Size Comparison by Vendor")

vendor_data = df_clean[df_clean['Vendor'].isin(['Intel', 'AMD', 'NVIDIA', 'ATI', 'TSMC'])]
create_scatter_plot(
    vendor_data, 'Release Year', 'Process Size (nm)', 
    hue_col='Vendor',
    title="Process Size by Vendor Over Time",
    x_label="Release Year", 
    y_label="Process Size (nm)"
)

# Assumption 8: TSMC's market share
print("\n8. TSMC's Market Share in Chip Production")

foundry_counts = df_clean['Foundry'].value_counts()
plt.figure(figsize=(12, 8))
foundry_counts.plot(kind='bar')
plt.title('Chip Production by Foundry')
plt.xlabel('Foundry')
plt.ylabel('Number of Chips Produced')
plt.xticks(rotation=45)
plt.show()

# 6. Calculate and visualize correlation among features
print("\n=== Feature Correlation Analysis ===")

# Select numerical features for correlation
numerical_features = ['Process Size (nm)', 'TDP (W)', 'Die Size (mm^2)', 
                      'Transistors (million)', 'Freq (GHz)', 'Release Year']

corr_matrix = df_clean[numerical_features].corr()

plt.figure(figsize=(10, 8))
sns.heatmap(corr_matrix, annot=True, cmap='coolwarm', center=0, fmt='.2f')
plt.title('Correlation Matrix of Numerical Features')
plt.show()

# 7. Encode categorical data for modeling
print("\n=== Encoding Categorical Data ===")

# One-hot encoding for Vendor and Foundry
df_encoded = pd.get_dummies(df_clean, columns=['Vendor', 'Foundry', 'Type'], prefix=['Vendor', 'Foundry', 'Type'])

print(f"Original dataset shape: {df.shape}")
print(f"Encoded dataset shape: {df_encoded.shape}")
print("New columns after encoding:")
print([col for col in df_encoded.columns if col.startswith(('Vendor_', 'Foundry_', 'Type_'))])

# Save the cleaned and encoded dataset
df_encoded.to_csv('cleaned_chip_dataset.csv', index=False)
print("\nCleaned and encoded dataset saved as 'cleaned_chip_dataset.csv'")

# Additional summary statistics
print("\n=== Additional Summary Statistics ===")
print(f"Total records: {len(df_clean)}")
print(f"CPU records: {len(cpus)}")
print(f"GPU records: {len(gpus)}")
print(f"Vendor distribution:\n{df_clean['Vendor'].value_counts()}")
print(f"Foundry distribution:\n{df_clean['Foundry'].value_counts()}")