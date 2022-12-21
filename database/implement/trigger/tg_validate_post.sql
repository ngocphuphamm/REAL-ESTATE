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
 