-- ====================================================
-- ป.เปา มอเตอร์เซอร์วิส — เพิ่มคอลัมน์ marketing_name
-- รัน script นี้ใน PostgreSQL (porpaor database)
-- ====================================================

ALTER TABLE bike_catalog
  ADD COLUMN IF NOT EXISTS marketing_name VARCHAR(200) DEFAULT '';

-- อัปเดตข้อมูลเก่า: ใช้ model_name + variant_name เป็น marketing_name เริ่มต้น
UPDATE bike_catalog
SET marketing_name = TRIM(CONCAT('HONDA ', model_name, ' ', COALESCE(variant_name, '')))
WHERE marketing_name = '' OR marketing_name IS NULL;
