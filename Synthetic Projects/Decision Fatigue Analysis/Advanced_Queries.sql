-- Build a CTE that classifies users into Risk Segments:
-- High Risk: Fatigue_Level='High' AND Error_Rate > 0.10
-- Medium Risk: Fatigue_Level='Moderate'
-- Low Risk: Fatigue_Level='Low'
-- Then compute average cognitive load per segment.
WITH RiskSegment AS (
  SELECT 
    CASE 
      WHEN Fatigue_Level = 'High' AND Error_Rate > 0.10 THEN 'High Risk'
      WHEN Fatigue_Level = 'High' THEN 'High Risk'
      WHEN Fatigue_Level = 'Moderate' THEN 'Medium Risk'
      WHEN Fatigue_Level = 'Low' THEN 'Low Risk'
      ELSE 'Unknown'
    END AS Segments,
    Cognitive_Load_Score
  FROM fatigue
)

SELECT 
  Segments,
  ROUND(AVG(Cognitive_Load_Score), 4) AS AvgCogLoadScore
FROM RiskSegment
GROUP BY Segments

-- Benchmarking against Averages (CTEs):
-- Create a CTE that calculates the average Error_Rate for each Fatigue_Level
-- Join this CTE back to the main table to find individuals whose Error_Rate is
-- More than 2x the average for their specific fatigue level.

-- CTE that calculates the average error rate for each fatigue level
WITH erfl AS (
  SELECT 
    Fatigue_Level,
    AVG(Error_Rate) AS Avg_Error_Rate
      
  FROM fatigue
  GROUP BY Fatigue_Level
)

SELECT 
  -- Higher stress levels tend to have higher error rates
  f.Stress_Level_1_10,
  f.Error_Rate,

  -- Grab all the fatigue levels and calculate:
  -- Deviation from average Error_Rate for each row
  f.Fatigue_Level,
  ROUND(
    f.Error_Rate - erfl.Avg_Error_Rate,
    6) AS Error_Rate_Diff_from_Avg
    
FROM fatigue f
  
-- Map the aggregated data back to the main table
JOIN erfl
  ON erfl.Fatigue_Level = f.Fatigue_Level
  
-- Filter for cases whose Error_Rate_Diff_from_Avg is 2x for their Fatigue_Level
WHERE f.Error_Rate >= erfl.Avg_Error_Rate * 2

ORDER BY f.Stress_Level_1_10 DESC
