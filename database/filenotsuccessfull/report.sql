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
    
    IF(isCheckLengthContent < 35) THEN
		SELECT "Nội dung không đủ để tố cáo";
    ELSEIF (isCheckReportUser > 0 ) THEN
		SELECT "Người dùng đã gửi tố cáo";
	ELSE
    	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		START TRANSACTION;
			SET SQL_SAFE_UPDATES = 0;
			INSERT INTO report (reportid, reid, phone, email, contentrp)
				  VALUES (uuid(),pr_reid,pr_phone,pr_email,pr_contentrp);
			SET SQL_SAFE_UPDATES = 1;
			SELECT 1;
        COMMIT;
	END IF;
END; $$


