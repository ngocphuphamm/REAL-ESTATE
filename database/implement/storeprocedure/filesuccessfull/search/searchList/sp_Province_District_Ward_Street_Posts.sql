use bds 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Province_District_Ward_Street_Posts $$
CREATE PROCEDURE sp_Province_District_Ward_Street_Posts(pr_province_id INT,pr_district_id INT
												 ,pr_ward_id int,pr_street_id INT) 
BEGIN	
    
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.provinceid = pr_province_id AND p.districtid  = pr_district_id
		   AND p.wardid = pr_ward_id AND p.streetid = pr_street_id 
           AND  p.approve = 0 ;
    
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p join medias m 
					 on m.reid = p.reid
		WHERE  p.provinceid = pr_province_id AND p.districtid  = pr_district_id
			   AND p.wardid = pr_ward_id AND p.streetid = pr_street_id AND  p.approve = 0
		GROUP BY p.reid;

	END IF ;
END; $$
