/*
SQLyog Ultimate v12.5.0 (64 bit)
MySQL - 5.7.44 : Database - english
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`english` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `english`;

/*Table structure for table `dictionaries` */

DROP TABLE IF EXISTS `dictionaries`;

CREATE TABLE `dictionaries` (
  `dictionary_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '字典唯一标识',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典名称(如: CET4/考研核心词)',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '字典详细介绍',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用(1启用 0停用)',
  `is_mastered` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否全部掌握(1是 0否)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`dictionary_id`),
  UNIQUE KEY `uniq_dict_name` (`name`) COMMENT '字典名称唯一'
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典主表';

/*Table structure for table `dictionary_words` */

DROP TABLE IF EXISTS `dictionary_words`;

CREATE TABLE `dictionary_words` (
  `relation_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '关系主键',
  `dictionary_id` int(11) NOT NULL COMMENT '字典ID',
  `word_id` int(11) NOT NULL COMMENT '单词ID',
  `difficulty` tinyint(1) DEFAULT NULL COMMENT '字典内难度(0-简单 1-中等 2-困难)',
  `is_mastered` tinyint(1) DEFAULT NULL COMMENT '字典内掌握状态(1是 0否 NULL未设置)',
  `notes` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典内备注',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `unique_dict_word` (`dictionary_id`,`word_id`) COMMENT '防止重复添加',
  KEY `idx_dw_word` (`word_id`),
  CONSTRAINT `dictionary_words_ibfk_1` FOREIGN KEY (`dictionary_id`) REFERENCES `dictionaries` (`dictionary_id`) ON DELETE CASCADE,
  CONSTRAINT `dictionary_words_ibfk_2` FOREIGN KEY (`word_id`) REFERENCES `words` (`word_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典单词关系表';


/*Table structure for table `error_words` */

DROP TABLE IF EXISTS `error_words`;

CREATE TABLE `error_words` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_id` int(11) NOT NULL COMMENT '计划ID',
  `word_id` int(11) NOT NULL COMMENT '单词ID',
  `error_count` int(11) NOT NULL DEFAULT '1' COMMENT '错误次数',
  `last_error_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_plan_error_word` (`plan_id`,`word_id`),
  KEY `word_id` (`word_id`),
  KEY `idx_error_words_plan_id` (`plan_id`),
  CONSTRAINT `error_words_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `word_plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `error_words_ibfk_2` FOREIGN KEY (`word_id`) REFERENCES `words` (`word_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `learning_progress` */

DROP TABLE IF EXISTS `learning_progress`;

CREATE TABLE `learning_progress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_id` int(11) NOT NULL COMMENT '计划ID',
  `total_words` int(11) NOT NULL COMMENT '总单词数',
  `learned_words` int(11) NOT NULL DEFAULT '0' COMMENT '已学习单词数',
  `correct_words` int(11) NOT NULL DEFAULT '0' COMMENT '正确单词数',
  `error_words` int(11) NOT NULL DEFAULT '0' COMMENT '错误单词数',
  `last_studied_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_plan_progress` (`plan_id`),
  KEY `idx_learning_progress_plan_id` (`plan_id`),
  CONSTRAINT `learning_progress_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `word_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/*Table structure for table `learning_records` */

DROP TABLE IF EXISTS `learning_records`;

CREATE TABLE `learning_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_id` int(11) NOT NULL COMMENT '计划ID',
  `word_id` int(11) NOT NULL COMMENT '单词ID',
  `user_answer` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户答案',
  `is_correct` tinyint(1) NOT NULL COMMENT '是否正确',
  `attempts` int(11) NOT NULL DEFAULT '1' COMMENT '尝试次数',
  `learned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_learning_records_plan_id` (`plan_id`),
  KEY `idx_learning_records_word_id` (`word_id`),
  CONSTRAINT `learning_records_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `word_plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `learning_records_ibfk_2` FOREIGN KEY (`word_id`) REFERENCES `words` (`word_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



/*Table structure for table `pronunciation_rules` */

DROP TABLE IF EXISTS `pronunciation_rules`;

CREATE TABLE `pronunciation_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '发音规则唯一标识',
  `letter_combination` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字母组合，如 "tion", "ea", "ough"',
  `pronunciation` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发音，如 "/ʃən/", "/iː/"',
  `rule_description` text COLLATE utf8mb4_unicode_ci COMMENT '发音规则说明',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_letter_combination` (`letter_combination`) COMMENT '字母组合查询索引'
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='发音规则表';


/*Table structure for table `sentence_tokens` */

DROP TABLE IF EXISTS `sentence_tokens`;

CREATE TABLE `sentence_tokens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sentence_id` bigint(20) NOT NULL,
  `position` int(11) NOT NULL COMMENT 'token 在句中的顺序，从 0 开始',
  `token_text` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始文本片段',
  `token_type` enum('word','punctuation') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '单词或标点',
  `word_id` int(11) DEFAULT NULL COMMENT '关联的单词 ID，NULL 表示未关联',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_sentence_position` (`sentence_id`,`position`),
  KEY `idx_token_word_id` (`word_id`),
  CONSTRAINT `fk_token_sentence` FOREIGN KEY (`sentence_id`) REFERENCES `sentences` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_token_word` FOREIGN KEY (`word_id`) REFERENCES `words` (`word_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sentences` */

DROP TABLE IF EXISTS `sentences`;

CREATE TABLE `sentences` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_text_prefix` (`text`(768))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



/*Table structure for table `word_plan_words` */

DROP TABLE IF EXISTS `word_plan_words`;

CREATE TABLE `word_plan_words` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_id` int(11) NOT NULL COMMENT '计划ID',
  `word_id` int(11) NOT NULL COMMENT '单词ID',
  `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序索引',
  `added_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_plan_word` (`plan_id`,`word_id`),
  KEY `idx_word_plan_words_plan_id` (`plan_id`),
  KEY `idx_word_plan_words_word_id` (`word_id`),
  CONSTRAINT `word_plan_words_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `word_plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `word_plan_words_ibfk_2` FOREIGN KEY (`word_id`) REFERENCES `words` (`word_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `word_plans` */

DROP TABLE IF EXISTS `word_plans`;

CREATE TABLE `word_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '计划名称',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '计划描述',
  `mode` enum('flash-card','spelling') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'flash-card' COMMENT '答题模式',
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'inactive' COMMENT '启用状态',
  `target_word_count` int(11) NOT NULL DEFAULT '10' COMMENT '目标单词数量',
  `daily_word_count` int(11) NOT NULL DEFAULT '5' COMMENT '每日学习单词数量',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_word_plans_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/*Table structure for table `word_pronunciation_rules` */

DROP TABLE IF EXISTS `word_pronunciation_rules`;

CREATE TABLE `word_pronunciation_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '关联关系唯一标识',
  `word_id` int(11) NOT NULL COMMENT '单词ID，外键关联words表的word_id字段',
  `pronunciation_rule_id` int(11) NOT NULL COMMENT '发音规则ID，外键关联pronunciation_rules表的id字段',
  `position_in_word` int(11) DEFAULT NULL COMMENT '该规则在单词中的位置（可选）',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_word_rule` (`word_id`,`pronunciation_rule_id`) COMMENT '防止重复关联',
  KEY `idx_word_pronunciation_rule_word` (`word_id`) COMMENT '根据单词ID查询关联规则',
  KEY `idx_word_pronunciation_rule_rule` (`pronunciation_rule_id`) COMMENT '根据规则ID查询使用该规则的单词',
  CONSTRAINT `word_pronunciation_rules_ibfk_1` FOREIGN KEY (`word_id`) REFERENCES `words` (`word_id`) ON DELETE CASCADE,
  CONSTRAINT `word_pronunciation_rules_ibfk_2` FOREIGN KEY (`pronunciation_rule_id`) REFERENCES `pronunciation_rules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='单词-发音规则多对多关联表，支持一个单词关联多个发音规则';

/*Table structure for table `words` */

DROP TABLE IF EXISTS `words`;

CREATE TABLE `words` (
  `word_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '单词唯一标识',
  `word` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '英文单词',
  `phonetic` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '音标(支持英式/美式不同标记)',
  `meaning` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '中文释义',
  `pronunciation1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发音链接1(默认英音)',
  `pronunciation2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发音链接2(美音)',
  `pronunciation3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发音链接3(例句发音)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `difficulty` tinyint(1) NOT NULL DEFAULT '0' COMMENT '难度等级(0-简单 1-中等 2-困难)',
  `is_mastered` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否掌握(1是 0否)',
  `notes` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '笔记(可选)',
  `sentence` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '例句(可选)',
  `has_image` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否有图片(0-无 1-有)',
  `image_type` enum('url','iconfont','emoji') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片类型(url-链接 iconfont-图标字体 emoji-表情)',
  `image_value` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片值(根据type存储URL/类名/emoji)',
  PRIMARY KEY (`word_id`),
  UNIQUE KEY `uniq_word` (`word`) COMMENT '单词唯一性约束',
  KEY `idx_phonetic` (`phonetic`(10)) COMMENT '音标查询索引',
  KEY `idx_words_first_char` (`word`(1)),
  KEY `idx_has_image` (`has_image`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='单词库表（含音标）';



/*Data for the table `dictionaries` */

insert  into `dictionaries`(`dictionary_id`,`name`,`description`,`is_enabled`,`is_mastered`,`created_at`,`updated_at`) values 
(2,'译林一上','译林版本一年级上册',1,0,'2025-10-31 21:28:37','2025-10-31 21:28:37'),
(3,'译林一下','译林版本一年级下册',1,0,'2025-10-31 21:28:56','2025-10-31 21:28:56'),
(4,'译林二上','译林版本二年级上册',1,0,'2025-10-31 21:40:16','2025-10-31 21:40:16'),
(5,'译林二下','译林版本二年级下册',1,0,'2025-10-31 21:40:44','2025-10-31 21:40:44'),
(6,'剑少','剑桥少儿',1,0,'2025-10-31 21:41:06','2025-10-31 21:41:06'),
(7,'Power UP P0',NULL,1,0,'2025-10-31 21:41:28','2025-10-31 21:41:28');

/*Data for the table `pronunciation_rules` */

insert  into `pronunciation_rules`(`id`,`letter_combination`,`pronunciation`,`rule_description`,`created_at`,`updated_at`) values 
(1,'tion','/ʃən/','结尾发音规则，通常在单词末尾发 /ʃən/ 音，如 action, nation, station','2025-11-05 09:13:14','2025-11-05 09:13:14'),
(2,'ea','/iː/','长音发音，在多数情况下发长音 /iː/，如 eat, beach, teach, read（现在时）','2025-11-05 09:13:14','2025-11-05 09:13:14'),
(3,'ea','/e/','短音发音，在某些情况下发短音 /e/，如 head, bread, ready, weather','2025-11-05 09:13:14','2025-11-05 09:13:14'),
(7,'th','/θ/','清辅音，在单词开头或中间时通常发清辅音 /θ/，如 think, three, method','2025-11-05 09:13:14','2025-11-05 09:13:14'),
(8,'th','/ð/','浊辅音，在单词中间或结尾时通常发浊辅音 /ð/，如 this, that, mother, with','2025-11-05 09:13:14','2025-11-05 09:13:14'),
(9,'ph','/f/','发 /f/ 音，如 phone, photo, graph, elephant','2025-11-05 09:13:14','2025-11-05 09:13:14'),
(10,'ch','/tʃ/','通常发 /tʃ/ 音，如 chair, teach, church, watch','2025-11-05 09:13:14','2025-11-05 09:13:14'),
(11,'sh','/ʃ/','通常发 /ʃ/ 音，如 she, fish, shoe, push','2025-11-05 09:13:14','2025-11-05 09:13:14'),
(12,'er','/ə/',NULL,'2025-11-05 10:03:07','2025-11-05 10:03:07'),
(13,'ts','/ts/',NULL,'2025-11-05 10:03:40','2025-11-05 10:03:40'),
(14,'ds','/dz/',NULL,'2025-11-05 10:03:53','2025-11-05 10:04:14'),
(15,'dr','/dr/',NULL,'2025-11-05 10:04:31','2025-11-05 10:04:31'),
(16,'tr','/tr/',NULL,'2025-11-05 10:04:40','2025-11-05 10:04:40'),
(17,'igh','/aɪ/','high, light, night','2025-11-05 10:05:23','2025-11-05 10:05:23'),
(18,'oo','/u:/','长音/u:/,如room, food, moon, cool, school, zoo, bamboo, tooth','2025-11-05 10:09:47','2025-11-05 10:09:47'),
(19,'oo','/ʊ/','短音/ʊ/，如good, foot, look, book, cook','2025-11-05 10:10:44','2025-11-05 10:10:44'),
(20,'ck','/k/',NULL,'2025-11-05 10:15:52','2025-11-05 10:15:52'),
(21,'ir','/ɜː/','如girl, bird','2025-11-05 10:18:00','2025-11-05 10:18:00'),
(22,'ow','/aʊ/',NULL,'2025-11-05 10:18:31','2025-11-05 10:18:31'),
(23,'ng','/ŋ/','ng在结尾发/ŋ/','2025-11-13 08:31:15','2025-11-13 08:31:15'),
(24,'ng','/ŋg/','ng在中间发/ŋg/','2025-11-13 08:31:38','2025-11-13 08:31:38');


/*Data for the table `words` */

insert  into `words`(`word_id`,`word`,`phonetic`,`meaning`,`pronunciation1`,`pronunciation2`,`pronunciation3`,`created_at`,`difficulty`,`is_mastered`,`notes`,`sentence`,`has_image`,`image_type`,`image_value`) values 
(1,'a','/ə/','一个',NULL,NULL,NULL,'2025-10-31 21:41:52',0,0,NULL,NULL,0,NULL,NULL),
(2,'hello','/həˈləʊ/','你好;(接电话或引起注意)喂','https://api.dictionaryapi.dev/media/pronunciations/en/hello-uk.mp3',NULL,NULL,'2025-10-31 22:50:25',0,0,NULL,NULL,0,NULL,NULL),
(4,'I','/aɪ/','我','https://api.dictionaryapi.dev/media/pronunciations/en/i-1-us.mp3',NULL,NULL,'2025-10-31 22:56:54',0,0,NULL,NULL,0,NULL,NULL),
(5,'am','/æm/','是(只和I连用)','https://api.dictionaryapi.dev/media/pronunciations/en/am-us.mp3',NULL,NULL,'2025-10-31 22:58:37',0,0,NULL,NULL,0,NULL,NULL),
(6,'I am','/aɪ//æm/','我是',NULL,NULL,NULL,'2025-10-31 22:59:18',0,0,NULL,NULL,0,NULL,NULL),
(7,'I\'m','/aɪm/','我是，I am的缩写',NULL,NULL,NULL,'2025-10-31 23:00:27',0,0,NULL,NULL,0,NULL,NULL),
(8,'hi','/haɪ/','你好，打招呼','https://api.dictionaryapi.dev/media/pronunciations/en/hi-1-uk.mp3',NULL,NULL,'2025-10-31 23:01:53',0,0,NULL,NULL,0,NULL,NULL),
(9,'Good morning!','/gʊd//mɔ:nɪŋ/','早上好！',NULL,NULL,NULL,'2025-11-04 09:19:55',0,0,NULL,NULL,0,NULL,NULL),
(10,'Good afternoon!','/gʊd//ɑːftənu:n/','下午好！',NULL,NULL,NULL,'2025-11-04 09:20:59',0,0,NULL,NULL,0,NULL,NULL),
(11,'Good evening!','/gʊd//i:vnɪŋ/','晚上好！',NULL,NULL,NULL,'2025-11-04 09:22:03',0,0,NULL,NULL,0,NULL,NULL),
(12,'woof','/wʊf/','汪','https://api.dictionaryapi.dev/media/pronunciations/en/woof-uk.mp3',NULL,NULL,'2025-11-04 09:24:18',0,0,NULL,NULL,0,NULL,NULL),
(13,'Good night!','/gʊd//naɪt/','晚安',NULL,NULL,NULL,'2025-11-04 16:28:24',0,0,'or组合发/ɔ:/',NULL,0,NULL,NULL),
(14,'morning','/mɔ:nɪŋ/','早上，上午','https://api.dictionaryapi.dev/media/pronunciations/en/morning-uk.mp3',NULL,NULL,'2025-11-04 09:27:04',0,0,NULL,NULL,0,NULL,NULL),
(15,'afternoon','/ɑːftənu:n/','下午','https://api.dictionaryapi.dev/media/pronunciations/en/afternoon-uk.mp3',NULL,NULL,'2025-11-04 16:28:11',0,0,'er组合发/ə/',NULL,0,NULL,NULL),
(16,'evening','/i:vnɪŋ/','晚上，傍晚','https://api.dictionaryapi.dev/media/pronunciations/en/evening-1-us.mp3',NULL,NULL,'2025-11-04 09:28:41',0,0,NULL,NULL,0,NULL,NULL),
(17,'night','/naɪt/','夜，夜晚','https://api.dictionaryapi.dev/media/pronunciations/en/night-uk.mp3',NULL,NULL,'2025-11-04 16:27:59',0,0,'igh组合发/aɪ/',NULL,0,NULL,NULL),
(18,'Miss','/mɪs/','小姐','https://api.dictionaryapi.dev/media/pronunciations/en/miss-us.mp3',NULL,NULL,'2025-11-04 09:29:56',0,0,NULL,NULL,0,NULL,NULL),
(19,'Miss Li','/mɪs//li:/','李小姐，李老师',NULL,NULL,NULL,'2025-11-04 09:30:58',0,0,NULL,NULL,0,NULL,NULL),
(20,'mum','/mʌm/','妈妈','https://api.dictionaryapi.dev/media/pronunciations/en/mum-au.mp3',NULL,NULL,'2025-11-04 09:31:29',0,0,NULL,NULL,0,NULL,NULL),
(21,'dad','/dæd/','爸爸','https://api.dictionaryapi.dev/media/pronunciations/en/dad-us.mp3',NULL,NULL,'2025-11-04 09:32:03',0,0,NULL,NULL,0,NULL,NULL),
(22,'this','/ðɪs/','这，这个','https://api.dictionaryapi.dev/media/pronunciations/en/this-us.mp3',NULL,NULL,'2025-11-04 16:27:31',0,0,'th组合发/ð/',NULL,0,NULL,NULL),
(23,'is','/ɪz/','是',NULL,NULL,NULL,'2025-11-04 09:42:11',0,0,NULL,NULL,0,NULL,NULL),
(24,'This is ...','/ðɪs//ɪz/','这是……',NULL,NULL,NULL,'2025-11-04 09:42:49',0,0,NULL,NULL,0,NULL,NULL),
(25,'Goodbye!','/gʊd\'baɪ/','再见！',NULL,NULL,NULL,'2025-11-04 09:44:47',0,0,NULL,NULL,0,NULL,NULL),
(26,'Mr','/mɪstə/','先生',NULL,NULL,NULL,'2025-11-04 09:45:18',0,0,NULL,NULL,0,NULL,NULL),
(27,'Mr Green','/mɪstə//gri:n/','格林先生，格林老师',NULL,NULL,NULL,'2025-11-04 09:45:47',0,0,NULL,NULL,0,NULL,NULL),
(28,'Is this ...?','/ɪz//ðɪs/','这是……吗？',NULL,NULL,NULL,'2025-11-04 09:46:23',0,0,NULL,NULL,0,NULL,NULL),
(30,'teddy','/tedɪ/','泰迪熊',NULL,NULL,NULL,'2025-11-04 09:47:30',0,0,NULL,NULL,0,NULL,NULL),
(31,'box','/bɒks/','盒子，箱子','https://api.dictionaryapi.dev/media/pronunciations/en/box-au.mp3',NULL,NULL,'2025-11-04 09:48:38',0,0,NULL,NULL,0,NULL,NULL),
(32,'yes','/jes/','是，对','https://api.dictionaryapi.dev/media/pronunciations/en/yes.mp3',NULL,NULL,'2025-11-04 09:49:17',0,0,NULL,NULL,0,NULL,NULL),
(33,'bag','/bæg/','包，袋','https://api.dictionaryapi.dev/media/pronunciations/en/bag-au.mp3',NULL,NULL,'2025-11-04 09:49:43',0,0,NULL,NULL,0,NULL,NULL),
(34,'no','/nəʊ/','不，不是，没有','https://api.dictionaryapi.dev/media/pronunciations/en/no-uk.mp3',NULL,NULL,'2025-11-04 09:50:11',0,0,NULL,NULL,0,NULL,NULL),
(35,'puppy','/pʌpɪ/','小狗','https://api.dictionaryapi.dev/media/pronunciations/en/puppy-us.mp3',NULL,NULL,'2025-11-04 09:50:47',0,0,NULL,NULL,0,NULL,NULL),
(36,'cherry','/tʃerɪ/','樱桃','https://api.dictionaryapi.dev/media/pronunciations/en/cherry-au.mp3',NULL,NULL,'2025-11-04 09:51:39',0,0,NULL,NULL,0,NULL,NULL),
(37,'please','/pli:z/','请','https://api.dictionaryapi.dev/media/pronunciations/en/please-uk.mp3',NULL,NULL,'2025-11-04 16:26:46',0,0,'ea组合发/i:/',NULL,0,NULL,NULL),
(38,'banana','/bə\'nɑːnə/','香蕉','https://api.dictionaryapi.dev/media/pronunciations/en/banana-uk.mp3',NULL,NULL,'2025-11-05 18:04:09',0,0,NULL,NULL,1,'iconfont','icon-xiangjiao'),
(39,'peach','/pi:tʃ/','桃子','https://api.dictionaryapi.dev/media/pronunciations/en/peach-us.mp3',NULL,NULL,'2025-11-04 16:26:28',0,0,'ea组合发/i:/',NULL,0,NULL,NULL),
(40,'grape','/greɪp/','葡萄','https://api.dictionaryapi.dev/media/pronunciations/en/grape-uk.mp3',NULL,NULL,'2025-11-04 16:18:32',0,0,'以不发音的e结尾，a就发/eɪ/',NULL,0,NULL,NULL),
(41,'OK.','/əʊkeɪ/','好的，行，可以',NULL,NULL,NULL,'2025-11-04 09:54:55',0,0,NULL,NULL,0,NULL,NULL),
(42,'Thank you.','/θæŋk//ju:/','谢谢你。',NULL,NULL,NULL,'2025-11-04 09:56:03',0,0,NULL,NULL,0,NULL,NULL),
(43,'look','/lʊk/','看',NULL,NULL,NULL,'2025-11-04 09:56:38',0,0,NULL,NULL,0,NULL,NULL),
(44,'look at','/lʊk//æt/','看',NULL,NULL,NULL,'2025-11-04 09:57:05',0,0,NULL,NULL,0,NULL,NULL),
(45,'my','/maɪ/','我的',NULL,NULL,NULL,'2025-11-04 09:57:34',0,0,NULL,NULL,0,NULL,NULL),
(46,'balloon','/bə\'lu:n/','气球','https://api.dictionaryapi.dev/media/pronunciations/en/balloon-us.mp3',NULL,NULL,'2025-11-04 16:21:13',0,0,'oo组合发/u:/',NULL,0,NULL,NULL),
(47,'pink','/pɪŋk/','粉色的','https://api.dictionaryapi.dev/media/pronunciations/en/pink-uk.mp3',NULL,NULL,'2025-11-04 09:58:49',0,0,NULL,NULL,0,NULL,NULL),
(48,'it\'s','/ɪts/','=it is 它是',NULL,NULL,NULL,'2025-11-04 09:59:31',0,0,NULL,NULL,0,NULL,NULL),
(49,'nice','/naɪs/','好的','https://api.dictionaryapi.dev/media/pronunciations/en/nice-us.mp3',NULL,NULL,'2025-11-04 16:26:03',0,0,'以不发音的e结尾，i就发/aɪ/',NULL,0,NULL,NULL),
(50,'red','/red/','红色的','https://api.dictionaryapi.dev/media/pronunciations/en/red-us.mp3',NULL,NULL,'2025-11-04 10:00:27',0,0,NULL,NULL,0,NULL,NULL),
(51,'blue','/blu:/','蓝色的','https://api.dictionaryapi.dev/media/pronunciations/en/blue-au.mp3',NULL,NULL,'2025-11-04 10:00:51',0,0,NULL,NULL,0,NULL,NULL),
(52,'green','/gri:n/','绿色的','https://api.dictionaryapi.dev/media/pronunciations/en/green-au.mp3',NULL,NULL,'2025-11-04 16:16:38',0,0,'ee组合发/i:/',NULL,0,NULL,NULL),
(54,'can','/kæn/','能，会','https://api.dictionaryapi.dev/media/pronunciations/en/can-1-us-stressed.mp3',NULL,NULL,'2025-11-04 10:02:25',0,0,NULL,NULL,0,NULL,NULL),
(55,'I can ...','/aɪ//kæn/','我会……',NULL,NULL,NULL,'2025-11-04 10:02:58',0,0,NULL,NULL,0,NULL,NULL),
(56,'dance','/dɑːns/','跳舞','https://api.dictionaryapi.dev/media/pronunciations/en/dance-uk.mp3',NULL,NULL,'2025-11-04 10:03:26',0,0,NULL,NULL,0,NULL,NULL),
(57,'robot','/rəʊbɒt/','机器人',NULL,NULL,NULL,'2025-11-04 10:04:29',0,0,NULL,NULL,0,NULL,NULL),
(58,'sing','/sɪŋ/','唱(歌)','https://api.dictionaryapi.dev/media/pronunciations/en/sing-uk.mp3',NULL,NULL,'2025-11-04 16:16:12',0,0,'ng组合发/ŋ/',NULL,0,NULL,NULL),
(59,'draw','/drɔ:/','画',NULL,NULL,NULL,'2025-11-04 10:24:33',0,0,NULL,NULL,0,NULL,NULL),
(60,'Great!','/greɪt/','太好了！太棒了！','https://api.dictionaryapi.dev/media/pronunciations/en/great-us.mp3',NULL,NULL,'2025-11-04 10:25:08',0,0,NULL,NULL,0,NULL,NULL),
(61,'cook','/kʊk/','烹饪，做饭',NULL,NULL,NULL,'2025-11-04 11:22:22',0,0,'oo组合发/u:/','I can cook.',0,NULL,NULL),
(62,'Wow!','/waʊ/','哇！','https://api.dictionaryapi.dev/media/pronunciations/en/wow-1-us.mp3',NULL,NULL,'2025-11-04 16:19:42',0,0,'ow组合发/aʊ/\n类似的还有cow ，how，down',NULL,0,NULL,NULL),
(63,'put on','/pʊt//ɒn/','穿上，戴上',NULL,NULL,NULL,'2025-11-04 10:26:57',0,0,NULL,NULL,0,NULL,NULL),
(64,'your','/jɔ:/','你的',NULL,NULL,NULL,'2025-11-04 10:27:29',0,0,NULL,NULL,0,NULL,NULL),
(65,'coat','/kəʊt/','外套，外衣','https://api.dictionaryapi.dev/media/pronunciations/en/coat-uk.mp3',NULL,NULL,'2025-11-04 10:27:58',0,0,NULL,NULL,0,NULL,NULL),
(66,'oh','/əʊ/','哦，啊','https://api.dictionaryapi.dev/media/pronunciations/en/oh-uk.mp3',NULL,NULL,'2025-11-04 10:28:41',0,0,NULL,NULL,0,NULL,NULL),
(67,'cold','/kəʊld/','冷的，寒冷的','https://api.dictionaryapi.dev/media/pronunciations/en/cold-uk.mp3',NULL,NULL,'2025-11-04 10:29:18',0,0,NULL,NULL,0,NULL,NULL),
(68,'scarf','/skɑːf/','围巾','https://api.dictionaryapi.dev/media/pronunciations/en/scarf-au.mp3',NULL,NULL,'2025-11-04 16:09:59',0,0,'ar组合发/ɑː/',NULL,0,NULL,NULL),
(69,'beanie','/bi:nɪ/','小便帽','https://api.dictionaryapi.dev/media/pronunciations/en/beanie-us.mp3',NULL,NULL,'2025-11-04 16:09:30',0,0,'ea组合发/i:/',NULL,0,NULL,NULL),
(70,'sweater','/swetə/','毛衣','https://api.dictionaryapi.dev/media/pronunciations/en/sweater-us.mp3',NULL,NULL,'2025-11-04 11:24:06',0,0,'er组合发/ə/',NULL,0,NULL,NULL),
(71,'let\'s','/lets/','=let us，让我们',NULL,NULL,NULL,'2025-11-04 19:32:22',0,0,NULL,'Let\'s jump.',0,NULL,NULL),
(72,'count','/kaʊnt/','数数','https://api.dictionaryapi.dev/media/pronunciations/en/count-us.mp3',NULL,NULL,'2025-11-04 19:34:24',0,0,'ou组合发/aʊ/',NULL,0,NULL,NULL),
(73,'cool','/ku:l/','酷！太棒了','https://api.dictionaryapi.dev/media/pronunciations/en/cool-uk.mp3',NULL,NULL,'2025-11-04 19:35:29',0,0,'oo组合发/u:/',NULL,0,NULL,NULL),
(74,'how many','/həʊ//mænɪ/','几个，多少',NULL,NULL,NULL,'2025-11-04 19:36:59',0,0,'How many放在开头引导疑问句，意思是问什么东西有多少个？','How many apples?',0,NULL,NULL),
(75,'marble','/mɑːbl/','玻璃球，玻璃弹珠','https://api.dictionaryapi.dev/media/pronunciations/en/marble-us.mp3',NULL,NULL,'2025-11-04 19:37:54',0,0,NULL,NULL,0,NULL,NULL),
(76,'one','/wʌn/','一','https://api.dictionaryapi.dev/media/pronunciations/en/one-us.mp3',NULL,NULL,'2025-11-04 19:38:39',0,0,NULL,NULL,0,NULL,NULL),
(77,'two','/tu:/','二','https://api.dictionaryapi.dev/media/pronunciations/en/two-uk.mp3',NULL,NULL,'2025-11-04 19:39:02',0,0,NULL,NULL,0,NULL,NULL),
(78,'three','/θri:/','三','https://api.dictionaryapi.dev/media/pronunciations/en/three-us.mp3',NULL,NULL,'2025-11-04 19:40:12',0,0,'th组合发/θ/\nee组合发/i:/',NULL,0,NULL,NULL),
(79,'four','/fɔ:/','四','https://api.dictionaryapi.dev/media/pronunciations/en/four-au.mp3',NULL,NULL,'2025-11-04 19:40:52',0,0,'our组合发/ɔ:/',NULL,0,NULL,NULL),
(80,'five','/faɪv/','五','https://api.dictionaryapi.dev/media/pronunciations/en/five-us.mp3',NULL,NULL,'2025-11-04 19:41:37',0,0,'以不发音的e结尾i就发/aɪ/',NULL,0,NULL,NULL),
(81,'yellow','/jeləʊ/','黄色','https://api.dictionaryapi.dev/media/pronunciations/en/yellow-uk.mp3',NULL,NULL,'2025-11-04 19:42:26',0,0,NULL,NULL,0,NULL,NULL),
(82,'like','/laɪk/','喜欢','https://api.dictionaryapi.dev/media/pronunciations/en/like-us.mp3',NULL,NULL,'2025-11-04 19:43:19',0,0,NULL,'I like apples.',0,NULL,NULL),
(83,'carrot','/kærət/','胡萝卜','https://api.dictionaryapi.dev/media/pronunciations/en/carrot-us.mp3',NULL,NULL,'2025-11-04 19:43:58',0,0,NULL,NULL,0,NULL,NULL),
(84,'Me too.','/mi://tu:/','我也是。',NULL,NULL,NULL,'2025-11-04 19:44:52',0,0,'别人说什么，你说“我也是”表示跟他一样',NULL,0,NULL,NULL),
(85,'onion','/ʌnjəŋ/','洋葱','https://api.dictionaryapi.dev/media/pronunciations/en/onion-uk.mp3',NULL,NULL,'2025-11-04 19:46:17',0,0,NULL,NULL,0,NULL,NULL),
(86,'No, thanks.','/nəʊ//θæŋks/','不要了，谢谢。',NULL,NULL,NULL,'2025-11-04 19:48:26',0,0,'别人问你要不要吃什么的东西，你不想吃可以说：No,thanks.','-A banana?\n-No,thanks.',0,NULL,NULL),
(87,'pea','/pi:/','豌豆，豌豆粒','https://api.dictionaryapi.dev/media/pronunciations/en/pea-us.mp3',NULL,NULL,'2025-11-04 19:49:08',0,0,'ea组合发/i:/',NULL,0,NULL,NULL),
(88,'Yes,please.','/jes//pli:z/','好的，谢谢。',NULL,NULL,NULL,'2025-11-04 19:50:27',0,0,'当别人问你要不要吃一样东西时，如果你想吃可以说：Yes,please.','-A banana?\n-Yes,please.',0,NULL,NULL),
(89,'we','/wi:/','我们','https://api.dictionaryapi.dev/media/pronunciations/en/we-uk.mp3',NULL,NULL,'2025-11-04 19:51:44',0,0,'我是I,我们是we，你是you，他是he，她是she，它是it，他们是they','We are family.我们是一家人。',0,NULL,NULL),
(90,'all','/ɔ:l/','全部，全体','https://api.dictionaryapi.dev/media/pronunciations/en/all-us.mp3',NULL,NULL,'2025-11-04 19:52:36',0,0,NULL,'We all like onions.',0,NULL,NULL),
(91,'pepper','/pepə/','甜椒，灯笼椒','https://api.dictionaryapi.dev/media/pronunciations/en/pepper-uk.mp3',NULL,NULL,'2025-11-04 19:53:11',0,0,NULL,NULL,0,NULL,NULL),
(92,'pencil','/pensəl/','铅笔','https://api.dictionaryapi.dev/media/pronunciations/en/pencil-us.mp3',NULL,NULL,'2025-11-04 19:53:46',0,0,NULL,NULL,0,NULL,NULL),
(93,'Ouch!','/aʊtʃ/','(表示突然的疼痛)哎哟！','https://api.dictionaryapi.dev/media/pronunciations/en/ouch-1.mp3',NULL,NULL,'2025-11-04 19:54:35',0,0,NULL,NULL,0,NULL,NULL),
(94,'I\'m sorry.','/aɪm//sɒrɪ/','对不起。请原谅。','https://api.dictionaryapi.dev/media/pronunciations/en/sorry-ca.mp3',NULL,NULL,'2025-11-04 19:55:35',0,0,NULL,NULL,0,NULL,NULL),
(95,'That\'s OK.','/ðæts//əʊkeɪ/','没关系。',NULL,NULL,NULL,'2025-11-04 19:57:05',0,0,'别人对你说I\'m sorry.想你道歉的时候你可以说：That\'s OK.表示没关系。','-I\'m sorry.\n-That\'s OK.',0,NULL,NULL),
(96,'book','/bʊk/','书',NULL,NULL,NULL,'2025-11-04 19:59:41',0,0,'oo组合发/ʊ/\nbook, look,good',NULL,0,NULL,NULL),
(97,'ruler','/ru:lə/','直尺','https://api.dictionaryapi.dev/media/pronunciations/en/ruler-us.mp3',NULL,NULL,'2025-11-04 20:00:39',0,0,'er组合发/ə/',NULL,0,NULL,NULL),
(98,'rubber','/rʌbə/','橡皮','https://api.dictionaryapi.dev/media/pronunciations/en/rubber-au.mp3',NULL,NULL,'2025-11-04 20:01:39',0,0,NULL,NULL,0,NULL,NULL),
(99,'spring','/sprɪŋ/','春天，春季','https://api.dictionaryapi.dev/media/pronunciations/en/spring-au.mp3',NULL,NULL,'2025-11-04 20:02:26',0,0,NULL,NULL,0,NULL,NULL),
(100,'the','/ðə/','(指代人或事物)这个；那个；这些；那些',NULL,NULL,NULL,'2025-11-04 20:04:16',0,0,NULL,NULL,0,NULL,NULL),
(101,'tree','/tri:/','树','https://api.dictionaryapi.dev/media/pronunciations/en/tree-uk.mp3',NULL,NULL,'2025-11-04 20:04:58',0,0,NULL,NULL,0,NULL,NULL),
(102,'they\'re','/ðeə/','=they are 他们是，她们是，它们是',NULL,NULL,NULL,'2025-11-04 20:07:31',0,0,NULL,'They\'re my friends.',0,NULL,NULL),
(103,'flower','/flaʊə/','花','https://api.dictionaryapi.dev/media/pronunciations/en/flower-1-uk.mp3',NULL,NULL,'2025-11-04 20:08:03',0,0,NULL,NULL,0,NULL,NULL),
(104,'beautiful','/ˈbjuːtɪfl/','美丽的，漂亮的','https://api.dictionaryapi.dev/media/pronunciations/en/beautiful-uk.mp3',NULL,NULL,'2025-11-04 20:09:13',0,0,NULL,NULL,0,NULL,NULL),
(105,'bird','/bɜːd/','鸟','https://api.dictionaryapi.dev/media/pronunciations/en/bird-us.mp3',NULL,NULL,'2025-11-04 20:09:50',0,0,NULL,NULL,0,NULL,NULL),
(106,'happy','/hæpɪ/','快乐的','https://api.dictionaryapi.dev/media/pronunciations/en/happy-au.mp3',NULL,NULL,'2025-11-04 20:10:34',0,0,NULL,'I\'m happy.',0,NULL,NULL),
(107,'kite','/kaɪt/','风筝',NULL,NULL,NULL,'2025-11-04 20:11:05',0,0,NULL,NULL,0,NULL,NULL),
(108,'colourful','/kʌləfl/','五彩缤纷的',NULL,NULL,NULL,'2025-11-04 20:11:55',0,0,NULL,NULL,0,NULL,NULL),
(109,'what\'s','/wɒts/','=what is 是什么',NULL,NULL,NULL,'2025-11-04 20:13:11',0,0,'用在开头引导疑问句，问一个东西是什么','What\'s this?',0,NULL,NULL),
(110,'What\'s this?','/wɒts//ðɪs/','这是什么？',NULL,NULL,NULL,'2025-11-04 20:13:47',0,0,NULL,NULL,0,NULL,NULL),
(111,'ladybird','/ˈleɪdibɜːd/','瓢虫','https://api.dictionaryapi.dev/media/pronunciations/en/ladybird-us.mp3',NULL,NULL,'2025-11-04 20:14:46',0,0,'ir组合发/ɜː/',NULL,0,NULL,NULL),
(112,'cute','/kju:t/','可爱的，漂亮的','https://api.dictionaryapi.dev/media/pronunciations/en/cute-us.mp3',NULL,NULL,'2025-11-04 20:15:45',0,0,'以不发音的e结尾u就发/ju:/',NULL,0,NULL,NULL),
(113,'cicada','/sɪkɑːdə/','蝉，知了',NULL,NULL,NULL,'2025-11-04 20:16:44',0,0,NULL,NULL,0,NULL,NULL),
(114,'butterfly','/bʌtəflaɪ/','蝴蝶',NULL,NULL,NULL,'2025-11-04 20:17:21',0,0,'er组合发/ə/',NULL,0,NULL,NULL),
(115,'dragonfly','/drægənflaɪ/','蜻蜓','https://api.dictionaryapi.dev/media/pronunciations/en/dragonfly-us.mp3',NULL,NULL,'2025-11-04 20:17:58',0,0,NULL,NULL,0,NULL,NULL),
(116,'Are you ready?','/ɑː//ju://redɪ/','你们准备好了吗？',NULL,NULL,NULL,'2025-11-04 20:18:58',0,0,NULL,'-Are you ready?\n-Yes.\n-Let\'s run.',0,NULL,NULL),
(117,'run','/rʌn/','跑','https://api.dictionaryapi.dev/media/pronunciations/en/run-au.mp3',NULL,NULL,'2025-11-04 20:19:37',0,0,NULL,NULL,0,NULL,NULL),
(118,'jump','/dʒʌmp/','跳，跳跃','https://api.dictionaryapi.dev/media/pronunciations/en/jump-us.mp3',NULL,NULL,'2025-11-04 20:20:11',0,0,NULL,NULL,0,NULL,NULL),
(119,'Well done!','/wel//dʌn/','干得好！',NULL,NULL,NULL,'2025-11-04 20:20:37',0,0,NULL,NULL,0,NULL,NULL),
(120,'hop','/hɒp/','单脚跳','https://api.dictionaryapi.dev/media/pronunciations/en/hop-au.mp3',NULL,NULL,'2025-11-04 20:21:14',0,0,NULL,NULL,0,NULL,NULL),
(121,'walk','/wɔ:k/','走，步行','https://api.dictionaryapi.dev/media/pronunciations/en/walk-uk.mp3',NULL,NULL,'2025-11-04 20:22:11',0,0,'al组合发/ɔ:/\ntalk',NULL,0,NULL,NULL),
(122,'What\'s that?','/wɒts//ðæt/','那是什么？',NULL,NULL,NULL,'2025-11-04 20:22:51',0,0,NULL,NULL,0,NULL,NULL),
(123,'Shh!','/ʃ/','(用以让别人安静)嘘！',NULL,NULL,NULL,'2025-11-04 20:23:29',0,0,NULL,NULL,0,NULL,NULL),
(124,'pig','/pɪg/','猪','https://api.dictionaryapi.dev/media/pronunciations/en/pig-1-au.mp3',NULL,NULL,'2025-11-06 09:43:11',0,0,NULL,NULL,1,'iconfont','icon-a-xiaozhuzhu_huaban1'),
(125,'Baa!','/bɑː/','(羊叫声)咩！','https://api.dictionaryapi.dev/media/pronunciations/en/baa-1-us.mp3',NULL,NULL,'2025-11-04 20:24:32',0,0,NULL,NULL,0,NULL,NULL),
(126,'lamb','/læm/','羊羔，小羊','https://api.dictionaryapi.dev/media/pronunciations/en/lamb-us.mp3',NULL,NULL,'2025-11-04 20:25:08',0,0,NULL,NULL,0,NULL,NULL),
(127,'Quack!','/kwæk/','(鸭子叫声)噶！',NULL,NULL,NULL,'2025-11-04 20:25:39',0,0,NULL,NULL,0,NULL,NULL),
(128,'duck','/dʌk/','鸭子','https://api.dictionaryapi.dev/media/pronunciations/en/duck-au.mp3',NULL,NULL,'2025-11-13 11:16:55',0,0,'ck组合发/k/','There is a duck in the water.',1,'url','http://t5a8n98no.hd-bkt.clouddn.com/20251105192153.png'),
(129,'cow','/kaʊ/','奶牛','https://api.dictionaryapi.dev/media/pronunciations/en/cow-uk.mp3',NULL,NULL,'2025-11-05 14:52:25',0,0,'ow组合发/aʊ/',NULL,0,NULL,NULL),
(130,'in','/ɪn/','在……内，在……里','https://api.dictionaryapi.dev/media/pronunciations/en/in-au-stressed.mp3',NULL,NULL,'2025-11-05 19:00:42',0,0,NULL,'in the box',1,'iconfont','icon-yudingyishitu'),
(131,'bottle','/bɒtl/','瓶子','https://api.dictionaryapi.dev/media/pronunciations/en/bottle-uk.mp3',NULL,NULL,'2025-11-05 19:03:25',0,0,NULL,NULL,1,'iconfont','icon-pingzi'),
(132,'hankie','/hænkɪ/','手帕，纸巾',NULL,NULL,NULL,'2025-11-05 19:06:33',0,0,NULL,NULL,1,'iconfont','icon-shoupa'),
(133,'and','/ænd/','和，同，与','https://api.dictionaryapi.dev/media/pronunciations/en/and-us.mp3',NULL,NULL,'2025-11-05 19:09:19',0,0,NULL,'Liu Tao and Wang Bing are good friends.',0,NULL,NULL),
(134,'sticker','/stɪkə/','贴纸','https://api.dictionaryapi.dev/media/pronunciations/en/sticker-us.mp3',NULL,NULL,'2025-11-05 19:11:14',0,0,NULL,NULL,1,'iconfont','icon-caigoudayintiezhi'),
(135,'yo-yo','/jəʊjəʊ/','溜溜球','https://api.dictionaryapi.dev/media/pronunciations/en/yo-yo-us.mp3',NULL,NULL,'2025-11-06 14:17:23',0,0,NULL,NULL,1,'url','http://t5a8n98no.hd-bkt.clouddn.com/20251106141636.png');

/*Data for the table `word_pronunciation_rules` */

insert  into `word_pronunciation_rules`(`id`,`word_id`,`pronunciation_rule_id`,`position_in_word`,`created_at`) values 
(1,129,22,NULL,'2025-11-05 10:34:00'),
(3,128,20,NULL,'2025-11-05 14:55:25');


/*Data for the table `dictionary_words` */

insert  into `dictionary_words`(`relation_id`,`dictionary_id`,`word_id`,`difficulty`,`is_mastered`,`notes`,`created_at`) values 
(1,2,70,NULL,NULL,NULL,'2025-11-04 11:29:47'),
(2,2,67,NULL,NULL,NULL,'2025-11-04 11:56:59'),
(3,2,69,NULL,NULL,NULL,'2025-11-04 11:57:43'),
(4,2,68,NULL,NULL,NULL,'2025-11-04 11:57:43'),
(5,2,66,NULL,NULL,NULL,'2025-11-04 11:57:43'),
(6,2,65,NULL,NULL,NULL,'2025-11-04 11:57:43'),
(7,2,64,NULL,NULL,NULL,'2025-11-04 11:57:43'),
(8,2,63,NULL,NULL,NULL,'2025-11-04 11:57:43'),
(9,2,62,NULL,NULL,NULL,'2025-11-04 11:57:43'),
(10,2,61,NULL,NULL,NULL,'2025-11-04 11:57:43'),
(11,2,60,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(12,2,59,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(13,2,58,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(14,2,57,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(15,2,56,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(16,2,55,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(17,2,54,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(18,2,52,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(19,2,51,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(20,2,50,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(21,2,49,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(22,2,48,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(23,2,47,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(24,2,46,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(25,2,45,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(26,2,44,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(27,2,43,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(28,2,42,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(29,2,41,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(30,2,40,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(31,2,39,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(32,2,38,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(33,2,37,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(34,2,36,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(35,2,35,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(36,2,34,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(37,2,33,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(38,2,32,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(39,2,31,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(40,2,30,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(41,2,28,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(42,2,27,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(43,2,26,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(44,2,25,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(45,2,24,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(46,2,23,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(47,2,22,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(48,2,21,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(49,2,20,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(50,2,19,NULL,NULL,NULL,'2025-11-04 11:58:08'),
(51,2,18,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(52,2,17,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(53,2,16,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(54,2,15,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(55,2,14,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(56,2,13,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(57,2,12,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(58,2,11,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(59,2,10,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(60,2,9,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(61,2,8,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(62,2,7,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(63,2,6,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(64,2,5,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(65,2,4,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(66,2,2,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(67,2,1,NULL,NULL,NULL,'2025-11-04 11:58:19'),
(69,3,71,NULL,NULL,NULL,'2025-11-05 18:54:05'),
(70,3,72,NULL,NULL,NULL,'2025-11-05 18:54:05'),
(71,3,73,NULL,NULL,NULL,'2025-11-05 18:54:05'),
(72,3,74,NULL,NULL,NULL,'2025-11-05 18:54:05'),
(73,3,75,NULL,NULL,NULL,'2025-11-05 18:54:05'),
(74,3,76,NULL,NULL,NULL,'2025-11-05 18:54:05'),
(75,3,77,NULL,NULL,NULL,'2025-11-05 18:54:05'),
(76,3,78,NULL,NULL,NULL,'2025-11-05 18:54:05'),
(77,3,79,NULL,NULL,NULL,'2025-11-05 18:54:05'),
(78,3,129,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(79,3,128,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(80,3,127,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(81,3,126,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(82,3,125,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(83,3,124,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(84,3,123,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(85,3,122,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(86,3,121,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(87,3,120,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(88,3,119,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(89,3,118,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(90,3,117,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(91,3,116,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(92,3,115,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(93,3,114,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(94,3,113,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(95,3,112,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(96,3,111,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(97,3,110,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(98,3,109,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(99,3,108,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(100,3,107,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(101,3,106,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(102,3,105,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(103,3,104,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(104,3,103,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(105,3,102,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(106,3,101,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(107,3,100,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(108,3,99,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(109,3,98,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(110,3,97,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(111,3,96,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(112,3,95,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(113,3,94,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(114,3,93,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(115,3,92,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(116,3,91,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(117,3,90,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(118,3,89,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(119,3,88,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(120,3,87,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(121,3,86,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(122,3,85,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(123,3,84,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(124,3,83,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(125,3,82,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(126,3,81,NULL,NULL,NULL,'2025-11-05 18:54:20'),
(127,3,80,NULL,NULL,NULL,'2025-11-05 18:54:20');


/*Data for the table `word_plans` */

insert  into `word_plans`(`id`,`name`,`description`,`mode`,`status`,`target_word_count`,`daily_word_count`,`created_at`,`updated_at`) values 
(1,'第一次计划','测试学习计划是否可用','flash-card','inactive',5,5,'2025-11-13 08:44:10','2025-11-13 08:44:10'),
(2,'第二次计划','111','flash-card','inactive',10,5,'2025-11-13 09:15:30','2025-11-13 09:15:30'),
(3,'测试拼写','测试拼写模式','flash-card','inactive',5,5,'2025-11-13 10:17:09','2025-11-13 10:17:09'),
(4,'拼写','拼写','spelling','inactive',10,5,'2025-11-13 10:39:10','2025-11-13 10:39:10');

/*Data for the table `sentences` */

insert  into `sentences`(`id`,`text`,`created_at`,`updated_at`) values 
(2,'Hello, world! How are you today?','2025-11-16 18:39:17','2025-11-16 18:39:17'),
(4,'The quick brown fox jumps over the lazy dog.','2025-11-16 18:41:31','2025-11-16 18:41:31'),
(5,'This is a duck.','2025-11-18 14:25:11','2025-11-18 14:25:11');

/*Data for the table `sentence_tokens` */

insert  into `sentence_tokens`(`id`,`sentence_id`,`position`,`token_text`,`token_type`,`word_id`,`created_at`) values 
(1,2,0,'Hello','word',NULL,'2025-11-16 18:39:17'),
(2,2,1,',','punctuation',NULL,'2025-11-16 18:39:17'),
(3,2,2,'world','word',NULL,'2025-11-16 18:39:17'),
(4,2,3,'!','punctuation',NULL,'2025-11-16 18:39:17'),
(5,2,4,'How','word',NULL,'2025-11-16 18:39:17'),
(6,2,5,'are','word',NULL,'2025-11-16 18:39:17'),
(7,2,6,'you','word',NULL,'2025-11-16 18:39:17'),
(8,2,7,'today','word',NULL,'2025-11-16 18:39:17'),
(9,2,8,'?','punctuation',NULL,'2025-11-16 18:39:17'),
(10,4,0,'The','word',NULL,'2025-11-16 18:41:31'),
(11,4,1,'quick','word',NULL,'2025-11-16 18:41:31'),
(12,4,2,'brown','word',NULL,'2025-11-16 18:41:31'),
(13,4,3,'fox','word',NULL,'2025-11-16 18:41:31'),
(14,4,4,'jumps','word',NULL,'2025-11-16 18:41:31'),
(15,4,5,'over','word',NULL,'2025-11-16 18:41:31'),
(16,4,6,'the','word',NULL,'2025-11-16 18:41:31'),
(17,4,7,'lazy','word',NULL,'2025-11-16 18:41:31'),
(18,4,8,'dog','word',NULL,'2025-11-16 18:41:31'),
(19,4,9,'.','punctuation',NULL,'2025-11-16 18:41:31'),
(20,5,0,'This','word',NULL,'2025-11-18 14:25:12'),
(21,5,1,'is','word',NULL,'2025-11-18 14:25:12'),
(22,5,2,'a','word',NULL,'2025-11-18 14:25:12'),
(23,5,3,'duck','word',NULL,'2025-11-18 14:25:12'),
(24,5,4,'.','punctuation',NULL,'2025-11-18 14:25:12');

/*Data for the table `error_words` */

insert  into `error_words`(`id`,`plan_id`,`word_id`,`error_count`,`last_error_at`) values 
(1,2,134,4,'2025-11-21 17:27:33'),
(6,4,128,4,'2025-11-13 12:02:22'),
(7,4,131,3,'2025-11-13 11:48:20'),
(8,3,18,10,'2025-11-21 17:28:33'),
(13,3,17,1,'2025-11-21 13:00:36'),
(16,2,135,2,'2025-11-21 13:14:17');

/*Data for the table `learning_progress` */

insert  into `learning_progress`(`id`,`plan_id`,`total_words`,`learned_words`,`correct_words`,`error_words`,`last_studied_at`) values 
(1,1,5,5,5,0,'2025-11-13 10:31:14'),
(2,2,10,11,5,6,'2025-11-21 17:27:32'),
(6,3,5,16,5,11,'2025-11-21 17:28:33'),
(14,4,2,21,10,11,'2025-11-18 19:15:17');

/*Data for the table `learning_records` */

insert  into `learning_records`(`id`,`plan_id`,`word_id`,`user_answer`,`is_correct`,`attempts`,`learned_at`) values 
(5,2,128,'duck',1,1,'2025-11-13 10:07:04'),
(6,2,135,NULL,1,1,'2025-11-13 10:08:33'),
(7,2,134,NULL,0,1,'2025-11-13 10:09:17'),
(8,3,18,NULL,1,1,'2025-11-13 10:17:47'),
(9,1,128,NULL,1,1,'2025-11-13 10:30:38'),
(10,1,111,NULL,1,1,'2025-11-13 10:30:46'),
(11,1,92,NULL,1,1,'2025-11-13 10:30:54'),
(12,1,129,NULL,1,1,'2025-11-13 10:31:03'),
(13,1,126,NULL,1,1,'2025-11-13 10:31:14'),
(14,3,18,NULL,1,1,'2025-11-13 10:31:43'),
(24,4,131,'bottle',1,1,'2025-11-13 11:17:49'),
(25,4,128,'dyrc',0,1,'2025-11-13 11:17:57'),
(26,4,131,'botxle',0,1,'2025-11-13 11:43:17'),
(27,4,131,'bottle',1,1,'2025-11-13 11:43:28'),
(28,4,128,'dubs',0,1,'2025-11-13 11:43:35'),
(29,4,131,'tsotqn',0,1,'2025-11-13 11:48:10'),
(30,4,131,'botjle',0,1,'2025-11-13 11:48:19'),
(31,4,131,'bottle',1,1,'2025-11-13 11:48:29'),
(32,4,128,'ykuc',0,1,'2025-11-13 11:48:33'),
(33,4,128,'kocv',0,1,'2025-11-13 12:02:22'),
(34,4,128,'duck',1,1,'2025-11-13 12:02:37'),
(35,4,131,'bottle',1,1,'2025-11-18 19:15:17'),
(36,3,18,NULL,0,1,'2025-11-18 19:15:33'),
(37,3,18,NULL,1,1,'2025-11-18 19:15:37'),
(38,3,17,NULL,1,1,'2025-11-18 19:15:43'),
(39,3,18,NULL,0,1,'2025-11-21 12:32:07'),
(40,3,17,NULL,1,1,'2025-11-21 12:32:21'),
(41,3,18,NULL,0,1,'2025-11-21 12:44:13'),
(42,3,18,NULL,0,1,'2025-11-21 12:50:37'),
(43,3,18,NULL,0,1,'2025-11-21 12:56:04'),
(44,3,17,NULL,0,1,'2025-11-21 13:00:36'),
(45,3,18,NULL,0,1,'2025-11-21 13:04:28'),
(46,3,18,NULL,0,1,'2025-11-21 13:08:41'),
(47,2,135,NULL,0,1,'2025-11-21 13:09:29'),
(48,2,135,NULL,1,1,'2025-11-21 13:11:39'),
(49,2,134,NULL,0,1,'2025-11-21 13:11:53'),
(50,2,134,NULL,0,1,'2025-11-21 13:12:06'),
(51,2,135,NULL,0,1,'2025-11-21 13:14:17'),
(52,2,135,NULL,1,1,'2025-11-21 13:14:29'),
(53,3,18,NULL,0,1,'2025-11-21 13:14:59'),
(54,2,135,NULL,1,1,'2025-11-21 17:27:26'),
(55,2,134,NULL,0,1,'2025-11-21 17:27:32'),
(56,3,18,NULL,0,1,'2025-11-21 17:28:26'),
(57,3,18,NULL,0,1,'2025-11-21 17:28:33');

/*Data for the table `word_plan_words` */

insert  into `word_plan_words`(`id`,`plan_id`,`word_id`,`order_index`,`added_at`) values 
(1,1,128,0,'2025-11-13 08:44:10'),
(2,1,111,1,'2025-11-13 08:44:10'),
(3,1,92,2,'2025-11-13 08:44:10'),
(4,1,129,3,'2025-11-13 08:44:10'),
(5,1,126,4,'2025-11-13 08:44:10'),
(6,2,135,0,'2025-11-13 09:15:30'),
(7,2,134,1,'2025-11-13 09:15:30'),
(8,2,133,2,'2025-11-13 09:15:30'),
(9,2,132,3,'2025-11-13 09:15:30'),
(10,2,131,4,'2025-11-13 09:15:30'),
(11,2,130,5,'2025-11-13 09:15:30'),
(12,2,129,6,'2025-11-13 09:15:30'),
(13,2,128,7,'2025-11-13 09:15:30'),
(14,2,127,8,'2025-11-13 09:15:30'),
(15,2,126,9,'2025-11-13 09:15:30'),
(16,3,18,0,'2025-11-13 10:17:09'),
(17,3,17,1,'2025-11-13 10:17:09'),
(18,3,16,2,'2025-11-13 10:17:09'),
(19,3,15,3,'2025-11-13 10:17:09'),
(20,3,14,4,'2025-11-13 10:17:09'),
(25,4,131,4,'2025-11-13 10:39:10'),
(26,4,128,5,'2025-11-13 11:17:38');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;



