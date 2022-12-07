use bds;

DROP TRIGGER IF EXISTS tg_before_type_user;
DELIMITER $$
CREATE TRIGGER tg_before_type_user
BEFORE INSERT
ON users FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(200);
    IF  NEW.typeuser != 0 AND NEW.typeuser != 1 THEN
		SET msg =  concat('MyTriggerError: Trying to insert a negative value in tg_before_type_user: ', cast(new.typeuser as char));
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END IF;
END $$
DELIMITER ;



INSERT INTO  USERS(userid ,name,username,email,password,typeuser,phone,status) 
values (uuid(),"Ngọc Phú","hel2lo",
		"ngocphupham682001@gmail.com","1231231145",1,"0909603123",0);