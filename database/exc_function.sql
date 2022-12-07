use bds;
DELIMITER $$
DROP FUNCTION IF EXISTS fnc_checkNamePhoneReport $$
CREATE FUNCTION fnc_checkNamePhoneReport(pr_reid varchar(40), pr_phone varchar(40),pr_email varchar(40))
RETURNS INT
DETERMINISTIC
begin
	DECLARE result INT DEFAULT -1 ;
	
    SELECT COUNT(*) INTO result
	FROM report r 
    WHERE r.reid = pr_reid AND r.phone = pr_phone AND r.email = pr_email;
   
	IF (result > 0 ) THEN 
		SET result = 1;
	ELSE
		SET result = 0;
	END IF;
    
    RETURN result; 
END; $$


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_SHAPassword $$
CREATE FUNCTION fnc_SHAPassword(pr_password varchar(50), pr_private_key varchar(50) )
RETURNS VARCHAR(50)
DETERMINISTIC
begin
    return sha1(concat(pr_password, pr_private_key));
END; $$


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_checkAddress $$
CREATE FUNCTION fnc_checkAddress(pr_provinceid int, pr_districtid int,
								 pr_wardid int, pr_streetid int)
RETURNS INT 
DETERMINISTIC
begin
			DECLARE isCheck INT DEFAULT -1;
            
			SELECT COUNT(*) into isCheck
			FROM  province p JOIN ( SELECT districtid,provinceid,nameDistrict
									FROM district ) d
							 ON p.provinceid = d.provinceid 
							 JOIN (SELECT wardid,nameward,districtid
								   FROM ward) w 
							ON w.districtid = d.districtid
			WHERE p.provinceid = pr_provinceid AND d.districtid = pr_districtid AND w.wardid = pr_wardid;
			
            IF isCheck = 0 THEN 
				set isCheck = 1;
			ELSE 
				SET isCheck = 0 ;
			END IF;
            return isCheck;
END; $$



DELIMITER $$
DROP FUNCTION IF EXISTS fnc_checkUserID $$
CREATE FUNCTION fnc_checkUserID(pr_userid varchar(200) )
RETURNS TEXT 
DETERMINISTIC
begin
	DECLARE result text;
    DECLARE isExists int default -1;
    
    SELECT COUNT(*) INTO isExists 
    FROM users u 
    WHERE u.userid = pr_userid;
    
    IF(isExists > 0) THEN 
		SET result = pr_userid;
	ELSE
		SET result = null;
	END IF;
    
	RETURN result;
END; $$




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







