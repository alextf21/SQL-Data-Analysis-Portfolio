# Advanced Queries Breakdown
Visit [this link](https://github.com/alextf21/SQL-Data-Analysis-Portfolio/blob/main/Synthetic%20Projects/Decision%20Fatigue%20Analysis/Advanced_Fatigue_Analysis_Breakdown.md) 
for a breakdown of the complex queries.

</br>

# Overview
This project analyzes a dataset of 25,000 records tracking coginitive load, sleep, and performance metrics. The main goal is to investigate how variables such
as sleep, hours awake, and time of day influence decision making accuracy, error rates, and cognitive load. Think of each record as a representation of a 
simulated decision being made.
The analysis progresses from foundational, descriptive statistics to intermediate queries including risk segmentation and performance benchmarking.

</br>

## Decision Fatigue: Foundational SQL
- **Conditional Logic**: Using ```CASE WHEN``` statements to create custom categories for ```Sleep_Hours``` and ```Hours_Awake```.
- **Filtering and Aggregation**: Using ```WHERE```, ```GROUP BY```, and ```ORDER BY``` to find averages and top pereforming records.



## Decision Fatigue: Intermediate SQL
- **Advanced Filtering**: Using ```FILTER (WHERE...)``` to calculate percentages and distributions.
- **Subqueries**: Dynamically calculating the top 5% of records based on fatigue scores.
- **CTEs**: Building risk segments before performing final aggregations.

</br>

## Key Insights Explored
- Temporal Patterns: Analyzing how decision fluctuates across different times of day.
- Operational Risk: Identifying 'High Risk' segments where high fatigue coincides with an error rate > 10%/
- Final analytical view that could be used by a dashboard that has aggregated data for Time_of_Day. 
