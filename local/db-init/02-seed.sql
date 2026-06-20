-- ==========================================================
-- ข้อมูลทดสอบ (local เท่านั้น — ไม่มี PII จริง)
-- รันหลัง 01-schema.sql ตอน docker compose up ครั้งแรก
-- ==========================================================

-- บัญชี admin (เจ้าของ) — ล็อกอินด้วยรหัสผ่าน หรือ Gmail waruton11@gmail.com
INSERT INTO users (username, password, password_hash, role, name, email, active)
VALUES ('admin', 'papao2569', crypt('papao2569', gen_salt('bf')), 'owner', 'เจ้าของร้าน (local)', 'waruton11@gmail.com', true)
ON CONFLICT (username) DO NOTHING;

-- บัญชีเซลทดสอบ
INSERT INTO users (username, password, password_hash, role, name, active)
VALUES ('salesA', 'sales123', crypt('sales123', gen_salt('bf')), 'sales', 'เซลเอ (local)', true)
ON CONFLICT (username) DO NOTHING;

-- site_config row แรก
INSERT INTO site_config (id, hero_image, benefits)
VALUES (1, '', '[{"icon":"🏅","label":"รับประกัน Honda"},{"icon":"💳","label":"ดาวน์ 0%"}]'::jsonb)
ON CONFLICT (id) DO NOTHING;

-- หมวดรถทดสอบ (honda)
INSERT INTO brand_categories (brand, categories) VALUES
('honda', '[{"name":"ทดสอบ (Family)","icon":"🛵","color":"#e8f5e9","models":[{"name":"Honda Test125","price":50000,"badge":"","icon":"🛵","variants":[{"name":"มาตรฐาน","price":50000,"downs":[]}],"colors":[{"name":"แดง","hex":"#cc0000"}],"gallery":[]}]}]'::jsonb)
ON CONFLICT (brand) DO NOTHING;

-- ลูกค้าทดสอบ (เบอร์ปลอม)
INSERT INTO customers (line_user_id, display_name, phone, status, interest_model) VALUES
('Utest001','ลูกค้าทดสอบ A','0800000001','new','Honda Test125'),
('Utest002','ลูกค้าทดสอบ B','0800000002','following','Honda Test125')
ON CONFLICT (line_user_id) DO NOTHING;
