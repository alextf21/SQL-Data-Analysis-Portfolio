/* Beginner SQL Challenges (Foundations & Aggregations) */

-- Monthly seasonality
-- Extract which months have the highest death counts
SELECT 
  EXTRACT(month FROM Date) AS Month,
  COUNT(*) AS Deaths
FROM drug
GROUP BY Month
ORDER BY Deaths DESC

-- Yearly deaths count
-- Extract the year from Date and show the total number of deaths per year
SELECT 
  EXTRACT(year FROM Date) AS Year,
  COUNT(*) AS Deaths
FROM drug
GROUP BY Year
ORDER BY Year DESC

-- Deaths by Race
-- Pull the number of deaths per race
SELECT 
  Race,
  COUNT(*) AS Deaths
FROM drug
GROUP BY Race
ORDER BY Deaths DESC

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
    WHEN Age > 65 THEN '65+'
    END AS AgeGroup,
  COUNT(*) AS Deaths
FROM drug
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
-- For each year calculate
-- Total deaths
-- Deaths involving Fenatnyl
-- Percentage involving fentanyl
SELECT 
  EXTRACT(year FROM Date) AS Year,
  COUNT(*) AS TotalDeaths,
  COUNT(*) FILTER (WHERE Fentanyl = 'Y') AS DeathsInvolvingFentanyl,
  ROUND(
    (DeathsInvolvingFentanyl / TotalDeaths) * 100, 2) AS PctDeathsFentanyl
FROM drug
GROUP BY Year
ORDER BY Year ASC

-- Deaths by Year and Sex
-- Pull yearly death counts split by Sex, exclude nulls
SELECT 
  EXTRACT(year FROM Date) AS Year,
  Sex,
  COUNT(*) AS Deaths
FROM drug
GROUP BY Year, Sex
HAVING Sex = 'Male' OR Sex = 'Female'
ORDER BY Year ASC, Sex ASC

/* Advanced SQL Challenges (Analytics, Risk Profiling, Trend Analysis) */

-- Rolling 3-year death average
-- Compute a rolling average of total deaths by year
SELECT 
  EXTRACT(year FROM Date) AS Year,
  COUNT(*) AS Deaths,
  ROUND(AVG(Deaths) 
    OVER(ORDER BY Year ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), 2) AS Rolling3YearAverage
FROM drug
GROUP BY Year
