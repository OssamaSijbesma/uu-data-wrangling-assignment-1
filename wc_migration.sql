CREATE TABLE staff_role (
	staff_role_id INT PRIMARY KEY,
	role_name VARCHAR NOT NULL
)

CREATE TABLE official_role (
	official_role_id INT PRIMARY KEY,
	role_name VARCHAR NOT NULL
)

CREATE TABLE stadium (
	
)

CREATE TABLE person (
	person_id INT PRIMARY KEY,
	last_name VARCHAR NOT NULL,
	first_name VARCHAR,
	birth_date DATETIME NOT NULL
)

CREATE TABLE team (
	team_id int PRIMARY KEY,
	country_name varchar NOT NULL,
	fifa_rank INT NOT NULL
	
)

CREATE TABLE staff_member (
	
	
)

CREATE TABLE player (
	player_id int PRIMARY KEY,
	FOREIGN KEY (person_id) REFERENCES person(person_id),
	position varchar NOT NULL,
	jersey_number int NOT NULL

)

CREATE TABLE match (
	
)

CREATE TABLE goal (
	goal_id int PRIMARY KEY,
	minute int NOT NULL,
	goal_type char NOT NULL,
	FOREIGN KEY (match_id) REFERENCES match(match_id),
	FOREIGN KEY (player_id) REFERENCES player(player_id)
	
)

CREATE TABLE substitute (
	
)

CREATE TABLE card (
	card_id INT PRIMARY KEY,
	minute INT NOT NULL,
	card_type VARCHAR NOT NULL CHECK (card_type IN ("yellow", "red")),
	FOREIGN KEY (match_id) REFERENCES match(match_id),
	FOREIGN KEY (player_id) REFERENCES player(player_id)
)

CREATE TABLE match_official (
	official_role_id int PRIMARY KEY,
	person_id int PRIMARY KEY,
	match_id int PRIMARY KEY
	
)
