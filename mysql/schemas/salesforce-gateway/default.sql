
CREATE DATABASE IF NOT EXISTS salesforce_gateway;

CREATE TABLE IF NOT EXISTS `leads` (
  `id` varchar(100) NOT NULL,
  `lead_source` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `last_update_url_datetime` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;