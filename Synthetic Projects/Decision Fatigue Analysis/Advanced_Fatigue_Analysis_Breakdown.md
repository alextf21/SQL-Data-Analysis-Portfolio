# Breakdown of Advanced Scripts
Below are the full explanations for 3 SQL queries that move from basic data retrieval to statistical anomaly detection, decile-based profiling, and 
benchmark comparisons.

</br>

## Key Findings

### The Statistical Outlier Detector
Identifies 'High Risk' entries where an individuals error rate is considerably higher than the peer group average for their specific 
time of day and fatigue level.

| Time_of_Day | Fatigue_Level | Error_Rate | Benchmark | Difference | Z_Score | 
| :---: | :---: | :---: | :---: | :---: | :---: | 
| Afternoon | High | 0.359 | 0.093 | 0.266 | 4.166 | 
| Evening | High | 0.336 | 0.094 | 0.242 | 3.776 | 
| Afternoon | High | 0.328 | 0.093 | 0.235 | 3.680 | 
| Night | High | 0.326 | 0.093 | 0.233 | 3.663 | 
| Afternoon | High | 0.323 | 0.093 | 0.230 | 3.602 | 
| Night | High | 0.321 | 0.093 | 0.228 | 3.584 | 
| Afternoon | High | 0.316 | 0.093 | 0.223 | 3.493 | 
| Evening | High | 0.311 | 0.094 | 0.217 | 3.386 | 
| Evening | High | 0.303 | 0.094 | 0.209 | 3.261 | 
| Evening | High | 0.297 | 0.094 | 0.203 | 3.167 | 
| Afternoon | High | 0.296 | 0.093 | 0.203 | 3.180 | 
| Evening | High | 0.295 | 0.094 | 0.201 | 3.136 | 
| ... | ... | ... | ... | ... | ... | 

#### Analysis Highlights
- **The "Afternoon Slump"**: From this dataset we can see that the highest density of error-rate outliers (2 standard deviations above the mean) occurs during the afternoon in individuals already at High or Moderate fatigue levels. This signals a productivity "danger zone" where decision quality drops sharply.
- **Demographics**: Only 2.12% (531 cases) were flagged as "Statistical Outliers". This small group represents the "Critical Risk" category where the system recommendation should from "Slow Down" to "Take Break". 

-----

</br>

### Decile Based Performance Profiling
This utilizes ```NTILE(10)``` to divide the population into risk deciles based on their ```Decision_Fatigue_Score```. For each decile you'll see the ```Average_Stress_Level_1_10``` and the percentage of ```System_Recommendation```. 

| Decision_Fatigue_Score_Percentile | Avg_Stress_level_1_10 | Take_Break_% | Continue_% | Slow_Down_% | 
| :---: | :---: | :---: | :---: | :---: | 
| 1 | 1.40 | 0 | 100 | 0 | 
| 2 | 1.42 | 0 | 100 | 0 | 
| 3 | 1.46 | 0 | 100 | 0 | 
| 4 | 1.77 | 0 | 100 | 0 | 
| 5 | 1.97 | 0 | 69.12 | 30.88 | 
| 6 | 2.22 | 0 | 0 | 100 |
| 7 | 2.49 | 36.16 | 0 | 63.84 | 
| 8 | 2.46 | 100 | 0 | 0 | 
| 9 | 3.07 | 100 | 0 | 0 | 
| 10 | 3.47 | 100 | 0 | 0 | 

#### Analysis Highlights
- **Stress as a Leading Indicator**: There is a direct correlation between the risk decile and ```Avg_Stress_Level_1_10```. As users move from Decile 1 to Decile 10, average stress levels rise significantly.
- **The "Take Break" Inflection Point**: In the highest deciles (8-10), the ```System_Recommendation``` of "Take Break" becomes nearly universal. This identifies a critical threshold where cognitive load and hours awake converge into a high-risk state. 

-----

</br>

### The Fatigue Slope
This query identifies "Stress Spikes" where an individual's stress level is 20% higher than their cohort's average (partitioned by ```Time_of_Day``` and ```Hours_Awake```).

| Hours_Awake | Time_of_Day | Stress_Level_1_10 | Avg_Stress_For_Hour | Stress_Delta | System_Recommendation | 
| :---: | :---: | :---: | :---: | :---: | :---: | 
| 17 | Afternoon | 8.4 | 3.62 | 4.78 | Take Break | 
| 17 | Morning | 7.8 | 3.32 | 4.48 | Take Break | 
| 17 | Morning | 7.7 | 3.32 | 4.38 | Take Break | 
| 17 | Morning | 7.5 | 3.32 | 4.18 | Take Break | 
| 17 | Afternoon | 7.7 | 3.62 | 4.08 | Take Break | 
| 17 | Morning | 7.3 | 3.32 | 3.98 | Take Break | 
| 17 | Evening | 7.4 | 3.45 | 3.95 | Take Break | 
| 17 | Night | 7.4 | 3.48 | 3.92 | Take Break | 
| 17 | Morning | 7.2 | 3.32 | 3.88 | Take Break | 
| 17 | Afternoon | 7.5 | 3.62 | 3.88 | Take Break | 
| 17 | Afternoon | 7.5 | 3.62 | 3.88 | Take Break | 
| 17 | Night | 7.3 | 3.48 | 3.82 | Take Break | 
| ... | ... | ... | ... | ... | ... | 

#### Analysis Highlights
- **The 20% Stress Threshold**: Approximately 29.5% of individuals across all times of day exhibit "Stress Spikes", where their stress levels are significantly higher than the average for their specific "Hours Awake" cohort.
- **Predictive Fatigue Slopes**: Stress levels show a linear progression to hours awake; however, the "Spike" frequency remains consistent across Morning, Afternoon and Night. This suggests that "Decision Fatigue" is more closely tied to duration of wakefullness than the specific clock time.

-----

