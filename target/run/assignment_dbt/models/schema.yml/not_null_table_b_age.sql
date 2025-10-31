select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select age
from "testdb"."public"."table_b"
where age is null



      
    ) dbt_internal_test