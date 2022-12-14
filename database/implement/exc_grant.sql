use bds;

CREATE USER IF NOT EXISTS 'RE_Quanly'@'localhost' IDENTIFIED BY '123@';
CREATE USER IF NOT EXISTS 'RE_Q='@'%' IDENTIFIED BY '123@';


CREATE ROLE  IF NOT EXISTS 'RE_QuanLy';
CREATE ROLE IF NOT EXISTS 'RE_KhachHangThanThiet';
CREATE ROLE IF NOT EXISTS 'RE_KhachHangVangLai';

GRANT SELECT, INSERT, UPDATE, DELETE ON bds.categories TO 'RE_QuanLy';
GRANT INSERT ON bds.comment TO 'RE_QuanLy';
GRANT INSERT ON bds.convenient TO 'RE_QuanLy';
GRANT SELECT,INSERT, UPDATE, DELETE ON bds.district TO 'RE_QuanLy';
GRANT SELECT ON bds.medias TO 'RE_QuanLy';
GRANT SELECT, UPDATE ON bds.posts TO 'RE_QuanLy';
GRANT SELECT,INSERT, UPDATE, DELETE ON bds.project TO 'RE_QuanLy';
GRANT SELECT,INSERT, UPDATE, DELETE ON bds.province TO 'RE_QuanLy';
GRANT SELECT,INSERT, UPDATE, DELETE ON bds.report TO 'RE_QuanLy';
GRANT SELECT,INSERT, UPDATE, DELETE ON bds.saveposts TO 'RE_QuanLy';
GRANT SELECT,INSERT, UPDATE, DELETE ON bds.street TO 'RE_QuanLy';
GRANT SELECT,INSERT, UPDATE, DELETE ON bds.users TO 'RE_QuanLy';
GRANT SELECT,INSERT, UPDATE, DELETE ON bds.ward TO 'RE_QuanLy';


GRANT SELECT ON bds.categories TO 'RE_KhachHangThanThiet';
GRANT INSERT, UPDATE ON bds.comment TO 'RE_KhachHangThanThiet';
GRANT INSERT, UPDATE ON bds.convenient TO 'RE_KhachHangThanThiet';
GRANT SELECT ON bds.district TO 'RE_KhachHangThanThiet';
GRANT SELECT ON bds.medias TO 'RE_KhachHangThanThiet';
GRANT SELECT,INSERT, UPDATE, DELETE ON bds.posts TO 'RE_KhachHangThanThiet';
GRANT SELECT ON bds.project TO 'RE_KhachHangThanThiet';
GRANT SELECT ON bds.province TO 'RE_KhachHangThanThiet';
GRANT SELECT,INSERT ON bds.report TO 'RE_KhachHangThanThiet';
GRANT SELECT,INSERT, DELETE ON bds.saveposts TO 'RE_KhachHangThanThiet';
GRANT SELECT ON bds.street TO 'RE_KhachHangThanThiet';
GRANT SELECT,INSERT, UPDATE ON bds.users TO 'RE_KhachHangThanThiet';
GRANT SELECT ON bds.ward TO 'RE_KhachHangThanThiet';


GRANT SELECT ON bds.* TO 'RE_KhachHangVangLai';



GRANT EXECUTE ON PROCEDURE bds.sp_Report TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Register TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_update_status_post TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_get_listMedias TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_show_detail_info TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_get_convenient TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_search_keyword TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Province_Posts TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Province_District_Posts TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Province_District_Ward_Posts TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Project TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Project_Province TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Project_Province_District TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Province_District_Ward_Street_Posts TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_get_post TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_savePosts TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Edit_User TO 'RE_KhachHangThanThiet';
GRANT EXECUTE ON PROCEDURE bds.sp_Comment TO 'RE_KhachHangThanThiet';


GRANT EXECUTE ON PROCEDURE bds.sp_return_list_posts TO 'RE_QuanLy';
GRANT EXECUTE ON PROCEDURE bds.sp_bans_post TO 'RE_QuanLy';
GRANT EXECUTE ON PROCEDURE bds.sp_return_list_posts_blocked TO 'RE_QuanLy';
GRANT EXECUTE ON PROCEDURE bds.sp_recovery_post TO 'RE_QuanLy';
GRANT EXECUTE ON PROCEDURE bds.sp_block_user TO 'RE_QuanLy';
GRANT EXECUTE ON PROCEDURE bds.sp_return_list_users TO 'RE_QuanLy';
GRANT EXECUTE ON PROCEDURE bds.sp_recovery_user TO 'RE_QuanLy';





SHOW grants FOR  'RE_QuanLy';
