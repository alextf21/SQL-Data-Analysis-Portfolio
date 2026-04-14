## Brief Overview
Data can be found in the relative folder but just for context, these are drug related deaths from 2012-2024. With about 13k rows and 48 columns, this contains the toxicity 
report, location info such as county, and also the manner of death. For more information and to view the full change catalog, visit the associated data.ct.gov website [here](https://data.ct.gov/Health-and-Human-Services/Accidental-Drug-Related-Deaths-2012-2024/rybz-nyjw/about_data). 

</br>

## Column Reference
| Category | Columns |
| :------------- |:-------------|
| **Case Identification**      | ```Date```, ```Date Type```, ```Manner of Death```, ```Cause of Death```, ```Other Significant Conditions```|
| **Demographics**      | ```Age```, ```Sex```, ```Race```, ```Ethnicity``` |
| **Residence Location** | ```Residence City```,  ```Residence County```, ```Residence State```, ```ResidenceCityGeo``` |
| **Injury Location** | ```Injury City```,  ```Injury County```, ```Injury State```, ```Injury Place```, ```Description of Injury```, ```InjuryCityGeo```|
| **Death Location** | ```Death City```, ```Death County```, ```Death State```, ```Location```, ```Location if Other```, ```DeathCityGeo``` |
| **Toxicology (Opioids)** | ```Heroin```, ```Heroin death certificate (DC)```, ```Heroin/Morph/Codeine```, ```Fentanyl```, ```Fentanyl Analogue```, ```Any Opioid```, ```Other Opioid```, ```Oxycodone```, ```Hydrocodone```, ```Hydromorphone```, ```Methadone```, ```Morphine (Not Heroin)```, ```Tramad```, ```Opiate NOS``` |
| **Toxicology (Other)** | ```Cocaine```, ```Ethanol```, ```Benzodiazepine```, ```Meth/Amphetamine```, ```Amphet```, ```Xylazine```, ```Gabapentin```, ```Other``` |

 </br>

## Annual Connecticut Drug Overdose Trends (2012-2024)
This table aggregates yearly overdose deaths in CT and tracks a few key indicators including total fatalities, the year-over-year percentage difference, average victim age, the average count of drugs per person, the top 2 death cities, and the top drug combinations. 

| Year | Total Overdoses | YoY Difference % | Average Age | Average Drug Count Per Person | Top Death Cities | Top Drug Combination |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | 
| 2012 | 353 | ```NULL``` | 40.7 | 1.71 | New Haven & Hartford | Cocaine & Heroin |
| 2013 | 477 | 26 | 41.3 | 1.65 | Hartford & New Haven | Cocaine & Heroin |
| 2014 | 557 | 14.36 | 41.5 | 1.91 | Hartford & New Haven | Ethanol & Heroin |
| 2015 | 721 | 22.75 | 42.2 | 2.67 | Hartford & Waterbury | Heroin & Heroin/Morph/Codeine |
| 2016 | 917 | 21.37 | 42.1 | 2.88 | Hartford & New Haven | Heroin & Heroin/Morph/Codeine |
| 2017 | 1038 | 11.66 | 41.7 | 2.52 | Hartford & Bridgeport | Fentanyl & Heroin |
| 2018 | 1017 | -2.06 | 42.8 | 2.97 | Hartford & Waterbury | Heroin & Heroin/Morph/Codeine |
| 2019 | 1200 | 15.25 | 43.3 | 2.80 | Hartford & Waterbury | Cocaine & Fentanyl |
| 2020 | 1374 | 12.66 | 43.7 | 2.39 | Hartford & Waterbury | Cocaine & Fentanyl | 
| 2021 | 1524 | 9.84 | 45.8 | 2.49 | Hartford & New Haven | Cocaine & Fentanyl |
| 2022 | 1452 | -4.96 | 46.6 | 2.40 | ```NULL``` | Cocaine & Fentanyl |
| 2023 | 1327 | -9.42 | 48 | 2.46 | ```NULL``` | Cocaine & Fentanyl | 
| 2024 | 982 | -35.13 | 48.5 | 2.27 | ```NULL``` | Cocaine & Fentanyl |

-----

### Analysis Highlights
- **Geographical Trends**: Hartford and New Haven consistently rank as the top two cities for accidental drug-related deaths for nearly every year in the 12-year span. While the largest cities remain the primary hubs, the YoY (Year-over-Year) percentage difference logic highlights periods of rapid growth in mid-sized municipalities like Waterbury and Bridgeport, suggesting the crisis is not confined to the major urban centers. Unfortunately, there was no "Death City" data collected from 2022-2024 so these data points are null. 
- **Demographic Shifts**: The query tracks the "Average Age" of victims, which has trended upwards over the last decade. This suggests that while the younger population was the initial focus of the crisis, the current epidemic is affecting older adults, likely due to long-term dependency or the increased lethality of the current supply.
- **Rise in Poly-Substance Use**: The data suggests that the crisis has evolved from a single-substance issue (primarily heroin) into a poly-substance epidemic. The presence of 3 or more substances in the average toxicology report highlights the extreme danger in the current supply, as multiple drug interactions make medical intervention more difficult. 

-----

### Technical Methodology
- **Data Transformation (Unpivoting)**: The raw dataset stored drug types in wide-format columns (e.g., separate columns for Heroin, Cocaine, Fentanyl). I used an ```UNPIVOT``` operation to transform these into a long-format 'one drug per row' structure, enabling granular analysis.
- **Combinatorial Anlaysis**: By performing a Self-Join on the unpivoted data (constrained by ```CaseID```), I identified every unique pair of drugs present in each individual case.
- **Ranking and Aggregation**: I utilized ```RANK()``` window functions partitioned by ```Year``` to isolate the most frequent drug combinations and cities, and connected these back to the main statistics via ```LEFT JOIN``` for a unified yearly report.
- **Note on the "Any Opioid" Column**: I filtered out the "Any Opioid" column to avoid potential double counting. 


