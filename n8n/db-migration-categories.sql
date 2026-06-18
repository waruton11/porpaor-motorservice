-- ======================================================
-- ย้าย "รุ่นรถ & ราคา" (data.categories) ขึ้น DB — แยกตามแบรนด์
-- เก็บทั้งชุดเป็น JSON ต่อ 1 แบรนด์ (honda / yamaha)
-- ป้องกันข้อมูลหาย (เดิมอยู่ localStorage อย่างเดียว)
-- รันใน pgAdmin → Query Tool → Run
-- ======================================================

CREATE TABLE IF NOT EXISTS bike_categories (
  brand       VARCHAR(20) PRIMARY KEY,
  categories  JSONB NOT NULL DEFAULT '[]'::jsonb,
  updated_at  TIMESTAMP DEFAULT NOW()
);

-- ตรวจผล
SELECT 'bike_categories created' AS info;
SELECT brand, jsonb_array_length(categories) AS num_categories, updated_at FROM bike_categories;
