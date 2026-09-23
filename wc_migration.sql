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
	team_1_id INT NOT NULL CHECK (team_1_id <> team_2_id),
	team_2_id INT NOT NULL CHECK (team_1_id <> team_2_id),
	stadium_id INT NOT NULL,
	attendance INT,
	first_half_start DATETIME,
	first_half_end DATETIME,
	second_half_start DATETIME,
	second_half_end DATETIME,
	is_abandoned BOOLEAN NOT NULL,

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
	official_role_id INT PRIMARY KEY,
	person_id INT NOT NULL,
	match_id INT NOT NULL
	
	PRIMARY KEY (official_role_id, person_id, match_id),

    FOREIGN KEY (official_role_id) REFERENCES official_role(official_role_id),
    FOREIGN KEY (person_id) REFERENCES person(person_id),
    FOREIGN KEY (match_id) REFERENCES match(match_id)
)
