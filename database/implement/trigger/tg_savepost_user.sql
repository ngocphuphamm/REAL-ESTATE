use bds; 

DROP TRIGGER IF EXISTS tg_before_validate_save_user;
DELIMITER $$
CREATE TRIGGER tg_before_validate_save_user
BEFORE INSERT
ON savePosts FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
    DECLARE is_user_save INT DEFAULT -1;
    
    SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_before_validate_save_user: ', cast(new.userid as char));
	
    SELECT COUNT(*) INTO is_user_save
    FROM savePosts
    WHERE reid = new.reid AND  userid = new.userid;

    
    IF  is_user_save > 0  THEN 
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
    
END $$
 DELIMITER ;