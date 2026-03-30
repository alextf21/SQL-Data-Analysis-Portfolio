# Advanced Analysis Breakdown
Visit [this link](https://github.com/alextf21/SQL-Data-Analysis-Portfolio/blob/main/Synthetic%20Projects/Medical%20Cost%20Analysis/Advanced_Medical_Cost_Breakdown.md) for the overview of the 5 scripts in the associated advanced analysis .sql file. Different than the ones 
in the general analysis file explained below. 

</br>

# Data Overview
With 7 columns and 1338 rows, this dataset contains cotains information regarding individual medical insurance costs and the factors that influence them.
More info can be found in the following [Kaggle link](https://www.kaggle.com/datasets/mosapabdelghany/medical-insurance-cost-dataset).

## Column Reference
| Category | Columns|
| :-------------|:-------------|
| **Demographic & Geographic**      | ```age```, ```sex```, ```region```   |
| **Health & Lifestyle**      | ```bmi```, ```smoker```  |
| **Family** | ```children```   |
| **Financial** | ```charges``` |

</br>

## Key Findings
### Executive Summary
This high-level query was designed for dashboards to provide a brief overview on policyholder demographics and cost drivers.

| Total Policyholders | Average Charges ($) | Number of Smokers | Average Smoker Charges ($) | Region with Highest Average Charges | 
|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|
| 1338 | 13,270.42 | 274 | 32,050.23 | southeast | 

#### Analysis Highlights
- **The 'Smoking Premium' Gap**: Smoking is the most significant driver of medical costs. On average, smoking incur 3.8x higher charges ($32,050) compared to non-smokers ($8,434). Or a cost increase of $23,615 per year per smoking policyholder.
- **Regional Concentration**: The Southeast region represents the highest financial risk, not only having the highest average charges ($14,735.41) but also containing the single most expensive policyholder in the entire dataset ($63,770.43). 

---

### Risk Concentration
This query isolates the financial weight of the most vulnerable demographic segments.
| Total Charges ($) | Charges from High Risk Policyholders ($) | High Risk Contribution (%) | High Risk Policyholders Count | High Risk Population (%) | 
|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|
| 17,755,824.99 | 2,786,767.53 | 15.69 | 64 | 4.78 | 

#### Analysis Highlights
- **Disproportionate Impact**: A small cohort of 'High-Risk' policyholders (Smokers, Age 45+, BMI 28+) represents less than 5% of the population but accounts for nearly 16% of all medical expenses.
- **Cost Multiplier**: The average charge for a policyholder in this high-risk segment is approximately $43,543, which is 3.3x higher than the average policyholder ($13,270).
