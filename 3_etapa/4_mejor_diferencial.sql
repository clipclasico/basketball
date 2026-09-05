-- 4. ¿Qué equipos tuvieron el mejor diferencial promedio de puntos y cómo evolucionó durante las temporadas analizadas?
select t.full_name as equipo, d.season as temporada, round(avg(d.diferencia), 2) as diferencia_promedio
from (
    select home_team_id as team_id, season, pts_home - pts_away as diferencia
    from game
    where pts_home is not null
    and pts_away is not null
    and season_id::text like '2%'
    union all
    select away_team_id as team_id, season, pts_away - pts_home as diferencia
    from game
    where pts_home is not null
    and pts_away is not null
    and season_id::text like '2%'
) d
join team t on t.team_id = d.team_id
group by t.team_id, t.full_name, d.season
order by diferencia_promedio desc;