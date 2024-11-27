CREATE TYPE scd_type as struct(
    quality_class quality_class, 
    is_active bool, 
    start_date integer, 
    end_date integer);

CREATE TABLE actors_history_scd (
    actor text, 
    quality_class quality_class, 
    is_active boolean, 
    start_date integer, 
    end_date integer)