-- เพิ่ม column category_overrides สำหรับ override icon/ชื่อหมวดประเภท
-- (key = bike_type เดิม ไม่กระทบข้อมูลรถ)
ALTER TABLE site_config
  ADD COLUMN IF NOT EXISTS category_overrides JSONB DEFAULT '{}'::jsonb;
