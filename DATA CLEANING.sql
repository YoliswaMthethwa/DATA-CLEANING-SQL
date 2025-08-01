-- Data Cleaning

SELECT *
FROM layoffs;
 
 -- 1. Remove Duplicates
 -- 2. Standardize the data
 -- 3. Looks at NULL values or Blank values
 -- 4. Remove any columns or rows
 
 CREATE TABLE layoffs_staging
 LIKE layoffs;
 
SELECT *
FROM layoffs_staging;
 
 INSERT layoffs_staging
 SELECT *
 FROM layoffs;
 

 -- Removing Dupilcates
 WITH duplicate_cte AS
 (
 SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- CTEs are not undaptable
CREATE TABLE `layoffs_staging2` (
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

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num >1;

DELETE
FROM layoffs_staging2
WHERE row_num >1;

SELECT *
FROM layoffs_staging2
WHERE company= 'Casper';

-- Standardaizing data
SELECT company,TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT industry
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, TRIM(TRAILING '.'FROM country)
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%';


UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.'FROM country)
WHERE country LIKE 'United States%';

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT *
FROM layoffs_staging2;

-- This line of code is me changing the data type from a text to the actual date data type.
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Removing NULL values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';



SELECT *
FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND  t2.industry IS NOT NULL ;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;



    















 
