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