insert into actors
            with this_year_dupe as (
        select
            *,
            avg(rating) over (partition by actorid) avg_rating,
            array_agg(ROW(film, votes, rating, filmid)::films) over (partition by actorid) as  films,
            --struct_pack(ROW(film, votes, rating, filmid)::films) over (partition by actorid) as  films,
            row_number() over (partition by actorid) rn,
            case when actorid is not null then 1 else 0 end is_active
        from actor_films
        where
            year = 1970),
    last_year as (
            select
                *
        from actors
            where
                year = 1969
            ),
    this_year as (
            select
                *,
            case
                when ty.avg_rating > 8 then 'star'
            when ty.avg_rating > 7 then 'good'
            when ty.avg_rating > 6 then 'average'
            else 'bad'
        end::quality_class as quality_class,
        from this_year_dupe as ty
            where rn = 1
            )

    select
            coalesce(ty.actor, ly.actor) as actor,
            case
                when ly.films is not null then
                    ly.films || ty.films
                when ty.films is null then ly.films
                else ty.films
            end as films,
            coalesce(ty.quality_class, ly.quality_class) as quality_class,
            coalesce(ty.is_active, ly.is_active) as is_active,
            coalesce(ty.year, ly.year + 1) as year
    from this_year ty
            full outer join last_year ly
            on ty.actor = ly.actor