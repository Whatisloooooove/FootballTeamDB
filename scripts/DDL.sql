DROP SCHEMA IF EXISTS Football CASCADE;
CREATE SCHEMA Football;

CREATE TABLE Football.Players (
    player_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50) NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE Football.Contracts (
    contract_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL,
    salary INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (player_id) REFERENCES Football.Players(player_id)
);

CREATE TABLE Football.Injuries (
    injury_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL ,
    is_health BOOL NOT NULL,
    injury_type VARCHAR(100),
    recovery_duration INT,
    FOREIGN KEY (player_id) REFERENCES Football.Players(player_id)
);

CREATE TABLE Football.LeaguePerformances (
    match_id INT PRIMARY KEY,
    points INT NOT NULL,
    goals_scored INT NOT NULL,
    goals_conceded INT NOT NULL
);

CREATE TABLE Football.MatchStats (
    match_id INT,
    player_id INT NOT NULL,
    match_rating DECIMAL(5, 2),
    successful_shots_percentage DECIMAL(5, 2),
    tackles_percentage DECIMAL(5, 2),
    FOREIGN KEY (match_id) REFERENCES Football.LeaguePerformances(match_id),
    FOREIGN KEY (player_id) REFERENCES Football.Players(player_id)
);

CREATE TABLE Football.ContractHistory (
    contract_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL,
    salary INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contract_id) REFERENCES Football.Contracts(contract_id),
    FOREIGN KEY (player_id) REFERENCES Football.Players(player_id)
);
