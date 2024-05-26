'Players'

| Название    | Описание               | Тип данных  | Ограничение |
|-------------|------------------------|-------------|-------------|
| player_id   | идентификатор игрока   | integer     | primary key |
| first_name  | имя игрока             | varchar(50) |             |
| last_name   | фамилия игрока         | varchar(50) |             |
| position    | позиция на поле        | varchar(50) | NOT NULL    |
| nationality | национальность игрока  | varchar(50) | NOT NULL    |
| age         | возраст игрока         | int         | NOT NULL    |


'Contracts'

| Название    | Описание               | Тип данных  | Ограничение |
|-------------|------------------------|-------------|-------------|
| contract_id | идентификатор контракта| integer     | primary key |
| player_id   | идентификатор игрока   | integer     | foreign key |
| salary      | зарплата игрока        | int         |             |
| start_date  | дата начала контракта  | date        | NOT NULL    |
| end_date    | дата конца контракта   | date        | NOT NULL    |


'Injuries'

| Название             | Описание               | Тип данных   | Ограничение |
|----------------------|------------------------|--------------|-------------|
| injury_id            | идентификатор травмы   | integer      | primary key |
| player_id            | идентификатор игрока   | integer      | foreign key |
| is_health            | здоров ли игрок        | bool         | NOT NULL    |
| injury_type          | тип травмы             | varchar(100) |             |
| recovery_duration    | дни на восстановление  | int          |             |


'MatchStats'

| Название                   | Описание                 | Тип данных    | Ограничение |
|----------------------------|--------------------------|---------------|-------------|
| match_id                   | идентификатор матча      | integer       | primary key |
| player_id                  | идентификатор игрока     | integer       | foreign key |
| match_rating               | рейтинг за матч игрока   | deсimal(5, 2) |             |
| succesful_shots_percentage | процент успешных ударов  | deсimal(5, 2) |             |
| tackles_percentage         | процент успешных отборов | deсimal(5, 2) |             |


'LeaguePerfomance'

| Название                   | Описание                 | Тип данных    | Ограничение |
|----------------------------|--------------------------|---------------|-------------|
| match_id                   | идентификатор матча      | integer       | primary key |
| points                     | очков за матч            | integer       |  NOT NULL   |
| goals_scored               | забито голов за матч     | integer       |  NOT NULL   |
| goals_concded              | пропущено голов за матч  | integer       |  NOT NULL   |


'ContractHistory'

| Название    | Описание                  | Тип данных  | Ограничение |
|-------------|---------------------------|-------------|-------------|
| contract_id | идентификатор контракта   | integer     | primary key |
| player_id   | идентификатор игрока      | integer     | foreign key |
| salary      | зарплата игрока           | int         |             |
| start_date  | дата начала контракта     | date        | NOT NULL    |
| end_date    | дата конца контракта      | date        | NOT NULL    |
| changed_at  | время изменения контракта | timestamp   |             |

