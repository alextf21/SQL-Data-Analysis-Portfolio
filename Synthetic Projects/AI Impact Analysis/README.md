# Advanced Analysis: Script Explanations
Visit [this link](https://github.com/alextf21/SQL-Data-Analysis-Portfolio/blob/main/Synthetic%20Projects/AI%20Impact%20Analysis/Advanced_AI_Impact_Analysis_Explanation.md) to see the full explanations on more complex queries.

</br>

# Dataset Overview
This dataset explores how different AI tools (ChatGPT, Gemini, Claude) influence student performance and learning efficiency. It covers 6 different grade levels: High school 
(10th-12th) to university level (1st-3rd) year. It contains components from several categories including AI usage purpose, lifestyle, and academic performance. More info can be found on the [Kaggle link](https://www.kaggle.com/datasets/aminasalamt/students-ai-usage-and-academic-performance). 

## Column Reference
| Category        | Columns           |
| ------------- |:-------------:|
| **Identity/Demographics**      | ```student_id```, ```age```, ```gender```, ```grade_level``` |
| **AI Integration**      | ```uses_ai```, ```ai_usage_time_minutes```, ```ai_tools_used```, ```ai_usage_purpose```, ```ai_dependency_score```, ```ai_generated_content_percentage```, ```ai_prompts_per_week```, ```ai_ethics_score```      |
| **Academic Performance** |   ```last_exam_score```, ```assignment_scores_avg```, ```attendance_percentage```, ```concept_understanding_score```, ```final_score```, ```passed```, ```performance_category```    |
| **Behavioral Habits** |   ```study_hours_per_day```, ```study_consistency_index```, ```improvement_rate```, ```sleep_hours```, ```social_media_hours```, ```tutoring_hours```, ```class_participation_score```    |

</br>

# AI Impact Analysis: Basic and Intermediate SQL

Key Techniques Used:
- **Subqueries & Having Clause**: To find high performers, I used a subquery within a ```HAVING``` clause to filter for students whose final_score is strictly above
the global average.
- ```FILTER (WHERE ...)``` : A cleaner alternative to ```CASE``` statements for conditional aggregation. This was used to compare the average scores of students 
with high vs. low AI dependency.
- **Executive Summary Report**: The final query in this script serves as a 'one-stop-shop' for stakeholders. It aggregates multiple metrics into a single row so
can see the global average, the pass percentage, the AI usage purpose associated with the highest average scores and metrics for those who passed. 

Other Strategies:
- **What if Scenario**: Assume a passing score and determine the average final score, percentage passed for each performance category. Also
uses ```COUNTIF``` function.
- **Data Bucketization**: Using a ```CASE``` statement, I grouped students into brackets (4-5 hours, 5-6 etc.) to determine which sleep duration correlated with
the highest average score. 

