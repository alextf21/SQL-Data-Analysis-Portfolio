# Advanced Queries Breakdown
Visit [this link](https://github.com/alextf21/SQL-Data-Analysis-Portfolio/blob/main/Synthetic%20Projects/Decision%20Fatigue%20Analysis/Advanced_Fatigue_Analysis_Breakdown.md) 
for a breakdown of the complex queries.

</br>

# Dataset Overview
This project analyzes a dataset of 25,000 records tracking coginitive load, sleep, and performance metrics. The main goal is to investigate how variables such
as sleep, hours awake, and time of day influence decision making accuracy, error rates, and cognitive load. Think of each record as a representation of a 
simulated decision being made. For more info, visit the [Kaggle link](https://www.kaggle.com/datasets/sonalshinde123/human-decision-fatigue-behavioral-dataset). 

## Column Reference
| Category | Columns|
| :------------- |:-------------|
| **Temporal & Lifestyle**      | ```Hours_Awake```, ```Sleep_Hours_Last_Night```, ```Time_of_Day```   |
| **Activity Metrics**      | ```Decisions_Made```, ```Task_Switches```, ```Avg_Decision_Time_sec```   |
| **Physiological Factors/State** | ```Caffeine_Intake_Cups```, ```Stress_Level_1_10```, ```Cognitive_Load_Score```   |
| **Performance Outcomes** | ```Error_Rate``` |
| **Fatigue Analysis** | ```Decision_Fatigue_Score```, ```Fatigue_Level```, ```System_Recommendation```   |

</br>

## Key Findings
### Fatigue Distribution
The following table summarizes the average decision fatigue, error rates, and break recommendations across different times of day:

| Time of Day | Average Decision Fatigue Score | Average Error Rate | High Fatigue (%) | Take Break Recommendation (%) | 
| :-------------: |:-------------:|:-------------:|:-------------:|:-------------:|
| Morning | 40.23 | 0.03176 | 33.22 | 33.22 |
| Afternoon | 40.45 | 0.03176 | 33.75 | 33.75 |
| Evening | 41.12 | 0.03254 | 34.13 | 34.13 |
| Night | 40.53 | 0.03125 | 33.08 | 33.08 |

#### Analysis Highlights
- **Peak Fatigue in the Evening**: The data indicates that decision fatigue and error rates reach their peak during evening hours. This hints at higher probabilities of errors after a cognitive load that builds during the day. 
- **Error Rate Correlation**: There is a visible dependency between the ```AvgDecisionFatigueScore``` and the ```AvgErrorRate```, reinforcing the theory that as cognitive resources deplete, the accuracy of decision making decreases. This also leaves room for a refinement opportunity. You can fine tune the criteria by incorporating 'pre-emptive' break logic that would recommend a 'Short Walk' or 'Slow Down' when fatigue is 'Moderate' but the ```Error_Rate``` is trending upwards. You could then mitigate an error before the user reaches a state of high fatigue. 

------

### Risk Segments
This analysis classifies users into risk segments based on their fatigue levels and error rates, measuring cognitive load to identify high-pressure thresholds.

| Time of Day | Average Decision Fatigue Score | Observations Count | Observations (%) |
| :-------------: |:-------------:| :-------------: | :-------------: |
| Low Risk | 1.9477 | 11729 | 46.92 |
| Medium Risk | 3.6431 | 4867 | 19.47 |
| High Risk | 5.1843 | 8404 | 33.62 |

#### Analysis Highlights
- **Cognitive Strain Distribution**: There is a clear, linear relationship between risk segments and cognitive load. Users in the High Risk segment experience nearly 2.6x the cognitive load of those in the low risk segments. Although the majority of observations fall within the 'Low Risk' category (approx. 47%) a significant 33.6% of the activity is currently operating in High Risk zone, suggesting s need for more frequent intervention or task redistribution. 
- **Segment Granularity**: Future iterations of this model could benefit from a weighted risk score that combines ```Hours_Awake``` and ```Task_Switches``` to identify 'at-risk' users before they enter the High Fatigue state.

</br>
