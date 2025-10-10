

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema F1--DB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema F1--DB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `F1--DB` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `F1--DB` ;

-- -----------------------------------------------------
-- Table `F1--DB`.`continent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`continent` (
  `id` VARCHAR(100) NOT NULL,
  `code` VARCHAR(2) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `demonym` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `code` (`code` ASC) VISIBLE,
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`country` (
  `id` VARCHAR(100) NOT NULL,
  `alpha2_code` VARCHAR(2) NOT NULL,
  `alpha3_code` VARCHAR(3) NOT NULL,
  `ioc_code` VARCHAR(3) NULL DEFAULT NULL,
  `name` VARCHAR(100) NOT NULL,
  `demonym` VARCHAR(100) NULL DEFAULT NULL,
  `continent_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `alpha2_code` (`alpha2_code` ASC) VISIBLE,
  UNIQUE INDEX `alpha3_code` (`alpha3_code` ASC) VISIBLE,
  UNIQUE INDEX `name` (`name` ASC) VISIBLE,
  INDEX `cntr_continent_id_idx` (`continent_id` ASC) VISIBLE,
  CONSTRAINT `country_ibfk_1`
    FOREIGN KEY (`continent_id`)
    REFERENCES `F1--DB`.`continent` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`constructor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`constructor` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `country_id` VARCHAR(100) NOT NULL,
  `best_championship_position` INT NULL DEFAULT NULL,
  `best_starting_grid_position` INT NULL DEFAULT NULL,
  `best_race_result` INT NULL DEFAULT NULL,
  `total_championship_wins` INT NOT NULL,
  `total_race_entries` INT NOT NULL,
  `total_race_starts` INT NOT NULL,
  `total_race_wins` INT NOT NULL,
  `total_1_and_2_finishes` INT NOT NULL,
  `total_race_laps` INT NOT NULL,
  `total_podiums` INT NOT NULL,
  `total_podium_races` INT NOT NULL,
  `total_points` DECIMAL(8,2) NOT NULL,
  `total_championship_points` DECIMAL(8,2) NOT NULL,
  `total_pole_positions` INT NOT NULL,
  `total_fastest_laps` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `cnst_country_id_idx` (`country_id` ASC) VISIBLE,
  INDEX `cnst_full_name_idx` (`full_name` ASC) VISIBLE,
  INDEX `cnst_name_idx` (`name` ASC) VISIBLE,
  CONSTRAINT `constructor_ibfk_1`
    FOREIGN KEY (`country_id`)
    REFERENCES `F1--DB`.`country` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`chassis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`chassis` (
  `id` VARCHAR(100) NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `chss_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `chss_full_name_idx` (`full_name` ASC) VISIBLE,
  INDEX `chss_name_idx` (`name` ASC) VISIBLE,
  CONSTRAINT `chassis_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`circuit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`circuit` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `previous_names` VARCHAR(255) NULL DEFAULT NULL,
  `type` VARCHAR(6) NOT NULL,
  `direction` VARCHAR(14) NOT NULL,
  `place_name` VARCHAR(100) NOT NULL,
  `country_id` VARCHAR(100) NOT NULL,
  `latitude` DECIMAL(10,6) NOT NULL,
  `longitude` DECIMAL(10,6) NOT NULL,
  `length` DECIMAL(6,3) NOT NULL,
  `turns` INT NOT NULL,
  `total_races_held` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `crct_country_id_idx` (`country_id` ASC) VISIBLE,
  INDEX `crct_direction_idx` (`direction` ASC) VISIBLE,
  INDEX `crct_full_name_idx` (`full_name` ASC) VISIBLE,
  INDEX `crct_name_idx` (`name` ASC) VISIBLE,
  INDEX `crct_place_name_idx` (`place_name` ASC) VISIBLE,
  INDEX `crct_type_idx` (`type` ASC) VISIBLE,
  CONSTRAINT `circuit_ibfk_1`
    FOREIGN KEY (`country_id`)
    REFERENCES `F1--DB`.`country` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`constructor_chronology`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`constructor_chronology` (
  `constructor_id` VARCHAR(100) NOT NULL,
  `position_display_order` INT NOT NULL,
  `other_constructor_id` VARCHAR(100) NOT NULL,
  `year_from` INT NOT NULL,
  `year_to` INT NULL DEFAULT NULL,
  PRIMARY KEY (`constructor_id`, `position_display_order`),
  UNIQUE INDEX `constructor_id` (`constructor_id` ASC, `other_constructor_id` ASC, `year_from` ASC, `year_to` ASC) VISIBLE,
  INDEX `cnch_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `cnch_other_constructor_id_idx` (`other_constructor_id` ASC) VISIBLE,
  INDEX `cnch_position_display_order_idx` (`position_display_order` ASC) VISIBLE,
  CONSTRAINT `constructor_chronology_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `constructor_chronology_ibfk_2`
    FOREIGN KEY (`other_constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`driver`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`driver` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `abbreviation` VARCHAR(3) NOT NULL,
  `permanent_number` VARCHAR(2) NULL DEFAULT NULL,
  `gender` VARCHAR(6) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `date_of_death` DATE NULL DEFAULT NULL,
  `place_of_birth` VARCHAR(100) NOT NULL,
  `country_of_birth_country_id` VARCHAR(100) NOT NULL,
  `nationality_country_id` VARCHAR(100) NOT NULL,
  `second_nationality_country_id` VARCHAR(100) NULL DEFAULT NULL,
  `best_championship_position` INT NULL DEFAULT NULL,
  `best_starting_grid_position` INT NULL DEFAULT NULL,
  `best_race_result` INT NULL DEFAULT NULL,
  `total_championship_wins` INT NOT NULL,
  `total_race_entries` INT NOT NULL,
  `total_race_starts` INT NOT NULL,
  `total_race_wins` INT NOT NULL,
  `total_race_laps` INT NOT NULL,
  `total_podiums` INT NOT NULL,
  `total_points` DECIMAL(8,2) NOT NULL,
  `total_championship_points` DECIMAL(8,2) NOT NULL,
  `total_pole_positions` INT NOT NULL,
  `total_fastest_laps` INT NOT NULL,
  `total_driver_of_the_day` INT NOT NULL,
  `total_grand_slams` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `drvr_abbreviation_idx` (`abbreviation` ASC) VISIBLE,
  INDEX `drvr_country_of_birth_country_id_idx` (`country_of_birth_country_id` ASC) VISIBLE,
  INDEX `drvr_date_of_birth_idx` (`date_of_birth` ASC) VISIBLE,
  INDEX `drvr_date_of_death_idx` (`date_of_death` ASC) VISIBLE,
  INDEX `drvr_first_name_idx` (`first_name` ASC) VISIBLE,
  INDEX `drvr_full_name_idx` (`full_name` ASC) VISIBLE,
  INDEX `drvr_gender_idx` (`gender` ASC) VISIBLE,
  INDEX `drvr_last_name_idx` (`last_name` ASC) VISIBLE,
  INDEX `drvr_name_idx` (`name` ASC) VISIBLE,
  INDEX `drvr_nationality_country_id_idx` (`nationality_country_id` ASC) VISIBLE,
  INDEX `drvr_permanent_number_idx` (`permanent_number` ASC) VISIBLE,
  INDEX `drvr_place_of_birth_idx` (`place_of_birth` ASC) VISIBLE,
  INDEX `drvr_second_nationality_country_id_idx` (`second_nationality_country_id` ASC) VISIBLE,
  CONSTRAINT `driver_ibfk_1`
    FOREIGN KEY (`country_of_birth_country_id`)
    REFERENCES `F1--DB`.`country` (`id`),
  CONSTRAINT `driver_ibfk_2`
    FOREIGN KEY (`nationality_country_id`)
    REFERENCES `F1--DB`.`country` (`id`),
  CONSTRAINT `driver_ibfk_3`
    FOREIGN KEY (`second_nationality_country_id`)
    REFERENCES `F1--DB`.`country` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`driver_family_relationship`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`driver_family_relationship` (
  `driver_id` VARCHAR(100) NOT NULL,
  `position_display_order` INT NOT NULL,
  `other_driver_id` VARCHAR(100) NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`driver_id`, `position_display_order`),
  UNIQUE INDEX `driver_id` (`driver_id` ASC, `other_driver_id` ASC, `type` ASC) VISIBLE,
  INDEX `dfrl_driver_id_idx` (`driver_id` ASC) VISIBLE,
  INDEX `dfrl_other_driver_id_idx` (`other_driver_id` ASC) VISIBLE,
  INDEX `dfrl_position_display_order_idx` (`position_display_order` ASC) VISIBLE,
  CONSTRAINT `driver_family_relationship_ibfk_1`
    FOREIGN KEY (`driver_id`)
    REFERENCES `F1--DB`.`driver` (`id`),
  CONSTRAINT `driver_family_relationship_ibfk_2`
    FOREIGN KEY (`other_driver_id`)
    REFERENCES `F1--DB`.`driver` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`engine_manufacturer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`engine_manufacturer` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `country_id` VARCHAR(100) NOT NULL,
  `best_championship_position` INT NULL DEFAULT NULL,
  `best_starting_grid_position` INT NULL DEFAULT NULL,
  `best_race_result` INT NULL DEFAULT NULL,
  `total_championship_wins` INT NOT NULL,
  `total_race_entries` INT NOT NULL,
  `total_race_starts` INT NOT NULL,
  `total_race_wins` INT NOT NULL,
  `total_race_laps` INT NOT NULL,
  `total_podiums` INT NOT NULL,
  `total_podium_races` INT NOT NULL,
  `total_points` DECIMAL(8,2) NOT NULL,
  `total_championship_points` DECIMAL(8,2) NOT NULL,
  `total_pole_positions` INT NOT NULL,
  `total_fastest_laps` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `enmf_country_id_idx` (`country_id` ASC) VISIBLE,
  INDEX `enmf_name_idx` (`name` ASC) VISIBLE,
  CONSTRAINT `engine_manufacturer_ibfk_1`
    FOREIGN KEY (`country_id`)
    REFERENCES `F1--DB`.`country` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`engine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`engine` (
  `id` VARCHAR(100) NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `capacity` DECIMAL(2,1) NULL DEFAULT NULL,
  `configuration` VARCHAR(100) NULL DEFAULT NULL,
  `aspiration` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `engn_aspiration_idx` (`aspiration` ASC) VISIBLE,
  INDEX `engn_capacity_idx` (`capacity` ASC) VISIBLE,
  INDEX `engn_configuration_idx` (`configuration` ASC) VISIBLE,
  INDEX `engn_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `engn_full_name_idx` (`full_name` ASC) VISIBLE,
  INDEX `engn_name_idx` (`name` ASC) VISIBLE,
  CONSTRAINT `engine_ibfk_1`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`entrant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`entrant` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `entr_name_idx` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`grand_prix`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`grand_prix` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `short_name` VARCHAR(100) NOT NULL,
  `abbreviation` VARCHAR(3) NOT NULL,
  `country_id` VARCHAR(100) NULL DEFAULT NULL,
  `total_races_held` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `grpx_abbreviation_idx` (`abbreviation` ASC) VISIBLE,
  INDEX `grpx_country_id_idx` (`country_id` ASC) VISIBLE,
  INDEX `grpx_full_name_idx` (`full_name` ASC) VISIBLE,
  INDEX `grpx_name_idx` (`name` ASC) VISIBLE,
  INDEX `grpx_short_name_idx` (`short_name` ASC) VISIBLE,
  CONSTRAINT `grand_prix_ibfk_1`
    FOREIGN KEY (`country_id`)
    REFERENCES `F1--DB`.`country` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`interactive_lap_performance_mat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`interactive_lap_performance_mat` (
  `season_year` INT NOT NULL DEFAULT '0',
  `round_number` INT NOT NULL DEFAULT '0',
  `grand_prix_name` VARCHAR(100) NOT NULL DEFAULT '',
  `circuit_name` VARCHAR(100) NOT NULL DEFAULT '',
  `session_type` VARCHAR(17) NOT NULL DEFAULT '',
  `driver_code` VARCHAR(3) NOT NULL DEFAULT '',
  `driver_full_name` VARCHAR(100) NOT NULL DEFAULT '',
  `constructor_name` VARCHAR(100) NOT NULL DEFAULT '',
  `best_lap_time` INT NULL DEFAULT NULL,
  `total_laps` INT NULL DEFAULT NULL,
  `total_time` VARCHAR(20) NULL DEFAULT NULL,
  `position` INT NULL DEFAULT NULL,
  `session_date` DATE NULL DEFAULT NULL,
  `gap_to_leader_millis` BIGINT NULL DEFAULT NULL,
  `pace_index` DECIMAL(16,2) NULL DEFAULT NULL,
  `session_delta_millis` BIGINT NULL DEFAULT NULL,
  INDEX `idx_perf_year_session_driver` (`season_year` ASC, `session_type` ASC, `driver_code` ASC) VISIBLE,
  INDEX `idx_perf_gap_pace` (`gap_to_leader_millis` ASC, `pace_index` ASC) VISIBLE,
  INDEX `idx_perf_position` (`position` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`interactive_lap_statistics_mat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`interactive_lap_statistics_mat` (
  `season_year` INT NOT NULL DEFAULT '0',
  `round_number` INT NOT NULL DEFAULT '0',
  `grand_prix_name` VARCHAR(100) NOT NULL DEFAULT '',
  `circuit_name` VARCHAR(100) NOT NULL DEFAULT '',
  `session_type` VARCHAR(17) NOT NULL DEFAULT '',
  `driver_code` VARCHAR(3) NOT NULL DEFAULT '',
  `driver_full_name` VARCHAR(100) NOT NULL DEFAULT '',
  `constructor_name` VARCHAR(100) NOT NULL DEFAULT '',
  `best_lap_time` INT NULL DEFAULT NULL,
  `total_laps` INT NULL DEFAULT NULL,
  `total_time` VARCHAR(20) NULL DEFAULT NULL,
  `position` INT NULL DEFAULT NULL,
  `session_date` DATE NULL DEFAULT NULL,
  INDEX `idx_stats_year_session` (`season_year` ASC, `session_type` ASC) VISIBLE,
  INDEX `idx_stats_driver` (`driver_code` ASC) VISIBLE,
  INDEX `idx_stats_gp_constructor` (`grand_prix_name` ASC, `constructor_name` ASC) VISIBLE,
  INDEX `idx_stats_position` (`position` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season` (
  `year` INT NOT NULL,
  PRIMARY KEY (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`race`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`race` (
  `id` INT NOT NULL,
  `year` INT NOT NULL,
  `round` INT NOT NULL,
  `date` DATE NOT NULL,
  `time` VARCHAR(5) NULL DEFAULT NULL,
  `grand_prix_id` VARCHAR(100) NOT NULL,
  `official_name` VARCHAR(100) NOT NULL,
  `qualifying_format` VARCHAR(20) NOT NULL,
  `sprint_qualifying_format` VARCHAR(20) NULL DEFAULT NULL,
  `circuit_id` VARCHAR(100) NOT NULL,
  `circuit_type` VARCHAR(6) NOT NULL,
  `direction` VARCHAR(14) NOT NULL,
  `course_length` DECIMAL(6,3) NOT NULL,
  `turns` INT NOT NULL,
  `laps` INT NOT NULL,
  `distance` DECIMAL(6,3) NOT NULL,
  `scheduled_laps` INT NULL DEFAULT NULL,
  `scheduled_distance` DECIMAL(6,3) NULL DEFAULT NULL,
  `drivers_championship_decider` TINYINT(1) NULL DEFAULT NULL,
  `constructors_championship_decider` TINYINT(1) NULL DEFAULT NULL,
  `pre_qualifying_date` DATE NULL DEFAULT NULL,
  `pre_qualifying_time` VARCHAR(5) NULL DEFAULT NULL,
  `free_practice_1_date` DATE NULL DEFAULT NULL,
  `free_practice_1_time` VARCHAR(5) NULL DEFAULT NULL,
  `free_practice_2_date` DATE NULL DEFAULT NULL,
  `free_practice_2_time` VARCHAR(5) NULL DEFAULT NULL,
  `free_practice_3_date` DATE NULL DEFAULT NULL,
  `free_practice_3_time` VARCHAR(5) NULL DEFAULT NULL,
  `free_practice_4_date` DATE NULL DEFAULT NULL,
  `free_practice_4_time` VARCHAR(5) NULL DEFAULT NULL,
  `qualifying_1_date` DATE NULL DEFAULT NULL,
  `qualifying_1_time` VARCHAR(5) NULL DEFAULT NULL,
  `qualifying_2_date` DATE NULL DEFAULT NULL,
  `qualifying_2_time` VARCHAR(5) NULL DEFAULT NULL,
  `qualifying_date` DATE NULL DEFAULT NULL,
  `qualifying_time` VARCHAR(5) NULL DEFAULT NULL,
  `sprint_qualifying_date` DATE NULL DEFAULT NULL,
  `sprint_qualifying_time` VARCHAR(5) NULL DEFAULT NULL,
  `sprint_race_date` DATE NULL DEFAULT NULL,
  `sprint_race_time` VARCHAR(5) NULL DEFAULT NULL,
  `warming_up_date` DATE NULL DEFAULT NULL,
  `warming_up_time` VARCHAR(5) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `year` (`year` ASC, `round` ASC) VISIBLE,
  INDEX `race_circuit_id_idx` (`circuit_id` ASC) VISIBLE,
  INDEX `race_circuit_type_idx` (`circuit_type` ASC) VISIBLE,
  INDEX `race_date_idx` (`date` ASC) VISIBLE,
  INDEX `race_direction_idx` (`direction` ASC) VISIBLE,
  INDEX `race_grand_prix_id_idx` (`grand_prix_id` ASC) VISIBLE,
  INDEX `race_official_name_idx` (`official_name` ASC) VISIBLE,
  INDEX `race_qualifying_format_idx` (`qualifying_format` ASC) VISIBLE,
  INDEX `race_round_idx` (`round` ASC) VISIBLE,
  INDEX `race_sprint_qualifying_format_idx` (`sprint_qualifying_format` ASC) VISIBLE,
  INDEX `race_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `race_ibfk_1`
    FOREIGN KEY (`circuit_id`)
    REFERENCES `F1--DB`.`circuit` (`id`),
  CONSTRAINT `race_ibfk_2`
    FOREIGN KEY (`grand_prix_id`)
    REFERENCES `F1--DB`.`grand_prix` (`id`),
  CONSTRAINT `race_ibfk_3`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`race_constructor_standing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`race_constructor_standing` (
  `race_id` INT NOT NULL,
  `position_display_order` INT NOT NULL,
  `position_number` INT NULL DEFAULT NULL,
  `position_text` VARCHAR(4) NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  `points` DECIMAL(8,2) NOT NULL,
  `positions_gained` INT NULL DEFAULT NULL,
  PRIMARY KEY (`race_id`, `position_display_order`),
  INDEX `rccs_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `rccs_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `rccs_position_display_order_idx` (`position_display_order` ASC) VISIBLE,
  INDEX `rccs_position_number_idx` (`position_number` ASC) VISIBLE,
  INDEX `rccs_position_text_idx` (`position_text` ASC) VISIBLE,
  INDEX `rccs_race_id_idx` (`race_id` ASC) VISIBLE,
  CONSTRAINT `race_constructor_standing_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `race_constructor_standing_ibfk_2`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`),
  CONSTRAINT `race_constructor_standing_ibfk_3`
    FOREIGN KEY (`race_id`)
    REFERENCES `F1--DB`.`race` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`tyre_manufacturer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`tyre_manufacturer` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `country_id` VARCHAR(100) NOT NULL,
  `best_starting_grid_position` INT NULL DEFAULT NULL,
  `best_race_result` INT NULL DEFAULT NULL,
  `total_race_entries` INT NOT NULL,
  `total_race_starts` INT NOT NULL,
  `total_race_wins` INT NOT NULL,
  `total_race_laps` INT NOT NULL,
  `total_podiums` INT NOT NULL,
  `total_podium_races` INT NOT NULL,
  `total_pole_positions` INT NOT NULL,
  `total_fastest_laps` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `tymf_country_id_idx` (`country_id` ASC) VISIBLE,
  INDEX `tymf_name_idx` (`name` ASC) VISIBLE,
  CONSTRAINT `tyre_manufacturer_ibfk_1`
    FOREIGN KEY (`country_id`)
    REFERENCES `F1--DB`.`country` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`race_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`race_data` (
  `race_id` INT NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  `position_display_order` INT NOT NULL,
  `position_number` INT NULL DEFAULT NULL,
  `position_text` VARCHAR(4) NOT NULL,
  `driver_number` VARCHAR(3) NOT NULL,
  `driver_id` VARCHAR(100) NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  `tyre_manufacturer_id` VARCHAR(100) NOT NULL,
  `practice_time` VARCHAR(20) NULL DEFAULT NULL,
  `practice_time_millis` INT NULL DEFAULT NULL,
  `practice_gap` VARCHAR(20) NULL DEFAULT NULL,
  `practice_gap_millis` INT NULL DEFAULT NULL,
  `practice_interval` VARCHAR(20) NULL DEFAULT NULL,
  `practice_interval_millis` INT NULL DEFAULT NULL,
  `practice_laps` INT NULL DEFAULT NULL,
  `qualifying_time` VARCHAR(20) NULL DEFAULT NULL,
  `qualifying_time_millis` INT NULL DEFAULT NULL,
  `qualifying_q1` VARCHAR(20) NULL DEFAULT NULL,
  `qualifying_q1_millis` INT NULL DEFAULT NULL,
  `qualifying_q2` VARCHAR(20) NULL DEFAULT NULL,
  `qualifying_q2_millis` INT NULL DEFAULT NULL,
  `qualifying_q3` VARCHAR(20) NULL DEFAULT NULL,
  `qualifying_q3_millis` INT NULL DEFAULT NULL,
  `qualifying_gap` VARCHAR(20) NULL DEFAULT NULL,
  `qualifying_gap_millis` INT NULL DEFAULT NULL,
  `qualifying_interval` VARCHAR(20) NULL DEFAULT NULL,
  `qualifying_interval_millis` INT NULL DEFAULT NULL,
  `qualifying_laps` INT NULL DEFAULT NULL,
  `starting_grid_position_qualification_position_number` INT NULL DEFAULT NULL,
  `starting_grid_position_qualification_position_text` VARCHAR(4) NULL DEFAULT NULL,
  `starting_grid_position_grid_penalty` VARCHAR(20) NULL DEFAULT NULL,
  `starting_grid_position_grid_penalty_positions` INT NULL DEFAULT NULL,
  `starting_grid_position_time` VARCHAR(20) NULL DEFAULT NULL,
  `starting_grid_position_time_millis` INT NULL DEFAULT NULL,
  `race_shared_car` TINYINT(1) NULL DEFAULT NULL,
  `race_laps` INT NULL DEFAULT NULL,
  `race_time` VARCHAR(20) NULL DEFAULT NULL,
  `race_time_millis` INT NULL DEFAULT NULL,
  `race_time_penalty` VARCHAR(20) NULL DEFAULT NULL,
  `race_time_penalty_millis` INT NULL DEFAULT NULL,
  `race_gap` VARCHAR(20) NULL DEFAULT NULL,
  `race_gap_millis` INT NULL DEFAULT NULL,
  `race_gap_laps` INT NULL DEFAULT NULL,
  `race_interval` VARCHAR(20) NULL DEFAULT NULL,
  `race_interval_millis` INT NULL DEFAULT NULL,
  `race_reason_retired` VARCHAR(100) NULL DEFAULT NULL,
  `race_points` DECIMAL(8,2) NULL DEFAULT NULL,
  `race_pole_position` TINYINT(1) NULL DEFAULT NULL,
  `race_qualification_position_number` INT NULL DEFAULT NULL,
  `race_qualification_position_text` VARCHAR(4) NULL DEFAULT NULL,
  `race_grid_position_number` INT NULL DEFAULT NULL,
  `race_grid_position_text` VARCHAR(2) NULL DEFAULT NULL,
  `race_positions_gained` INT NULL DEFAULT NULL,
  `race_pit_stops` INT NULL DEFAULT NULL,
  `race_fastest_lap` TINYINT(1) NULL DEFAULT NULL,
  `race_driver_of_the_day` TINYINT(1) NULL DEFAULT NULL,
  `race_grand_slam` TINYINT(1) NULL DEFAULT NULL,
  `fastest_lap_lap` INT NULL DEFAULT NULL,
  `fastest_lap_time` VARCHAR(20) NULL DEFAULT NULL,
  `fastest_lap_time_millis` INT NULL DEFAULT NULL,
  `fastest_lap_gap` VARCHAR(20) NULL DEFAULT NULL,
  `fastest_lap_gap_millis` INT NULL DEFAULT NULL,
  `fastest_lap_interval` VARCHAR(20) NULL DEFAULT NULL,
  `fastest_lap_interval_millis` INT NULL DEFAULT NULL,
  `pit_stop_stop` INT NULL DEFAULT NULL,
  `pit_stop_lap` INT NULL DEFAULT NULL,
  `pit_stop_time` VARCHAR(20) NULL DEFAULT NULL,
  `pit_stop_time_millis` INT NULL DEFAULT NULL,
  `driver_of_the_day_percentage` DECIMAL(4,1) NULL DEFAULT NULL,
  PRIMARY KEY (`race_id`, `type`, `position_display_order`),
  INDEX `rcda_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `rcda_driver_id_idx` (`driver_id` ASC) VISIBLE,
  INDEX `rcda_driver_number_idx` (`driver_number` ASC) VISIBLE,
  INDEX `rcda_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `rcda_position_display_order_idx` (`position_display_order` ASC) VISIBLE,
  INDEX `rcda_position_number_idx` (`position_number` ASC) VISIBLE,
  INDEX `rcda_position_text_idx` (`position_text` ASC) VISIBLE,
  INDEX `rcda_race_id_idx` (`race_id` ASC) VISIBLE,
  INDEX `rcda_type_idx` (`type` ASC) VISIBLE,
  INDEX `rcda_tyre_manufacturer_id_idx` (`tyre_manufacturer_id` ASC) VISIBLE,
  CONSTRAINT `race_data_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `race_data_ibfk_2`
    FOREIGN KEY (`driver_id`)
    REFERENCES `F1--DB`.`driver` (`id`),
  CONSTRAINT `race_data_ibfk_3`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`),
  CONSTRAINT `race_data_ibfk_4`
    FOREIGN KEY (`race_id`)
    REFERENCES `F1--DB`.`race` (`id`),
  CONSTRAINT `race_data_ibfk_5`
    FOREIGN KEY (`tyre_manufacturer_id`)
    REFERENCES `F1--DB`.`tyre_manufacturer` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`race_driver_standing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`race_driver_standing` (
  `race_id` INT NOT NULL,
  `position_display_order` INT NOT NULL,
  `position_number` INT NULL DEFAULT NULL,
  `position_text` VARCHAR(4) NOT NULL,
  `driver_id` VARCHAR(100) NOT NULL,
  `points` DECIMAL(8,2) NOT NULL,
  `positions_gained` INT NULL DEFAULT NULL,
  PRIMARY KEY (`race_id`, `position_display_order`),
  INDEX `rcds_driver_id_idx` (`driver_id` ASC) VISIBLE,
  INDEX `rcds_position_display_order_idx` (`position_display_order` ASC) VISIBLE,
  INDEX `rcds_position_number_idx` (`position_number` ASC) VISIBLE,
  INDEX `rcds_position_text_idx` (`position_text` ASC) VISIBLE,
  INDEX `rcds_race_id_idx` (`race_id` ASC) VISIBLE,
  CONSTRAINT `race_driver_standing_ibfk_1`
    FOREIGN KEY (`driver_id`)
    REFERENCES `F1--DB`.`driver` (`id`),
  CONSTRAINT `race_driver_standing_ibfk_2`
    FOREIGN KEY (`race_id`)
    REFERENCES `F1--DB`.`race` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_constructor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_constructor` (
  `year` INT NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `position_number` INT NULL DEFAULT NULL,
  `position_text` VARCHAR(4) NULL DEFAULT NULL,
  `best_starting_grid_position` INT NULL DEFAULT NULL,
  `best_race_result` INT NULL DEFAULT NULL,
  `total_race_entries` INT NOT NULL,
  `total_race_starts` INT NOT NULL,
  `total_race_wins` INT NOT NULL,
  `total_1_and_2_finishes` INT NOT NULL,
  `total_race_laps` INT NOT NULL,
  `total_podiums` INT NOT NULL,
  `total_podium_races` INT NOT NULL,
  `total_points` DECIMAL(8,2) NOT NULL,
  `total_pole_positions` INT NOT NULL,
  `total_fastest_laps` INT NOT NULL,
  PRIMARY KEY (`year`, `constructor_id`),
  INDEX `sscn_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `sscn_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_constructor_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `season_constructor_ibfk_2`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_constructor_standing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_constructor_standing` (
  `year` INT NOT NULL,
  `position_display_order` INT NOT NULL,
  `position_number` INT NULL DEFAULT NULL,
  `position_text` VARCHAR(4) NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  `points` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`year`, `position_display_order`),
  INDEX `sscs_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `sscs_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `sscs_position_display_order_idx` (`position_display_order` ASC) VISIBLE,
  INDEX `sscs_position_number_idx` (`position_number` ASC) VISIBLE,
  INDEX `sscs_position_text_idx` (`position_text` ASC) VISIBLE,
  INDEX `sscs_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_constructor_standing_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `season_constructor_standing_ibfk_2`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`),
  CONSTRAINT `season_constructor_standing_ibfk_3`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_driver`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_driver` (
  `year` INT NOT NULL,
  `driver_id` VARCHAR(100) NOT NULL,
  `position_number` INT NULL DEFAULT NULL,
  `position_text` VARCHAR(4) NULL DEFAULT NULL,
  `best_starting_grid_position` INT NULL DEFAULT NULL,
  `best_race_result` INT NULL DEFAULT NULL,
  `total_race_entries` INT NOT NULL,
  `total_race_starts` INT NOT NULL,
  `total_race_wins` INT NOT NULL,
  `total_race_laps` INT NOT NULL,
  `total_podiums` INT NOT NULL,
  `total_points` DECIMAL(8,2) NOT NULL,
  `total_pole_positions` INT NOT NULL,
  `total_fastest_laps` INT NOT NULL,
  `total_driver_of_the_day` INT NOT NULL,
  `total_grand_slams` INT NOT NULL,
  PRIMARY KEY (`year`, `driver_id`),
  INDEX `ssdr_driver_id_idx` (`driver_id` ASC) VISIBLE,
  INDEX `ssdr_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_driver_ibfk_1`
    FOREIGN KEY (`driver_id`)
    REFERENCES `F1--DB`.`driver` (`id`),
  CONSTRAINT `season_driver_ibfk_2`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_driver_standing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_driver_standing` (
  `year` INT NOT NULL,
  `position_display_order` INT NOT NULL,
  `position_number` INT NULL DEFAULT NULL,
  `position_text` VARCHAR(4) NOT NULL,
  `driver_id` VARCHAR(100) NOT NULL,
  `points` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`year`, `position_display_order`),
  INDEX `ssds_driver_id_idx` (`driver_id` ASC) VISIBLE,
  INDEX `ssds_position_display_order_idx` (`position_display_order` ASC) VISIBLE,
  INDEX `ssds_position_number_idx` (`position_number` ASC) VISIBLE,
  INDEX `ssds_position_text_idx` (`position_text` ASC) VISIBLE,
  INDEX `ssds_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_driver_standing_ibfk_1`
    FOREIGN KEY (`driver_id`)
    REFERENCES `F1--DB`.`driver` (`id`),
  CONSTRAINT `season_driver_standing_ibfk_2`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_engine_manufacturer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_engine_manufacturer` (
  `year` INT NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  `position_number` INT NULL DEFAULT NULL,
  `position_text` VARCHAR(4) NULL DEFAULT NULL,
  `best_starting_grid_position` INT NULL DEFAULT NULL,
  `best_race_result` INT NULL DEFAULT NULL,
  `total_race_entries` INT NOT NULL,
  `total_race_starts` INT NOT NULL,
  `total_race_wins` INT NOT NULL,
  `total_race_laps` INT NOT NULL,
  `total_podiums` INT NOT NULL,
  `total_podium_races` INT NOT NULL,
  `total_points` DECIMAL(8,2) NOT NULL,
  `total_pole_positions` INT NOT NULL,
  `total_fastest_laps` INT NOT NULL,
  PRIMARY KEY (`year`, `engine_manufacturer_id`),
  INDEX `ssem_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `ssem_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_engine_manufacturer_ibfk_1`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`),
  CONSTRAINT `season_engine_manufacturer_ibfk_2`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_entrant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_entrant` (
  `year` INT NOT NULL,
  `entrant_id` VARCHAR(100) NOT NULL,
  `country_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`year`, `entrant_id`),
  INDEX `sent_country_id_idx` (`country_id` ASC) VISIBLE,
  INDEX `sent_entrant_id_idx` (`entrant_id` ASC) VISIBLE,
  INDEX `sent_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_entrant_ibfk_1`
    FOREIGN KEY (`country_id`)
    REFERENCES `F1--DB`.`country` (`id`),
  CONSTRAINT `season_entrant_ibfk_2`
    FOREIGN KEY (`entrant_id`)
    REFERENCES `F1--DB`.`entrant` (`id`),
  CONSTRAINT `season_entrant_ibfk_3`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_entrant_chassis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_entrant_chassis` (
  `year` INT NOT NULL,
  `entrant_id` VARCHAR(100) NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  `chassis_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`year`, `entrant_id`, `constructor_id`, `engine_manufacturer_id`, `chassis_id`),
  INDEX `sech_chassis_id_idx` (`chassis_id` ASC) VISIBLE,
  INDEX `sech_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `sech_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `sech_entrant_id_idx` (`entrant_id` ASC) VISIBLE,
  INDEX `sech_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_entrant_chassis_ibfk_1`
    FOREIGN KEY (`chassis_id`)
    REFERENCES `F1--DB`.`chassis` (`id`),
  CONSTRAINT `season_entrant_chassis_ibfk_2`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `season_entrant_chassis_ibfk_3`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`),
  CONSTRAINT `season_entrant_chassis_ibfk_4`
    FOREIGN KEY (`entrant_id`)
    REFERENCES `F1--DB`.`entrant` (`id`),
  CONSTRAINT `season_entrant_chassis_ibfk_5`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_entrant_constructor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_entrant_constructor` (
  `year` INT NOT NULL,
  `entrant_id` VARCHAR(100) NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`year`, `entrant_id`, `constructor_id`, `engine_manufacturer_id`),
  INDEX `secn_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `secn_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `secn_entrant_id_idx` (`entrant_id` ASC) VISIBLE,
  INDEX `secn_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_entrant_constructor_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `season_entrant_constructor_ibfk_2`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`),
  CONSTRAINT `season_entrant_constructor_ibfk_3`
    FOREIGN KEY (`entrant_id`)
    REFERENCES `F1--DB`.`entrant` (`id`),
  CONSTRAINT `season_entrant_constructor_ibfk_4`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_entrant_driver`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_entrant_driver` (
  `year` INT NOT NULL,
  `entrant_id` VARCHAR(100) NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  `driver_id` VARCHAR(100) NOT NULL,
  `rounds` VARCHAR(100) NULL DEFAULT NULL,
  `rounds_text` VARCHAR(100) NULL DEFAULT NULL,
  `test_driver` TINYINT(1) NOT NULL,
  PRIMARY KEY (`year`, `entrant_id`, `constructor_id`, `engine_manufacturer_id`, `driver_id`),
  INDEX `sedr_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `sedr_driver_id_idx` (`driver_id` ASC) VISIBLE,
  INDEX `sedr_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `sedr_entrant_id_idx` (`entrant_id` ASC) VISIBLE,
  INDEX `sedr_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_entrant_driver_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `season_entrant_driver_ibfk_2`
    FOREIGN KEY (`driver_id`)
    REFERENCES `F1--DB`.`driver` (`id`),
  CONSTRAINT `season_entrant_driver_ibfk_3`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`),
  CONSTRAINT `season_entrant_driver_ibfk_4`
    FOREIGN KEY (`entrant_id`)
    REFERENCES `F1--DB`.`entrant` (`id`),
  CONSTRAINT `season_entrant_driver_ibfk_5`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_entrant_engine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_entrant_engine` (
  `year` INT NOT NULL,
  `entrant_id` VARCHAR(100) NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  `engine_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`year`, `entrant_id`, `constructor_id`, `engine_manufacturer_id`, `engine_id`),
  INDEX `seen_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `seen_engine_id_idx` (`engine_id` ASC) VISIBLE,
  INDEX `seen_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `seen_entrant_id_idx` (`entrant_id` ASC) VISIBLE,
  INDEX `seen_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_entrant_engine_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `season_entrant_engine_ibfk_2`
    FOREIGN KEY (`engine_id`)
    REFERENCES `F1--DB`.`engine` (`id`),
  CONSTRAINT `season_entrant_engine_ibfk_3`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`),
  CONSTRAINT `season_entrant_engine_ibfk_4`
    FOREIGN KEY (`entrant_id`)
    REFERENCES `F1--DB`.`entrant` (`id`),
  CONSTRAINT `season_entrant_engine_ibfk_5`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_entrant_tyre_manufacturer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_entrant_tyre_manufacturer` (
  `year` INT NOT NULL,
  `entrant_id` VARCHAR(100) NOT NULL,
  `constructor_id` VARCHAR(100) NOT NULL,
  `engine_manufacturer_id` VARCHAR(100) NOT NULL,
  `tyre_manufacturer_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`year`, `entrant_id`, `constructor_id`, `engine_manufacturer_id`, `tyre_manufacturer_id`),
  INDEX `setm_constructor_id_idx` (`constructor_id` ASC) VISIBLE,
  INDEX `setm_engine_manufacturer_id_idx` (`engine_manufacturer_id` ASC) VISIBLE,
  INDEX `setm_entrant_id_idx` (`entrant_id` ASC) VISIBLE,
  INDEX `setm_tyre_manufacturer_id_idx` (`tyre_manufacturer_id` ASC) VISIBLE,
  INDEX `setm_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_entrant_tyre_manufacturer_ibfk_1`
    FOREIGN KEY (`constructor_id`)
    REFERENCES `F1--DB`.`constructor` (`id`),
  CONSTRAINT `season_entrant_tyre_manufacturer_ibfk_2`
    FOREIGN KEY (`engine_manufacturer_id`)
    REFERENCES `F1--DB`.`engine_manufacturer` (`id`),
  CONSTRAINT `season_entrant_tyre_manufacturer_ibfk_3`
    FOREIGN KEY (`entrant_id`)
    REFERENCES `F1--DB`.`entrant` (`id`),
  CONSTRAINT `season_entrant_tyre_manufacturer_ibfk_4`
    FOREIGN KEY (`tyre_manufacturer_id`)
    REFERENCES `F1--DB`.`tyre_manufacturer` (`id`),
  CONSTRAINT `season_entrant_tyre_manufacturer_ibfk_5`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `F1--DB`.`season_tyre_manufacturer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`season_tyre_manufacturer` (
  `year` INT NOT NULL,
  `tyre_manufacturer_id` VARCHAR(100) NOT NULL,
  `best_starting_grid_position` INT NULL DEFAULT NULL,
  `best_race_result` INT NULL DEFAULT NULL,
  `total_race_entries` INT NOT NULL,
  `total_race_starts` INT NOT NULL,
  `total_race_wins` INT NOT NULL,
  `total_race_laps` INT NOT NULL,
  `total_podiums` INT NOT NULL,
  `total_podium_races` INT NOT NULL,
  `total_pole_positions` INT NOT NULL,
  `total_fastest_laps` INT NOT NULL,
  PRIMARY KEY (`year`, `tyre_manufacturer_id`),
  INDEX `sstm_tyre_manufacturer_id_idx` (`tyre_manufacturer_id` ASC) VISIBLE,
  INDEX `sstm_year_idx` (`year` ASC) VISIBLE,
  CONSTRAINT `season_tyre_manufacturer_ibfk_1`
    FOREIGN KEY (`tyre_manufacturer_id`)
    REFERENCES `F1--DB`.`tyre_manufacturer` (`id`),
  CONSTRAINT `season_tyre_manufacturer_ibfk_2`
    FOREIGN KEY (`year`)
    REFERENCES `F1--DB`.`season` (`year`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `F1--DB` ;

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`driver_of_the_day_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`driver_of_the_day_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `percentage` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`fastest_lap`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`fastest_lap` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `lap` INT, `time` INT, `time_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`free_practice_1_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`free_practice_1_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`free_practice_2_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`free_practice_2_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`free_practice_3_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`free_practice_3_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`free_practice_4_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`free_practice_4_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`pit_stop`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`pit_stop` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `stop` INT, `lap` INT, `time` INT, `time_millis` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`pre_qualifying_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`pre_qualifying_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`qualifying_1_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`qualifying_1_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`qualifying_2_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`qualifying_2_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`qualifying_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`qualifying_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `q1` INT, `q1_millis` INT, `q2` INT, `q2_millis` INT, `q3` INT, `q3_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`race_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`race_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `shared_car` INT, `laps` INT, `time` INT, `time_millis` INT, `time_penalty` INT, `time_penalty_millis` INT, `gap` INT, `gap_millis` INT, `gap_laps` INT, `interval` INT, `interval_millis` INT, `reason_retired` INT, `points` INT, `pole_position` INT, `qualification_position_number` INT, `qualification_position_text` INT, `grid_position_number` INT, `grid_position_text` INT, `positions_gained` INT, `pit_stops` INT, `fastest_lap` INT, `driver_of_the_day` INT, `grand_slam` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`sprint_qualifying_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`sprint_qualifying_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `q1` INT, `q1_millis` INT, `q2` INT, `q2_millis` INT, `q3` INT, `q3_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`sprint_race_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`sprint_race_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `laps` INT, `time` INT, `time_millis` INT, `time_penalty` INT, `time_penalty_millis` INT, `gap` INT, `gap_millis` INT, `gap_laps` INT, `interval` INT, `interval_millis` INT, `reason_retired` INT, `points` INT, `qualification_position_number` INT, `qualification_position_text` INT, `grid_position_number` INT, `grid_position_text` INT, `positions_gained` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`sprint_starting_grid_position`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`sprint_starting_grid_position` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `qualification_position_number` INT, `qualification_position_text` INT, `grid_penalty` INT, `grid_penalty_positions` INT, `time` INT, `time_millis` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`starting_grid_position`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`starting_grid_position` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `qualification_position_number` INT, `qualification_position_text` INT, `grid_penalty` INT, `grid_penalty_positions` INT, `time` INT, `time_millis` INT);

-- -----------------------------------------------------
-- Placeholder table for view `F1--DB`.`warming_up_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `F1--DB`.`warming_up_result` (`race_id` INT, `position_display_order` INT, `position_number` INT, `position_text` INT, `driver_number` INT, `driver_id` INT, `constructor_id` INT, `engine_manufacturer_id` INT, `tyre_manufacturer_id` INT, `time` INT, `time_millis` INT, `gap` INT, `gap_millis` INT, `interval` INT, `interval_millis` INT, `laps` INT);

-- -----------------------------------------------------
-- View `F1--DB`.`driver_of_the_day_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`driver_of_the_day_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`driver_of_the_day_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`percentage`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`driver_of_the_day_percentage` AS `percentage` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'DRIVER_OF_THE_DAY_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`fastest_lap`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`fastest_lap`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`fastest_lap` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`lap`,`time`,`time_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`fastest_lap_lap` AS `lap`,`F1--DB`.`race_data`.`fastest_lap_time` AS `time`,`F1--DB`.`race_data`.`fastest_lap_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`fastest_lap_gap` AS `gap`,`F1--DB`.`race_data`.`fastest_lap_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`fastest_lap_interval` AS `interval`,`F1--DB`.`race_data`.`fastest_lap_interval_millis` AS `interval_millis` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'FASTEST_LAP');

-- -----------------------------------------------------
-- View `F1--DB`.`free_practice_1_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`free_practice_1_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`free_practice_1_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`practice_time` AS `time`,`F1--DB`.`race_data`.`practice_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`practice_gap` AS `gap`,`F1--DB`.`race_data`.`practice_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`practice_interval` AS `interval`,`F1--DB`.`race_data`.`practice_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`practice_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'FREE_PRACTICE_1_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`free_practice_2_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`free_practice_2_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`free_practice_2_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`practice_time` AS `time`,`F1--DB`.`race_data`.`practice_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`practice_gap` AS `gap`,`F1--DB`.`race_data`.`practice_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`practice_interval` AS `interval`,`F1--DB`.`race_data`.`practice_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`practice_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'FREE_PRACTICE_2_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`free_practice_3_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`free_practice_3_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`free_practice_3_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`practice_time` AS `time`,`F1--DB`.`race_data`.`practice_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`practice_gap` AS `gap`,`F1--DB`.`race_data`.`practice_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`practice_interval` AS `interval`,`F1--DB`.`race_data`.`practice_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`practice_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'FREE_PRACTICE_3_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`free_practice_4_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`free_practice_4_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`free_practice_4_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`practice_time` AS `time`,`F1--DB`.`race_data`.`practice_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`practice_gap` AS `gap`,`F1--DB`.`race_data`.`practice_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`practice_interval` AS `interval`,`F1--DB`.`race_data`.`practice_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`practice_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'FREE_PRACTICE_4_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`pit_stop`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`pit_stop`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`pit_stop` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`stop`,`lap`,`time`,`time_millis`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`pit_stop_stop` AS `stop`,`F1--DB`.`race_data`.`pit_stop_lap` AS `lap`,`F1--DB`.`race_data`.`pit_stop_time` AS `time`,`F1--DB`.`race_data`.`pit_stop_time_millis` AS `time_millis` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'PIT_STOP');

-- -----------------------------------------------------
-- View `F1--DB`.`pre_qualifying_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`pre_qualifying_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`pre_qualifying_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`qualifying_time` AS `time`,`F1--DB`.`race_data`.`qualifying_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`qualifying_gap` AS `gap`,`F1--DB`.`race_data`.`qualifying_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`qualifying_interval` AS `interval`,`F1--DB`.`race_data`.`qualifying_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`qualifying_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'PRE_QUALIFYING_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`qualifying_1_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`qualifying_1_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`qualifying_1_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`qualifying_time` AS `time`,`F1--DB`.`race_data`.`qualifying_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`qualifying_gap` AS `gap`,`F1--DB`.`race_data`.`qualifying_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`qualifying_interval` AS `interval`,`F1--DB`.`race_data`.`qualifying_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`qualifying_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'QUALIFYING_1_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`qualifying_2_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`qualifying_2_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`qualifying_2_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`qualifying_time` AS `time`,`F1--DB`.`race_data`.`qualifying_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`qualifying_gap` AS `gap`,`F1--DB`.`race_data`.`qualifying_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`qualifying_interval` AS `interval`,`F1--DB`.`race_data`.`qualifying_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`qualifying_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'QUALIFYING_2_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`qualifying_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`qualifying_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`qualifying_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`q1`,`q1_millis`,`q2`,`q2_millis`,`q3`,`q3_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`qualifying_time` AS `time`,`F1--DB`.`race_data`.`qualifying_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`qualifying_q1` AS `q1`,`F1--DB`.`race_data`.`qualifying_q1_millis` AS `q1_millis`,`F1--DB`.`race_data`.`qualifying_q2` AS `q2`,`F1--DB`.`race_data`.`qualifying_q2_millis` AS `q2_millis`,`F1--DB`.`race_data`.`qualifying_q3` AS `q3`,`F1--DB`.`race_data`.`qualifying_q3_millis` AS `q3_millis`,`F1--DB`.`race_data`.`qualifying_gap` AS `gap`,`F1--DB`.`race_data`.`qualifying_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`qualifying_interval` AS `interval`,`F1--DB`.`race_data`.`qualifying_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`qualifying_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'QUALIFYING_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`race_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`race_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`race_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`shared_car`,`laps`,`time`,`time_millis`,`time_penalty`,`time_penalty_millis`,`gap`,`gap_millis`,`gap_laps`,`interval`,`interval_millis`,`reason_retired`,`points`,`pole_position`,`qualification_position_number`,`qualification_position_text`,`grid_position_number`,`grid_position_text`,`positions_gained`,`pit_stops`,`fastest_lap`,`driver_of_the_day`,`grand_slam`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`race_shared_car` AS `shared_car`,`F1--DB`.`race_data`.`race_laps` AS `laps`,`F1--DB`.`race_data`.`race_time` AS `time`,`F1--DB`.`race_data`.`race_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`race_time_penalty` AS `time_penalty`,`F1--DB`.`race_data`.`race_time_penalty_millis` AS `time_penalty_millis`,`F1--DB`.`race_data`.`race_gap` AS `gap`,`F1--DB`.`race_data`.`race_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`race_gap_laps` AS `gap_laps`,`F1--DB`.`race_data`.`race_interval` AS `interval`,`F1--DB`.`race_data`.`race_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`race_reason_retired` AS `reason_retired`,`F1--DB`.`race_data`.`race_points` AS `points`,`F1--DB`.`race_data`.`race_pole_position` AS `pole_position`,`F1--DB`.`race_data`.`race_qualification_position_number` AS `qualification_position_number`,`F1--DB`.`race_data`.`race_qualification_position_text` AS `qualification_position_text`,`F1--DB`.`race_data`.`race_grid_position_number` AS `grid_position_number`,`F1--DB`.`race_data`.`race_grid_position_text` AS `grid_position_text`,`F1--DB`.`race_data`.`race_positions_gained` AS `positions_gained`,`F1--DB`.`race_data`.`race_pit_stops` AS `pit_stops`,`F1--DB`.`race_data`.`race_fastest_lap` AS `fastest_lap`,`F1--DB`.`race_data`.`race_driver_of_the_day` AS `driver_of_the_day`,`F1--DB`.`race_data`.`race_grand_slam` AS `grand_slam` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'RACE_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`sprint_qualifying_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`sprint_qualifying_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`sprint_qualifying_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`q1`,`q1_millis`,`q2`,`q2_millis`,`q3`,`q3_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`qualifying_time` AS `time`,`F1--DB`.`race_data`.`qualifying_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`qualifying_q1` AS `q1`,`F1--DB`.`race_data`.`qualifying_q1_millis` AS `q1_millis`,`F1--DB`.`race_data`.`qualifying_q2` AS `q2`,`F1--DB`.`race_data`.`qualifying_q2_millis` AS `q2_millis`,`F1--DB`.`race_data`.`qualifying_q3` AS `q3`,`F1--DB`.`race_data`.`qualifying_q3_millis` AS `q3_millis`,`F1--DB`.`race_data`.`qualifying_gap` AS `gap`,`F1--DB`.`race_data`.`qualifying_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`qualifying_interval` AS `interval`,`F1--DB`.`race_data`.`qualifying_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`qualifying_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'SPRINT_QUALIFYING_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`sprint_race_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`sprint_race_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`sprint_race_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`laps`,`time`,`time_millis`,`time_penalty`,`time_penalty_millis`,`gap`,`gap_millis`,`gap_laps`,`interval`,`interval_millis`,`reason_retired`,`points`,`qualification_position_number`,`qualification_position_text`,`grid_position_number`,`grid_position_text`,`positions_gained`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`race_laps` AS `laps`,`F1--DB`.`race_data`.`race_time` AS `time`,`F1--DB`.`race_data`.`race_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`race_time_penalty` AS `time_penalty`,`F1--DB`.`race_data`.`race_time_penalty_millis` AS `time_penalty_millis`,`F1--DB`.`race_data`.`race_gap` AS `gap`,`F1--DB`.`race_data`.`race_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`race_gap_laps` AS `gap_laps`,`F1--DB`.`race_data`.`race_interval` AS `interval`,`F1--DB`.`race_data`.`race_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`race_reason_retired` AS `reason_retired`,`F1--DB`.`race_data`.`race_points` AS `points`,`F1--DB`.`race_data`.`race_qualification_position_number` AS `qualification_position_number`,`F1--DB`.`race_data`.`race_qualification_position_text` AS `qualification_position_text`,`F1--DB`.`race_data`.`race_grid_position_number` AS `grid_position_number`,`F1--DB`.`race_data`.`race_grid_position_text` AS `grid_position_text`,`F1--DB`.`race_data`.`race_positions_gained` AS `positions_gained` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'SPRINT_RACE_RESULT');

-- -----------------------------------------------------
-- View `F1--DB`.`sprint_starting_grid_position`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`sprint_starting_grid_position`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`sprint_starting_grid_position` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`qualification_position_number`,`qualification_position_text`,`grid_penalty`,`grid_penalty_positions`,`time`,`time_millis`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`starting_grid_position_qualification_position_number` AS `qualification_position_number`,`F1--DB`.`race_data`.`starting_grid_position_qualification_position_text` AS `qualification_position_text`,`F1--DB`.`race_data`.`starting_grid_position_grid_penalty` AS `grid_penalty`,`F1--DB`.`race_data`.`starting_grid_position_grid_penalty_positions` AS `grid_penalty_positions`,`F1--DB`.`race_data`.`starting_grid_position_time` AS `time`,`F1--DB`.`race_data`.`starting_grid_position_time_millis` AS `time_millis` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'SPRINT_STARTING_GRID_POSITION');

-- -----------------------------------------------------
-- View `F1--DB`.`starting_grid_position`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`starting_grid_position`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`starting_grid_position` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`qualification_position_number`,`qualification_position_text`,`grid_penalty`,`grid_penalty_positions`,`time`,`time_millis`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`starting_grid_position_qualification_position_number` AS `qualification_position_number`,`F1--DB`.`race_data`.`starting_grid_position_qualification_position_text` AS `qualification_position_text`,`F1--DB`.`race_data`.`starting_grid_position_grid_penalty` AS `grid_penalty`,`F1--DB`.`race_data`.`starting_grid_position_grid_penalty_positions` AS `grid_penalty_positions`,`F1--DB`.`race_data`.`starting_grid_position_time` AS `time`,`F1--DB`.`race_data`.`starting_grid_position_time_millis` AS `time_millis` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'STARTING_GRID_POSITION');

-- -----------------------------------------------------
-- View `F1--DB`.`warming_up_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `F1--DB`.`warming_up_result`;
USE `F1--DB`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`hump-nduati`@`localhost` SQL SECURITY DEFINER VIEW `F1--DB`.`warming_up_result` (`race_id`,`position_display_order`,`position_number`,`position_text`,`driver_number`,`driver_id`,`constructor_id`,`engine_manufacturer_id`,`tyre_manufacturer_id`,`time`,`time_millis`,`gap`,`gap_millis`,`interval`,`interval_millis`,`laps`) AS select `F1--DB`.`race_data`.`race_id` AS `race_id`,`F1--DB`.`race_data`.`position_display_order` AS `position_display_order`,`F1--DB`.`race_data`.`position_number` AS `position_number`,`F1--DB`.`race_data`.`position_text` AS `position_text`,`F1--DB`.`race_data`.`driver_number` AS `driver_number`,`F1--DB`.`race_data`.`driver_id` AS `driver_id`,`F1--DB`.`race_data`.`constructor_id` AS `constructor_id`,`F1--DB`.`race_data`.`engine_manufacturer_id` AS `engine_manufacturer_id`,`F1--DB`.`race_data`.`tyre_manufacturer_id` AS `tyre_manufacturer_id`,`F1--DB`.`race_data`.`practice_time` AS `time`,`F1--DB`.`race_data`.`practice_time_millis` AS `time_millis`,`F1--DB`.`race_data`.`practice_gap` AS `gap`,`F1--DB`.`race_data`.`practice_gap_millis` AS `gap_millis`,`F1--DB`.`race_data`.`practice_interval` AS `interval`,`F1--DB`.`race_data`.`practice_interval_millis` AS `interval_millis`,`F1--DB`.`race_data`.`practice_laps` AS `laps` from `F1--DB`.`race_data` where (`F1--DB`.`race_data`.`type` = 'WARMING_UP_RESULT');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
