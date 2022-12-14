use bds;
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_comments $$
CREATE PROCEDURE sp_get_comments(pr_reid CHAR(40))
BEGIN
		START TRANSACTION;
			SELECT *
            FROM COMMENT c JOIN (SELECT userid, username
							   FROM USERS) u
						 ON  c.userid = u.userid
						  
            WHERE reid = pr_reid;
		COMMIT;
END; $$