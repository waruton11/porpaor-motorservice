-- ============================================================
-- site_config → เพิ่มการตั้งค่าการแสดงรูป Hero (fit + focal position) ราย brand
-- รัน 1 ครั้งบน Postgres prod ก่อน re-import workflow Site Config (hero/faq)
-- idempotent: รันซ้ำได้ · Honda default = cover/center (ไม่เปลี่ยนพฤติกรรมเดิม)
-- ============================================================

ALTER TABLE site_config ADD COLUMN IF NOT EXISTS hero_fit TEXT DEFAULT 'cover';
ALTER TABLE site_config ADD COLUMN IF NOT EXISTS hero_pos TEXT DEFAULT 'center center';

UPDATE site_config SET hero_fit = 'cover'          WHERE hero_fit IS NULL OR hero_fit = '';
UPDATE site_config SET hero_pos = 'center center'  WHERE hero_pos IS NULL OR hero_pos = '';

-- ตรวจ: SELECT brand, hero_fit, hero_pos FROM site_config ORDER BY brand;
