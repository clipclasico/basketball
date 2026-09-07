-- 2. ¿Qué equipos presentaron la mayor mejora entre el inicio y el final del período analizado?
select t.full_name as equipo, inicio.porcentaje_victorias as porcentaje_2020_21, final.porcentaje_victorias as porcentaje_2025_26, round(final.porcentaje_victorias - inicio.porcentaje_victorias, 2) as mejora
from team t
join (
    select team_id, round(sum(case when resultado = 'W' then 1 else 0 end)::numeric / count(*) * 100, 2) as porcentaje_victorias
    from (
        select home_team_id as team_id, wl_home as resultado
        from game
        where season = '2020'
        and wl_home is not null
        and season_id::text like '2%'
        union all
        select away_team_id as team_id, wl_away as resultado
        from game
        where season = '2020'
        and wl_away is not null
        and season_id::text like '2%'
    ) partidos_inicio
    group by team_id
) inicio on inicio.team_id = t.team_id
join (
    select team_id, round(sum(case when resultado = 'W' then 1 else 0 end)::numeric / count(*) * 100, 2) as porcentaje_victorias
    from (
        select home_team_id as team_id, wl_home as resultado
        from game
        where season = '2025-26'
        and wl_home is not null
        and season_id::text like '2%'
        union all
        select away_team_id as team_id, wl_away as resultado
        from game
        where season = '2025-26'
        and wl_away is not null
        and season_id::text like '2%'
    ) partidos_final
    group by team_id
) final on final.team_id = t.team_id
order by mejora desc;