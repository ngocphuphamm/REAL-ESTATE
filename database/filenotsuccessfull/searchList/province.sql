
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Province_Posts $$
CREATE PROCEDURE sp_Province_Posts(pr_province_id INT)
BEGIN	
    
	DECLARE isExitsProvince INT DEFAULT -1 ;
    
	SELECT COUNT(*) into isExitsProvince
    FROM posts p 
    WHERE  p.provinceid = pr_province_id;
    
    IF isExitsProvince <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
        FROM posts p 
        WHERE p.provinceid = pr_province_id;
	END IF ;
END; $$
