-- Selecciona los business_product de tipo "Invoice Advance" junto con la información de la invoice_advance asociada (si existe)
SELECT DISTINCT bp.id AS business_product_id, ia.id, ia.state
FROM Business_Product bp
-- Utiliza LEFT JOIN para asegurarse de incluir todos los business_product incluso si no tienen ninguna invoice_advance asociada
LEFT JOIN Invoice_Advance ia ON bp.id = ia.business_product_id
WHERE bp.product_name = 'Invoice Advance' -- Filtra los business_product por el tipo "Invoice Advance"
AND (
    -- Condiciones para las invoice_advance asociadas:
    -- 1. Si no tiene ninguna invoice_advance asociada
    ia.id IS NULL
    OR (
        -- 2. Si la invoice_advance está rechazada y su moneda es USD
        ia.state = 'rejected'
        AND ia.currency = 'USD'
    )
)
-- Condiciones adicionales para los business_product que no tienen ninguna invoice_advance asociada:
OR ia.id IS NULL
AND bp.id NOT IN (
    -- Subconsulta para obtener los business_product_id de las invoice_advance existentes
    SELECT DISTINCT business_product_id
    FROM Invoice_Advance
)
