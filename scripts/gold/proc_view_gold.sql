SELECT
    ci.cst_id,
    ci.cst_key,
    ci.cst_firstname,
    ci.cst_lastname,
    ci.cst_marital_status,
    cst_gndr,
    CASE
        WHEN ci.cst_gndr 
    eca.bdate,
    eca.gen,
    ela.cntry
FROM
    silver.crm_cust_info ci 
    LEFT JOIN silver.erp_cust_az12 eca
    ON ci.cst_key = eca.cid
    LEFT JOIN silver.erp_loc_a101 ela
    ON ci.cst_key = ela.cid

SELECT DISTINCT
    cst_gndr,
    eca.gen
FROM
    silver.crm_cust_info ci 
    LEFT JOIN silver.erp_cust_az12 eca
    ON ci.cst_key = eca.cid
    LEFT JOIN silver.erp_loc_a101 ela
    ON ci.cst_key = ela.cid