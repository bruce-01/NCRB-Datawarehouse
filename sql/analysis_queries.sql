-- Most Dangerous City 
SELECT
    city,
    SUM(cases) AS total_crimes
FROM master_total_ipc_bns_sll
GROUP BY city
ORDER BY total_crimes DESC
LIMIT 10;

-- Safest Metro Cities
Select city,sum(cases) as total_crimes
From master_total_ipc_bns_sll
Group by city
order by total_crimes 
limit 10;

-- Year-over-year Crime Growth
SELECT
	year,
    sum(cases) as total_crimes
from master_total_ipc_bns_sll
group by year
order by year;

-- Highest Crime Rate Cities
Select 
	city,
    Avg(crime_rate_2024) As avg_crime_rate
From master_total_ipc_bns_sll
Group by city
order by avg_crime_rate desc
limit 10;

-- woman safety ranking
select 
	city,
    sum(cases) as crime_against_woman
from master_women_safety
group by city
order by crime_against_woman desc
limit 10;

-- Woman crime trend by year
select 
	year,
    sum(cases) as women_crimes
from master_women_safety
group by year
order by year;

-- cybercrime hotspots
select city, sum(cases) as cybercrime_cases
from master_cybercrime
group by city
order by cybercrime_cases desc
limit 10;

-- fastest growing cybercrime year
select year, sum(cases) as cybercrimecases
from master_cybercrime
group by year
order by cybercrimecases desc ;

-- economic crime leaders
select city, sum(cases) as economical_crimes
from master_economic_offences
group by city
order by economical_crimes desc
limit 10;

-- most common ipc/bns crime heads
select crime_head, sum(cases) as total_Cases
from fact_ipc_bns_crime_heads
group by crime_head
order by total_Cases desc
limit 15;

-- Most Common SLL Crime Heads
SELECT
    crime_head,
    SUM(cases) AS total_cases
FROM fact_sll_crime_heads
GROUP BY crime_head
ORDER BY total_cases DESC
LIMIT 15;

-- Highest Chargesheeting Rate Cities
SELECT
    city,
    AVG(chargesheeting_rate_2024) AS avg_chargesheeting_rate
FROM master_total_ipc_bns_sll
GROUP BY city
ORDER BY avg_chargesheeting_rate DESC
LIMIT 10;

-- Lowest Chargesheeting Rate Cities
SELECT
    city,
    AVG(chargesheeting_rate_2024) AS avg_chargesheeting_rate
FROM master_total_ipc_bns_sll
GROUP BY city
ORDER BY avg_chargesheeting_rate ASC
LIMIT 10;

-- crime against children 
SELECT
    city,
    SUM(cases) AS crimes_against_children
FROM mastered_children
GROUP BY city
ORDER BY crimes_against_children DESC
LIMIT 10;

-- Crimes Against Senior Citizens
SELECT
    city,
    SUM(cases) AS crimes_against_seniors
FROM mastered_senior
GROUP BY city
ORDER BY crimes_against_seniors DESC
LIMIT 10;

-- crime against sc/st community
-- sc 
SELECT
    city,
    SUM(cases) AS crimes_against_sc
FROM mastered_sc
GROUP BY city
ORDER BY crimes_against_sc DESC
LIMIT 10;

-- st
SELECT
    city,
    SUM(cases) AS crimes_against_st
FROM mastered_st
GROUP BY city
ORDER BY crimes_against_st DESC
LIMIT 10;

-- crime rate vs population
SELECT
    city,
    population_lakhs_2011,
    AVG(crime_rate_2024) AS avg_crime_rate
FROM master_total_ipc_bns_sll
GROUP BY city, population_lakhs_2011
ORDER BY avg_crime_rate DESC;

-- national crime summary 
SELECT
    year,
    total_incidence,
    total_crime_rate
FROM fact_national_crime_summary
ORDER BY year;