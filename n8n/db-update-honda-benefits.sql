-- ============================================================
-- เติม 3 จุดเด่น (trust-strip) ของ Honda ใน admin/site_config
-- icon = keyword → เรนเดอร์เป็นไอคอนเส้นพรีเมียมสีแดง (tools/credit-card/shield-check)
-- เดิม benefits ของ honda ว่าง ([{},{},{}]) เลยโชว์แค่ ✨ ไม่มีข้อความ
-- รัน 1 ครั้งบน Postgres prod
-- ============================================================
UPDATE site_config
SET benefits = '[
  {"icon":"tools","label":"ศูนย์บริการฮอนด้าครบวงจร","label_my":""},
  {"icon":"credit-card","label":"ฟรีดาวน์ ผ่อนสบาย","label_my":""},
  {"icon":"shield-check","label":"บริการหลังการขาย อุ่นใจทุกการใช้งาน","label_my":""}
]'::jsonb,
    updated_at = NOW()
WHERE brand = 'honda';

-- ตรวจ: SELECT jsonb_pretty(benefits) FROM site_config WHERE brand='honda';
