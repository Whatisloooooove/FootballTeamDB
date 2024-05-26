-- Функция для подбора лучшего состава игроков с учётом травм
CREATE OR REPLACE FUNCTION SelectBestTeam()
RETURNS TABLE(
    player_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    player_position VARCHAR(50),
    nationality VARCHAR(50),
    age INT,
    match_rating DECIMAL(5, 2),
    is_health BOOL
) AS $$
DECLARE
    selected_players INT[];
BEGIN
    -- Выбираем лучших защитников
    SELECT ARRAY_AGG(def.player_id)
    INTO selected_players
    FROM (
        SELECT p.player_id
        FROM Football.Players p
        JOIN Football.MatchStats ms ON p.player_id = ms.player_id
        JOIN Football.Injuries i ON p.player_id = i.player_id
        WHERE p.position = 'Defender'
        ORDER BY ms.match_rating DESC
        LIMIT 4
    ) AS def;

    RETURN QUERY
    SELECT p.*, ms.match_rating, i.is_health
    FROM Football.Players p
    JOIN Football.MatchStats ms ON p.player_id = ms.player_id
    JOIN Football.Injuries i ON p.player_id = i.player_id
    WHERE p.player_id = ANY(selected_players);

    -- Выбираем лучших полузащитников
    SELECT ARRAY_AGG(mid.player_id)
    INTO selected_players
    FROM (
        SELECT p.player_id
        FROM Football.Players p
        JOIN Football.MatchStats ms ON p.player_id = ms.player_id
        JOIN Football.Injuries i ON p.player_id = i.player_id
        WHERE p.position = 'Midfielder'
        ORDER BY ms.match_rating DESC
        LIMIT 4
    ) AS mid;

    RETURN QUERY
    SELECT p.*, ms.match_rating, i.is_health
    FROM Football.Players p
    JOIN Football.MatchStats ms ON p.player_id = ms.player_id
    JOIN Football.Injuries i ON p.player_id = i.player_id
    WHERE p.player_id = ANY(selected_players);

    -- Выбираем лучших нападающих
    SELECT ARRAY_AGG(forw.player_id)
    INTO selected_players
    FROM (
        SELECT p.player_id
        FROM Football.Players p
        JOIN Football.MatchStats ms ON p.player_id = ms.player_id
        JOIN Football.Injuries i ON p.player_id = i.player_id
        WHERE p.position = 'Forward'
        ORDER BY ms.match_rating DESC
        LIMIT 3
    ) AS forw;

    RETURN QUERY
    SELECT p.*, ms.match_rating, i.is_health
    FROM Football.Players p
    JOIN Football.MatchStats ms ON p.player_id = ms.player_id
    JOIN Football.Injuries i ON p.player_id = i.player_id
    WHERE p.player_id = ANY(selected_players);

    -- Выбираем лучшего вратаря
    RETURN QUERY
    SELECT p.*, ms.match_rating, i.is_health
    FROM Football.Players p
    JOIN Football.MatchStats ms ON p.player_id = ms.player_id
    JOIN Football.Injuries i ON p.player_id = i.player_id
    WHERE p.position = 'Goalkeeper'
    ORDER BY ms.match_rating DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Функция для обновления контракта игрока
CREATE OR REPLACE PROCEDURE UpdatePlayerContract(player_first_name VARCHAR, player_last_name VARCHAR, new_salary INT, new_start_date DATE, new_end_date DATE)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Football.Contracts
    SET salary = new_salary, start_date = new_start_date, end_date = new_end_date
    WHERE player_id = (SELECT player_id FROM Football.Players WHERE first_name = player_first_name AND last_name = player_last_name);
    COMMIT;
END;
$$;



-- Функция для добавления травмы игрока
CREATE OR REPLACE PROCEDURE AddPlayerInjuryByName(
    IN firstName VARCHAR(50),
    IN lastName VARCHAR(50),
    IN isHealth BOOLEAN,
    IN injuryType VARCHAR(100),
    IN recoveryDuration INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    playerId INT;
BEGIN
    SELECT player_id INTO playerId
    FROM Football.Players
    WHERE first_name = firstName AND last_name = lastName;

    IF playerId IS NOT NULL THEN
        INSERT INTO Football.Injuries(player_id, is_health, injury_type, recovery_duration)
        VALUES (playerId, isHealth, injuryType, recoveryDuration);
    ELSE
        RAISE EXCEPTION 'Player not found';
    END IF;
END;
$$;