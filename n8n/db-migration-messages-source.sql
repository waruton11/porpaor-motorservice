-- ======================================================
-- เพิ่มคอลัมน์ source ให้ตาราง messages
-- เพื่อรองรับการเก็บข้อความจากหลายช่องทาง (LINE + Facebook Messenger)
--
-- ปลอดภัย + additive: เพิ่มคอลัมน์เท่านั้น ไม่แตะข้อมูลเดิม
--   - แถวเดิมทั้งหมด (ที่มาจาก LINE) จะได้ค่า DEFAULT 'line' อัตโนมัติ
--   - แถวใหม่จาก Facebook จะบันทึก source='facebook'
--   - คอลัมน์ line_user_id ใช้ร่วมกัน: LINE เก็บ userId, Facebook เก็บ PSID (page-scoped id)
--
-- รันใน pgAdmin → Query Tool → วางทั้งไฟล์ → Run
-- ต้องรันบน prod ก่อน re-import workflow/endpoint ที่อ้างคอลัมน์นี้ (กัน fail เงียบ)
-- ======================================================

ALTER TABLE messages
  ADD COLUMN IF NOT EXISTS source VARCHAR(16) NOT NULL DEFAULT 'line';

CREATE INDEX IF NOT EXISTS idx_messages_source ON messages(source);

-- ตรวจผล
SELECT 'messages.source ready' AS info;
SELECT source, COUNT(*) AS n FROM messages GROUP BY source ORDER BY source;
