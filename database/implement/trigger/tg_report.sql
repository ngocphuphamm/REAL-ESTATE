use bds; 

DROP TRIGGER IF EXISTS tg_before_validate_report_user;
DELIMITER $$
CREATE TRIGGER tg_before_validate_report_user
BEFORE INSERT
ON report FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
	DECLARE is_exists_user_report_email INT DEFAULT -1; 
    DECLARE is_exists_user_report_phone INT DEFAULT -1;
    
    SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_after_username: ', cast(new.phone as char),'',cast(new.email as char));
	
    SELECT COUNT(*) INTO is_exists_user_report_email
    FROM report
    WHERE reid = new.reid and email = new.email;
    
    SELECT COUNT(*) INTO is_exists_user_report_phone
    FROM report
    WHERE reid = new.reid and phone = new.phone;
    
    IF  is_exists_user_report_email > 0 OR is_exists_user_report_phone > 0 THEN 
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
    
END $$
 DELIMITER ;