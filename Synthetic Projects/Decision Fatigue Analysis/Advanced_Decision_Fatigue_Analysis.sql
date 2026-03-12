-- Dialect: PostgreSQL / DuckDB

-- The 'Statistical Outlier' Detector
-- 1. Goal: Identify high risk entries where the individuals Error_Rate is significantly 
-- higher than the peer group average for their specific Time_of_Day and Fatigue_Level

-- 2.. Use a CTE to calculate the average Error_rate and Standard Deviation for every
-- unique combination of Time_of_Day and Fatigue_Level

-- 3. Filter for rows where the Error_Rate is 2 Standard Deviations above the group mean

-- Setup a benchmark CTE
WITH BenchmarkSetup AS (
  SELECT
      Time_of_Day,
      Fatigue_Level,
      AVG(Error_Rate) AS Avg_Error_Rate,
      STDDEV(Error_Rate) AS Std_Dev_Error_Rate
  FROM fatigue
  GROUP BY Time_of_Day, Fatigue_Level
)

SELECT 
  f.Fatigue_Level,
  f.Time_of_Day,
  f.Error_Rate,

  -- Calculate difference from averge
  ROUND(bm.Avg_Error_Rate, 2) AS Avg_Error_Rate,
  ROUND(
    f.Error_Rate - bm.Avg_Error_Rate 
    , 2) AS Deviation_from_Avg

-- Join CTE to main query
FROM fatigue f
JOIN BenchmarkSetup bm 
ON f.Time_of_Day = bm.Time_of_Day
AND f.Fatigue_Level = bm.Fatigue_Level

-- Filter for +/- 2x group average
WHERE f.Error_Rate > (bm.Avg_Error_Rate + 2 * bm.Std_Dev_Error_Rate)
OR f.Error_Rate < (bm.Avg_Error_Rate - 2 * bm.Std_Dev_Error_Rate)

  
-- Decile Based Performance Profiling
-- 1. Goal: Analyze how the System_Recommendation shifts as people move through different
-- 'risk buckets' of Decision_Fatigue_Score
  
-- 2. Use the NTILE(10) window function to divide the entire dataset into 10 deciles based on Decision_Fatigue_Score
  
-- 3. For each decile, calculate:
-- The average Sress_Level_1_10
-- The percentage of rows where the recommendation is 'Take Break'
  
-- 4. Display the results sorted by decile (1 to 10)

-- Create a CTE to materialize the fatigue score percentile
WITH Percentile AS (
  SELECT
    Stress_Level_1_10,
    System_Recommendation,
    
    -- Create 10 percentiles, 1 being highest and 10 being lowest. 
    -- dfs_pctl = Decision_Fatigue_Score_Percentile
    NTILE(10) OVER(ORDER BY Decision_Fatigue_Score DESC) AS Decision_Fatigue_Score_Percentile
  FROM fatigue
)

SELECT 
  Decision_Fatigue_Score_Percentile,
  ROUND(AVG(Stress_Level_1_10), 2) AS Avg_Stress_Level_1_10,

  -- Calculate percentage of rows in each percentile where the 
  -- System_Recommendation = 'Take Break'
  ROUND( 
    (COUNT(*) FILTER (WHERE System_Recommendation = 'Take Break') / 
    COUNT(*)) * 100
    , 2) AS '% Take Break'
    
FROM Percentile 

-- Grouping by the percentile function created earlier will give us a 1-10 view
GROUP BY Decision_Fatigue_Score_Percentile
ORDER BY Decision_Fatigue_Score_Percentile ASC 

  
-- The 'Fatigue Slope'
-- 1. Goal: Identify rows where the Stress_Level_1_10 is climbing faster than the 
-- average for the current Hours_Awake cohort
  
-- 2. Use a window function to calculate a 'Moving Average' of Stress_Level_1_10
-- partitioned by Time_of_Day and ordered by Hours_Awake
  
-- 3. Compare the individuals Stress_Level_1_10 to the LAG() Stress_Level_1_10
-- within the same Time_of_Day
  
-- 4. Identify 'Stres Spikes': Cases where the current stress is > 20% higher than 
-- the previous record in the Hours_Awake sequence

-- Create CTE to actualize Stress_Lag figures
WITH FunctionSetup AS (
  SELECT
    Time_of_Day,
    Hours_Awake,
    Stress_Level_1_10,

    -- Primary LAG() function for subtracting Stress_Level partitioned by Time_of_Day
   LAG(Stress_Level_1_10) OVER(PARTITION BY Time_of_Day ORDER BY Hours_Awake) AS Prev_Stress,
   
    -- Moving average function
    AVG(Stress_Level_1_10) OVER(
      PARTITION BY Time_of_Day 
      ORDER BY Hours_Awake
      ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
      ) AS Stress_Level_Moving_Average
    
  FROM fatigue
)

SELECT *
FROM FunctionSetup

-- Filter for 'Stress Spikes': Cases where Stress_Level is > 20% than 
-- the previous record in Hours_Awake sequence
WHERE Stress_Level_1_10 > (Prev_Stress * 1.2)

