# Advanced Query Breakdown
Below are further details on the 5 queries that you can find in the relevant file. 

</br>

## 1. Multi Factor Risk Scoring
Here we create a weighted scoring system to quantify a policyholders health risk based on four different variables.

### Logic Breakdown
The weighting system uses a ```CASE``` statement to assign points:
- Smoker: +2 points (weighted most heavily)
- BMI >= 30: +1 point
- Age >= 45: +1 point
- Children >= 2: +1 point


From here we can add these points together into a derived column. 

**Purpose**: This allows us for quick sorting of the 'riskiest' individuals in the dataset.

</br>

## 2. Risk Tier Financial Aggregation
This query takes the risk scores calculated above and aggregates the financial impact (charges). 

### Logic Breakdown
- **CTE Usage**: Reuse the ```RiskScore``` logic to generate the total points. 
- **Grouping**: Groups dataset by ```RiskPoints``` total. 
- **Validation**: Calculates the ```AVG(charges)``` for each score. 
- **Goal**: To validate the scoring models accuracy in a way that shows average charges go up with risk points. 

</br>

## 3. Regional Top Tier
This query identifies the 'top 5' highest cost individuals in eaach region, but only for those whose BMI exceeds the global average. 

### Logic Breakdown
- **Window Functions**: Uses ```RANK() OVER(PARTITION BY region ORDER BY charges DESC)``` to create a leaderbord for each specific region.
- **Filtering**: A subquery in the ```WHERE``` clause
- **Final Ouput**: Filters the ranked list to only show the top 5 per region.

</br>

## 4. The Smoking Premium Gap
This report quantifies the 'cost of smoking' by comparing charges between smokers and non-smokers across different regions.

### Logic Breakdown
- **Advanced Filtering**: Uses the ```FILTER (WHERE..)``` clause (common in PostgreSQL and DuckDB) to calculate 2 different averages in the same select statement.
- **CTE** ```RegionalAverages```: Calculates raw averages for smokers and non-smokers.
- **Main Query**: Subtracts the non-smoker average from the smoker average to find the 'extra cost' of being a smoker. 

</br>

## 5. Peer Group Benchmarking
This is the most complex query in the file. It compares an individuals costs against 2 different 'peer groups' simultaneously using window functions. 

### Logic Breakdown
- **Peer Group A (Sex and Region)**: Uses ```PARTITION BY sex, region``` to see how an individual compares to tohers of the same gener in their area.
- **Peer Group B (Age)**: Uses ```PARTITION BY age``` to see how policyholders compare to others of the exact same age.
- **Deviation Analysis**:
  - srd_pct: The percentage difference from the sex/regional average.
  - ad_pct: The percentage difference from the age average.
- **Insight**: This helps in identifying outliers; people who are paying more or less than others with similar demographic profiles.





