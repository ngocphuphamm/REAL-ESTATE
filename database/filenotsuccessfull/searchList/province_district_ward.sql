use bds 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Province_District_Ward_Posts $$
CREATE PROCEDURE sp_Province_District_Ward_Posts(pr_province_id INT,pr_district_id INT
												 ,pr_ward_id INT) 
BEGIN	
    
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.provinceid = pr_province_id AND p.districtid  = pr_district_id
		   AND p.wardid = pr_ward_id;
    
    
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p 
		WHERE  p.provinceid = pr_province_id AND p.districtid  = pr_district_id
			   AND p.districtid = pr_ward_id;
		
	END IF ;
END; $$
