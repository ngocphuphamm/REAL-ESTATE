use bds; 

DROP TRIGGER IF EXISTS tg_after_auto_update_viewcount;
DELIMITER $$
CREATE TRIGGER tg_after_auto_update_viewcount
after INSERT
ON saveposts FOR EACH ROW
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
 
INSERT INTO saveposts(savePostId,reid, userid)
	VALUES (uuid(),'3f4e3910-73ee-11ed-b4c1-c8b29b839518','83bac6b8-7617-11ed-b4c1-c8b29b839518');
 
 SELECT * 
 FROM posts;
 
 select * 
 from users