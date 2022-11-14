use bds ; 

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_cancel_savePost $$
CREATE PROCEDURE sp_cancel_savePost(pr_savepost_id char(40))
BEGIN
	DECLARE isExists int DEFAULT -1;

    SELECT COUNT(*) INTO isExists
    FROM saveposts s
	WHERE s.savePostId = pr_savepost_id;
    
	IF (isExists>0) THEN
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
				DELETE FROM saveposts 
				WHERE savePostId = pr_savepost_id;
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SELECT 1;
	ELSE 
		SELECT 'Bạn chưa lưu tin để hủy ';
    END IF;    
END; $$

