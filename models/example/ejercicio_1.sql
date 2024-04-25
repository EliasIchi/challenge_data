{{ config(materialized='view') }}
select * from (

WITH AllYearMonths AS (
    SELECT DISTINCT YEAR(issued_at) AS year, MONTH(issued_at) AS month
    FROM DBT.AVENU_SCHEMA.INVOICE
    WHERE issued_at > (
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
SELECT 
    AYM.year,
    AYM.month,
    Issuers.ISSUER_RFC,
    COALESCE(COUNT(invoice.id), 0) AS num_invoices
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
    AYM.month DESC)
