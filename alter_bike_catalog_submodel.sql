-- ====================================================
-- ป.เปา มอเตอร์เซอร์วิส — เพิ่มคอลัมน์ submodel_name
-- รัน script นี้ใน PostgreSQL (porpaor database)
-- ====================================================

ALTER TABLE bike_catalog
  ADD COLUMN IF NOT EXISTS submodel_name VARCHAR(200) DEFAULT '';
