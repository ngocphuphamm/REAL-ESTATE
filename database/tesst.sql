use bds; 

SELECT * FROM USERS;
DELETE FROM users;

delete from users u where u.username = "ngocphupham";

INSERT INTO  USERS(userid ,name,username,email,password,typeuser,phone,avatar,status) 
values (uuid(),"Ngọc Phú","ngocphupham","ngocphupham682001@gmail.com","123145",0,"0909603123","asdaasdasdasdasdasdasdasdsd",0);

------
call sp_Register("ngocphu","123","Pham Ngoc Phu","ngocphupham682001@gmail.com","123123");




------
call sp_Login("ngocphu", "123");

------
call sp_postFeed("c673e15a-62ad-11ed-98ae-c8b29b839518", "pr_title", "pr_description"
				 , 120.000,"pr_area","pr_phone","pr_Address"
                 , "04334e72-62b7-11ed-98ae-c8b29b839518",1
				 , 1, 1, 1,1);
SELECT *
FROM POSTS;

------
CALL sp_insert_medias("7709e621-62bb-11ed-98ae-c8b29b839518","123123");



------
call sp_Report("4f811be5-5d9e-11ed-98ae-c8b29b839518","123123123","ngocphupham682001@gmail.com","asdasdádasdasdasdasdasdasdasdasdasd");






------
CALL sp_Province_Posts(1);


call sp_Province_District_Posts("1","10");

call sp_Province_District_Ward_Posts("1","1","1");

call sp_Province_District_Ward_Street_Posts("1","1","1","1");

call sp_insert_convenient("7709e651-62bb-11ed-98ae-c8b29b839518",1, 1, 
									 3 ,"pr_direction", "pr_balconyDirection",
                                     "pr_furniture", 5);
CALL sp_Project("1");

CALL sp_Project_Province("1","1");

CALL sp_Project_Province_District(1,1,1);


-------
SET SQL_SAFE_UPDATES = 1;
CALL sp_Edit_User("04334e72-62b7-11ed-98ae-c8b29b839518","ngochu","123123");
------
SELECT *
FROM COMMENT


