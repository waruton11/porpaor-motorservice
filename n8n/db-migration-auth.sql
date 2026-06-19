-- ======================================================
-- ระดับ 1a: ความปลอดภัย auth จริง
--   1) hash รหัสผ่าน admin ด้วย bcrypt (pgcrypto) — เลิกเก็บ plaintext
--   2) ตาราง sessions เก็บ token หลังล็อกอิน (ใช้ guard endpoint ใน 1b/1c)
-- รันใน pgAdmin → Query Tool → Run  (รันก่อน re-import login!)
-- ======================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1) hash รหัสผ่านเดิม (plaintext → bcrypt) — ยังเก็บคอลัมน์ password ไว้ชั่วคราว
--    (login รับได้ทั้ง hash และ plaintext จนกว่าจะถึง 1c แล้วค่อยลบ plaintext)
ALTER TABLE users ADD COLUMN IF NOT EXISTS password_hash TEXT;
UPDATE users
   SET password_hash = crypt(password, gen_salt('bf'))
 WHERE password_hash IS NULL AND password IS NOT NULL;

-- 2) ตาราง session token
CREATE TABLE IF NOT EXISTS sessions (
  token      TEXT PRIMARY KEY,
  username   TEXT NOT NULL,
  role       TEXT,
  name       TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_sessions_expires ON sessions(expires_at);

-- ลบ session ที่หมดอายุ (รันเป็นครั้งคราวได้ หรือปล่อยให้ guard กรอง expires_at เอง)
-- DELETE FROM sessions WHERE expires_at < NOW();

-- ตรวจผล
SELECT username, role, active, (password_hash IS NOT NULL) AS hashed FROM users;
SELECT 'sessions ready' AS info;
