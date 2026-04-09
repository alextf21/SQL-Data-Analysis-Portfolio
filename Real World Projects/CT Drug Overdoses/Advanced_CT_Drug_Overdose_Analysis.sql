-- Dialect: PostgreSQL / DuckDB


-- Demographic Consolidation: Analyze death counts by Race. 
-- You must merge categories like Black and Black or African American into a single bucket to get an accurate count.
WITH Races AS (
  SELECT 
  
    CASE
      -- White
      WHEN LOWER(Race) LIKE 'white' THEN 'White'
      
      -- Black or African American
      WHEN LOWER(Race) IN ('black', 'black or african american', 'other (specify) haitian') THEN 'Black or African American'

      -- Asian
      WHEN LOWER(Race) LIKE '%asian%' OR LOWER(Race) IN ('asian indian', 'asian/indian', 'chinese', 'japanese', 'korean') THEN 'Asian'

      -- American Indian or Alska Native
      WHEN LOWER(Race) IN ('american indian or alaska native', 'native american, other') THEN 'American Indian or Alaskan Native'

      -- Native Hawaiian or Other Pacific Islander
      WHEN LOWER(Race) LIKE 'hawaiian' THEN 'Native Hawaiian or Other Pacific Islander'

      -- Other / Multiracial
      WHEN LOWER(Race) IN ('other', 'other (specify)', 'other (specify) puerto rican', 'other (specify) portugese, cape verdean', 
        'black or african american / american indian lenni lenape') THEN 'Other / Multiracial'

      -- Unkown / Null
      ELSE 'Not Specified'
      
    END AS "Cleaned Race"

  FROM drug

  -- General cleaning mechanism to ensure we're just counting accidents and excluding NULL races
  WHERE "Manner of Death" != 'Pending'
    AND Race IS NOT NULL
)

SELECT
  "Cleaned Race",
  COUNT(*) AS Deaths
FROM Races
GROUP BY "Cleaned Race"
ORDER BY Deaths DESC


-- Coordinate Extraction: The ResidenceCityGeo column contains strings like BRIDGEPORT, CT\n(41.179195, -73.189476). 
-- Extract the Latitude and Longitude into two separate numeric columns

-- CTE to extract just the coordinates which we will use later
WITH
  Setup AS (
    SELECT
  
      -- Original uncleaned location with coordinates
      DeathCityGeo,
      
      -- Substring of just the coordinates
      SUBSTR(
        DeathCityGeo,
        STRPOS(DeathCityGeo, '(') + 1, -- Start from the position of the parenethesese plus one
        LENGTH(SUBSTR(DeathCityGeo, STRPOS(DeathCityGeo, '(') + 1)) - 1 -- Go for the length of the coordinates minus one
      ) AS Coordinates
      
    FROM drug
  ),
  -- CTE to use coordinates from above for extracting longitude and lattitude
  GeoClean AS (
    SELECT *,
  
      -- Longitude starting from the beginning of Coordinates variable above going until the comma
      SUBSTR(
        Coordinates,
        0,
        STRPOS(Coordinates, ',')
      ) AS Longitude,
  
      -- Lattitude starting from the space after the comma going until the end
      SUBSTR(
        Coordinates,
        STRPOS(Coordinates, ',') + 2
      ) AS Lattitude
    FROM Setup
  )
  
SELECT
  DeathCityGeo,
  Coordinates,
  Longitude,
  Lattitude
FROM GeoClean
  
ORDER BY
RANDOM()


-- Imputation Strategy: For records missing an Age, impute the value 
-- using the average age of victims from the same Residence County and Sex. 

WITH Benchmark AS (
  SELECT
    "Residence County",
    Sex
  FROM drug
)
SELECT
  Sex,
  "Residence County",
  Age,
  
  CASE
    WHEN Age IS NULL THEN 
      (SELECT 
          ROUND(AVG(Age), 0) -- Age has no decimal so we're rounding 
        FROM drug d 
        JOIN Benchmark b
          ON d."Residence County" = b."Residence County"
          AND d.Sex = b.Sex
      )
    ELSE Age
  END AS "Cleaned Age"
      
FROM drug

-- Reporting Lag: Compare the Date column when the Date Type is "Date of death" vs. "Date reported." 
-- Calculate the average "lag" in days for reported deaths per year.
WITH DateOfDeath AS (
  SELECT 
    Date AS "Death Date",
    Age,
    Sex,
    Race,
    "Death City"
  FROM drug
  WHERE "Date Type" = 'Date of death'
),
DateReported AS (
  SELECT 
    Date AS "Date Reported",
    Age,
    Sex,
    Race,
    "Death City"
  FROM drug
  WHERE "Date Type" = 'Date reported'
)

SELECT 
  EXTRACT(YEAR FROM d."Death Date") AS Year,

  -- Taking the absolute value of the average to avoid negative days
  ABS(
    ROUND(
      AVG(d."Death Date" - r."Date Reported")
    , 2)
  ) AS "Avg Lag Days"

FROM DateOfDeath d

JOIN DateReported r 
  ON d.Age = r.Age
  AND d.Sex = r.Sex
  AND d.Race = r.Race
  AND d."Death City" = r."Death City"
  
GROUP BY Year
ORDER BY Year ASC

/* 
  The following query has different variations and outputs depending on what you want to see.
  There are 3 different versions:
    1. You can generate the original ask that outputs the drug count for every case in the dataset
    2. Alternatively you can perform single line aggregates on the newly created drug count column
    3. For further analysis, you can break the aggregation down into yearly functions
*/

-- The following is aggregated by year for further detail 
-- The Polydrug Metric: Create a new column called DrugCount that sums how many different drugs 
-- were present in a single incident (by checking all drug columns).

-- CTE to form base with IDs for each row
WITH Base AS (
  SELECT
    ROW_NUMBER() OVER() AS CaseID,
    *,

    -- Since the 'Other Opioid' column is never 'Y' we have to account for text being present to indicate there was another drug
    CASE WHEN STRLEN("Other Opioid") > 1 THEN 'Y' END AS "Other Opioid",

    -- Since the 'Other' column is never 'Y' we have to account for text being present to indicate there was another drug
    CASE WHEN STRLEN(Other) > 1 THEN 'Y' END AS Other

  FROM drug
),

-- CTE to unpivot all of the drug columns so that they are rows
Unpivoted AS (
  SELECT 
    EXTRACT(YEAR FROM Date) AS Year,
    CaseID,
    DrugName,
    DrugFlag
  FROM Base

  UNPIVOT (
    DrugFlag 
    FOR DrugName IN (
      Heroin,
      "Heroin death certificate (DC)",
      Cocaine,
      Fentanyl,
      "Fentanyl Analogue",
      Oxycodone,
      Oxymorphone,
      Ethanol,
      Hydrocodone,
      Benzodiazepine,
      Methadone,
      "Meth/Amphetamine",
      Amphet,
      Hydromorphone,
      "Morphine (Not Heroin)",
      Xylazine,
      Gabapentin,
      "Opiate NOS",
      "Other Opioid",
      -- Removed "Any Opioid" from the list to avoid potential double counting
      Other
    )
  )
  -- Be sure to capture instances where its not just 'Y' for a DrugFlag (e.g., Y POPS, Y(PITCH), P)
  WHERE DrugFlag IN ('Y', 'y', 'Y POPS', 'Y (PTCH)', 'P')  
)

-- Main query that just takes the CaseID and aggregates the drug count now that everything is in 1 column
-- This provides the DrugCount column for every case in the dataset
/*
SELECT
  CaseID,
  COUNT(*) AS DrugCount
FROM Unpivoted
GROUP BY CaseID
ORDER BY CaseID ASC
*/

-- From here we can wrap the above into different FROM statements
SELECT 

  Year,
  COUNT(*) AS "Total Incidents", 
  ROUND(AVG(DrugCount), 2) AS "Average Drug Count",
  MAX(DrugCount) AS "Maximum Drug Count"
  
FROM (
  SELECT
    Year,
    COUNT(*) AS DrugCount
  FROM Unpivoted
  GROUP BY CaseID, Year
  ORDER BY CaseID ASC
) AS Unpivoted

GROUP BY Year
ORDER BY Year ASC

