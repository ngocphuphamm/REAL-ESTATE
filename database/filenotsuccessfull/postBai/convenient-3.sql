use bds ; 
select *
from convenient 

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_insert_convenient $$
CREATE PROCEDURE sp_insert_convenient(pr_reid char(40), pr_bedroom int, pr_bathroom int, 
									 pr_floor int, pr_direction text, pr_balconyDirection text,
                                     pr_furniture text, pr_fontageArea int) 
BEGIN	
	DECLARE convenient_id char(40) DEFAULT uuid();
	DECLARE isExitsREID INT DEFAULT -1 ; 
    DECLARE isQty INT DEFAULT -1 ; 
    
    SELECT COUNT(*) INTO isQty
    FROM convenient m 
    WHERE m.reid = pr_reid;

	SELECT COUNT(*) INTO isExitsREID
    FROM posts p 
    WHERE p.reid = pr_reid;
    
    IF isExitsREID <= 0 THEN
		SELECT "REID không tồn tại";
    ELSEIF isQty > 1 THEN
		SELECT "Không chèn được thông tin đã có ";
	ELSE
		SET TRANSACTION ISOLATION LEVEL Repeatable read;
		START TRANSACTION;
			INSERT INTO convenient(convenientid, reid, bedroom, bathroom
									, floor, direction
									, balconyDirection, furniture, fontageArea)
			VALUES (convenient_id,pr_reid , pr_bedroom , pr_bathroom , 
					pr_floor , pr_direction , pr_balconyDirection ,
					pr_furniture , pr_fontageArea );
		COMMIT;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
        SELECT 1;
	 END IF;
END; $$