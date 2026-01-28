-- Data Cleaning --

SELECT * 
FROM layoffs;

-- Create a duplicate table  of the original  

CREATE TABLE layoffs_sample
LIKE layoffs;

-- Insert data into dplicated table --

INSERT layoffs_sample
SELECT* 
FROM layoffs; 

SELECT* 
FROM layoffs;


-- Looking for duplicates rows -- 
SELECT company,  industry, total_laid_off, 'date',
ROW_NUMBER () OVER(PARTITION BY company,  industry, total_laid_off, 'date') AS row_num
FROM layoffs_sample;

-- Creating a temporary table 
With duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER( PARTITION BY company, industry, total_laid_off, 'date', location, stage, funds_raised_millions, percentage_laid_off, country)
AS row_num 
FROM layoffs_sample )

SELECT *
FROM duplicate_cte 
WHERE row_num >1 ;


SELECT * 
FROM layoffs_sample
WHERE company = ' E Inc.';

SELECT *
FROM layoffs_sample
WHERE company = ' Included Health'
;


-- CReating another Table we can modify

CREATE TABLE `layoffs_sample2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creating a new column in the table row_num
INSERT INTO layoffs_sample2
SELECT * ,
ROW_NUMBER() OVER( PARTITION BY company, industry, total_laid_off, 'date', location, stage, funds_raised_millions, percentage_laid_off, country)
AS row_num 
FROM layoffs_sample ;


SELECT *
FROM layoffs_sample2
WHERE row_num > 1 ;

DELETE 
FROM layoffs_sample2
WHERE row_num > 1 ;

SELECT *
FROM layoffs_sample2
WHERE row_num > 1 ;

-- Standardizing the DATA --

SELECT *
FROM layoffs_sample2;

-- Removing Whitespaces from the company column --
SELECT company, TRIM(company)
FROM layoffs_sample2;

-- UPDATING THE TRIM COMPANY COLUMN --
UPDATE layoffs_sample2
SET company = TRIM(company) ;

-- Checking  for a problem in the Industry column-- 
SELECT DISTINCT industry
FROM layoffs_sample2
ORDER BY 1 ;

-- Updating the Industry Column -- 
UPDATE layoffs_sample2 
SET industry = 'Crypto'
WHERE industry Like 'Crypto%';

-- Checking the country column for any error --
SELECT DISTINCT country
FROM layoffs_sample2
ORDER BY 1 ;

-- Updating the Country Column --
UPDATE layoffs_sample2 
SET country = 'United States'
WHERE country Like 'United States%';

-- Changing the Data type of the Date column from text to date datatype -- 

SELECT `date`
FROM layoffs_sample2;

UPDATE layoffs_sample2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_sample2
MODIFY COLUMN `date` DATE;


-- Missing Values and Null values 
-- Update the blank to nulls 

UPDATE layoffs_sample2 
SET industry = NULL
WHERE industry = ""; 

-- now if we check those are all null
SELECT DISTINCT industry 
FROM layoffs_sample2
ORDER BY 1;

-- -- now we need to populate those nulls if possible
UPDATE layoffs_sample2 t1
JOIN layoffs_sample2 t2
  ON  t1.company = t2.company 
  SET t1.industry = t2.industry 
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ; 


-- Check to see if we can populate the miisng values in these columns --
SELECT * 
FROM layoffs_sample2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;

-- Delete Useless data we can't really use
DELETE FROM layoffs_sample2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_sample2;

-- Dropping row_num 
ALTER TABLE layoffs_sample2
DROP COLUMN row_num;


SELECT * 
FROM layoffs_sample2;

