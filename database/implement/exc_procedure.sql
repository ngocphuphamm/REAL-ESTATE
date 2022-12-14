DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Report $$
CREATE PROCEDURE sp_Report(pr_reid varchar(40), pr_phone varchar(40),pr_email varchar(40),pr_contentrp text)
BEGIN
	DECLARE isCheckLengthContent INT DEFAULT -1;
	DECLARE isCheckReportUser INT DEFAULT -1 ;
    SET isCheckReportUser = fnc_checkNamePhoneReport(pr_reid, pr_phone,pr_email);
    
	SELECT LENGTH(pr_contentrp) into isCheckLengthContent;
    
    IF(isCheckLengthContent < 10) THEN
		SELECT 0,"Nội dung không đủ để tố cáo";
    ELSEIF (isCheckReportUser > 0 ) THEN
		SELECT 1,"Người dùng đã gửi tố cáo";
	ELSE
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO report (reportid, reid, phone, email, contentrp)
				  VALUES (uuid(),pr_reid,pr_phone,pr_email,pr_contentrp);
			SET SQL_SAFE_UPDATES = 1;
			SELECT 1;
        COMMIT;
	END IF;
END; $$





DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Register $$
CREATE PROCEDURE sp_Register(pr_username varchar(50), pr_password varchar(50),pr_name varchar(150),pr_email varchar(100),pr_phone varchar(11))
BEGIN
	DECLARE isExists int DEFAULT -1;
    DECLARE pw varchar(50);
    DECLARE privateKey text DEFAULT uuid();

    SELECT COUNT(*) INTO isExists
    FROM users U
	WHERE U.username = pr_username;
    
	IF (isExists>0) THEN
		SELECT 'Tài khoản đã tồn tại !';
	ELSE
		SET pw= fnc_SHAPassword(pr_password, privateKey);
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO USERS(userid ,name,username,email,password,phone)
			VALUES (privateKey,pr_name,pr_username,pr_email,pw,pr_phone);
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        
        SELECT 1 ;
    END IF;    
END; $$


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Login $$
CREATE PROCEDURE sp_Login(pr_username varchar(50), pr_password varchar(50)) 
BEGIN	
    DECLARE private_key VARCHAR(50);
    DECLARE isExists INT DEFAULT -1;
    DECLARE pw VARCHAR(50)  ;

    SELECT  u.userid INTO private_key  FROM users u WHERE u.username= pr_username;

    SET pw=fnc_SHAPassword(pr_password, private_key); #function này đã tạo ra ở bước trên

    SELECT COUNT(*) INTO isExists FROM users u WHERE u.username=pr_username AND u.password=pw;
    
    IF(isExists >0) THEN
        SELECT u.name,  u.username,u.userid,
			   u.email, u.phone
        FROM users u
        where u.userid = private_key;
    ELSE
	    SELECT 'Tên đăng nhập hoặc mật khẩu không đúng !';
    END IF;
    
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_convenient $$
CREATE PROCEDURE sp_get_convenient(pr_reid char(40))
BEGIN
	DECLARE isExist int DEFAULT -1;
    
    SELECT COUNT(*) INTO isExist
    FROM  convenient c 
	WHERE c.reid = pr_reid;
    
	IF (isExist = 0) THEN
		SELECT 'Không có tiện ghi nào cả !';
	ELSE
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
				SELECT bedroom, bathroom, floor, direction
					  , balconyDirection, furniture, fontageArea
                from convenient c
                where c.reid = pr_reid;
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    END IF;    
END; $$



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




DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_convenient $$
CREATE PROCEDURE sp_get_convenient(pr_reid char(40))
BEGIN
	DECLARE isExist int DEFAULT -1;
    
    SELECT COUNT(*) INTO isExist
    FROM  convenient c 
	WHERE c.reid = pr_reid;
    
	IF (isExist = 0) THEN
		SELECT 'Không có tiện ghi nào cả !';
	ELSE
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
				SELECT bedroom, bathroom, floor, direction
					  , balconyDirection, furniture, fontageArea
                from convenient c
                where c.reid = pr_reid;
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    END IF;    
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Province_District_Ward_Street_Posts $$
CREATE PROCEDURE sp_Province_District_Ward_Street_Posts(pr_province_id INT,pr_district_id INT
												 ,pr_ward_id int,pr_street_id INT) 
BEGIN	
    
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.provinceid = pr_province_id AND p.districtid  = pr_district_id
		   AND p.wardid = pr_ward_id AND p.streetid = pr_street_id 
           AND  p.approve = 0 ;
    
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p join medias m 
					 on m.reid = p.reid
		WHERE  p.provinceid = pr_province_id AND p.districtid  = pr_district_id
			   AND p.wardid = pr_ward_id AND p.streetid = pr_street_id AND  p.approve = 0
		GROUP BY p.reid;

	END IF ;
END; $$


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Project_Province_District $$
CREATE PROCEDURE sp_Project_Province_District(pr_project_id int,pr_province_id int
											 ,pr_district_id int ) 
BEGIN	
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.projectid = pr_project_id 
		 AND p.provinceid = pr_province_id AND p.districtid = pr_district_id
         AND  p.approve = 0;
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p join medias m
					on m.reid = p.reid
		WHERE  p.projectid = pr_project_id AND p.provinceid = pr_province_id
			   AND p.districtid = pr_district_id AND  p.approve = 0
		GROUP BY p.reid;
	END IF ;
END; $$


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Project_Province $$
CREATE PROCEDURE sp_Project_Province(pr_project_id int,pr_province_id int) 
BEGIN	
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.projectid = pr_project_id 
		   AND p.provinceid = pr_province_id 
           AND  p.approve = 0;
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p join medias m 
					 on m.reid = p.reid
		WHERE  p.projectid = pr_project_id AND p.provinceid = pr_province_id 
			  AND  p.approve = 0
		GROUP BY p.reid;

	END IF ;
END; $$


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Project $$
CREATE PROCEDURE sp_Project(pr_project_id INT) 
BEGIN	
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.projectid = pr_project_id AND  p.approve = 0;
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p join medias m 
					 on m.reid = p.reid
		WHERE  p.projectid = pr_project_id AND  p.approve = 0
		GROUP BY p.reid;

	END IF ;
END; $$


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Province_District_Ward_Posts $$
CREATE PROCEDURE sp_Province_District_Ward_Posts(pr_province_id INT,pr_district_id INT
												 ,pr_ward_id INT) 
BEGIN	
    
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.provinceid = pr_province_id AND p.districtid  = pr_district_id
		   AND p.wardid = pr_ward_id AND  p.approve = 0;
    
    
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
		FROM posts p join medias m 
					 on m.reid = p.reid 
		WHERE  p.provinceid = pr_province_id AND p.districtid  = pr_district_id
			   AND p.districtid = pr_ward_id AND  p.approve = 0
		GROUP BY p.reid;

	END IF ;
END; $$


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Province_District_Posts $$
CREATE PROCEDURE sp_Province_District_Posts(pr_province_id INT,pr_district_id INT) 
BEGIN	
    
	DECLARE isExists INT DEFAULT -1 ;

	SELECT COUNT(*) into isExists
    FROM posts p 
    WHERE  p.provinceid = pr_province_id 
		   AND p.districtid  = pr_district_id 
           AND  p.approve = 0;
    
    
    
    IF isExists <= 0 THEN 
		SELECT "Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
        FROM posts p JOIN medias m
					 ON m.reid = p.reid
        WHERE p.provinceid = pr_province_id AND p.districtid  = pr_district_id AND  p.approve = 0
		GROUP BY p.reid;

	END IF ;
END; $$


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Province_Posts $$
CREATE PROCEDURE sp_Province_Posts(pr_province_id INT)
BEGIN	
    
	DECLARE isExitsProvince INT DEFAULT -1 ;
    
	SELECT COUNT(*) into isExitsProvince
    FROM posts p 
    WHERE  p.provinceid = pr_province_id
		   AND  p.approve = 0; 
    
    IF isExitsProvince <= 0 THEN 
		SELECT 0,"Hiện không có nhà đất nào tại đây";
	ELSE
		SELECT *
        FROM posts p JOIN medias m
					 ON m.reid = p.reid
        WHERE p.provinceid = pr_province_id AND  p.approve = 0
        GROUP BY p.reid;
	END IF ;
END; $$


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
                    WHERE p.title like pr_keyword AND  p.approve = 0
                    group by p.reid;
				SET SQL_SAFE_UPDATES = 1;
			COMMIT;
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END; $$




DELIMITER $$
DROP PROCEDURE IF EXISTS sp_savePosts $$
CREATE PROCEDURE sp_savePosts(pr_reid char(40), pr_userid char(40))
BEGIN
		DECLARE isExists int DEFAULT -1;
		DECLARE savePost_id char(40) DEFAULT uuid();
		DECLARE savePost_id_exists char(40) DEFAULT -1;
		SELECT COUNT(*) INTO isExists
		FROM saveposts s
		WHERE s.reid = pr_reid AND s.userid = pr_userid;
		
		IF (isExists>0) THEN
			SELECT savePostId  into savePost_id_exists
			FROM saveposts s
			WHERE s.reid = pr_reid AND s.userid = pr_userid;
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
			START TRANSACTION;
				SET SQL_SAFE_UPDATES = 0;
					DELETE FROM saveposts  
					WHERE saveposts.reid = pr_reid AND saveposts.userid = pr_userid;
				SET SQL_SAFE_UPDATES = 1;
			COMMIT;
			SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
			
			SELECT savePost_id_exists,0;
		ELSE
			START TRANSACTION;
				SET SQL_SAFE_UPDATES = 0;
				INSERT INTO saveposts(savePostId,reid,userid)
				VALUES (savePost_id,pr_reid,pr_userid);
				SET SQL_SAFE_UPDATES = 1;
			COMMIT;
			
			SELECT *
			FROM saveposts s
			WHERE s.reid = pr_reid AND s.userid = pr_userid ;
		END IF;    
END; $$



DELIMITER $$
DROP PROCEDURE IF EXISTS sp_getCategories $$
CREATE PROCEDURE sp_getCategories() 
BEGIN	
		   SELECT *
		   FROM categories;
END; $$


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_postFeed $$
CREATE PROCEDURE sp_postFeed(pr_categoryid varchar(200), pr_title varchar(200), pr_description text
					        , pr_price decimal(15,2), pr_area varchar(100)
                            , pr_phone varchar(20),pr_address varchar(150), pr_userid varchar(200)
                            , pr_projectid char(20), pr_streetid int, pr_wardid int, pr_districtid int
                            , pr_provinceid int) 
BEGIN	
    DECLARE isExists INT DEFAULT -1;
        
	DECLARE isCheckAddress INT DEFAULT -1;
	
    DECLARE isCheckUserID INT DEFAULT -1;
   
	DECLARE id_post char(40);
    
    SELECT COUNT(*) INTO isExists FROM categories c WHERE c.categoryid = pr_categoryid;
    
	SET isCheckAddress = fnc_checkAddress(pr_provinceid, pr_districtid,
											 pr_wardid, pr_streetid);
                                             
    IF(isExists = 0) THEN
		SELECT "Loại Bất Động Sản Không Có";
	ELSEIF(isCheckAddress > 0) THEN
		SELECT "Địa Chỉ Không Hợp Lệ";
	ELSE
		set id_post = uuid();
        START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO posts (reid, categoryid, title, description, price
								, area, phone, address, userid, projectid
                                , streetid, wardid, districtid, provinceid)
			VALUES (id_post, pr_categoryid, pr_title, pr_description
					 , pr_price , pr_area, pr_phone, pr_address ,pr_userid
					, pr_projectid, pr_streetid, pr_wardid, pr_districtid
					, pr_provinceid);
			SET SQL_SAFE_UPDATES = 1;
		COMMIT;


        SELECT id_post;
	END IF; 
END; $$



DELIMITER $$
DROP PROCEDURE IF EXISTS sp_insert_medias $$
CREATE PROCEDURE sp_insert_medias(pr_reid char(40), pr_url text) 
BEGIN	
    DECLARE isQty INT DEFAULT -1 ; 
	DECLARE media_id char(40) DEFAULT uuid();
	DECLARE isExitsREID INT DEFAULT -1 ; 
    
    SELECT COUNT(*) INTO isQty
    FROM medias m 
    WHERE m.reid = pr_reid;

	SELECT COUNT(*) INTO isExitsREID
    FROM posts p 
    WHERE p.reid = pr_reid;
    
    IF isExitsREID <= 0 THEN
		SELECT "REID không tồn tại";
    ELSEIF isQty > 15 THEN
		SELECT "Số hình đã vượt quá";
	ELSE
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO medias(mediaid ,url,reid)
			VALUES (media_id,pr_url,pr_reid);
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SELECT 1;
	 END IF;
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_insert_convenient $$
CREATE PROCEDURE sp_insert_convenient(pr_reid char(40), pr_bedroom int, pr_bathroom int, 
									 pr_floor int, pr_direction text, pr_balconyDirection text,
                                     pr_furniture text, pr_fontageArea int) 
BEGIN	
	DECLARE convenient_id char(40) DEFAULT uuid();
	DECLARE isExitsREID INT DEFAULT -1 ; 
    DECLARE isQty INT DEFAULT -1 ; 
    
    SELECT COUNT(*) INTO isQty
    FROM convenient m 
    WHERE m.reid = pr_reid;

	SELECT COUNT(*) INTO isExitsREID
    FROM posts p 
    WHERE p.reid = pr_reid;
    
    IF isExitsREID <= 0 THEN
		SELECT "REID không tồn tại";
    ELSEIF isQty > 1 THEN
		SELECT "Không chèn được thông tin đã có ";
	ELSE
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO convenient(convenientid, reid, bedroom, bathroom
									, floor, direction
									, balconyDirection, furniture, fontageArea)
			VALUES (convenient_id,pr_reid , pr_bedroom , pr_bathroom , 
					pr_floor , pr_direction , pr_balconyDirection ,
					pr_furniture , pr_fontageArea );
			SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SELECT 1;
	 END IF;
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Comment $$
CREATE PROCEDURE sp_Comment(pr_reid char(40), pr_userid char(40),pr_content text)
BEGIN
	DECLARE isExistsRe int DEFAULT -1;
    DECLARE isExistsUser int DEFAULT -1;
    DECLARE contentLen int DEFAULT -1;
    DECLARE isExistsComment int DEFAULT -1;
	DECLARE comment_id char(40) DEFAULT uuid();
    
    SELECT COUNT(*) INTO isExistsRe
    FROM posts p
	WHERE p.reid = pr_reid;
	
    SELECT COUNT(*) INTO isExistsUser
    FROM  users u 
    WHERE u.userid = pr_userid;
    
    SELECT LENGTH(pr_content) INTO contentLen;
	
    SELECT COUNT(*) INTO isExistsComment
    FROM comment c
    WHERE c.reid = pr_reid AND c.userid = pr_userid;
    
    IF (isExistsRe <= 0) THEN
			SELECT 'Nhà đất không có để comment !' , 0;
		ELSEIF (isExistsUser <= 0)  THEN
			SELECT 'Người dùng không tồn tại trong hệ thống!' , 0;
		ELSEIF (contentLen < 10) THEN
			SELECT 'Nội dung comment không phù  hợp' , 0;
		ELSEIF (isExistsComment > 0) THEN
			SELECT 'Bạn đã comment tại bài đăng này', 0;
        ELSE
			START TRANSACTION;
				SET SQL_SAFE_UPDATES = 0;
					INSERT INTO comment(commentid,content,reid,userid)
					VALUES (comment_id,pr_content,pr_reid,pr_userid);
				SET SQL_SAFE_UPDATES = 1;
			COMMIT;
        
			SELECT c.content, u.name , u.userid , 1
			FROM comment c 
			JOIN users u ON c.userid = u.userid
			WHERE c.commentid = comment_id;
    END IF;    
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_listMedias $$
CREATE PROCEDURE sp_get_listMedias(pr_reid char(40))
BEGIN
	DECLARE isExist int DEFAULT -1;
    
    SELECT COUNT(*) INTO isExist
    FROM medias m
	WHERE m.reid = pr_reid;
    
	IF (isExist = 0) THEN
		SELECT 'Không có hình ảnh nào cả !';
	ELSE
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
				SELECT url
                from medias
                where reid = pr_reid;
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    END IF;    
END; $$

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
						SET SQL_SAFE_UPDATES = 0;
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





DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Edit_User $$
CREATE PROCEDURE sp_Edit_User(pr_userid char(40),pr_name varchar(150), pr_phone varchar(100)) 
BEGIN	
	DECLARE isExistsUser INT DEFAULT -1; 
    
    SELECT COUNT(*) INTO isExistsUser
    FROM users u
    WHERE u.userid = pr_userid;
    
    IF isExistsUser <= 0 THEN
		SELECT "USER KHÔNG TỒN TẠI";
	ELSE
        START TRANSACTION;
			SET SQL_SAFE_UPDATES=0;
			UPDATE users 
			SET name = pr_name , phone = pr_phone
            WHERE  userid = pr_userid;
			SET SQL_SAFE_UPDATES=1;
		COMMIT; 
		
        SELECT userid,name,username,email,phone
        FROM users u
		WHERE u.userid = pr_userid;
    END IF;
    
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_bans_post $$
CREATE PROCEDURE sp_bans_post(pr_idUser char(40), pr_id_post char(40)) 
BEGIN	
    DECLARE is_admin INT DEFAULT 0;
    DECLARE is_exists_posts INT DEFAULT -1; 
    DECLARE is_check_blocked INT DEFAULT -1;
    SET is_exists_posts = fnc_is_exists_posts(pr_id_post);
    
    IF is_exists_posts = 0 THEN 
		SELECT "Post not exists";
    ELSE 
		SET is_admin = fnc_check_authorization(pr_idUser);
		IF is_admin = 1 THEN  
			SET is_check_blocked = fnc_check_blocked(pr_id_post);
			IF is_check_blocked > 0 THEN 
				SELECT 0 as "status", "POST BLOCKED" as "message",'' as "data";
			ELSE 
					SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
					START TRANSACTION;
						SET SQL_SAFE_UPDATES = 0;
							UPDATE Posts
							SET approve = 1
							WHERE reid = pr_id_post;
						SET SQL_SAFE_UPDATES = 1;
					COMMIT;
					SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
                    
					SELECT 1 as "status","SUCCESS UPDATE" as "message",'' as "data"  ;
            END IF;
		ELSE 
			SELECT 0 as "status","Not right admin" as "message",'' as "data";
		END IF;
	END IF;
END; $$





