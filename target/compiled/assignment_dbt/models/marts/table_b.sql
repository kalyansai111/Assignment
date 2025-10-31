

with src as (
  select name, age, city
  from "testdb"."public"."stg_table_a"
)
select
  name,
  age,
  city,
  case when age < 30 then 'YOUNG' else 'ADULT' end as category
from src