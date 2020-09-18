-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 10, 2019 at 08:37 AM
-- Server version: 5.7.26
-- PHP Version: 7.0.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pos`
--

-- --------------------------------------------------------

--
-- Table structure for table `sma_addresses`
--

DROP TABLE IF EXISTS `sma_addresses`;
CREATE TABLE IF NOT EXISTS `sma_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `line1` varchar(50) NOT NULL,
  `line2` varchar(50) DEFAULT NULL,
  `city` varchar(25) NOT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `state` varchar(25) NOT NULL,
  `country` varchar(50) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_adjustments`
--

DROP TABLE IF EXISTS `sma_adjustments`;
CREATE TABLE IF NOT EXISTS `sma_adjustments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `note` text,
  `attachment` varchar(55) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `count_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_adjustment_items`
--

DROP TABLE IF EXISTS `sma_adjustment_items`;
CREATE TABLE IF NOT EXISTS `sma_adjustment_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `adjustment_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `adjustment_id` (`adjustment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_brands`
--

DROP TABLE IF EXISTS `sma_brands`;
CREATE TABLE IF NOT EXISTS `sma_brands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `image` varchar(50) DEFAULT NULL,
  `slug` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_brands`
--

INSERT INTO `sma_brands` (`id`, `code`, `name`, `image`, `slug`) VALUES
(1, '4', 'Lar', NULL, 'lar');

-- --------------------------------------------------------

--
-- Table structure for table `sma_calendar`
--

DROP TABLE IF EXISTS `sma_calendar`;
CREATE TABLE IF NOT EXISTS `sma_calendar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(55) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `start` datetime NOT NULL,
  `end` datetime DEFAULT NULL,
  `color` varchar(7) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_calendar`
--

INSERT INTO `sma_calendar` (`id`, `title`, `description`, `start`, `end`, `color`, `user_id`) VALUES
(1, 'Birthday Reminder', 'Birthday Reminder', '2019-06-01 00:00:00', '2019-06-02 00:00:00', '#00f0ff', 1);

-- --------------------------------------------------------

--
-- Table structure for table `sma_captcha`
--

DROP TABLE IF EXISTS `sma_captcha`;
CREATE TABLE IF NOT EXISTS `sma_captcha` (
  `captcha_id` bigint(13) UNSIGNED NOT NULL AUTO_INCREMENT,
  `captcha_time` int(10) UNSIGNED NOT NULL,
  `ip_address` varchar(16) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `word` varchar(20) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`captcha_id`),
  KEY `word` (`word`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_categories`
--

DROP TABLE IF EXISTS `sma_categories`;
CREATE TABLE IF NOT EXISTS `sma_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(55) NOT NULL,
  `name` varchar(55) NOT NULL,
  `image` varchar(55) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `slug` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_categories`
--

INSERT INTO `sma_categories` (`id`, `code`, `name`, `image`, `parent_id`, `slug`) VALUES
(1, 'C1', 'Wood', NULL, 0, 'wood'),
(3, 'C2', 'Bottle', NULL, 0, 'bottle');

-- --------------------------------------------------------

--
-- Table structure for table `sma_combo_items`
--

DROP TABLE IF EXISTS `sma_combo_items`;
CREATE TABLE IF NOT EXISTS `sma_combo_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `item_code` varchar(20) NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_companies`
--

DROP TABLE IF EXISTS `sma_companies`;
CREATE TABLE IF NOT EXISTS `sma_companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(10) UNSIGNED DEFAULT NULL,
  `group_name` varchar(20) NOT NULL,
  `customer_group_id` int(11) DEFAULT NULL,
  `customer_group_name` varchar(100) DEFAULT NULL,
  `name` varchar(55) NOT NULL,
  `company` varchar(255) NOT NULL,
  `vat_no` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(55) DEFAULT NULL,
  `state` varchar(55) DEFAULT NULL,
  `postal_code` varchar(8) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `cf1` varchar(100) DEFAULT NULL,
  `cf2` varchar(100) DEFAULT NULL,
  `cf3` varchar(100) DEFAULT NULL,
  `cf4` varchar(100) DEFAULT NULL,
  `cf5` varchar(100) DEFAULT NULL,
  `cf6` varchar(100) DEFAULT NULL,
  `invoice_footer` text,
  `payment_term` int(11) DEFAULT '0',
  `logo` varchar(255) DEFAULT 'logo.png',
  `award_points` int(11) DEFAULT '0',
  `deposit_amount` decimal(25,4) DEFAULT NULL,
  `price_group_id` int(11) DEFAULT NULL,
  `price_group_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `group_id_2` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_companies`
--

INSERT INTO `sma_companies` (`id`, `group_id`, `group_name`, `customer_group_id`, `customer_group_name`, `name`, `company`, `vat_no`, `address`, `city`, `state`, `postal_code`, `country`, `phone`, `email`, `cf1`, `cf2`, `cf3`, `cf4`, `cf5`, `cf6`, `invoice_footer`, `payment_term`, `logo`, `award_points`, `deposit_amount`, `price_group_id`, `price_group_name`) VALUES
(1, 3, 'customer', 1, 'General', 'Walk-in Customer', 'Walk-in Customer', '', 'Customer Address', 'Petaling Jaya', 'Selangor', '46000', 'Malaysia', '0123456789', 'customer@tecdiary.com', '', '', '', '', '', '', NULL, 0, 'logo.png', 0, NULL, NULL, NULL),
(2, 4, 'supplier', NULL, NULL, 'Arslan', 'Shaheen Traders', '', 'street 12 I-10/4 Islamabad', 'Islamabad', 'Punjab', '46050', 'Pakistan', '03005847585', 'Arslan@yahoo.com', '-', '-', '-', '-', '-', '-', NULL, 0, 'logo.png', 0, NULL, NULL, NULL),
(3, NULL, 'biller', NULL, NULL, 'Mian Saleem', 'Test Biller', '5555', 'Biller adddress', 'City', '', '', 'Country', '012345678', 'saleem@tecdiary.com', '', '', '', '', '', '', ' Thank you for shopping with us. Please come again', 0, 'logo1.png', 0, NULL, NULL, NULL),
(4, 3, 'customer', 1, 'General', 'Zia', 'Wood Traders', '', 'shop 34, Iqbal road islamabad', 'islamabad', 'punjab', '', '', '051', 'zia@yahoo.com', '', '', '', '', '', '', NULL, 0, 'logo.png', 0, NULL, 1, 'Default'),
(5, NULL, 'biller', NULL, NULL, 'Haroon Bhai', 'Al Jannat Wood Works', '', 'street 5', 'rwp', '', '', '', '0300', 'haroon@yahoo.com', '', '', '', '', '', '', '', 0, 'logo1.png', 0, NULL, NULL, NULL),
(6, 3, 'customer', 1, 'General', 'Ahsan', 'Graystork', '', 'rwp', 'rwp', '', '', '', '0334', 'ahsan@yahoo.com', '', '', '', '', '', '', NULL, 0, 'logo.png', 0, NULL, 1, 'Default'),
(7, 4, 'supplier', NULL, NULL, 'Iqbal', 'Awan Wood', '', 'islamabad', 'islamabad', '', '', '', '051', 'iqbal@yahoo.com', '', '', '', '', '', '', NULL, 0, 'logo.png', 0, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_costing`
--

DROP TABLE IF EXISTS `sma_costing`;
CREATE TABLE IF NOT EXISTS `sma_costing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `sale_item_id` int(11) NOT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `purchase_item_id` int(11) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `purchase_net_unit_cost` decimal(25,4) DEFAULT NULL,
  `purchase_unit_cost` decimal(25,4) DEFAULT NULL,
  `sale_net_unit_price` decimal(25,4) NOT NULL,
  `sale_unit_price` decimal(25,4) NOT NULL,
  `quantity_balance` decimal(15,4) DEFAULT NULL,
  `inventory` tinyint(1) DEFAULT '0',
  `overselling` tinyint(1) DEFAULT '0',
  `option_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_costing`
--

INSERT INTO `sma_costing` (`id`, `date`, `product_id`, `sale_item_id`, `sale_id`, `purchase_item_id`, `quantity`, `purchase_net_unit_cost`, `purchase_unit_cost`, `sale_net_unit_price`, `sale_unit_price`, `quantity_balance`, `inventory`, `overselling`, `option_id`) VALUES
(36, '2019-06-30', 21, 41, 33, 31, '12.0000', '0.0000', '0.0000', '10.0000', '10.0000', '0.0000', 1, 0, NULL),
(37, '2019-06-30', 21, 41, 33, 29, '12.0000', '0.0000', '0.0000', '10.0000', '10.0000', '0.0000', 1, 0, NULL),
(38, '2019-06-30', 21, 42, 34, 32, '1.0000', '10.0000', '10.0000', '10.0000', '10.0000', '24.0000', 1, 0, NULL),
(39, '2019-06-30', 21, 43, 34, 32, '1.0000', '10.0000', '10.0000', '5.0000', '5.0000', '24.0000', 1, 0, NULL),
(40, '2019-06-30', 22, 44, 34, 30, '5.0000', '0.0000', '0.0000', '20.0000', '20.0000', '20.0000', 1, 0, NULL),
(41, '2019-06-30', 21, 45, 34, 32, '1.0000', '10.0000', '10.0000', '30.0000', '30.0000', '24.0000', 1, 0, NULL),
(42, '2019-07-01', 21, 46, 35, 32, '10.0000', '10.0000', '10.0000', '10.0000', '10.0000', '12.0000', 1, 0, NULL),
(43, '2019-07-01', 21, 48, 37, 32, '12.0000', '10.0000', '10.0000', '10.0000', '10.0000', '0.0000', 1, 0, NULL),
(44, '2019-07-01', 21, 51, 39, 33, '12.0000', '10.0000', '10.0000', '100.0000', '100.0000', '13.0000', 1, 0, NULL),
(45, '2019-07-04', 22, 52, 40, 30, '18.0000', '0.0000', '0.0000', '10.0000', '10.0000', '2.0000', 1, 0, NULL),
(46, '2019-07-04', 22, 53, 41, 30, '1.0000', '0.0000', '0.0000', '100.0000', '100.0000', '1.0000', 1, 0, NULL),
(47, '2019-07-08', 21, 54, 42, 39, '1.0000', '5.0000', '5.0000', '1000.0000', '1000.0000', '9.0000', 1, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_currencies`
--

DROP TABLE IF EXISTS `sma_currencies`;
CREATE TABLE IF NOT EXISTS `sma_currencies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(5) NOT NULL,
  `name` varchar(55) NOT NULL,
  `rate` decimal(12,4) NOT NULL,
  `auto_update` tinyint(1) NOT NULL DEFAULT '0',
  `symbol` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_currencies`
--

INSERT INTO `sma_currencies` (`id`, `code`, `name`, `rate`, `auto_update`, `symbol`) VALUES
(1, 'USD', 'US Dollar', '1.0000', 0, NULL),
(2, 'ERU', 'EURO', '0.7340', 0, NULL),
(3, 'PKR', 'Rupees', '100.0000', 0, 'rs');

-- --------------------------------------------------------

--
-- Table structure for table `sma_customer_groups`
--

DROP TABLE IF EXISTS `sma_customer_groups`;
CREATE TABLE IF NOT EXISTS `sma_customer_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `percent` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_customer_groups`
--

INSERT INTO `sma_customer_groups` (`id`, `name`, `percent`) VALUES
(1, 'General', 0),
(2, 'Reseller', -5),
(3, 'Distributor', -15),
(4, 'New Customer (+10)', 10);

-- --------------------------------------------------------

--
-- Table structure for table `sma_date_format`
--

DROP TABLE IF EXISTS `sma_date_format`;
CREATE TABLE IF NOT EXISTS `sma_date_format` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `js` varchar(20) NOT NULL,
  `php` varchar(20) NOT NULL,
  `sql` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_date_format`
--

INSERT INTO `sma_date_format` (`id`, `js`, `php`, `sql`) VALUES
(1, 'mm-dd-yyyy', 'm-d-Y', '%m-%d-%Y'),
(2, 'mm/dd/yyyy', 'm/d/Y', '%m/%d/%Y'),
(3, 'mm.dd.yyyy', 'm.d.Y', '%m.%d.%Y'),
(4, 'dd-mm-yyyy', 'd-m-Y', '%d-%m-%Y'),
(5, 'dd/mm/yyyy', 'd/m/Y', '%d/%m/%Y'),
(6, 'dd.mm.yyyy', 'd.m.Y', '%d.%m.%Y');

-- --------------------------------------------------------

--
-- Table structure for table `sma_deliveries`
--

DROP TABLE IF EXISTS `sma_deliveries`;
CREATE TABLE IF NOT EXISTS `sma_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sale_id` int(11) NOT NULL,
  `do_reference_no` varchar(50) NOT NULL,
  `sale_reference_no` varchar(50) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `address` varchar(1000) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `attachment` varchar(50) DEFAULT NULL,
  `delivered_by` varchar(50) DEFAULT NULL,
  `received_by` varchar(50) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_deposits`
--

DROP TABLE IF EXISTS `sma_deposits`;
CREATE TABLE IF NOT EXISTS `sma_deposits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `company_id` int(11) NOT NULL,
  `amount` decimal(25,4) NOT NULL,
  `paid_by` varchar(50) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_expenses`
--

DROP TABLE IF EXISTS `sma_expenses`;
CREATE TABLE IF NOT EXISTS `sma_expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference` varchar(50) NOT NULL,
  `amount` decimal(25,4) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `created_by` varchar(55) NOT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_expense_categories`
--

DROP TABLE IF EXISTS `sma_expense_categories`;
CREATE TABLE IF NOT EXISTS `sma_expense_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(55) NOT NULL,
  `name` varchar(55) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_expense_categories`
--

INSERT INTO `sma_expense_categories` (`id`, `code`, `name`) VALUES
(1, '3', 'Computer');

-- --------------------------------------------------------

--
-- Table structure for table `sma_extra_sale`
--

DROP TABLE IF EXISTS `sma_extra_sale`;
CREATE TABLE IF NOT EXISTS `sma_extra_sale` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_code` varchar(50) NOT NULL,
  `product_name` char(255) NOT NULL,
  `price` decimal(25,4) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(255) DEFAULT NULL,
  `created_by` varchar(55) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `card_no` (`product_code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_extra_sale`
--

INSERT INTO `sma_extra_sale` (`id`, `date`, `product_code`, `product_name`, `price`, `supplier_id`, `supplier`, `created_by`) VALUES
(1, '0000-00-00 00:00:00', '46710553', 'Lar', '100.0000', 2, 'Shaheen Traders-Arslan', '2'),
(2, '2019-07-01 10:05:07', '03396395', 'Lar', '4500.0000', 2, 'Shaheen Traders-Arslan', '2'),
(3, '2019-07-01 10:08:00', '71823679', 'Gillow', '4500.0000', 2, 'Shaheen Traders-Arslan', '2'),
(4, '2019-07-01 10:10:19', '55885712', 'Wood', '4500.0000', 2, 'Shaheen Traders-Arslan', '2'),
(5, '2019-07-01 10:12:50', '40088108', 'Samad', '500.0000', 2, 'Shaheen Traders-Arslan', '2'),
(6, '2019-07-01 10:21:52', '55242417', 'Samad', '450.0000', 2, 'Shaheen Traders-Arslan', '1'),
(7, '2019-07-05 09:42:05', '90176930', 'Samad', '40.0000', 2, 'Shaheen Traders-Arslan', '1');

-- --------------------------------------------------------

--
-- Table structure for table `sma_gift_cards`
--

DROP TABLE IF EXISTS `sma_gift_cards`;
CREATE TABLE IF NOT EXISTS `sma_gift_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `card_no` varchar(20) NOT NULL,
  `value` decimal(25,4) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(255) DEFAULT NULL,
  `balance` decimal(25,4) NOT NULL,
  `expiry` date DEFAULT NULL,
  `created_by` varchar(55) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `card_no` (`card_no`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_gift_cards`
--

INSERT INTO `sma_gift_cards` (`id`, `date`, `card_no`, `value`, `customer_id`, `customer`, `balance`, `expiry`, `created_by`) VALUES
(1, '2019-07-01 07:46:11', '3137852014444224', '0.0000', 1, 'Walk-in Customer', '0.0000', '2021-07-01', '1'),
(2, '2019-07-01 07:53:06', '4606495805599850', '0.0000', 4, 'Wood Traders', '0.0000', '2022-04-01', '1'),
(3, '2019-07-01 08:55:21', '3743612264483607', '0.0000', 4, 'Wood Traders', '0.0000', '2021-07-01', '1'),
(4, '2019-07-01 09:15:33', '1419534634642650', '0.0000', 6, 'Graystork', '0.0000', '2021-07-01', '1');

-- --------------------------------------------------------

--
-- Table structure for table `sma_gift_card_topups`
--

DROP TABLE IF EXISTS `sma_gift_card_topups`;
CREATE TABLE IF NOT EXISTS `sma_gift_card_topups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `card_id` int(11) NOT NULL,
  `amount` decimal(15,4) NOT NULL,
  `created_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `card_id` (`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_gift_card_topups`
--

INSERT INTO `sma_gift_card_topups` (`id`, `date`, `card_id`, `amount`, `created_by`) VALUES
(1, '2019-06-27 11:11:07', 2, '1200.0000', 1),
(2, '2019-06-27 11:11:18', 2, '1200.0000', 1),
(3, '2019-06-27 11:34:55', 2, '15000.0000', 1),
(4, '2019-06-27 11:42:15', 14, '15000.0000', 1),
(5, '2019-06-27 11:43:10', 14, '200.0000', 1);

-- --------------------------------------------------------

--
-- Table structure for table `sma_groups`
--

DROP TABLE IF EXISTS `sma_groups`;
CREATE TABLE IF NOT EXISTS `sma_groups` (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_groups`
--

INSERT INTO `sma_groups` (`id`, `name`, `description`) VALUES
(1, 'owner', 'Owner'),
(2, 'admin', 'Administrator'),
(3, 'customer', 'Customer'),
(4, 'supplier', 'Supplier'),
(5, 'sales', 'Sales Staff');

-- --------------------------------------------------------

--
-- Table structure for table `sma_login_attempts`
--

DROP TABLE IF EXISTS `sma_login_attempts`;
CREATE TABLE IF NOT EXISTS `sma_login_attempts` (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ip_address` varbinary(16) NOT NULL,
  `login` varchar(100) NOT NULL,
  `time` int(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_migrations`
--

DROP TABLE IF EXISTS `sma_migrations`;
CREATE TABLE IF NOT EXISTS `sma_migrations` (
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_migrations`
--

INSERT INTO `sma_migrations` (`version`) VALUES
(315);

-- --------------------------------------------------------

--
-- Table structure for table `sma_notifications`
--

DROP TABLE IF EXISTS `sma_notifications`;
CREATE TABLE IF NOT EXISTS `sma_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `from_date` datetime DEFAULT NULL,
  `till_date` datetime DEFAULT NULL,
  `scope` tinyint(1) NOT NULL DEFAULT '3',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_notifications`
--

INSERT INTO `sma_notifications` (`id`, `comment`, `date`, `from_date`, `till_date`, `scope`) VALUES
(2, '<p>Notifications</p>', '2019-06-18 13:01:50', '2019-06-18 18:00:00', '2019-06-23 18:05:00', 3);

-- --------------------------------------------------------

--
-- Table structure for table `sma_order_ref`
--

DROP TABLE IF EXISTS `sma_order_ref`;
CREATE TABLE IF NOT EXISTS `sma_order_ref` (
  `ref_id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `so` int(11) NOT NULL DEFAULT '1',
  `qu` int(11) NOT NULL DEFAULT '1',
  `po` int(11) NOT NULL DEFAULT '1',
  `to` int(11) NOT NULL DEFAULT '1',
  `pos` int(11) NOT NULL DEFAULT '1',
  `do` int(11) NOT NULL DEFAULT '1',
  `pay` int(11) NOT NULL DEFAULT '1',
  `re` int(11) NOT NULL DEFAULT '1',
  `rep` int(11) NOT NULL DEFAULT '1',
  `ex` int(11) NOT NULL DEFAULT '1',
  `ppay` int(11) NOT NULL DEFAULT '1',
  `qa` int(11) DEFAULT '1',
  PRIMARY KEY (`ref_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_order_ref`
--

INSERT INTO `sma_order_ref` (`ref_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `rep`, `ex`, `ppay`, `qa`) VALUES
(1, '2015-03-01', 1, 2, 18, 1, 43, 1, 40, 1, 1, 1, 40, 4);

-- --------------------------------------------------------

--
-- Table structure for table `sma_payments`
--

DROP TABLE IF EXISTS `sma_payments`;
CREATE TABLE IF NOT EXISTS `sma_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sale_id` int(11) DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `reference_no` varchar(50) NOT NULL,
  `transaction_id` varchar(50) DEFAULT NULL,
  `paid_by` varchar(20) NOT NULL,
  `cheque_no` varchar(20) DEFAULT NULL,
  `cc_no` varchar(20) DEFAULT NULL,
  `cc_holder` varchar(25) DEFAULT NULL,
  `cc_month` varchar(2) DEFAULT NULL,
  `cc_year` varchar(4) DEFAULT NULL,
  `cc_type` varchar(20) DEFAULT NULL,
  `amount` decimal(25,4) NOT NULL,
  `currency` varchar(3) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `type` varchar(20) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `pos_paid` decimal(25,4) DEFAULT '0.0000',
  `pos_balance` decimal(25,4) DEFAULT '0.0000',
  `approval_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_payments`
--

INSERT INTO `sma_payments` (`id`, `date`, `sale_id`, `return_id`, `purchase_id`, `supplier_id`, `reference_no`, `transaction_id`, `paid_by`, `cheque_no`, `cc_no`, `cc_holder`, `cc_month`, `cc_year`, `cc_type`, `amount`, `currency`, `created_by`, `attachment`, `type`, `note`, `pos_paid`, `pos_balance`, `approval_code`) VALUES
(35, '2019-06-30 11:43:41', 33, NULL, NULL, NULL, 'IPAY/2019/06/0030', NULL, 'cash', '', '', '', '', '', '', '240.0000', NULL, 1, NULL, 'received', '', '240.0000', '0.0000', NULL),
(36, '2019-06-30 11:47:10', 34, NULL, NULL, NULL, 'IPAY/2019/06/0031', NULL, 'cash', '', '', '', '', '', '', '145.0000', NULL, 1, NULL, 'received', '', '145.0000', '0.0000', NULL),
(37, '2019-07-01 03:43:12', 35, NULL, NULL, NULL, 'IPAY/2019/07/0032', NULL, 'cash', '', '', '', '', '', '', '100.0000', NULL, 1, NULL, 'received', '', '100.0000', '0.0000', NULL),
(38, '2019-07-01 03:48:05', 36, NULL, NULL, NULL, 'IPAY/2019/07/0033', NULL, 'cash', '', '', '', '', '', '', '10.0000', NULL, 1, NULL, 'received', '', '10.0000', '0.0000', NULL),
(39, '2019-07-01 03:57:46', 37, NULL, NULL, NULL, 'IPAY/2019/07/0034', NULL, 'cash', '', '', '', '', '', '', '120.0000', NULL, 1, NULL, 'received', '', '120.0000', '0.0000', NULL),
(40, '2019-07-01 10:10:35', 38, NULL, NULL, NULL, 'IPAY/2019/07/0035', NULL, 'cash', '', '', '', '', '', '', '4500.0000', NULL, 2, NULL, 'received', '', '4500.0000', '0.0000', NULL),
(41, '2019-07-01 10:22:12', 39, NULL, NULL, NULL, 'IPAY/2019/07/0036', NULL, 'cash', '', '', '', '', '', '', '1650.0000', NULL, 1, NULL, 'received', '', '1650.0000', '0.0000', NULL),
(42, '2019-07-04 01:42:04', 40, NULL, NULL, NULL, 'IPAY/2019/07/0037', NULL, 'cash', '', '', '', '', '', '', '180.0000', NULL, 1, NULL, 'received', '', '180.0000', '0.0000', NULL),
(43, '2019-07-04 01:42:57', 41, NULL, NULL, NULL, 'IPAY/2019/07/0038', NULL, 'cash', '', '', '', '', '', '', '100.0000', NULL, 1, NULL, 'received', '', '100.0000', '0.0000', NULL),
(44, '2019-07-04 05:49:00', NULL, NULL, 12, NULL, 'POP/2019/07/0006', NULL, 'cash', '', '', '', '', '', 'Visa', '250.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(45, '2019-07-04 05:49:00', NULL, NULL, 11, NULL, 'POP/2019/07/0007', NULL, 'cash', '', '', '', '', '', 'Visa', '2500.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(46, '2019-07-04 05:52:00', NULL, NULL, 13, NULL, 'POP/2019/07/0008', NULL, 'cash', '', '', '', '', '', 'Visa', '0.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(47, '2019-07-04 07:43:00', NULL, NULL, 10, NULL, 'POP/2019/07/0009', NULL, 'cash', '', '', '', '', '', 'Visa', '12000.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(49, '2019-07-04 07:45:00', NULL, NULL, 16, NULL, 'POP/2019/07/0011', NULL, 'cash', '', '', '', '', '', 'Visa', '30.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(50, '2019-07-04 07:45:00', NULL, NULL, 16, NULL, 'POP/2019/07/0012', NULL, 'cash', '', '', '', '', '', 'Visa', '10.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(51, '2019-07-04 07:55:00', NULL, NULL, 16, NULL, 'POP/2019/07/0013', NULL, 'cash', '', '', '', '', '', 'Visa', '10.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(52, '2019-07-04 08:57:00', NULL, NULL, 16, NULL, 'POP/2019/07/0014', NULL, 'cash', '', '', '', '', '', 'Visa', '1.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(53, '2019-07-04 08:58:00', NULL, NULL, 16, NULL, 'POP/2019/07/0015', NULL, 'cash', '', '', '', '', '', 'Visa', '1.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(54, '2019-07-04 09:46:00', NULL, NULL, 16, NULL, 'POP/2019/07/0016', NULL, 'cash', '', '', '', '', '', 'Visa', '0.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(55, '2019-07-05 11:05:00', NULL, NULL, 17, NULL, 'POP/2019/07/0017', NULL, 'cash', '', '', '', '', '', 'Visa', '10.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(56, '2019-07-05 11:05:00', NULL, NULL, NULL, 2, 'POP/2019/07/0017', NULL, 'cash', '', '', '', '', '', 'Visa', '123.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(57, '2019-07-08 12:55:09', 42, NULL, NULL, NULL, 'IPAY/2019/07/0039', NULL, 'cash', '', '', '', '', '', '', '1000.0000', NULL, 1, NULL, 'received', '', '1000.0000', '0.0000', NULL),
(58, '2019-07-09 13:17:00', NULL, NULL, NULL, NULL, 'POP/2019/07/0018', NULL, 'cash', '', '', '', '', '', 'Visa', '200.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(59, '2019-07-10 06:57:00', NULL, NULL, NULL, NULL, 'POP/2019/07/0019', NULL, 'cash', '', '', '', '', '', 'Visa', '400.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(60, '2019-07-10 03:12:10', NULL, NULL, NULL, 0, 'POP/2019/07/0020', NULL, 'cash', '', '', '', '', '', 'Visa', '2.0000', NULL, 2, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(61, '2019-07-10 03:13:59', NULL, NULL, NULL, 0, 'POP/2019/07/0021', NULL, 'cash', '', '', '', '', '', 'Visa', '3.0000', NULL, 2, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(62, '2019-07-10 03:19:27', NULL, NULL, NULL, 2, 'POP/2019/07/0022', NULL, 'cash', '', '', '', '', '', 'Visa', '4.0000', NULL, 2, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(63, '2019-07-10 07:47:00', NULL, NULL, NULL, 0, 'POP/2019/07/0023', NULL, 'cash', '', '', '', '', '', 'Visa', '5.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(64, '2019-07-10 07:47:00', NULL, NULL, NULL, 0, 'POP/2019/07/0024', NULL, 'cash', '', '', '', '', '', 'Visa', '6.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(65, '2019-07-10 07:48:00', NULL, NULL, NULL, 2, 'POP/2019/07/0025', NULL, 'cash', '', '', '', '', '', 'Visa', '7.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(66, '2019-07-10 07:50:00', NULL, NULL, NULL, 2, 'POP/2019/07/0026', NULL, 'cash', '', '', '', '', '', 'Visa', '8.0000', NULL, 4, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(67, '2019-07-10 07:58:00', NULL, NULL, NULL, 0, 'POP/2019/07/0027', NULL, 'cash', '', '', '', '', '', 'Visa', '10.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(68, '2019-07-10 07:59:00', NULL, NULL, NULL, 0, 'POP/2019/07/0028', NULL, 'cash', '', '', '', '', '', 'Visa', '11.0000', NULL, 1, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(69, '2019-07-10 08:11:00', NULL, NULL, NULL, NULL, 'POP/2019/07/0029', NULL, 'cash', '', '', '', '', '', 'Visa', '11.0000', NULL, 4, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(70, '2019-07-10 08:12:00', NULL, NULL, NULL, NULL, 'POP/2019/07/0030', NULL, 'cash', '', '', '', '', '', 'Visa', '12.0000', NULL, 4, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(71, '2019-07-10 08:13:00', NULL, NULL, NULL, 0, 'POP/2019/07/0031', NULL, 'cash', '', '', '', '', '', 'Visa', '13.0000', NULL, 4, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(72, '2019-07-10 08:14:00', NULL, NULL, NULL, 2, 'POP/2019/07/0032', NULL, 'cash', '', '', '', '', '', 'Visa', '14.0000', NULL, 4, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(73, '2019-07-10 08:20:00', NULL, NULL, NULL, 2, 'POP/2019/07/0033', NULL, 'cash', '', '', '', '', '', 'Visa', '15.0000', NULL, 4, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(74, '2019-07-10 08:20:00', NULL, NULL, NULL, 2, 'POP/2019/07/0034', NULL, 'cash', '', '', '', '', '', 'Visa', '16.0000', NULL, 4, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(75, '2019-07-10 04:21:22', NULL, NULL, NULL, 2, 'POP/2019/07/0035', NULL, 'cash', '', '', '', '', '', 'Visa', '17.0000', NULL, 2, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(76, '2019-07-10 04:21:31', NULL, NULL, NULL, 2, 'POP/2019/07/0036', NULL, 'cash', '', '', '', '', '', 'Visa', '18.0000', NULL, 2, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(77, '2019-07-10 04:23:06', NULL, NULL, NULL, 7, 'POP/2019/07/0037', NULL, 'cash', '', '', '', '', '', 'Visa', '19.0000', NULL, 2, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(78, '2019-07-10 04:23:29', NULL, NULL, NULL, 7, 'POP/2019/07/0038', NULL, 'cash', '', '', '', '', '', 'Visa', '20.0000', NULL, 2, NULL, 'sent', '', '0.0000', '0.0000', NULL),
(79, '2019-07-10 04:23:53', NULL, NULL, NULL, 2, 'POP/2019/07/0039', NULL, 'cash', '', '', '', '', '', 'Visa', '21.0000', NULL, 2, NULL, 'sent', '', '0.0000', '0.0000', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_paypal`
--

DROP TABLE IF EXISTS `sma_paypal`;
CREATE TABLE IF NOT EXISTS `sma_paypal` (
  `id` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `account_email` varchar(255) NOT NULL,
  `paypal_currency` varchar(3) NOT NULL DEFAULT 'USD',
  `fixed_charges` decimal(25,4) NOT NULL DEFAULT '2.0000',
  `extra_charges_my` decimal(25,4) NOT NULL DEFAULT '3.9000',
  `extra_charges_other` decimal(25,4) NOT NULL DEFAULT '4.4000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_paypal`
--

INSERT INTO `sma_paypal` (`id`, `active`, `account_email`, `paypal_currency`, `fixed_charges`, `extra_charges_my`, `extra_charges_other`) VALUES
(1, 1, 'mypaypal@paypal.com', 'USD', '0.0000', '0.0000', '0.0000');

-- --------------------------------------------------------

--
-- Table structure for table `sma_permissions`
--

DROP TABLE IF EXISTS `sma_permissions`;
CREATE TABLE IF NOT EXISTS `sma_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `products-index` tinyint(1) DEFAULT '0',
  `products-add` tinyint(1) DEFAULT '0',
  `products-edit` tinyint(1) DEFAULT '0',
  `products-delete` tinyint(1) DEFAULT '0',
  `products-cost` tinyint(1) DEFAULT '0',
  `products-price` tinyint(1) DEFAULT '0',
  `quotes-index` tinyint(1) DEFAULT '0',
  `quotes-add` tinyint(1) DEFAULT '0',
  `quotes-edit` tinyint(1) DEFAULT '0',
  `quotes-pdf` tinyint(1) DEFAULT '0',
  `quotes-email` tinyint(1) DEFAULT '0',
  `quotes-delete` tinyint(1) DEFAULT '0',
  `sales-index` tinyint(1) DEFAULT '0',
  `sales-add` tinyint(1) DEFAULT '0',
  `sales-edit` tinyint(1) DEFAULT '0',
  `sales-pdf` tinyint(1) DEFAULT '0',
  `sales-email` tinyint(1) DEFAULT '0',
  `sales-delete` tinyint(1) DEFAULT '0',
  `purchases-index` tinyint(1) DEFAULT '0',
  `purchases-add` tinyint(1) DEFAULT '0',
  `purchases-edit` tinyint(1) DEFAULT '0',
  `purchases-pdf` tinyint(1) DEFAULT '0',
  `purchases-email` tinyint(1) DEFAULT '0',
  `purchases-delete` tinyint(1) DEFAULT '0',
  `purchases-supplier_payment` tinyint(1) DEFAULT '0',
  `purchases-add_supplier_payment` tinyint(1) DEFAULT '0',
  `transfers-index` tinyint(1) DEFAULT '0',
  `transfers-add` tinyint(1) DEFAULT '0',
  `transfers-edit` tinyint(1) DEFAULT '0',
  `transfers-pdf` tinyint(1) DEFAULT '0',
  `transfers-email` tinyint(1) DEFAULT '0',
  `transfers-delete` tinyint(1) DEFAULT '0',
  `customers-index` tinyint(1) DEFAULT '0',
  `customers-add` tinyint(1) DEFAULT '0',
  `customers-edit` tinyint(1) DEFAULT '0',
  `customers-delete` tinyint(1) DEFAULT '0',
  `suppliers-index` tinyint(1) DEFAULT '0',
  `suppliers-add` tinyint(1) DEFAULT '0',
  `suppliers-edit` tinyint(1) DEFAULT '0',
  `suppliers-delete` tinyint(1) DEFAULT '0',
  `sales-deliveries` tinyint(1) DEFAULT '0',
  `sales-add_delivery` tinyint(1) DEFAULT '0',
  `sales-edit_delivery` tinyint(1) DEFAULT '0',
  `sales-delete_delivery` tinyint(1) DEFAULT '0',
  `sales-email_delivery` tinyint(1) DEFAULT '0',
  `sales-pdf_delivery` tinyint(1) DEFAULT '0',
  `sales-gift_cards` tinyint(1) DEFAULT '0',
  `sales-extra_sale` tinyint(1) NOT NULL DEFAULT '0',
  `sales-add_gift_card` tinyint(1) DEFAULT '0',
  `sales-edit_gift_card` tinyint(1) DEFAULT '0',
  `sales-delete_gift_card` tinyint(1) DEFAULT '0',
  `pos-index` tinyint(1) DEFAULT '0',
  `sales-return_sales` tinyint(1) DEFAULT '0',
  `reports-index` tinyint(1) DEFAULT '0',
  `reports-warehouse_stock` tinyint(1) DEFAULT '0',
  `reports-quantity_alerts` tinyint(1) DEFAULT '0',
  `reports-expiry_alerts` tinyint(1) DEFAULT '0',
  `reports-products` tinyint(1) DEFAULT '0',
  `reports-daily_sales` tinyint(1) DEFAULT '0',
  `reports-monthly_sales` tinyint(1) DEFAULT '0',
  `reports-sales` tinyint(1) DEFAULT '0',
  `reports-payments` tinyint(1) DEFAULT '0',
  `reports-purchases` tinyint(1) DEFAULT '0',
  `reports-profit_loss` tinyint(1) DEFAULT '0',
  `reports-customers` tinyint(1) DEFAULT '0',
  `reports-suppliers` tinyint(1) DEFAULT '0',
  `reports-staff` tinyint(1) DEFAULT '0',
  `reports-register` tinyint(1) DEFAULT '0',
  `sales-payments` tinyint(1) DEFAULT '0',
  `purchases-payments` tinyint(1) DEFAULT '0',
  `purchases-expenses` tinyint(1) DEFAULT '0',
  `products-adjustments` tinyint(1) NOT NULL DEFAULT '0',
  `bulk_actions` tinyint(1) NOT NULL DEFAULT '0',
  `customers-deposits` tinyint(1) NOT NULL DEFAULT '0',
  `customers-delete_deposit` tinyint(1) NOT NULL DEFAULT '0',
  `products-barcode` tinyint(1) NOT NULL DEFAULT '0',
  `purchases-return_purchases` tinyint(1) NOT NULL DEFAULT '0',
  `reports-expenses` tinyint(1) NOT NULL DEFAULT '0',
  `reports-daily_purchases` tinyint(1) DEFAULT '0',
  `reports-monthly_purchases` tinyint(1) DEFAULT '0',
  `products-stock_count` tinyint(1) DEFAULT '0',
  `edit_price` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_permissions`
--

INSERT INTO `sma_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `purchases-supplier_payment`, `purchases-add_supplier_payment`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-extra_sale`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `products-adjustments`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-barcode`, `purchases-return_purchases`, `reports-expenses`, `reports-daily_purchases`, `reports-monthly_purchases`, `products-stock_count`, `edit_price`) VALUES
(1, 5, 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, NULL, 1, 1, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 1, 1, 1, NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, NULL, 1, NULL, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_pos_register`
--

DROP TABLE IF EXISTS `sma_pos_register`;
CREATE TABLE IF NOT EXISTS `sma_pos_register` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `cash_in_hand` decimal(25,4) NOT NULL,
  `status` varchar(10) NOT NULL,
  `total_cash` decimal(25,4) DEFAULT NULL,
  `total_cheques` int(11) DEFAULT NULL,
  `total_cc_slips` int(11) DEFAULT NULL,
  `total_cash_submitted` decimal(25,4) DEFAULT NULL,
  `total_cheques_submitted` int(11) DEFAULT NULL,
  `total_cc_slips_submitted` int(11) DEFAULT NULL,
  `note` text,
  `closed_at` timestamp NULL DEFAULT NULL,
  `transfer_opened_bills` varchar(50) DEFAULT NULL,
  `closed_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_pos_register`
--

INSERT INTO `sma_pos_register` (`id`, `date`, `user_id`, `cash_in_hand`, `status`, `total_cash`, `total_cheques`, `total_cc_slips`, `total_cash_submitted`, `total_cheques_submitted`, `total_cc_slips_submitted`, `note`, `closed_at`, `transfer_opened_bills`, `closed_by`) VALUES
(1, '2019-06-19 06:35:30', 2, '0.0000', 'close', '0.0000', 0, 0, '0.0000', 0, 0, '', '2019-06-27 09:55:44', NULL, 1),
(2, '2019-06-20 07:04:51', 1, '0.0000', 'open', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, '2019-06-27 11:31:35', 2, '0.0000', 'open', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, '2019-07-01 05:24:12', 4, '0.0000', 'open', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, '2019-07-01 05:26:51', 3, '0.0000', 'open', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_pos_settings`
--

DROP TABLE IF EXISTS `sma_pos_settings`;
CREATE TABLE IF NOT EXISTS `sma_pos_settings` (
  `pos_id` int(1) NOT NULL,
  `cat_limit` int(11) NOT NULL,
  `pro_limit` int(11) NOT NULL,
  `default_category` int(11) NOT NULL,
  `default_customer` int(11) NOT NULL,
  `default_biller` int(11) NOT NULL,
  `display_time` varchar(3) NOT NULL DEFAULT 'yes',
  `cf_title1` varchar(255) DEFAULT NULL,
  `cf_title2` varchar(255) DEFAULT NULL,
  `cf_value1` varchar(255) DEFAULT NULL,
  `cf_value2` varchar(255) DEFAULT NULL,
  `receipt_printer` varchar(55) DEFAULT NULL,
  `cash_drawer_codes` varchar(55) DEFAULT NULL,
  `focus_add_item` varchar(55) DEFAULT NULL,
  `add_manual_product` varchar(55) DEFAULT NULL,
  `customer_selection` varchar(55) DEFAULT NULL,
  `add_customer` varchar(55) DEFAULT NULL,
  `toggle_category_slider` varchar(55) DEFAULT NULL,
  `toggle_subcategory_slider` varchar(55) DEFAULT NULL,
  `cancel_sale` varchar(55) DEFAULT NULL,
  `suspend_sale` varchar(55) DEFAULT NULL,
  `print_items_list` varchar(55) DEFAULT NULL,
  `finalize_sale` varchar(55) DEFAULT NULL,
  `today_sale` varchar(55) DEFAULT NULL,
  `open_hold_bills` varchar(55) DEFAULT NULL,
  `close_register` varchar(55) DEFAULT NULL,
  `keyboard` tinyint(1) NOT NULL,
  `pos_printers` varchar(255) DEFAULT NULL,
  `java_applet` tinyint(1) NOT NULL,
  `product_button_color` varchar(20) NOT NULL DEFAULT 'default',
  `tooltips` tinyint(1) DEFAULT '1',
  `paypal_pro` tinyint(1) DEFAULT '0',
  `stripe` tinyint(1) DEFAULT '0',
  `rounding` tinyint(1) DEFAULT '0',
  `char_per_line` tinyint(4) DEFAULT '42',
  `pin_code` varchar(20) DEFAULT NULL,
  `purchase_code` varchar(100) DEFAULT 'purchase_code',
  `envato_username` varchar(50) DEFAULT 'envato_username',
  `version` varchar(10) DEFAULT '3.2.10',
  `after_sale_page` tinyint(1) DEFAULT '0',
  `item_order` tinyint(1) DEFAULT '0',
  `authorize` tinyint(1) DEFAULT '0',
  `toggle_brands_slider` varchar(55) DEFAULT NULL,
  `remote_printing` tinyint(1) DEFAULT '1',
  `printer` int(11) DEFAULT NULL,
  `order_printers` varchar(55) DEFAULT NULL,
  `auto_print` tinyint(1) DEFAULT '0',
  `customer_details` tinyint(1) DEFAULT NULL,
  `local_printers` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`pos_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_pos_settings`
--

INSERT INTO `sma_pos_settings` (`pos_id`, `cat_limit`, `pro_limit`, `default_category`, `default_customer`, `default_biller`, `display_time`, `cf_title1`, `cf_title2`, `cf_value1`, `cf_value2`, `receipt_printer`, `cash_drawer_codes`, `focus_add_item`, `add_manual_product`, `customer_selection`, `add_customer`, `toggle_category_slider`, `toggle_subcategory_slider`, `cancel_sale`, `suspend_sale`, `print_items_list`, `finalize_sale`, `today_sale`, `open_hold_bills`, `close_register`, `keyboard`, `pos_printers`, `java_applet`, `product_button_color`, `tooltips`, `paypal_pro`, `stripe`, `rounding`, `char_per_line`, `pin_code`, `purchase_code`, `envato_username`, `version`, `after_sale_page`, `item_order`, `authorize`, `toggle_brands_slider`, `remote_printing`, `printer`, `order_printers`, `auto_print`, `customer_details`, `local_printers`) VALUES
(1, 22, 20, 1, 1, 3, '1', 'GST Reg', 'VAT Reg', '123456789', '987654321', NULL, 'x1C', 'Ctrl+F3', 'Ctrl+Shift+M', 'Ctrl+Shift+C', 'Ctrl+Shift+A', 'Ctrl+F11', 'Ctrl+F12', 'F4', 'F7', 'F9', 'F8', 'Ctrl+F1', 'Ctrl+F2', 'Ctrl+F10', 0, NULL, 0, 'default', 1, 0, 0, 0, 42, NULL, 'purchase_code', 'envato_username', '3.2.10', 0, 0, 0, '', 1, NULL, 'null', 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `sma_price_groups`
--

DROP TABLE IF EXISTS `sma_price_groups`;
CREATE TABLE IF NOT EXISTS `sma_price_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_price_groups`
--

INSERT INTO `sma_price_groups` (`id`, `name`) VALUES
(1, 'Default');

-- --------------------------------------------------------

--
-- Table structure for table `sma_printers`
--

DROP TABLE IF EXISTS `sma_printers`;
CREATE TABLE IF NOT EXISTS `sma_printers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(55) NOT NULL,
  `type` varchar(25) NOT NULL,
  `profile` varchar(25) NOT NULL,
  `char_per_line` tinyint(3) UNSIGNED DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `ip_address` varbinary(45) DEFAULT NULL,
  `port` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_products`
--

DROP TABLE IF EXISTS `sma_products`;
CREATE TABLE IF NOT EXISTS `sma_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` char(255) NOT NULL,
  `unit` int(11) DEFAULT NULL,
  `cost` decimal(25,4) DEFAULT NULL,
  `price` decimal(25,4) NOT NULL,
  `alert_quantity` decimal(15,4) DEFAULT '20.0000',
  `image` varchar(255) DEFAULT 'no_image.png',
  `category_id` int(11) NOT NULL,
  `subcategory_id` int(11) DEFAULT NULL,
  `cf1` varchar(255) DEFAULT NULL,
  `cf2` varchar(255) DEFAULT NULL,
  `cf3` varchar(255) DEFAULT NULL,
  `cf4` varchar(255) DEFAULT NULL,
  `cf5` varchar(255) DEFAULT NULL,
  `cf6` varchar(255) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `tax_rate` int(11) DEFAULT NULL,
  `track_quantity` tinyint(1) DEFAULT '1',
  `details` varchar(1000) DEFAULT NULL,
  `warehouse` int(11) DEFAULT NULL,
  `barcode_symbology` varchar(55) NOT NULL DEFAULT 'code128',
  `file` varchar(100) DEFAULT NULL,
  `product_details` text,
  `tax_method` tinyint(1) DEFAULT '0',
  `type` varchar(55) NOT NULL DEFAULT 'standard',
  `product_type` varchar(55) NOT NULL DEFAULT 'hardware',
  `supplier1` int(11) DEFAULT NULL,
  `supplier1price` decimal(25,4) DEFAULT NULL,
  `supplier2` int(11) DEFAULT NULL,
  `supplier2price` decimal(25,4) DEFAULT NULL,
  `supplier3` int(11) DEFAULT NULL,
  `supplier3price` decimal(25,4) DEFAULT NULL,
  `supplier4` int(11) DEFAULT NULL,
  `supplier4price` decimal(25,4) DEFAULT NULL,
  `supplier5` int(11) DEFAULT NULL,
  `supplier5price` decimal(25,4) DEFAULT NULL,
  `promotion` tinyint(1) DEFAULT '0',
  `promo_price` decimal(25,4) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `supplier1_part_no` varchar(50) DEFAULT NULL,
  `supplier2_part_no` varchar(50) DEFAULT NULL,
  `supplier3_part_no` varchar(50) DEFAULT NULL,
  `supplier4_part_no` varchar(50) DEFAULT NULL,
  `supplier5_part_no` varchar(50) DEFAULT NULL,
  `sale_unit` int(11) DEFAULT NULL,
  `purchase_unit` int(11) DEFAULT NULL,
  `brand` int(11) DEFAULT NULL,
  `slug` varchar(55) DEFAULT NULL,
  `featured` tinyint(1) DEFAULT NULL,
  `weight` decimal(10,4) DEFAULT NULL,
  `hsn_code` int(11) DEFAULT NULL,
  `views` int(11) NOT NULL DEFAULT '0',
  `hide` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `category_id` (`category_id`),
  KEY `id` (`id`),
  KEY `id_2` (`id`),
  KEY `category_id_2` (`category_id`),
  KEY `unit` (`unit`),
  KEY `brand` (`brand`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_products`
--

INSERT INTO `sma_products` (`id`, `code`, `name`, `unit`, `cost`, `price`, `alert_quantity`, `image`, `category_id`, `subcategory_id`, `cf1`, `cf2`, `cf3`, `cf4`, `cf5`, `cf6`, `quantity`, `tax_rate`, `track_quantity`, `details`, `warehouse`, `barcode_symbology`, `file`, `product_details`, `tax_method`, `type`, `product_type`, `supplier1`, `supplier1price`, `supplier2`, `supplier2price`, `supplier3`, `supplier3price`, `supplier4`, `supplier4price`, `supplier5`, `supplier5price`, `promotion`, `promo_price`, `start_date`, `end_date`, `supplier1_part_no`, `supplier2_part_no`, `supplier3_part_no`, `supplier4_part_no`, `supplier5_part_no`, `sale_unit`, `purchase_unit`, `brand`, `slug`, `featured`, `weight`, `hsn_code`, `views`, `hide`) VALUES
(21, '22862990', 'sheet-شیت', 1, '0.0000', '0.0000', '0.0000', 'no_image.png', 1, NULL, '', '', '', '', '', '', '60.0000', 1, 1, '', NULL, 'code128', '', '', 1, 'standard', 'hardware', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, 1, 1, 0, 'sheet', NULL, '0.0000', NULL, 0, 0),
(22, '69503741', 'pepsi', 1, '0.0000', '0.0000', '2.0000', 'no_image.png', 3, NULL, '', '', '', '', '', '', '1.0000', 1, 1, '', NULL, 'code128', '', '', 1, 'standard', 'hardware', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, 1, 1, 0, 'pepsi', NULL, '0.0000', NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `sma_product_photos`
--

DROP TABLE IF EXISTS `sma_product_photos`;
CREATE TABLE IF NOT EXISTS `sma_product_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `photo` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_product_prices`
--

DROP TABLE IF EXISTS `sma_product_prices`;
CREATE TABLE IF NOT EXISTS `sma_product_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `price_group_id` int(11) NOT NULL,
  `price` decimal(25,4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `price_group_id` (`price_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_product_variants`
--

DROP TABLE IF EXISTS `sma_product_variants`;
CREATE TABLE IF NOT EXISTS `sma_product_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `name` varchar(55) NOT NULL,
  `cost` decimal(25,4) DEFAULT NULL,
  `price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_purchases`
--

DROP TABLE IF EXISTS `sma_purchases`;
CREATE TABLE IF NOT EXISTS `sma_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(55) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(11) NOT NULL,
  `supplier` varchar(55) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `note` varchar(1000) NOT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_discount` decimal(25,4) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT NULL,
  `product_tax` decimal(25,4) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `paid` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `status` varchar(55) DEFAULT '',
  `payment_status` varchar(20) DEFAULT 'pending',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `return_purchase_ref` varchar(55) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `return_purchase_total` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_purchases`
--

INSERT INTO `sma_purchases` (`id`, `reference_no`, `date`, `supplier_id`, `supplier`, `warehouse_id`, `note`, `total`, `product_discount`, `order_discount_id`, `order_discount`, `total_discount`, `product_tax`, `order_tax_id`, `order_tax`, `total_tax`, `shipping`, `grand_total`, `paid`, `status`, `payment_status`, `created_by`, `updated_by`, `updated_at`, `attachment`, `payment_term`, `due_date`, `return_id`, `surcharge`, `return_purchase_ref`, `purchase_id`, `return_purchase_total`, `cgst`, `sgst`, `igst`) VALUES
(10, 'PO/2019/06/0010', '2019-06-30 10:22:00', 2, 'Shaheen Traders', 1, '', '12000.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '12000.0000', '12000.0000', 'received', 'paid', 1, 1, '2019-07-04 01:50:55', NULL, 0, NULL, NULL, '0.0000', NULL, NULL, '0.0000', NULL, NULL, NULL),
(11, 'PO/2019/06/0011', '2019-06-30 15:44:00', 2, 'Shaheen Traders', 1, '', '250.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', NULL, '0.0000', '0.0000', '0.0000', '250.0000', '2500.0000', 'received', 'paid', 1, NULL, NULL, NULL, 0, NULL, NULL, '0.0000', NULL, NULL, '0.0000', NULL, NULL, NULL),
(12, 'PO/2019/07/0012', '2019-07-01 08:24:00', 2, 'Shaheen Traders', 1, '', '250.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', NULL, '0.0000', '0.0000', '0.0000', '250.0000', '250.0000', 'received', 'paid', 1, NULL, NULL, NULL, 0, NULL, NULL, '0.0000', NULL, NULL, '0.0000', NULL, NULL, NULL),
(13, 'PO/2019/07/0013', '2019-07-04 05:50:00', 2, 'Shaheen Traders', 1, '', '0.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', NULL, '0.0000', '0.0000', '0.0000', '0.0000', '0.0000', 'received', 'paid', 1, NULL, NULL, NULL, 0, NULL, NULL, '0.0000', NULL, NULL, '0.0000', NULL, NULL, NULL),
(14, 'PO/2019/07/0014', '2019-07-04 07:39:00', 2, 'Shaheen Traders', 1, '', '120.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', NULL, '0.0000', '0.0000', '0.0000', '120.0000', '0.0000', 'received', 'pending', 1, NULL, NULL, NULL, 0, NULL, NULL, '0.0000', NULL, NULL, '0.0000', NULL, NULL, NULL),
(15, 'PO/2019/07/0015', '2019-07-04 07:40:00', 2, 'Shaheen Traders', 1, '', '10.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', NULL, '0.0000', '0.0000', '0.0000', '10.0000', '2.0000', 'received', 'partial', 1, NULL, NULL, NULL, 0, NULL, NULL, '0.0000', NULL, NULL, '0.0000', NULL, NULL, NULL),
(16, 'PO/2019/07/0016', '2019-07-04 07:44:00', 2, 'Shaheen Traders', 1, '', '50.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', NULL, '0.0000', '0.0000', '0.0000', '50.0000', '50.0000', 'received', 'paid', 1, NULL, NULL, NULL, 0, NULL, NULL, '0.0000', NULL, NULL, '0.0000', NULL, NULL, NULL),
(17, 'PO/2019/07/0017', '2019-07-05 09:43:00', 2, 'Shaheen Traders', 1, '', '50.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', NULL, '0.0000', '0.0000', '0.0000', '50.0000', '10.0000', 'received', 'partial', 1, NULL, NULL, NULL, 0, NULL, NULL, '0.0000', NULL, NULL, '0.0000', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_purchase_items`
--

DROP TABLE IF EXISTS `sma_purchase_items`;
CREATE TABLE IF NOT EXISTS `sma_purchase_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_id` int(11) DEFAULT NULL,
  `transfer_id` int(11) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(50) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_cost` decimal(25,4) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(20) DEFAULT NULL,
  `discount` varchar(20) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `quantity_balance` decimal(15,4) DEFAULT '0.0000',
  `date` date NOT NULL,
  `status` varchar(50) NOT NULL,
  `unit_cost` decimal(25,4) DEFAULT NULL,
  `real_unit_cost` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) DEFAULT NULL,
  `supplier_part_no` varchar(50) DEFAULT NULL,
  `purchase_item_id` int(11) DEFAULT NULL,
  `product_unit_id` int(11) DEFAULT NULL,
  `product_unit_code` varchar(10) DEFAULT NULL,
  `unit_quantity` decimal(15,4) NOT NULL,
  `gst` varchar(20) DEFAULT NULL,
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_purchase_items`
--

INSERT INTO `sma_purchase_items` (`id`, `purchase_id`, `transfer_id`, `product_id`, `product_code`, `product_name`, `option_id`, `net_unit_cost`, `quantity`, `warehouse_id`, `item_tax`, `tax_rate_id`, `tax`, `discount`, `item_discount`, `expiry`, `subtotal`, `quantity_balance`, `date`, `status`, `unit_cost`, `real_unit_cost`, `quantity_received`, `supplier_part_no`, `purchase_item_id`, `product_unit_id`, `product_unit_code`, `unit_quantity`, `gst`, `cgst`, `sgst`, `igst`) VALUES
(29, NULL, NULL, 21, '22862989', 'sheet-شیت', NULL, '0.0000', '12.0000', 1, '0.0000', 1, '0.0000%', NULL, NULL, NULL, '0.0000', '0.0000', '2019-06-30', 'received', '0.0000', '0.0000', '12.0000', NULL, NULL, NULL, NULL, '0.0000', NULL, NULL, NULL, NULL),
(30, NULL, NULL, 22, '69503741', 'pepsi', NULL, '0.0000', '25.0000', 1, '0.0000', 1, '0.0000%', NULL, NULL, NULL, '0.0000', '1.0000', '2019-06-30', 'received', '0.0000', '0.0000', '25.0000', NULL, NULL, NULL, NULL, '0.0000', NULL, NULL, NULL, NULL),
(32, 11, NULL, 21, '22862987', 'sheet-شیت', NULL, '10.0000', '25.0000', 1, '0.0000', 1, '0', '0', '0.0000', NULL, '250.0000', '0.0000', '2019-06-30', 'received', '10.0000', '10.0000', '25.0000', NULL, NULL, 1, '09', '25.0000', NULL, NULL, NULL, NULL),
(33, 12, NULL, 21, '22862990', 'sheet-شیت', NULL, '10.0000', '25.0000', 1, '0.0000', 1, '0', '0', '0.0000', NULL, '250.0000', '13.0000', '2019-07-01', 'received', '10.0000', '10.0000', '25.0000', NULL, NULL, 1, '09', '25.0000', NULL, NULL, NULL, NULL),
(34, 13, NULL, 21, '22862990', 'sheet-شیت', NULL, '0.0000', '15.0000', 1, '0.0000', 1, '0', '0', '0.0000', NULL, '0.0000', '15.0000', '2019-07-04', 'received', '0.0000', '0.0000', '15.0000', NULL, NULL, 1, '09', '15.0000', NULL, NULL, NULL, NULL),
(35, 10, NULL, 21, '22862990', 'sheet-شیت', NULL, '1000.0000', '12.0000', 1, '0.0000', 1, '0', '0', '0.0000', NULL, '12000.0000', '0.0000', '2019-06-30', 'received', '1000.0000', '1000.0000', '12.0000', NULL, NULL, 1, '09', '12.0000', NULL, NULL, NULL, NULL),
(36, 14, NULL, 21, '22862990', 'sheet-شیت', NULL, '10.0000', '12.0000', 1, '0.0000', 1, '0', '0', '0.0000', NULL, '120.0000', '12.0000', '2019-07-04', 'received', '10.0000', '10.0000', '12.0000', NULL, NULL, 1, '09', '12.0000', NULL, NULL, NULL, NULL),
(37, 15, NULL, 21, '22862990', 'sheet-شیت', NULL, '10.0000', '1.0000', 1, '0.0000', 1, '0', '0', '0.0000', NULL, '10.0000', '1.0000', '2019-07-04', 'received', '10.0000', '10.0000', '1.0000', NULL, NULL, 1, '09', '1.0000', NULL, NULL, NULL, NULL),
(38, 16, NULL, 21, '22862990', 'sheet-شیت', NULL, '5.0000', '10.0000', 1, '0.0000', 1, '0', '0', '0.0000', NULL, '50.0000', '10.0000', '2019-07-04', 'received', '5.0000', '5.0000', '10.0000', NULL, NULL, 1, '09', '10.0000', NULL, NULL, NULL, NULL),
(39, 17, NULL, 21, '22862990', 'sheet-شیت', NULL, '5.0000', '10.0000', 1, '0.0000', 1, '0', '0', '0.0000', NULL, '50.0000', '9.0000', '2019-07-05', 'received', '5.0000', '5.0000', '10.0000', NULL, NULL, 1, '09', '10.0000', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_quotes`
--

DROP TABLE IF EXISTS `sma_quotes`;
CREATE TABLE IF NOT EXISTS `sma_quotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `biller_id` int(11) NOT NULL,
  `biller` varchar(55) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `internal_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT NULL,
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(55) DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_quote_items`
--

DROP TABLE IF EXISTS `sma_quote_items`;
CREATE TABLE IF NOT EXISTS `sma_quote_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quote_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) NOT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_unit_id` int(11) DEFAULT NULL,
  `product_unit_code` varchar(10) DEFAULT NULL,
  `unit_quantity` decimal(15,4) NOT NULL,
  `gst` varchar(20) DEFAULT NULL,
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quote_id` (`quote_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_sales`
--

DROP TABLE IF EXISTS `sma_sales`;
CREATE TABLE IF NOT EXISTS `sma_sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `biller_id` int(11) NOT NULL,
  `biller` varchar(55) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `staff_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `sale_status` varchar(20) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `total_items` smallint(6) DEFAULT NULL,
  `pos` tinyint(1) NOT NULL DEFAULT '0',
  `paid` decimal(25,4) DEFAULT '0.0000',
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `return_sale_ref` varchar(55) DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `return_sale_total` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `rounding` decimal(10,4) DEFAULT NULL,
  `suspend_note` varchar(255) DEFAULT NULL,
  `api` tinyint(1) DEFAULT '0',
  `shop` tinyint(1) DEFAULT '0',
  `address_id` int(11) DEFAULT NULL,
  `reserve_id` int(11) DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `manual_payment` varchar(55) DEFAULT NULL,
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_sales`
--

INSERT INTO `sma_sales` (`id`, `date`, `reference_no`, `customer_id`, `customer`, `biller_id`, `biller`, `warehouse_id`, `note`, `staff_note`, `total`, `product_discount`, `order_discount_id`, `total_discount`, `order_discount`, `product_tax`, `order_tax_id`, `order_tax`, `total_tax`, `shipping`, `grand_total`, `sale_status`, `payment_status`, `payment_term`, `due_date`, `created_by`, `updated_by`, `updated_at`, `total_items`, `pos`, `paid`, `return_id`, `surcharge`, `attachment`, `return_sale_ref`, `sale_id`, `return_sale_total`, `rounding`, `suspend_note`, `api`, `shop`, `address_id`, `reserve_id`, `hash`, `manual_payment`, `cgst`, `sgst`, `igst`) VALUES
(33, '2019-06-30 11:43:41', 'SALE/POS/2019/06/0033', 1, 'Walk-in Customer', 3, 'Test Biller', 1, '', '', '240.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '240.0000', 'completed', 'paid', 0, NULL, 1, NULL, NULL, 24, 1, '240.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, '2250b7bcb5c5f8b362a59c40487d62759893ba5cce0496614c35b12ab74da612', NULL, NULL, NULL, NULL),
(34, '2019-06-30 11:47:10', 'SALE/POS/2019/06/0034', 1, 'Walk-in Customer', 3, 'Test Biller', 1, '', '', '145.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '145.0000', 'completed', 'paid', 0, NULL, 1, NULL, NULL, 8, 1, '145.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, '0b14d94ccf08da167a601bbdfbf314e55041b79c10a78c8d1b55e2598a04d48b', NULL, NULL, NULL, NULL),
(35, '2019-07-01 03:43:12', 'SALE/POS/2019/07/0035', 1, 'Walk-in Customer', 3, 'Test Biller', 1, '', '', '100.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '100.0000', 'completed', 'paid', 0, NULL, 1, NULL, NULL, 10, 1, '100.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, '648071a1f8355db7c70ef68907afd13af15223e3473943a72fdbc9ac920fb60c', NULL, NULL, NULL, NULL),
(36, '2019-07-01 03:48:05', 'SALE/POS/2019/07/0036', 1, 'Walk-in Customer', 3, 'Test Biller', 1, '', '', '10.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '10.0000', 'completed', 'paid', 0, NULL, 1, NULL, NULL, 1, 1, '10.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, 'dd4cb73a551dcedc4952ab899e4c82bfe2db2052a41826c8d4ea2fa0ec64a9dd', NULL, NULL, NULL, NULL),
(37, '2019-07-01 03:57:46', 'SALE/POS/2019/07/0037', 1, 'Walk-in Customer', 3, 'Test Biller', 1, '', '', '120.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '120.0000', 'completed', 'paid', 0, NULL, 1, NULL, NULL, 12, 1, '120.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, '289b556bb9692d939089a59d0aaa4edc4d6ea8fd9b2fbaa5991e6fe6210765a1', NULL, NULL, NULL, NULL),
(38, '2019-07-01 10:10:35', 'SALE/POS/2019/07/0038', 1, 'Walk-in Customer', 5, 'Al Jannat Wood Works', 1, '', '', '4500.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '4500.0000', 'completed', 'paid', 0, NULL, 2, NULL, NULL, 1, 1, '4500.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, '283edfc77bfa78c2ce90464125b74733cd4ae6d542cdca60e8c5e42ddd0e8cef', NULL, NULL, NULL, NULL),
(39, '2019-07-01 10:22:12', 'SALE/POS/2019/07/0039', 1, 'Walk-in Customer', 3, 'Test Biller', 1, '', '', '1650.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '1650.0000', 'completed', 'paid', 0, NULL, 1, NULL, NULL, 13, 1, '1650.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, 'da4d1aadeda5325886325967867319124b2c4aa7fb83d702dd8a44413a052aab', NULL, NULL, NULL, NULL),
(40, '2019-07-04 01:42:04', 'SALE/POS/2019/07/0040', 1, 'Walk-in Customer', 3, 'Test Biller', 1, '', '', '180.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '180.0000', 'completed', 'paid', 0, NULL, 1, NULL, NULL, 18, 1, '180.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, '8a35f5e15ea93c14cc951d20299ba9bacb640b14010d77ae0f656769f2a91a72', NULL, NULL, NULL, NULL),
(41, '2019-07-04 01:42:57', 'SALE/POS/2019/07/0041', 1, 'Walk-in Customer', 3, 'Test Biller', 1, '', '', '100.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '100.0000', 'completed', 'paid', 0, NULL, 1, NULL, NULL, 1, 1, '100.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, 'ce40769a6120f3def8808fe4fc99b6feb0634945f2a33a9fcb6bc0ea4f411a04', NULL, NULL, NULL, NULL),
(42, '2019-07-08 12:55:09', 'SALE/POS/2019/07/0042', 1, 'Walk-in Customer', 3, 'Test Biller', 1, '', '', '1000.0000', '0.0000', '', '0.0000', '0.0000', '0.0000', 0, '0.0000', '0.0000', '0.0000', '1000.0000', 'completed', 'paid', 0, NULL, 1, NULL, NULL, 1, 1, '1000.0000', NULL, '0.0000', NULL, NULL, NULL, '0.0000', '0.0000', NULL, 0, 0, NULL, NULL, 'fad4af7ae415aa43c376b4e6fb5220b9f86443e02d3566797c8a914086de3237', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_sale_items`
--

DROP TABLE IF EXISTS `sma_sale_items`;
CREATE TABLE IF NOT EXISTS `sma_sale_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) UNSIGNED NOT NULL,
  `product_id` int(11) UNSIGNED NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) NOT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `sale_item_id` int(11) DEFAULT NULL,
  `product_unit_id` int(11) DEFAULT NULL,
  `product_unit_code` varchar(10) DEFAULT NULL,
  `unit_quantity` decimal(15,4) NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `gst` varchar(20) DEFAULT NULL,
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_id` (`sale_id`),
  KEY `product_id` (`product_id`),
  KEY `product_id_2` (`product_id`,`sale_id`),
  KEY `sale_id_2` (`sale_id`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_sale_items`
--

INSERT INTO `sma_sale_items` (`id`, `sale_id`, `product_id`, `product_code`, `product_name`, `product_type`, `option_id`, `net_unit_price`, `unit_price`, `quantity`, `warehouse_id`, `item_tax`, `tax_rate_id`, `tax`, `discount`, `item_discount`, `subtotal`, `serial_no`, `real_unit_price`, `sale_item_id`, `product_unit_id`, `product_unit_code`, `unit_quantity`, `comment`, `gst`, `cgst`, `sgst`, `igst`) VALUES
(41, 33, 21, '22862987', 'sheet-شیت', 'standard', 0, '10.0000', '10.0000', '24.0000', 1, '0.0000', 1, '0', '0', '0.0000', '240.0000', '', '10.0000', NULL, 1, '09', '24.0000', '', NULL, NULL, NULL, NULL),
(42, 34, 21, '22862987', 'sheet-شیت', 'standard', 0, '10.0000', '10.0000', '1.0000', 1, '0.0000', 1, '0', '0', '0.0000', '10.0000', '', '10.0000', NULL, 1, '09', '1.0000', '', NULL, NULL, NULL, NULL),
(43, 34, 21, '22862987', 'sheet-شیت', 'standard', 0, '5.0000', '5.0000', '1.0000', 1, '0.0000', 1, '0', '0', '0.0000', '5.0000', '', '5.0000', NULL, 1, '09', '1.0000', '', NULL, NULL, NULL, NULL),
(44, 34, 22, '69503741', 'pepsi', 'standard', 0, '20.0000', '20.0000', '5.0000', 1, '0.0000', 1, '0', '0', '0.0000', '100.0000', '', '20.0000', NULL, 1, '09', '5.0000', '', NULL, NULL, NULL, NULL),
(45, 34, 21, '22862987', 'sheet-شیت', 'standard', 0, '30.0000', '30.0000', '1.0000', 1, '0.0000', 1, '0', '0', '0.0000', '30.0000', '', '30.0000', NULL, 1, '09', '1.0000', '', NULL, NULL, NULL, NULL),
(46, 35, 21, '22862990', 'sheet-شیت', 'standard', 0, '10.0000', '10.0000', '10.0000', 1, '0.0000', 1, '0', '0', '0.0000', '100.0000', '', '10.0000', NULL, 1, '09', '10.0000', '', NULL, NULL, NULL, NULL),
(47, 36, 4294967295, '3137852014444224', 'Gift Card', 'manual', 0, '10.0000', '10.0000', '1.0000', 1, '0.0000', 0, '', '0', '0.0000', '10.0000', '', '10.0000', NULL, NULL, NULL, '1.0000', '', NULL, NULL, NULL, NULL),
(48, 37, 21, '22862990', 'sheet-شیت', 'standard', 0, '10.0000', '10.0000', '12.0000', 1, '0.0000', 1, '0', '0', '0.0000', '120.0000', '', '10.0000', NULL, 1, '09', '12.0000', '', NULL, NULL, NULL, NULL),
(49, 38, 4294967295, '55885712', 'Wood', 'manual', 0, '4500.0000', '4500.0000', '1.0000', 1, '0.0000', 0, '', '0', '0.0000', '4500.0000', '', '4500.0000', NULL, NULL, NULL, '1.0000', '', NULL, NULL, NULL, NULL),
(50, 39, 4294967295, '55242417', 'Samad', 'manual', 0, '450.0000', '450.0000', '1.0000', 1, '0.0000', 0, '', '0', '0.0000', '450.0000', '', '450.0000', NULL, NULL, NULL, '1.0000', '', NULL, NULL, NULL, NULL),
(51, 39, 21, '22862990', 'sheet-شیت', 'standard', 0, '100.0000', '100.0000', '12.0000', 1, '0.0000', 1, '0', '0', '0.0000', '1200.0000', '', '100.0000', NULL, 1, '09', '12.0000', '', NULL, NULL, NULL, NULL),
(52, 40, 22, '69503741', 'pepsi', 'standard', 0, '10.0000', '10.0000', '18.0000', 1, '0.0000', 1, '0', '0', '0.0000', '180.0000', '', '10.0000', NULL, 1, '09', '18.0000', '', NULL, NULL, NULL, NULL),
(53, 41, 22, '69503741', 'pepsi', 'standard', 0, '100.0000', '100.0000', '1.0000', 1, '0.0000', 1, '0', '0', '0.0000', '100.0000', '', '100.0000', NULL, 1, '09', '1.0000', '', NULL, NULL, NULL, NULL),
(54, 42, 21, '22862990', 'sheet-شیت', 'standard', 0, '1000.0000', '1000.0000', '1.0000', 1, '0.0000', 1, '0', '0', '0.0000', '1000.0000', '', '1000.0000', NULL, 1, '09', '1.0000', '', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_sessions`
--

DROP TABLE IF EXISTS `sma_sessions`;
CREATE TABLE IF NOT EXISTS `sma_sessions` (
  `id` varchar(40) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ci_sessions_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_sessions`
--

INSERT INTO `sma_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES
('0ac7kolcn756i43pl44skqanlfst6gb7', '::1', 1562744855, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734343835353b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('0mstc99n0a1o37jd190mi7lr7tbvlvjj', '::1', 1562741709, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734313730393b7265717565737465645f706167657c733a31333a2261646d696e2f77656c636f6d65223b6964656e746974797c733a363a226861726f6f6e223b757365726e616d657c733a363a226861726f6f6e223b656d61696c7c733a31363a226861726f6f6e407961686f6f2e636f6d223b757365725f69647c733a313a2232223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363830383836223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2235223b77617265686f7573655f69647c733a313a2231223b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2231223b616c6c6f775f646973636f756e747c733a313a2231223b62696c6c65725f69647c733a313a2235223b636f6d70616e795f69647c4e3b73686f775f636f73747c4e3b73686f775f70726963657c4e3b),
('1h3kqot4grj38j8i6s567oqr11m0gv0h', '::1', 1562743435, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734333433353b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b6d6573736167657c733a33383a2247726f7570207065726d697373696f6e73207375636365737366756c6c792075706461746564223b5f5f63695f766172737c613a313a7b733a373a226d657373616765223b733a333a226f6c64223b7d),
('258ur1hvh4m8cj0abmv1ob92fdh0382i', '::1', 1562747692, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734373639323b),
('a4vfri5k1taigfjrgf0bj0s61ndf2hi7', '::1', 1562745659, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734353635393b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('ab2hvc1deifik58t1o4470rj05esjbq3', '::1', 1562742551, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734323535313b7265717565737465645f706167657c733a31333a2261646d696e2f77656c636f6d65223b6964656e746974797c733a363a226861726f6f6e223b757365726e616d657c733a363a226861726f6f6e223b656d61696c7c733a31363a226861726f6f6e407961686f6f2e636f6d223b757365725f69647c733a313a2232223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363830383836223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2235223b77617265686f7573655f69647c733a313a2231223b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2231223b616c6c6f775f646973636f756e747c733a313a2231223b62696c6c65725f69647c733a313a2235223b636f6d70616e795f69647c4e3b73686f775f636f73747c4e3b73686f775f70726963657c4e3b),
('cgkefhkn2mc5jldtealj28l965cimukm', '::1', 1562740856, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734303835363b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('d79gilpcl4kfeei5pcovjh34dio7fjlj', '::1', 1562746965, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734363936353b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('e3td8gos92ath6v8uivr0aioimlpnm27', '::1', 1562741656, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734313635363b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b6d6573736167657c733a33383a2247726f7570207065726d697373696f6e73207375636365737366756c6c792075706461746564223b5f5f63695f766172737c613a313a7b733a373a226d657373616765223b733a333a226f6c64223b7d),
('een2oc3ph8dp2q7il2038alusfqnl1m1', '::1', 1562746801, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734363830313b6964656e746974797c733a343a2262696c6c223b757365726e616d657c733a343a2262696c6c223b656d61696c7c733a31383a2262696c6c406d6963726f736f66742e636f6d223b757365725f69647c733a313a2234223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632373432393433223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2232223b77617265686f7573655f69647c733a313a2230223b766965775f72696768747c733a313a2231223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c733a313a2230223b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('fle03qevjajsfbsn9eblnm1op8fh2u3i', '::1', 1562742227, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734323232373b7265717565737465645f706167657c733a31333a2261646d696e2f77656c636f6d65223b6964656e746974797c733a363a226861726f6f6e223b757365726e616d657c733a363a226861726f6f6e223b656d61696c7c733a31363a226861726f6f6e407961686f6f2e636f6d223b757365725f69647c733a313a2232223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363830383836223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2235223b77617265686f7573655f69647c733a313a2231223b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2231223b616c6c6f775f646973636f756e747c733a313a2231223b62696c6c65725f69647c733a313a2235223b636f6d70616e795f69647c4e3b73686f775f636f73747c4e3b73686f775f70726963657c4e3b),
('j6b90p0cugpbopv1mpattjqtaseaousi', '::1', 1562741395, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734313339353b7265717565737465645f706167657c733a31333a2261646d696e2f77656c636f6d65223b6964656e746974797c733a363a226861726f6f6e223b757365726e616d657c733a363a226861726f6f6e223b656d61696c7c733a31363a226861726f6f6e407961686f6f2e636f6d223b757365725f69647c733a313a2232223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363830383836223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2235223b77617265686f7573655f69647c733a313a2231223b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2231223b616c6c6f775f646973636f756e747c733a313a2231223b62696c6c65725f69647c733a313a2235223b636f6d70616e795f69647c4e3b73686f775f636f73747c4e3b73686f775f70726963657c4e3b),
('jpoaiilvbiijf656ppd8tv00u2i6su1e', '::1', 1562742151, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734323135313b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('kabr7qr9ivnuidseft3iaacmll6sv3t8', '::1', 1562742849, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734323834393b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('n5t49qrlh653h4p61om5gonekllbg71n', '::1', 1562742937, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734323933373b7265717565737465645f706167657c733a31333a2261646d696e2f77656c636f6d65223b6964656e746974797c733a363a226861726f6f6e223b757365726e616d657c733a363a226861726f6f6e223b656d61696c7c733a31363a226861726f6f6e407961686f6f2e636f6d223b757365725f69647c733a313a2232223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363830383836223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2235223b77617265686f7573655f69647c733a313a2231223b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2231223b616c6c6f775f646973636f756e747c733a313a2231223b62696c6c65725f69647c733a313a2235223b636f6d70616e795f69647c4e3b73686f775f636f73747c4e3b73686f775f70726963657c4e3b),
('nqcvdparrq3eq0nc60hripbalrsgprde', '::1', 1562740744, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734303734343b7265717565737465645f706167657c733a31333a2261646d696e2f77656c636f6d65223b6964656e746974797c733a363a226861726f6f6e223b757365726e616d657c733a363a226861726f6f6e223b656d61696c7c733a31363a226861726f6f6e407961686f6f2e636f6d223b757365725f69647c733a313a2232223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363830383836223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2235223b77617265686f7573655f69647c733a313a2231223b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2231223b616c6c6f775f646973636f756e747c733a313a2231223b62696c6c65725f69647c733a313a2235223b636f6d70616e795f69647c4e3b73686f775f636f73747c4e3b73686f775f70726963657c4e3b),
('p75v5av37fasbfsgnirbiq2m42ag37c3', '::1', 1562747692, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734373639323b6964656e746974797c733a363a226861726f6f6e223b757365726e616d657c733a363a226861726f6f6e223b656d61696c7c733a31363a226861726f6f6e407961686f6f2e636f6d223b757365725f69647c733a313a2232223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632373433313334223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2235223b77617265686f7573655f69647c733a313a2231223b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2231223b616c6c6f775f646973636f756e747c733a313a2231223b62696c6c65725f69647c733a313a2235223b636f6d70616e795f69647c4e3b73686f775f636f73747c4e3b73686f775f70726963657c4e3b),
('pqbekpia7kmelpjfde65e1dn7jojirgc', '::1', 1562746228, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734363232383b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('qv84senusl5avbb7l1gl9bbrvabb9jdo', '::1', 1562742529, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734323532393b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('r7q63gfgup6hvlb6351ig4kbvo54c439', '::1', 1562745827, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734353832373b6964656e746974797c733a343a2262696c6c223b757365726e616d657c733a343a2262696c6c223b656d61696c7c733a31383a2262696c6c406d6963726f736f66742e636f6d223b757365725f69647c733a313a2234223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632373432393433223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2232223b77617265686f7573655f69647c733a313a2230223b766965775f72696768747c733a313a2231223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c733a313a2230223b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('rq0r6dbqmqnu0uirh2d2qbmpdmpf9u12', '::1', 1562745327, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734353332373b6964656e746974797c733a353a226f776e6572223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a31383a226f776e65724074656364696172792e636f6d223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363730343336223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('s3obur4631qc8dgiod2uoq7nl3omkalr', '::1', 1562741069, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734313036393b7265717565737465645f706167657c733a31333a2261646d696e2f77656c636f6d65223b6964656e746974797c733a363a226861726f6f6e223b757365726e616d657c733a363a226861726f6f6e223b656d61696c7c733a31363a226861726f6f6e407961686f6f2e636f6d223b757365725f69647c733a313a2232223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632363830383836223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2235223b77617265686f7573655f69647c733a313a2231223b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2231223b616c6c6f775f646973636f756e747c733a313a2231223b62696c6c65725f69647c733a313a2235223b636f6d70616e795f69647c4e3b73686f775f636f73747c4e3b73686f775f70726963657c4e3b6572726f727c733a3132363a224163636573732044656e6965642120596f7520646f6e2774206861766520726967687420746f20616363657373207468652072657175657374656420706167652e20496620796f75207468696e6b2c2069742773206279206d697374616b652c20706c6561736520636f6e746163742061646d696e6973747261746f722e223b5f5f63695f766172737c613a313a7b733a353a226572726f72223b733a333a226e6577223b7d),
('ssouasiq226hbucce3fni3oe7dai6ce4', '::1', 1562746456, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734363435363b6964656e746974797c733a343a2262696c6c223b757365726e616d657c733a343a2262696c6c223b656d61696c7c733a31383a2262696c6c406d6963726f736f66742e636f6d223b757365725f69647c733a313a2234223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632373432393433223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2232223b77617265686f7573655f69647c733a313a2230223b766965775f72696768747c733a313a2231223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c733a313a2230223b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('ui4n74dp79519a2b64ojq5qvjigssbbg', '::1', 1562746155, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734363135353b6964656e746974797c733a343a2262696c6c223b757365726e616d657c733a343a2262696c6c223b656d61696c7c733a31383a2262696c6c406d6963726f736f66742e636f6d223b757365725f69647c733a313a2234223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632373432393433223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2232223b77617265686f7573655f69647c733a313a2230223b766965775f72696768747c733a313a2231223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c733a313a2230223b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b),
('v6p8g5h69biv7sufmit52bdsnu776ulm', '::1', 1562747055, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734373035323b7265717565737465645f706167657c733a33323a2261646d696e2f7075726368617365732f737570706c6965725f7061796d656e74223b),
('vqgqir1q554glbnp04sgbfglb347rtut', '::1', 1562745018, 0x5f5f63695f6c6173745f726567656e65726174657c693a313536323734353031383b6964656e746974797c733a343a2262696c6c223b757365726e616d657c733a343a2262696c6c223b656d61696c7c733a31383a2262696c6c406d6963726f736f66742e636f6d223b757365725f69647c733a313a2234223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231353632373432393433223b6c6173745f69707c733a333a223a3a31223b6176617461727c4e3b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2232223b77617265686f7573655f69647c733a313a2230223b766965775f72696768747c733a313a2231223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c733a313a2230223b62696c6c65725f69647c733a313a2230223b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b);

-- --------------------------------------------------------

--
-- Table structure for table `sma_settings`
--

DROP TABLE IF EXISTS `sma_settings`;
CREATE TABLE IF NOT EXISTS `sma_settings` (
  `setting_id` int(1) NOT NULL,
  `logo` varchar(255) NOT NULL,
  `logo2` varchar(255) NOT NULL,
  `site_name` varchar(55) NOT NULL,
  `language` varchar(20) NOT NULL,
  `default_warehouse` int(2) NOT NULL,
  `accounting_method` tinyint(4) NOT NULL DEFAULT '0',
  `default_currency` varchar(3) NOT NULL,
  `default_tax_rate` int(2) NOT NULL,
  `rows_per_page` int(2) NOT NULL,
  `version` varchar(10) NOT NULL DEFAULT '1.0',
  `default_tax_rate2` int(11) NOT NULL DEFAULT '0',
  `dateformat` int(11) NOT NULL,
  `sales_prefix` varchar(20) DEFAULT NULL,
  `quote_prefix` varchar(20) DEFAULT NULL,
  `purchase_prefix` varchar(20) DEFAULT NULL,
  `transfer_prefix` varchar(20) DEFAULT NULL,
  `delivery_prefix` varchar(20) DEFAULT NULL,
  `payment_prefix` varchar(20) DEFAULT NULL,
  `return_prefix` varchar(20) DEFAULT NULL,
  `returnp_prefix` varchar(20) DEFAULT NULL,
  `expense_prefix` varchar(20) DEFAULT NULL,
  `item_addition` tinyint(1) NOT NULL DEFAULT '0',
  `theme` varchar(20) NOT NULL,
  `product_serial` tinyint(4) NOT NULL,
  `default_discount` int(11) NOT NULL,
  `product_discount` tinyint(1) NOT NULL DEFAULT '0',
  `discount_method` tinyint(4) NOT NULL,
  `tax1` tinyint(4) NOT NULL,
  `tax2` tinyint(4) NOT NULL,
  `overselling` tinyint(1) NOT NULL DEFAULT '0',
  `restrict_user` tinyint(4) NOT NULL DEFAULT '0',
  `restrict_calendar` tinyint(4) NOT NULL DEFAULT '0',
  `timezone` varchar(100) DEFAULT NULL,
  `iwidth` int(11) NOT NULL DEFAULT '0',
  `iheight` int(11) NOT NULL,
  `twidth` int(11) NOT NULL,
  `theight` int(11) NOT NULL,
  `watermark` tinyint(1) DEFAULT NULL,
  `reg_ver` tinyint(1) DEFAULT NULL,
  `allow_reg` tinyint(1) DEFAULT NULL,
  `reg_notification` tinyint(1) DEFAULT NULL,
  `auto_reg` tinyint(1) DEFAULT NULL,
  `protocol` varchar(20) NOT NULL DEFAULT 'mail',
  `mailpath` varchar(55) DEFAULT '/usr/sbin/sendmail',
  `smtp_host` varchar(100) DEFAULT NULL,
  `smtp_user` varchar(100) DEFAULT NULL,
  `smtp_pass` varchar(255) DEFAULT NULL,
  `smtp_port` varchar(10) DEFAULT '25',
  `smtp_crypto` varchar(10) DEFAULT NULL,
  `corn` datetime DEFAULT NULL,
  `customer_group` int(11) NOT NULL,
  `default_email` varchar(100) NOT NULL,
  `mmode` tinyint(1) NOT NULL,
  `bc_fix` tinyint(4) NOT NULL DEFAULT '0',
  `auto_detect_barcode` tinyint(1) NOT NULL DEFAULT '0',
  `captcha` tinyint(1) NOT NULL DEFAULT '1',
  `reference_format` tinyint(1) NOT NULL DEFAULT '1',
  `racks` tinyint(1) DEFAULT '0',
  `attributes` tinyint(1) NOT NULL DEFAULT '0',
  `product_expiry` tinyint(1) NOT NULL DEFAULT '0',
  `decimals` tinyint(2) NOT NULL DEFAULT '2',
  `qty_decimals` tinyint(2) NOT NULL DEFAULT '2',
  `decimals_sep` varchar(2) NOT NULL DEFAULT '.',
  `thousands_sep` varchar(2) NOT NULL DEFAULT ',',
  `invoice_view` tinyint(1) DEFAULT '0',
  `default_biller` int(11) DEFAULT NULL,
  `envato_username` varchar(50) DEFAULT NULL,
  `purchase_code` varchar(100) DEFAULT NULL,
  `rtl` tinyint(1) DEFAULT '0',
  `each_spent` decimal(15,4) DEFAULT NULL,
  `ca_point` tinyint(4) DEFAULT NULL,
  `each_sale` decimal(15,4) DEFAULT NULL,
  `sa_point` tinyint(4) DEFAULT NULL,
  `update` tinyint(1) DEFAULT '0',
  `sac` tinyint(1) DEFAULT '0',
  `display_all_products` tinyint(1) DEFAULT '0',
  `display_symbol` tinyint(1) DEFAULT NULL,
  `symbol` varchar(50) DEFAULT NULL,
  `remove_expired` tinyint(1) DEFAULT '0',
  `barcode_separator` varchar(2) NOT NULL DEFAULT '_',
  `set_focus` tinyint(1) NOT NULL DEFAULT '0',
  `price_group` int(11) DEFAULT NULL,
  `barcode_img` tinyint(1) NOT NULL DEFAULT '1',
  `ppayment_prefix` varchar(20) DEFAULT 'POP',
  `disable_editing` smallint(6) DEFAULT '90',
  `qa_prefix` varchar(55) DEFAULT NULL,
  `update_cost` tinyint(1) DEFAULT NULL,
  `apis` tinyint(1) NOT NULL DEFAULT '0',
  `state` varchar(100) DEFAULT NULL,
  `pdf_lib` varchar(20) DEFAULT 'dompdf',
  PRIMARY KEY (`setting_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_settings`
--

INSERT INTO `sma_settings` (`setting_id`, `logo`, `logo2`, `site_name`, `language`, `default_warehouse`, `accounting_method`, `default_currency`, `default_tax_rate`, `rows_per_page`, `version`, `default_tax_rate2`, `dateformat`, `sales_prefix`, `quote_prefix`, `purchase_prefix`, `transfer_prefix`, `delivery_prefix`, `payment_prefix`, `return_prefix`, `returnp_prefix`, `expense_prefix`, `item_addition`, `theme`, `product_serial`, `default_discount`, `product_discount`, `discount_method`, `tax1`, `tax2`, `overselling`, `restrict_user`, `restrict_calendar`, `timezone`, `iwidth`, `iheight`, `twidth`, `theight`, `watermark`, `reg_ver`, `allow_reg`, `reg_notification`, `auto_reg`, `protocol`, `mailpath`, `smtp_host`, `smtp_user`, `smtp_pass`, `smtp_port`, `smtp_crypto`, `corn`, `customer_group`, `default_email`, `mmode`, `bc_fix`, `auto_detect_barcode`, `captcha`, `reference_format`, `racks`, `attributes`, `product_expiry`, `decimals`, `qty_decimals`, `decimals_sep`, `thousands_sep`, `invoice_view`, `default_biller`, `envato_username`, `purchase_code`, `rtl`, `each_spent`, `ca_point`, `each_sale`, `sa_point`, `update`, `sac`, `display_all_products`, `display_symbol`, `symbol`, `remove_expired`, `barcode_separator`, `set_focus`, `price_group`, `barcode_img`, `ppayment_prefix`, `disable_editing`, `qa_prefix`, `update_cost`, `apis`, `state`, `pdf_lib`) VALUES
(1, 'logo1.png', 'logo3.png', 'Al jannat Wood Works', 'english', 1, 0, 'USD', 1, 10, '3.2.10', 0, 5, 'SALE', 'QUOTE', 'PO', 'TR', 'DO', 'IPAY', 'SR', 'PR', '', 0, 'default', 1, 1, 1, 1, 1, 0, 0, 1, 0, 'Europe/London', 800, 800, 150, 150, 0, 0, 0, 0, NULL, 'mail', '/usr/sbin/sendmail', 'pop.gmail.com', 'contact@sma.tecdiary.org', 'jEFTM4T63AiQ9dsidxhPKt9CIg4HQjCN58n/RW9vmdC/UDXCzRLR469ziZ0jjpFlbOg43LyoSmpJLBkcAHh0Yw==', '25', NULL, NULL, 1, 'contact@tecdiary.com', 0, 4, 1, 0, 2, 1, 1, 0, 2, 2, '.', ',', 0, 3, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, '', 0, '_', 0, 1, 1, 'POP', 90, '', 0, 0, 'AN', 'dompdf');

-- --------------------------------------------------------

--
-- Table structure for table `sma_skrill`
--

DROP TABLE IF EXISTS `sma_skrill`;
CREATE TABLE IF NOT EXISTS `sma_skrill` (
  `id` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `account_email` varchar(255) NOT NULL DEFAULT 'testaccount2@moneybookers.com',
  `secret_word` varchar(20) NOT NULL DEFAULT 'mbtest',
  `skrill_currency` varchar(3) NOT NULL DEFAULT 'USD',
  `fixed_charges` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `extra_charges_my` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `extra_charges_other` decimal(25,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_skrill`
--

INSERT INTO `sma_skrill` (`id`, `active`, `account_email`, `secret_word`, `skrill_currency`, `fixed_charges`, `extra_charges_my`, `extra_charges_other`) VALUES
(1, 1, 'testaccount2@moneybookers.com', 'mbtest', 'USD', '0.0000', '0.0000', '0.0000');

-- --------------------------------------------------------

--
-- Table structure for table `sma_stock_counts`
--

DROP TABLE IF EXISTS `sma_stock_counts`;
CREATE TABLE IF NOT EXISTS `sma_stock_counts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `type` varchar(10) NOT NULL,
  `initial_file` varchar(50) NOT NULL,
  `final_file` varchar(50) DEFAULT NULL,
  `brands` varchar(50) DEFAULT NULL,
  `brand_names` varchar(100) DEFAULT NULL,
  `categories` varchar(50) DEFAULT NULL,
  `category_names` varchar(100) DEFAULT NULL,
  `note` text,
  `products` int(11) DEFAULT NULL,
  `rows` int(11) DEFAULT NULL,
  `differences` int(11) DEFAULT NULL,
  `matches` int(11) DEFAULT NULL,
  `missing` int(11) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `finalized` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_stock_counts`
--

INSERT INTO `sma_stock_counts` (`id`, `date`, `reference_no`, `warehouse_id`, `type`, `initial_file`, `final_file`, `brands`, `brand_names`, `categories`, `category_names`, `note`, `products`, `rows`, `differences`, `matches`, `missing`, `created_by`, `updated_by`, `updated_at`, `finalized`) VALUES
(1, '2019-06-24 05:59:00', '', 1, 'full', '056873b2d9e6a4a2493647ba720c81db.csv', NULL, '', '', '', '', NULL, 2, 2, NULL, NULL, NULL, 1, NULL, NULL, NULL),
(2, '2019-06-24 06:05:00', '', 1, 'full', 'e92bc064946f48dcb1dffe094641e1fa.csv', NULL, '', '', '', '', NULL, 2, 2, NULL, NULL, NULL, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_stock_count_items`
--

DROP TABLE IF EXISTS `sma_stock_count_items`;
CREATE TABLE IF NOT EXISTS `sma_stock_count_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_count_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_variant` varchar(55) DEFAULT NULL,
  `product_variant_id` int(11) DEFAULT NULL,
  `expected` decimal(15,4) NOT NULL,
  `counted` decimal(15,4) NOT NULL,
  `cost` decimal(25,4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stock_count_id` (`stock_count_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_suspended_bills`
--

DROP TABLE IF EXISTS `sma_suspended_bills`;
CREATE TABLE IF NOT EXISTS `sma_suspended_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `count` int(11) NOT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `suspend_note` varchar(255) DEFAULT NULL,
  `shipping` decimal(15,4) DEFAULT '0.0000',
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_suspended_bills`
--

INSERT INTO `sma_suspended_bills` (`id`, `date`, `customer_id`, `customer`, `count`, `order_discount_id`, `order_tax_id`, `total`, `biller_id`, `warehouse_id`, `created_by`, `suspend_note`, `shipping`, `cgst`, `sgst`, `igst`) VALUES
(1, '2019-06-27 09:39:01', 1, 'Walk-in Customer', 10, '', 0, '0.0000', 3, 2, 1, 'testing', '0.0000', NULL, NULL, NULL),
(2, '2019-06-27 09:40:21', 1, 'Walk-in Customer', 1, '', 0, '0.0000', 3, 1, 1, 'asdasd', '0.0000', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_suspended_items`
--

DROP TABLE IF EXISTS `sma_suspended_items`;
CREATE TABLE IF NOT EXISTS `sma_suspended_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suspend_id` int(11) UNSIGNED NOT NULL,
  `product_id` int(11) UNSIGNED NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `net_unit_price` decimal(25,4) NOT NULL,
  `unit_price` decimal(25,4) NOT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_unit_id` int(11) DEFAULT NULL,
  `product_unit_code` varchar(10) DEFAULT NULL,
  `unit_quantity` decimal(15,4) NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `gst` varchar(20) DEFAULT NULL,
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_suspended_items`
--

INSERT INTO `sma_suspended_items` (`id`, `suspend_id`, `product_id`, `product_code`, `product_name`, `net_unit_price`, `unit_price`, `quantity`, `warehouse_id`, `item_tax`, `tax_rate_id`, `tax`, `discount`, `item_discount`, `subtotal`, `serial_no`, `option_id`, `product_type`, `real_unit_price`, `product_unit_id`, `product_unit_code`, `unit_quantity`, `comment`, `gst`, `cgst`, `sgst`, `igst`) VALUES
(1, 1, 13, '07679038', 'qwerty', '0.0000', '0.0000', '10.0000', 2, '0.0000', 0, '', '0', '0.0000', '0.0000', '', NULL, 'standard', '0.0000', 1, '09', '10.0000', '', NULL, NULL, NULL, NULL),
(2, 2, 9, '85227877', 'lar-لر', '0.0000', '0.0000', '1.0000', 1, '0.0000', 0, '', '0', '0.0000', '0.0000', '', NULL, 'sheets', '0.0000', 1, '09', '1.0000', '', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_tax_rates`
--

DROP TABLE IF EXISTS `sma_tax_rates`;
CREATE TABLE IF NOT EXISTS `sma_tax_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `rate` decimal(12,4) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_tax_rates`
--

INSERT INTO `sma_tax_rates` (`id`, `name`, `code`, `rate`, `type`) VALUES
(1, 'General Sales Tax', 'GST', '0.0000', '1');

-- --------------------------------------------------------

--
-- Table structure for table `sma_transfers`
--

DROP TABLE IF EXISTS `sma_transfers`;
CREATE TABLE IF NOT EXISTS `sma_transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_no` varchar(55) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `from_warehouse_id` int(11) NOT NULL,
  `from_warehouse_code` varchar(55) NOT NULL,
  `from_warehouse_name` varchar(55) NOT NULL,
  `to_warehouse_id` int(11) NOT NULL,
  `to_warehouse_code` varchar(55) NOT NULL,
  `to_warehouse_name` varchar(55) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT NULL,
  `grand_total` decimal(25,4) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `status` varchar(55) NOT NULL DEFAULT 'pending',
  `shipping` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_transfer_items`
--

DROP TABLE IF EXISTS `sma_transfer_items`;
CREATE TABLE IF NOT EXISTS `sma_transfer_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `net_unit_cost` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `quantity_balance` decimal(15,4) NOT NULL,
  `unit_cost` decimal(25,4) DEFAULT NULL,
  `real_unit_cost` decimal(25,4) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `product_unit_id` int(11) DEFAULT NULL,
  `product_unit_code` varchar(10) DEFAULT NULL,
  `unit_quantity` decimal(15,4) NOT NULL,
  `gst` varchar(20) DEFAULT NULL,
  `cgst` decimal(25,4) DEFAULT NULL,
  `sgst` decimal(25,4) DEFAULT NULL,
  `igst` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transfer_id` (`transfer_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sma_units`
--

DROP TABLE IF EXISTS `sma_units`;
CREATE TABLE IF NOT EXISTS `sma_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(55) NOT NULL,
  `base_unit` int(11) DEFAULT NULL,
  `operator` varchar(1) DEFAULT NULL,
  `unit_value` varchar(55) DEFAULT NULL,
  `operation_value` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `base_unit` (`base_unit`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_units`
--

INSERT INTO `sma_units` (`id`, `code`, `name`, `base_unit`, `operator`, `unit_value`, `operation_value`) VALUES
(1, '09', 'Piece', NULL, NULL, NULL, NULL),
(2, '6', 'Key', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_users`
--

DROP TABLE IF EXISTS `sma_users`;
CREATE TABLE IF NOT EXISTS `sma_users` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `last_ip_address` varbinary(45) DEFAULT NULL,
  `ip_address` varbinary(45) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(40) NOT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `forgotten_password_code` varchar(40) DEFAULT NULL,
  `forgotten_password_time` int(11) UNSIGNED DEFAULT NULL,
  `remember_code` varchar(40) DEFAULT NULL,
  `created_on` int(11) UNSIGNED NOT NULL,
  `last_login` int(11) UNSIGNED DEFAULT NULL,
  `active` tinyint(1) UNSIGNED DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(55) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `group_id` int(10) UNSIGNED NOT NULL,
  `warehouse_id` int(10) UNSIGNED DEFAULT NULL,
  `biller_id` int(10) UNSIGNED DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `show_cost` tinyint(1) DEFAULT '0',
  `show_price` tinyint(1) DEFAULT '0',
  `award_points` int(11) DEFAULT '0',
  `view_right` tinyint(1) NOT NULL DEFAULT '0',
  `edit_right` tinyint(1) NOT NULL DEFAULT '0',
  `allow_discount` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`,`warehouse_id`,`biller_id`),
  KEY `group_id_2` (`group_id`,`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_users`
--

INSERT INTO `sma_users` (`id`, `last_ip_address`, `ip_address`, `username`, `password`, `salt`, `email`, `activation_code`, `forgotten_password_code`, `forgotten_password_time`, `remember_code`, `created_on`, `last_login`, `active`, `first_name`, `last_name`, `company`, `phone`, `avatar`, `gender`, `group_id`, `warehouse_id`, `biller_id`, `company_id`, `show_cost`, `show_price`, `award_points`, `view_right`, `edit_right`, `allow_discount`) VALUES
(1, 0x3a3a31, 0x0000, 'owner', '2c8ab736b2ccab4f50e72d5fd7d21020cbb77ae7', NULL, 'owner@tecdiary.com', NULL, NULL, NULL, NULL, 1351661704, 1562740347, 1, 'Owner', 'Owner', 'Al Jannat Wood Works', '012345678', NULL, 'male', 1, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0),
(2, 0x3a3a31, 0x3a3a31, 'haroon', '2c8ab736b2ccab4f50e72d5fd7d21020cbb77ae7', NULL, 'haroon@yahoo.com', NULL, NULL, NULL, NULL, 1560863310, 1562746863, 1, 'Haroon', 'Haroon', 'Al Jannat Wood Works', '0300', NULL, 'male', 5, 1, 5, NULL, NULL, NULL, 0, 0, 1, 1),
(3, 0x3a3a31, 0x3a3a31, 'test', '81d416288eb38db479d576b08d5f28f6769d6682', NULL, 'test@yahoo.com', NULL, NULL, NULL, NULL, 1560875630, 1562223204, 1, 'test', 'test', 'test', '0300', NULL, 'male', 5, 1, 3, NULL, NULL, NULL, 0, 1, 0, 0),
(4, 0x3a3a31, 0x3a3a31, 'bill', '2c8ab736b2ccab4f50e72d5fd7d21020cbb77ae7', NULL, 'bill@microsoft.com', NULL, NULL, NULL, NULL, 1561644029, 1562743241, 1, 'bill', 'gates', 'microsoft', '+17485478547', NULL, 'male', 2, 0, 0, NULL, 0, 0, 0, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `sma_user_logins`
--

DROP TABLE IF EXISTS `sma_user_logins`;
CREATE TABLE IF NOT EXISTS `sma_user_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `ip_address` varbinary(16) NOT NULL,
  `login` varchar(100) NOT NULL,
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_user_logins`
--

INSERT INTO `sma_user_logins` (`id`, `user_id`, `company_id`, `ip_address`, `login`, `time`) VALUES
(0, 1, NULL, 0x3a3a31, 'owner', '2019-06-27 13:03:13'),
(1, 1, NULL, 0x3a3a31, 'owner', '2019-06-18 12:59:33'),
(2, 2, NULL, 0x3a3a31, 'haroon', '2019-06-18 13:08:51'),
(3, 1, NULL, 0x3a3a31, 'owner', '2019-06-18 13:09:35'),
(4, 1, NULL, 0x3a3a31, 'owner', '2019-06-18 13:25:06'),
(5, 2, NULL, 0x3a3a31, 'haroon', '2019-06-18 13:25:26'),
(6, 1, NULL, 0x3a3a31, 'owner', '2019-06-18 13:26:02'),
(7, 1, NULL, 0x3a3a31, 'owner', '2019-06-18 13:38:01'),
(8, 2, NULL, 0x3a3a31, 'haroon', '2019-06-18 13:44:31'),
(9, 2, NULL, 0x3a3a31, 'haroon', '2019-06-18 13:49:28'),
(10, 1, NULL, 0x3a3a31, 'owner', '2019-06-18 13:51:14'),
(11, 1, NULL, 0x3a3a31, 'owner', '2019-06-18 15:59:02'),
(12, 2, NULL, 0x3a3a31, 'haroon', '2019-06-18 15:59:16'),
(13, 2, NULL, 0x3a3a31, 'haroon', '2019-06-18 16:16:27'),
(14, 1, NULL, 0x3a3a31, 'owner', '2019-06-18 16:31:00'),
(15, 3, NULL, 0x3a3a31, 'test', '2019-06-18 16:34:06'),
(16, 1, NULL, 0x3a3a31, 'owner', '2019-06-19 05:34:48'),
(17, 2, NULL, 0x3a3a31, 'haroon', '2019-06-19 05:37:31'),
(18, 1, NULL, 0x3a3a31, 'owner', '2019-06-19 09:36:19'),
(19, 1, NULL, 0x3a3a31, 'owner', '2019-06-19 10:30:02'),
(20, 2, NULL, 0x3a3a31, 'haroon', '2019-06-19 10:30:29'),
(21, 1, NULL, 0x3a3a31, 'owner', '2019-06-20 09:05:08'),
(22, 1, NULL, 0x3a3a31, 'owner', '2019-06-24 08:32:34'),
(23, 1, NULL, 0x3a3a31, 'owner', '2019-06-24 09:54:53'),
(24, 1, NULL, 0x3a3a31, 'owner', '2019-06-25 09:18:33'),
(25, 1, NULL, 0x3a3a31, 'owner', '2019-06-25 15:10:09'),
(26, 1, NULL, 0x3a3a31, 'owner', '2019-06-27 12:57:45'),
(27, 2, NULL, 0x3a3a31, 'haroon', '2019-06-27 15:31:27'),
(28, 1, NULL, 0x3a3a31, 'owner', '2019-06-28 05:03:18'),
(29, 1, NULL, 0x3a3a31, 'owner', '2019-06-28 10:26:42'),
(30, 1, NULL, 0x3a3a31, 'owner', '2019-06-29 05:22:47'),
(31, 1, NULL, 0x3a3a31, 'owner', '2019-06-29 09:19:17'),
(32, 1, NULL, 0x3a3a31, 'owner', '2019-06-29 13:52:28'),
(33, 1, NULL, 0x3a3a31, 'owner', '2019-06-29 13:54:02'),
(34, 1, NULL, 0x3a3a31, 'owner', '2019-06-30 08:17:42'),
(35, 1, NULL, 0x3a3a31, 'owner', '2019-06-30 15:38:14'),
(36, 1, NULL, 0x3a3a31, 'owner', '2019-07-01 07:39:37'),
(37, 4, NULL, 0x3a3a31, 'bill', '2019-07-01 09:24:05'),
(38, 3, NULL, 0x3a3a31, 'test', '2019-07-01 09:26:44'),
(39, 2, NULL, 0x3a3a31, 'haroon', '2019-07-01 09:28:16'),
(40, 1, NULL, 0x3a3a31, 'owner', '2019-07-04 05:20:57'),
(41, 3, NULL, 0x3a3a31, 'test', '2019-07-04 06:53:24'),
(42, 1, NULL, 0x3a3a31, 'owner', '2019-07-04 12:27:32'),
(43, 1, NULL, 0x3a3a31, 'owner', '2019-07-05 09:38:18'),
(44, 2, NULL, 0x3a3a31, 'haroon', '2019-07-05 12:48:00'),
(45, 4, NULL, 0x3a3a31, 'bill', '2019-07-05 13:05:01'),
(46, 1, NULL, 0x3a3a31, 'owner', '2019-07-08 07:21:07'),
(47, 1, NULL, 0x3a3a31, 'owner', '2019-07-08 11:36:34'),
(48, 2, NULL, 0x3a3a31, 'haroon', '2019-07-08 11:46:01'),
(49, 1, NULL, 0x3a3a31, 'owner', '2019-07-08 15:43:03'),
(50, 1, NULL, 0x3a3a31, 'owner', '2019-07-09 09:34:48'),
(51, 1, NULL, 0x3a3a31, 'owner', '2019-07-09 11:07:16'),
(52, 2, NULL, 0x3a3a31, 'haroon', '2019-07-09 14:01:27'),
(53, 1, NULL, 0x3a3a31, 'owner', '2019-07-10 06:32:28'),
(54, 2, NULL, 0x3a3a31, 'haroon', '2019-07-10 06:33:01'),
(55, 4, NULL, 0x3a3a31, 'bill', '2019-07-10 07:15:43'),
(56, 2, NULL, 0x3a3a31, 'haroon', '2019-07-10 07:18:55'),
(57, 4, NULL, 0x3a3a31, 'bill', '2019-07-10 07:20:41'),
(58, 2, NULL, 0x3a3a31, 'haroon', '2019-07-10 08:21:03');

-- --------------------------------------------------------

--
-- Table structure for table `sma_variants`
--

DROP TABLE IF EXISTS `sma_variants`;
CREATE TABLE IF NOT EXISTS `sma_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_variants`
--

INSERT INTO `sma_variants` (`id`, `name`) VALUES
(2, 'asdasdasd'),
(4, 'werwer');

-- --------------------------------------------------------

--
-- Table structure for table `sma_warehouses`
--

DROP TABLE IF EXISTS `sma_warehouses`;
CREATE TABLE IF NOT EXISTS `sma_warehouses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `map` varchar(255) DEFAULT NULL,
  `phone` varchar(55) DEFAULT NULL,
  `email` varchar(55) DEFAULT NULL,
  `price_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_warehouses`
--

INSERT INTO `sma_warehouses` (`id`, `code`, `name`, `address`, `map`, `phone`, `email`, `price_group_id`) VALUES
(1, 'WHI', 'Warehouse 1', '\r\nAddress, City', NULL, '012345678', 'haroon@aljannat.com', NULL),
(2, 'WHII', 'Warehouse 2', '\r\nWarehouse 2, Jalan Sultan Ismail, 54000, Kuala Lumpur\r\n\r\n', NULL, '012345678', 'adil@aljannat.com', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sma_warehouses_products`
--

DROP TABLE IF EXISTS `sma_warehouses_products`;
CREATE TABLE IF NOT EXISTS `sma_warehouses_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `rack` varchar(55) DEFAULT NULL,
  `avg_cost` decimal(25,4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sma_warehouses_products`
--

INSERT INTO `sma_warehouses_products` (`id`, `product_id`, `warehouse_id`, `quantity`, `rack`, `avg_cost`) VALUES
(34, 21, 1, '60.0000', '1', '247.3648'),
(35, 22, 1, '1.0000', '1', '0.0000'),
(36, 21, 2, '0.0000', NULL, '0.0000');

-- --------------------------------------------------------

--
-- Table structure for table `sma_warehouses_products_variants`
--

DROP TABLE IF EXISTS `sma_warehouses_products_variants`;
CREATE TABLE IF NOT EXISTS `sma_warehouses_products_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `option_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `rack` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `option_id` (`option_id`),
  KEY `product_id` (`product_id`),
  KEY `warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
