# Advanced Analysis: Script Explanations
Visit [this link](https://github.com/alextf21/SQL-Data-Analysis-Portfolio/blob/main/Synthetic%20Projects/AI%20Impact%20Analysis/Advanced_AI_Impact_Analysis_Explanation.md) to see the full explanations on more complex queries.

</br>

# Dataset Overview
This dataset explores how different AI tools (ChatGPT, Gemini, Claude) influence student performance and learning efficiency. It covers 6 different grade levels: High school 
(10th-12th) to university level (1st-3rd) year. It contains components from several categories including AI usage purpose, lifestyle, and academic performance. More info can be found on the [Kaggle link](https://www.kaggle.com/datasets/aminasalamt/students-ai-usage-and-academic-performance). 

## Column Reference
| Category | Columns |
| :------------- |:-------------|
| **Identity/Demographics** | ```student_id```, ```age```, ```gender```, ```grade_level``` |
| **AI Integration** | ```uses_ai```, ```ai_usage_time_minutes```, ```ai_tools_used```, ```ai_usage_purpose```, ```ai_dependency_score```, ```ai_generated_content_percentage```, ```ai_prompts_per_week```, ```ai_ethics_score``` |
| **Academic Performance** |   ```last_exam_score```, ```assignment_scores_avg```, ```attendance_percentage```, ```concept_understanding_score```, ```final_score```, ```passed```, ```performance_category```    |
| **Behavioral Habits** |   ```study_hours_per_day```, ```study_consistency_index```, ```improvement_rate```, ```sleep_hours```, ```social_media_hours```, ```tutoring_hours```, ```class_participation_score```    |

</br>

## Key Findings
### Executive Summary Report 
This produces a single row that shows the count of individuals in the dataset, the average final score, the average AI dependency score, the percentage of those who passed (assuming a 55 score however this can be altered), the AI usage purpose that has the lowest average score, and the average study hours of those who passed.

| Total Students | Average Final Score | Average AI Dependency Score | Passed (%) | AI Usage Purpose with Lowest Average Score | Average Study Hours per Day of those who Passed |
| :-------------: |:-------------:|:-------------:|:-------------:|:-------------:|:-------------:| 
| 8000 | 56.81 | 5.52 | 54.96 | Coding | 3.29 |

------

### What-If Scenario
This query assumes a passing score and aggregates the performance category column to determine the average final score of each category, the count of those who passed, and the pass/fail rate.

| Performance Category | Average Final Score | Students Passed | Passed (%) | 
| :-------------: |:-------------:|:-------------:|:-------------:|
| Low | 41.54 | 0 | 0 |
| Medium | 61.24 | 3644 | 77.45 |
| High | 80.70 | 753 | 100 |




