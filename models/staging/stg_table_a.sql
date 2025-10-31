{{ config(materialized='view') }}

select
  name,
  age,
  city
from {{ source('raw', 'table_a') }}
