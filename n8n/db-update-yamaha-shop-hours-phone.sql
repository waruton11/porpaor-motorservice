-- ============================================================
-- ตั้งค่าเวลาเปิด + เบอร์โทร ร้าน Yamaha (สิงห์ชัยสยามยนต์) ใน admin/site_data
-- merge เข้า jsonb shop ของแถว yamaha — ไม่ทับ name/social/address เดิม
-- รัน 1 ครั้งบน Postgres prod
-- ============================================================
UPDATE site_data
SET shop = shop || '{"hours":"08:00 – 17:30","phone":"092-249968-1"}'::jsonb
WHERE brand = 'yamaha';

-- ตรวจ: SELECT shop->>'hours' AS hours, shop->>'phone' AS phone FROM site_data WHERE brand='yamaha';
