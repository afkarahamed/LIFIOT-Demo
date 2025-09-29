USE `lifiot_demo`;

-- Insert a demo user
INSERT INTO users (email, password_hash, name)
VALUES (
  'demo@lifiot.io',
  '$2b$10$abcdefghijklmnopqrstuvABCDEabc1234567890XYZ/abcdEFGHij', -- placeholder bcrypt hash
  'Demo User'
);

-- Insert a demo device owned by that user
INSERT INTO devices (serial, model, owner_user_id, status)
VALUES (
  'DEMO123',
  'LIFIOT-X',
  LAST_INSERT_ID(),  
  'offline'
);