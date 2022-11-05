use bds; 

select * 
from users;

delete from users u where u.username = "ngocphupham";

INSERT INTO  USERS(userid ,name,username,email,password,typeuser,phone,avatar,status) 
values (uuid(),"Ngọc Phú","ngocphupham","ngocphupham682001@gmail.com","123145",0,"0909603123","asdaasdasdasdasdasdasdasdsd",0);

call sp_Register("ngocphu","123","Pham Ngoc Phu","ngocphupham682001@gmail.com","123123");

call sp_Login("ngocphu", "123");

call sp_postFeed("9962baad-5d3e-11ed-9637-c8b29b839518", "Đẹp quá", "quá đẹp",
				 "khong biet", 120.000,"20m2","123123","pr_Address"
                 , 123.123, 123.12312, "7fb1b894-5d44-11ed-9637-c8b29b839518","12312"
                  , 1, 1, 1 
				  ,1, 1, 1, 1, "direction", "pr_balconyDirection"
				  ,"pr_furniture", 1);


		






