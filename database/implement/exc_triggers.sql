use bds;

DROP TRIGGER IF EXISTS tg_after_username;
DELIMITER $$
CREATE TRIGGER tg_after_username
AFTER INSERT
ON users FOR EACH ROW
BEGIN
    DECLARE is_exists_username INT DEFAULT -1; 
	DECLARE msg VARCHAR(200);
    
    SELECT COUNT(*) INTO is_exists_username
    FROM  users U
    WHERE U.username = NEW.username;
    
    SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_after_username: ', cast(new.username as char));
	IF is_exists_username > 0 THEN 
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	END IF;
END $$
 DELIMITER ;
 
 
 
DROP TRIGGER IF EXISTS tg_before_type_user;
DELIMITER $$
CREATE TRIGGER tg_before_type_user
BEFORE INSERT
ON users FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
    IF NEW.typeuser <> 0  AND NEW.typeuser <> 1 THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_before_type_user: ', cast(new.typeuser as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
END $$
DELIMITER ;
