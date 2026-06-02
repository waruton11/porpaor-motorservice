-- เพิ่มคอลัมน์ freebies (ของแถม) ต่อรุ่นย่อยใน bike_catalog
ALTER TABLE bike_catalog
  ADD COLUMN IF NOT EXISTS freebies JSONB DEFAULT '[]'::jsonb;
