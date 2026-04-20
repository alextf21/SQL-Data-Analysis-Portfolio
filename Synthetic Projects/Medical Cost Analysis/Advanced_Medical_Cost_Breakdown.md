# Advanced Query Breakdown
Below are further details on the 5 queries that you can find in the relevant file. 

</br>

## Key Findings

### Multi-Factor Risk Scoring
Here we create a weighted scoring system to quantify a policyholders health risk based on four different variables.

| age | sex | bmi | children | smoker | region | charges | risk_points | 
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |  
| 58 | male | 37 | 2 | true | northwest | 47496.49 | 5 | 
| 64 | female | 31 | 2 |  true | southwest | 47291.06 | 5 | 
| 46 | male | 30 | 3 | true | northwest | 40720.55 | 5 | 
| 63 | female | 32 | 2 |  true | southwest | 47305.31 | 5 | 
| 54 | male | 34 | 2 | true | southeast | 44260.75 | 5 | 
| 46 | male | 42 | 3 | true | southeast | 46151.12 | 5 | 
| 50 | male | 34 | 2 | true | southwest | 42856.84 | 5 | 
| 54 | male | 41 | 3 | true | southwest | 48549.18 | 5 | 
| 48 | male | 41 | 2 | true | northeast | 45702.02 | 5 | 
| 60 | male | 31 | 3 | true | northwest | 46130.53 | 5 | 
| 51 | female | 37 | 3 |  true | northeast | 46255.11 | 5 | 
| 47 | male | 39 | 2 | true | southeast | 44202.65 | 5 | 
| ... | ... | ... | ... | ... | ... | ... | ... | 

#### Analysis Highlights
- **Primary Cost Driver**: Smoking is the most significant individual predictor of high medical charges. In the dataset, smokers incur substantially higher costs compared to non-smokers, regardless of age or BMI. 
- **Weights**: The weighting system uses a ```CASE``` statement to assign points:
  - Smoker: +2 points (weighted most heavily)
  - BMI >= 30: +1 point
  - Age >= 45: +1 point
  - Children >= 2: +1 point

-----

</br>

### Risk Tier Financial Aggregation
This query takes the risk scores calculated above and aggregates the financial impact (charges). 

| risk_points | avg_charges | 
| :---: | :---: | 
| 5 | 46468.98 | 
| 4 | 39645.08 | 
| 3 | 23341.16 | 
| 2 | 11783.32 | 
| 1 | 7895.09 | 
| 0 | 4481.10 | 

#### Analysis Highlights
- **Low Risk (0-1 pts)**: Predominantly young, non-smoking individuals with healthy BMIs. This group represents the baseline "healthy" population with the lowest charge variance.
- **Medium Risk (2-3 pts)**: Individuals in this tier often have one major risk factor (snoking) or a combination of two minor ones (e.g., Age + BMI). Costs in this tier are roughly 2-3x higher than the low-risk group. 
- **High Risk (4-5 pts)**: This group represents the top 5-10% of medical spenders, often accounting for over 50% of the total insurance distribution. 

-----

</br>

### Regional Top Tier
This query identifies the "Top 5" highest cost individuals in each region, but only for those whose BMI exceeds the global average. 

| region | age | bmi | charges | rank | 
| :---: | :---: | :---: | :---: | :---: | 
| northeast | 31 | 38 | 58571.07 | 1 | 
| northeast | 54 | 41 | 48549.18 | 2 | 
| northeast | 61 | 36 | 48517.56 | 3 | 
| northeast | 59 | 37 | 47896.79 | 4 | 
| northeast | 51 | 37 | 46255.11 | 5 | 
| northwest | 52 | 34 | 60021.40 | 1 | 
| northwest | 33 | 36 | 55135.40 | 2 | 
| northwest | 58 | 37 | 47496.49 | 3 | 
| northwest | 62 | 31 | 46718.16 | 4 | 
| northwest | 53 | 37 | 46661.44 | 5 | 
| southeast | 54 | 47 | 63770.43 | 1 | 
| southeast | 64 | 37 | 49577.66 | 2 | 
| ... | ... | ... | ... | ... | 

#### Analysis Highlights
- **Cost Ranges**: Across all regions, the top 5 individuals with high BMIs consistnently incur charges between $46,000 and $63,000.
- **Demographic Profile**: While the majority of these high-cost individuals are aged 50+, the query successfully identifies younger outliers, such as a 31-tear-old in the northeast with $58,571 in charges, demonstrating that high BMI can trigger massive medical costs regardless of youth. 


-----

</br>

### The Smoking Premium Gap
This report quantifies the 'cost of smoking' by comparing charges between smokers and non-smokers across different regions.

| region | avg_charges | avg_non_smoker_charges | avg_smoker_charges | smoking_premium | 
| :---: | :---: | :---: | :---: | :---: |
| southeast | 14735.41 | 8032.22 | 34845.00 | 26812.78 | 
| southwest | 12346.94 | 8019.28 | 32269.06 | 24249.78 | 
| northeast | 13406.38 | 9165.53 | 29673.54 | 20508.00 | 
| northwest | 12417.58 | 8556.46 | 30192.00 | 21635.54 | 


#### Analysis Highlights
- **The Massive Multiplier**: Across all regions, smokers pay between $20,000 and $26,000 more than non-smokers. In terms of scale, smoking increases average medical charges by roughly 300% to 400%.
- **Regional Peak**: The southeast exhibits the largest "Smoking Premium" at $26,812.78. This region also has the highest average smoker charges ($34,845), suggesting that lifestyle factors in this area might compound with smoking to drive costs even higher. 

-----

</br>

### Peer Group Benchmarking
This is the most complex query in the file. It compares an individuals costs against 2 different 'peer groups' simultaneously using window functions. Although the data can be ordered by whatever metric you want, you may see different results from below as these are random. 

#### Logic Breakdown
- **Peer Group A (Sex and Region)**: Uses ```PARTITION BY sex, region``` to see how an individual compares to tohers of the same gender in their area.
- **Peer Group B (Age)**: Uses ```PARTITION BY age``` to see how policyholders compare to others of the exact same age.
- **Deviation Analysis**:
  - srd_pct (sex regional difference percentage): The percentage difference from the sex/regional average.
  - ad_pct (age difference percentage): The percentage difference from the age average.
- **Insight**: This helps in identifying outliers; people who are paying more or less than others with similar demographic profiles.

| charges | region | sex | regional_sex_diff | regional_sex_diff_pct | age | age_diff | age_diff_pct | 
| :---: | :---: | :---:| :---:| :---:| :---:| :---:| :---: |
| 4527.18 | northwest | female | -7952.69 | -63.72 | 30 | -8191.93 | -64.41 | 
| 39241.44 | southwest | male | 25828.56 | 192.57 | 30 | 26522.33 | 208.52 | 
| 5325.65 | southwest | female | 5948.76 | -52.76 | 30 | 7393.46 | -58.13 | 
| 4032.24 | northwest | male | 8321.88 | -67.36 | 30 | -8686.87 | -68.30 | 
| 4149.74 | southwest | female | -7124.68 | -63.19 | 30 | 8569.37 | -67.37 | 
| 17361.77 | northwest | male | 5007.65 | 40.53 | 30 | 4642.06 | 36.50 | 
| 18963.17 | southeast | male | 3083.55 | 19.42 | 30 | 6244.06 | 49.09 | 
| 3554.20 | southwest | female | -7720.21 | -68.48 | 30 | -9164.91 | -72.06 | 
| 4719.52 | northeast | female | -8233.68 | -63.56 | 30 | -7999.59 | -62.89 | 
| 4137.52 | northeast | female | -8815.68 | -68.06 | 30 | -8581.59 | -67.47 | 
| 4718.20 | northeast | female | -8235.00 | -63.58 | 30 | -8000.91 | -62.9 | 
| 3645.09 | northeast | male | -10208.92 | -73.69 | 30 | -9074.02 | -71.34 | 
| ... | ... | ... | ... | ... | ... | ... | ... | 

#### Analysis Highlights
- **Regional and Demographic Benchmarking**: While sex and region do not show significant variance in median changes, the deviation analysis revelas that individuals in the Northeast and Southeast tend to have outliers in the "High Risk" category compared to the Southwest. 

-----

