select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select name
from "testdb"."public"."stg_table_a"
where name is null



      
    ) dbt_internal_test