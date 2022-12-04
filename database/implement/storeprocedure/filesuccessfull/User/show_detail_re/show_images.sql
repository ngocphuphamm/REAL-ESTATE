use bds; 

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_listMedias $$
CREATE PROCEDURE sp_get_listMedias(pr_reid char(40))
BEGIN
	DECLARE isExist int DEFAULT -1;
    
    SELECT COUNT(*) INTO isExist
    FROM medias m
	WHERE m.reid = pr_reid;
    
	IF (isExist = 0) THEN
		SELECT 'Không có hình ảnh nào cả !';
	ELSE
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
				SELECT url
                from medias
                where reid = pr_reid;
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    END IF;    
END; $$