DROP TABLE IF EXISTS master_crime_warehouse;

CREATE TABLE master_crime_warehouse (

    id INT PRIMARY KEY AUTO_INCREMENT,

    year INT,

    state VARCHAR(100),

    city VARCHAR(100),

    category VARCHAR(255),

    cases BIGINT,

    crime_rate_2024 DECIMAL(10,2),

    chargesheeting_rate_2024 DECIMAL(10,2),

    crime_domain VARCHAR(100),

    victim_group VARCHAR(100),

    source_table VARCHAR(100)
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/sumitbhandari/Desktop/NCRB/cleaned data/master_crime_warehouse.csv'
INTO TABLE master_crime_warehouse
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
year,
state,
city,
category,
cases,
crime_rate_2024,
chargesheeting_rate_2024,
crime_domain,
victim_group,
source_table
);

SELECT * 
FROM master_crime_warehouse
LIMIT 10;