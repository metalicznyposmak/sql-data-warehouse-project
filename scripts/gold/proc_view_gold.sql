CREATE VIEW gold.dim_customers AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
        ci.cst_id AS customer_id,
        ci.cst_key AS customer_nummber,
        ci.cst_firstname AS first_name,
        ci.cst_lastname AS last_name,
        ela.cntry AS country,
        ci.cst_marital_status AS marital_status,
        CASE
            WHEN eca.gen IS NULL THEN ci.cst_gndr
            WHEN ci.cst_gndr LIKE 'n/a' THEN eca.gen -- CRM is the master for gender info
            ELSE ci.cst_gndr
        END AS gender,
        eca.bdate AS birth_date,
        ci.cst_create_date AS create_date
    FROM
        silver.crm_cust_info ci 
        LEFT JOIN silver.erp_cust_az12 eca
        ON ci.cst_key = eca.cid
        LEFT JOIN silver.erp_loc_a101 ela
        ON ci.cst_key = ela.cid;
    SIEMA ENIU