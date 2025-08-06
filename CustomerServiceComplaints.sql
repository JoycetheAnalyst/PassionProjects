---Hiii just reviewing some quick customer complaints for the government (DCC= Dublin City Council)

--Testing Data Import Completion-- (data is all good;)
SELECT TOP 100 * FROM DCCCustomerServiceComplaints


-- Count total incidents/complaints
SELECT COUNT(*) AS total_incidents FROM DCCCustomerServiceComplaints;
--working with 31417 complaints)


-- What types of incidents were reported?-
SELECT DISTINCT NAME AS incident_type FROM DCCCustomerServiceComplaints
--43 different categories of complaints--



--6. Status update counts
SELECT STATUS, COUNT(*) AS count
FROM DCCCustomerServiceComplaints
GROUP BY STATUS
ORDER BY count DESC;
--29876 are closed/solved, 696 are open, 611 are pending and the rest are nulled--



--1. Incidents per year
SELECT 
    YEAR(INCIDENT_DATE) AS incident_year,
    COUNT(*) AS total_incidents
FROM DCCCustomerServiceComplaints
GROUP BY YEAR(INCIDENT_DATE)
ORDER BY incident_year;
--2011 had the most complaints, then 2010,2009 and 2012--



--2.Top 10 Most Frequent Incidents--
SELECT TOP 10
    NAME AS incident_type,
    COUNT(*) AS frequency
FROM DCCCustomerServiceComplaints
GROUP BY NAME
ORDER BY frequency DESC;
--Top 3= Illegal Dumping, Sweep Your Street, and Tree Maintenance--



--3.Status by Group name--
SELECT 
    GROUP_NAME,
    STATUS,
    COUNT(*) AS total
FROM DCCCustomerServiceComplaints
GROUP BY GROUP_NAME, STATUS
ORDER BY total DESC;


--4.channel usage by year--
SELECT 
    YEAR(INCIDENT_DATE) AS year,
    SR_CREATION_CHANNEL,
    COUNT(*) AS count
FROM DCCCustomerServiceComplaints
GROUP BY YEAR(INCIDENT_DATE), SR_CREATION_CHANNEL
ORDER BY year, count DESC;
--most complaints were made through live agents; which makes sense as this was the 2009 to 2012 period--



--The Trend of Open Vs Closed Over Time--
SELECT 
    YEAR(INCIDENT_DATE) AS year,
    STATUS,
    COUNT(*) AS total
FROM DCCCustomerServiceComplaints
GROUP BY YEAR(INCIDENT_DATE), STATUS
ORDER BY year, STATUS;

--Percentage of Closed requets per group (performance analysis of the customer service employees)
SELECT 
    GROUP_NAME,
    SUM(CASE WHEN STATUS = 'CLOSED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS percent_closed
FROM DCCCustomerServiceComplaints
GROUP BY GROUP_NAME
ORDER BY percent_closed DESC;
--not a lot of the roads, traffic, recreations/amenities were solved; probably because these would take a bit longer to fix, as for the rest, they are above 90%--

--thanks for reading my script:)--
