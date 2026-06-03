-- เพิ่มคอลัมน์ faq (คำถามที่พบบ่อย) ใน site_config
ALTER TABLE site_config
  ADD COLUMN IF NOT EXISTS faq JSONB DEFAULT '[]'::jsonb;
