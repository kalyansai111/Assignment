
  create view "testdb"."public"."stg_table_a__dbt_tmp"
    
    
  as (
    

select
  name,
  age,
  city
from "testdb"."public"."table_a"
  );