-- ======================================================
-- ตาราง messages: เก็บ "คำถาม/ข้อความ" ที่ลูกค้าพิมพ์เข้ามาทาง LINE OA
-- ใช้กับ "ระบบเก็บคำถามลูกค้าอัตโนมัติ" (FAQ) — Yamaha pilot
--
-- ปลอดภัย + additive: สร้างตารางใหม่เท่านั้น ไม่แตะข้อมูลเดิม
-- เก็บเฉพาะข้อความตัวอักษร (text) และเบอร์โทรถูกเซ็นเซอร์ก่อนบันทึกในฝั่ง n8n
-- (PDPA — เบอร์จริงยังถูกเก็บไว้ใน customers/leads ตามเดิม)
--
-- รันใน pgAdmin → Query Tool → วางทั้งไฟล์ → Run
-- ต้องรันบน prod ก่อน re-import workflow ที่เขียนตารางนี้ (กัน fail เงียบ)
-- ======================================================

CREATE TABLE IF NOT EXISTS messages (
  id            SERIAL PRIMARY KEY,
  line_user_id  VARCHAR(64),
  brand         VARCHAR(16)  NOT NULL DEFAULT 'yamaha',
  message_type  VARCHAR(24)  NOT NULL DEFAULT 'text',
  text          TEXT,
  created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at);
CREATE INDEX IF NOT EXISTS idx_messages_brand      ON messages(brand);

-- ตรวจผล
SELECT 'messages table ready' AS info;
SELECT COUNT(*) AS message_count FROM messages;
