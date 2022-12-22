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

 DELETE 
 FROM savePosts
 WHERE userid = '83bac6b8-7617-11ed-b4c1-c8b29b839518';
 
 INSERT INTO savePosts(savePostId,reid,userid)
		VALUES(uuid(),'3f4e3910-73ee-11ed-b4c1-c8b29b839518','83bac6b8-7617-11ed-b4c1-c8b29b839518');
  
 INSERT INTO savePosts(savePostId,reid,userid)
		VALUES(uuid(),'3f4e3910-73ee-11ed-b4c1-c8b29b839518','028f405e-73ee-11ed-b4c1-c8b29b839518');
 
 UPDATE POSTS 
 SET viewCount = 1
 WHERE reid = '3f4e3910-73ee-11ed-b4c1-c8b29b839518';
 
 SELECT * 
 FROM posts;
 
 select * 
 from users;
 
 SELECT * 
 FROM savePosts;
 
 DELETE 
 FROM savePosts
 WHERE reid = '3f4e3910-73ee-11ed-b4c1-c8b29b839518';
 
 UPDATE posts
 SET viewCount = 2 
 WHERE reid = '3f4e3910-73ee-11ed-b4c1-c8b29b839518';