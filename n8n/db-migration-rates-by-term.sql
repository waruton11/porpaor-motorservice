-- ======================================================
-- เพิ่มคอลัมน์ "ดอกเบี้ยรายงวด" (per-term interest) ให้ bike_catalog
-- ใช้กับรถเล็ก Yamaha ที่เรตต่างกันตามจำนวนงวด เช่น 24/36/42/48
-- เก็บเป็น JSON string เช่น {"24":1.06,"36":1.09,"42":1.10,"48":1.10}
-- หน่วย (เดือน/ปี) ใช้ร่วมกับคอลัมน์เดิม auto_rate_unit
-- บิ๊กไบค์ที่เป็นเรตเดียว (เช่น 6.5%/ปี) ไม่ต้องใช้คอลัมน์นี้ — ใช้ auto_rate เดิมได้
-- รันใน pgAdmin / Supabase SQL Editor (idempotent — รันซ้ำได้ปลอดภัย)
-- ======================================================

ALTER TABLE bike_catalog
  ADD COLUMN IF NOT EXISTS auto_rates_by_term TEXT DEFAULT '';

-- ตรวจสอบ
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name = 'bike_catalog' AND column_name = 'auto_rates_by_term';
