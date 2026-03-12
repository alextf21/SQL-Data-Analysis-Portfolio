# Breakdown of Advanced Scripts
Below are the full explanations for 3 SQL queries that move from basic data retrieval to statistical anomaly detection, decile-based profiling, and 
benchmark comparisons.

</br>

## 1. The Statistical Outlier Detector
**Puropose**: Identify 'High Risk' entries where an individuals error rate is considerably higher than the peer group average for their specific 
time of day and fatigue level.

### SQL Techniques
- **Common Table Expressions** (CTEs) to aggregate group statistics.
- **Standard Deviation** (STDDEV) for statistical thresholding.
- **Inner Joins** to benchmark granular data against group means.

</br>

## 2. Decile Based Performance Profiling
**Purpose**: Analyze how the systems 'Take Break' recommenadations correlate with different risk buckets of decision fatigue score.

### SQL Techniques
- ```NTILE(10)``` window function to create statistical deciles.
- **Conditional Aggregation** using ```FILTER``` (or ```CASE WHEN```) to calculate percentage rates.

</br>

## 3. Multi-Factor Benchmark Comparison
**Purpose**: Create a 'Fatigue Index' by normalizing an individuals cognitive load against the 'Global Low' and 'Global High' 
benchmarks of the dataset

### SQL Techniques
- **Multi CTE** architecture for isolated metric calculations.
- **Feature Engineering**: Creating a normalized index (0.0 - 1.0)
