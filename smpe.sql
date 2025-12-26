/*
SQLyog Ultimate v12.5.0 (64 bit)
MySQL - 5.7.44 : Database - smpe
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`smpe` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `smpe`;

/*Table structure for table `sys_dept` */

DROP TABLE IF EXISTS `sys_dept`;

CREATE TABLE `sys_dept` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '上级部门（顶级部门为0，默认为0）',
  `sub_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '子部门数目',
  `name` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '名称',
  `dept_sort` int(10) unsigned NOT NULL DEFAULT '999' COMMENT '排序',
  `enabled` bit(1) NOT NULL DEFAULT b'1' COMMENT '状态：1启用（默认）、0禁用',
  `create_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者',
  `update_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '状态：1启用（默认）、0禁用',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid` (`pid`) USING BTREE COMMENT '普通索引——pid查询部门',
  KEY `idx_enabled` (`enabled`) USING BTREE COMMENT '普通索引——enabled查询部门'
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='部门';

/*Data for the table `sys_dept` */

insert  into `sys_dept`(`id`,`pid`,`sub_count`,`name`,`dept_sort`,`enabled`,`create_by`,`update_by`,`create_time`,`update_time`,`is_deleted`) values 
(2,7,0,'研发部',3,'',1,1,'2020-12-13 11:41:04','2020-12-13 11:41:06','\0'),
(5,7,0,'运维部',4,'',1,1,'2020-12-13 11:41:36','2020-12-13 11:41:38','\0'),
(6,8,0,'测试部',6,'',1,1,'2020-12-13 11:42:17','2020-12-13 11:42:19','\0'),
(7,0,2,'华南分部',1,'',1,1,'2020-12-13 11:42:58','2020-12-13 11:43:01','\0'),
(8,0,1,'华北分部',7,'',1,1,'2020-12-13 11:43:40','2020-12-13 11:43:43','\0');

/*Table structure for table `sys_job` */

DROP TABLE IF EXISTS `sys_job`;

CREATE TABLE `sys_job` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '岗位名称',
  `enabled` bit(1) NOT NULL DEFAULT b'1' COMMENT '状态：1启用（默认）、0禁用',
  `job_sort` int(10) unsigned NOT NULL DEFAULT '999' COMMENT '排序',
  `create_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者id',
  `update_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新者id',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '软删除（默认值为0，1为删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unq_name` (`name`) USING BTREE COMMENT '岗位名唯一',
  KEY `idx_enabled` (`enabled`) USING BTREE COMMENT '普通索引——enabled查询岗位'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='岗位';

/*Data for the table `sys_job` */

insert  into `sys_job`(`id`,`name`,`enabled`,`job_sort`,`create_by`,`update_by`,`create_time`,`update_time`,`is_deleted`) values 
(1,'人事','',3,1,1,'2020-12-13 11:39:24','2020-12-13 11:39:28','\0'),
(2,'产品','',4,1,1,'2020-12-13 11:39:49','2020-12-13 11:39:52','\0');

/*Table structure for table `sys_log` */

DROP TABLE IF EXISTS `sys_log`;

CREATE TABLE `sys_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '日志id',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '操作用户id',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `log_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '日志类型',
  `method` varchar(255) NOT NULL DEFAULT '' COMMENT '方法名',
  `params` text COMMENT '参数',
  `request_ip` varchar(255) NOT NULL DEFAULT '' COMMENT '请求ip',
  `request_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '请求耗时（毫秒值）',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '地址',
  `browser` varchar(255) NOT NULL DEFAULT '' COMMENT '浏览器',
  `exception_detail` text COMMENT '详细异常',
  `create_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建人id',
  `update_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新人id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '软删除（默认值为0，1为删除）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE COMMENT '普通索引——根据创建时间查询日志',
  KEY `idx_log_type` (`log_type`) USING BTREE COMMENT '普通索引——根据日志类型查询日志'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='日志';

/*Data for the table `sys_log` */

/*Table structure for table `sys_menu` */

DROP TABLE IF EXISTS `sys_menu`;

CREATE TABLE `sys_menu` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '上级菜单ID',
  `sub_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '子菜单数目',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '菜单类型',
  `title` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '菜单标题',
  `name` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '组件名称',
  `component` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '组件',
  `menu_sort` int(10) unsigned NOT NULL DEFAULT '999' COMMENT '排序',
  `icon` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '图标',
  `path` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '链接地址',
  `i_frame` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否外链',
  `cache` bit(1) NOT NULL DEFAULT b'0' COMMENT '缓存',
  `hidden` bit(1) NOT NULL DEFAULT b'0' COMMENT '隐藏',
  `permission` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '权限',
  `create_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者',
  `update_by` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid` (`pid`) USING BTREE COMMENT '普通索引——pid查询菜单'
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='系统菜单';

/*Data for the table `sys_menu` */

insert  into `sys_menu`(`id`,`pid`,`sub_count`,`type`,`title`,`name`,`component`,`menu_sort`,`icon`,`path`,`i_frame`,`cache`,`hidden`,`permission`,`create_by`,`update_by`,`create_time`,`update_time`,`is_deleted`) values 
(1,0,7,0,'系统管理','','',1,'system','system','\0','\0','\0','',1,1,'2018-12-18 15:11:29','2020-12-13 16:25:07','\0'),
(2,1,3,1,'用户管理','User','system/user/index',2,'peoples','user','\0','\0','\0','user:list',1,1,'2018-12-18 15:14:44','2020-12-13 16:25:07','\0'),
(3,1,3,1,'角色管理','Role','system/role/index',3,'role','role','\0','\0','\0','roles:list',1,1,'2018-12-18 15:16:07','2020-12-13 16:25:07','\0'),
(5,1,3,1,'菜单管理','Menu','system/menu/index',5,'menu','menu','\0','\0','\0','menu:list',1,1,'2018-12-18 15:17:28','2020-12-13 16:25:07','\0'),
(6,0,4,0,'系统监控','','',10,'monitor','monitor','\0','\0','\0','',1,1,'2018-12-18 15:17:48','2020-12-13 16:25:07','\0'),
(7,6,0,1,'操作日志','Log','monitor/log/index',11,'log','logs','\0','\0','\0','',1,1,'2018-12-18 15:18:26','2020-12-13 16:25:07','\0'),
(28,1,3,1,'任务调度','Timing','system/timing/index',999,'timing','timing','\0','\0','\0','timing:list',1,1,'2019-01-07 20:34:40','2020-12-13 16:25:07','\0'),
(32,6,0,1,'异常日志','ErrorLog','monitor/log/errorLog',12,'error','errorLog','\0','\0','\0','',1,1,'2019-01-13 13:49:03','2020-12-13 16:25:07','\0'),
(35,1,3,1,'部门管理','Dept','system/dept/index',6,'dept','dept','\0','\0','\0','dept:list',1,1,'2019-03-25 09:46:00','2020-12-13 16:25:07','\0'),
(37,1,3,1,'岗位管理','Job','system/job/index',7,'Steve-Jobs','job','\0','\0','\0','job:list',1,1,'2019-03-29 13:51:18','2020-12-13 16:25:07','\0'),
(39,1,3,1,'字典管理','Dict','system/dict/index',8,'dictionary','dict','\0','\0','\0','dict:list',1,1,'2019-04-10 11:49:04','2020-12-13 16:25:07','\0'),
(41,6,0,1,'在线用户','OnlineUser','monitor/online/index',10,'Steve-Jobs','online','\0','\0','\0','',1,1,'2019-10-26 22:08:43','2020-12-13 16:25:07','\0'),
(44,2,0,2,'用户新增','','',2,'','','\0','\0','\0','user:add',1,1,'2019-10-29 10:59:46','2020-12-13 16:25:07','\0'),
(45,2,0,2,'用户编辑','','',3,'','','\0','\0','\0','user:edit',1,1,'2019-10-29 11:00:08','2020-12-13 16:25:07','\0'),
(46,2,0,2,'用户删除','','',4,'','','\0','\0','\0','user:del',1,1,'2019-10-29 11:00:23','2020-12-13 16:25:07','\0'),
(48,3,0,2,'角色创建','','',2,'','','\0','\0','\0','roles:add',1,1,'2019-10-29 12:45:34','2020-12-13 16:25:07','\0'),
(49,3,0,2,'角色修改','','',3,'','','\0','\0','\0','roles:edit',1,1,'2019-10-29 12:46:16','2020-12-13 16:25:07','\0'),
(50,3,0,2,'角色删除','','',4,'','','\0','\0','\0','roles:del',1,1,'2019-10-29 12:46:51','2020-12-13 16:25:07','\0'),
(52,5,0,2,'菜单新增','','',2,'','','\0','\0','\0','menu:add',1,1,'2019-10-29 12:55:07','2020-12-13 16:25:07','\0'),
(53,5,0,2,'菜单编辑','','',3,'','','\0','\0','\0','menu:edit',1,1,'2019-10-29 12:55:40','2020-12-13 16:25:07','\0'),
(54,5,0,2,'菜单删除','','',4,'','','\0','\0','\0','menu:del',1,1,'2019-10-29 12:56:00','2020-12-13 16:25:07','\0'),
(56,35,0,2,'部门新增','','',2,'','','\0','\0','\0','dept:add',1,1,'2019-10-29 12:57:09','2020-12-13 16:25:07','\0'),
(57,35,0,2,'部门编辑','','',3,'','','\0','\0','\0','dept:edit',1,1,'2019-10-29 12:57:27','2020-12-13 16:25:07','\0'),
(58,35,0,2,'部门删除','','',4,'','','\0','\0','\0','dept:del',1,1,'2019-10-29 12:57:41','2020-12-13 16:25:07','\0'),
(60,37,0,2,'岗位新增','','',2,'','','\0','\0','\0','job:add',1,1,'2019-10-29 12:58:27','2020-12-13 16:25:07','\0'),
(61,37,0,2,'岗位编辑','','',3,'','','\0','\0','\0','job:edit',1,1,'2019-10-29 12:58:45','2020-12-13 16:25:07','\0'),
(62,37,0,2,'岗位删除','','',4,'','','\0','\0','\0','job:del',1,1,'2019-10-29 12:59:04','2020-12-13 16:25:07','\0'),
(64,39,0,2,'字典新增','','',2,'','','\0','\0','\0','dict:add',1,1,'2019-10-29 13:00:17','2020-12-13 16:25:07','\0'),
(65,39,0,2,'字典编辑','','',3,'','','\0','\0','\0','dict:edit',1,1,'2019-10-29 13:00:42','2020-12-13 16:25:07','\0'),
(66,39,0,2,'字典删除','','',4,'','','\0','\0','\0','dict:del',1,1,'2019-10-29 13:00:59','2020-12-13 16:25:07','\0'),
(73,28,0,2,'任务新增','','',2,'','','\0','\0','\0','timing:add',1,1,'2019-10-29 13:07:28','2020-12-13 16:25:07','\0'),
(74,28,0,2,'任务编辑','','',3,'','','\0','\0','\0','timing:edit',1,1,'2019-10-29 13:07:41','2020-12-13 16:25:07','\0'),
(75,28,0,2,'任务删除','','',4,'','','\0','\0','\0','timing:del',1,1,'2019-10-29 13:07:54','2020-12-13 16:25:07','\0');

/*Table structure for table `sys_quartz_job` */

DROP TABLE IF EXISTS `sys_quartz_job`;

CREATE TABLE `sys_quartz_job` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `bean_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Spring Bean名称',
  `cron_expression` varchar(255) NOT NULL DEFAULT '' COMMENT 'cron 表达式',
  `is_pause` bit(1) NOT NULL DEFAULT b'0' COMMENT '状态：0暂停、1启用',
  `job_name` varchar(255) NOT NULL DEFAULT '' COMMENT '任务名称',
  `method_name` varchar(255) NOT NULL DEFAULT '' COMMENT '方法名称',
  `params` varchar(255) NOT NULL DEFAULT '' COMMENT '参数',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `person_in_charge` varchar(100) NOT NULL DEFAULT '' COMMENT '负责人',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '报警邮箱',
  `sub_task` varchar(100) NOT NULL DEFAULT '' COMMENT '子任务ID',
  `pause_after_failure` bit(1) NOT NULL DEFAULT b'0' COMMENT '任务失败后是否暂停,0是暂停，1是不暂停',
  `create_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者',
  `update_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除：0启用（默认）、1删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `inx_is_pause` (`is_pause`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='定时任务';

/*Data for the table `sys_quartz_job` */

/*Table structure for table `sys_quartz_log` */

DROP TABLE IF EXISTS `sys_quartz_log`;

CREATE TABLE `sys_quartz_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `bean_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'bean对象名称',
  `cron_expression` varchar(255) NOT NULL DEFAULT '' COMMENT 'cron表达式',
  `exception_detail` text COMMENT '异常详情',
  `is_success` bit(1) NOT NULL DEFAULT b'0' COMMENT '状态（是否成功）1成功，0失败(默认)',
  `job_name` varchar(255) NOT NULL DEFAULT '' COMMENT '任务名称',
  `method_name` varchar(255) NOT NULL DEFAULT '' COMMENT '执行方法',
  `params` varchar(255) NOT NULL DEFAULT '' COMMENT '方法参数',
  `time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '执行时间(ms)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者',
  `update_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新者',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除：0启用（默认）、1删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='定时任务日志';

/*Data for the table `sys_quartz_log` */

/*Table structure for table `sys_role` */

DROP TABLE IF EXISTS `sys_role`;

CREATE TABLE `sys_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '角色名称',
  `level` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '角色级别（越小越大）',
  `description` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '描述',
  `data_scope` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '数据权限',
  `is_protection` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否受保护（内置角色，1为内置角色，默认值为0）',
  `create_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者id',
  `update_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新者id',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '软删除（默认值为0，1为删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unq_name` (`name`) USING BTREE COMMENT '角色名唯一',
  KEY `idx_role_name` (`name`) USING BTREE COMMENT '普通索引——角色名查询角色信息'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='角色表';

/*Data for the table `sys_role` */

insert  into `sys_role`(`id`,`name`,`level`,`description`,`data_scope`,`is_protection`,`create_by`,`update_by`,`create_time`,`update_time`,`is_deleted`) values 
(1,'超级管理员',1,'-','全部','',1,1,'2020-12-13 11:36:45','2020-12-13 11:36:47','\0'),
(2,'普通用户',2,'-','自定义','',1,1,'2020-12-13 11:37:14','2020-12-13 11:37:18','\0');

/*Table structure for table `sys_roles_depts` */

DROP TABLE IF EXISTS `sys_roles_depts`;

CREATE TABLE `sys_roles_depts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `dept_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '部门id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_mid_dept_id` (`dept_id`) USING BTREE COMMENT '普通索引——根据dept_id查询',
  KEY `idx_mid_role_id` (`role_id`) USING BTREE COMMENT '普通索引——根据role_id查询'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='角色部门关联';

/*Data for the table `sys_roles_depts` */

insert  into `sys_roles_depts`(`id`,`role_id`,`dept_id`) values 
(1,2,7);

/*Table structure for table `sys_roles_menus` */

DROP TABLE IF EXISTS `sys_roles_menus`;

CREATE TABLE `sys_roles_menus` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id\n',
  `menu_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '菜单ID',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_mid_role_id` (`role_id`) USING BTREE COMMENT '普通索引——根据role_id查询',
  KEY `idx_mid_menu_id` (`menu_id`) USING BTREE COMMENT '普通索引——根据menu_id查询'
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='角色菜单关联';

/*Data for the table `sys_roles_menus` */

insert  into `sys_roles_menus`(`id`,`menu_id`,`role_id`) values 
(1,1,1),
(2,1,2),
(3,2,1),
(4,2,2),
(5,3,1),
(6,3,2),
(7,5,1),
(8,5,2),
(9,6,1),
(10,7,1),
(26,28,1),
(28,32,1),
(31,35,1),
(34,37,1),
(36,39,1),
(37,41,1);

/*Table structure for table `sys_user` */

DROP TABLE IF EXISTS `sys_user`;

CREATE TABLE `sys_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `dept_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '部门id',
  `username` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '用户名',
  `nick_name` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '昵称',
  `gender` bit(1) NOT NULL DEFAULT b'0' COMMENT '性别（0为男默认，1为女）',
  `phone` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '手机号码',
  `email` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '邮箱',
  `avatar_path` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '头像路径',
  `password` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '密码',
  `is_admin` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否为admin账号',
  `enabled` bit(1) NOT NULL DEFAULT b'1' COMMENT '状态：1启用（默认）、0禁用',
  `create_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者id',
  `update_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新者id',
  `pwd_reset_time` datetime DEFAULT NULL COMMENT '修改密码的时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '软删除（默认值为0，1为删除）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_dept_id` (`dept_id`) USING BTREE COMMENT '普通索引——根据dept_id查询用户',
  KEY `idx_enabled` (`enabled`) USING BTREE COMMENT '普通索引——根据enabled查询'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='系统用户';

/*Data for the table `sys_user` */

insert  into `sys_user`(`id`,`dept_id`,`username`,`nick_name`,`gender`,`phone`,`email`,`avatar_path`,`password`,`is_admin`,`enabled`,`create_by`,`update_by`,`pwd_reset_time`,`create_time`,`update_time`,`is_deleted`) values 
(1,2,'admin','管理员','\0','18888888888','201507802@qq.com','','$2a$10$Egp1/gvFlt7zhlXVfEFw4OfWQCGPw0ClmMcc6FjTnvXNRVf9zdMRa','','',1,1,'2020-12-13 11:27:20','2020-12-13 11:26:52','2020-12-13 11:26:57','\0'),
(2,5,'test','测试','','15689899898','231@qq.com','','$2a$10$Egp1/gvFlt7zhlXVfEFw4OfWQCGPw0ClmMcc6FjTnvXNRVf9zdMRa','\0','',1,1,NULL,'2020-12-13 11:34:53','2020-12-13 11:34:59','\0');

/*Table structure for table `sys_users_jobs` */

DROP TABLE IF EXISTS `sys_users_jobs`;

CREATE TABLE `sys_users_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `job_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '岗位ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_mid_job_id` (`job_id`) USING BTREE COMMENT '普通索引——根据job_id查询',
  KEY `idx_mid_user_id` (`user_id`) USING BTREE COMMENT '普通索引——根据user_id查询'
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `sys_users_jobs` */

insert  into `sys_users_jobs`(`id`,`user_id`,`job_id`) values 
(1,1,1),
(2,1,1),
(3,2,2);

/*Table structure for table `sys_users_roles` */

DROP TABLE IF EXISTS `sys_users_roles`;

CREATE TABLE `sys_users_roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id\n',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_mid_role_id` (`role_id`) USING BTREE COMMENT '普通索引——根据role_id查询',
  KEY `idx_mid_user_id` (`user_id`) USING BTREE COMMENT '普通索引——根据user_id查询用户'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='用户角色关联';

/*Data for the table `sys_users_roles` */

insert  into `sys_users_roles`(`id`,`user_id`,`role_id`) values 
(1,1,1),
(2,2,1);

/*Table structure for table `test` */

DROP TABLE IF EXISTS `test`;

CREATE TABLE `test` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

/*Data for the table `test` */

insert  into `test`(`id`,`name`) values 
(1,'张三');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
