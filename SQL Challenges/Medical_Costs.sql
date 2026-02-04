/* Level 1 - Beginner (Foundational SQL & Aggregates) */

-- Basic Exploration
-- Return all records for policyholders who are smokers.
SELECT * FROM insurance 
WHERE smoker = 'false'

-- List distinct regions represented in the dataset.
SELECT DISTINCT(region) FROM insurance

-- Simple Aggregations
-- Compute the average, minimum, and maximum insurance charges 
-- across all policyholders.
SELECT 
AVG(charges) as Avg_Charges,
MIN(charges) as Min_Charges,
MAX(charges) as Max_Charges,
FROM insurance

-- Calculate the average charges for smokers vs. non-smokers.
SELECT smoker, 
ROUND(AVG(charges), 2) as Avg_Charges
FROM insurance
GROUP BY ALL

-- Grouped Analysis
-- Find the average insurance charges by region.
SELECT region,
ROUND(AVG(charges), 2) as Avg_Charges
FROM insurance
GROUP BY ALL 
ORDER BY Avg_Charges DESC

-- Determine the average BMI by gender.
SELECT sex,
ROUND(AVG(bmi), 2) as Avg_Bmi
FROM insurance
GROUP BY ALL

-- Filtering with Conditions
-- Identify policyholders over age 50 with more than 2 children.
SELECT * FROM insurance
WHERE age > 50 AND children > 2 

-- Return all policyholders whose BMI is above the dataset average.
SELECT * FROM insurance
WHERE bmi > (SELECT AVG(bmi) FROM insurance)

/* Level 2 — Intermediate (Analytical Grouping & Derived Metrics) */

-- Ranking & Ordering
-- Rank regions by average insurance charges (highest to lowest).
SELECT region,
ROUND(AVG(charges), 2) AS Avg_Charges
FROM insurance
GROUP BY region
ORDER BY Avg_Charges DESC 

-- Identify the top 10 most expensive individual policies.
SELECT * FROM insurance
ORDER BY charges DESC
LIMIT 10

-- Ranking & Ordering
-- Rank regions by average insurance charges (highest to lowest).
SELECT region,
ROUND(AVG(charges), 2) AS Avg_Charges
FROM insurance
GROUP BY region
ORDER BY Avg_Charges DESC 

-- Identify the top 10 most expensive individual policies.
SELECT * FROM insurance
ORDER BY charges DESC
LIMIT 10

-- Categorization with CASE
-- Create age groups (e.g., <30, 30–39, 40–49, 50-59, 60+) and compute average charges per age group.
SELECT 
  CASE 
    WHEN age < 20 THEN '<20'
    WHEN age >= 20 AND age < 30 THEN '20-29'
    WHEN age >= 30 AND age < 40 THEN '30-39'
    WHEN age >= 40 AND age < 50 THEN '40-59'
    WHEN age >= 50 AND age < 60 THEN '50-59'
    WHEN age >= 60 THEN '60+'
    ELSE 'Unkown'
  END AS 'Age',
  ROUND(AVG(charges), 2) AS Avg_Charges
  FROM insurance
  GROUP BY ALL
  ORDER BY Avg_Charges DESC

-- Categorize BMI into Underweight, Normal, Overweight, and Obese, then calculate average charges/category
-- Underweight: Below 18.5
-- Healthy Weight: 18.5 – 24.9
-- Overweight: 25.0 – 29.9
-- Obese: 30.0 or greater
SELECT 
  CASE 
    WHEN bmi < 18.5 THEN 'Underweight'
    WHEN bmi >= 18.5 AND bmi < 24.999 THEN 'Healthy Weight'
    WHEN bmi >= 25 AND bmi < 29.999 THEN 'Overweight'
    WHEN bmi >= 30 THEN 'Obese'
    ELSE 'Unknown'
  END AS Bmi_Category, 
  ROUND(AVG(charges), 2) AS Avg_Charges
  FROM insurance
  GROUP BY ALL 
  ORDER BY Avg_Charges DESC
