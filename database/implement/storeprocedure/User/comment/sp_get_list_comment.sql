use bds;
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_comments $$
CREATE PROCEDURE sp_get_comments(pr_reid CHAR(40))
BEGIN
		START TRANSACTION;
			SELECT *
            FROM comment c JOIN (SELECT userid, username
							   FROM users) u
						 ON  c.userid = u.userid
						  
            WHERE reid = pr_reid;
		COMMIT;
END; $$