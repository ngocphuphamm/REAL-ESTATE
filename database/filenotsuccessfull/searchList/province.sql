
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Province_Posts $$
CREATE PROCEDURE sp_Province_Posts(pr_province_id INT)
BEGIN	
    
	DECLARE isExitsProvince INT DEFAULT -1 ;
    
	SELECT COUNT(*) into isExitsProvince
    FROM posts p 
    WHERE  p.provinceid = pr_province_id;
    
    IF isExitsProvince <= 0 THEN 
		SELECT 0,"Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
        FROM posts p JOIN medias m
					 ON m.reid = p.reid
        WHERE p.provinceid = pr_province_id
        GROUP BY p.reid;
	END IF ;
END; $$
