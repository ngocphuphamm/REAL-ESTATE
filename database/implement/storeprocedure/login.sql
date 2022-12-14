DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Login $$
CREATE PROCEDURE sp_Login(pr_username varchar(50), pr_password varchar(50)) 
BEGIN	
    DECLARE private_key VARCHAR(50);
    DECLARE isExists INT DEFAULT -1;
    DECLARE pw VARCHAR(50)  ;

    SELECT  u.userid INTO private_key  FROM users u WHERE u.username= pr_username;

    SET pw=fnc_SHAPassword(pr_password, private_key); #function này đã tạo ra ở bước trên

    SELECT COUNT(*) INTO isExists FROM users u WHERE u.username=pr_username AND u.password=pw;
    
    IF(isExists >0) THEN
        SELECT u.name,  u.username,u.userid,
			   u.email, u.phone
        FROM users u
        where u.userid = private_key;
    ELSE
	    SELECT 0;
    END IF;
    
END; $$