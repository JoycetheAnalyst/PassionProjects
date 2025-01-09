--1. Getting familar with data
--Displaying all rows to ensure all data is correctly loaded
SELECT *
FROM [Global Burden of Disease Data]
ORDER  BY 1,2


--Total number of records in dataset
SELECT COUNT (*) AS total_records
FROM [Global Burden of Disease Data];


SELECT DISTINCT country_name
FROM [Global Burden of Disease Data] 
order by Country_Name asc;
-- Insight: 187 countries are included in the data out of 195 globally

--2.Death Totals By Country
SELECT country_name, SUM (number_of_deaths) AS total_deaths
FROM [Global Burden of Disease Data]
GROUP BY country_name
ORDER BY total_deaths DESC
--Insight: India, China, U.S, Russia and Indonesia rank highest


--3. Average Death Rate by Country
SELECT country_name, AVG(death_rate_per_100_000) AS avg_death_rate 
FROM [Global Burden of Disease Data] 
GROUP BY country_name 
ORDER BY avg_death_rate DESC 

-- Insight: Mali, Sierra Leone, Guinea, Ethiopia and Liberia are top 5 highest death averages 


--4. Checking demographcs in India
 SELECT *
 FROM [Global Burden of Disease Data]
 WHERE Country_Name = 'India' AND (Sex = 'MALE' OR Sex = 'female')
 ORDER BY number_of_deaths DESC;
 -- Insights: India, 2010-2020 has the highest death number, both genders and all ages
 --Mortality rate in Males is lower than in females in India 


 --5. Average Death Rate Over Time both Globally and Region Based
 SELECT year, 
       AVG(Death_Rate_Per_100_000) AS avg_death_rate 
FROM [Global Burden of Disease Data] 
GROUP BY year
ORDER BY avg_death_rate DESC

--Insight: Average Death Rate by Year 1970 being the highest globally

--India--

 SELECT year, 
       AVG(Death_Rate_Per_100_000) AS avg_death_rate 
FROM [Global Burden of Disease Data] 
WHERE Country_Name = 'India'
GROUP BY year
ORDER BY avg_death_rate DESC;


-- Nigeria--
 SELECT year, 
       AVG(Death_Rate_Per_100_000) AS avg_death_rate 
FROM [Global Burden of Disease Data] 
WHERE Country_Name = 'Nigeria'
GROUP BY year
ORDER BY avg_death_rate DESC;

--United States--
 SELECT year, 
       AVG(Death_Rate_Per_100_000) AS avg_death_rate 
FROM [Global Burden of Disease Data] 
WHERE Country_Name = 'United States'
GROUP BY year
ORDER BY avg_death_rate DESC;
-- Insight: compared trends to see how different/similar underdeveloped and developed regions are and if they improved or worsened over time


--6. Identify most affected demographic groups globally (average)

SELECT age_group, sex,  SUM(number_of_deaths) AS total_deaths, 
    AVG(death_rate_per_100_000) AS avg_death_rate
FROM [Global Burden of Disease Data]
GROUP BY age_group, sex
ORDER BY avg_death_rate DESC; 
   
   -- United States--
SELECT age_group, sex,  SUM(number_of_deaths) AS total_deaths, 
    AVG(death_rate_per_100_000) AS avg_death_rate
FROM [Global Burden of Disease Data]
WHERE Country_Name = 'United States'
GROUP BY age_group, sex
ORDER BY avg_death_rate DESC; 

--Nigeria--
SELECT age_group, sex,  SUM(number_of_deaths) AS total_deaths, 
    AVG(death_rate_per_100_000) AS avg_death_rate
FROM [Global Burden of Disease Data]
WHERE Country_Name = 'Nigeria'
GROUP BY age_group, sex
ORDER BY avg_death_rate DESC;


--By age group

SELECT age_group, 
       SUM(number_of_deaths) AS total_deaths 
FROM [Global Burden of Disease Data] 
WHERE age_group <> 'all ages'
GROUP BY age_group 
ORDER BY total_deaths DESC;

--Insight: most vulnerable age group is 80+ years


-- by sex

SELECT sex, 
       SUM(number_of_deaths) AS total_deaths 
FROM [Global Burden of Disease Data] 
WHERE Sex <> 'both' 
GROUP BY sex
ORDER BY total_deaths DESC;



--7. Death rate average per country over time

SELECT country_name, year, SUM(number_of_deaths) AS total_deaths, 
    AVG(Death_Rate_Per_100_000) AS avg_death_rate
FROM [Global Burden of Disease Data]
GROUP BY country_name, year
ORDER BY avg_death_rate DESC;

-- 8.rolling averages from decade to decade
SELECT DISTINCT year, country_name, AVG(death_rate_per_100_000) OVER (
        PARTITION BY country_name 
        ORDER BY year
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_death_rate

FROM [Global Burden of Disease Data]
ORDER BY rolling_avg_death_rate ASC;


--9. Trying to find outliers with unusually high death rates
SELECT country_name, year, death_rate_per_100_000
FROM [Global Burden of Disease Data]
WHERE death_rate_per_100_000 > (
    SELECT AVG(death_rate_per_100_000) + 2 * STDEV(death_rate_per_100_000)
    FROM [Global Burden of Disease Data]
)
ORDER BY death_rate_per_100_000 DESC;
