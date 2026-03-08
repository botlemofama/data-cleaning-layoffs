# SQL Data Cleaning Project – Global Tech Layoffs Dataset

## Overview
This project focuses on cleaning a real-world dataset containing global tech layoffs. Raw datasets often contain duplicates, inconsistent formatting, missing values, and incorrect data types. The goal of this project is to prepare the dataset for reliable analysis.

The cleaning process was performed using SQL and follows common industry data cleaning practices.

---

## Dataset
The dataset contains information about layoffs across companies worldwide, including:

- Company
- Location
- Industry
- Total employees laid off
- Percentage laid off
- Date of layoffs
- Company stage
- Country
- Funds raised (millions)

---

## Objectives
The main objectives of this project were to:

- Remove duplicate records
- Standardize inconsistent data
- Handle null or missing values
- Convert data types to appropriate formats
- Prepare a clean dataset for exploratory analysis

---

## Data Cleaning Steps

### 1. Creating Staging Tables
A staging table was created to ensure the original dataset remained unchanged while cleaning operations were performed.

### 2. Removing Duplicates
Duplicates were identified using the `ROW_NUMBER()` window function across multiple columns such as:

- company
- location
- industry
- total_laid_off
- percentage_laid_off
- date
- stage
- country
- funds_raised_millions

Duplicate rows were removed while preserving the first occurrence.

### 3. Standardizing Data
Several fields were standardized to ensure consistency:

- Company names were trimmed to remove extra spaces.
- Industry values such as variations of "Crypto" were normalized.
- Country names were cleaned (e.g., removing trailing punctuation).

### 4. Converting Data Types
The `date` column was converted from text format into a proper SQL `DATE` format using `STR_TO_DATE()`.

### 5. Handling Missing Values
Rows with both `total_laid_off` and `percentage_laid_off` missing were removed because they provided no usable analytical value.

### 6. Final Dataset Preparation
Temporary columns used for duplicate detection were removed to produce the final cleaned dataset.

---

## SQL Concepts Used

This project demonstrates the following SQL skills:

- Window Functions (`ROW_NUMBER`)
- Common Table Expressions (CTEs)
- Data Standardization
- Data Type Conversion
- Duplicate Detection
- Data Cleaning Workflows
- Table Alterations

---

## Tools Used

- SQL (MySQL)
- Relational Database Management System

---

## Outcome
The final dataset is a clean and structured version of the layoffs dataset, ready for analysis and visualization.

This cleaned dataset is used in the accompanying **Exploratory Data Analysis (EDA) project**.

---

## Author
Created as part of a SQL portfolio project demonstrating practical data cleaning techniques.
