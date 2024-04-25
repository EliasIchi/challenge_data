-- Listado de todos los business existentes, con la cantidad de business_product de tipo invoice advance activos creados en 2021 y 2022; siempre y cuando haya tenido al menos 1 por cada año, de lo contrario mostrar 0.

SELECT 
    AllBusiness.BUSINESS_ID,
    COALESCE(T2021.TOTAL, 0) AS TOTAL_2021,
    COALESCE(T2022.TOTAL, 0) AS TOTAL_2022
FROM (
    SELECT DISTINCT BUSINESS_ID
    FROM Business_Product
) AS AllBusiness
LEFT JOIN (
    SELECT
        BUSINESS_ID,
        COUNT(*) AS TOTAL
    FROM
        Business_Product
    WHERE
        YEAR(created_at) = 2021
    GROUP BY
        BUSINESS_ID
) AS T2021 ON AllBusiness.BUSINESS_ID = T2021.BUSINESS_ID
LEFT JOIN (
    SELECT
        BUSINESS_ID,
        COUNT(*) AS TOTAL
    FROM
        Business_Product
    WHERE
        YEAR(created_at) = 2022
    GROUP BY
        BUSINESS_ID
) AS T2022 ON AllBusiness.BUSINESS_ID = T2022.BUSINESS_ID
ORDER BY
    AllBusiness.BUSINESS_ID
