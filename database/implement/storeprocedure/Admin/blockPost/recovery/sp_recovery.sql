use bds ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_recovery_post $$
CREATE PROCEDURE sp_recovery_post(pr_id_user char(40), pr_id_post char(40)) 
BEGIN	
    DECLARE is_admin INT DEFAULT 0;
    DECLARE is_exists_posts INT DEFAULT -1; 
    DECLARE is_check_blocked INT DEFAULT -1;
    
    SET is_exists_posts = fnc_is_exists_posts(pr_id_post);
    
    IF is_exists_posts = 0 THEN 
		SELECT 0 as "status","Post not exists" as "message",'' as 'data';
    ELSE 
		SET is_admin = fnc_check_authorization(pr_id_user);
		IF is_admin = 1 THEN  
			SET is_check_blocked = fnc_check_blocked(pr_id_post);
			IF is_check_blocked = 0 THEN 
				SELECT 0 as "status", "POST NOT BLOCKED" as "message",'' as "data";
			ELSE 
					SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
					START TRANSACTION;
						SET SQL_SAFE_UPDATES = 0;
							UPDATE posts
							SET approve = 0
							WHERE reid = pr_id_post;
						SET SQL_SAFE_UPDATES = 0;
					COMMIT;
					SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
                    
					SELECT 1 as "status","SUCCESS UPDATE" as "message",'' as "data"  ;
            END IF;
		ELSE 
			SELECT 0 as "status","Not right admin" as "message",'' as "data";
		END IF;
	END IF;
END; $$

CALL sp_recovery_post("d5ef3568-634c-11ed-b1d9-00155d87afbf","77ebde3d-634d-11ádased-b1d9-00155d87afbf")


