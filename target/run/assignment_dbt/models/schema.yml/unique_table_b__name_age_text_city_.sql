select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    (name || '|' || age::text || '|' || city) as unique_field,
    count(*) as n_records

from "testdb"."public"."table_b"
where (name || '|' || age::text || '|' || city) is not null
group by (name || '|' || age::text || '|' || city)
having count(*) > 1



      
    ) dbt_internal_test