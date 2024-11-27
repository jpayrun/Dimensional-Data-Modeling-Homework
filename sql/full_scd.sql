insert into actors_history_scd
            with lag_query as (
            select
                *,
                lag(quality_class, 1) over (partition by actor) as lag_quality_class,
                lag(is_active, 1) over (partition by actor) as lag_is_active
            from actors
            ),
change_indicator as (
    select *,
            case
                when is_active <> lag_is_active then 1
            when lag_quality_class <> quality_class then 1
            else 0
            end change_indicator
             from lag_query),
streak as (
     select *, sum(change_indicator) over (partition by actor order by year) as streak from change_indicator),
grouped as (
select
    actor,
    streak,
    quality_class,
    is_active,
    min(year) start_year,
    max(year) end_year
from streak
group by all)
            
select
    actor,
    quality_class,
    is_active,
    start_year,
    end_year
from grouped