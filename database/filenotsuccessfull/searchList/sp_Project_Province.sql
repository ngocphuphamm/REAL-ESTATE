use bds 

select * 
from  project

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Project_Province $$
CREATE PROCEDURE sp_Project_Province(pr_project_id int,pr_province_id int) 
BEGIN	
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.projectid = pr_project_id AND p.provinceid = pr_province_id ;
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p join medias m 
					 on m.reid = p.reid
		WHERE  p.projectid = pr_project_id AND p.provinceid = pr_province_id 
		GROUP BY p.reid;

	END IF ;
END; $$
