/*
SQLyog Ultimate v12.5.0 (64 bit)
MySQL - 5.7.44 : Database - blog_app
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`blog_app` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `blog_app`;

/*Table structure for table `media` */

DROP TABLE IF EXISTS `media`;

CREATE TABLE `media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` enum('local','aliyun_oss','qiniu','cos','s3') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local',
  `mime_type` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size_bytes` int(10) unsigned DEFAULT NULL,
  `width` int(10) unsigned DEFAULT NULL,
  `height` int(10) unsigned DEFAULT NULL,
  `created_by_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_media_user` (`created_by_user_id`),
  CONSTRAINT `fk_media_user` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `media` */

/*Table structure for table `post_revisions` */

DROP TABLE IF EXISTS `post_revisions`;

CREATE TABLE `post_revisions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) unsigned NOT NULL,
  `editor_user_id` bigint(20) unsigned DEFAULT NULL,
  `content_md` longtext COLLATE utf8mb4_unicode_ci,
  `content_html` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_post_revisions_post` (`post_id`),
  KEY `fk_post_revisions_editor` (`editor_user_id`),
  CONSTRAINT `fk_post_revisions_editor` FOREIGN KEY (`editor_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_post_revisions_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `post_revisions` */

insert  into `post_revisions`(`id`,`post_id`,`editor_user_id`,`content_md`,`content_html`,`created_at`) values 
(1,2,NULL,NULL,'<ul><li><p>fdf</p></li><li><p>fdf</p></li><li><p><code>fdfdfd</code></p></li><li><p><code>fdfdfdfddfdf</code></p></li><li><p><code>测试编辑</code></p></li><li><p><code>测试历史</code></p></li></ul><p></p>','2025-10-29 17:14:24'),
(2,2,NULL,NULL,'<ul><li><p>fdf</p></li><li><p>fdf</p></li><li><p><code>fdfdfd</code></p></li><li><p><code>fdfdfdfddfdf</code></p></li><li><p><code>测试编辑</code></p></li><li><p>测试历史</p></li></ul><p></p>','2025-10-29 17:14:29'),
(3,2,NULL,NULL,'<ul><li><p>fdf</p></li><li><p>fdf</p></li><li><p><code>fdfdfd</code></p></li><li><p><code>fdfdfdfddfdf</code></p></li><li><p><code>测试编辑</code></p></li><li><p>测试历史</p></li></ul><p></p>','2025-10-29 17:14:30'),
(4,2,NULL,NULL,'<ul><li><p>fdf</p></li><li><p>fdf</p></li><li><p><code>fdfdfd</code></p></li><li><p><code>fdfdfdfddfdf</code></p></li><li><p><code>测试编辑</code></p></li><li><p>测试历史</p></li></ul><p></p><p>$$E=mc^2$$</p><p></p>','2025-10-29 17:25:03'),
(5,2,NULL,NULL,'<ul><li><p>fdf</p></li><li><p>fdf</p></li><li><p><code>fdfdfd</code></p></li><li><p><code>fdfdfdfddfdf</code></p></li><li><p><code>测试编辑</code></p></li><li><p>测试历史</p></li></ul><p></p><p>$$E=mc^2$$</p><p></p>','2025-10-29 17:29:44'),
(6,2,NULL,NULL,'<ul><li><p>fdf</p></li><li><p>fdf</p></li><li><p><code>fdfdfd</code></p></li><li><p><code>fdfdfdfddfdf</code></p></li><li><p><code>测试编辑</code></p></li><li><p>测试历史</p></li></ul><p></p><p>$$E=mc^2$$</p><p></p>','2025-10-29 17:30:58'),
(7,2,NULL,NULL,'<ul><li><p>fdf</p></li><li><p>fdf</p></li><li><p><code>fdfdfd</code></p></li><li><p><code>fdfdfdfddfdf</code></p></li><li><p><code>测试编辑</code></p></li><li><p>测试历史</p></li></ul><p></p><p>$$E=mc^2$$</p>','2025-10-29 17:34:23'),
(8,2,NULL,NULL,'<ul><li><p>fdf</p></li><li><p>fdf</p></li><li><p><code>fdfdfd</code></p></li><li><p><code>fdfdfdfddfdf</code></p></li><li><p><code>测试编辑</code></p></li><li><p>测试历史</p></li></ul><p></p><p>$$E=mc^2$$</p>','2025-10-29 19:47:58');

/*Table structure for table `post_tags` */

DROP TABLE IF EXISTS `post_tags`;

CREATE TABLE `post_tags` (
  `post_id` bigint(20) unsigned NOT NULL,
  `tag_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`post_id`,`tag_id`),
  KEY `fk_post_tags_tag` (`tag_id`),
  CONSTRAINT `fk_post_tags_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_post_tags_tag` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `post_tags` */

insert  into `post_tags`(`post_id`,`tag_id`) values 
(2,1);

/*Table structure for table `posts` */

DROP TABLE IF EXISTS `posts`;

CREATE TABLE `posts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `author_id` bigint(20) unsigned NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci,
  `content_md` longtext COLLATE utf8mb4_unicode_ci,
  `content_html` longtext COLLATE utf8mb4_unicode_ci,
  `cover_image_url` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('draft','published','archived') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `allow_comments` tinyint(1) NOT NULL DEFAULT '1',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_posts_slug` (`slug`),
  KEY `idx_posts_author` (`author_id`),
  KEY `idx_posts_status_published_at` (`status`,`published_at`),
  CONSTRAINT `fk_posts_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `posts` */

insert  into `posts`(`id`,`author_id`,`title`,`slug`,`summary`,`content_md`,`content_html`,`cover_image_url`,`status`,`is_featured`,`allow_comments`,`view_count`,`published_at`,`created_at`,`updated_at`) values 
(1,1,'第一篇文章','firt','文章摘要',NULL,'<pre><code class=\"language-js\">var a = 1;\nvar b = a * a;\nreturn a + b;</code></pre><blockquote><p>fdfdfd</p><p>fdfdf</p></blockquote><p>$$E=mc^2$$</p>','http://gips3.baidu.com/it/u=3886271102,3123389489&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960','published',0,1,3,'2025-10-27 09:20:23','2025-10-27 09:17:20','2025-10-27 14:36:23'),
(2,1,'第二篇文章','di-er-pian-wen-zhang','啦啦啦111',NULL,'<ul><li><p>fdf</p></li><li><p>fdf</p></li><li><p><code>fdfdfd</code></p></li><li><p><code>fdfdfdfddfdf</code></p></li><li><p><code>测试编辑</code></p></li><li><p>测试历史</p></li></ul><p></p><p>$$E=mc^2$$</p>',NULL,'published',0,1,5,'2025-10-29 17:14:30','2025-10-27 19:55:58','2025-10-29 19:47:57');

/*Table structure for table `settings` */

DROP TABLE IF EXISTS `settings`;

CREATE TABLE `settings` (
  `k` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `v` text COLLATE utf8mb4_unicode_ci,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `settings` */

insert  into `settings`(`k`,`v`,`updated_at`) values 
('site_description','记录与分享','2025-10-24 14:02:22'),
('site_title','我的博客','2025-10-24 14:02:22');

/*Table structure for table `tags` */

DROP TABLE IF EXISTS `tags`;

CREATE TABLE `tags` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tags_name` (`name`),
  UNIQUE KEY `uk_tags_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `tags` */

insert  into `tags`(`id`,`name`,`slug`,`created_at`) values 
(1,'markdown','markdown','2025-10-27 19:55:07');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('admin','editor','author') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'admin',
  `status` enum('active','disabled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_username` (`username`),
  UNIQUE KEY `uk_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `users` */

insert  into `users`(`id`,`username`,`email`,`password_hash`,`display_name`,`role`,`status`,`last_login_at`,`created_at`,`updated_at`) values 
(1,'admin',NULL,'$2a$12$G2fEGp7tDNs3Nol5JE3eUeY5NFSF5ER5Zbw5gUgdSSApqqPtH/U4K',NULL,'admin','active',NULL,'2025-10-26 13:51:48','2025-10-26 13:51:48');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
