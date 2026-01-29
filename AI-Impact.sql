/* Beginner Challenges (Foundational SQL) */

-- Retrieve all students who do not use AI
SELECT * from impact
WHERE uses_ai = 0

-- Find students with attendance percentage below 75%
SELECT * FROM impact
WHERE attendance_percentage < 75.0

-- Create a column called exam_difference showing final_score - last_exam_score
SELECT *, 
(last_exam_score - final_score) as exam_difference
FROM impact

-- List all distinct AI usage purposes
SELECT DISTINCT(ai_usage_purpose) FROM impact

/* Intermediate Challenges */

-- Find the average AI dependency score by grade level
SELECT grade_level, 
AVG(attendance_percentage) AS avg_attendance_pct
FROM impact
GROUP BY grade_level
ORDER BY avg_attendance_pct DESC

-- Calculate the average final_score for each of the sleep_hours.
-- Group into ranges (5-6, 6-7, etc.)
SELECT 
  CASE 
    WHEN sleep_hours BETWEEN 4 AND 5 THEN '4-5'
    WHEN sleep_hours BETWEEN 5 AND 6 THEN '5-6'
    WHEN sleep_hours BETWEEN 6 AND 7 THEN '6-7'
    WHEN sleep_hours BETWEEN 7 AND 8 THEN '7-8'
    WHEN sleep_hours BETWEEN 8 AND 9 THEN '8-9'
    WHEN sleep_hours > 9 THEN '> 9'
    ELSE 'Unknown'
  END AS hours_slept, 
AVG(final_score) as avg_final_score
FROM impact
GROUP BY ALL
ORDER BY avg_final_score DESC;

-- Behavioral Impact Analysis
-- Analyze how ai_generated_content_percentage impacts final_score
-- Group into ranges (0–25, 26–50, 51–75, 76–100)
SELECT 
  CASE 
    WHEN ai_generated_content_percentage BETWEEN 0 AND 25 THEN 'Low'
    WHEN ai_generated_content_percentage BETWEEN 26 AND 50 THEN 'Low to Mid'
    WHEN ai_generated_content_percentage BETWEEN 51 AND 75 THEN 'Mid to High'
    WHEN ai_generated_content_percentage BETWEEN 76 AND 100 THEN 'High'
    ELSE performance_category
   END AS 'AI Generated Content %', 
AVG(final_score) AS avg_final
FROM impact
GROUP BY ALL
ORDER BY avg_final DESC

-- SUBQUERY with WHERE clause
-- Who is scoring higher than average, list their study hours per day and their final score
SELECT student_id, age, gender, final_score, study_hours_per_day
FROM impact 
WHERE final_score > (SELECT AVG(final_score) FROM impact)
ORDER BY final_score DESC

-- What if scenario
-- Assume a passing score and determine the following:
-- The average for each category
-- The count of students in the catefory that passed
-- A pass/fail rate for each performance_category that is compared to overall average
-- Dont use case when
SELECT performance_category,
ROUND(AVG(final_score),2) AS avg_final_score,
COUNTIF(final_score > 55) AS students_passed,
ROUND((COUNTIF(final_score > 55) / COUNT(*)) * 100,2) AS pct_passed
FROM impact
GROUP BY performance_category
ORDER BY performance_category DESC

/* Advanced Challenges (Advanced / Analytical SQL) */

-- Concept: Window Functions: Rank students within each grade level by final score
-- Compute each student’s score difference from the grade average.
SELECT age, gender, final_score,
final_score - AVG(final_score) OVER() as diff_from_avg
FROM impact
ORDER BY diff_from_avg DESC

-- Window Funciton with Rank() OVER(PARTITION BY)
-- Calculate grade_level_rank for all students
SELECT student_id, grade_level, final_score,
RANK() OVER(PARTITION BY grade_level ORDER BY final_score DESC) AS grade_level_rank
FROM impact
ORDER BY grade_level_rank ASC


