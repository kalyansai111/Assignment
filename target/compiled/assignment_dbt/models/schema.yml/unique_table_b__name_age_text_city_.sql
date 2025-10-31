
    
    

select
    (name || '|' || age::text || '|' || city) as unique_field,
    count(*) as n_records

from "testdb"."public"."table_b"
where (name || '|' || age::text || '|' || city) is not null
group by (name || '|' || age::text || '|' || city)
having count(*) > 1


