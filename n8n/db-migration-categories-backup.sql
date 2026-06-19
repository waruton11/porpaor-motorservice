-- ======================================================
-- กันข้อมูล "รุ่นรถ & ราคา" หาย: เก็บ snapshot ก่อนทุกครั้งที่เขียนทับ
-- ทุกครั้งที่ save-categories ทำงาน จะ copy แถวเดิมลงตารางนี้ก่อน UPSERT
-- กู้คืนได้ด้วย: ดูแถวล่าสุดก่อนเวลาที่พลาด แล้ว save กลับ
-- รันใน pgAdmin → Query Tool → Run
-- ======================================================

CREATE TABLE IF NOT EXISTS brand_categories_backup (
  id           SERIAL PRIMARY KEY,
  brand        VARCHAR(20) NOT NULL,
  categories   JSONB NOT NULL,
  num_models   INT,
  backed_up_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_bcat_backup_brand_time
  ON brand_categories_backup (brand, backed_up_at DESC);

-- ดูประวัติ backup (ล่าสุดอยู่บน)
-- SELECT id, brand, num_models, jsonb_array_length(categories) AS num_cats, backed_up_at
-- FROM brand_categories_backup ORDER BY backed_up_at DESC LIMIT 20;

-- กู้คืนแถวใดแถวหนึ่ง (แทน <ID> ด้วย id ที่ต้องการ):
-- INSERT INTO brand_categories (brand, categories, updated_at)
-- SELECT brand, categories, NOW() FROM brand_categories_backup WHERE id = <ID>
-- ON CONFLICT (brand) DO UPDATE SET categories = EXCLUDED.categories, updated_at = NOW();
