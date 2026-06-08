-- เพิ่มคอลัมน์ FAQ ภาษาพม่า (คนละชุดกับไทย)
ALTER TABLE site_config ADD COLUMN IF NOT EXISTS faq_my JSONB DEFAULT '[]'::jsonb;
