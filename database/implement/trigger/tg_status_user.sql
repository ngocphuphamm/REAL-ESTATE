DROP TRIGGER IF EXISTS tg_before_status_user;

DELIMITER $$
CREATE TRIGGER tg_before_status_user
BEFORE INSERT
ON users FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
    IF NEW.status <> 0  AND NEW.status <> 1 THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_before_type_user: ', cast(new.status as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
END $$
DELIMITER ;
