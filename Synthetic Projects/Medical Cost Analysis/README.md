# Advanced Analysis Breakdown
Visit [this link](https://github.com/alextf21/SQL-Data-Analysis-Portfolio/blob/main/Synthetic%20Projects/Medical%20Cost%20Analysis/Advanced_Medical_Cost_Breakdown.md) for the overview of the 5 scripts in the associated advanced analysis .sql file. Different than the ones 
in the general analysis file explained below. 

</br>

# Data Overview
With 7 columns and 1338 rows, this dataset contains cotains information regarding individual medical insurance costs and the factors that influence them.
More info can be found in the following [Kaggle link](https://www.kaggle.com/datasets/mosapabdelghany/medical-insurance-cost-dataset).

## Column Reference
| Category | Columns|
| :-------------: |:-------------:|
| **Demographic & Geographic**      | ```age```, ```sex```, ```region```   |
| **Health & Lifestyle**      | ```bmi```, ```smoker```  |
| **Family** | ```children```   |
| **Financial** | ```charges``` |

</br>

## 1. Foundational Exploration
In the first 2 sections, you can see a focus on understanding the distribution and cost outliers.
- **Segmenting by Lifestyle**: Simple ```GROUP BY``` and ```AVG``` functions were used to compare charges between smokers and non-smokers.
- **Filtering by Health Metrics**: Used subqueries to isolate 'above averge' BMI policyholders.

</br>

## 2. Intermediate Bucketing
To make the data more readable, I used ```CASE``` statements to transform variables into meaningful categories.
- **Age & BMI Bracketing**: Instead of looking at individual ages and BMI figures, I created age groups and BMI categories. You can then filter or aggregate
on this newly created column.

</br>

## 3. Advanced Analytical Logic
The final section contains a few advanced queries that are separate from the advanced analysis file in this directory. These provide deeper 
context and summarized insights.
- **Window Functions**: Used ```OVER()``` to calculate how much a policyholders charges deviate from their regions average.
- **Executive Summary**: This query provides a snapshot of the entire dataset by totaling the number of smokers, displaying average charges, total
policyholders, and the region with the highest average charges.
