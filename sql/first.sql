-- =====================================================
-- NCRB CRIME ANALYTICS WAREHOUSE
-- FINAL MYSQL SCHEMA
-- =====================================================

CREATE DATABASE IF NOT EXISTS ncrb_crime_warehouse;

USE ncrb_crime_warehouse;

-- =====================================================
-- DROP OLD TABLES
-- =====================================================

DROP TABLE IF EXISTS fact_complaint_registration;
DROP TABLE IF EXISTS fact_economic_crime_heads;
DROP TABLE IF EXISTS fact_ipc_bns_crime_heads;
DROP TABLE IF EXISTS fact_national_crime_summary;
DROP TABLE IF EXISTS fact_sll_crime_heads;

DROP TABLE IF EXISTS master_ipc_bns_crimes;
DROP TABLE IF EXISTS master_sll_crimes;
DROP TABLE IF EXISTS master_total_ipc_bns_sll;

DROP TABLE IF EXISTS mastered_children;
DROP TABLE IF EXISTS mastered_sc;
DROP TABLE IF EXISTS mastered_st;
DROP TABLE IF EXISTS mastered_senior;

DROP TABLE IF EXISTS master_cybercrime;
DROP TABLE IF EXISTS master_economic_offences;
DROP TABLE IF EXISTS master_women_safety;

-- =====================================================
-- FACT TABLES
-- =====================================================

CREATE TABLE fact_complaint_registration (
    id INT PRIMARY KEY AUTO_INCREMENT,

    type_of_complaint VARCHAR(255),

    complaints_received BIGINT,

    firs_registered BIGINT,

    online_efirs BIGINT
);

CREATE TABLE fact_economic_crime_heads (
    id INT PRIMARY KEY AUTO_INCREMENT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    crime_head VARCHAR(255),

    cases BIGINT
);

CREATE TABLE fact_ipc_bns_crime_heads (
    id INT PRIMARY KEY AUTO_INCREMENT,

    category VARCHAR(255),

    crime_head VARCHAR(255),

    year INT,

    cases BIGINT
);

CREATE TABLE fact_national_crime_summary (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    mid_year_projected_population_in_lakhs DECIMAL(12,2),

    ipc_bns_incidence BIGINT,

    sll_incidence BIGINT,

    total_incidence BIGINT,

    ipc_bns_crime_rate DECIMAL(10,2),

    sll_crime_rate DECIMAL(10,2),

    total_crime_rate DECIMAL(10,2),

    percent_of_ipc_bns_crimes_to_total_cognizable_crimes DECIMAL(10,2)
);

CREATE TABLE fact_sll_crime_heads (
    id INT PRIMARY KEY AUTO_INCREMENT,

    category VARCHAR(255),

    crime_head VARCHAR(255),

    year INT,

    cases BIGINT
);

-- =====================================================
-- MASTER TABLES
-- =====================================================

CREATE TABLE master_ipc_bns_crimes (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    population_lakhs_2011 DECIMAL(12,2),

    crime_rate_2024 DECIMAL(10,2),

    chargesheeting_rate_2024 DECIMAL(10,2)
);

CREATE TABLE master_sll_crimes (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    population_lakhs_2011 DECIMAL(12,2),

    crime_rate_2024 DECIMAL(10,2),

    chargesheeting_rate_2024 DECIMAL(10,2)
);

CREATE TABLE master_total_ipc_bns_sll (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    population_lakhs_2011 DECIMAL(12,2),

    crime_rate_2024 DECIMAL(10,2),

    chargesheeting_rate_2024 DECIMAL(10,2)
);

CREATE TABLE mastered_children (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    chargesheeting_rate_2024 DECIMAL(10,2)
);

CREATE TABLE mastered_sc (
    id INT PRIMARY KEY AUTO_INCREMENT,

    city VARCHAR(100),

    chargesheeting_rate_2024 DECIMAL(10,2),

    year INT,

    cases BIGINT,

    state VARCHAR(100),

    category VARCHAR(255)
);

CREATE TABLE mastered_st (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    chargesheeting_rate_2024 DECIMAL(10,2)
);

CREATE TABLE mastered_senior (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    chargesheeting_rate_2024 DECIMAL(10,2)
);

CREATE TABLE master_cybercrime (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    population_lakhs_2011 DECIMAL(12,2),

    crime_rate_2024 DECIMAL(10,2),

    chargesheeting_rate_2024 DECIMAL(10,2)
);

CREATE TABLE master_economic_offences (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    population_lakhs_2011 DECIMAL(12,2),

    crime_rate_2024 DECIMAL(10,2),

    chargesheeting_rate_2024 DECIMAL(10,2)
);

CREATE TABLE master_women_safety (
    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    population_lakhs_2011 DECIMAL(12,2),

    crime_rate_2024 DECIMAL(10,2),

    chargesheeting_rate_2024 DECIMAL(10,2)
);

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX idx_city_total
ON master_total_ipc_bns_sll(city);

CREATE INDEX idx_city_women
ON master_women_safety(city);

CREATE INDEX idx_city_cyber
ON master_cybercrime(city);

CREATE INDEX idx_city_economic
ON master_economic_offences(city);

CREATE INDEX idx_year_total
ON master_total_ipc_bns_sll(year);

CREATE INDEX idx_year_women
ON master_women_safety(year);

-- =====================================================
-- ANALYTICAL VIEWS
-- =====================================================

DROP VIEW IF EXISTS vw_total_crime_summary;

CREATE VIEW vw_total_crime_summary AS
SELECT
    year,
    state,
    city,
    category,
    SUM(cases) AS total_cases
FROM master_total_ipc_bns_sll
GROUP BY year, state, city, category;

DROP VIEW IF EXISTS vw_women_safety_summary;

CREATE VIEW vw_women_safety_summary AS
SELECT
    year,
    city,
    SUM(cases) AS women_crimes
FROM master_women_safety
GROUP BY year, city;

DROP VIEW IF EXISTS vw_cybercrime_summary;

CREATE VIEW vw_cybercrime_summary AS
SELECT
    year,
    city,
    SUM(cases) AS cybercrime_cases
FROM master_cybercrime
GROUP BY year, city;

DROP VIEW IF EXISTS vw_economic_offence_summary;

CREATE VIEW vw_economic_offence_summary AS
SELECT
    year,
    city,
    SUM(cases) AS economic_cases
FROM master_economic_offences
GROUP BY year, city;

SELECT * FROM master_total_ipc_bns_sll LIMIT 10;
LOAD DATA LOCAL INFILE '/Users/sumitbhandari/Desktop/NCRB/cleaned data/fact_sll_crime_heads.csv'
INTO TABLE fact_sll_crime_heads
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category, crime_head, year, cases);

SELECT * FROM fact_sll_crime_heads LIMIT 10;

SELECT COUNT(*) FROM master_total_ipc_bns_sll;

SELECT COUNT(*) FROM master_women_safety;

SELECT COUNT(*) FROM master_cybercrime;

SELECT COUNT(*) FROM master_economic_offences;

SELECT COUNT(*) FROM fact_ipc_bns_crime_heads;

SELECT COUNT(*) FROM fact_sll_crime_heads;

SELECT COUNT(*) FROM fact_national_crime_summary;

select * from fact_cybercrime;
