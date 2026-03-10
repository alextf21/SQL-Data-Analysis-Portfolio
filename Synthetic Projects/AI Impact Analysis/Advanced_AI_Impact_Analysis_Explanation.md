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

## 2. AI Dependency vs. Ethics Benchmark
**Objective**: Identify 'at-risk' students who rely heavily on AI but have a low understanding of AI ethics.
### Logic:
- **Common Table Expression (CTE)**: I first define a CTE named ```esfs``` (shorthand for 'Ethics Score Final Score') to calculate the average ethics, dependency, and
final score for each grade level.
- **JOIN Logic**: I then join this CTE back to the main impact table to compare individual student scores against their grade level averages.
- **Flagging**: A ```CASE``` statement flags students as 'Y' if their dependency is above average while their ethics score is below average. In practice, this would
allow for targeted educational intervention.

## 3. Fastest Risers (Underdog Detection)
**Objective**: Find students who currently have low scores but show the highest potential for growth with a high improvement rate. 
The 'Underdog Criteria':
1. Student must be in the bottom 25% of ```final_score```.
2. Student must be in the top 10% of ```improvement_rate```.

**Technique**: ```PERCENT_RANK()```

I used ```PERCENT_RANK()``` partitioned by grade_level. This allows you to find the exact percentile for every student, making it easy to filter for specific 'Underdog'
criteria regardless of the varying score distributions across different grades.

**Code Snippet**:
```
WHERE score_rank >= 0.75          -- Bottom 25% of scores
AND improvement_rate_rank <= 0.1  -- Top 10% of improvement
```
