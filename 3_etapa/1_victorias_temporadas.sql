-- Etapa 3
-- 1a. ¿Cuál fue el porcentaje de victorias de cada equipo en cada temporada analizada?
select t.full_name as equipo, w.season as temporada, w.victorias, w.partidos, round(w.victorias::numeric / w.partidos * 100, 2) as porcentaje_victorias
from (
    select team_id, season, count(*) as partidos, sum(case when resultado = 'W' then 1 else 0 end) as victorias
    from (
        select home_team_id as team_id, season, wl_home as resultado
        from game
        where wl_home is not null 
        and season_id::text like '2%'
        union all
        select away_team_id as team_id, season, wl_away as resultado
        from game
        where wl_away is not null 
        and season_id::text like '2%'
    ) partidos_equipo
    group by team_id, season
) w
join team t on t.team_id = w.team_id
order by porcentaje_victorias desc;

-- 1b. ¿Qué equipos mantuvieron el rendimiento más consistente durante las temporadas analizadas?
select t.full_name as equipo, round(avg(w.porcentaje_victorias), 2) as promedio_victorias, round(min(w.porcentaje_victorias), 2) as peor_temporada, round(max(w.porcentaje_victorias), 2) as mejor_temporada, round(max(w.porcentaje_victorias) - min(w.porcentaje_victorias), 2) as variacion
from (
    select team_id, season, sum(case when resultado = 'W' then 1 else 0 end)::numeric / count(*) * 100 as porcentaje_victorias
    from (
        select home_team_id as team_id, season, wl_home as resultado
        from game
        where wl_home is not null
        and season_id::text like '2%'
        union all
        select away_team_id as team_id, season, wl_away as resultado
        from game
        where wl_away is not null
        and season_id::text like '2%'
    ) partidos_equipo
    group by team_id, season
) w
join team t on t.team_id = w.team_id
group by t.team_id, t.full_name
order by variacion asc;