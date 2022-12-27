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
   
    IF quantity_medias > 3  THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_before_limit_insert_medias: ',cast(new.reid as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
    
END $$
 DELIMITER ;
 
 
INSERT medias(mediaid,url,reid)
	VALUES(uuid(),'123','d2cce737-8227-11ed-918e-0242ac110004');
 INSERT medias(mediaid,url,reid)
	VALUES(uuid(),'123','d2cce737-8227-11ed-918e-0242ac110004');
 INSERT medias(mediaid,url,reid)
	VALUES(uuid(),'123','d2cce737-8227-11ed-918e-0242ac110004');
 INSERT medias(mediaid,url,reid)
	VALUES(uuid(),'123','d2cce737-8227-11ed-918e-0242ac110004');
INSERT medias(mediaid,url,reid)
	VALUES(uuid(),'123','d2cce737-8227-11ed-918e-0242ac110004');
 select *
 from posts;
 
 select *
 from medias;

DELETE 
FROM MEDIAS 
where url = '123';
 