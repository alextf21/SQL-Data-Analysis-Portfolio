# Advanced Analysis: Script Explanations
Visit this link to see the full explanations on the more complex queries.

</br>

# AI Impact Analysis: Basic and Intermediate SQL

Key Techniques Used:
- **Subqueries & Having Clause**: To find high performers, I used a subquery within a ```HAVING``` clause to filter for students whose final_score is strictly above
the global average.
- ```FILTER (WHERE ...)``` : A cleaner alternative to ```CASE``` statements for conditional aggregation. This was used to compare the average scores of students 
with high vs. low AI dependency.
- **Executive Summary Report**: The final query in this script serves as a 'one-stop-shop' for stakeholders. It aggregates multiple metrics into a single row so
can see the global average, the pass percentage, the AI usage purpose associated with the highest average scores and metrics for those who passed. 

Other Strategies
- **What if Scenario**: Assume a passing score and determine the average final score, percentage passed for each performance category. Also
uses ```COUNTIF``` function.
- **Data Bucketization**: Using a ```CASE``` statement, I grouped students into brackets (4-5 hours, 5-6 etc.) to determine which sleep duration correlated with
the highest average score. 

