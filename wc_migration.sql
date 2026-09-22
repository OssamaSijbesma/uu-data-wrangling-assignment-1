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
	
)

CREATE TABLE staff_member (
	
)

CREATE TABLE player (
	

)

CREATE TABLE match (
	
)

CREATE TABLE goal (
	
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
	
)