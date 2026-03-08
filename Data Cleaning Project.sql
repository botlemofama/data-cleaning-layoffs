-- DATA CLEANING PROJECT

-- Drop staging tables if they already exist
DROP TABLE IF EXISTS layoffs_staging;
DROP TABLE IF EXISTS layoffs_staging2;

-- Preview original data
SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns

-- Create a staging table to work on data without affecting the original
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Preview the staging table
SELECT * 
FROM layoffs_staging;

-- Copy data into staging table
INSERT layoffs_staging
SELECT *
FROM layoffs; 

-- Identify potential duplicate rows
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;


-- Find duplicates based on multiple columns
WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num >1;


-- Example: check data for a specific company
SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';


-- Create second staging table with row_num column for deduplication
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
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Check duplicates in the new table
SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

-- Insert data with row numbers for deduplication
INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions
ORDER BY company
) AS row_num
FROM layoffs_staging;


-- Remove duplicate rows
DELETE
FROM layoffs_staging2
WHERE row_num > 1;


-- Preview cleaned staging2 table
SELECT * 
FROM layoffs_staging2;


-- Standardize company names by trimming spaces
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);


-- Standardize industry names
SELECT DISTINCT industry
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Clean up country names (remove trailing dots)
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- Convert date column from text to proper DATE format
SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` LIKE '%/%%';

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- Preview cleaned table
SELECT *
FROM world_layoffs.layoffs_staging2;


-- Leaving the NULL values as they are for calculations for the EDA stage


-- Identify rows with missing key values
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



-- Delete rows with unusable data
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Confirm deletion
SELECT * 
FROM world_layoffs.layoffs_staging2;


-- Remove temporary row_num column now that duplicates are removed
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- Final preview of cleaned data
SELECT * 
FROM world_layoffs.layoffs_staging2;
