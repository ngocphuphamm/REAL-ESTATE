use bds ;


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_authorization$$
CREATE FUNCTION fnc_check_authorization(pr_id_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_admin char(40) DEFAULT NULL;
     
     SELECT u.name into is_admin 
     FROM users u   
     WHERE u.typeuser = 1 AND  u.userid = pr_id_user;
     
     IF is_admin IS NULL THEN
		RETURN FALSE;
	 END IF;
    
	RETURN TRUE;
END; $$


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_is_exists_user$$
CREATE FUNCTION fnc_is_exists_user(pr_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_exists char(40) DEFAULT NULL;
     
	 SELECT COUNT(*) INTO is_exists
     FROM users u   
     WHERE u.userid = pr_user;
     
     
     IF is_exists > 0 THEN  
		RETURN TRUE;
	 END IF;
     
	 RETURN FALSE;
END; $$



DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_blocked_user$$
CREATE FUNCTION fnc_check_blocked_user(pr_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	DECLARE check_blocked INT DEFAULT -1; 
    
    SELECT COUNT(*) INTO check_blocked
    FROM users u 
    WHERE  u.userid = pr_user AND  u.status = 1;
    
    IF check_blocked > 0 THEN
		RETURN TRUE;
    END IF;
    RETURN FALSE;
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_recovery_user $$
CREATE PROCEDURE sp_recovery_user(pr_id_user char(40), pr_id_user_block char(40)) 
BEGIN	
    DECLARE is_admin INT DEFAULT 0;
    DECLARE is_exists_user INT DEFAULT -1; 
    DECLARE is_check_blocked INT DEFAULT -1;
    SET is_exists_user = fnc_is_exists_user(pr_id_user_block);
    
    IF is_exists_user = 0 THEN 
		SELECT 0 as "status", "User không tồn tại" as "message", "" as "data";
    ELSE 
		SET is_admin = fnc_check_authorization(pr_id_user);
		IF is_admin = 1 THEN  
			SET is_check_blocked = fnc_check_blocked_user(pr_id_user_block);
			IF is_check_blocked > 0 THEN 
            	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
					START TRANSACTION;
						SET SQL_SAFE_UPDATES = 0;
							UPDATE users
							SET status = 0
							WHERE userid = pr_id_user_block;
						SET SQL_SAFE_UPDATES = 1;
					COMMIT;
					SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
                    
					SELECT 1 as "status","Update thành công" as "message",'' as "data"  ;
				
			ELSE 
				SELECT 0 as "status", "User không bị chặn" as "message",'' as "data";
            END IF;
		ELSE 
			SELECT 0 as "status","Bạn Không Phải Admin" as "message",'' as "data";
		END IF;
	END IF;
END; $$


CALL sp_recovery_user("d5ef3568-634c-11ed-b1d9-00155d87afbf","41febb60-7233-11ed-b4c1-c8b29b839518")


