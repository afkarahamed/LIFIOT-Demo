-- assumes `USE lifiot` has run (from 0000_bootstrap.sql)

CREATE TABLE IF NOT EXISTS users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(120) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS devices (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  serial VARCHAR(120) NOT NULL UNIQUE,
  model VARCHAR(120) NULL,
  owner_user_id BIGINT NULL,
  status ENUM('online','offline','idle','working','error') NOT NULL DEFAULT 'offline',
  last_seen_at DATETIME NULL,
  last_telemetry JSON NULL,
  CONSTRAINT fk_devices_owner FOREIGN KEY (owner_user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS telemetry_minute (
  device_id BIGINT NOT NULL,
  bucket_minute DATETIME NOT NULL,
  ts_ms BIGINT NOT NULL,
  rpm FLOAT NULL,
  current_a FLOAT NULL,
  lat DOUBLE NULL,
  lon DOUBLE NULL,
  raw JSON NULL,
  PRIMARY KEY (device_id, bucket_minute),
  CONSTRAINT fk_tm_device FOREIGN KEY (device_id) REFERENCES devices(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS idempotency_keys (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  `key` VARCHAR(64) NOT NULL,
  user_id BIGINT NULL,
  method VARCHAR(10) NOT NULL,
  route VARCHAR(255) NOT NULL,
  request_hash CHAR(64) NOT NULL,
  status_code INT NOT NULL,
  response_body MEDIUMTEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY u_key_user (`key`, user_id),
  KEY k_created_at (created_at),
  CONSTRAINT fk_idem_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;