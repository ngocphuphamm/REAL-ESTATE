use bds 

select * 
from  posts

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Project $$
CREATE PROCEDURE sp_Project(pr_project_id INT) 
BEGIN	
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.projectid = pr_project_id ;
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p join medias m 
					 on m.reid = p.reid
		WHERE  p.projectid = pr_project_id 
		GROUP BY p.reid;

	END IF ;
END; $$
