-- ======================================================
-- ระดับ 1c-3 Part B: ลบ plaintext password (เก็บกวาดความปลอดภัย)
-- เงื่อนไข: ต้อง re-import "Users & Login" ตัวใหม่ก่อน (login ใช้ bcrypt อย่างเดียว,
--          manage-users เลิกเขียนคอลัมน์ password) แล้วทดสอบ login ผ่าน → ค่อยรันอันนี้
-- ทุก user มี password_hash แล้ว (จาก db-migration-auth.sql + manage-users)
-- รันใน pgAdmin → Query Tool → Run
-- ======================================================

-- กันพลาด: ถ้ายังมี user ที่ไม่มี hash ให้ hash จาก plaintext ก่อน (ปกติไม่มีแล้ว)
UPDATE users SET password_hash = crypt(password, gen_salt('bf'))
 WHERE password_hash IS NULL AND password IS NOT NULL;

-- ลบคอลัมน์ plaintext
ALTER TABLE users DROP COLUMN IF EXISTS password;

-- ตรวจผล: ต้องไม่มีคอลัมน์ password แล้ว และทุก user มี hash
SELECT username, role, (password_hash IS NOT NULL) AS hashed, active FROM users ORDER BY role, id;
