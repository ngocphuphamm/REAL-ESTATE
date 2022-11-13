use bds 

select * 
from  project

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Project_Province_District $$
CREATE PROCEDURE sp_Project_Province_District(pr_project_id int,pr_province_id int
											 ,pr_district_id int ) 
BEGIN	
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.projectid = pr_project_id AND p.provinceid = pr_province_id AND p.districtid = pr_district_id;
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p 
		WHERE  p.projectid = pr_project_id AND p.provinceid = pr_province_id
			   AND p.districtid = pr_district_id;
	END IF ;
END; $$
