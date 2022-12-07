use bds;

DROP TRIGGER IF EXISTS tg_after_username;
DELIMITER $$
CREATE TRIGGER tg_after_username
BEFORE INSERT
ON users FOR EACH ROW
BEGIN
    DECLARE is_exists_username INT DEFAULT -1; 
	DECLARE msg VARCHAR(200);
    
    SELECT COUNT(*) INTO is_exists_username
    FROM  users U
    WHERE U.username = new.username;
    
    SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_after_username: ', cast(new.username as char));
	IF is_exists_username > 0  THEN 
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	END IF;
END $$
 DELIMITER ;


SELECT * 
FROM USERS ;
 SET SQL_SAFE_UPDATES = 0;

INSERT INTO  USERS(userid ,name,username,email,password,typeuser,phone,status) 
values (uuid(),"Ngọc Phú","ngocphupham",
		"ngocphupham682001@gmail.com","123145",0,"0909603123",0);