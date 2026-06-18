-- ======================================================
-- ย้าย "รุ่นรถ & ราคา" (data.categories) ขึ้น DB — แยกตามแบรนด์
-- เก็บทั้งชุดเป็น JSON ต่อ 1 แบรนด์ (honda / yamaha)
-- หมายเหตุ: ใช้ชื่อ brand_categories (ไม่ใช่ bike_categories ซึ่งเป็นตาราง
--          หมวดหมู่เดิมที่ bike_models ผูก FK อยู่ — ห้ามแตะ)
-- รันใน pgAdmin → Query Tool → Run
-- ======================================================

CREATE TABLE IF NOT EXISTS brand_categories (
  brand       VARCHAR(20) PRIMARY KEY,
  categories  JSONB NOT NULL DEFAULT '[]'::jsonb,
  updated_at  TIMESTAMP DEFAULT NOW()
);

-- ตรวจผล
SELECT 'brand_categories ready' AS info;
SELECT brand, jsonb_array_length(categories) AS num_categories, updated_at FROM brand_categories;
