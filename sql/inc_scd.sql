
    insert into actors_history_scd
    with this_year as (
                select 
        * 
    from actors
    where
        year = {year}),
    last_year as (
    select
        *
    from actors_history_scd
    where
        end_date = {year - 1}),
    historical as (
    select
        *
    from actors_history_scd
    where
        end_date < {year - 1}),
    new as (
    select
        actor,
        quality_class,
        is_active,
        year start_date,
        year end_date
    from this_year ty
    where
        not exists (select * from last_year ly where ly.actor = ty.actor)            
        ),
    unchanged as (
    select
        ly.actor,
        ly.quality_class,
        ly.is_active,
        ly.start_date start_date,
        ly.end_date + 1 end_date
    from this_year ty
        join last_year ly
            on ty.actor = ly.actor
    where
        ty.is_active = ly.is_active
        and ty.quality_class = ly.quality_class),
    changed_nested as (
    select
        ty.actor,
        unnest(Array[
                ROW(
                ly.quality_class,
                ly.is_active,
                ly.start_date,
                ly.end_date),
                ROW(
                ty.quality_class,
                ty.is_active,
                ty.year,
                ty.year)]) as records
    from this_year ty
        join last_year ly
            on ty.actor = ly.actor
    where
        ty.is_active <> ly.is_active
        or ty.quality_class <> ly.quality_class             
                ),
    unnested as (
    SELECT
        actor,
        (records::scd_type).quality_class,
        (records::scd_type).is_active,
        (records::scd_type).start_date,
        (records::scd_type).end_date
    FROM changed_nested            
                )
                
    select * from new
                
    union all
                
    select * from unnested
                
    union all
                
    select * from historical
                
    union all
                
    select * from unchanged