-- ============================================================
-- site_data → brand-aware (Honda / Yamaha แยก row)  [shop/social + news]
-- รัน 1 ครั้งบน Postgres prod ก่อน re-import workflow get/save-site-data
-- idempotent: รันซ้ำได้ ปลอดภัยกับ Honda ที่ live อยู่
-- หลังรันเสร็จ workflow เดิม (WHERE id=1) ยังทำงานได้ เพราะ row เดิม (id=1) = honda
-- ============================================================

-- 1) เพิ่มคอลัมน์ brand
ALTER TABLE site_data ADD COLUMN IF NOT EXISTS brand TEXT;

-- 2) backfill row เดิม = honda (ของที่มีอยู่คือของ Honda / ป.เปา)
UPDATE site_data SET brand = 'honda' WHERE brand IS NULL OR brand = '';

-- 3) ปลดล็อก single-row เดิม (ถ้ามี) เพื่อให้มีหลายแบรนด์ได้
ALTER TABLE site_data DROP CONSTRAINT IF EXISTS single_row;

-- 4) ให้ id ออกอัตโนมัติเวลาเพิ่มแบรนด์ใหม่ (เดิม default=1 จะชนกัน)
CREATE SEQUENCE IF NOT EXISTS site_data_id_seq;
SELECT setval('site_data_id_seq', GREATEST((SELECT COALESCE(MAX(id),1) FROM site_data), 1));
ALTER TABLE site_data ALTER COLUMN id SET DEFAULT nextval('site_data_id_seq');

-- 5) unique(brand) — จำเป็นสำหรับการอ้างอิงราย brand
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'site_data_brand_key') THEN
    ALTER TABLE site_data ADD CONSTRAINT site_data_brand_key UNIQUE (brand);
  END IF;
END $$;

-- 6) seed row yamaha โดยก๊อปจาก honda เป็นจุดตั้งต้น (news/shop) — เจ้าของค่อยแก้ข้อมูลร้าน Yamaha เอง
INSERT INTO site_data (brand, categories, news, shop, updated_at)
SELECT 'yamaha', categories, news, shop, NOW()
FROM site_data WHERE brand = 'honda'
ON CONFLICT (brand) DO NOTHING;

-- 7) ตั้งค่าโซเชียล + ชื่อร้าน Yamaha ให้ถูกต้องทันที (merge เข้า jsonb shop ของแถว yamaha)
UPDATE site_data
SET shop = shop || '{"name":"สิงห์ชัยสยามยนต์","fb":"https://www.facebook.com/profile.php?id=61566402556399","tt":"https://www.tiktok.com/@singchaiyamaha","line":"https://lin.ee/X9Vbj7i"}'::jsonb
WHERE brand = 'yamaha';

-- ตรวจ: ควรได้ 2 แถว (honda, yamaha)
-- SELECT brand, shop->>'fb' AS fb, shop->>'line' AS line FROM site_data ORDER BY brand;
