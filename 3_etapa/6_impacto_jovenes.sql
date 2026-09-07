-- 6. ¿Cómo ha evolucionado el impacto de los jugadores de cada equipo durante las temporadas analizadas?
select t.full_name as equipo, pss.season as temporada, round(sum(pss.plus_minus * pss.min) / nullif(sum(pss.min), 0), 2) as plus_minus_ponderado
from player_season_stats pss
join team t on t.team_id = pss.team_id
where pss.plus_minus is not null
and pss.min is not null
group by t.team_id, t.full_name, pss.season
order by plus_minus_ponderado desc;

-- 7a. ¿Qué equipos tienen actualmente mayor producción proveniente de jugadores jóvenes?
select t.full_name as equipo, count(distinct pss.player_id) as jugadores_jovenes, round(sum(pss.pts + pss.ast + pss.reb), 2) as produccion_joven
from player_season_stats pss
join player p on p.player_id = pss.player_id
join team t on t.team_id = pss.team_id
where pss.season = '2025-26'
and p.birthdate > '2000-10-01'
group by t.team_id, t.full_name
order by produccion_joven desc;

-- 7b. ¿Qué equipos tienen los jugadores jóvenes más productivos en promedio?
select t.full_name as equipo, count(distinct pss.player_id) as jugadores_jovenes, round(avg(pss.pts + pss.ast + pss.reb), 2) as produccion_promedio_jugador
from player_season_stats pss
join player p on p.player_id = pss.player_id
join team t on t.team_id = pss.team_id
where pss.season = '2025-26'
and p.birthdate > '2000-10-01'
group by t.team_id, t.full_name
order by produccion_promedio_jugador desc;