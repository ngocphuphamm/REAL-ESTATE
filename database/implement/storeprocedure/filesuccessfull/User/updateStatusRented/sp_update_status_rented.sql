use bds ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_status_post $$
CREATE PROCEDURE sp_update_status_post(pr_id_user char(40), pr_id_post char(40)) 
BEGIN	
	DECLARE is_exists INT DEFAULT -1; 
	DECLARE check_blocked INT DEFAULT -1;
	DECLARE is_update_status INT DEFAULT -1 ;
    DECLARE is_belong_user INT DEFAULT -1 ;
    SET is_exists  = fnc_is_exists_posts(pr_id_post);

    
    IF is_exists > 0 THEN
		SET check_blocked = fnc_check_blocked(pr_id_post);
        IF check_blocked > 0 THEN
			SELECT 0 as "status", "Bài post đã bị khóa" as "message", '' as 'data';
        ELSE
			SELECT COUNT(*) INTO is_update_status
            FROM posts p 
            WHERE p.reid = pr_id_post AND p.rented = 0 ;
            
            IF is_update_status > 0 THEN 
				SELECT COUNT(*) INTO is_belong_user
                FROM posts p
                WHERE p.reid = pr_id_post AND p.userid = pr_id_user;
                
                IF is_belong_user > 0 THEN 
					SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
					START TRANSACTION;
						SET SQL_SAFE_UPDATES = 0;
							UPDATE Posts
							SET rented = 1
							WHERE reid = pr_id_post;
						SET SQL_SAFE_UPDATES = 1;
					COMMIT;
					SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
				ELSE 
					SELECT 0 as 'status', "Bài post này không thuộc quyền sở hữu của bạn" as "message",	
											'' as 'data';
                END IF;
			ELSE 
				SELECT 0 as status, "Bài post đã được cập nhật trạng thái" as message , '' as 'data';
            END IF; 
        END IF;
    ELSE 
		SELECT 0 as 'status', 'Bài Posts không tồn tại' as 'message';
    END IF;
END; $$




