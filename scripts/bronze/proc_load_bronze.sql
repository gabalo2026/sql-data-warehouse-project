/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @rows_inserted int;
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME
	DECLARE @start_time DATETIME, @end_time DATETIME

	BEGIN TRY

		PRINT '================================================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================================================';

		PRINT '--------------------------------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------------------------------------------------------';

		SET @batch_start_time = GETDATE();

		SET @start_time = GETDATE();
		PRINT '>> Truncating Tables: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\pablo.garciaabalo\Downloads\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @rows_inserted = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Rows Inserted: ' + CAST(@rows_inserted AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Tables: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\pablo.garciaabalo\Downloads\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @rows_inserted = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Rows Inserted: ' + CAST(@rows_inserted AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Tables: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\pablo.garciaabalo\Downloads\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @rows_inserted = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Rows Inserted: ' + CAST(@rows_inserted AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ----------------------'

		PRINT '--------------------------------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '--------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Tables: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\pablo.garciaabalo\Downloads\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @rows_inserted = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Rows Inserted: ' + CAST(@rows_inserted AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Tables: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\pablo.garciaabalo\Downloads\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @rows_inserted = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Rows Inserted: ' + CAST(@rows_inserted AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Tables: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\pablo.garciaabalo\Downloads\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @rows_inserted = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Rows Inserted: ' + CAST(@rows_inserted AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ----------------------'

		PRINT ''
		PRINT '================================================================================';
		PRINT 'Bronze Layer Load Completed';
		SET @batch_end_time = GETDATE();
		PRINT 'Batch Load Duration: ' + CAST(DATEDIFF(millisecond, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '================================================================================';

	END TRY
	BEGIN CATCH
		PRINT '================================================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================================================';
	END CATCH

END
