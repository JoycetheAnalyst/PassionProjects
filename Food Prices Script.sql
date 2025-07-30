SELECT TOP (1000) [STATISTIC]
      ,[STATISTIC Label]
      ,[TLIST(M1)]
      ,[Month]
      ,[C02363V03422]
      ,[Consumer Item]
      ,[UNIT]
      ,[VALUE]
  FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
  --making sure my data has imported correctly--

  SELECT 
    COUNT(*) AS total_rows,
    COUNT([VALUE]) AS rows_with_price,
    COUNT(*) - COUNT([VALUE]) AS missing_price_count
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis];
--checking any missing values; there are none :) total rows are 12388--

SELECT [Month], [Consumer Item], [UNIT], COUNT(*) AS frequency
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
GROUP BY [Month], [Consumer Item], [UNIT]
HAVING COUNT(*) > 1;
--this query checks for any duplicate data, in which there are none as I have cleaned my data in excel; but it doesn't hurt to check again :)--

--finding the amount of entries per food item--
SELECT [Consumer Item], COUNT(*) AS entry_count
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
GROUP BY [Consumer Item]
ORDER BY entry_count DESC;





--1. AVERAGE PRICE PER FOOD ITEM--(had to use float function as numbers were uploaded as text not numeric)--
SELECT 
    [Consumer Item], 
    AVG(CAST([VALUE] AS FLOAT)) AS avg_price
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
WHERE ISNUMERIC([VALUE]) = 1
GROUP BY [Consumer Item]
ORDER BY avg_price DESC;


--2. Price Range for each food item--
SELECT 
    [Consumer Item],
    MIN(CAST([VALUE] AS FLOAT)) AS min_price,
    MAX(CAST([VALUE] AS FLOAT)) AS max_price,
    MAX(CAST([VALUE] AS FLOAT)) - MIN(CAST([VALUE] AS FLOAT)) AS price_range
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
WHERE ISNUMERIC([VALUE]) = 1
GROUP BY [Consumer Item]
ORDER BY price_range DESC;

--3.Average Price by item (yearly)
SELECT 
    LEFT([Month], 4) AS Year,
    [Consumer Item],
    AVG(CAST([VALUE] AS FLOAT)) AS avg_price
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
WHERE ISNUMERIC([VALUE]) = 1
GROUP BY LEFT([Month], 4), [Consumer Item]
ORDER BY Year, [Consumer Item];


--4.CALCULATING PRICE VOLATILITY (price fluctuations by item-)
SELECT 
    [Consumer Item],
    COUNT(*) AS data_points,
    AVG(CAST([VALUE] AS FLOAT)) AS avg_price,
    STDEV(CAST([VALUE] AS FLOAT)) AS price_stddev
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
WHERE ISNUMERIC([VALUE]) = 1
GROUP BY [Consumer Item]
ORDER BY price_stddev DESC;

--also identifies risky/price sensitive products--
SELECT 
    [Consumer Item], 
    AVG(CAST([VALUE] AS FLOAT)) AS avg_price,
    STDEV(CAST([VALUE] AS FLOAT)) AS price_volatility
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
WHERE ISNUMERIC([VALUE]) = 1
GROUP BY [Consumer Item]
ORDER BY price_volatility DESC;
--brandy bottle, smoked salmon, men's haircuts and nightclubs fee are the most sensitive items--



--5.shows short-term trend analysis to identify seasonal pricing patterns or unusual price volatility for the last 6 months--

WITH CleanedData AS (
    SELECT 
        [Consumer Item],
        TRY_CAST([VALUE] AS FLOAT) AS Price,
        TRY_CAST([Month] AS DATE) AS PriceMonth
    FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
    WHERE ISNUMERIC([VALUE]) = 1
),
LatestMonths AS (
    SELECT DISTINCT TOP 6 PriceMonth
    FROM CleanedData
    WHERE PriceMonth IS NOT NULL
    ORDER BY PriceMonth DESC
),
FilteredData AS (
    SELECT *
    FROM CleanedData
    WHERE PriceMonth IN (SELECT PriceMonth FROM LatestMonths)
)
SELECT 
    PriceMonth,
    [Consumer Item],
    AVG(Price) AS avg_price
FROM FilteredData
GROUP BY PriceMonth, [Consumer Item]
ORDER BY [Consumer Item], PriceMonth;


--6.trying to find value for money and cost efficiency( the higher the value index= the more value per currency unit--
SELECT 
    [Consumer Item], 
    AVG(CAST([VALUE] AS FLOAT)) AS avg_price,
    ROUND(1 / NULLIF(AVG(CAST([VALUE] AS FLOAT)), 0), 3) AS value_index
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
WHERE ISNUMERIC([VALUE]) = 1
GROUP BY [Consumer Item]
ORDER BY value_index DESC;
--tinned tomatoes, low fat milk and spaghetti are top 3--


--7.the avg monthly prices will be used to forecast--
SELECT 
    [Month], 
    [Consumer Item], 
    AVG(CAST([VALUE] AS FLOAT)) AS avg_monthly_price
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
WHERE ISNUMERIC([VALUE]) = 1
GROUP BY [Month], [Consumer Item]
ORDER BY [Consumer Item], [Month];


--8.to analyse any sudden price changes or anomalies--
WITH PriceStats AS (
    SELECT 
        [Consumer Item],
        AVG(CAST([VALUE] AS FLOAT)) AS avg_price,
        STDEV(CAST([VALUE] AS FLOAT)) AS stddev_price
    FROM [Food Price Project].[dbo].[FOOD PRICES Analysis]
    WHERE ISNUMERIC([VALUE]) = 1
    GROUP BY [Consumer Item]
)

SELECT 
    f.[Month],
    f.[Consumer Item],
    CAST(f.[VALUE] AS FLOAT) AS price,
    p.avg_price,
    p.stddev_price
FROM [Food Price Project].[dbo].[FOOD PRICES Analysis] f
JOIN PriceStats p ON f.[Consumer Item] = p.[Consumer Item]
WHERE ISNUMERIC(f.[VALUE]) = 1
  AND CAST(f.[VALUE] AS FLOAT) > (p.avg_price + 2 * p.stddev_price)
ORDER BY f.[Consumer Item], f.[Month];

--numbers used to mark the visualisations I need-- visualisations can be found on my tableau!