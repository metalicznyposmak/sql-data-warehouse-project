PRINT('==============================================')
PRINT('Inserting clean data into silver.crm_cust_info')
PRINT('==============================================')

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) as cst_firstname,
    TRIM(cst_lastname) as cst_lastname,
    CASE
        WHEN TRIM(UPPER(cst_marital_status)) = 'M' THEN 'Married'
        WHEN TRIM(UPPER(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END cst_marital_status,
    CASE
        WHEN TRIM(UPPER(cst_gndr)) = 'F' THEN 'Female'
        WHEN TRIM(UPPER(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END cst_gndr,
    cst_create_date
FROM (
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
)t WHERE flag_last = 1

PRINT('==============================================')
PRINT('Inserting clean data into silver.crm_prd_info')
PRINT('==============================================')

SELECT
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS [prd_key],
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost,
    CASE
        WHEN UPPER(TRIM(prd_line)) LIKE 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) LIKE 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) LIKE 'S' THEN 'Sport'
        WHEN UPPER(TRIM(prd_line)) LIKE 'T' THEN 'Touring'
        ELSE 'Unspecified'
    END AS prd_line,
    prd_start_dt,
    DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
FROM bronze.crm_prd_info