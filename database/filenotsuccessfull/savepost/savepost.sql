select * 
from saveposts 

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_savePosts $$
CREATE PROCEDURE sp_savePosts(pr_reid char(40), pr_userid char(40))
BEGIN
	DECLARE isExists int DEFAULT -1;
	DECLARE savePost_id char(40) DEFAULT uuid();
    DECLARE savePost_id_exists char(40) DEFAULT -1;
    SELECT COUNT(*) INTO isExists
    FROM saveposts s
	WHERE s.reid = pr_reid AND s.userid = pr_userid;
    
	IF (isExists>0) THEN
		SELECT savePostId  into savePost_id_exists
        FROM saveposts
        WHERE s.reid = pr_reid AND s.userid = pr_userid;
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
				DELETE FROM saveposts 
				WHERE s.reid = pr_reid AND s.userid = pr_userid;
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        
        SELECT savePost_id_exists,0;
	ELSE
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO saveposts(savePostId,reid,userid)
			VALUES (savePost_id,pr_reid,pr_userid);
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        
        SELECT *
        FROM saveposts s
        WHERE s.reid = pr_reid AND s.userid = pr_userid ;
    END IF;    
END; $$

