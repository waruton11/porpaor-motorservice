-- ======================================================
-- ระดับ 1a+: ล็อกอินด้วย Gmail (Sign in with Google)
--   เพิ่มคอลัมน์ email ใน users (whitelist อีเมลที่อนุญาต)
--   ใช้ตาราง sessions เดิมจาก db-migration-auth.sql (รันอันนั้นก่อน)
-- รันใน pgAdmin → Query Tool → Run
-- ======================================================

ALTER TABLE users ADD COLUMN IF NOT EXISTS email TEXT;

-- ผูกอีเมล Google ของเจ้าของกับบัญชี admin
UPDATE users SET email = 'waruton11@gmail.com'
 WHERE username = 'admin' AND (email IS NULL OR email = '');

-- กันอีเมลซ้ำ (เฉพาะแถวที่มีอีเมล — แถวที่ไม่มี Gmail เว้น NULL ได้)
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email
  ON users (lower(email)) WHERE email IS NOT NULL;

-- เพิ่มเซลที่ใช้ Gmail ล็อกอินได้ทีหลัง เช่น:
-- UPDATE users SET email = 'sale1@gmail.com' WHERE username = 'sale1';
-- หรือเพิ่มผู้ใช้ใหม่ผ่านหน้า "จัดการผู้ใช้" แล้วค่อยเซ็ต email ที่นี่

-- ตรวจผล
SELECT username, role, email, active FROM users ORDER BY role, id;
