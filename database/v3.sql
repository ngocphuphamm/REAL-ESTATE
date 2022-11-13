-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th1 13, 2019 lúc 04:16 AM
-- Phiên bản máy phục vụ: 10.1.35-MariaDB
-- Phiên bản PHP: 7.2.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
DROP DATABASE IF EXISTS `BDS` ;
CREATE database BDS;
USE `BDS`;

SET SQL_SAFE_UPDATES = 0;


create table posts (
	reid char(40) not null ,
	categoryid char(40)  not null,
	title varchar(255) COLLATE utf8_unicode_ci not null,
	description text COLLATE utf8_unicode_ci not null,
	price decimal(15,2) not null,
	area varchar(100) not null,
	viewCount int not null default 0,
	approve tinyint(1) not null default 0,
	phone varchar(20) not null,
	address varchar(255) COLLATE utf8_unicode_ci  not null,
	rented tinyint(1) not null default 0,
	createdat timestamp not null default current_timestamp,
	updatedat timestamp,
	userid char(40) not null,
	projectid char(20),
	streetid int not null,
	wardid int not null,
	districtid int not null,
	provinceid int not null,
 primary key (reid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table users (
	userid char(40) not null ,
	name varchar(255) COLLATE utf8_unicode_ci not null,
	username varchar(150) not null,
	email varchar(100) not null,
	password varchar(255) not null,
	typeuser tinyint(1) not null default 0,
	phone varchar(20) not null,
	createdat timestamp not null default  current_timestamp,
	updatedat timestamp,
	status tinyint(1) not null default 0,
 primary key (userid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table convenient (
	convenientid char(40) not null,
    reid char(40) not null,
	bedroom int not null,
	bathroom int not null,
	floor int not null,
	direction text COLLATE utf8_unicode_ci not null,
	balconyDirection text COLLATE utf8_unicode_ci not null,
	furniture text COLLATE utf8_unicode_ci not null,
	fontageArea int not null,
    createdat timestamp not null default  current_timestamp,
	updatedat timestamp,
 primary key (convenientid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table medias (
	mediaid char(40) not null ,
	url text not null,
	reid char(40) not null,
 primary key (mediaid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table categories (
	categoryid char(40) not null ,
	name varchar(255) COLLATE utf8_unicode_ci not null,
 primary key (categoryid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table comment (
	commentid char(40) not null,
	createdat timestamp not null  default  current_timestamp,
	content text COLLATE utf8_unicode_ci not null,
	reid char(40) not null,
	userid char(40) not null,
 primary key (commentid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
 
 create table savePosts (
	savePostId char(40) not null,
	createdat timestamp not null  default  current_timestamp,
	reid char(40) not null,
	userid char(40) not null,
 primary key (savePostId))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table report (
	reportid char(40) not null,
	reid char(40) not null,
	phone varchar(20),
	email varchar(255),
	contentrp text COLLATE utf8_unicode_ci not null,
	createdat timestamp not null default  current_timestamp,
 primary key (reportid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table province (
	provinceid int not null,
	nameprovince varchar(50) COLLATE utf8_unicode_ci,
	codeprovince varchar(20),
 primary key (provinceid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table district (
	districtid int not null,
	provinceid int not null,
	namedistrict varchar(100) COLLATE utf8_unicode_ci,
	prefixdistrict varchar(20) COLLATE utf8_unicode_ci,
 primary key (districtid,provinceid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table ward (
	wardid int not null,
	nameward varchar(50) COLLATE utf8_unicode_ci,
	prefixward varchar(20 ) COLLATE utf8_unicode_ci,
	districtid int not null,
	provinceid int not null,
 primary key (wardid,districtid,provinceid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table project (
	projectid char(20) NOT NULL ,
	districtid int not null,
	provinceid int not null,
	nameproject varchar(200) COLLATE utf8_unicode_ci,
	lat double,
	lng double,
 primary key (projectid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table street (
	streetid int not null,
	districtid int not null,
	provinceid int not null,
	namestreet varchar(100) COLLATE utf8_unicode_ci,
	prefixstreet varchar(20) COLLATE utf8_unicode_ci,
 primary key (streetid))ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


alter table medias add foreign key (reid) references posts (reid) on delete  restrict on update  restrict;
alter table comment add foreign key (reid) references posts (reid) on delete  restrict on update  restrict;
alter table convenient add foreign key (reid) references posts (reid) on delete  restrict on update  restrict;
alter table report add foreign key (reid) references posts (reid) on delete  restrict on update  restrict;
alter table posts add foreign key (userid) references users (userid) on delete  restrict on update  restrict;
alter table comment add foreign key (userid) references users (userid) on delete  restrict on update  restrict;
alter table posts add foreign key (categoryid) references categories (categoryid) on delete  restrict on update  restrict;
alter table district add foreign key (provinceid) references province (provinceid) on delete  restrict on update  restrict;
alter table project add foreign key (districtid,provinceid) references district (districtid,provinceid) on delete  restrict on update  restrict;
alter table ward add foreign key (districtid,provinceid) references district (districtid,provinceid) on delete  restrict on update  restrict;
alter table street add foreign key (districtid,provinceid) references district (districtid,provinceid) on delete  restrict on update  restrict;
alter table posts add foreign key (wardid,districtid,provinceid) references ward (wardid,districtid,provinceid) on delete  restrict on update  restrict;
alter table posts add foreign key (projectid) references project (projectid) on delete  restrict on update  restrict;
alter table posts add foreign key (streetid) references street (streetid) on delete  restrict on update  restrict;
alter table savePosts add foreign key (reid) references posts (reid) on delete  restrict on update  restrict;
alter table savePosts add foreign key (userid) references users (userid) on delete  restrict on update  restrict;


/* users permissions */



/* USERS PERMISSIONS */
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


