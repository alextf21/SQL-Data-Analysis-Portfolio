/* Level 1 — Beginner (Foundational SQL) */

-- Display the average daily steps for each BMI category.
SELECT "BMI Category",
ROUND(AVG("Daily Steps"),0) AS Avg_Daily_Steps
FROM sleep
GROUP BY "BMI Category"
ORDER BY Avg_Daily_Steps DESC

-- Count how many individuals fall into each sleep disorder category.
SELECT "Sleep Disorder",
COUNT("Sleep Disorder") AS No_of_People
FROM sleep
GROUP BY "Sleep Disorder"
ORDER BY No_of_People DESC

-- Retrieve individuals with a stress level greater than 7.
SELECT * FROM sleep
WHERE "Stress Level" > 7

-- Calculate the average sleep duration across all individuals.
SELECT ROUND(AVG("Sleep Duration"),1) AS Avg_Sleep_Hrs
FROM sleep

-- Find the average quality of sleep by gender.
SELECT Gender,
AVG("Quality of Sleep") AS Avg_Quality_Sleep
FROM sleep
GROUP BY Gender

-- List all individuals who sleep fewer than 6 hours per night.
SELECT * 
FROM sleep
WHERE "Sleep Duration" < 6 

-- Show distinct occupations present in the dataset.
SELECT DISTINCT(Occupation) 
FROM sleep

/* Level 2 — Intermediate (Segmentation & Derived Metrics) */

-- Compute average sleep duration for people with vs. without sleep disorders.
-- CTE for those with and without sleep disorders
WITH SleepDisorders AS (
  SELECT * FROM sleep
  WHERE "Sleep Disorder" != 'None'
),
NoSleepDisorders AS (
  SELECT * FROM sleep
  WHERE "Sleep Disorder" = 'None'
)
SELECT 
(SELECT ROUND(AVG("Sleep Duration"),1) FROM SleepDisorders) AS Avg_Sleep_with_Disorders,
(SELECT ROUND(AVG("Sleep Duration"),1) FROM NoSleepDisorders) AS Avg_Sleep_without_Disorders

-- Calculate average daily steps by gender and BMI category.
SELECT "BMI Category",
Gender,
ROUND(AVG("Daily Steps"),0) AS Avg_daily_Steps
FROM sleep
GROUP BY ALL 
ORDER BY Avg_daily_Steps DESC

-- Determine the percentage of people who have a sleep disorder.
SELECT COUNT(*) AS Total_people,
ROUND(((SELECT COUNT(*) FROM sleep WHERE "Sleep Disorder" != 'None') / 
COUNT(*)) * 100, 2)
 AS Percent_of_People_with_sleep_disorder
FROM sleep

-- Create sleep-duration groups:
-- <5 hours
-- 5–6 hours
-- 6–7 hours
-- 7–8 hours
-- >8 hours
-- Then calculate average quality of sleep for each group.
SELECT 
  CASE
    WHEN "Sleep Duration" < 5 THEN '<5'
    WHEN "Sleep Duration" BETWEEN 5 AND 6 THEN '5-6'
    WHEN "Sleep Duration" BETWEEN 6 AND 7 THEN '6-7'
    WHEN "Sleep Duration" BETWEEN 7 AND 8 THEN '7-8'
    WHEN "Sleep Duration" > 8 THEN '>8'
    ELSE 'Unkown'
  END AS Hrs_of_sleep,
ROUND(AVG("Quality of Sleep"),1) AS Avg_Quality_Sleep
FROM sleep
GROUP BY Hrs_of_sleep
ORDER BY Avg_Quality_Sleep DESC

-- Compare average stress level by occupation.
SELECT Occupation, 
ROUND(AVG("Stress Level"),1) AS Avg_stress_level
FROM sleep
GROUP BY Occupation
ORDER BY Avg_stress_level DESC

/* Level 3 — Advanced (Analytical & Business-Oriented SQL) */

-- For each person, calculate how their sleep duration 
-- compares to the average sleep duration within their occupation.
SELECT *,
ROUND("Sleep Duration" - AVG("Sleep Duration") OVER(),2) AS Sleep_duration_diff_from_avg
FROM sleep
ORDER BY Occupation

-- What-if scenario:
-- Assume everyone sleeping less than 6 hours increases their sleep by 1 hour.
-- Recalculate the overall average sleep duration.
-- Quantify the improvement.
SELECT AVG("Sleep Duration") AS AvgSleep,
AVG((SELECT 
  CASE 
    WHEN "Sleep Duration" < 6 THEN "Sleep Duration" + 1
    ELSE "Sleep Duration"
  END AS NewAvgSleep
    )) AS WhatIfScenario
FROM sleep

-- Build an executive-style summary query returning:
-- Total individuals
-- Average sleep duration
-- Average quality of sleep
-- Percentage with sleep disorders
-- Occupation with lowest average sleep duration
SELECT COUNT(*) AS TotalParticipants,
AVG("Sleep Duration") AS AvgSleepDuration,
AVG("Quality of Sleep") AS AvgQualitySleep,
((SELECT COUNT(*) 
  FROM sleep 
  WHERE "Sleep Disorder" != 'None') / COUNT(*)) * 100 AS PctWithSleepDisorder,
(SELECT Occupation 
FROM sleep
GROUP BY Occupation, "Sleep Duration"
ORDER BY "Sleep Duration" ASC
LIMIT 1) AS OccupationLowestAvgSleep
FROM sleep
