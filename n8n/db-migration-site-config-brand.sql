-- ============================================================
-- site_config → brand-aware (Honda / Yamaha แยก row)
-- รัน 1 ครั้งบน Postgres prod ก่อน re-import workflow get/save-site-config
-- idempotent: รันซ้ำได้ ปลอดภัยกับ Honda ที่ live อยู่
-- ============================================================

-- 1) เพิ่มคอลัมน์ brand (ถ้ายังไม่มี — Phase 1 อาจเติมไว้แล้ว)
ALTER TABLE site_config ADD COLUMN IF NOT EXISTS brand TEXT;

-- 2) backfill row เดิม = honda (ของที่มีอยู่คือของ Honda)
UPDATE site_config SET brand = 'honda' WHERE brand IS NULL OR brand = '';

-- 3) ปลดล็อก single-row เดิม (เดิมบังคับ id=1 row เดียว) เพื่อให้มีหลายแบรนด์ได้
ALTER TABLE site_config DROP CONSTRAINT IF EXISTS single_row;

-- 4) ให้ id ออกอัตโนมัติเวลาเพิ่มแบรนด์ใหม่ (เดิม default=1 จะชนกัน)
CREATE SEQUENCE IF NOT EXISTS site_config_id_seq;
SELECT setval('site_config_id_seq', GREATEST((SELECT COALESCE(MAX(id),1) FROM site_config), 1));
ALTER TABLE site_config ALTER COLUMN id SET DEFAULT nextval('site_config_id_seq');

-- 5) unique(brand) — จำเป็นสำหรับ ON CONFLICT (brand) ใน save-site-config
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'site_config_brand_key') THEN
    ALTER TABLE site_config ADD CONSTRAINT site_config_brand_key UNIQUE (brand);
  END IF;
END $$;

-- 6) seed row yamaha โดยก๊อปจาก honda เป็นจุดตั้งต้น (เจ้าของค่อยแก้ Hero ของ Yamaha เอง)
--    ON CONFLICT DO NOTHING = ถ้ามี yamaha อยู่แล้วไม่ทับ
INSERT INTO site_config
  (brand, hero_image, hero_image_my, svc_tradein_icon, svc_testride_icon,
   benefits, category_overrides, faq, faq_my, updated_at)
SELECT
  'yamaha', hero_image, hero_image_my, svc_tradein_icon, svc_testride_icon,
  benefits, category_overrides, faq, faq_my, NOW()
FROM site_config
WHERE brand = 'honda'
ON CONFLICT (brand) DO NOTHING;

-- ตรวจ: ควรได้ 2 แถว (honda, yamaha)
-- SELECT brand, hero_image FROM site_config ORDER BY brand;
