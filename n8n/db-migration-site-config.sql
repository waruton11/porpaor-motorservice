-- ตาราง site_config: เก็บการตั้งค่าหน้าเว็บ (hero image, benefits)
-- รัน 1 ครั้งใน Postgres console
CREATE TABLE IF NOT EXISTS site_config (
  id INT PRIMARY KEY DEFAULT 1,
  hero_image TEXT DEFAULT '',
  benefits JSONB DEFAULT '[]'::jsonb,
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT single_row CHECK (id = 1)
);

-- เริ่ม row แรก
INSERT INTO site_config (id, hero_image, benefits)
VALUES (1, '', '[
  {"icon":"🏅","label":"รับประกัน Honda"},
  {"icon":"💳","label":"ดาวน์ 0%"},
  {"icon":"📞","label":"ช่วยเหลือ 24ชม"}
]'::jsonb)
ON CONFLICT (id) DO NOTHING;
