-- EDA --

-- Taking note of the timeline in which these layoffs happened -- 
SELECT Min(`date`), Max(`date`)
FROM layoffs_sample2;

-- The timeline of these layoffs is between 2020-2023 -- 

 -- Year with the highest Layoff 
SELECT YEAR(`date`) AS YEAR, SUM(total_laid_off)
FROM layoffs_sample2
GROUP BY YEAR (`date`)  
ORDER BY 2 DESC ;


-- The max total laid off and the percentage laid off 1 representing 100% 

SELECT  MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_sample2;

-- Companies that went under completely regardless of having a lot of funding 
SELECT* 
FROM layoffs_sample2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

SELECT company, total_laid_off, funds_raised_millions
FROM layoffs_sample2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC 
LIMIT 5;

-- Companies with the most Total Layoffs

SELECT company, SUM(total_laid_off)
FROM layoffs_sample2
GROUP BY company  
ORDER BY 2 DESC ;

-- Industries that had the highest layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_sample2
GROUP BY industry  
ORDER BY 2 DESC ;


-- Country that had the highest layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_sample2
GROUP BY country  
ORDER BY 2 DESC ;


-- Location with the most Total Layoffs
SELECT location, SUM(total_laid_off)
FROM layoffs_sample2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- Companies stages 
SELECT stage, SUM(total_laid_off)
FROM layoffs_sample2
GROUP BY stage
ORDER BY 2 DESC;


-- Companies with the most layoff per year.


WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_sample2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;



-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_sample2
GROUP BY dates
ORDER BY dates ASC;

--  using a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_sample2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;

