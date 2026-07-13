-- ======================================================
-- เพิ่มคอลัมน์ lang ให้ตาราง leads เพื่อแยกลูกค้าไทย/พม่า
-- ปลอดภัย + additive:
--   • แถวเดิมทั้งหมด = NULL (แสดงเป็น "ไม่ระบุ" — ไม่มีข้อมูลย้อนหลัง)
--   • ลีดใหม่จะได้ 'th' หรือ 'my' จาก save-lead / save-leads (forward-only)
-- รันใน pgAdmin → Query Tool → วาง → Run
-- ======================================================

ALTER TABLE leads ADD COLUMN IF NOT EXISTS lang VARCHAR(5);
CREATE INDEX IF NOT EXISTS idx_leads_lang ON leads(lang);

-- ตรวจผล
SELECT 'lang column added to leads' AS info;
SELECT lang, COUNT(*) FROM leads GROUP BY lang ORDER BY 2 DESC;
