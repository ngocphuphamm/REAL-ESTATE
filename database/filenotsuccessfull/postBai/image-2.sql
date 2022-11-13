use bds ; 

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_insert_medias $$
CREATE PROCEDURE sp_insert_medias(pr_reid char(40), pr_url text) 
BEGIN	
    DECLARE isQty INT DEFAULT -1 ; 
	DECLARE media_id char(40) DEFAULT uuid();
	DECLARE isExitsREID INT DEFAULT -1 ; 
    
    SELECT COUNT(*) INTO isQty
    FROM medias m 
    WHERE m.reid = pr_reid;

	SELECT COUNT(*) INTO isExitsREID
    FROM posts p 
    WHERE p.reid = pr_reid;
    
    IF isExitsREID <= 0 THEN
		SELECT "REID không tồn tại";
    ELSEIF isQty > 15 THEN
		SELECT "Số hình đã vượt quá";
	ELSE
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO medias(mediaid ,url,reid)
			VALUES (media_id,pr_url,pr_reid);
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SELECT 1;
	 END IF;
END; $$