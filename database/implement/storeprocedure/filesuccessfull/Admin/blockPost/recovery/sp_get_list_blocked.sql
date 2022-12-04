use bds ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_return_list_posts_blocked $$
CREATE PROCEDURE sp_return_list_posts_blocked(pr_id_user varchar(50)) 
BEGIN	
	DECLARE is_admin INT DEFAULT 0;
	SET is_admin = fnc_checkAuthorization(pr_id_user);
	IF is_admin = 1 THEN 
		SELECT *  
        FROM posts p JOIN (
							SELECT reid,url
                            FROM medias
							) m 
					 ON p.reid = m.reid
		WHERE p.approve = 1 
        GROUP BY p.reid;
	ELSE
		SELECT 0 as "status","Not right admin" as "message",'' as "data";
    END IF; 
END; $$

CALL sp_return_list_posts_blocked("d5ef3568-634c-11ed-b1d9-00155d87afbf")