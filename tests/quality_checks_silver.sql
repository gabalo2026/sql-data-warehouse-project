/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

--===================================================================
-- Checking 'silver.crm_cust_info'
--===================================================================

-- Check for nulls or duplicates in Primary Key
-- Expectations: No result
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for unwanted spaces
-- Expectations: No resuts
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Data Standardization & Consistency
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

------------------------------------

SELECT * FROM silver.crm_cust_info

--===================================================================
-- Checking 'silver.crm_prd_info'
--===================================================================

-- Check for nulls or duplicates in Primary Key
-- Expectation: No result
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for unwanted spaces
-- Expectation: No resuts
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for NULLs or negative numbers
-- Expectation: No results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for invalid date orders
-- Expectation: No results
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

------------------------------------

SELECT *
FROM silver.crm_prd_info

--===================================================================
-- Checking 'silver.crm_sales_details'
--===================================================================

-- Check for invalid dates
SELECT
	sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > '20500101'
	OR sls_order_dt < '19000101'

SELECT
	sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_ship_dt > '20500101'
	OR sls_ship_dt < '19000101'

SELECT
	sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt > '20500101'
	OR sls_due_dt < '19000101'

-- Check for invalid date orders
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt > sls_due_dt

-- Check data consistency: between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- Values must not be NULL, zero, or negative

SELECT DISTINCT
	sls_sales AS old_sls_sales,
	sls_quantity,
	sls_price AS old_sls_price,
	sls_sales,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
	OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

--Rules:
--If Sales is negative, zero, or null, derive it using Quantity and Price.
--if Price is zero or null, calculate it using Sales and Quantity.
--If Price is negative, convert it to a positive value

----------------------------

SELECT * FROM silver.crm_sales_details

--===================================================================
-- Checking 'silver.erp_cust_az12'
--===================================================================

-- Identify out-of-range dates
SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate  < '1924-01-01' OR bdate  > GETDATE()

-- Data Standardizatio & Consistency
SELECT DISTINCT gen 
FROM silver.erp_cust_az12

----------------------------------

SELECT * FROM silver.erp_cust_az12

--===================================================================
-- Checking 'silver.erp_loc_a101'
--===================================================================

-- Data Standardizatio & Consistency
SELECT DISTINCT cntry 
FROM silver.erp_loc_a101
ORDER BY cntry

------------------------------

SELECT * FROM silver.erp_loc_a101

--===================================================================
-- Checking 'silver.erp_px_cat_g1v2'
--===================================================================

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT maintenance 
FROM silver.erp_px_cat_g1v2;

------------------------------

SELECT * FROM silver.erp_px_cat_g1v2
