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



select * 
from ward






DELIMITER $$
DROP PROCEDURE IF EXISTS sp_postFeed $$
CREATE PROCEDURE sp_postFeed(pr_categoryid varchar(200), pr_title varchar(200), pr_description text
							, pr_displayDistrict text, pr_price decimal(15,2), pr_area varchar(100)
                            , pr_phone varchar(20),pr_address varchar(150), pr_lat double, pr_lng double, pr_userid varchar(200)
                            , pr_projectid char(20), pr_streetid int, pr_wardid int, pr_districtid int
                            , pr_provinceid int, pr_bedroom int, pr_bathroom int, pr_floor int
                            , pr_direction text, pr_balconyDirection text, pr_furniture text
                            , pr_fontageArea int) 
BEGIN	
    DECLARE isExists INT DEFAULT -1;
        
	DECLARE isCheckAddress INT DEFAULT -1;
	
    DECLARE isCheckUserID INT DEFAULT -1;
   
    
    SELECT COUNT(*) INTO isExists FROM categories c WHERE c.categoryid = pr_categoryid;
	
    IF(isExists = 0) THEN
		SELECT "Loại Bất Động Sản Không Có";
	END IF;
    
    SET isCheckAddress = fnc_checkAddress(pr_provinceid, pr_districtid,
											 pr_wardid, pr_streetid);
    IF(isCheckAddress > 0) THEN
		SELECT "Địa Chỉ Không Hợp Lệ";
	END IF;
	
    
    
	INSERT INTO posts (reid, categoryid, title, description, displayDistrict, price, area, phone, address, lat, lng, userid, projectid, streetid, wardid, districtid, provinceid, bedroom, bathroom, floor, direction, balconyDirection, furniture, fontageArea)
		  VALUES (uuid(), pr_categoryid, pr_title, pr_description
				, pr_displayDistrict, pr_price
                , pr_area, pr_phone, pr_address 
                , pr_lat, pr_lng,pr_userid
                , pr_projectid, pr_streetid, pr_wardid, pr_districtid
                , pr_provinceid, pr_bedroom, pr_bathroom, pr_floor, pr_direction
                , pr_balconyDirection, pr_furniture, pr_fontageArea);
	SELECT 1;
    
END; $$

