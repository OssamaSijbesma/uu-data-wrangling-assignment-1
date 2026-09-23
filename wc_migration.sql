CREATE TABLE staff_role (
	staff_role_id INT PRIMARY KEY,
	role_name VARCHAR NOT NULL
);

CREATE TABLE official_role (
	official_role_id INT PRIMARY KEY,
	role_name VARCHAR NOT NULL
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
	staff_member_id INT PRIMARY KEY,
	person_id INT NOT NULL,
	staff_role_id INT NOT NULL,
	team_id INT NOT NULL,
	
	FOREIGN KEY (person_id) REFERENCES person(person_id),
	FOREIGN KEY (staff_role_id) REFERENCES staff_role(staff_role_id),
	FOREIGN KEY (team_id) REFERENCES team(team_id)
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
	first_half_start DATETIME,
	first_half_end DATETIME,
	second_half_start DATETIME,
	second_half_end DATETIME,
	is_abandoned BOOLEAN NOT NULL,

	CHECK (team_1_id <> team_2_id),

	FOREIGN KEY (team_1_id) REFERENCES team(team_id),
	FOREIGN KEY (team_2_id) REFERENCES team(team_id),
	FOREIGN KEY (stadium_id) REFERENCES stadium(stadium_id)
);

CREATE TABLE goal (
	goal_id INT PRIMARY KEY,
	minute INT NOT NULL,
	goal_type CHAR NOT NULL,
	match_id INT NOT NULL,
	player_id INT NOT NULL,
	
	FOREIGN KEY (match_id) REFERENCES match(match_id),
	FOREIGN KEY (player_id) REFERENCES player(player_id)
);

CREATE TABLE substitute (
	substitute_id INT PRIMARY KEY,
	minute INT NOT NULL,
	player_out INT NOT NULL,
	player_in INT NOT NULL,
	match_id INT NOT NULL,

	FOREIGN KEY (player_in) REFERENCES player(player_id),
	FOREIGN KEY (player_out) REFERENCES player(player_id),
	FOREIGN KEY (match_id) REFERENCES match(match_id)
);

CREATE TABLE card (
	card_id INT PRIMARY KEY,
	minute INT NOT NULL,
	card_type VARCHAR NOT NULL CHECK (card_type IN ("yellow", "red")),
	match_id INT NOT NULL,
	player_id INT NOT NULL,
	
	FOREIGN KEY (match_id) REFERENCES match(match_id),
	FOREIGN KEY (player_id) REFERENCES player(player_id)
);

CREATE TABLE match_official (
	official_role_id INT NOT NULL,
	person_id INT NOT NULL,
	match_id INT NOT NULL,
	
	PRIMARY KEY (official_role_id, person_id, match_id),

    FOREIGN KEY (official_role_id) REFERENCES official_role(official_role_id),
    FOREIGN KEY (person_id) REFERENCES person(person_id),
    FOREIGN KEY (match_id) REFERENCES match(match_id)
)


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


INSERT INTO staff_member (staff_member_id, person_id, staff_role_id, team_id) VALUES
(1, 1, 1, 1),
(2, 12, 2, 1),
(3, 13, 3, 1),
(4, 14, 1, 2);


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
