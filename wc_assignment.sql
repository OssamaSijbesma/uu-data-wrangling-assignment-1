-- =====================================================================
-- Data Wrangling (INFOMDW) - Assignment 1: Data Extraction & Integration
-- FIFA World Cup 2026 database
--
-- Creates the database (Task 1), inserts sample records and runs the
-- Task 2 queries. Run it from the sqlite3 shell, in this folder:
--
--     sqlite3
--     sqlite> .read wc_assignment.sql
--
-- The script drops existing tables first, so it can be run repeatedly.
-- =====================================================================

.open wc_database.db

PRAGMA foreign_keys = ON;

-- =====================================================================
-- Reset: drop existing tables (children before parents)
-- =====================================================================
DROP TABLE IF EXISTS match_official;
DROP TABLE IF EXISTS card;
DROP TABLE IF EXISTS substitute;
DROP TABLE IF EXISTS goal;
DROP TABLE IF EXISTS match;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS staff_member;
DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS stadium;
DROP TABLE IF EXISTS official_role;
DROP TABLE IF EXISTS staff_role;

-- Referential integrity policies
--   ON DELETE CASCADE  : rows that only exist as part of their parent
--                        (match events and officials -> match; staff assignments -> person/team).
--   ON DELETE RESTRICT : parents that must not disappear while referenced
--                        (teams/stadiums with matches, players with goals/cards/substitutions,
--                        roles in use, officials who have officiated).
--   NO ACTION (default): player -> person, player -> team.
--   ON UPDATE CASCADE  : on every explicit policy, so a changed key propagates to children.
--   SET NULL is not used: every foreign key column is NOT NULL.

-- =====================================================================
-- TASK 1: Creating the database
-- =====================================================================

CREATE TABLE staff_role (
	staff_role_id INT PRIMARY KEY,
	role_name VARCHAR NOT NULL
);

CREATE TABLE official_role (
	official_role_id INT PRIMARY KEY,
	role_name VARCHAR NOT NULL UNIQUE
);

CREATE TABLE stadium (
	stadium_id INT PRIMARY KEY,
	name VARCHAR NOT NULL,
	city VARCHAR NOT NULL,
	country VARCHAR NOT NULL,
	capacity INT
);

CREATE TABLE person (
	person_id INT PRIMARY KEY,
	last_name VARCHAR NOT NULL,
	first_name VARCHAR,
	birth_date DATETIME NOT NULL
);

CREATE TABLE team (
	team_id INT PRIMARY KEY,
	country_name VARCHAR NOT NULL,
	fifa_rank INT NOT NULL
);

CREATE TABLE staff_member (
	person_id INT NOT NULL,
	staff_role_id INT NOT NULL,
	team_id INT NOT NULL,
	
	PRIMARY KEY (person_id, staff_role_id, team_id),

	FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_role_id) REFERENCES staff_role(staff_role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE player (
	player_id INT PRIMARY KEY,
	person_id INT NOT NULL,
	position VARCHAR NOT NULL,
	jersey_number INT NOT NULL,
	team_id INT NOT NULL,
	
	FOREIGN KEY (person_id) REFERENCES person(person_id),
	FOREIGN KEY (team_id) REFERENCES team(team_id)
);

CREATE TABLE match (
	match_id INT PRIMARY KEY,
	team_1_id INT NOT NULL,
	team_2_id INT NOT NULL,
	stadium_id INT NOT NULL,
	attendance INT,
	first_half_start DATETIME NOT NULL,
	first_half_end DATETIME,
	second_half_start DATETIME,
	second_half_end DATETIME,
	is_abandoned BOOLEAN NOT NULL,

	CHECK (team_1_id <> team_2_id),

	FOREIGN KEY (team_1_id) REFERENCES team(team_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (team_2_id) REFERENCES team(team_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (stadium_id) REFERENCES stadium(stadium_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE goal (
	goal_id INT PRIMARY KEY,
	minute INT NOT NULL,
	goal_type CHAR NOT NULL,
	match_id INT NOT NULL,
	player_id INT NOT NULL,
	
	FOREIGN KEY (match_id) REFERENCES match(match_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (player_id) REFERENCES player(player_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE substitute (
	substitute_id INT PRIMARY KEY,
	minute INT NOT NULL,
	player_out INT NOT NULL,
	player_in INT NOT NULL,
	match_id INT NOT NULL,

	FOREIGN KEY (player_in) REFERENCES player(player_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (player_out) REFERENCES player(player_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (match_id) REFERENCES match(match_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE card (
	card_id INT PRIMARY KEY,
	minute INT NOT NULL,
	card_type VARCHAR NOT NULL CHECK (card_type IN ('yellow', 'red')),
	match_id INT NOT NULL,
	player_id INT NOT NULL,
	
	FOREIGN KEY (match_id) REFERENCES match(match_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (player_id) REFERENCES player(player_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE match_official (
	official_role_id INT NOT NULL,
	person_id INT NOT NULL,
	match_id INT NOT NULL,
	
	PRIMARY KEY (official_role_id, person_id, match_id),

    FOREIGN KEY (official_role_id) REFERENCES official_role(official_role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (match_id) REFERENCES match(match_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- =====================================================================
-- Sample records
-- =====================================================================

INSERT INTO staff_role (staff_role_id, role_name) VALUES
(1, 'Coach'),
(2, 'Assistant Coach'),
(3, 'Physiotherapist'),
(4, 'Team Doctor');


INSERT INTO official_role (official_role_id, role_name) VALUES
(1, 'Referee'),
(2, 'Assistant Referee'),
(3, 'Fourth Official'),
(4, 'VAR');


INSERT INTO stadium (stadium_id, name, city, country, capacity) VALUES
(1, 'Johan Cruyff Arena', 'Amsterdam', 'Netherlands', 55000),
(2, 'Wembley Stadium', 'London', 'England', 90000),
(3, 'Camp Nou', 'Barcelona', 'Spain', 99354),
(4, 'San Siro', 'Milan', 'Italy', 80018);


INSERT INTO person (person_id, last_name, first_name, birth_date) VALUES
(1, 'Koeman', 'Ronald', '1963-03-21'),
(2, 'Van Dijk', 'Virgil', '1991-07-08'),
(3, 'De Jong', 'Frenkie', '1997-05-12'),
(4, 'Depay', 'Memphis', '1994-02-13'),
(5, 'Gakpo', 'Cody', '1999-05-07'),
(6, 'Rice', 'Declan', '1999-01-14'),
(7, 'Kane', 'Harry', '1993-07-28'),
(8, 'Bellingham', 'Jude', '2003-06-29'),
(9, 'Martinez', 'Emiliano', '1992-09-02'),
(10, 'Martinez', 'Lautaro', '1997-08-22'),
(11, 'Silva', 'Bernardo', '1994-08-10'),
(12, 'Santos', 'Rafael', '1980-04-15'),
(13, 'Garcia', 'Carlos', '1985-09-20'),
(14, 'Muller', 'Thomas', '1989-09-13'),
(15, 'Taylor', 'Anthony', '1978-10-20'),
(16, 'Oliver', 'Michael', '1985-02-20'),
(17, 'Brown', 'David', '1975-06-11'),
(18, 'Wilson', 'James', '1982-11-03');


INSERT INTO team (team_id, country_name, fifa_rank) VALUES
(1, 'Netherlands', 8),
(2, 'England', 4),
(3, 'Spain', 3),
(4, 'Argentina', 1);


INSERT INTO staff_member (person_id, staff_role_id, team_id) VALUES
(1, 1, 1),
(12, 2, 1),
(13, 3, 1),
(14, 1, 2);


INSERT INTO player (player_id, person_id, position, jersey_number, team_id) VALUES
(1, 2, 'Defender', 4, 1),
(2, 3, 'Midfielder', 21, 1),
(3, 4, 'Forward', 10, 1),
(4, 5, 'Forward', 11, 1),

(5, 6, 'Midfielder', 4, 2),
(6, 7, 'Forward', 9, 2),
(7, 8, 'Midfielder', 10, 2),

(8, 9, 'Goalkeeper', 23, 4),
(9, 10, 'Forward', 22, 4),

(10, 11, 'Midfielder', 10, 3);


INSERT INTO match (
	match_id,
	team_1_id,
	team_2_id,
	stadium_id,
	attendance,
	first_half_start,
	first_half_end,
	second_half_start,
	second_half_end,
	is_abandoned
) VALUES
(
	1, 1, 2, 1,
	54000,
	'2026-09-01 20:00:00',
	'2026-09-01 20:48:00',
	'2026-09-01 21:03:00',
	'2026-09-01 21:51:00',
	FALSE
),
(
	2, 3, 4, 3,
	95000,
	'2026-09-02 20:00:00',
	'2026-09-02 20:47:00',
	'2026-09-02 21:02:00',
	'2026-09-02 21:50:00',
	FALSE
),
(
	3, 2, 4, 2,
	88000,
	'2026-09-05 18:00:00',
	'2026-09-05 18:47:00',
	'2026-09-05 19:02:00',
	'2026-09-05 19:49:00',
	FALSE
);


INSERT INTO goal (goal_id, minute, goal_type, match_id, player_id) VALUES
(1, 23, 'N', 1, 3),
(2, 67, 'N', 1, 6),
(3, 35, 'N', 2, 9),
(4, 72, 'P', 2, 10),
(5, 41, 'N', 3, 6),
(6, 83, 'N', 3, 9);


INSERT INTO substitute (
	substitute_id,
	minute,
	player_out,
	player_in,
	match_id
) VALUES
(1, 60, 3, 4, 1),
(2, 70, 6, 7, 1),
(3, 65, 10, 9, 2),
(4, 75, 9, 10, 3);


INSERT INTO card (
	card_id,
	minute,
	card_type,
	match_id,
	player_id
) VALUES
(1, 30, 'yellow', 1, 1),
(2, 55, 'yellow', 1, 5),
(3, 62, 'yellow', 2, 10),
(4, 78, 'red', 2, 8),
(5, 25, 'yellow', 3, 6);


INSERT INTO match_official (official_role_id, person_id, match_id) VALUES
(1, 15, 1),
(2, 16, 1),
(3, 17, 1),
(4, 18, 1),

(1, 16, 2),
(2, 15, 2),
(3, 18, 2),

(1, 17, 3),
(2, 16, 3),
(4, 15, 3);


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
SELECT pe.first_name,
    pe.last_name,
    t.country_name AS team,
    s.name AS stadium,
    g.minute
FROM goal g
    JOIN player p ON g.player_id = p.player_id
    JOIN person pe ON p.person_id = pe.person_id
    JOIN team t ON p.team_id = t.team_id
    JOIN match m ON g.match_id = m.match_id
    JOIN stadium s ON m.stadium_id = s.stadium_id
ORDER BY g.match_id,
    g.minute;

-- ---------------------------------------------------------------------
-- Query 2 (aggregate function)
-- NL: How many goals has each team scored in the tournament?
-- RA: team_id, country_name γ COUNT(goal_id) → total_goals (
--    (goal ⋈_goal.player_id = player.player_id  player)
--          ⋈_player.team_id = team.team_id  team )
-- ---------------------------------------------------------------------
SELECT t.country_name,
    COUNT(g.goal_id) AS total_goals
FROM goal g
    JOIN player p ON g.player_id = p.player_id
    JOIN team t ON p.team_id = t.team_id
GROUP BY t.team_id,
    t.country_name
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
SELECT DISTINCT pe.first_name,
    pe.last_name
FROM goal g
    JOIN player p ON g.player_id = p.player_id
    JOIN person pe ON p.person_id = pe.person_id
WHERE g.match_id IN (
        SELECT match_id
        FROM match
        WHERE attendance = (
                SELECT MAX(attendance)
                FROM match
            )
    );

-- ---------------------------------------------------------------------
-- Query 4 (self join)
-- NL: Find all pairs of players who play for the same team and in the
--     same position (each pair listed once).
-- RA: π_{p1.last_name, p2.last_name, p1.position, country_name} (
--       ( ρ_{p1} (player ⋈_{player.person_id = person.person_id} person)
--         ⋈_{p1.team_id = p2.team_id ∧ p1.position = p2.position ∧ p1.player_id < p2.player_id}
--         ρ_{p2} (player ⋈_{player.person_id = person.person_id} person) )
--       ⋈_{p1.team_id = team.team_id} team )
-- ---------------------------------------------------------------------
SELECT pe1.last_name AS player_1,
    pe2.last_name AS player_2,
    p1.position,
    t.country_name AS team
FROM player p1
    JOIN player p2 ON p1.team_id = p2.team_id
    AND p1.position = p2.position
    AND p1.player_id < p2.player_id
    JOIN person pe1 ON p1.person_id = pe1.person_id
    JOIN person pe2 ON p2.person_id = pe2.person_id
    JOIN team t ON p1.team_id = t.team_id;

-- ---------------------------------------------------------------------
-- Query 5 (set operation)
-- NL: Which players both scored a goal and received a card?
-- RA: Both ← π player_id (goal) ∩ π player_id (card)
--     π first_name, last_name (
--       (Both ⋈_{Both.player_id = player.player_id} player)
--         ⋈_{player.person_id = person.person_id} person )
-- ---------------------------------------------------------------------
SELECT pe.first_name,
    pe.last_name
FROM player p
    JOIN person pe ON p.person_id = pe.person_id
WHERE p.player_id IN (
        SELECT player_id
        FROM goal
        INTERSECT
        SELECT player_id
        FROM card
    );

