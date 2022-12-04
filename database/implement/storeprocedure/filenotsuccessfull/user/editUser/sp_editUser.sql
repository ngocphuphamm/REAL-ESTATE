use bds 

SELECT * FROM USERS

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Edit_User $$
CREATE PROCEDURE sp_Edit_User(pr_userid char(40),pr_name varchar(150), pr_phone varchar(100)) 
BEGIN	
	DECLARE isExistsUser INT DEFAULT -1; 
    
    SELECT COUNT(*) INTO isExistsUser
    FROM users u
    WHERE u.userid = pr_userid;
    
    IF isExistsUser <= 0 THEN
		SELECT "USER KHÔNG TỒN TẠI";
	ELSE
        START TRANSACTION;
			SET SQL_SAFE_UPDATES=0;
			UPDATE users 
			SET name = pr_name , phone = pr_phone
            WHERE  userid = pr_userid;
			SET SQL_SAFE_UPDATES=1;
		COMMIT; 
		
        SELECT userid,name,username,email,phone
        FROM users u
		WHERE u.userid = pr_userid;
    END IF;
    
END; $$

select @@transaction_isolation;
