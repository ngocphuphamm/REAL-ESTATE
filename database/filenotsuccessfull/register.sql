use bds; 

DELIMITER $$
DROP FUNCTION IF EXISTS fnc_SHAPassword $$
CREATE FUNCTION fnc_SHAPassword(pr_password varchar(50), pr_private_key varchar(50) )
RETURNS VARCHAR(50)
DETERMINISTIC
begin
    return sha1(concat(pr_password, pr_private_key));
END; $$



DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Register $$
CREATE PROCEDURE sp_Register(pr_username varchar(50), pr_password varchar(50),pr_name varchar(150),pr_email varchar(100),pr_phone varchar(11))
BEGIN
	DECLARE isExists int DEFAULT -1;
    DECLARE pw varchar(50);
    DECLARE privateKey text DEFAULT uuid();

	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;

    SELECT COUNT(*) INTO isExists
    FROM users U
	WHERE U.username = pr_username;
	IF (isExists>0) THEN
		SELECT 'Tài khoản đã tồn tại !';
	ELSE
		SET pw= fnc_SHAPassword(pr_password, privateKey);
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO USERS(userid ,name,username,email,password,phone)
			VALUES (privateKey,pr_name,pr_username,pr_email,pw,pr_phone);
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        
        SELECT 1 ;
    END IF;    
END; $$

SELECT row_count()