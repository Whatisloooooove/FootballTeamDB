-- Триггер для проверки дат при добавлении контракта
CREATE OR REPLACE FUNCTION check_contract_dates()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.start_date >= NEW.end_date THEN
        RAISE EXCEPTION 'Start date must be before end date';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_contract_dates
BEFORE INSERT OR UPDATE ON Football.Contracts
FOR EACH ROW EXECUTE FUNCTION check_contract_dates();



-- Триггер для автоматического обновления истории контрактов при появлении нового
CREATE OR REPLACE FUNCTION UpdateContractHistory()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Football.ContractHistory (player_id, salary, start_date, end_date)
    VALUES (NEW.player_id, NEW.salary, NEW.start_date, NEW.end_date);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER contract_update_trigger
AFTER UPDATE ON Football.Contracts
FOR EACH ROW EXECUTE FUNCTION UpdateContractHistory();


-- Триггер, который уведомляет , что сегодня истекает контракт у игрока
CREATE OR REPLACE FUNCTION NotifyContractEnd()
RETURNS TRIGGER AS $$
DECLARE
    contract_end_date DATE;
BEGIN
    SELECT end_date INTO contract_end_date
    FROM Football.Contracts
    WHERE player_id = NEW.player_id;

    IF contract_end_date = CURRENT_DATE THEN
        RAISE NOTICE 'Контракт игрока % % истекает сегодня!', NEW.first_name, NEW.last_name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER contract_end_notification_trigger
BEFORE INSERT OR UPDATE ON Football.Contracts
FOR EACH ROW EXECUTE FUNCTION NotifyContractEnd();
