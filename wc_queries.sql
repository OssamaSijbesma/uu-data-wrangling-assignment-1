-- =====================================================================
-- TASK 2: Querying the database
-- =====================================================================

-- ---------------------------------------------------------------------
-- Query 1 (join two or more tables)
-- NL: For every goal, list the scorer's name, the scorer's team, the
--     stadium where it was scored and the minute of the goal.
-- RA: π first_name, last_name, country_name, stadium.name, minute (
--       ((((goal ⋈_{goal.player_id = player.player_id} player)
--           ⋈_{player.person_id = person.person_id} person)
--           ⋈_{player.team_id = team.team_id} team)
--           ⋈_{goal.match_id = match.match_id} match)
--           ⋈_{match.stadium_id = stadium.stadium_id} stadium )
-- ---------------------------------------------------------------------
SELECT pe.first_name, pe.last_name, t.country_name AS team,
       s.name AS stadium, g.minute
FROM goal g
JOIN player  p  ON g.player_id  = p.player_id
JOIN person  pe ON p.person_id  = pe.person_id
JOIN team    t  ON p.team_id    = t.team_id
JOIN match   m  ON g.match_id   = m.match_id
JOIN stadium s  ON m.stadium_id = s.stadium_id
ORDER BY g.match_id, g.minute;

-- ---------------------------------------------------------------------
-- Query 2 (aggregate function)
-- NL: How many goals has each team scored in the tournament?
-- RA: ρ(team_goals)( country_name γ COUNT(goal_id) → total_goals (
--       (goal ⋈_{goal.player_id = player.player_id} player)
--         ⋈_{player.team_id = team.team_id} team ) )
-- ---------------------------------------------------------------------
SELECT t.country_name, COUNT(g.goal_id) AS total_goals
FROM goal g
JOIN player p ON g.player_id = p.player_id
JOIN team   t ON p.team_id   = t.team_id
GROUP BY t.team_id, t.country_name
ORDER BY total_goals DESC;

-- ---------------------------------------------------------------------
-- Query 3 (nested query)
-- NL: Which players scored a goal in the match with the highest
--     attendance?
-- RA: MaxAtt ← γ MAX(attendance) → max_att (match)
--     TopMatch ← π match_id ( match ⋈_{match.attendance = MaxAtt.max_att} MaxAtt )
--     π first_name, last_name (
--       ((goal ⋈_{goal.match_id = TopMatch.match_id} TopMatch)
--         ⋈_{goal.player_id = player.player_id} player)
--         ⋈_{player.person_id = person.person_id} person )
-- ---------------------------------------------------------------------
SELECT DISTINCT pe.first_name, pe.last_name
FROM goal g
JOIN player p  ON g.player_id = p.player_id
JOIN person pe ON p.person_id = pe.person_id
WHERE g.match_id IN (
    SELECT match_id
    FROM match
    WHERE attendance = (SELECT MAX(attendance) FROM match)
);

-- ---------------------------------------------------------------------
-- Query 4 (self join)
-- NL: Find all pairs of players who play for the same team and in the
--     same position (each pair listed once).
-- RA: P1 ← ρ_{p1}(player ⋈_{player.person_id = person.person_id} person)
--     P2 ← ρ_{p2}(player ⋈_{player.person_id = person.person_id} person)
--     π p1.last_name, p2.last_name, p1.position, p1.team_id (
--       P1 ⋈_{p1.team_id = p2.team_id ∧ p1.position = p2.position
--             ∧ p1.player_id < p2.player_id} P2 )
-- ---------------------------------------------------------------------
SELECT pe1.last_name AS player_1, pe2.last_name AS player_2,
       p1.position, t.country_name AS team
FROM player p1
JOIN player p2  ON p1.team_id  = p2.team_id
               AND p1.position = p2.position
               AND p1.player_id < p2.player_id
JOIN person pe1 ON p1.person_id = pe1.person_id
JOIN person pe2 ON p2.person_id = pe2.person_id
JOIN team   t   ON p1.team_id   = t.team_id;

-- ---------------------------------------------------------------------
-- Query 5 (set operation)
-- NL: Which players both scored a goal and received a card?
-- RA: Both ← π player_id (goal) ∩ π player_id (card)
--     π first_name, last_name (
--       (Both ⋈_{Both.player_id = player.player_id} player)
--         ⋈_{player.person_id = person.person_id} person )
-- ---------------------------------------------------------------------
SELECT pe.first_name, pe.last_name
FROM player p
JOIN person pe ON p.person_id = pe.person_id
WHERE p.player_id IN (
    SELECT player_id FROM goal
    INTERSECT
    SELECT player_id FROM card
);
