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
DROP FUNCTION IF EXISTS fnc_is_exists_posts$$
CREATE FUNCTION fnc_is_exists_posts(pr_posts char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_exists char(40) DEFAULT NULL;
     
	 SELECT COUNT(reid) INTO is_exists
     FROM posts p  
     WHERE p.reid = pr_posts;
     
     
     IF is_exists > 0 THEN  
		RETURN TRUE;
	 END IF;
     
	 RETURN FALSE;
END; $$



DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_blocked$$
CREATE FUNCTION fnc_check_blocked(pr_posts char(40))
RETURNS boolean
DETERMINISTIC
begin
	DECLARE check_blocked INT DEFAULT -1; 
    
    SELECT COUNT(reid) INTO check_blocked
    FROM posts p 
    WHERE  p.reid = pr_posts AND p.approve = 1;
    
    IF check_blocked > 0 THEN
		RETURN TRUE;
    END IF;
    RETURN FALSE;
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_bans_post $$
CREATE PROCEDURE sp_bans_post(pr_idUser char(40), pr_id_post char(40)) 
BEGIN	
    DECLARE is_admin INT DEFAULT 0;
    DECLARE is_exists_posts INT DEFAULT -1; 
    DECLARE is_check_blocked INT DEFAULT -1;
    SET is_exists_posts = fnc_is_exists_posts(pr_id_post);
    
    IF is_exists_posts = 0 THEN 
		SELECT "Post not exists";
    ELSE 
		SET is_admin = fnc_check_authorization(pr_idUser);
		IF is_admin = 1 THEN  
			SET is_check_blocked = fnc_check_blocked(pr_id_post);
			IF is_check_blocked > 0 THEN 
				SELECT 0 as "status", "POST BLOCKED" as "message",'' as "data";
			ELSE 
					SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
					START TRANSACTION;
						SET SQL_SAFE_UPDATES = 0;
							UPDATE posts
							SET approve = 1
							WHERE reid = pr_id_post;
						SET SQL_SAFE_UPDATES = 1;
					COMMIT;
					SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
                    
					SELECT 1 as "status","SUCCESS UPDATE" as "message",'' as "data"  ;
            END IF;
		ELSE 
			SELECT 0 as "status","Not right admin" as "message",'' as "data";
		END IF;
	END IF;
END; $$

CALL sp_bans_post("d5ef3568-634c-11ed-b1d9-00155d87afbf","77ebde3d-634d-11ed-b1d9-00155d87afbf")


