use bds 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Province_District_Posts $$
CREATE PROCEDURE sp_Province_District_Posts(pr_province_id INT,pr_district_id INT) 
BEGIN	
    
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.provinceid = pr_province_id AND p.districtid  = pr_district_id;
    
    
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
        FROM posts p JOIN medias m
					 ON m.reid = p.reid
        WHERE p.provinceid = pr_province_id AND p.districtid  = pr_district_id
		GROUP BY p.reid;

	END IF ;
END; $$
