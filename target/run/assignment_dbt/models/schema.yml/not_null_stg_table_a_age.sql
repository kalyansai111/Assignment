select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select age
from "testdb"."public"."stg_table_a"
where age is null



      
    ) dbt_internal_test