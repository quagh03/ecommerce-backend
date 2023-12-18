DROP DATABASE IF EXISTS `ecommerce`;
CREATE DATABASE `ecommerce`;

CREATE TABLE `ecommerce`.`user` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `registered_at` datetime NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `intro` tinytext COLLATE utf8mb4_unicode_ci,
  `profile` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mobile` (`mobile`),
  UNIQUE KEY `uq_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`role` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `name` enum('ROLE_ADMIN', 'ROLE_MEMBER', 'ROLE_VENDOR') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`user_role` (
  `user_id` BINARY(16) unique NOT NULL,
  `role_id` BINARY(16) NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  CONSTRAINT `fk_user_role_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce`.`user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_role_role_id` FOREIGN KEY (`role_id`) REFERENCES `ecommerce`.`role` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`vendor`(
	`id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
    `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `mobile` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
	`email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
	`province` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
	`country` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `number_of_products` int NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`product` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `vendor_id` BINARY(16) NOT NULL,
  `title` varchar(75) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` tinytext COLLATE utf8mb4_unicode_ci,
  `type` smallint NOT NULL DEFAULT '0',
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` float NOT NULL DEFAULT '0',
  `discount` float NOT NULL DEFAULT '0',
  `quantity` smallint NOT NULL DEFAULT '0',
  `shop` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `starts_at` datetime DEFAULT NULL,
  `ends_at` datetime DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `views` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_slug` (`slug`),
  KEY `idx_product_vendor` (`vendor_id`),
  CONSTRAINT `fk_product_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`cart` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `user_id` BINARY(16) DEFAULT NULL,
  `session_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` smallint NOT NULL DEFAULT '0',
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `middle_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `line1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `line2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `province` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_cart_user` (`user_id`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`cart_item` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `product_id` BINARY(16) NOT NULL,
  `cart_id` BINARY(16) NOT NULL,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` float NOT NULL DEFAULT '0',
  `discount` float NOT NULL DEFAULT '0',
  `quantity` smallint NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_cart_item_product` (`product_id`),
  KEY `idx_cart_item_cart` (`cart_id`),
  CONSTRAINT `fk_cart_item_cart` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  CONSTRAINT `fk_cart_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`category` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `parent_id` BINARY(16) DEFAULT NULL,
  `title` varchar(75) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `number_of_product` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_category_parent` (`parent_id`),
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`order` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `user_id` BINARY(16) DEFAULT NULL,
  `session_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` smallint NOT NULL DEFAULT '0',
  `sub_total` float NOT NULL DEFAULT '0',
  `item_discount` float NOT NULL DEFAULT '0',
  `tax` float NOT NULL DEFAULT '0',
  `shipping` float NOT NULL DEFAULT '0',
  `total` float NOT NULL DEFAULT '0',
  `promo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount` float NOT NULL DEFAULT '0',
  `grand_total` float NOT NULL DEFAULT '0',
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `middle_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `line1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `line2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `province` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_order_user` (`user_id`),
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`order_item` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `product_id` BINARY(16) NOT NULL,
  `order_id` BINARY(16) NOT NULL,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` float NOT NULL DEFAULT '0',
  `discount` float NOT NULL DEFAULT '0',
  `quantity` smallint NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_order_item_product` (`product_id`),
  KEY `idx_order_item_order` (`order_id`),
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`),
  CONSTRAINT `fk_order_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`product_category` (
  `product_id` BINARY(16) NOT NULL,
  `category_id` BINARY(16) NOT NULL,
  PRIMARY KEY (`product_id`,`category_id`),
  KEY `idx_pc_category` (`category_id`),
  KEY `idx_pc_product` (`product_id`),
  CONSTRAINT `fk_pc_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `fk_pc_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`product_meta` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `product_id` BINARY(16) NOT NULL,
  `key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_product_meta` (`product_id`,`key`),
  KEY `idx_meta_product` (`product_id`),
  CONSTRAINT `fk_meta_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`product_review` (
   `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
   `product_id` BINARY(16) NOT NULL,
   `parent_id` BINARY(16) DEFAULT NULL,
   `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
   `rating` smallint NOT NULL DEFAULT '0',
   `published` tinyint(1) NOT NULL DEFAULT '0',
   `created_at` datetime NOT NULL,
   `published_at` datetime DEFAULT NULL,
   `content` text COLLATE utf8mb4_unicode_ci,
   PRIMARY KEY (`id`),
   KEY `idx_review_product` (`product_id`),
   KEY `idx_review_parent` (`parent_id`),
   CONSTRAINT `fk_review_parent` FOREIGN KEY (`parent_id`) REFERENCES `product_review` (`id`),
   CONSTRAINT `fk_review_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`tag` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `title` varchar(75) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`product_tag` (
  `product_id` BINARY(16) NOT NULL,
  `tag_id` BINARY(16) NOT NULL,
  PRIMARY KEY (`product_id`,`tag_id`),
  KEY `idx_pt_tag` (`tag_id`),
  KEY `idx_pt_product` (`product_id`),
  CONSTRAINT `fk_pt_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `fk_pt_tag` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ecommerce`.`transaction` (
  `id` BINARY(16) DEFAULT (UUID_TO_BIN(UUID())),
  `user_id` BINARY(16) NOT NULL,
  `order_id` BINARY(16) NOT NULL,
  `code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` smallint NOT NULL DEFAULT '0',
  `mode` smallint NOT NULL DEFAULT '0',
  `status` smallint NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_transaction_user` (`user_id`),
  KEY `idx_transaction_order` (`order_id`),
  CONSTRAINT `fk_transaction_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`),
  CONSTRAINT `fk_transaction_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `ecommerce`.`user` 
(`first_name`, `last_name`, `mobile`, `email`, `password_hash`, `registered_at`, `last_login`, `intro`, `profile`)
VALUES
('John', 'Smith', '123456789', 'john.doe@example.com', 'password123', NOW(), NULL, 'Introduction for John Doe', 'Profile details for John Doe'),

('Jane', 'Johnson', '987654321', 'jane.lee@example.com', 'password456', NOW(), NULL, 'Introduction for Jane Lee', 'Profile details for Jane Lee'),

('Alice', 'Williams', '555555555', 'alice.wonder@example.com', 'password789', NOW(), NULL, 'Introduction for Alice Wonder', 'Profile details for Alice Wonder'),

('Bob', 'Jones', '111222333', 'bob.miller@example.com', 'passwordabc', NOW(), NULL, 'Introduction for Bob Miller', 'Profile details for Bob Miller'),

('Eva', 'Brown', '999888777', 'eva.taylor@example.com', 'passwordeva', NOW(), NULL, 'Introduction for Eva Taylor', 'Profile details for Eva Taylor');


