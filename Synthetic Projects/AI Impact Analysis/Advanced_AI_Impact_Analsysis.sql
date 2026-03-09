-- Dialect: PostgreSQL / DuckDB

-- Peer Performance Gap Analysis
-- Objective: Perform a "lead-lag" analysis to see how students compare to 
-- Their immediate academic neighbors.
-- Task: Rank students within each grade_level by final_score. Create a report showing:
-- The student's final_score.
-- The score difference of the student immediately ranked below them (LAG).
-- The score difference of the student immediately ranked a them (LEAD).
-- The "Gap to Leader" (Difference between their score and the #1 ranked student in their grade).

SELECT 
  student_id,
  grade_level,
  final_score,

  -- Show students rank in class (Higher average score, lower the rank)
  RANK() OVER(
    PARTITION BY grade_level 
    ORDER BY final_score DESC) AS rank,

  -- Capture the difference in final_score between current student and 
  -- student immediately below in grade
  ROUND(
    final_score - LAG(final_score) OVER(
      PARTITION BY grade_level 
      ORDER BY final_score DESC)
      , 2) AS points_behind,

  -- Capture the difference in final_score between current student and 
  -- student immediately above in grade
  ROUND(
    final_score - LEAD(final_score) OVER(
      PARTITION BY grade_level 
      ORDER BY final_score DESC)
      , 2) AS points_ahead,

  -- Gap to Leader: Capture the difference in final_score between 
  -- current student and highest final score in grade
  ROUND(
    final_score - MAX(final_score) OVER(
      PARTITION BY grade_level)
      , 2) AS gap_to_leader
    
FROM impact


-- AI Dependency vs. Ethics Benchmark
-- Analyze if higher AI ethics scores correlate with better academic outcomes,   
-- while adjusting for AI dependency.
-- Task:
-- 1.  Use a CTE to calculate the average ai_ethics_score and average 
-- final_score for each grade_level.
-- 2.  Join this back to the main table.
-- 3.  Flag students who have an ai_dependency_score above their grade's average but 
-- an ai_ethics_score below their grade's average.
-- 4.  Calculate the final_score difference for these "at-risk" students 
-- compared to the grade average.

WITH esfs AS (
  SELECT 
    grade_level,
    AVG(ai_ethics_score) AS avg_ai_ethics_score,
    AVG(ai_dependency_score) AS avg_ai_dependency_score,
    AVG(final_score) AS avg_final_score
  FROM impact
  GROUP BY grade_level
)

SELECT 
  i.student_id,
  i.grade_level,

  -- Find each students deviation from the average ethics and final scores
  -- using the CTE created above
  i.ai_ethics_score,
  ROUND(
    i.ai_ethics_score - esfs.avg_ai_ethics_score
    , 2) AS ethics_deviation,

  -- Find each students deviation from the average ethics and final scores
  -- using the CTE created above
  i.final_score,
  ROUND( 
    i.final_score - esfs.avg_final_score
    , 2 ) AS final_score_deviation,

  -- Flag students who have an ai_dependency_score above their grade's average but 
  -- an ai_ethics_score below their grade's average.
  CASE 
    WHEN i.ai_dependency_score > esfs.avg_ai_dependency_score
      AND i.ai_ethics_score < esfs.avg_ai_ethics_score 
    THEN 'Y' 
    END AS flag

FROM impact i

JOIN esfs ON
  i.grade_level = esfs.grade_level

-- Optional filter for just flagged results
-- WHERE flag = 'Y'

  
-- Fastest Risers Detection
-- Identify "underdogs" who are currently low-ranked but showing the highest potential for growth
-- Task: For each grade_level, find students who are in the bottom 25% of final_score but 
-- are in the top 10% of improvement_rate.
WITH Ranked AS (
  SELECT
    student_id,
    grade_level,
    
    -- Create percentiles of improvement rate partitioned by grade level
    -- Higher the improvement rate, lower the percentile
    -- 0.0 represents the top performer
    improvement_rate,
    PERCENT_RANK() OVER(
      PARTITION BY grade_level
      ORDER BY improvement_rate DESC
    ) AS improvement_rate_rank,
    
    -- Create percentiles of final score partitioned by grade level
    -- Higher the grade, lower the percentile
    -- 0.0 represents the top performer
    final_score,
    PERCENT_RANK() OVER(
      PARTITION BY grade_level
      ORDER BY final_score DESC
    ) AS score_rank

  FROM impact
)

SELECT 
  student_id,
  grade_level,
  ROUND(improvement_rate_rank * 100, 2) AS improvement_rate_percentile,
  ROUND(score_rank * 100, 2) AS score_percentile
FROM Ranked

WHERE score_rank >= 0.75
AND improvement_rate_rank <= 0.1

ORDER BY final_score DESC
ORDER BY rank ASC
