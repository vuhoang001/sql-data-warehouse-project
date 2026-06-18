use DataWarehouse;
go

create or alter procedure bronze.load_bronze
as
begin
    set nocount on;

    declare @start_time     datetime,
            @end_time       datetime,
            @batch_start    datetime = getdate(),
            @batch_end      datetime;

    begin try
        print '================================================';
        print 'Loading Bronze Layer';
        print '================================================';

        ------------------------------------------------------------
        -- CRM Tables
        ------------------------------------------------------------
        print '------------------------------------------------';
        print 'Loading CRM Tables';
        print '------------------------------------------------';

        set @start_time = getdate();
        print '>> Truncating: bronze.crm_cust_info';
        truncate table bronze.crm_cust_info;

        print '>> Inserting:  bronze.crm_cust_info';
        bulk insert bronze.crm_cust_info
        from '/datasets/source_crm/cust_info.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            rowterminator = '0x0a',
            keepnulls,
            tablock
        );
        set @end_time = getdate();
        print '   Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' sec';
        print '';

        set @start_time = getdate();
        print '>> Truncating: bronze.crm_prd_info';
        truncate table bronze.crm_prd_info;

        print '>> Inserting:  bronze.crm_prd_info';
        bulk insert bronze.crm_prd_info
        from '/datasets/source_crm/prd_info.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            rowterminator = '0x0a',
            keepnulls,
            tablock
        );
        set @end_time = getdate();
        print '   Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' sec';
        print '';

        set @start_time = getdate();
        print '>> Truncating: bronze.crm_sales_details';
        truncate table bronze.crm_sales_details;

        print '>> Inserting:  bronze.crm_sales_details';
        bulk insert bronze.crm_sales_details
        from '/datasets/source_crm/sales_details.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            rowterminator = '0x0a',
            keepnulls,
            tablock
        );
        set @end_time = getdate();
        print '   Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' sec';
        print '';

        ------------------------------------------------------------
        -- ERP Tables
        ------------------------------------------------------------
        print '------------------------------------------------';
        print 'Loading ERP Tables';
        print '------------------------------------------------';

        set @start_time = getdate();
        print '>> Truncating: bronze.erp_cust_az12';
        truncate table bronze.erp_cust_az12;

        print '>> Inserting:  bronze.erp_cust_az12';
        bulk insert bronze.erp_cust_az12
        from '/datasets/source_erp/CUST_AZ12.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            rowterminator = '0x0a',
            keepnulls,
            tablock
        );
        set @end_time = getdate();
        print '   Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' sec';
        print '';

        set @start_time = getdate();
        print '>> Truncating: bronze.erp_loc_a101';
        truncate table bronze.erp_loc_a101;

        print '>> Inserting:  bronze.erp_loc_a101';
        bulk insert bronze.erp_loc_a101
        from '/datasets/source_erp/LOC_A101.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            rowterminator = '0x0a',
            keepnulls,
            tablock
        );
        set @end_time = getdate();
        print '   Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' sec';
        print '';

        set @start_time = getdate();
        print '>> Truncating: bronze.erp_px_cat_g1v2';
        truncate table bronze.erp_px_cat_g1v2;

        print '>> Inserting:  bronze.erp_px_cat_g1v2';
        bulk insert bronze.erp_px_cat_g1v2
        from '/datasets/source_erp/PX_CAT_G1V2.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            rowterminator = '0x0a',
            keepnulls,
            tablock
        );
        set @end_time = getdate();
        print '   Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' sec';
        print '';

        ------------------------------------------------------------
        -- Fix empty dates: BULK INSERT converts '' to 1900-01-01,
        -- KEEPNULLS does not prevent this. Normalize to NULL here.
        ------------------------------------------------------------
        print '>> Normalizing 1900-01-01 → NULL on date columns';

        update bronze.crm_cust_info
        set cst_create_date = null
        where cst_create_date = '1900-01-01';

        update bronze.crm_prd_info
        set prd_start_dt = null
        where prd_start_dt = '1900-01-01';

        update bronze.crm_prd_info
        set prd_end_dt = null
        where prd_end_dt = '1900-01-01';

        update bronze.erp_cust_az12
        set bdate = null
        where bdate = '1900-01-01';

        ------------------------------------------------------------
        set @batch_end = getdate();
        print '================================================';
        print 'Bronze Layer Loaded Successfully';
        print 'Total Duration: ' + cast(datediff(second, @batch_start, @batch_end) as nvarchar) + ' sec';
        print '================================================';
    end try
    begin catch
        print '================================================';
        print 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        print 'Error Message: ' + error_message();
        print 'Error Number : ' + cast(error_number() as nvarchar);
        print 'Error State  : ' + cast(error_state() as nvarchar);
        print 'Error Line   : ' + cast(error_line() as nvarchar);
        print 'Error Proc   : ' + isnull(error_procedure(), 'N/A');
        print '================================================';
    end catch
end;
go

-- run it:
-- exec bronze.load_bronze;
