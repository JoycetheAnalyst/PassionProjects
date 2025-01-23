--checking my data is complete--

SELECT TOP (1000) [Country_or_territory_name]
      ,[ISO_3_character_country_territory_code]
      ,[ISO_numeric_country_territory_code]
      ,[Region]
      ,[Year]
      ,[total_population_number]
      ,[prevalence_of_TB_per_100_000_population]
      ,[prevalence_of_TB_all_forms]
      ,[mortality_of_TB_cases_per_100_000_population]
      ,[mortality_of_TB_cases_all_forms_excluding_HIV_per_100_000_population_low_bound]
      ,[mortality_of_TB_cases_all_forms_excluding_HIV_per_100_000_population_high_bound]
      ,[number_of_deaths_from_TB_all_forms_excluding_HIV]
      ,[mortality_of_TB_cases_who_are_HIV_positive_per_100_000_population]
      ,[number_of_deaths_from_TB_in_people_who_are_HIV_positive]
      ,[Method_to_derive_mortality_estimates]
      ,[incidence_all_forms_per_100_000_population]
      ,[number_of_incident_cases_all_forms]
      ,[Method_to_derive_incidence_estimates]
      ,[HIV_in_incident_TB_percent]
      ,[incidence_of_TB_cases_who_are_HIV_positive_per_100_000_population]
      ,[incidence_of_TB_cases_who_are_HIV_positive]
      ,[Case_detection_rate_all_forms_percent]
  FROM [TB Burden Project].[dbo].[BurdenData]

  --rechecking for confirmation-- 
SELECT *
FROM [TB Burden Project].dbo.BurdenData

--checking if there is any missing values ensuring the dataset is complete and reliable--
SELECT COUNT(*) AS total_records FROM [BurdenData];

SELECT COUNT(*) AS missing_values
FROM [BurdenData]
WHERE prevalence_of_TB_per_100_000_population IS NULL 
   OR mortality_of_TB_cases_per_100_000_population IS NULL 
   OR incidence_all_forms_per_100_000_population IS NULL;

   --Key Insight going forward; some columns were saved as text instead of VARCHAR, hence a few changes to the queries and the use of CAST and VARCHAR--


SELECT DISTINCT CAST(Country_or_territory_name AS VARCHAR(MAX)) AS Country 
FROM [BurdenData]
ORDER BY Country;
--insight: includes all countries and some extra specific regions--


--Country with the most TB cases--
 
 SELECT CAST (country_or_territory_name AS VARCHAR(MAX)) AS Country,
  SUM(number_of_incident_cases_all_forms) AS total_TB_cases
FROM BurdenData
GROUP BY CAST(country_or_territory_name AS VARCHAR(MAX))
ORDER BY total_TB_cases DESC;
 --Insight: India, China, Indonesia, Nigeria, Pakistan in top 5--


--Finding the average TB mortality rate-- 
 SELECT CAST(Country_or_territory_name AS VARCHAR(MAX)) AS Country, 
       AVG(mortality_of_TB_cases_per_100_000_population) AS avg_TB_mortality_rate
FROM [BurdenData]
GROUP BY CAST(Country_or_territory_name AS VARCHAR(MAX))
ORDER BY avg_TB_mortality_rate DESC;


--Analysing TB across different regions--
SELECT CAST(Region AS VARCHAR(MAX)) AS Region, 
       AVG(prevalence_of_TB_per_100_000_population) AS avg_TB_prevalence, 
       AVG(incidence_all_forms_per_100_000_population) AS avg_TB_incidence,
       AVG(mortality_of_TB_cases_per_100_000_population) AS avg_TB_mortality
FROM [BurdenData]
GROUP BY CAST(Region AS VARCHAR(MAX))
ORDER BY avg_TB_mortality DESC;


 --TB Trend over years--
   SELECT Year, 
       SUM(number_of_incident_cases_all_forms) AS total_TB_cases
FROM [BurdenData]
GROUP BY Year
ORDER BY Year;


--Finding out average of how many TB cases are associated with HIV--
SELECT Year, 
       CAST(Country_or_territory_name AS VARCHAR(MAX)) AS Country, 
       AVG(HIV_in_incident_TB_percent) AS avg_HIV_in_TB_percent
FROM [BurdenData]
GROUP BY Year, CAST(Country_or_territory_name AS VARCHAR(MAX))
ORDER BY avg_HIV_in_TB_percent DESC;
--Swaziland and Zimbabwe are frequent--


--Comparing and Contrasting between TB and HIV--
SELECT AVG(CAST(mortality_of_TB_cases_per_100_000_population AS FLOAT)) AS avg_TB_mortality,
       AVG(CAST(incidence_of_TB_cases_who_are_HIV_positive_per_100_000_population AS FLOAT)) AS avg_HIV_related_TB
FROM [BurdenData];


--TB cases where they are HIV Positive Vs HIV Negative--
 SELECT 
    'HIV-Positive TB Cases' AS Category, 
    SUM(number_of_deaths_from_TB_in_people_who_are_HIV_positive) AS Cases
FROM BurdenData
UNION ALL
SELECT 
    'HIV-Negative TB Cases', 
    SUM(number_of_deaths_from_TB_all_forms_excluding_HIV)
FROM BurdenData;


--------------------------------------------------------------------------------------------------------------------------------------
--QUERIES END HERE--



--THIS IS JUST TO HELP PLAN MY DATA VISUALISATIONS CORRECTLY--

--1. Country with most TB cases 
SELECT CAST (country_or_territory_name AS VARCHAR(MAX)) AS Country,
  SUM(number_of_incident_cases_all_forms) AS total_TB_cases
FROM BurdenData
GROUP BY CAST(country_or_territory_name AS VARCHAR(MAX))
ORDER BY total_TB_cases DESC;

--2.  TB Trend over time
SELECT Year, 
       SUM(number_of_incident_cases_all_forms) AS total_TB_cases
FROM [BurdenData]
GROUP BY Year
ORDER BY Year;

--3. Average TB mortality rate
 SELECT CAST(Country_or_territory_name AS VARCHAR(MAX)) AS Country, 
       AVG(mortality_of_TB_cases_per_100_000_population) AS avg_TB_mortality_rate
FROM [BurdenData]
GROUP BY CAST(Country_or_territory_name AS VARCHAR(MAX))
ORDER BY avg_TB_mortality_rate DESC;

--4. Compare and Contrast between TB and HIV
SELECT AVG(CAST(mortality_of_TB_cases_per_100_000_population AS FLOAT)) AS avg_TB_mortality,
       AVG(CAST(incidence_of_TB_cases_who_are_HIV_positive_per_100_000_population AS FLOAT)) AS avg_HIV_related_TB
FROM [BurdenData];

--5. HIV Positive VS HIV Negative in TB cases
SELECT   'HIV-Positive TB Cases' AS Category, 
    SUM(number_of_deaths_from_TB_in_people_who_are_HIV_positive) AS Cases
FROM BurdenData
UNION ALL
SELECT  'HIV-Negative TB Cases', 
    SUM(number_of_deaths_from_TB_all_forms_excluding_HIV)
FROM BurdenData;
