SELECT *
FROM data;

CREATE TABLE data_staging
LIKE data;

SELECT *
FROM data_staging;

INSERT data_staging
SELECT *
FROM data;

-- REMOVING DUPLICATES
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM data_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM data_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM data_staging
WHERE company = 'Casper';

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM data_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `data_staging2` (
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

SELECT *
FROM data_staging2
WHERE row_num > 1;

INSERT INTO data_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM data_staging;

DELETE
FROM data_staging2
WHERE row_num > 1;


-- STANDARDIZING THE DATA


-- NULL VALUES


-- REMOVING UNNECESSARY COLUMNS