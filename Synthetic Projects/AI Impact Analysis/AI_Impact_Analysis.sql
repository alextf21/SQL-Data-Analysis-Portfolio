-- Dialect: PostgreSQL / DuckDB

/* Foundational Querying, Basic Filters and Aggregation */

-- Sorting
-- List students ordered by final_score from highest to lowest.
SELECT * FROM impact 
ORDER BY final_score DESC

-- Order students by ai_usage_time_minutes (descending).
SELECT * FROM impact
ORDER BY ai_usage_time_minutes DESC

-- Find the average AI dependency score by grade level
SELECT 
  DISTINCT(grade_level), 
  AVG(ai_dependency_score) as ai_dependency_score
FROM impact 

GROUP BY grade_level
ORDER BY ai_dependency_score DESC

-- Count how many students fall into each performance category
SELECT 
  performance_category, 
  COUNT(performance_category) AS student_count
FROM impact
GROUP BY performance_category

-- Correlations: Compare average final_score for
-- High AI dependency (ai_dependency_score >= 7)
-- Low AI dependency (<= 3)
SELECT 
  ROUND(
    AVG(final_score) FILTER (WHERE ai_dependency_score >= 7)
    , 2) AS avg_high_dependency,
  
  ROUND(
    AVG(final_score) FILTER (WHERE ai_dependency_score <= 3)
    , 2) AS avg_low_dependency
FROM impact

-- Calculate the average final_score for each hour of sleep. 
SELECT 
  CASE 
    WHEN sleep_hours BETWEEN 4 AND 5 THEN '4-5'
    WHEN sleep_hours BETWEEN 5 AND 6 THEN '5-6'
    WHEN sleep_hours BETWEEN 6 AND 7 THEN '6-7'
    WHEN sleep_hours BETWEEN 7 AND 8 THEN '7-8'
    WHEN sleep_hours BETWEEN 8 AND 9 THEN '8-9'
    ELSE 'Unknown'
  END AS hours_slept, 
  
ROUND(AVG(final_score), 2) as avg_final_score
FROM impact
GROUP BY hours_slept
  
ORDER BY avg_final_score DESC


/* Intermediate SQL */

-- What if scenario
-- Assume a passing score and determine the following:
-- The average for each category
-- The count of students in the catefory that passed
-- A pass/fail rate for each performance_category that is compared to overall average
-- Dont use case when
SELECT 
  performance_category,
  ROUND(AVG(final_score), 2) AS avg_final_score,
  COUNTIF(final_score > 55) AS students_passed,
  
  ROUND(
    (COUNTIF(final_score > 55) / 
    COUNT(*)) * 100
    , 2) AS pct_passed
    
FROM impact

GROUP BY performance_category
ORDER BY performance_category DESC

-- SUBQUERY with HAVING clause
-- ai_dependency_score and final_score of those above average
SELECT 
  student_id, 
  age, 
  gender, 
  ai_dependency_score, 
  final_score
FROM impact

GROUP BY ALL
HAVING final_score > (SELECT AVG(final_score) from impact)

ORDER BY final_score DESC


-- Executive summary report
-- Produce a single query that shows the following: 
-- Total individuals
-- Average final score
-- Average AI dependency score
-- Percentage passed
-- AI usage purpose with lowest average score
-- Average Study hours per day of those who passed
SELECT 
  ROUND(AVG(final_score), 2) AS avg_final_score,
  ROUND(AVG(ai_dependency_score), 2) AS avg_ai_dependency_score,

  ROUND(
    (COUNTIF(final_score > 50) / 
      COUNT(*)) * 100, 
      2) AS pct_passed,
    
  (SELECT ai_usage_purpose
    FROM impact
    GROUP BY ai_usage_purpose, final_score
    ORDER BY final_score DESC
    LIMIT 1) AS 'AI usage purpose with lowest average score',
  
  ROUND(
    AVG(study_hours_per_day) FILTER (WHERE passed = 1)
    , 2) AS 'Average Study hours per day of those who passed'

FROM impact
