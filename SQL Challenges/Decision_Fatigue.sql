/* Beginner Level (Foundations & Descriptive SQL) */

-- Display all records where Fatigue_Level = 'High'.
SELECT * FROM fatigue
WHERE Fatigue_Level = 'High'
LIMIT 50

-- Show the average Decision_Fatigue_Score for each Fatigue_Level.
SELECT Fatigue_Level, 
ROUND(AVG(Decision_Fatigue_Score),2) AS AvgDecisionFatigueScore
FROM fatigue
GROUP BY Fatigue_Level

-- List the top 10 records with the highest Error_Rate.
SELECT * FROM fatigue
ORDER BY Error_Rate DESC
LIMIT 10

-- Count how many observations occur in each Time_of_Day.
SELECT Time_of_Day, 
COUNT(*) AS CountOfObservations
FROM fatigue
GROUP BY Time_of_Day
ORDER BY CountOfObservations DESC

-- Find the average number of Decisions_Made grouped by System_Recommendation.
SELECT System_Recommendation,
ROUND(AVG(Decisions_Made),2) AS AvgDecisionsMade
FROM fatigue
GROUP BY System_Recommendation
ORDER BY AvgDecisionsMade

-- Return records where:
-- Sleep_Hours_Last_Night < 5
-- AND Fatigue_Level = 'High'.
SELECT * FROM fatigue
WHERE Sleep_Hours_Last_Night < 5 AND Fatigue_Level = 'High'

-- Create a derived column called Sleep_Category:
-- < 5 → 'Poor Sleep'
-- 5–7 → 'Moderate Sleep'
-- 7 → 'Good Sleep'.
SELECT *,
  CASE
    WHEN Sleep_Hours_Last_Night < 5 THEN 'Poor Sleep'
    WHEN Sleep_Hours_Last_Night BETWEEN 5 AND 7 THEN 'Moderate sleep'
    WHEN Sleep_Hours_Last_Night >= 7 THEN 'Good sleep'
    ELSE 'Unkown'
  END AS Sleep_Category
FROM fatigue
LIMIT 100

-- Show average Decision_Fatigue_Score by Sleep_Category.
SELECT
  CASE
    WHEN Sleep_Hours_Last_Night < 5 THEN 'Poor Sleep'
    WHEN Sleep_Hours_Last_Night BETWEEN 5 AND 7 THEN 'Moderate sleep'
    WHEN Sleep_Hours_Last_Night >= 7 THEN 'Good sleep'
    ELSE 'Unkown'
  END AS Sleep_Category,
ROUND(AVG(Decision_Fatigue_Score),2) AS AvgDecisionFatigueScore
FROM fatigue
GROUP BY Sleep_Category

-- Order fatigue levels by their average Error_Rate (highest first).
SELECT Fatigue_Level,
ROUND(AVG(Error_Rate),5) * 100 AS AvgErrorRatePct
FROM fatigue
GROUP BY Fatigue_Level
ORDER BY AvgErrorRatePct DESC

-- Find the minimum, maximum, and average Hours_Awake.
SELECT 
MIN(Hours_Awake) AS MinHoursAwake,
MAX(Hours_Awake) AS MaxHoursAwake,
AVG(Hours_Awake) AS AvgHoursAwake
FROM fatigue

/* Intermediate Level (Analytical Aggregations, CTEs and Window Functions)  */

-- For each Fatigue_Level, calculate:
-- AVG(Error_Rate)
-- AVG(Decision_Fatigue_Score)
-- AVG(Avg_Decision_Time_sec)
SELECT Fatigue_Level,
ROUND(AVG(Error_Rate),2) AS AvgErrorRate,
ROUND(AVG(Decision_Fatigue_Score),2) AS AvgDecisionFatigueScore,
ROUND(AVG(Avg_Decision_Time_sec),2) AS AvgDecisionTimeSeconds
FROM fatigue
GROUP BY Fatigue_Level

-- Rank Time_of_Day by highest average Decision_Fatigue_Score.
SELECT Time_of_Day,
ROUND(AVG(Decision_Fatigue_Score),2) AS AvgDecisionFatigueScore
FROM fatigue
GROUP BY Time_of_Day
ORDER BY AvgDecisionFatigueScore DESC

-- Identify the top 5% of records by Decision_Fatigue_Score.
SELECT * FROM fatigue
ORDER BY Decision_Fatigue_Score DESC
LIMIT (SELECT COUNT(*) * .05 FROM fatigue)

-- Compare average fatigue scores for:
-- Caffeine drinkers (Caffeine_Intake_Cups > 0)
-- Non-drinkers (Caffeine_Intake_Cups = 0).
-- CTEs
WITH CaffeineDrinkers AS (
  SELECT ROUND(AVG(Decision_Fatigue_Score),2) AS AvgDecisionFatigueScoreCaffeineDrinkers
  FROM fatigue
  WHERE Caffeine_Intake_Cups > 0
), 
NonCaffeineDrinkers AS (
  SELECT ROUND(AVG(Decision_Fatigue_Score),2) AS AvgDecisionFatigueScoreNonCaffeineDrinkers
  FROM fatigue
  WHERE Caffeine_Intake_Cups = 0
) 
SELECT 
CaffeineDrinkers.AvgDecisionFatigueScoreCaffeineDrinkers,
NonCaffeineDrinkers.AvgDecisionFatigueScoreNonCaffeineDrinkers
FROM CaffeineDrinkers, NonCaffeineDrinkers

-- Same as above but without CTEs
SELECT 
AVG(Decision_Fatigue_Score) FILTER (Caffeine_Intake_Cups > 0) AS AvgDatigueScoreCaffeineDrinkers,
AVG(Decision_Fatigue_Score) FILTER (Caffeine_Intake_Cups = 0) AS AvgDatigueScoreNonCaffeineDrinkers
FROM fatigue

-- Create buckets of Hours_Awake:
-- 0–6, 7–12, 13–18, 19+
-- and compute average fatigue score per bucket.
SELECT 
  CASE
    WHEN Hours_Awake BETWEEN 0 AND 6 THEN '0-6'
    WHEN Hours_Awake BETWEEN 7 AND 12 THEN '7-12'
    WHEN Hours_Awake BETWEEN 13 AND 18 THEN '13-18'
    WHEN Hours_Awake > 19 THEN '19+'
    ELSE 'Unkown'
  END AS HoursAwakeCategory,
ROUND(AVG(Decision_Fatigue_Score),2) AS AvgDecisionFatigueScore
FROM fatigue
GROUP BY HoursAwakeCategory
ORDER BY AvgDecisionFatigueScore DESC

-- For each System_Recommendation, calculate what percentage of total rows it represents.
SELECT 
(COUNT(System_Recommendation) FILTER (System_Recommendation = 'Slow Down') / 
COUNT(*)) * 100 AS PctSlowDown,
(COUNT(System_Recommendation) FILTER (System_Recommendation = 'Take Break') / 
COUNT(*)) * 100 AS PctTakeBreak,
(COUNT(System_Recommendation) FILTER (System_Recommendation = 'Continue') / 
COUNT(*)) * 100 AS PctContinue
FROM fatigue

-- Show difference between each row’s fatigue score and the overall average fatigue score.
SELECT *,
ROUND(Decision_Fatigue_Score - AVG(Decision_Fatigue_Score) OVER(), 2) AS FatigueScoreDiffFromAvg
FROM fatigue
LIMIT 25
