-- 1. Узнать средний возраст игроков по наицональностям
SELECT nationality, AVG(age) AS avg_age
FROM Football.Players
GROUP BY nationality
ORDER BY avg_age DESC;

-- Результат
--    | Poland    | 36    |
--    | Germany   | 32    |
--    | Denmark   | 27    |
--    | Portugal  | 26.5  |
--    | Nederland | 26    |
--    | Uruguay   | 25    |
--    | France    | 25    |
--    | Spain     | 23.69 |
--    | Brazil    | 23    |


-- 2. Узнать количество контрактов и среднюю зарплату по позициям
SELECT position, COUNT(contract_id) AS contract_count, AVG(salary) AS avg_salary
FROM Football.Players
JOIN Football.Contracts ON Football.Players.player_id = Football.Contracts.player_id
GROUP BY position
ORDER BY contract_count DESC;

-- Результат:
--   | Defender   | 10 | 135750    |
--   | Forward    | 6  | 176762.83 |
--   | Midfielder | 6  | 244166.83 |
--   | Goalkeeper | 2  | 91827     |


-- 3. Топ 5 игроков с наивысшим рейтингом в матчах
SELECT first_name, last_name, match_rating
FROM Football.Players
JOIN Football.MatchStats ON Football.Players.player_id = Football.MatchStats.player_id
ORDER BY match_rating DESC
LIMIT 5;

-- Реззультат:
--   | Robert | Lewandowski | 9.20 |
--   | Pau    | Cubarasi    | 7.90 |
--   | Ilkay  | Gündoğan    | 7.80 |
--   | João   | Félix       | 7.50 |
--   | Fermin | López       | 7.40 |


-- 4. Узнать сколько игроков выбыли более чем на месяц
SELECT COUNT(*) AS num_injured_players
FROM Football.Players
JOIN Football.Injuries ON Football.Players.player_id = Football.Injuries.player_id
WHERE is_health = FALSE AND recovery_duration > 30;

-- Результат:
-- | 1 |


-- 5. Узнать сколько голов в среднем за матч забивает команда
SELECT AVG(goals_scored) AS avg_goals_scored
FROM Football.LeaguePerformances;

-- Результат:
-- | 2.0740740740740741 |


-- 6. Средний рейтинг игроков по возрастным группам
SELECT CASE
           WHEN age BETWEEN 15 AND 20 THEN '15-20'
           WHEN age BETWEEN 21 AND 25 THEN '21-25'
           WHEN age BETWEEN 26 AND 30 THEN '26-30'
           ELSE '31+'
       END AS age_group,
       AVG(ms.match_rating) AS avg_rating
FROM Football.Players p
JOIN Football.MatchStats ms ON p.player_id = ms.player_id
GROUP BY age_group
ORDER BY age_group;

-- Результат:
-- | 15-20 | 6.92               |
-- | 21-25 | 7.3666666666666667 |
-- | 26-30 | 6.8                |
-- | 31+   | 7.3833333333333333 |


-- 7. Среднее время восстановления от травм по типу травмы
SELECT injury_type, AVG(recovery_duration) AS avg_recovery_time
FROM Football.Injuries
WHERE recovery_duration IS NOT NULL
GROUP BY injury_type
ORDER BY avg_recovery_time DESC;

-- Результат:
-- | cruciate ligament tear | 223 |
-- | tendon rupture         | 127 |
-- | hamstring injury       | 49  |
-- | ankle injury           | 35  |


-- 8. Список контрактов с зарплатой выше 200к евро и их длительность в днях
SELECT
    p.first_name || ' ' || p.last_name AS player_name,
    c.salary,
    (c.end_date - c.start_date) AS contract_duration
FROM
    Football.Players p
JOIN
    Football.Contracts c ON p.player_id = c.player_id
WHERE
    c.salary > 200000
ORDER BY
    contract_duration DESC;

-- Результат:
--   | Frenkie de Jong    | 721154 | 2079 |
--   | Raphinha           | 240385 | 1813 |
--   | Jules Koundé       | 260577 | 1798 |
--   | Robert Lewandowski | 520769 | 1442 |
--   | İlkay Gündoğan     | 360577 | 730  |
--   | João Cancelo       | 240385 | 303  |


-- 9. Количество заключенных контрактотв по годам
SELECT EXTRACT(YEAR FROM start_date) AS contract_year, COUNT(*) AS contract_count
FROM Football.Contracts
GROUP BY contract_year
ORDER BY contract_year;

-- Результат:
-- | 2020 | 1  |
-- | 2021 | 1  |
-- | 2022 | 10 |
-- | 2023 | 10 |
-- | 2024 | 2  |


-- 10. Сумма зарплат всех игроков
SELECT SUM(salary) AS total_salary
FROM Football.Contracts;

-- Результат:
-- | 4066732 |

