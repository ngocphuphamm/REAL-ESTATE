use bds; 

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_show_detail_info $$
CREATE PROCEDURE sp_show_detail_info(pr_reid char(40))
BEGIN
	DECLARE isExists int DEFAULT -1;
    DECLARE isExistsProjectid VARCHAR(40) DEFAULT NULL;
    
    SELECT COUNT(*) INTO isExists
    FROM posts p
	WHERE p.reid = pr_reid;
    
    SELECT projectid INTO isExistsProjectid
	FROM posts p
	WHERE p.reid = pr_reid ;
    
	IF (isExists = 0) THEN
		SELECT 'Không có tin này!';
	
	ELSE
		IF ISNULL(isExistsProjectid) = 1 THEN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
			START TRANSACTION;
				SET SQL_SAFE_UPDATES = 0;
						SELECT p.reid, p.title, p.description, p.price
							, p.area, p.viewCount, p.phone
							, p.address, p.rented, p.createdat
							, c.name as 'categories', pr.nameprovince
							, dis.namedistrict, w.nameward,st.namestreet as 'street'
                            , u.name, u.email, u.phone
					 FROM posts p JOIN users u 
								  ON u.userid = p.userid 
								  JOIN categories c 
								  ON c.categoryid = p.categoryid
								  JOIN (SELECT provinceid,nameprovince
										FROM province ) pr
								  ON pr.provinceid = p.provinceid
								  JOIN (SELECT districtid,namedistrict
										FROM district) dis
								  ON dis.districtid = p.districtid
								  JOIN (SELECT wardid,nameward
										FROM ward) w
								  ON w.wardid = p.wardid
								  JOIN street st
								  ON st.streetid = p.streetid 
					 where  p.reid = pr_reid;
				SET SQL_SAFE_UPDATES = 1;
			COMMIT;
			SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
		ELSE
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
			START TRANSACTION;
				SET SQL_SAFE_UPDATES = 0;
						SELECT p.reid, p.title, p.description, p.price
							, p.area, p.viewCount, p.phone
							, p.address, p.rented, p.createdat
							, c.name as 'categories', pr.nameprovince
							, dis.namedistrict, w.nameward,st.namestreet as 'street'
                            , pro.nameproject ,u.name, u.email, u.phone
					 FROM posts p JOIN users u 
								  ON u.userid = p.userid 
								  JOIN categories c 
								  ON c.categoryid = p.categoryid
								  JOIN (SELECT provinceid,nameprovince
										FROM province ) pr
								  ON pr.provinceid = p.provinceid
								  JOIN (SELECT districtid,namedistrict
										FROM district) dis
								  ON dis.districtid = p.districtid
								  JOIN (SELECT wardid,nameward
										FROM ward) w
								  ON w.wardid = p.wardid
								  JOIN street st
								  ON st.streetid = p.streetid 
                                  JOIN (SELECT projectid,nameproject
										FROM project ) pro
								  ON pro.projectid = p.projectid
					 where  p.reid = pr_reid;
				SET SQL_SAFE_UPDATES = 1;
			COMMIT;
			SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
		END IF;
    END IF;    
END; $$
