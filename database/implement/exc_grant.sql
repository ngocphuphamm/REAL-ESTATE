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


SHOW grants FOR  'RE_QuanLy';
