use bds; 

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_convenient $$
CREATE PROCEDURE sp_get_convenient(pr_reid char(40))
BEGIN
	DECLARE isExist int DEFAULT -1;
    
    SELECT COUNT(*) INTO isExist
    FROM  convenient c 
	WHERE c.reid = pr_reid;
    
	IF (isExist = 0) THEN
		SELECT 'Không có tiện ghi nào cả !';
	ELSE
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
				SELECT bedroom, bathroom, floor, direction
					  , balconyDirection, furniture, fontageArea
                from convenient c
                where c.reid = pr_reid;
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    END IF;    
END; $$