# World Layoffs: Data Cleaning & Exploratory Analysis
## Project Overview
>> The objective of this project was to take a raw, unorganized dataset of global layoffs and transform it into a structured, clean format for analysis. After the cleaning process, I performed EDA to uncover trends regarding which companies, industries, and countries were most affected by layoffs during the COVID-119 pandemic and the subsequent economic shifts.

#### Dataset

> - Source: Kaggle / Real-world tech layoff data.
- Time Range: March 2020 – March 2023.
- Key Columns: Company, Location, Industry, Total Laid Off, Percentage Laid Off, Date, Stage, Country, Funds Raised.

#### Tools Used
- Database: MySQL Workbench
- SQL Techniques: CTEs, Window Functions (ROW_NUMBER, DENSE_RANK), String Functions (TRIM, SUBSTRING), Joins, and Data Type Conversions (STR_TO_DATE).

SQL SCRIPT 1: Data Cleaning
>In professional environments, working directly on raw data is risky. I created a staging table (layoffs_staging) to preserve the original records while performing the following steps:
Remove Duplicates: Used ROW_NUMBER() over all columns to identify identical rows and deleted those with a rank higher than 1.

###### Standardize Data:
> * Trimmed unnecessary white space from the company names.
* Standardized industry names (e.g., merged various "Crypto" labels into one uniform "Crypto" industry).
* Fixed trailing punctuation in country names (e.g., "United States.").
* Date Formatting: Converted the date column from a text format to a standard SQL DATE format using STR_TO_DATE.
* Handle Null/Blank Values:
* Populated missing industry values by joining the table to itself where the company name matched but the industry was missing.
* Removed rows where both total_laid_off and percentage_laid_off were null, as these records provided no actionable insights for the analysis.
* Remove Unnecessary Columns: Dropped the helper column row_num used during duplicate removal.

#### Phase 2: Exploratory Data Analysis (EDA)
With the cleaned data, I explored the layoffs to find significant patterns:
###### Key Findings:
* The Hardest Hit: Companies like Amazon, Google, Meta, and Microsoft saw the largest individual layoff events (exceeding 10,000+ people).
* Industry Trends: The Consumer and Retail industries were hit hardest overall, reflecting the impact of the pandemic on physical commerce and consumer behavior.
* Geographic Focus: The United States reported significantly higher layoff numbers than any other country in this dataset.
- Year-over-Year Progression:
> 2020 started with a spike due to the initial pandemic lockdowns.
2022 was the most devastating year for tech layoffs.
Data for early 2023 showed that the trend was accelerating, with over 125,000 layoffs in just the first three months.
###### Notable Queries:
- Rolling Totals: Calculated the month-by-month rolling total of layoffs across the entire three-year period.
- Top 5 Rankings: Used CTEs and DENSE_RANK() to rank the top 5 companies per year with the most layoffs.
