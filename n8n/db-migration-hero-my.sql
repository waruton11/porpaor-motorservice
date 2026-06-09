-- เพิ่มคอลัมน์รูป Hero ภาษาพม่า
ALTER TABLE site_config ADD COLUMN IF NOT EXISTS hero_image_my TEXT DEFAULT '';
