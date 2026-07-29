-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2025 at 06:38 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dinemaster`
--

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `tax` decimal(10,2) NOT NULL DEFAULT 0.00,
  `service_charge` decimal(10,2) NOT NULL DEFAULT 0.00,
  `paid` tinyint(1) NOT NULL DEFAULT 0,
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `payment_method` enum('cash','card','upi') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bills`
--

INSERT INTO `bills` (`id`, `order_id`, `customer_id`, `amount`, `tax`, `service_charge`, `paid`, `paid_at`, `created_at`, `updated_at`, `payment_method`) VALUES
(1, 1, 2, 12.81, 1.80, 1.00, 1, '2025-11-24 13:51:43', '2025-11-23 05:47:46', '2025-11-24 13:51:43', 'cash'),
(2, 2, 2, 25.63, 3.60, 2.00, 1, '2025-11-23 06:13:07', '2025-11-23 06:06:42', '2025-11-23 06:13:07', 'cash'),
(3, 3, 1, 2.59, 0.36, 0.20, 1, '2025-11-23 06:33:03', '2025-11-23 06:08:47', '2025-11-23 06:33:03', 'upi'),
(4, 4, NULL, 12.81, 1.80, 1.00, 1, '2025-11-23 06:24:54', '2025-11-23 06:13:38', '2025-11-23 06:24:54', 'card'),
(5, 5, 2, 3.84, 0.54, 0.30, 0, NULL, '2025-11-24 13:50:50', '2025-11-24 17:17:02', NULL),
(6, 6, 1, 19.20, 2.70, 1.50, 0, NULL, '2025-11-24 14:03:48', '2025-11-24 14:03:48', NULL),
(7, 7, 3, 39.60, 5.57, 3.09, 0, NULL, '2025-11-25 07:33:09', '2025-11-25 07:33:09', NULL),
(8, 9, 8, 31.94, 4.49, 2.50, 1, '2025-11-27 08:23:28', '2025-11-27 08:22:29', '2025-11-27 08:23:28', 'upi');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `visits` int(10) UNSIGNED DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `phone`, `email`, `notes`, `visits`, `created_at`, `updated_at`) VALUES
(1, 'SP Praneeth', '7794055685', NULL, NULL, 3, '2025-11-23 02:40:13', '2025-11-24 17:14:18'),
(2, 'Vikranth', '9059214815', NULL, NULL, 3, '2025-11-23 04:59:59', '2025-11-25 07:24:30'),
(3, 'Shelly Sachdeva', '8263826483', NULL, NULL, 1, '2025-11-24 17:10:56', '2025-11-24 17:10:56'),
(4, 'Aditya', '9623872628', NULL, NULL, 1, '2025-11-24 17:11:27', '2025-11-24 17:11:27'),
(5, 'Abhinay', '9275278173', NULL, NULL, 1, '2025-11-24 17:11:46', '2025-11-24 17:11:46'),
(6, 'Abhinay', '9728240383', NULL, NULL, 1, '2025-11-24 17:15:29', '2025-11-24 17:15:29'),
(7, 'Shelly Sachdeva', '9836273292', NULL, NULL, 1, '2025-11-24 17:16:19', '2025-11-24 17:16:19'),
(8, 'Teja', '9638198726', NULL, NULL, 1, '2025-11-27 08:21:29', '2025-11-27 08:21:29');

-- --------------------------------------------------------

--
-- Table structure for table `dining_tables`
--

CREATE TABLE `dining_tables` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `number` int(11) NOT NULL,
  `seats` int(10) UNSIGNED DEFAULT 2,
  `status` enum('free','reserved','busy','out_of_service') DEFAULT 'free',
  `location` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dining_tables`
--

INSERT INTO `dining_tables` (`id`, `number`, `seats`, `status`, `location`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 'free', NULL, '2025-11-23 02:35:41', '2025-11-24 17:09:12'),
(2, 2, 4, 'reserved', NULL, '2025-11-23 02:35:56', '2025-11-24 17:09:27'),
(3, 3, 4, 'free', NULL, '2025-11-23 02:36:08', '2025-11-25 07:32:29'),
(4, 4, 5, 'free', NULL, '2025-11-23 02:36:19', '2025-11-25 06:54:40'),
(5, 5, 8, 'free', NULL, '2025-11-24 14:02:52', '2025-11-24 17:09:58'),
(6, 6, 6, 'busy', NULL, '2025-11-24 17:10:11', '2025-11-24 17:10:11');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(120) DEFAULT 'Main',
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`id`, `name`, `description`, `category`, `price`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Maggi', NULL, 'Starter', 1.01, 0, '2025-11-23 02:25:28', '2025-11-23 15:12:41'),
(2, 'Biryani', NULL, 'Main', 10.01, 0, '2025-11-23 02:26:10', '2025-11-23 15:13:35'),
(3, 'Hyderabad Chicken Dum Biryani', NULL, 'Main', 3.00, 0, '2025-11-24 13:50:25', '2025-11-24 16:56:28'),
(4, 'Chicken 65', NULL, 'Starter', 12.99, 1, '2025-11-24 17:00:57', '2025-11-24 17:00:57'),
(5, 'Thai Chili Shrimp', NULL, 'Starter', 16.50, 1, '2025-11-24 17:00:57', '2025-11-24 17:00:57'),
(6, 'Paneer Tikka', NULL, '12.99', 12.99, 0, '2025-11-24 17:00:57', '2025-11-24 17:06:02'),
(7, 'Chicken Biryani', NULL, 'Main', 24.95, 1, '2025-11-24 17:02:48', '2025-11-24 17:02:48'),
(8, 'CheeseBurger', NULL, 'Main', 23.50, 1, '2025-11-24 17:02:48', '2025-11-24 17:02:48'),
(9, 'Margherita Pizza', NULL, 'Main', 19.99, 1, '2025-11-24 17:02:48', '2025-11-24 17:02:48'),
(10, 'Red Velvet Cheesecake', NULL, 'Dessert', 10.95, 1, '2025-11-24 17:04:04', '2025-11-24 17:04:04'),
(11, 'Chocolate Icecream', NULL, 'Dessert', 9.00, 1, '2025-11-24 17:04:04', '2025-11-24 17:04:04'),
(12, 'Vanilla Icecream', NULL, 'Dessert', 8.77, 1, '2025-11-24 17:04:35', '2025-11-24 17:04:35'),
(13, 'Appolo Fish', NULL, 'Starter', 14.00, 1, '2025-11-24 17:05:35', '2025-11-24 17:05:35'),
(14, 'Paneer Tikka', NULL, 'Starter', 12.99, 1, '2025-11-24 17:06:24', '2025-11-24 17:06:24');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `table_id` bigint(20) UNSIGNED DEFAULT NULL,
  `staff_id` bigint(20) UNSIGNED DEFAULT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','in_progress','served','closed','cancelled') DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customer_id`, `table_id`, `staff_id`, `total`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(1, 2, 4, NULL, 10.01, 'closed', NULL, '2025-11-23 05:26:29', '2025-11-23 05:47:46'),
(2, 2, 4, NULL, 20.02, 'closed', NULL, '2025-11-23 05:27:02', '2025-11-23 06:06:42'),
(3, 1, 1, NULL, 2.02, 'closed', NULL, '2025-11-23 06:08:30', '2025-11-23 06:08:47'),
(4, NULL, 1, NULL, 10.01, 'closed', NULL, '2025-11-23 06:13:20', '2025-11-23 06:13:38'),
(5, 2, 1, NULL, 3.00, 'closed', NULL, '2025-11-24 13:50:41', '2025-11-24 13:50:50'),
(6, 1, 5, NULL, 15.00, 'closed', NULL, '2025-11-24 14:03:25', '2025-11-24 14:03:48'),
(7, 3, 1, NULL, 30.94, 'closed', NULL, '2025-11-24 17:12:52', '2025-11-25 07:33:09'),
(8, 5, 3, NULL, 46.50, 'pending', NULL, '2025-11-24 17:13:32', '2025-11-24 17:13:32'),
(9, 8, 1, NULL, 24.95, 'closed', NULL, '2025-11-27 08:22:17', '2025-11-27 08:22:29');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `menu_item_id` bigint(20) UNSIGNED NOT NULL,
  `qty` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `line_total` decimal(10,2) GENERATED ALWAYS AS (`qty` * `unit_price`) VIRTUAL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `menu_item_id`, `qty`, `unit_price`, `created_at`) VALUES
(1, 1, 2, 1, 10.01, '2025-11-23 05:26:29'),
(2, 2, 2, 1, 10.01, '2025-11-23 05:27:02'),
(3, 2, 2, 1, 10.01, '2025-11-23 05:27:02'),
(4, 3, 1, 2, 1.01, '2025-11-23 06:08:30'),
(5, 4, 2, 1, 10.01, '2025-11-23 06:13:20'),
(6, 5, 3, 1, 3.00, '2025-11-24 13:50:41'),
(7, 6, 3, 1, 3.00, '2025-11-24 14:03:25'),
(8, 6, 3, 1, 3.00, '2025-11-24 14:03:25'),
(9, 6, 3, 1, 3.00, '2025-11-24 14:03:25'),
(10, 6, 3, 1, 3.00, '2025-11-24 14:03:25'),
(11, 6, 3, 1, 3.00, '2025-11-24 14:03:25'),
(12, 7, 10, 1, 10.95, '2025-11-24 17:12:52'),
(13, 7, 9, 1, 19.99, '2025-11-24 17:12:52'),
(14, 8, 13, 1, 14.00, '2025-11-24 17:13:32'),
(15, 8, 8, 1, 23.50, '2025-11-24 17:13:32'),
(16, 8, 11, 1, 9.00, '2025-11-24 17:13:32'),
(17, 9, 10, 1, 10.95, '2025-11-27 08:22:17'),
(18, 9, 13, 1, 14.00, '2025-11-27 08:22:17');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `bill_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `method` enum('cash','card','upi','online') DEFAULT 'cash',
  `reference` varchar(255) DEFAULT NULL,
  `paid_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `reserved_date` date NOT NULL,
  `reserved_time` time NOT NULL,
  `table_id` bigint(20) UNSIGNED DEFAULT NULL,
  `guests` smallint(5) UNSIGNED DEFAULT 1,
  `status` enum('booked','seated','cancelled','no_show') DEFAULT 'booked',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`id`, `customer_id`, `name`, `phone`, `reserved_date`, `reserved_time`, `table_id`, `guests`, `status`, `created_at`, `updated_at`) VALUES
(3, 1, 'Aditya', '7794055685', '2025-11-26', '09:30:00', 4, 6, 'booked', '2025-11-24 17:14:18', '2025-11-24 17:14:18'),
(4, 6, 'Abhinay', '9728240383', '2025-11-25', '12:00:00', 2, 4, 'booked', '2025-11-24 17:15:29', '2025-11-24 17:15:29'),
(5, 7, 'Shelly Sachdeva', '9836273292', '2025-11-25', '11:30:00', 1, 2, 'booked', '2025-11-24 17:16:19', '2025-11-24 17:16:19'),
(6, 2, 'Vikranth', '9059214815', '2025-11-26', '09:30:00', 5, 7, 'booked', '2025-11-25 07:24:31', '2025-11-25 07:24:31');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `role` varchar(120) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `hired_at` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id`, `name`, `role`, `phone`, `email`, `hired_at`, `created_at`, `updated_at`) VALUES
(3, 'Vikranth', 'Admin', '9059214815', NULL, NULL, '2025-11-24 17:06:57', '2025-11-24 17:06:57'),
(4, 'Abhinay', 'Chef', '8936283628', NULL, NULL, '2025-11-24 17:07:15', '2025-11-24 17:07:15'),
(5, 'Ankith Yadav', 'Chef', '8263904736', NULL, NULL, '2025-11-24 17:07:42', '2025-11-24 17:07:42'),
(6, 'Aryan', 'Waiter', '8254638264', NULL, NULL, '2025-11-24 17:08:03', '2025-11-24 17:08:03'),
(7, 'Deepika', 'Waiter', '9263526527', NULL, NULL, '2025-11-24 17:08:34', '2025-11-24 17:08:34'),
(8, 'Teja', 'Chef', '8984239293', NULL, NULL, '2025-11-27 08:17:52', '2025-11-27 08:17:52');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `role` enum('admin','manager','staff') DEFAULT 'manager',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `name`, `email`, `role`, `created_at`, `updated_at`) VALUES
(241210031, 'abhinay', '$2y$10$GT3QYFYEuXfRB/vUzL95LOhBwpi.TZsT6FNxCrUOcEx2..SzKc/yy', 'Chilaka Abhinay', '241210031@nitdelhi.ac.in', 'manager', '2025-11-22 11:17:16', '2025-11-22 12:03:27'),
(241210032, 'vikranth', '$2y$10$rp2NYPQXc6cQn/GVbhdwJeXbd3j733v1SKHs5fluX8E//kmQvKsbO', 'Vikranth Chunduri', '241210032@nitdelhi.ac.in', 'admin', '2025-11-22 11:06:44', '2025-11-23 01:42:26');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_bills_order` (`order_id`),
  ADD KEY `fk_bills_customer` (`customer_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customers_phone` (`phone`);

--
-- Indexes for table `dining_tables`
--
ALTER TABLE `dining_tables`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_table_number` (`number`),
  ADD KEY `idx_table_status` (`status`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_menu_category` (`category`);
ALTER TABLE `menu_items` ADD FULLTEXT KEY `ft_menu_name_description` (`name`,`description`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_orders_customer` (`customer_id`),
  ADD KEY `idx_orders_table` (`table_id`),
  ADD KEY `fk_orders_staff` (`staff_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_oi_order` (`order_id`),
  ADD KEY `fk_oi_menu` (`menu_item_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pay_bill` (`bill_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_res_date` (`reserved_date`),
  ADD KEY `idx_res_table` (`table_id`),
  ADD KEY `fk_res_customer` (`customer_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_users_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `dining_tables`
--
ALTER TABLE `dining_tables`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=241210033;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `fk_bills_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bills_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_table` FOREIGN KEY (`table_id`) REFERENCES `dining_tables` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_oi_menu` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_pay_bill` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `fk_res_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_res_table` FOREIGN KEY (`table_id`) REFERENCES `dining_tables` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
