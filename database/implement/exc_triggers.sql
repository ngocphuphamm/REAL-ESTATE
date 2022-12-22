use bds; 

DROP TRIGGER IF EXISTS tg_after_auto_update_reduce_viewcount;
DELIMITER $$
CREATE TRIGGER tg_after_auto_update_reduce_viewcount
before DELETE
ON savePosts FOR EACH ROW
BEGIN
	DECLARE reid_need_update CHAR (40) DEFAULT NULL;
	DECLARE msg VARCHAR(200);
	DECLARE quantity_save INT DEFAULT -1;
    
	SET reid_need_update = (SELECT reid
							FROM savePosts
							WHERE userid = old.userid AND reid = old.reid);
   
    IF reid_need_update IS NULL OR reid_need_update = '' THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_after_auto_update_reduce_viewcount: ',cast(old.reid as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
    
	SET quantity_save = (SELECT viewCount
						 FROM posts
						 WHERE reid = reid_need_update) - 1;
	IF quantity_save < 0  THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_after_auto_update_reduce_viewcount quantity not right ');
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
    
    SET SQL_SAFE_UPDATES = 0;
		UPDATE posts
		SET viewCount = quantity_save
		WHERE reid = reid_need_update;
	SET SQL_SAFE_UPDATES = 1;
END $$
 DELIMITER ;


 use bds; 

DROP TRIGGER IF EXISTS tg_after_auto_update_viewcount;
DELIMITER $$
CREATE TRIGGER tg_after_auto_update_viewcount
after INSERT
ON savePosts FOR EACH ROW
BEGIN
	DECLARE reid_need_update CHAR (40) DEFAULT NULL;
	DECLARE msg VARCHAR(200);
	DECLARE quantity_save INT DEFAULT -1;
    
	SET reid_need_update = (SELECT reid
							FROM posts
							WHERE reid = new.reid);
   
    IF reid_need_update IS NULL OR reid_need_update = '' THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_after_auto_save_user: ',cast(new.reid as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
	SET quantity_save = (SELECT viewCount
						 FROM posts
						 WHERE reid = reid_need_update);
	SET SQL_SAFE_UPDATES = 0;
		UPDATE posts
		SET viewCount = quantity_save + 1
		WHERE reid = reid_need_update;
	SET SQL_SAFE_UPDATES = 1;
END $$
 DELIMITER ;
 


DROP TRIGGER IF EXISTS tg_before_limit_insert_medias;
DELIMITER $$
CREATE TRIGGER tg_before_limit_insert_medias
BEFORE INSERT
ON medias FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
	DECLARE quantity_medias INT DEFAULT -1;
    
    SET  quantity_medias = (SELECT COUNT(*)
						   FROM  medias
						   WHERE reid = new.reid);
   
    IF quantity_medias = 5  THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_before_limit_insert_medias: ',cast(new.reid as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
    
END $$
 DELIMITER ;

 
 
 select *
 from posts;
 
 select *
 from medias;



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
 
 DROP TRIGGER IF EXISTS tg_before_status_user;

DELIMITER $$
CREATE TRIGGER tg_before_status_user
BEFORE INSERT
ON users FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
    IF NEW.status <> 0  AND NEW.status <> 1 THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_before_type_user: ', cast(new.status as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
END $$
DELIMITER ;

use bds;

DROP TRIGGER IF EXISTS tg_before_type_user;
DELIMITER $$
CREATE TRIGGER tg_before_type_user
BEFORE INSERT
ON users FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
    IF  NEW.typeuser != 0 AND NEW.typeuser != 1 THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_before_type_user: ', cast(new.typeuser as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
END $$
DELIMITER ;

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
FROM users ;
 SET SQL_SAFE_UPDATES = 0;


DROP TRIGGER IF EXISTS tg_before_validate_password;
DELIMITER $$
CREATE TRIGGER tg_before_validate_password
BEFORE INSERT
ON users FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
		
    
    SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_after_username: ', cast(new.password as char));
	IF LENGTH(new.password) < 7  THEN 
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	END IF;
END $$
 DELIMITER ;
 
 use bds; 


DROP TRIGGER IF EXISTS tg_before_validate_post;
DELIMITER $$
CREATE TRIGGER tg_before_validate_post
BEFORE INSERT
ON posts FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
	DECLARE check_address  INT DEFAULT -1; 
	DECLARE count_posts INT DEFAULT -1;
    DECLARE checked_duplicate_name INT DEFAULT -1; 
    
    SELECT  COUNT(*) INTO check_address
    FROM province p JOIN (SELECT districtid, provinceid
						 FROM district) d
					ON d.provinceid = p.provinceid
                    JOIN (SELECT wardid, districtid 
						  FROM ward ) w  
					ON  w.districtid = d.districtid
                    JOIN (SELECT streetid, districtid
						  FROM street) s
					ON  s.districtid = w.districtid
    WHERE p.provinceid = new.provinceid AND d.districtid = new.districtid
		 AND w.wardid = new.wardid AND s.streetid = new.streetid;
	
	SELECT COUNT(p.reid) INTO count_posts
    FROM posts p 
    WHERE MONTH(p.createdat) = month(CURRENT_DATE()) AND p.userid = new.userid;
    
    SELECT COUNT(*) INTO checked_duplicate_name
    FROM posts p 
    WHERE p.title = new.title AND p.userid = new.userid;
    
    IF new.price < 100   THEN 
		SET msg =  concat('MyTriggerError: Trying to insert a negative price  in tg_before_validate_post: ', cast(new.price as char));
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	ELSEIF check_address <= 0 THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value address in tg_before_validate_post: ', cast(new.provinceid as char));
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	ELSEIF length(new.phone) < 9 OR length(new.phone) > 10  THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value  phone in tg_before_validate_post: ', cast(new.phone as char));
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	ELSEIF checked_duplicate_name > 0 THEN 
		SET msg =  concat('MyTriggerError: Trying to insert a negative value  TITLE in tg_before_validate_post: ', cast(new.title as char));
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	ELSEIF count_posts > 5 THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value count post in tg_before_validate_post: ', cast(count_posts as char));
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
	END IF;
    
END $$
 DELIMITER ;
 