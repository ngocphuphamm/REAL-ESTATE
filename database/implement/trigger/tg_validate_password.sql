use bds; 

DROP TRIGGER IF EXISTS tg_before_validate_password;
DELIMITER $$
CREATE TRIGGER tg_before_validate_password
BEFORE INSERT
ON users FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
		
    
    SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_after_username: ', cast(new.password as char));
	IF LENGTH(new.password) < 7  THEN 
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	END IF;
END $$
 DELIMITER ;