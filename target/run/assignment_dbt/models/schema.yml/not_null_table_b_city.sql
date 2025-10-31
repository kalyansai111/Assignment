select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select city
from "testdb"."public"."table_b"
where city is null



      
    ) dbt_internal_test