# SQL-Data-Analysis-Portfolio

</br>

## The Tech Stack
All analysis in this repo is written in SQL, specifically optimized for DuckDB. Why, you may ask? DuckDB is a high-performance analytical database that uses PostgreSQL-compatible syntax but runs locally without a heavy server. Installation is fairly easy and it can be ran right in your browser, for example. 

### How to Run these Projects
1. **Download DuckDB**: Visit [this](https://motherduck.com/blog/duckdb-tutorial-for-beginners/) website for more information on setup and further documentation.
2. **Launch**: Open your terminal and type ```duckdb```. I personally run my queries in my browser as initialization and shutdown are very fast.
3. **Query**: No matter the method of installation or launch, you are now ready to query ```.csv``` files directly.

</br>

## Synthetic and Real World Challenges
These folders contain a structured progression of SQL and data analysis challenges, starting from foundational querying and moving to advanced analytical problem solving. Although separated, this repository intentionally includes both synthetic and real datasets. While synthetic data allows for practicing without any noise and easily controlled scenarios, the real world datasets have inconsistency and can be messy to handle. In general, this repository represents technical development and a structured approach to skill building in SQL and data analysis.

</br> 

### Project Highlights & Key Findings

-----

#### Real World: CT Drug Overdose Analysis
- **The Poly-Substance Shift**: Documented the evolution of the crisis from a single-substabce issue (Heroin) to a deadly poly-substance edpidemic, dominated by Cocaine and Fentanyl combinations.
- **Demographic Aging**: Observed a significant upward trend in the average age of victims, rising from 40.7 in 2012 to 48.5 in 2024.
- **Urban Spread**: While major hubs like Hartford remain primary centers, YoY data shows growth in mid-size municipalities.

</br>

#### Synthetic: AI Impact Analysis
- **At-Risk Detection**: Identified that 25.3% of the student population falls into a high-risk category defined as high AI usage dependency paired with low AI ethics score.
- **"Underdog" Success Patterns**: Found that "Underdog" students (bottom 25% of score but top 10% improvement rate) use AI differently. They focus on doubt-solving and note-taking rather than content generation.
- **Efficiency vs. Frequency**: Data suggests that purposeful use outweighs frequency; high-improving students actually spend less time on AI per day than the average.

</br>

#### Synthetic: Decision Fatigue Analysis
- **The "Afternoon Slump"**: Statistical outlier detection revealed a productivity "danger zone" in the afternoon where error rates spike significantly for fatigued individuals.
- **Predictive Fatigue**: Analyis proved that decision fatigue is more closely tied to duration of wakefulness rather than the specific clock time.
- **Critical Thresholds**: Identified a "Take Break" inflection point in the top 30% of fatigue deciles where cognitive load and stress converge into high-risk states

</br>

#### Synthetic: Medical Cost Analysis
- **The "Smoking Premium"**: Identified that smoking is the most significant driver of medical costs, with smokers incurring 3.8x higher charges (roughly $32,050) compared to non-smokers (roughly $8,434).
- **Risk Concentration**: Discovered that a small "High Risk" cohort (under 5% of the population) accounts for nearly 16% of medical expenses.
- **Regional Insights**: The Southeast region represents the highest financial risk, containing both the highest average charges and the single most expensive policyholder ($63,770).

-----
