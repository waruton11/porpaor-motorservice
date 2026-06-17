-- ======================================================
-- Phase 1 (Yamaha): เพิ่มคอลัมน์ brand แบบ multi-tenant
-- ปลอดภัย + additive ล้วน:
--   • แถวเดิมทั้งหมดได้ค่า 'honda' อัตโนมัติ
--   • INSERT/SELECT เดิมไม่ระบุ brand → ใช้ DEFAULT 'honda' → Honda ทำงานเหมือนเดิม
--   • ยังไม่แตะ logic การกรอง (ทำใน Phase ถัดไป)
-- รันใน pgAdmin → Query Tool → วาง → Run
-- ======================================================

ALTER TABLE bike_catalog ADD COLUMN IF NOT EXISTS brand VARCHAR(20) NOT NULL DEFAULT 'honda';
ALTER TABLE site_config  ADD COLUMN IF NOT EXISTS brand VARCHAR(20) NOT NULL DEFAULT 'honda';
ALTER TABLE leads        ADD COLUMN IF NOT EXISTS brand VARCHAR(20) NOT NULL DEFAULT 'honda';
ALTER TABLE customers    ADD COLUMN IF NOT EXISTS brand VARCHAR(20) NOT NULL DEFAULT 'honda';
ALTER TABLE users        ADD COLUMN IF NOT EXISTS brand VARCHAR(20) NOT NULL DEFAULT 'honda';

-- index ช่วยกรองตาม brand (เร็วขึ้นเมื่อมีข้อมูล 2 แบรนด์)
CREATE INDEX IF NOT EXISTS idx_bike_catalog_brand ON bike_catalog(brand);
CREATE INDEX IF NOT EXISTS idx_leads_brand        ON leads(brand);
CREATE INDEX IF NOT EXISTS idx_customers_brand    ON customers(brand);

-- หมายเหตุ:
--   • car_prices มีคอลัมน์ brand อยู่แล้ว (เทียบราคา Honda 2 ดีลเลอร์) → ไม่แตะ
--   • price_list ยังไม่เพิ่ม brand — รอแมป price-flow ก่อน (Phase ถัดไป)

-- ตรวจผล
SELECT 'brand columns added:' AS info;
SELECT table_name, column_name, column_default
FROM information_schema.columns
WHERE column_name = 'brand' AND table_name IN ('bike_catalog','site_config','leads','customers','users','car_prices')
ORDER BY table_name;
