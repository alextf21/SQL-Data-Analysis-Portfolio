/* 
  What needs to be cleaned:
  The following 5 queries will show us there are inconsistencies in the data
  or are sanity tests to prove what we do later on is correct.
*/

-- 1. There are cases where the "Manner of Death" is NULL, Pending, or mispelled.
SELECT 
  "Manner of Death",
  COUNT(*)
FROM drug
GROUP BY "Manner of Death"

-- 2. If you want to analyze Race demographics, then there are several chores to complete. There are 24 races. 
SELECT 
  Race,
  COUNT(*)
FROM drug
GROUP BY Race

-- 3. For location based analysis, there are many nulls. 
-- Additionally, there are cases where the Residence County is CT based but their residence state is not CT.
SELECT 
  EXTRACT(YEAR FROM Date) AS Year,
  "Residence County",
  "Residence State"
FROM drug
WHERE "Residence State" IS NULL 
  AND "Residence County" IS NOT NULL

-- 4. For coordinate extraction, there is incosistencies in format for each 'Geo' column
-- For example, DeathCityGeo has 2 different formats throughout the dataset
SELECT 
  ResidenceCityGeo,
  InjuryCityGeo,
  DeathCityGeo,
FROM drug
ORDER BY RANDOM()

-- 4a. We must determine a method for how to extract just the X and Y coordinates
SELECT
  DeathCityGeo,

  -- LEFT will give us values from left to right
  LEFT(DeathCityGeo, 10),

  -- RIGHT will give us values from right to left
  RIGHT(DeathCityGeo, 10),

  -- This gives us the position of a specific character
  STRPOS(DeathCityGeo, '('),

  -- SUBSTR will retirn a substring of text, we just have to provide where to start and optionally where to end
  SUBSTR(DeathCityGeo, 0, 10)

FROM drug

-- 5. Coordinates sanity testing
SELECT
  -- Total length of DeathCityGeo Coordinates
  LENGTH(SUBSTR(DeathCityGeo, STRPOS(DeathCityGeo, '(') + 1)) - 1 AS CoordinatesLength,
    
  -- STRPOS to determine how far in the '(' character is from LEFT to RIGHT
  STRPOS(DeathCityGeo, '(') + 1 AS ParStart
FROM drug


/* Beginner SQL Challenges (Foundations & Aggregations) */

  
-- Monthly seasonality
-- Extract which months have the highest death counts
SELECT 
  EXTRACT(MONTH FROM Date) AS Month,
  COUNT(*) AS Deaths
FROM drug

WHERE "Manner of Death" != 'Pending'

GROUP BY Month
ORDER BY Deaths DESC
  
-- Yearly deaths count
-- Extract the year from Date and show the total number of deaths per year
SELECT 
  EXTRACT(YEAR FROM Date) AS Year,
  COUNT(*) AS Deaths
FROM drug

WHERE "Manner of Death" != 'Pending'

GROUP BY Year
ORDER BY Year ASC

-- Age distribution
-- Bucket ages into: 
-- <25, 25-34, 35-44, 45-54, 55-64, 65+
-- Show death count per category
SELECT 
  CASE
    WHEN Age < 25 THEN '<25'
    WHEN Age BETWEEN 25 AND 34 THEN '25-34'
    WHEN Age BETWEEN 35 AND 44 THEN '35-44'
    WHEN Age BETWEEN 45 AND 54 THEN '45-54'
    WHEN Age BETWEEN 55 AND 64 THEN '55-64'
    WHEN Age >= 65 THEN '65+'
    ELSE 'Not Specified'
  END AS AgeGroup,
  COUNT(*) AS Deaths
FROM drug

-- There are 2 cases in the dataset where the Age is NULL so we are going to exclude them and also the Pending cases
WHERE Age IS NOT NULL
  AND "Cause of Death" != 'Pending'
  
GROUP BY AgeGroup
ORDER BY Deaths DESC

-- Top injury cities
-- List the top 10 Injury City values by number of deaths, exclude nulls
SELECT 
  "Injury City",
  COUNT(*) As Deaths
FROM drug
WHERE "Injury City" NOT null
GROUP BY "Injury City"
ORDER BY Deaths DESC
LIMIT 10
  

/* Intermediate SQL Challenges (Logic, Case Statements, Multi-Column Analysis) */

  
-- Fentanyl Trend
-- For each year calculate:
-- Total deaths
-- Count of deaths where fentanyl is present
-- Percentage of deaths where fentanyl is present
SELECT 
  EXTRACT(year FROM Date) AS Year,
  COUNT(*) AS "Total Deaths",
  
  COUNT(*) FILTER (WHERE Fentanyl = 'Y' OR 'y') AS "Deaths Where Fenanyl is Present",
  
  ROUND(
    (COUNT(*) FILTER (WHERE Fentanyl = 'Y' OR 'y') / COUNT(*)) * 100
  , 2) AS "Fentanyl Presence %"
  
FROM drug
GROUP BY Year
ORDER BY Year ASC

-- Deaths by Year and Sex
-- Pull yearly death counts split by Sex, exclude nulls
SELECT 
  EXTRACT(YEAR FROM Date) AS Year,
  Sex,
  COUNT(*) AS Deaths
FROM drug

WHERE "Manner of Death" != 'Pending'
GROUP BY Year, Sex

HAVING Sex = 'Male' OR Sex = 'Female'
ORDER BY Year ASC, Sex ASC

-- Create a query that outputs per year:
-- Total Deaths
-- % fentanyl detected
-- Average age
SELECT
  EXTRACT(YEAR FROM Date) AS Year,
  COUNT(*) TotalDeaths,
  
  ROUND(
    (COUNT(*) FILTER (WHERE Fentanyl = 'Y' OR 'y') / COUNT(*))  * 100
  , 2) AS FentanylDeathsPct,
  
  ROUND(AVG(Age), 0) AS Age
FROM drug

WHERE "Manner of Death" != 'Pending'
  
GROUP BY Year
ORDER BY Year ASC

-- Missing State Logic: Fill in missing values in the Residence State column. 
-- If the Residence City is in Connecticut but the State is null, programmatically assign it as CT.
SELECT 
  Age, 
  Date, 
  "Cause of Death",

  -- Assign 'CT' to state if the county is in Connecticut
  CASE
    WHEN "Residence County" IN ('LITCHFIELD', 'FAIRFIELD', 'HARTFORD', 'MIDDLESEX', 'NEW HAVEN', 'NEW LONDON', 'TOLLAND', 'WINDHAM') 
      THEN 'CT'
    ELSE "Residence State"
  END AS "Residence State",
  
  "Residence County"
FROM drug 
