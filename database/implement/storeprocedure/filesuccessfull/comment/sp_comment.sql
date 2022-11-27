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

