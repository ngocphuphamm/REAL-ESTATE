use bds; 

select * 
from users;

delete from users u where u.username = "ngocphupham";

INSERT INTO  USERS(userid ,name,username,email,password,typeuser,phone,avatar,status) 
values (uuid(),"Ngọc Phú","ngocphupham","ngocphupham682001@gmail.com","123145",0,"0909603123","asdaasdasdasdasdasdasdasdsd",0);

call sp_Register("ngocphu","123","Pham Ngoc Phu","ngocphupham682001@gmail.com","123123");

call sp_Login("ngocphu", "123");

call sp_postFeed("ed52164b-5d9c-11ed-98ae-c8b29b839518", "Đẹp quá", "quá đẹp",
				 "khong biet", 120.000,"20m2","123123","pr_Address"
                 , 123.123, 123.12312, "3db03ff9-5d9d-11ed-98ae-c8b29b839518",NULL
                  , 1, 1, 1 
				  ,1, 1, 1, 1, "direction", "pr_balconyDirection"
				  ,"pr_furniture", 1);
select * 
from posts;

call sp_Report("4f811be5-5d9e-11ed-98ae-c8b29b839518","123123123","ngocphupham682001@gmail.com","asdasdádasdasdasdasdasdasdasdasdasd");





