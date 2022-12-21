use bds; 

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_remove_feed $$
CREATE PROCEDURE sp_remove_feed(pr_reid varchar(200), pr_userid varchar(200)) 
BEGIN	
    DECLARE isExists INT DEFAULT -1;
	DECLARE isBlocked INT DEFAULT -1; 
    
    SELECT COUNT(*) INTO isExists 
    FROM posts 
    WHERE reid = pr_reid AND userid = pr_userid ;
    
	SELECT COUNT(*) INTO isBlocked 
    FROM posts 
    WHERE reid = pr_reid AND userid = pr_userid AND approve = 1;
    
    
    IF(isExists < 0) THEN
		SELECT 0 as 'status', 'Bài post không tồn tại hoặc không thuộc quyền sở hữu' as 'msg','' as 'data';
	ELSEIF (isBlocked  > 1 ) THEN
		SELECT 0 as 'status', 'Bài post đã bị chặn nên không thể xóa' as 'msg','' as 'data';
	ELSE
		BEGIN
			SELECT 'ROLLBACK'; /* This is returned so we know the error was triggered */
			ROLLBACK; 
	    END;

        START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
				DELETE 
                FROM medias 
                WHERE reid  = pr_reid;
				DELETE 
                FROM convenient
                WHERE reid  = pr_reid;
                DELETE 
                FROM saveposts
                WHERE reid = pr_reid;
                DELETE 
                FROM report
                WHERE reid = pr_reid;
                DELETE 
                FROM comment
                WHERE reid = pr_reid;
                DELETE 
                FROM posts
                WHERE reid = pr_reid;
			SET SQL_SAFE_UPDATES = 1;
		COMMIT;


        SELECT 1;
	END IF; 
END; $$


-- , pr_bedroom, pr_bathroom, pr_floor, pr_direction
-- 					, pr_balconyDirection, pr_furniture, pr_fontageArea


