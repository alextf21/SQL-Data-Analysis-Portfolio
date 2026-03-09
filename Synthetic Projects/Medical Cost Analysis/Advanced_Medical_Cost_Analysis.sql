-- Dialect: PostgreSQL / DuckDB

-- Create a numeric risk score per policyholder based on:
-- +2 points if smoker
-- +1 point if BMI ≥ 30
-- +1 point if age ≥ 45
-- +1 point if children ≥ 2
WITH RiskScore AS (
  SELECT  *,
  
    CASE
      WHEN smoker = true THEN 2
      ELSE 0
      END AS Smoker_Points,
    
    CASE
      WHEN bmi >= 30 THEN 1
      ELSE 0
      END AS Bmi_Points,
    
    CASE 
      WHEN age >= 45 THEN 1
      ELSE 0
      END AS Age_Points,
    
    CASE 
      WHEN children >= 2 THEN 1
      ELSE 0
      END AS Children_Points,
    
    Smoker_Points + Bmi_Points + Age_Points + Children_Points AS RiskPoints
FROM insurance
)

SELECT  
  age, sex, bmi, children, smoker, region, charges, RiskPoints
FROM RiskScore
ORDER BY RiskPoints DESC

-- Compute risk score per person.
-- Bucket into risk tiers: Low (0–1), Medium (2–3), High (4–5).
-- Compute average charges per risk tier.
-- Validate monotonicity (do charges increase with risk?).
WITH RiskScore AS (
  SELECT *,
  
    CASE
      WHEN smoker = true THEN 2
      ELSE 0
      END AS Smoker_Points,
    
    CASE
      WHEN bmi >= 30 THEN 1
      ELSE 0
      END AS Bmi_Points,
    
    CASE 
      WHEN age >= 45 THEN 1
      ELSE 0
      END AS Age_Points,
    
    CASE 
      WHEN children >= 2 THEN 1
      ELSE 0
      END AS Children_Points,
    
    Smoker_Points + Bmi_Points + Age_Points + Children_Points AS RiskPoints

  FROM insurance
)

SELECT 
  RiskPoints,
  ROUND(AVG(charges), 2) AS Avg_Charges
FROM RiskScore
GROUP BY RiskPoints

ORDER BY Avg_Charges DESC

-- The Regional Top Tier
-- Task: For each region, find the top 5 individuals with the highest charges
-- Output the region, age, bmi, charges and their rank within the region
-- Only include individuals who have a BMI higher than the global average

WITH Ranked AS (
  SELECT
    region,
    age,
    bmi,
    charges,
  
    RANK() OVER(
      PARTITION BY region
      ORDER BY charges DESC
      ) AS rank
  FROM insurance
  WHERE bmi > (SELECT AVG(bmi) FROM insurance)
)

SELECT *
FROM Ranked
WHERE rank <= 5

-- The Smoking Premium Gap
-- Task: Create a report that compares the cost of smoking across regions
-- The final output should have 1 row per region
-- Include a column for average_smoker_charges and average_non_smoker_charges
-- Include a third column called smoking_premium which is the difference of the 2
-- Twist: Use a CTE to calculate the averages first, then format final output'

WITH RegionalAverages AS (
  SELECT 
    region,
    AVG(charges) AS avg_charges,
    AVG(charges) FILTER (WHERE smoker = 'false') AS avg_non_smoker_charges,
    AVG(charges) FILTER (WHERE smoker = 'true') AS avg_smoker_charges,
  FROM insurance
  GROUP BY region
)

SELECT 
  region,
  ROUND(avg_charges, 2) AS avg_charges,
  ROUND(avg_non_smoker_charges, 2) AS avg_non_smoker_charges,
  ROUND(avg_smoker_charges, 2) AS avg_smoker_charges,
  ROUND(avg_smoker_charges - avg_non_smoker_charges, 2) AS smoking_premium 
FROM RegionalAverages

-- Peer Group Benchmarking
-- Task: Compare every individuals charges to their 'peer group' average
-- Define a 'peer group' as policyholders of the same sex and region and also a benchmark for age
-- Output the individuals sex, region average charges and average age charges
-- Include a column for peer_group_avg_charges
-- Include a column for pct_difference (how much higher or lower each individual 
-- is compared to their peer average)

-- Separate CTE for setting up benchmarks
WITH BenchmarkSetup AS (
  SELECT 
    charges, region, sex,
  
    -- Disoplay average by sex and region
    AVG(charges) OVER(PARTITION BY sex, region) AS sra,
    
    -- Pull the deviation from sex and region average
    charges - AVG(charges) OVER(PARTITION BY sex, region) AS srd,

    age,
    -- Diplay age average
    AVG(charges) OVER(PARTITION BY age) AS aa,

    -- Pull the deviation from age average
    charges - AVG(charges) OVER( PARTITION BY age) AS ad
    
  FROM insurance
),

-- Select all columns and perform percentage math based on first CTE
BenchmarkCalcs AS (
  SELECT *,
  
    -- Calculate percentage of difference with regional sex average
    (srd / sra) * 100 AS srd_pct,

    -- Calculate percentage of difference with age average
    (ad / aa) * 100 AS ad_pct

  FROM BenchmarkSetup
)

SELECT 
  ROUND(charges, 2) AS charges,
  
  region,
  sex,
  ROUND(sra, 2) AS regional_sex_avg,
  ROUND(srd, 2) AS regional_sex_diff,
  ROUND(srd_pct, 2) AS regional_sex_diff_pct,
  
  age,
  ROUND(aa, 2) AS age_average,
  ROUND(ad, 2) AS age_diff,
  ROUND(ad_pct, 2) AS age_diff_pct
FROM BenchmarkCalcs
