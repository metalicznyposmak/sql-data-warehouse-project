CREATE OR ALTER VIEW gold.dim_customers AS
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
        ON ci.cst_key = ela.cid
GO;


CREATE OR ALTER VIEW gold.dim_products AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY prd.prd_start_dt, prd.prd_key) AS product_key,
        prd.prd_id AS product_id,
        prd.prd_key AS product_number,
        prd.prd_nm AS product_name,
        prd.cat_id AS category_id,
        cat.cat AS category_name,
        cat.subcat AS subcategory_name,
        cat.maintenance,
        prd.prd_cost AS cost,
        prd.prd_line AS product_line,
        prd.prd_start_dt AS start_date
    FROM silver.crm_prd_info prd LEFT JOIN silver.erp_px_cat_g1v2 cat ON prd.cat_id = cat.id
    WHERE prd.prd_end_dt IS NULL -- We are filtering out the historical data
GO;


CREATE OR ALTER VIEW gold.fact_sales AS
    SELECT
        sd.sls_ord_num AS order_number,
        pd.product_key,
        cst.customer_key,
        sd.sls_order_dt AS order_date,
        sd.sls_ship_dt AS shipping_date,
        sd.sls_due_dt AS due_date,
        sd.sls_sales AS sales_amount,
        sd.sls_quantity AS quantity,
        sd.sls_price AS price
    FROM silver.crm_sales_details sd 
        LEFT JOIN gold.dim_products pd ON pd.product_number = sd.sls_prd_key
        LEFT JOIN gold.dim_customers cst ON cst.customer_id = sd.sls_cust_id
GO;
        

-- Foreign Key Integrity (Dimensions) CHECK
SELECT *
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON fs.customer_key = dc.customer_key
LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
WHERE dc.customer_key IS NULL OR dp.product_key IS NULL
