-- 5. ¿Qué equipos mostraron el mejor rendimiento ofensivo y defensivo durante las temporadas analizadas?
-- 5a. Rendimiento ofensivo
select t.full_name as equipo, o.season as temporada, round(avg(o.puntos), 2) as puntos_promedio, round(avg(o.fg_pct) * 100, 2) as porcentaje_tiros_campo, round(avg(o.fg3_pct) * 100, 2) as porcentaje_triples, round(avg(o.ast), 2) as asistencias_promedio, round(avg(o.tov), 2) as perdidas_promedio
from (
    select home_team_id as team_id, season, pts_home as puntos, fg_pct_home as fg_pct, fg3_pct_home as fg3_pct, ast_home as ast, tov_home as tov
    from game
    where pts_home is not null
    and season_id::text like '2%'
    union all
    select away_team_id as team_id, season, pts_away as puntos, fg_pct_away as fg_pct, fg3_pct_away as fg3_pct, ast_away as ast, tov_away as tov
    from game
    where pts_away is not null
    and season_id::text like '2%'
) o
join team t on t.team_id = o.team_id
group by t.team_id, t.full_name, o.season
order by puntos_promedio desc;

-- 5b. Rendimiento defensivo
select t.full_name as equipo, d.season as temporada, round(avg(d.puntos_recibidos), 2) as puntos_recibidos_promedio, round(avg(d.robos), 2) as robos_promedio, round(avg(d.bloqueos), 2) as bloqueos_promedio, round(avg(d.rebotes_defensivos), 2) as rebotes_defensivos_promedio
from (
    select home_team_id as team_id, season, pts_away as puntos_recibidos, stl_home as robos, blk_home as bloqueos, dreb_home as rebotes_defensivos
    from game
    where pts_away is not null
    and season_id::text like '2%'
    union all
    select away_team_id as team_id, season, pts_home as puntos_recibidos, stl_away as robos, blk_away as bloqueos, dreb_away as rebotes_defensivos
    from game
    where pts_home is not null
    and season_id::text like '2%'
) d
join team t on t.team_id = d.team_id
group by t.team_id, t.full_name, d.season
order by puntos_recibidos_promedio asc;