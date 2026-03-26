## Brief Overview
Data can be found in the relative folder but just for context, these are drug related deaths from 2012-2024. With about 13k rows and 48 columns, this contains the toxicity 
report, location info such as county and also the manner of death. For more information and to view the full change catalog, visit the website associated data.ct.gov website [here](https://data.ct.gov/Health-and-Human-Services/Accidental-Drug-Related-Deaths-2012-2024/rybz-nyjw/about_data). 

</br>

## Column Reference
| Category        | Columns           |
| ------------- |:-------------|
| **Case Identification**      | ```Date```, ```Date Type```, ```Manner of Death```, ```Cause of Death```, ```Other Significant Conditions```|
| **Demographics**      | ```Age```, ```Sex```, ```Race```, ```Ethnicity``` |
| **Residence Location** | ```Residence City```,  ```Residence County```, ```Residence State```, ```ResidenceCityGeo``` |
| **Injury Location** | ```Injury City```,  ```Injury County```, ```Injury State```, ```Injury Place```, ```Description of Injury```, ```InjuryCityGeo```|
| **Death Location** | ```Death City```, ```Death County```, ```Death State```, ```Location```, ```Location if Other```, ```DeathCityGeo``` |
| **Toxicology (Opioids)** | ```Heroin```, ```Heroin death certificate (DC)```, ```Heroin/Morph/Codeine```, ```Fentanyl```, ```Fentanyl Analogue```, ```Any Opioid```, ```Other Opioid```, ```Oxycodone```, ```Hydrocodone```, ```Hydromorphone```, ```Methadone```, ```Morphine (Not Heroin)```, ```Tramad```, ```Opiate NOS``` |
| **Toxicology (Other)** | ```Cocaine```, ```Ethanol```, ```Benzodiazepine```, ```Meth/Amphetamine```, ```Amphet```, ```Xylazine```, ```Gabapentin```, ```Other``` |

 </br>

 ## Key Findings
 - **Long-Term Trend**: Drug related deaths show a clear upward trajectory over time with rolling averages confirming sustained growth rather than isolated spikes.
 - **Substance Trends**: Fentanyl has become inscreasingly prevalent over time and now represents a significant share of total overdose deaths. Its dominance suggests not only a shift in the drug supply but also its role in the modern overdose crisis.
- **Demographic Patterns**: A majority of deaths are concentrated among the 35-44 age group, represening the most at-risk range. Male deaths consistently exceed female deaths,
indicating a gender disparity. 

</br>

## Annual Connecticut Drug Overdose Trends (2012-2024)
This table aggregates yearly overdose deaths in CT and tracks a few key indicators including total fatalities, fentanyl involvement
rate and average victim age. As you can see, there is a sharp increase in deaths between 2012 and 2021, coinciding with fentanyl's rapid emergence as the dominant substance present in overdose cases. 

| Year | Total Deaths | Fentanyl Presence (%) | Average Age
| --- | --- | --- | --- |
| 2012 | 355 | 3.66 | 40.8
| 2013 | 490 | 7.35 | 41.4
| 2014 | 558 | 13.44 | 41.6
| 2015 | 729 | 25.93 | 42.3
| 2016 | 917 | 52.56 | 42.1
| 2017 | 1038 | 65.13 | 41.7
| 2018 | 1017 | 74.73 | 42.8
| 2019 | 1200 | 81.58 | 43.3
| 2020 | 1374 | 84.35 | 43.7
| 2021 | 1524 | 85.37 | 45.8
| 2022 | 1424 | 86.29 | 46.6
| 2023 | 1327 | 84.70 | 48
| 2024 | 982 | 77.60 | 48.5
