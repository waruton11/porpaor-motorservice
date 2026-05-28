-- ======================================================
-- ป.เปา มอเตอร์เซอร์วิส — Database Setup
-- รันใน Supabase SQL Editor หรือ pgAdmin
-- ======================================================

-- 1. เพิ่มคอลัมน์ colors ใน bike_catalog (ถ้ายังไม่มี)
ALTER TABLE bike_catalog
  ADD COLUMN IF NOT EXISTS colors TEXT DEFAULT '[]';

-- 2. สร้างตาราง price_list (เก็บราคาจาก Excel)
CREATE TABLE IF NOT EXISTS price_list (
  id            SERIAL PRIMARY KEY,
  model_code    VARCHAR(150) NOT NULL,
  variant_code  VARCHAR(100) NOT NULL DEFAULT '',
  price         INTEGER      NOT NULL DEFAULT 0,
  finance_price INTEGER      NOT NULL DEFAULT 0,
  file_type     VARCHAR(10),
  updated_at    TIMESTAMP DEFAULT NOW(),
  UNIQUE(model_code, variant_code)
);

-- เพิ่มคอลัมน์ finance_price (ถ้ายังไม่มี สำหรับ DB ที่สร้างไว้แล้ว)
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS finance_price INTEGER NOT NULL DEFAULT 0;

-- 3. Index สำหรับ JOIN ระหว่าง bike_catalog กับ price_list
CREATE INDEX IF NOT EXISTS idx_price_list_lookup
  ON price_list(model_code, variant_code);

-- ตรวจสอบ
SELECT 'bike_catalog columns:' AS info;
SELECT column_name, data_type FROM information_schema.columns
  WHERE table_name = 'bike_catalog' ORDER BY ordinal_position;

SELECT 'price_list created:' AS info;
SELECT column_name, data_type FROM information_schema.columns
  WHERE table_name = 'price_list' ORDER BY ordinal_position;
