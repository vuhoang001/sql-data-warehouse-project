if object_id('sliver.crm_cust_info', 'U') is not null
drop table sliver.crm_cust_info;
GO
create table sliver.crm_cust_info (
                      cst_id int,
                      cst_key nvarchar(50),
                      cst_firstname nvarchar(255),
                      cst_lastname nvarchar(255),
                      cst_marital_status nvarchar(50),
                      cst_gndr nvarchar(50),
                      cst_create_date date,
                      dwh_create_date DATETIME2 default GETDATE()
)
GO


if object_id('sliver.crm_prd_info', 'U') is not null
    drop table sliver.crm_prd_info
create table sliver.crm_prd_info (
    prd_id int,
    cat_id nvarchar(50),
    prd_key nvarchar(50),
    prd_nm nvarchar(50),
    prd_cost int,
    prd_line nvarchar(50),
    prd_start_dt date,
    prd_end_dt date,
    dwh_create_date datetime2 default GETDATE()
)

if object_id('sliver.crm_sales_details', 'U') is not null
    drop table sliver.crm_sales_details
create table sliver.crm_sales_details (
                                          sls_ord_num nvarchar(49),
                                          sls_prd_key nvarchar(49),
                                          sls_cust_id int,
                                          sls_order_dt date,
                                          sls_ship_dt date,
                                          sls_due_dt date,
                                          sls_sales int,
                                          sls_quantity int,
                                          sls_price int,
                                          dwh_create_date datetime2 default getdate()
)

go

if object_id('sliver.erp_loc_a101', 'U') is not null
    drop table sliver.erp_loc_a101
create table sliver.erp_loc_a101 (
                                     cid nvarchar(50),
                                     cntry nvarchar(50),
                                     dwh_create_date datetime2 default Getdate()
)
go


if object_id('sliver.erp_px_cat_g1v2', 'U') is not null
    drop table sliver.erp_px_cat_g1v2
create table sliver.erp_px_cat_g1v2(
                                       id nvarchar(50),
                                       cat nvarchar(50),
                                       subcat nvarchar(50),
                                       maintenance nvarchar(50),
    dwh_create_date datetime2 default getdate()
)

IF OBJECT_ID('sliver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE sliver.erp_cust_az12;
GO

CREATE TABLE sliver.erp_cust_az12 (
                                      cid             NVARCHAR(50),
                                      bdate           DATE,
                                      gen             NVARCHAR(50),
                                      dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

