-- Check for nulls and duplicates in Primary Key cst_id in bronze.crm_sales_details
-- Return records with duplicate and null primary keys
SELECT
sls_ord_num,
COUNT(*)
FROM bronze.crm_sales_details
GROUP BY sls_ord_num
HAVING COUNT(*) > 1 OR sls_ord_num IS NULL;



-- Check for unwanted spaces
SELECT sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

------------------------------------------------------------------

SELECT DISTINCT prd_line
FROM bronze.crm_sales_details

------------------------------------------------------------------

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt
        = 0
        OR LEN(sls_order_dt) != 8
        OR sls_order_dt < 19000101
        THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,
    CASE WHEN sls_ship_dt
        = 0
        OR LEN(sls_ship_dt) != 8
        OR sls_ship_dt < 19000101
        THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,
    CASE WHEN sls_due_dt
        = 0
        OR LEN(sls_due_dt) != 8
        OR sls_due_dt < 19000101
        THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,
    CASE WHEN
        sls_sales IS NULL 
        OR sls_sales <= 0
        OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END as sls_sales,
    sls_quantity,
    CASE WHEN
        sls_price IS NULL 
        OR sls_price <= 0
        OR sls_price != ABS(sls_sales) / sls_quantity
        THEN ABS(sls_sales) / sls_quantity
        ELSE sls_price
    END as sls_price
FROM bronze.crm_sales_details

---------------------------------------------------------------------------

SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM
(
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt
        = 0
        OR LEN(sls_order_dt) != 8
        OR sls_order_dt < 19000101
        THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,
    CASE WHEN sls_ship_dt
        = 0
        OR LEN(sls_ship_dt) != 8
        OR sls_ship_dt < 19000101
        THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,
    CASE WHEN sls_due_dt
        = 0
        OR LEN(sls_due_dt) != 8
        OR sls_due_dt < 19000101
        THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,
    CASE WHEN
        sls_sales IS NULL 
        OR sls_sales <= 0
        OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END as sls_sales,
    sls_quantity,
    CASE WHEN
        sls_price IS NULL 
        OR sls_price <= 0
        OR sls_price != ABS(sls_sales) / sls_quantity
        THEN ABS(sls_sales) / sls_quantity
        ELSE sls_price
    END as sls_price
FROM bronze.crm_sales_details
)t WHERE 
    sls_sales != sls_price * sls_quantity 
    OR sls_quantity <= 0 
    OR sls_sales <= 0
    OR sls_price <= 0
    OR sls_quantity IS NULL 
    OR sls_price IS NULL 
    OR sls_sales IS NULL


-----------------------------------------------------------------------------

SELECT *
FROM bronze.crm_sales_details