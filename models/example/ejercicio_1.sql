{{ config(materialized='view') }}
SELECT * FROM DBT.AVENU_SCHEMA.BUSINESS