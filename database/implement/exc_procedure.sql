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
	    SELECT 0;
    END IF;
    
END; $$
use bds; 

DELIMITER $$
DROP FUNCTION IF EXISTS fnc_SHAPassword $$
CREATE FUNCTION fnc_SHAPassword(pr_password varchar(50), pr_private_key varchar(50) )
RETURNS VARCHAR(50)
DETERMINISTIC
begin
    return sha1(concat(pr_password, pr_private_key));
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
		SELECT 0;
	ELSE
		SET pw= fnc_SHAPassword(pr_password, privateKey);
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO users(userid ,name,username,email,password,phone)
			VALUES (privateKey,pr_name,pr_username,pr_email,pw,pr_phone);
            SET SQL_SAFE_UPDATES = 1;
		COMMIT;
        
        SELECT 1 ;
    END IF;    
END; $$
SELECT @TRA

use bds;

select * 
from report;

DELIMITER $$
DROP FUNCTION IF EXISTS fnc_checkNamePhoneReport $$
CREATE FUNCTION fnc_checkNamePhoneReport(pr_reid varchar(40), pr_phone varchar(40),pr_email varchar(40))
RETURNS INT
DETERMINISTIC
begin
	DECLARE result INT DEFAULT -1 ;
	
    SELECT COUNT(*) INTO result
	FROM report r 
    WHERE r.reid = pr_reid AND r.phone = pr_phone AND r.email = pr_email;
   
	IF (result > 0 ) THEN 
		SET result = 1;
	ELSE
		SET result = 0;
	END IF;
    
    RETURN result; 
END; $$


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_Report $$
CREATE PROCEDURE sp_Report(pr_reid varchar(40), pr_phone varchar(40),pr_email varchar(40),pr_contentrp text)
BEGIN
	DECLARE isCheckLengthContent INT DEFAULT -1;
	DECLARE isCheckReportUser INT DEFAULT -1 ;
    SET isCheckReportUser = fnc_checkNamePhoneReport(pr_reid, pr_phone,pr_email);
    
	SELECT LENGTH(pr_contentrp) into isCheckLengthContent;
    
    IF(isCheckLengthContent < 5) THEN
		SELECT 0,"Nội dung không đủ để tố cáo";
    ELSEIF (isCheckReportUser > 0 ) THEN
		SELECT 0,"Người dùng đã gửi tố cáo";
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
							UPDATE posts
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




use bds; 

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
use bds; 

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

use bds 
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
use bds 
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
use bds 

select * 
from  project

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
use bds 

select * 
from  project

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

use bds 
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
DROP PROCEDURE IF EXISTS sp_savePosts $$
CREATE PROCEDURE sp_savePosts(pr_reid char(40), pr_userid char(40))
BEGIN
		DECLARE isExists int DEFAULT -1;
		DECLARE savePost_id char(40) DEFAULT uuid();
		DECLARE savePost_id_exists char(40) DEFAULT -1;
		SELECT COUNT(*) INTO isExists
		FROM savePosts s
		WHERE s.reid = pr_reid AND s.userid = pr_userid;
		
		IF (isExists>0) THEN
			SELECT savePostId  into savePost_id_exists
			FROM savePosts s
			WHERE s.reid = pr_reid AND s.userid = pr_userid;
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
			START TRANSACTION;
				SET SQL_SAFE_UPDATES = 0;
					DELETE FROM savePosts  
					WHERE savePosts.reid = pr_reid AND savePosts.userid = pr_userid;
				SET SQL_SAFE_UPDATES = 1;
			COMMIT;
			SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
			
			SELECT savePost_id_exists,0;
		ELSE
			START TRANSACTION;
				SET SQL_SAFE_UPDATES = 0;
				INSERT INTO savePosts(savePostId,reid,userid)
				VALUES (savePost_id,pr_reid,pr_userid);
				SET SQL_SAFE_UPDATES = 1;
			COMMIT;
			
			SELECT *
			FROM savePosts s
			WHERE s.reid = pr_reid AND s.userid = pr_userid ;
		END IF;    
END; $$

use bds; 

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_remove_feed $$
CREATE PROCEDURE sp_remove_feed(pr_reid varchar(200), pr_userid varchar(200)) 
BEGIN	
    DECLARE isExists INT DEFAULT -1;
	DECLARE isBlocked INT DEFAULT -1; 
    
    SELECT COUNT(*) INTO isExists 
    FROM posts 
    WHERE reid = pr_reid AND userid = pr_userid ;
    
	SELECT COUNT(*) INTO isBlocked 
    FROM posts 
    WHERE reid = pr_reid AND userid = pr_userid AND approve = 1;
    
    
    IF(isExists < 0) THEN
		SELECT 0 as 'status', 'Bài post không tồn tại hoặc không thuộc quyền sở hữu' as 'msg','' as 'data';
	ELSEIF (isBlocked  > 1 ) THEN
		SELECT 0 as 'status', 'Bài post đã bị chặn nên không thể xóa' as 'msg','' as 'data';
	ELSE
		BEGIN
			SELECT 'ROLLBACK'; /* This is returned so we know the error was triggered */
			ROLLBACK; 
	    END;

        START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
				DELETE 
                FROM medias 
                WHERE reid  = pr_reid;
				DELETE 
                FROM convenient
                WHERE reid  = pr_reid;
                DELETE 
                FROM savePosts
                WHERE reid = pr_reid;
                DELETE 
                FROM report
                WHERE reid = pr_reid;
                DELETE 
                FROM comment
                WHERE reid = pr_reid;
                DELETE 
                FROM posts
                WHERE reid = pr_reid;
			SET SQL_SAFE_UPDATES = 1;
		COMMIT;


        SELECT 1;
	END IF; 
END; $$


-- , pr_bedroom, pr_bathroom, pr_floor, pr_direction
-- 					, pr_balconyDirection, pr_furniture, pr_fontageArea


use bds ; 

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
    ELSEIF isQty > 5 THEN
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

use bds; 
/* get categories*/
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_getCategories $$
CREATE PROCEDURE sp_getCategories() 
BEGIN	
		   SELECT *
		   FROM categories;
END; $$
DELIMITER;

/* post feed*/
/* checkuserid*/
DELIMITER $$
DROP FUNCTION IF EXISTS fnc_checkUserID $$
CREATE FUNCTION fnc_checkUserID(pr_userid varchar(200) )
RETURNS TEXT 
DETERMINISTIC
begin
	DECLARE result text;
    DECLARE isExists int default -1;
    
    SELECT COUNT(*) INTO isExists 
    FROM users u 
    WHERE u.userid = pr_userid;
    
    IF(isExists > 0) THEN 
		SET result = pr_userid;
	ELSE
		SET result = null;
	END IF;
    
	RETURN result;
END; $$

select fnc_checkUserID("7fb1b94-5d44-11ed-9637-c8b29b839518")

select * 
from users;

DELIMITER $$
DROP FUNCTION IF EXISTS fnc_checkAddress $$
CREATE FUNCTION fnc_checkAddress(pr_provinceid int, pr_districtid int,
								 pr_wardid int, pr_streetid int)
RETURNS INT 
DETERMINISTIC
begin
			DECLARE isCheck INT DEFAULT -1;
            
			SELECT COUNT(*) into isCheck
			FROM  province p JOIN ( SELECT districtid,provinceid,nameDistrict
									FROM district ) d
							 ON p.provinceid = d.provinceid 
							 JOIN (SELECT wardid,nameward,districtid
								   FROM ward) w 
							ON w.districtid = d.districtid
			WHERE p.provinceid = pr_provinceid AND d.districtid = pr_districtid AND w.wardid = pr_wardid;
			
            IF isCheck = 0 THEN 
				set isCheck = 1;
			ELSE 
				SET isCheck = 0 ;
			END IF;
            return isCheck;
END; $$



DELIMITER $$
DROP PROCEDURE IF EXISTS sp_postFeed $$
CREATE PROCEDURE sp_postFeed(pr_categoryid varchar(200), pr_title varchar(200), pr_description text
					        , pr_price decimal(15,2), pr_area varchar(100)
                            , pr_phone varchar(20),pr_address varchar(150), pr_userid varchar(200)
                            , pr_projectid char(20), pr_streetid int, pr_wardid int, pr_districtid int
                            , pr_provinceid int,pr_bedroom int, pr_bathroom int,pr_floor int
                            , pr_direction text, pr_balconyDirection text, pr_furniture text
                            , pr_fontageArea int) 
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
			INSERT INTO convenient(convenientid, reid, bedroom, bathroom
									, floor, direction
									, balconyDirection, furniture, fontageArea)
			VALUES (uuid(),id_post , pr_bedroom , pr_bathroom , 
					pr_floor , pr_direction , pr_balconyDirection ,
					pr_furniture , pr_fontageArea );
			SET SQL_SAFE_UPDATES = 1;
		COMMIT;


        SELECT id_post;
	END IF; 
END; $$
select @@transaction_isolation;


-- , pr_bedroom, pr_bathroom, pr_floor, pr_direction
-- 					, pr_balconyDirection, pr_furniture, pr_fontageArea


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

use bds 

SELECT * FROM USERS

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

select @@transaction_isolation;

use bds; 

select *
from comment

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

use bds;
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_comments $$
CREATE PROCEDURE sp_get_comments(pr_reid CHAR(40))
BEGIN
		START TRANSACTION;
			SELECT *
            FROM comment c JOIN (SELECT userid, username
							   FROM USERS) u
						 ON  c.userid = u.userid
						  
            WHERE reid = pr_reid;
		COMMIT;
END; $$
use bds ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_return_list_posts $$
CREATE PROCEDURE sp_return_list_posts(pr_id_user varchar(50)) 
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
		WHERE p.approve = 0 
        GROUP BY p.reid;
	ELSE
		SELECT 0 as "status","Not right admin" as "message",'' as "data";
    END IF; 
END; $$

CALL sp_return_list_posts("d5ef3568-634c-11ed-b1d9-00155d87afbf")

use bds ;


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_authorization$$
CREATE FUNCTION fnc_check_authorization(pr_id_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_admin char(40) DEFAULT NULL;
     
     SELECT u.name into is_admin 
     FROM users u   
     WHERE u.typeuser = 1 AND  u.userid = pr_id_user;
     
     IF is_admin IS NULL THEN
		RETURN FALSE;
	 END IF;
    
	RETURN TRUE;
END; $$


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_is_exists_posts$$
CREATE FUNCTION fnc_is_exists_posts(pr_posts char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_exists char(40) DEFAULT NULL;
     
	 SELECT COUNT(reid) INTO is_exists
     FROM posts p  
     WHERE p.reid = pr_posts;
     
     
     IF is_exists > 0 THEN  
		RETURN TRUE;
	 END IF;
     
	 RETURN FALSE;
END; $$



DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_blocked$$
CREATE FUNCTION fnc_check_blocked(pr_posts char(40))
RETURNS boolean
DETERMINISTIC
begin
	DECLARE check_blocked INT DEFAULT -1; 
    
    SELECT COUNT(reid) INTO check_blocked
    FROM posts p 
    WHERE  p.reid = pr_posts AND p.approve = 1;
    
    IF check_blocked > 0 THEN
		RETURN TRUE;
    END IF;
    RETURN FALSE;
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
							UPDATE posts
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

CALL sp_bans_post("d5ef3568-634c-11ed-b1d9-00155d87afbf","77ebde3d-634d-11ed-b1d9-00155d87afbf")


use bds ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_return_list_posts $$
CREATE PROCEDURE sp_return_list_posts(pr_id_user varchar(50)) 
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
		WHERE p.approve = 0 
        GROUP BY p.reid;
	ELSE
		SELECT 0 as "status","Not right admin" as "message",'' as "data";
    END IF; 
END; $$

CALL sp_return_list_posts("d5ef3568-634c-11ed-b1d9-00155d87afbf")

use bds ;


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_authorization$$
CREATE FUNCTION fnc_check_authorization(pr_id_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_admin char(40) DEFAULT NULL;
     
     SELECT u.name into is_admin 
     FROM users u   
     WHERE u.typeuser = 1 AND  u.userid = pr_id_user;
     
     IF is_admin IS NULL THEN
		RETURN FALSE;
	 END IF;
    
	RETURN TRUE;
END; $$


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_is_exists_posts$$
CREATE FUNCTION fnc_is_exists_posts(pr_posts char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_exists char(40) DEFAULT NULL;
     
	 SELECT COUNT(reid) INTO is_exists
     FROM posts p  
     WHERE p.reid = pr_posts;
     
     
     IF is_exists > 0 THEN  
		RETURN TRUE;
	 END IF;
     
	 RETURN FALSE;
END; $$



DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_blocked$$
CREATE FUNCTION fnc_check_blocked(pr_posts char(40))
RETURNS boolean
DETERMINISTIC
begin
	DECLARE check_blocked INT DEFAULT -1; 
    
    SELECT COUNT(reid) INTO check_blocked
    FROM posts p 
    WHERE  p.reid = pr_posts AND p.approve = 1;
    
    IF check_blocked > 0 THEN
		RETURN TRUE;
    END IF;
    RETURN FALSE;
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

CALL sp_bans_post("d5ef3568-634c-11ed-b1d9-00155d87afbf","77ebde3d-634d-11ed-b1d9-00155d87afbf")


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


use bds ;


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_authorization$$
CREATE FUNCTION fnc_check_authorization(pr_id_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_admin char(40) DEFAULT NULL;
     
     SELECT u.name into is_admin 
     FROM users u   
     WHERE u.typeuser = 1 AND  u.userid = pr_id_user;
     
     IF is_admin IS NULL THEN
		RETURN FALSE;
	 END IF;
    
	RETURN TRUE;
END; $$


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_is_exists_user$$
CREATE FUNCTION fnc_is_exists_user(pr_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_exists char(40) DEFAULT NULL;
     
	 SELECT COUNT(*) INTO is_exists
     FROM users u   
     WHERE u.userid = pr_user;
     
     
     IF is_exists > 0 THEN  
		RETURN TRUE;
	 END IF;
     
	 RETURN FALSE;
END; $$



DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_blocked_user$$
CREATE FUNCTION fnc_check_blocked_user(pr_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	DECLARE check_blocked INT DEFAULT -1; 
    
    SELECT COUNT(*) INTO check_blocked
    FROM users u 
    WHERE  u.userid = pr_user AND  u.status = 1;
    
    IF check_blocked > 0 THEN
		RETURN TRUE;
    END IF;
    RETURN FALSE;
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_block_user $$
CREATE PROCEDURE sp_block_user(pr_id_user char(40), pr_id_user_block char(40)) 
BEGIN	
    DECLARE is_admin INT DEFAULT 0;
    DECLARE is_exists_user INT DEFAULT -1; 
    DECLARE is_check_blocked INT DEFAULT -1;
    SET is_exists_user = fnc_is_exists_user(pr_id_user_block);
    
    IF is_exists_user = 0 THEN 
		SELECT 0 as "status", "User không tồn tại" as "message", "" as "data";
    ELSE 
		SET is_admin = fnc_check_authorization(pr_id_user);
		IF is_admin = 1 THEN  
			SET is_check_blocked = fnc_check_blocked_user(pr_id_user_block);
			IF is_check_blocked > 0 THEN 
				SELECT 0 as "status", "User đã được block" as "message",'' as "data";
			ELSE 
					SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
					START TRANSACTION;
						SET SQL_SAFE_UPDATES = 0;
							UPDATE users
							SET status = 1
							WHERE userid = pr_id_user_block;
						SET SQL_SAFE_UPDATES = 1;
					COMMIT;
					SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
                    
					SELECT 1 as "status","Update thành công" as "message",'' as "data"  ;
            END IF;
		ELSE 
			SELECT 0 as "status","Bạn Không Phải Admin" as "message",'' as "data";
		END IF;
	END IF;
END; $$


CALL sp_block_user("d5ef3568-634c-11ed-b1d9-00155d87afbf","41febb60-7233-11ed-b4c1-c8b29b839518")


use bds ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_return_list_users $$
CREATE PROCEDURE sp_return_list_users(pr_id_user varchar(50)) 
BEGIN	
	DECLARE is_admin INT DEFAULT 0;
	SET is_admin = fnc_checkAuthorization(pr_id_user);
	IF is_admin = 1 THEN 
		SELECT *  
        FROM users u
		WHERE u.status = 0;
	ELSE
		SELECT 0 as "status","Bạn Không Phải Admin" as "message",'' as "data";
    END IF; 
END; $$

CALL sp_return_list_users_blocked("d5ef3568-634c-11ed-b1d9-00155d87afbf")

use bds ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_return_list_users_blocked $$
CREATE PROCEDURE sp_return_list_users_blocked(pr_id_user varchar(50)) 
BEGIN	
	DECLARE is_admin INT DEFAULT 0;
	SET is_admin = fnc_check_authorization(pr_id_user);
	IF is_admin = 1 THEN 
		SELECT *  
        FROM users u
		WHERE u.status = 1;
	ELSE
		SELECT 0 as "status","Bạn Không Phải Admin" as "message",'' as "data";
    END IF; 
END; $$

CALL sp_return_list_users_blocked("d5ef3568-634c-11ed-b1d9-00155d87afbf")

use bds ;


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_authorization$$
CREATE FUNCTION fnc_check_authorization(pr_id_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_admin char(40) DEFAULT NULL;
     
     SELECT u.name into is_admin 
     FROM users u   
     WHERE u.typeuser = 1 AND  u.userid = pr_id_user;
     
     IF is_admin IS NULL THEN
		RETURN FALSE;
	 END IF;
    
	RETURN TRUE;
END; $$


DELIMITER $$
DROP FUNCTION IF EXISTS fnc_is_exists_user$$
CREATE FUNCTION fnc_is_exists_user(pr_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	 DECLARE is_exists char(40) DEFAULT NULL;
     
	 SELECT COUNT(*) INTO is_exists
     FROM users u   
     WHERE u.userid = pr_user;
     
     
     IF is_exists > 0 THEN  
		RETURN TRUE;
	 END IF;
     
	 RETURN FALSE;
END; $$



DELIMITER $$
DROP FUNCTION IF EXISTS fnc_check_blocked_user$$
CREATE FUNCTION fnc_check_blocked_user(pr_user char(40))
RETURNS boolean
DETERMINISTIC
begin
	DECLARE check_blocked INT DEFAULT -1; 
    
    SELECT COUNT(*) INTO check_blocked
    FROM users u 
    WHERE  u.userid = pr_user AND  u.status = 1;
    
    IF check_blocked > 0 THEN
		RETURN TRUE;
    END IF;
    RETURN FALSE;
END; $$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_recovery_user $$
CREATE PROCEDURE sp_recovery_user(pr_id_user char(40), pr_id_user_block char(40)) 
BEGIN	
    DECLARE is_admin INT DEFAULT 0;
    DECLARE is_exists_user INT DEFAULT -1; 
    DECLARE is_check_blocked INT DEFAULT -1;
    SET is_exists_user = fnc_is_exists_user(pr_id_user_block);
    
    IF is_exists_user = 0 THEN 
		SELECT 0 as "status", "User không tồn tại" as "message", "" as "data";
    ELSE 
		SET is_admin = fnc_check_authorization(pr_id_user);
		IF is_admin = 1 THEN  
			SET is_check_blocked = fnc_check_blocked_user(pr_id_user_block);
			IF is_check_blocked > 0 THEN 
            	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
					START TRANSACTION;
						SET SQL_SAFE_UPDATES = 0;
							UPDATE users
							SET status = 0
							WHERE userid = pr_id_user_block;
						SET SQL_SAFE_UPDATES = 1;
					COMMIT;
					SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
                    
					SELECT 1 as "status","Update thành công" as "message",'' as "data"  ;
				
			ELSE 
				SELECT 0 as "status", "User không bị chặn" as "message",'' as "data";
            END IF;
		ELSE 
			SELECT 0 as "status","Bạn Không Phải Admin" as "message",'' as "data";
		END IF;
	END IF;
END; $$


CALL sp_recovery_user("d5ef3568-634c-11ed-b1d9-00155d87afbf","41febb60-7233-11ed-b4c1-c8b29b839518")


