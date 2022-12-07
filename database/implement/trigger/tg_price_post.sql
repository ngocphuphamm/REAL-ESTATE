use bds; 

DROP TRIGGER IF EXISTS tg_before_validate_price_post;
DELIMITER $$
CREATE TRIGGER tg_before_validate_price_post
BEFORE INSERT
ON posts FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
	
    SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_after_username: ', cast(new.price as char));
	IF new.price < 100   THEN 
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	END IF;
END $$
 DELIMITER ;