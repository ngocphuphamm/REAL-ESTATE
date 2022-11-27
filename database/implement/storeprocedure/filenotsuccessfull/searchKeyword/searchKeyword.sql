DELIMITER $$
DROP PROCEDURE IF EXISTS sp_search_keyword $$
CREATE PROCEDURE sp_search_keyword(pr_keyword text)
BEGIN
		SET pr_keyword = CONCAT('%',pr_keyword,'%');
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
			START TRANSACTION;
				SET SQL_SAFE_UPDATES = 0;
					SELECT  *
                    FROM posts p JOIN medias m
								ON m.reid = p.reid 
                    WHERE p.title like pr_keyword
                    group by p.reid;
				SET SQL_SAFE_UPDATES = 1;
			COMMIT;
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END; $$
