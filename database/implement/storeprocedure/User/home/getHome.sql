USE BDS;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_post $$
CREATE PROCEDURE sp_get_post()
BEGIN
	START TRANSACTION;
				SELECT *
				FROM posts p JOIN (SELECT reid , url
					   FROM medias) m
				ON p.reid = m.reid
                WHERE approve = 0
				GROUP BY p.reid;
		COMMIT;
END; $$

CALL sp_get_post();