-- 3a. Durante las temporadas con información salarial completa, ¿qué equipos obtuvieron victorias a menor costo de nómina?
select t.full_name as equipo, ts.season as temporada, ts.salary as nomina_total, w.victorias, round(ts.salary / nullif(w.victorias, 0), 2) as costo_por_victoria
from team_salary ts
join team t on t.team_id = ts.team_id
join (
    select team_id, season, sum(case when resultado = 'W' then 1 else 0 end) as victorias
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
) w on w.team_id = ts.team_id
and (
    w.season = ts.season
    or (w.season = '2020' and ts.season = '2020-21')
)
where ts.season in ('2020-21', '2021-22')
order by costo_por_victoria asc;

-- 3.b. ¿Gastar más está asociado con ganar más?
select round(corr(ts.salary, w.victorias)::numeric, 3) as correlacion_salario_victorias
from team_salary ts
join (
    select team_id, season, sum(case when resultado = 'W' then 1 else 0 end) as victorias
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
) w on w.team_id = ts.team_id
and (
    w.season = ts.season
    or (w.season = '2020' and ts.season = '2020-21')
)
where ts.season in ('2020-21', '2021-22');