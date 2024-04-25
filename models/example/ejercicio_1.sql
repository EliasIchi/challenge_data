{{ config(materialized='view') }}
SELECT * FROM
(
-- Paso 1: Calculamos el número de facturas por mes para cada emisor
WITH consecutivo AS (
    SELECT 
        YEAR,
        MONTH,
        ISSUER_RFC,
        NUM_INVOICES,
        -- Paso 2: Utilizamos LAG para obtener el valor anterior de NUM_INVOICES por ISSUER_RFC
        LAG(CASE WHEN NUM_INVOICES = 0 THEN 1 ELSE 0 END, 1) OVER (PARTITION BY ISSUER_RFC ORDER BY YEAR, MONTH) AS PREV_NUM_INVOICES,
        ROW_INDEX
    FROM
    (
        -- Paso 3: Generamos los meses y emisores únicos
        WITH AllYearMonths AS (
            SELECT DISTINCT YEAR(issued_at) AS year, MONTH(issued_at) AS month
            FROM DBT.AVENU_SCHEMA.INVOICE
            WHERE issued_at < (
                SELECT DATEADD(month, -24, MAX(issued_at))
                FROM DBT.AVENU_SCHEMA.INVOICE
                WHERE TYPE = 'I'
            )
        ),
        Issuers AS (
            SELECT DISTINCT ISSUER_RFC
            FROM DBT.AVENU_SCHEMA.INVOICE
            WHERE TYPE = 'I'
        )
        -- Paso 4: Hacemos un join para obtener el número de facturas por mes para cada emisor
        SELECT 
            AYM.year,
            AYM.month,
            Issuers.ISSUER_RFC,
            COALESCE(COUNT(invoice.id), 0) AS num_invoices,
            ROW_NUMBER() OVER (PARTITION BY Issuers.ISSUER_RFC ORDER BY AYM.year DESC, AYM.month DESC) AS ROW_INDEX
        FROM 
            AllYearMonths AYM
        CROSS JOIN
            Issuers
        LEFT JOIN 
            (
                SELECT 
                    YEAR(issued_at) AS year,
                    MONTH(issued_at) AS month,
                    ISSUER_RFC,
                    id
                FROM 
                    DBT.AVENU_SCHEMA.INVOICE
                WHERE 
                    TYPE = 'I'
            ) invoice
        ON 
            AYM.year = invoice.year
            AND AYM.month = invoice.month
            AND Issuers.ISSUER_RFC = invoice.ISSUER_RFC
        GROUP BY
            AYM.year,
            AYM.month,
            Issuers.ISSUER_RFC
        ORDER BY
            AYM.year DESC,
            AYM.month DESC
    ) AS T
)
-- Paso 5: Filtramos las filas donde hay tres o más meses consecutivos con cero facturas
SELECT 
    *,
    CASE 
        WHEN NUM_INVOICES = 0 AND PREV_NUM_INVOICES = 1 OR PREV_NUM_INVOICES IS NULL THEN 1
        ELSE 0
    END AS CONSECUTIVE_ZEROS,
    CASE 
        WHEN SUM(CASE WHEN NUM_INVOICES = 0 THEN 1 ELSE 0 END) OVER (PARTITION BY ISSUER_RFC ORDER BY YEAR, MONTH ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) >= 3 THEN 1
        ELSE 0
    END AS THREE_CONSECUTIVE_ZEROS
FROM consecutivo)
WHERE THREE_CONSECUTIVE_ZEROS = 1

