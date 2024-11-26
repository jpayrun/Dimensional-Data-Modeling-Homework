drop type quality_class;

create type quality_class as ENUM ('star', 'good', 'average', 'bad');

drop type films;

create type films as struct(
                film text,
                votes integer,
                rating real,
                filmid text);
            
DROP TABLE actors;

CREATE TABLE actors (
            actor text,
            films films[],
            quality_class quality_class,
            is_active bool,
            year integer);
