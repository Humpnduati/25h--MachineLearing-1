
DROP TABLE IF EXISTS interactive_lap_statistics_mat;

-- ===============================================================
-- 2. CREATE MATERIALIZED TABLE (FULL SESSION COVERAGE)
-- ===============================================================
CREATE TABLE interactive_lap_statistics_mat AS

/********************************************************************
* FREE PRACTICE 1
********************************************************************/
SELECT
    s.year AS season_year,
    r.round AS round_number,
    r.name AS race_name,
    c.name AS circuit_name,
    'FP1' AS session_type,
    d.code AS driver_code,
    CONCAT(d.forename, ' ', d.surname) AS driver_full_name,
    cons.name AS constructor_name,
    fp1.best_lap_time,
    fp1.total_laps,
    fp1.total_time,
    fp1.position,
    fp1.session_date
FROM free_practice_1_result fp1
JOIN driver d ON fp1.driver_id = d.id
JOIN constructor cons ON fp1.constructor_id = cons.id
JOIN race r ON fp1.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id

UNION ALL

/********************************************************************
* FREE PRACTICE 2
********************************************************************/
SELECT
    s.year,
    r.round,
    r.name,
    c.name,
    'FP2',
    d.code,
    CONCAT(d.forename, ' ', d.surname),
    cons.name,
    fp2.best_lap_time,
    fp2.total_laps,
    fp2.total_time,
    fp2.position,
    fp2.session_date
FROM free_practice_2_result fp2
JOIN driver d ON fp2.driver_id = d.id
JOIN constructor cons ON fp2.constructor_id = cons.id
JOIN race r ON fp2.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id

UNION ALL

/********************************************************************
* FREE PRACTICE 3
********************************************************************/
SELECT
    s.year,
    r.round,
    r.name,
    c.name,
    'FP3',
    d.code,
    CONCAT(d.forename, ' ', d.surname),
    cons.name,
    fp3.best_lap_time,
    fp3.total_laps,
    fp3.total_time,
    fp3.position,
    fp3.session_date
FROM free_practice_3_result fp3
JOIN driver d ON fp3.driver_id = d.id
JOIN constructor cons ON fp3.constructor_id = cons.id
JOIN race r ON fp3.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id

UNION ALL

/********************************************************************
* FREE PRACTICE 4
********************************************************************/
SELECT
    s.year,
    r.round,
    r.name,
    c.name,
    'FP4',
    d.code,
    CONCAT(d.forename, ' ', d.surname),
    cons.name,
    fp4.best_lap_time,
    fp4.total_laps,
    fp4.total_time,
    fp4.position,
    fp4.session_date
FROM free_practice_4_result fp4
JOIN driver d ON fp4.driver_id = d.id
JOIN constructor cons ON fp4.constructor_id = cons.id
JOIN race r ON fp4.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id

UNION ALL

/********************************************************************
* QUALIFYING 1
********************************************************************/
SELECT
    s.year,
    r.round,
    r.name,
    c.name,
    'QUALIFYING 1',
    d.code,
    CONCAT(d.forename, ' ', d.surname),
    cons.name,
    q1.best_lap_time,
    q1.total_laps,
    q1.total_time,
    q1.position,
    q1.session_date
FROM qualifying_1_result q1
JOIN driver d ON q1.driver_id = d.id
JOIN constructor cons ON q1.constructor_id = cons.id
JOIN race r ON q1.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id

UNION ALL

/********************************************************************
* QUALIFYING 2
********************************************************************/
SELECT
    s.year,
    r.round,
    r.name,
    c.name,
    'QUALIFYING 2',
    d.code,
    CONCAT(d.forename, ' ', d.surname),
    cons.name,
    q2.best_lap_time,
    q2.total_laps,
    q2.total_time,
    q2.position,
    q2.session_date
FROM qualifying_2_result q2
JOIN driver d ON q2.driver_id = d.id
JOIN constructor cons ON q2.constructor_id = cons.id
JOIN race r ON q2.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id

UNION ALL

/********************************************************************
* MAIN QUALIFYING
********************************************************************/
SELECT
    s.year,
    r.round,
    r.name,
    c.name,
    'QUALIFYING',
    d.code,
    CONCAT(d.forename, ' ', d.surname),
    cons.name,
    q.best_lap_time,
    q.total_laps,
    q.total_time,
    q.position,
    q.session_date
FROM qualifying_result q
JOIN driver d ON q.driver_id = d.id
JOIN constructor cons ON q.constructor_id = cons.id
JOIN race r ON q.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id

UNION ALL

/********************************************************************
* SPRINT QUALIFYING
********************************************************************/
SELECT
    s.year,
    r.round,
    r.name,
    c.name,
    'SPRINT QUALIFYING',
    d.code,
    CONCAT(d.forename, ' ', d.surname),
    cons.name,
    sq.best_lap_time,
    sq.total_laps,
    sq.total_time,
    sq.position,
    sq.session_date
FROM sprint_qualifying_result sq
JOIN driver d ON sq.driver_id = d.id
JOIN constructor cons ON sq.constructor_id = cons.id
JOIN race r ON sq.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id

UNION ALL

/********************************************************************
* SPRINT RACE
********************************************************************/
SELECT
    s.year,
    r.round,
    r.name,
    c.name,
    'SPRINT RACE',
    d.code,
    CONCAT(d.forename, ' ', d.surname),
    cons.name,
    sr.best_lap_time,
    sr.total_laps,
    sr.total_time,
    sr.position,
    sr.session_date
FROM sprint_race_result sr
JOIN driver d ON sr.driver_id = d.id
JOIN constructor cons ON sr.constructor_id = cons.id
JOIN race r ON sr.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id

UNION ALL

/********************************************************************
* MAIN RACE
********************************************************************/
SELECT
    s.year,
    r.round,
    r.name,
    c.name,
    'RACE',
    d.code,
    CONCAT(d.forename, ' ', d.surname),
    cons.name,
    rr.best_lap_time,
    rr.total_laps,
    rr.total_time,
    rr.position,
    rr.session_date
FROM race_result rr
JOIN driver d ON rr.driver_id = d.id
JOIN constructor cons ON rr.constructor_id = cons.id
JOIN race r ON rr.race_id = r.id
JOIN circuit c ON r.circuit_id = c.id
JOIN season s ON r.season_id = s.id;

-- ===============================================================
-- 3. PERFORMANCE INDEXES
-- ===============================================================
CREATE INDEX idx_lapstats_year_session
    ON interactive_lap_statistics_mat (season_year, session_type);
CREATE INDEX idx_lapstats_driver
    ON interactive_lap_statistics_mat (driver_code);
CREATE INDEX idx_lapstats_race_constructor
    ON interactive_lap_statistics_mat (race_name, constructor_name);
CREATE INDEX idx_lapstats_position
    ON interactive_lap_statistics_mat (position);


