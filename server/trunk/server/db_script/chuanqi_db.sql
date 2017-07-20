-- MySQL dump 10.13  Distrib 5.6.17, for Win64 (x86_64)
--
-- Host: localhost    Database: chuanqi_db
-- ------------------------------------------------------
-- Server version	5.6.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account` (
  `open_id` varchar(128) NOT NULL DEFAULT '' COMMENT '第三方id或者是游戏本身自定义id',
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `platform` smallint(1) unsigned NOT NULL DEFAULT '0' COMMENT '渠道',
  `server_id` int(11) DEFAULT '0' COMMENT '区服id,主要是用于合服',
  PRIMARY KEY (`open_id`,`player_id`,`platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='账号表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_service_db`
--

DROP TABLE IF EXISTS `active_service_db`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_service_db` (
  `active_service_id` int(11) NOT NULL DEFAULT '0' COMMENT '开服活动排名记录',
  `rank` int(11) DEFAULT '0' COMMENT '排名',
  `player_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '玩家id',
  `value` int(11) DEFAULT '0' COMMENT '玩家排名时候的值',
  `time` int(11) unsigned DEFAULT '0' COMMENT '记录时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_service_db`
--

LOCK TABLES `active_service_db` WRITE;
/*!40000 ALTER TABLE `active_service_db` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_service_db` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arena_shop`
--

DROP TABLE IF EXISTS `arena_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arena_shop` (
  `id` int(19) NOT NULL COMMENT '商品id',
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `count` int(19) NOT NULL DEFAULT '0' COMMENT '购买次数',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`,`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='竞技场商店';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arena_shop`
--

LOCK TABLES `arena_shop` WRITE;
/*!40000 ALTER TABLE `arena_shop` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buff`
--

DROP TABLE IF EXISTS `buff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buff` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `buff_id` smallint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'buff列表',
  `next_time` int(11) unsigned DEFAULT '0' COMMENT '下一次生效时间',
  `remove_time` int(11) unsigned DEFAULT '0' COMMENT '移除时间',
  `extra_info` varchar(256) DEFAULT '' COMMENT 'buff扩展信息',
  PRIMARY KEY (`player_id`,`buff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='buff表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buff`
--

LOCK TABLES `buff` WRITE;
/*!40000 ALTER TABLE `buff` DISABLE KEYS */;
/*!40000 ALTER TABLE `buff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `button_tips`
--

DROP TABLE IF EXISTS `button_tips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `button_tips` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `btn_id` smallint(3) unsigned NOT NULL DEFAULT '0' COMMENT '按钮id',
  `num` smallint(3) unsigned DEFAULT '0' COMMENT '按钮提示数量',
  PRIMARY KEY (`player_id`,`btn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `button_tips`
--

LOCK TABLES `button_tips` WRITE;
/*!40000 ALTER TABLE `button_tips` DISABLE KEYS */;
/*!40000 ALTER TABLE `button_tips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city_info`
--

DROP TABLE IF EXISTS `city_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `city_info` (
  `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '城市场景id',
  `guild_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '帮会ID',
  `occupy_time` int(11) NOT NULL COMMENT '占领时间',
  `frist_player_id` bigint(20) DEFAULT NULL,
  `every_player_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='城市任命信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city_info`
--

LOCK TABLES `city_info` WRITE;
/*!40000 ALTER TABLE `city_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `city_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city_officer`
--

DROP TABLE IF EXISTS `city_officer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `city_officer` (
  `officer_id` int(8) NOT NULL DEFAULT '0' COMMENT '职位id',
  `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '沙巴克场景id',
  `player_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `day_time` int(11) NOT NULL DEFAULT '0' COMMENT '每日奖励领取时间',
  `frist_player_id` bigint(20) NOT NULL COMMENT '第一次领取的人的id',
  `day_officer_id` int(11) NOT NULL DEFAULT '0' COMMENT '每日奖励领取的 哪种官职的奖励',
  `is_del` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否删除 1是删除',
  `every_player_id` bigint(20) unsigned DEFAULT '0' COMMENT '每次攻城领取玩家id',
  PRIMARY KEY (`scene_id`,`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='城市任命信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city_officer`
--

LOCK TABLES `city_officer` WRITE;
/*!40000 ALTER TABLE `city_officer` DISABLE KEYS */;
/*!40000 ALTER TABLE `city_officer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `function`
--

DROP TABLE IF EXISTS `function`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `function` (
  `id` int(8) NOT NULL DEFAULT '0' COMMENT '功能id',
  `begin_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '开启时间',
  `end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
  `group_num` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '开启分组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='功能信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `function`
--

LOCK TABLES `function` WRITE;
/*!40000 ALTER TABLE `function` DISABLE KEYS */;
/*!40000 ALTER TABLE `function` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild`
--

DROP TABLE IF EXISTS `guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild` (
  `guild_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '帮派id',
  `guild_name` varchar(100) CHARACTER SET utf8mb4 NOT NULL COMMENT '名称',
  `state` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态:0:未激活,1正常',
  `rank` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '排名',
  `member_count` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '成员数量',
  `lv` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `expe` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `active` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活跃点',
  `chief_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '会长ID',
  `chief_name` varchar(50) NOT NULL DEFAULT '' COMMENT '会长昵称',
  `capital` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '行会资金',
  `public_announce` varchar(150) NOT NULL DEFAULT '' COMMENT '外部公告',
  `internal_announce` varchar(150) NOT NULL DEFAULT '' COMMENT '内部公告',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `extra` varchar(2000) NOT NULL DEFAULT '[]' COMMENT '额外数据(申请设置)',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`guild_id`),
  KEY `idx_rank` (`rank`),
  KEY `idx_name` (`guild_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='帮派';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild`
--

LOCK TABLES `guild` WRITE;
/*!40000 ALTER TABLE `guild` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hook_star_reward`
--

DROP TABLE IF EXISTS `hook_star_reward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hook_star_reward` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `chapter` smallint(1) unsigned NOT NULL DEFAULT '0' COMMENT '章节',
  `step_list` varchar(32) DEFAULT '[]' COMMENT '阶段奖励标识列表',
  PRIMARY KEY (`player_id`,`chapter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='挂机星级奖励表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hook_star_reward`
--

LOCK TABLES `hook_star_reward` WRITE;
/*!40000 ALTER TABLE `hook_star_reward` DISABLE KEYS */;
/*!40000 ALTER TABLE `hook_star_reward` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_money`
--

DROP TABLE IF EXISTS `log_money`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_money` (
  `player_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '玩家id',
  `num` int(11) DEFAULT '0' COMMENT '数量',
  `key` int(11) DEFAULT '0' COMMENT '3，金币',
  `type` int(11) DEFAULT '0' COMMENT '消耗的类型',
  `time` int(11) unsigned DEFAULT '0' COMMENT '时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_money`
--

LOCK TABLES `log_money` WRITE;
/*!40000 ALTER TABLE `log_money` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_money` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lottery_coin_db`
--

DROP TABLE IF EXISTS `lottery_coin_db`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lottery_coin_db` (
  `lottery_coin_id` int(11) NOT NULL DEFAULT '0' COMMENT '奖励id',
  `day_num` int(11) DEFAULT '0' COMMENT '每次抽取次数记录',
  `ref_time` int(11) unsigned DEFAULT '0' COMMENT '刷新时间',
  PRIMARY KEY (`lottery_coin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lottery_coin_db`
--

LOCK TABLES `lottery_coin_db` WRITE;
/*!40000 ALTER TABLE `lottery_coin_db` DISABLE KEYS */;
/*!40000 ALTER TABLE `lottery_coin_db` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lottery_coin_log`
--

DROP TABLE IF EXISTS `lottery_coin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lottery_coin_log` (
  `id` bigint(19) NOT NULL DEFAULT '0' COMMENT '编号id',
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `lottery_coin_id` int(11) DEFAULT '0' COMMENT '奖励id',
  `time` int(11) unsigned DEFAULT '0' COMMENT '抽取时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lottery_coin_log`
--

LOCK TABLES `lottery_coin_log` WRITE;
/*!40000 ALTER TABLE `lottery_coin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `lottery_coin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lottery_db`
--

DROP TABLE IF EXISTS `lottery_db`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lottery_db` (
  `lottery_id` int(11) NOT NULL DEFAULT '0' COMMENT '奖励id',
  `day_num` int(11) DEFAULT '0' COMMENT '每次抽取次数记录',
  `ref_time` int(11) unsigned DEFAULT '0' COMMENT '刷新时间',
  PRIMARY KEY (`lottery_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lottery_db`
--

LOCK TABLES `lottery_db` WRITE;
/*!40000 ALTER TABLE `lottery_db` DISABLE KEYS */;
/*!40000 ALTER TABLE `lottery_db` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lottery_log`
--

DROP TABLE IF EXISTS `lottery_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lottery_log` (
  `id` bigint(19) NOT NULL DEFAULT '0' COMMENT '编号id',
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `lottery_id` int(11) DEFAULT '0' COMMENT '奖励id',
  `time` int(11) unsigned DEFAULT '0' COMMENT '抽取时间',
  `group_num` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '属于哪个轮数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lottery_log`
--

LOCK TABLES `lottery_log` WRITE;
/*!40000 ALTER TABLE `lottery_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `lottery_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_conf`
--

DROP TABLE IF EXISTS `mail_conf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_conf` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '邮件id',
  `mail_type` int(2) NOT NULL DEFAULT '0' COMMENT '邮件类型(0系统个人1其他2全服)',
  `sender` varchar(100) NOT NULL COMMENT '发送者',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '邮件标题',
  `content` varchar(1024) NOT NULL DEFAULT '' COMMENT '邮件内容',
  `award` varchar(100) NOT NULL DEFAULT '' COMMENT '邮件奖励',
  `active_time` int(11) NOT NULL DEFAULT '0' COMMENT '邮件有效时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家邮件配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_conf`
--

LOCK TABLES `mail_conf` WRITE;
/*!40000 ALTER TABLE `mail_conf` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_conf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monster_kills`
--

DROP TABLE IF EXISTS `monster_kills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monster_kills` (
  `monster_id` int(11) NOT NULL COMMENT '怪物id',
  `scene_id` int(11) unsigned NOT NULL COMMENT '场景id',
  `kill_count` int(11) NOT NULL COMMENT '被击杀次数',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`monster_id`,`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='怪物击杀信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monster_kills`
--

LOCK TABLES `monster_kills` WRITE;
/*!40000 ALTER TABLE `monster_kills` DISABLE KEYS */;
/*!40000 ALTER TABLE `monster_kills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `my_service`
--

DROP TABLE IF EXISTS `my_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `my_service` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(40) NOT NULL COMMENT '服务器名称',
  `ip` varchar(100) DEFAULT NULL,
  `service_port` int(11) DEFAULT NULL COMMENT '游戏端口',
  `begin_time` int(11) DEFAULT NULL COMMENT 'php用的开服时间',
  `platform` varchar(50) DEFAULT NULL COMMENT '平台',
  `port` int(11) DEFAULT NULL COMMENT '后台端口',
  `service_id` int(11) DEFAULT NULL,
  `description` text COMMENT '服务器描述',
  `db_sql` varchar(300) DEFAULT NULL,
  `isopen` int(1) DEFAULT NULL COMMENT '是否开启',
  `order` int(11) DEFAULT NULL,
  `show_host_arr` varchar(1000) DEFAULT NULL COMMENT '对应网址需要显示的服务器id',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 畅通，1 繁忙 ，2爆满',
  `white_ip` text COMMENT '白名单ip',
  `white_acc` text COMMENT '白名单账号',
  `v` varchar(100) DEFAULT NULL COMMENT '版本号',
  `group_id` int(11) DEFAULT '0' COMMENT '分组',
  `open_time` int(11) DEFAULT '0' COMMENT '服务器用的开服时间',
  `is_robot` tinyint(4) DEFAULT '0' COMMENT '是否开启机器人 0关闭，1开启',
  PRIMARY KEY (`id`),
  KEY `fk_isopen` (`isopen`),
  KEY `fk_platform_isopen_white_ip_white_acc` (`platform`,`isopen`,`white_ip`(255),`white_acc`(255)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `my_service`
--

LOCK TABLES `my_service` WRITE;
/*!40000 ALTER TABLE `my_service` DISABLE KEYS */;
/*!40000 ALTER TABLE `my_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pet` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `pet_list` varchar(256) DEFAULT '' COMMENT '宠物列表',
  `effective_time` int(11) unsigned DEFAULT '0' COMMENT '有效期',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宠物表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet`
--

LOCK TABLES `pet` WRITE;
/*!40000 ALTER TABLE `pet` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_active_service`
--

DROP TABLE IF EXISTS `player_active_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_active_service` (
  `player_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '玩家id',
  `active_service_id` int(11) NOT NULL DEFAULT '0' COMMENT '开服活动id',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`player_id`,`active_service_id`),
  KEY `fk_active_service_id` (`active_service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='领取开服奖励表信息 ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_active_service`
--

LOCK TABLES `player_active_service` WRITE;
/*!40000 ALTER TABLE `player_active_service` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_active_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_active_service_record`
--

DROP TABLE IF EXISTS `player_active_service_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_active_service_record` (
  `player_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '玩家id',
  `active_service_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '开服活动类型id记录',
  `value` int(11) DEFAULT '0' COMMENT '玩家值记录',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`,`active_service_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_active_service_record`
--

LOCK TABLES `player_active_service_record` WRITE;
/*!40000 ALTER TABLE `player_active_service_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_active_service_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_arena_rank`
--

DROP TABLE IF EXISTS `player_arena_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_arena_rank` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `name` varchar(50) NOT NULL COMMENT '名字',
  `sex` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '性别',
  `lv` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `career` int(4) unsigned NOT NULL DEFAULT '0' COMMENT '职业',
  `fighting` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '战斗力',
  `guild_id` bigint(19) NOT NULL COMMENT '公会id',
  `extra` varchar(1024) NOT NULL COMMENT '额外数据',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`),
  KEY `_rank` (`rank`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家_竞技场排名';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_arena_rank`
--

LOCK TABLES `player_arena_rank` WRITE;
/*!40000 ALTER TABLE `player_arena_rank` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_arena_rank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_arena_record`
--

DROP TABLE IF EXISTS `player_arena_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_arena_record` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `reputation` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '声望',
  `match_list` varchar(50) NOT NULL COMMENT '匹配到的名次列表',
  `arena_list` blob NOT NULL COMMENT '分配记录',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家_竞技场记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_arena_record`
--

LOCK TABLES `player_arena_record` WRITE;
/*!40000 ALTER TABLE `player_arena_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_arena_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_attr`
--

DROP TABLE IF EXISTS `player_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_attr` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `cur_hp` int(11) unsigned DEFAULT '0' COMMENT '玩家当前血量',
  `cur_mp` int(11) unsigned DEFAULT '0' COMMENT '玩家当前魔法',
  `last_recover_hp` int(11) unsigned DEFAULT '0' COMMENT '最后回血时间',
  `last_recover_mp` int(11) unsigned DEFAULT '0' COMMENT '最后回蓝时间',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家需要存库的属性表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_attr`
--

LOCK TABLES `player_attr` WRITE;
/*!40000 ALTER TABLE `player_attr` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_attr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_base`
--

DROP TABLE IF EXISTS `player_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_base` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT 'id',
  `name` varchar(128) CHARACTER SET utf8mb4 DEFAULT '' COMMENT '名字',
  `lv` smallint(1) unsigned DEFAULT '0' COMMENT '等级',
  `exp` int(11) unsigned DEFAULT '0' COMMENT '经验',
  `sex` tinyint(1) unsigned DEFAULT '0' COMMENT '性别',
  `career` smallint(1) unsigned DEFAULT '0' COMMENT '职业',
  `register_time` int(11) unsigned DEFAULT '0' COMMENT '注册时间戳',
  `last_login_time` int(11) unsigned DEFAULT '0' COMMENT '最后登录时间',
  `last_logout_time` int(11) unsigned DEFAULT '0' COMMENT '最后离线时间',
  `os_type` tinyint(1) unsigned DEFAULT '0' COMMENT '系统类型',
  `scene_id` smallint(5) unsigned DEFAULT '0' COMMENT '当前所在场景id',
  `x` smallint(5) unsigned DEFAULT '0' COMMENT '当前所在x坐标',
  `y` smallint(5) unsigned DEFAULT '0' COMMENT '当前所在y坐标',
  `pass_hook_scene_id` smallint(5) unsigned DEFAULT '0' COMMENT '通关挂机场景id',
  `hook_scene_id` smallint(1) unsigned DEFAULT '0' COMMENT '挂机场景id',
  `last_hook_time` int(11) unsigned DEFAULT '0' COMMENT '最后挂机时间',
  `draw_hook_time` int(11) unsigned DEFAULT '0' COMMENT '领取挂机奖励时间',
  `challenge_num` tinyint(1) unsigned DEFAULT '0' COMMENT '当天可挑战次数',
  `buy_challenge_num` tinyint(1) unsigned DEFAULT '0' COMMENT '当日购买挑战次数',
  `reset_challenge_time` int(11) unsigned DEFAULT '0' COMMENT '挑战重置时间',
  `power` tinyint(1) unsigned DEFAULT '0' COMMENT '当前体力',
  `power_recover_time` int(11) unsigned DEFAULT '0' COMMENT '体力恢复时间',
  `buy_power_num` tinyint(1) unsigned DEFAULT '0' COMMENT '当日购买体力次数',
  `reset_buy_power_time` int(11) unsigned DEFAULT '0' COMMENT '当日购买次数重置时间',
  `bag` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '背包格子容量',
  `forge` mediumint(6) unsigned NOT NULL DEFAULT '0' COMMENT '锻造id',
  `guild_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '帮派id',
  `legion_id` bigint(19) NOT NULL DEFAULT '0' COMMENT '军团id',
  `set_pk_mode` tinyint(3) unsigned DEFAULT '0' COMMENT '自己设定的pk模式',
  `pk_mode` tinyint(3) unsigned DEFAULT '0' COMMENT 'pk模式',
  `pk_value` smallint(1) unsigned DEFAULT '0' COMMENT 'pk值',
  `vip` smallint(1) unsigned DEFAULT '0' COMMENT 'vip等级',
  `blood_bag` int(11) unsigned DEFAULT '0' COMMENT '血包',
  `ref_task_time` int(11) NOT NULL DEFAULT '0' COMMENT '记录任务刷新时间',
  `task_reward_active` varchar(100) DEFAULT NULL COMMENT '任务领取奖励记录',
  `hp_set` varchar(100) NOT NULL DEFAULT '0' COMMENT '回复设置信息',
  `hpmp_set` varchar(100) NOT NULL DEFAULT '0' COMMENT '瞬间回复设置',
  `fight` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `instance_reset_time` int(11) unsigned DEFAULT '0' COMMENT '副本进入次数重置时间',
  `guise` varchar(200) NOT NULL DEFAULT '' COMMENT '外观属性',
  `fh_cd` int(11) unsigned DEFAULT '0' COMMENT '复活戒指cd',
  `skill_set` tinyint(3) unsigned DEFAULT '0' COMMENT '群体技能设置开关',
  `equip_sell_set` varchar(100) NOT NULL DEFAULT '0' COMMENT '装备自动出售设置',
  `pickup_set` varchar(100) NOT NULL DEFAULT '0' COMMENT '自动拾取设置',
  `vip_exp` int(11) DEFAULT '0' COMMENT 'vip经验',
  `pet_att_type` tinyint(1) unsigned DEFAULT '1' COMMENT '宠物攻击类型',
  `limit_chat` int(11) unsigned DEFAULT '0' COMMENT '禁言时间',
  `limit_login` int(11) unsigned DEFAULT '0' COMMENT '封角色时间',
  `wing_state` tinyint(1) unsigned DEFAULT '0' COMMENT '翅膀外观状态0显示 1不显示',
  `guild_task_time` int(11) NOT NULL DEFAULT '0' COMMENT '公会任务刷新时间',
  `guild_task_id` int(11) NOT NULL DEFAULT '0' COMMENT '公会任务id记录',
  `lottery_num` int(11) NOT NULL DEFAULT '0' COMMENT '玩家抽奖次数',
  `lottery_coin_num` int(11) NOT NULL DEFAULT '0' COMMENT '玩家金币抽奖次数',
  `is_robot` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否是机器人',
  `instance_left_time` int(11) DEFAULT '0' COMMENT '个人boss剩余时间',
  `state` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '玩家状态 0是无状态，1是死亡状态',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_base`
--

LOCK TABLES `player_base` WRITE;
/*!40000 ALTER TABLE `player_base` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_base` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_batch_record`
--

DROP TABLE IF EXISTS `player_batch_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_batch_record` (
  `player_id` bigint(20) NOT NULL COMMENT '玩家id',
  `task_id` int(11) NOT NULL COMMENT '任务id',
  `add_time` int(11) DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`player_id`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='批量处理状态';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_batch_record`
--

LOCK TABLES `player_batch_record` WRITE;
/*!40000 ALTER TABLE `player_batch_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_batch_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_black`
--

DROP TABLE IF EXISTS `player_black`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_black` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `tplayer_id` bigint(19) NOT NULL COMMENT '黑名单玩家Id',
  `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '拉黑时间',
  PRIMARY KEY (`player_id`,`tplayer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_black`
--

LOCK TABLES `player_black` WRITE;
/*!40000 ALTER TABLE `player_black` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_black` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_charge`
--

DROP TABLE IF EXISTS `player_charge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_charge` (
  `id` bigint(19) NOT NULL DEFAULT '0' COMMENT '订单编号id',
  `player_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `platform` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '渠道',
  `charge_key` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值商品编号key',
  `rmb` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值rmb',
  `charge_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值时间',
  `state` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值状态 0 订单开始，1，订单验证完成，2 订单完成',
  `platform_result` varchar(1000) DEFAULT NULL COMMENT '渠道返回信息',
  PRIMARY KEY (`id`),
  KEY `fk_player_id_state` (`player_id`,`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家订单数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_charge`
--

LOCK TABLES `player_charge` WRITE;
/*!40000 ALTER TABLE `player_charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_charge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_charge_copy`
--

DROP TABLE IF EXISTS `player_charge_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_charge_copy` (
  `id` bigint(19) NOT NULL DEFAULT '0' COMMENT '订单编号id',
  `player_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `platform` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '渠道',
  `charge_key` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值商品编号key',
  `rmb` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值rmb',
  `charge_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值时间',
  `state` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值状态 0 订单开始，1，订单验证完成，2 订单完成',
  `platform_result` varchar(500) DEFAULT NULL COMMENT '渠道返回信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家订单数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_charge_copy`
--

LOCK TABLES `player_charge_copy` WRITE;
/*!40000 ALTER TABLE `player_charge_copy` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_charge_copy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_counter`
--

DROP TABLE IF EXISTS `player_counter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_counter` (
  `player_id` bigint(19) NOT NULL DEFAULT '0' COMMENT '玩家id',
  `counter_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '计数器id',
  `value` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '计数值',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`player_id`,`counter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家计数器记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_counter`
--

LOCK TABLES `player_counter` WRITE;
/*!40000 ALTER TABLE `player_counter` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_counter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_drop`
--

DROP TABLE IF EXISTS `player_drop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_drop` (
  `player_id` bigint(19) unsigned NOT NULL COMMENT '玩家id',
  `monster_id` int(11) NOT NULL COMMENT '怪物id',
  `kill_count` int(11) NOT NULL COMMENT '击杀次数',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`,`monster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家掉落相关数据记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_drop`
--

LOCK TABLES `player_drop` WRITE;
/*!40000 ALTER TABLE `player_drop` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_drop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_foe`
--

DROP TABLE IF EXISTS `player_foe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_foe` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `tplayer_id` bigint(19) NOT NULL COMMENT '仇人Id',
  `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`player_id`,`tplayer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_foe`
--

LOCK TABLES `player_foe` WRITE;
/*!40000 ALTER TABLE `player_foe` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_foe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_friend`
--

DROP TABLE IF EXISTS `player_friend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_friend` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家Id',
  `tplayer_id` bigint(19) NOT NULL COMMENT '好友Id',
  PRIMARY KEY (`player_id`,`tplayer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_friend`
--

LOCK TABLES `player_friend` WRITE;
/*!40000 ALTER TABLE `player_friend` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_friend` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_friend_ask`
--

DROP TABLE IF EXISTS `player_friend_ask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_friend_ask` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `tplayer_id` bigint(19) NOT NULL COMMENT '申请人id',
  `asktime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '申请时间',
  PRIMARY KEY (`player_id`,`tplayer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_friend_ask`
--

LOCK TABLES `player_friend_ask` WRITE;
/*!40000 ALTER TABLE `player_friend_ask` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_friend_ask` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_goods`
--

DROP TABLE IF EXISTS `player_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_goods` (
  `id` bigint(19) NOT NULL DEFAULT '0' COMMENT '物品唯一id',
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `goods_id` int(11) unsigned NOT NULL COMMENT '物品id',
  `is_bind` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否绑定0非绑1绑定',
  `num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '堆叠个数',
  `stren_lv` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '强化等级',
  `soul` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '铸魂',
  `location` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '存放位置 0普通背包,1,穿戴背包2,仓库背包',
  `grid` int(4) unsigned NOT NULL DEFAULT '0' COMMENT '存放格子',
  `extra` varchar(600) NOT NULL COMMENT '道具存储数据',
  `secure` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '保险次数',
  `bless` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '祝福值',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `expire_time` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '时效道具过期时间',
  PRIMARY KEY (`id`,`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家_物品对应表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_goods`
--

LOCK TABLES `player_goods` WRITE;
/*!40000 ALTER TABLE `player_goods` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_guide`
--

DROP TABLE IF EXISTS `player_guide`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_guide` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家新手引导记录',
  `guide_step_id` int(11) unsigned NOT NULL COMMENT '新手引导记录id',
  PRIMARY KEY (`player_id`,`guide_step_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_guide`
--

LOCK TABLES `player_guide` WRITE;
/*!40000 ALTER TABLE `player_guide` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_guide` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_guild`
--

DROP TABLE IF EXISTS `player_guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_guild` (
  `player_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `name` varchar(200) CHARACTER SET utf8mb4 NOT NULL COMMENT '姓名',
  `career` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '职业',
  `sex` int(11) unsigned NOT NULL DEFAULT '0',
  `lv` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `guild_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '帮派ID',
  `guild_name` varchar(200) NOT NULL,
  `position` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '职位:0非会员,1会长,2长老,3会员',
  `fight` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '战斗力',
  `contribution` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '贡献',
  `totoal_contribution` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '总贡献',
  `extra` varchar(500) NOT NULL DEFAULT '[]',
  `join_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '加入时间',
  `login_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后上线时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`),
  KEY `idx_guild_id` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家帮派数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_guild`
--

LOCK TABLES `player_guild` WRITE;
/*!40000 ALTER TABLE `player_guild` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_guild` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_guild_shop`
--

DROP TABLE IF EXISTS `player_guild_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_guild_shop` (
  `player_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `shop_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '购买次数',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`,`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家帮派商店数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_guild_shop`
--

LOCK TABLES `player_guild_shop` WRITE;
/*!40000 ALTER TABLE `player_guild_shop` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_guild_shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_hook_star`
--

DROP TABLE IF EXISTS `player_hook_star`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_hook_star` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `hook_scene_id` smallint(8) unsigned NOT NULL DEFAULT '0' COMMENT '挂机场景id',
  `star` tinyint(1) unsigned DEFAULT '0' COMMENT '星级',
  `reward_status` tinyint(1) unsigned DEFAULT '0' COMMENT '首次通过奖励状态',
  PRIMARY KEY (`player_id`,`hook_scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家_挂机星级对应表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_hook_star`
--

LOCK TABLES `player_hook_star` WRITE;
/*!40000 ALTER TABLE `player_hook_star` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_hook_star` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_instance`
--

DROP TABLE IF EXISTS `player_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_instance` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `scene_id` int(5) unsigned NOT NULL DEFAULT '0' COMMENT '副本场景id',
  `enter_times` tinyint(4) unsigned DEFAULT '0' COMMENT '进入次数',
  `buy_times` tinyint(4) unsigned DEFAULT '0' COMMENT '购买次数',
  PRIMARY KEY (`player_id`,`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家-副本映射表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_instance`
--

LOCK TABLES `player_instance` WRITE;
/*!40000 ALTER TABLE `player_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_instance_pass`
--

DROP TABLE IF EXISTS `player_instance_pass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_instance_pass` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `scene_id` int(5) unsigned NOT NULL DEFAULT '0' COMMENT '副本场景id',
  `pass_time` int(11) DEFAULT '0' COMMENT '通关时间',
  PRIMARY KEY (`player_id`,`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家-副本通关表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_instance_pass`
--

LOCK TABLES `player_instance_pass` WRITE;
/*!40000 ALTER TABLE `player_instance_pass` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_instance_pass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_mail`
--

DROP TABLE IF EXISTS `player_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_mail` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT COMMENT '自增',
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `mail_id` int(11) NOT NULL DEFAULT '0' COMMENT '邮件id',
  `mail_type` int(2) NOT NULL DEFAULT '0' COMMENT '邮件类型(0系统邮件1其他2全服邮件)',
  `sender` varchar(100) NOT NULL COMMENT '发送者',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '邮件标题',
  `content` varchar(1024) NOT NULL DEFAULT '' COMMENT '邮件内容',
  `award` varchar(500) NOT NULL COMMENT '邮件奖励',
  `state` tinyint(2) NOT NULL DEFAULT '0' COMMENT '领取状态(0未领取1已领取2无附件)',
  `send_time` int(11) NOT NULL DEFAULT '0' COMMENT '发送时间',
  `limit_time` int(11) NOT NULL DEFAULT '0' COMMENT '到期时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`,`player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=438086665267 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家邮件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_mail`
--

LOCK TABLES `player_mail` WRITE;
/*!40000 ALTER TABLE `player_mail` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_mail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_mark`
--

DROP TABLE IF EXISTS `player_mark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_mark` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `hp_mark` tinyint(4) unsigned DEFAULT '0' COMMENT '生命印记',
  `atk_mark` tinyint(4) unsigned DEFAULT '0' COMMENT '攻击印记',
  `def_mark` tinyint(4) unsigned DEFAULT '0' COMMENT '防御印记',
  `res_mark` tinyint(4) unsigned DEFAULT '0' COMMENT '魔防印记',
  `holy_mark` tinyint(4) unsigned DEFAULT '0' COMMENT '神圣印记',
  `mounts_mark_1` int(4) unsigned DEFAULT '0' COMMENT '坐骑装备印记1',
  `mounts_mark_2` int(4) unsigned DEFAULT '0' COMMENT '坐骑装备印记2',
  `mounts_mark_3` int(4) unsigned DEFAULT '0' COMMENT '坐骑装备印记3',
  `mounts_mark_4` int(4) unsigned DEFAULT '0' COMMENT '坐骑装备印记4',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家自身印记';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_mark`
--

LOCK TABLES `player_mark` WRITE;
/*!40000 ALTER TABLE `player_mark` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_mark` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_money`
--

DROP TABLE IF EXISTS `player_money`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_money` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `coin` bigint(20) unsigned DEFAULT '0' COMMENT '金币',
  `jade` int(11) unsigned DEFAULT '0' COMMENT '元宝',
  `gift` int(11) unsigned DEFAULT '0' COMMENT '礼券',
  `smelt_value` int(11) unsigned DEFAULT '0' COMMENT '熔炼值',
  `feats` int(11) unsigned DEFAULT '0' COMMENT '功勋',
  `hp_mark_value` int(11) unsigned DEFAULT '0' COMMENT '生命印记值',
  `atk_mark_value` int(11) unsigned DEFAULT '0' COMMENT '攻击印记值',
  `def_mark_value` int(11) unsigned DEFAULT '0' COMMENT '防御印记值',
  `res_mark_value` int(11) unsigned DEFAULT '0' COMMENT '魔防印记值',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家货币表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_money`
--

LOCK TABLES `player_money` WRITE;
/*!40000 ALTER TABLE `player_money` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_money` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_monster`
--

DROP TABLE IF EXISTS `player_monster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_monster` (
  `monster_id` int(11) NOT NULL COMMENT '怪物id',
  `player_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '击杀时间',
  `is_frist` tinyint(1) unsigned DEFAULT '0' COMMENT '是否是全服首杀 0不是 1是',
  `is_frist_goods` tinyint(1) unsigned DEFAULT '0' COMMENT '是否是领取全服首杀 0不是 1是',
  `is_goods` tinyint(1) unsigned DEFAULT '0' COMMENT '是否领取单次击杀 0不是 1是',
  PRIMARY KEY (`player_id`,`monster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家击杀boss怪物信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_monster`
--

LOCK TABLES `player_monster` WRITE;
/*!40000 ALTER TABLE `player_monster` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_monster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_monster_drop`
--

DROP TABLE IF EXISTS `player_monster_drop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_monster_drop` (
  `id` bigint(20) NOT NULL,
  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
  `player_name` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '玩家名称',
  `scene_id` int(11) DEFAULT NULL COMMENT '场景id',
  `monster_id` int(11) DEFAULT NULL COMMENT '怪物id',
  `monster_goods` varchar(1000) DEFAULT '' COMMENT '怪物掉落物品id列表',
  `add_time` int(11) DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='击杀boss的掉落';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_monster_drop`
--

LOCK TABLES `player_monster_drop` WRITE;
/*!40000 ALTER TABLE `player_monster_drop` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_monster_drop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_monster_follow`
--

DROP TABLE IF EXISTS `player_monster_follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_monster_follow` (
  `scene_id` int(11) NOT NULL COMMENT '场景',
  `monster_id` int(11) NOT NULL COMMENT '怪物id',
  `player_id` bigint(20) NOT NULL COMMENT '玩家id',
  `open_id` varchar(128) DEFAULT NULL,
  `channel` int(11) DEFAULT NULL COMMENT '渠道',
  PRIMARY KEY (`scene_id`,`monster_id`,`player_id`),
  KEY `idx_player_id` (`player_id`) USING BTREE,
  KEY `idx_open_id` (`open_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家关注的boss';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_monster_follow`
--

LOCK TABLES `player_monster_follow` WRITE;
/*!40000 ALTER TABLE `player_monster_follow` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_monster_follow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_monster_killer_last`
--

DROP TABLE IF EXISTS `player_monster_killer_last`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_monster_killer_last` (
  `monster_id` int(11) NOT NULL COMMENT '怪物id',
  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '玩家名字',
  `update_time` int(11) DEFAULT '0' COMMENT ' 更新时间',
  PRIMARY KEY (`monster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='击杀游荡boss的最后一个玩家';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_monster_killer_last`
--

LOCK TABLES `player_monster_killer_last` WRITE;
/*!40000 ALTER TABLE `player_monster_killer_last` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_monster_killer_last` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_monster_state`
--

DROP TABLE IF EXISTS `player_monster_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_monster_state` (
  `player_id` bigint(20) NOT NULL,
  `refresh_time` int(11) DEFAULT NULL COMMENT '刷新时间',
  `hp_reset_time` int(11) DEFAULT '0' COMMENT '满血刷新时间',
  `monster_state` text COMMENT '各场景怪物状态',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='个人boss怪物状态';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_monster_state`
--

LOCK TABLES `player_monster_state` WRITE;
/*!40000 ALTER TABLE `player_monster_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_monster_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_month`
--

DROP TABLE IF EXISTS `player_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_month` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `charge_key` int(11) unsigned DEFAULT '0' COMMENT '充值键值',
  `begin_time` int(11) unsigned DEFAULT '0' COMMENT '月卡开始时间',
  `end_time` int(11) unsigned DEFAULT '0' COMMENT '月卡结束时间',
  `time` int(11) unsigned DEFAULT '0' COMMENT '月卡领取奖励时间',
  `is_jade` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否领取元宝',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家月卡信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_month`
--

LOCK TABLES `player_month` WRITE;
/*!40000 ALTER TABLE `player_month` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_month` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_mystery_shop`
--

DROP TABLE IF EXISTS `player_mystery_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_mystery_shop` (
  `id` bigint(20) NOT NULL DEFAULT '0' COMMENT '编号',
  `player_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `mystery_shop_id` int(11) unsigned NOT NULL COMMENT '神秘商店id',
  `ref_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '刷新时间',
  `is_buy` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已经购买',
  PRIMARY KEY (`id`,`player_id`),
  KEY `fk_player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家神秘商店表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_mystery_shop`
--

LOCK TABLES `player_mystery_shop` WRITE;
/*!40000 ALTER TABLE `player_mystery_shop` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_mystery_shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_operate_active`
--

DROP TABLE IF EXISTS `player_operate_active`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_operate_active` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `active_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动编号',
  `sub_type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动子类',
  `count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '完成次数',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`,`active_id`,`sub_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家运营活动完成次数';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_operate_active`
--

LOCK TABLES `player_operate_active` WRITE;
/*!40000 ALTER TABLE `player_operate_active` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_operate_active` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_operate_record`
--

DROP TABLE IF EXISTS `player_operate_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_operate_record` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `active_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动编号',
  `finish_limit_type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '完成条件类型',
  `finish_limit_value` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '完成条件参数',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`,`active_id`,`finish_limit_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家运营活动纪录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_operate_record`
--

LOCK TABLES `player_operate_record` WRITE;
/*!40000 ALTER TABLE `player_operate_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_operate_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_package`
--

DROP TABLE IF EXISTS `player_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_package` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家下载的包记录表',
  `lv` int(11) unsigned NOT NULL COMMENT '玩家记录的等级',
  `is_receive` tinyint(4) NOT NULL COMMENT '是否已经领取了这个奖励了1是已经领取了，0是还未领取',
  PRIMARY KEY (`player_id`,`lv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_package`
--

LOCK TABLES `player_package` WRITE;
/*!40000 ALTER TABLE `player_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_red`
--

DROP TABLE IF EXISTS `player_red`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_red` (
  `red_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '红包id',
  `player_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '红包id',
  `guild_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '帮派id',
  `jade` int(11) NOT NULL DEFAULT '0' COMMENT '领取的元宝金额',
  `time` int(11) unsigned DEFAULT '0' COMMENT '领取的时间',
  PRIMARY KEY (`red_id`,`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='红包领取信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_red`
--

LOCK TABLES `player_red` WRITE;
/*!40000 ALTER TABLE `player_red` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_red` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_sale`
--

DROP TABLE IF EXISTS `player_sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_sale` (
  `id` bigint(19) NOT NULL DEFAULT '0' COMMENT '编号id',
  `player_id` bigint(19) NOT NULL COMMENT '拍卖玩家id',
  `goods_id` int(11) unsigned NOT NULL COMMENT '拍卖物品id',
  `num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '数量',
  `stren_lv` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '强化等级',
  `jade` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '拍卖多少元宝',
  `state` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态 1 已退出，2 出售成功，3 表示已下架,4 已购买',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `extra` varchar(255) NOT NULL COMMENT '道具存储数据',
  `soul` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '铸魂',
  `secure` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '保险次数',
  PRIMARY KEY (`id`),
  KEY `fk_player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家领取物品信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_sale`
--

LOCK TABLES `player_sale` WRITE;
/*!40000 ALTER TABLE `player_sale` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_sign`
--

DROP TABLE IF EXISTS `player_sign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_sign` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `sign_month` int(11) NOT NULL COMMENT '签到月份',
  `sign_list` varchar(300) NOT NULL COMMENT '签到日期列表',
  `reward_list` varchar(300) NOT NULL COMMENT '签到奖励列表',
  `count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '补签次数',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家_签到表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_sign`
--

LOCK TABLES `player_sign` WRITE;
/*!40000 ALTER TABLE `player_sign` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_sign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_task`
--

DROP TABLE IF EXISTS `player_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_task` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `taskid_id` int(11) unsigned NOT NULL COMMENT '任务id',
  `nownum` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '已经完成的数量',
  `isfinish` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '是否完成 1位完成，0为结束',
  PRIMARY KEY (`player_id`,`taskid_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_task`
--

LOCK TABLES `player_task` WRITE;
/*!40000 ALTER TABLE `player_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_task_finish`
--

DROP TABLE IF EXISTS `player_task_finish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_task_finish` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家id',
  `taskid_id` int(11) unsigned NOT NULL COMMENT '任务id',
  PRIMARY KEY (`player_id`,`taskid_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_task_finish`
--

LOCK TABLES `player_task_finish` WRITE;
/*!40000 ALTER TABLE `player_task_finish` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_task_finish` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_vip`
--

DROP TABLE IF EXISTS `player_vip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_vip` (
  `player_id` bigint(19) NOT NULL COMMENT '玩家vip奖励领取记录',
  `vip_lv` int(11) unsigned NOT NULL COMMENT 'vip等级',
  PRIMARY KEY (`player_id`,`vip_lv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_vip`
--

LOCK TABLES `player_vip` WRITE;
/*!40000 ALTER TABLE `player_vip` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_vip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `red_record`
--

DROP TABLE IF EXISTS `red_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `red_record` (
  `red_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '红包id',
  `active_service_id` int(11) NOT NULL DEFAULT '0' COMMENT '开服活动id',
  `player_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '发送的玩家id',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '玩家名称',
  `position` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '发送时玩家的职位 职位:0非会员,1会长,2长老,3会员',
  `red_type_id` tinyint(4) NOT NULL DEFAULT '0' COMMENT '红包类型 0,一般红包 1，手气红包 ，2 定额红包',
  `guild_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '帮派id',
  `min_jade` int(11) NOT NULL DEFAULT '0' COMMENT '红包最小奖励',
  `max_jade` int(11) NOT NULL DEFAULT '0' COMMENT '红包最大奖励',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '红包最大数量',
  `loss_num` int(11) NOT NULL DEFAULT '0' COMMENT '已经使用的红包数量',
  `jade` int(11) NOT NULL DEFAULT '0' COMMENT '总金额元宝',
  `loss_jade` int(11) unsigned DEFAULT '0' COMMENT '已经领取的金额元宝',
  `begin_time` int(11) unsigned DEFAULT '0' COMMENT '红包发送时间',
  `end_time` int(11) unsigned DEFAULT '0' COMMENT '红包结束时间',
  `des` varchar(1000) DEFAULT '' COMMENT '红包说明',
  PRIMARY KEY (`red_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='红包信息记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `red_record`
--

LOCK TABLES `red_record` WRITE;
/*!40000 ALTER TABLE `red_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `red_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relationship`
--

DROP TABLE IF EXISTS `relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relationship` (
  `idA` bigint(19) NOT NULL COMMENT 'idA',
  `idB` bigint(19) NOT NULL COMMENT 'idB',
  `playernameB` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家B色角名',
  `playercareerB` tinyint(1) NOT NULL DEFAULT '0' COMMENT '玩家B职业',
  `playersexB` tinyint(1) NOT NULL DEFAULT '0' COMMENT '玩家B性别',
  `playerlvB` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家B等级',
  `rela` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '玩家间关系0好友1黑名单',
  `logintimeB` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家B最后登陆时间',
  PRIMARY KEY (`idA`,`idB`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relationship`
--

LOCK TABLES `relationship` WRITE;
/*!40000 ALTER TABLE `relationship` DISABLE KEYS */;
/*!40000 ALTER TABLE `relationship` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale`
--

DROP TABLE IF EXISTS `sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sale` (
  `sale_id` bigint(19) NOT NULL DEFAULT '0' COMMENT '编号id',
  `player_id` bigint(19) NOT NULL COMMENT '拍卖玩家id',
  `goods_id` int(11) unsigned NOT NULL COMMENT '拍卖物品id',
  `sale_sort` int(11) unsigned NOT NULL COMMENT '拍卖物品类型',
  `num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '数量',
  `jade` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '拍卖多少元宝',
  `begin_time` int(11) NOT NULL DEFAULT '0' COMMENT '拍卖开始时间',
  `end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '拍卖结束时间',
  `stren_lv` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '强化等级',
  `extra` varchar(255) NOT NULL COMMENT '道具存储数据',
  `soul` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '铸魂',
  `secure` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '保险次数',
  PRIMARY KEY (`sale_id`),
  KEY `fk_end_time` (`end_time`),
  KEY `fk_sale_sort` (`sale_sort`),
  KEY `fk_goods_id` (`goods_id`),
  KEY `fk_player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='拍卖物品信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale`
--

LOCK TABLES `sale` WRITE;
/*!40000 ALTER TABLE `sale` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill`
--

DROP TABLE IF EXISTS `skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skill` (
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `skill_id` mediumint(11) unsigned NOT NULL DEFAULT '0' COMMENT '技能id',
  `lv` tinyint(1) unsigned DEFAULT '0' COMMENT '技能等级',
  `exp` int(11) unsigned DEFAULT '0' COMMENT '技能熟练度',
  `pos` tinyint(1) unsigned DEFAULT '0' COMMENT '技能快捷键位置',
  `auto_set` tinyint(1) unsigned DEFAULT '0' COMMENT '自动设置开关',
  `next_time` bigint(11) unsigned DEFAULT '0' COMMENT '下次可释放技能时间',
  PRIMARY KEY (`player_id`,`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='技能表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill`
--

LOCK TABLES `skill` WRITE;
/*!40000 ALTER TABLE `skill` DISABLE KEYS */;
/*!40000 ALTER TABLE `skill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `special_drop`
--

DROP TABLE IF EXISTS `special_drop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `special_drop` (
  `drop_type` int(11) unsigned NOT NULL COMMENT '掉落类型',
  `drop_num` int(11) NOT NULL COMMENT '掉落数量',
  `next_time` int(11) NOT NULL COMMENT '下次掉落刷新时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`drop_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='特殊掉落表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `special_drop`
--

LOCK TABLES `special_drop` WRITE;
/*!40000 ALTER TABLE `special_drop` DISABLE KEYS */;
/*!40000 ALTER TABLE `special_drop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_log`
--

DROP TABLE IF EXISTS `test_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_log`
--

LOCK TABLES `test_log` WRITE;
/*!40000 ALTER TABLE `test_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `test_log` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-21 16:40:50
