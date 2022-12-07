use bds; 

DROP TRIGGER IF EXISTS tg_before_limit_insert_medias;
DELIMITER $$
CREATE TRIGGER tg_before_limit_insert_medias
BEFORE INSERT
ON medias FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
	DECLARE quantity_medias INT DEFAULT -1;
    
    SET  quantity_medias = (SELECT COUNT(*)
						   FROM  medias
						   WHERE reid = new.reid);
   
    IF quantity_medias = 5  THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_before_limit_insert_medias: ',cast(new.reid as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
    
END $$
 DELIMITER ;
 
 
INSERT MEDIAS(MEDIAID,URL,REID)
	VALUES(uuid(),'123','3f4e3910-73ee-11ed-b4c1-c8b29b839518');
 
 
 
 select *
 from posts;
 
 select *
 from medias;

DELETE 
FROM MEDIAS 
where url = '123';
 