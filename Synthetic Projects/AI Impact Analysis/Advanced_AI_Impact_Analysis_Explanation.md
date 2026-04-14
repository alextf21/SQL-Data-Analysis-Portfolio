# Advanced Analysis: Comlpex Queries
This contains explanations that go beyond basic aggregation to perform peer-to-peer comparison, ranking, ethical benchmarking, and predictive 'underdog' detection.

</br>

## 1. Peer Performance Gap Analysis
**Objective**: Determine how a student compares to their immediate academic neighbors within the same grade level.
### Logic and Window Functions:
- ```RANK() OVER(PARTITION BY grade_level...)```: Assigns a rank to each student based on their score within their specific grade level.
- ```LAG()``` & ```LEAD()```: These window functions allow us to look at the score of the student ranked immediately above and below the current row. This calculates the
'Points Behind' and 'Points Ahead' metrics.
- ```MAX() OVER()```: Used to calculate the 'Gap to Leader', showing how far a student is from the top performer in their class.

| student_id | grade_level | final_score | rank | points_behind | points_ahead | gap_to_leader |
| :---: | :---:| :---:| :---:| :---:| :---:| :---: |
| 7720 | 11th | 95.8 | 1 | ```NULL``` | 2.4 | 0 | 
| 7479 | 12th | 92.8 | 1 | ```NULL``` | 1.3 | 0 |
| 7981 | 10th | 94.8 | 1 | ```NULL``` | 0.4 | 0 |
| 1864 | 2nd Year | 94.3 | 1 | ```NULL``` | 2.3 | 0 | 
| 7012 | 1st Year | 93.1 | 1 | ```NULL``` | 0.1 | 0 | 
| 5230 | 3rd Year | 93.8 | 1 | ```NULL``` | 0.3 | 0 | 
| 5478 | 11th | 93.4 | 2 | -2.4 | 0.4 | -2.4 | 
| 3514 | 12th | 91.5 | 2 | -1.3 | 1.1 | -1.3 | 
| 4029 | 10th | 94.4 | 2 | -0.4 | 0.3 | -0.4 | 
| 575 | 2nd Year | 92 | 2 | -2.3 | 0.7 | -2.3 | 
| 1195 | 1st Year | 93 | 2 | -0.1 | 1.9 | -0.1 | 
| 2161 | 3rd Year | 93.5 | 2 | -0.3 | 0.6 | -0.3 |

-----

</br>

## 2. AI Dependency vs. Ethics Benchmark
**Objective**: Identify 'at-risk' students who rely heavily on AI but have a low understanding of AI ethics.
### Logic:
- **Common Table Expression (CTE)**: I first define a CTE named ```esfs``` (shorthand for 'Ethics Score Final Score') to calculate the average ethics, dependency, and
final score for each grade level.
- **JOIN Logic**: I then join this CTE back to the main impact table to compare individual student scores against their grade level averages.
- **Flagging**: A ```CASE``` statement flags students as 'Y' if their dependency is above average while their ethics score is below average. In practice, this would
allow for targeted educational intervention.

| student_id | grade_level | ai_ethics_score | ethics_deviation | final_score | final_score_deviation | flag | 
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | 
| 1 | 1st Year | 5 | -0.45 | 36.8 | -19.9 | Y | 
| 2 | 12th | 1 | -4.35 | 65.5 | 8.56 | ```NULL``` | 
| 3 | 3rd Year | 5 | -0.59 | 66.3 | 9.1 | Y | 
| 4 | 12th | 10 | 4.65 | 69.5 | 12.56 | ```NULL``` | 
| 5 | 3rd Year | 10 | 4.41 | 49.7 | -7.5 | ```NULL``` |
| 6 | 1st Year | 6 | 0.55 | 77.9 | 21.2 | ```NULL``` | 
| 7 | 1st Year | 5 | -0.45 | 82.2 | 25.5 | Y | 
| 8 | 3rd Year | 6 | 0.41 | 52.7 | -4.5 | ```NULL``` | 
| 9 | 10th | 9 | 3.43 | 81.7 | 24.81 | ```NULL``` | 
| 10 | 1st Year | 7 | 1.55 | 66.7 | 10 | ```NULL``` | 
| 11 | 10th | 5 | -0.57 | 54.3 | -2.59 | Y | 
| 12 | 10th | 10 | 4.43 | 50.7 | -6.19 | ```NULL``` | 

-----

</br>

## 3. Fastest Risers (Underdog Detection)
**Objective**: Find students who currently have low scores but show the highest potential for growth with a high improvement rate. 
The 'Underdog Criteria':
1. Student must be in the bottom 25% of ```final_score```.
2. Student must be in the top 10% of ```improvement_rate```.

**Technique**: ```PERCENT_RANK()```

I used ```PERCENT_RANK()``` partitioned by grade_level. This allows you to find the exact percentile for every student, making it easy to filter for specific 'Underdog'
criteria regardless of the varying score distributions across different grades.


| student_id | grade_level | improvement_rate_percentile | score_percentile | 
| :---: | :---: | :---: | :---: |
| 3559 | 3rd Year | 7.43 | 76.44 | 
| 4095 | 10th | 6.85 | 75.65 | 
| 2792 | 3rd Year | 5.40 | 76.89 | 
| 736 | 1st Year | 2.36 | 75.13 | 
| 769 | 1st Year | 1.33 | 75.13 | 
| 3791 | 12th | 6.82 | 75.38 | 
| 372 | 1st Year | 1.77 | 75.65 | 
| 1147 | 10th | 6.03 | 76.40 | 
| 1826 | 10th | 4.84 | 76.55 | 
| 2482 | 10th | 2.16 | 76.84 | 
| 1342 | 2nd Year | 4.05 | 75.99 | 
| 6082 | 3rd Year | 6.60 | 77.79 | 




