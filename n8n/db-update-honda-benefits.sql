-- ============================================================
-- เติม 3 จุดเด่น (trust-strip) ของ Honda ใน admin/site_config
-- icon = keyword → เรนเดอร์เป็นไอคอนเส้นพรีเมียมสีแดง (tools/credit-card/shield-check)
-- label = ไทย · label_my = พม่า (fallback เป็นไทยถ้าเว้นว่าง)
-- รัน 1 ครั้งบน Postgres prod
-- ============================================================
UPDATE site_config
SET benefits = '[
  {"icon":"tools","label":"ศูนย์บริการฮอนด้าครบวงจร","label_my":"Honda ဝန်ဆောင်မှုစင်တာ ပြည့်စုံ"},
  {"icon":"credit-card","label":"ฟรีดาวน์ ผ่อนสบาย","label_my":"စရန်ငွေအခမဲ့ အရစ်ကျချောမွေ့"},
  {"icon":"shield-check","label":"บริการหลังการขาย อุ่นใจทุกการใช้งาน","label_my":"ရောင်းပြီးဝန်ဆောင်မှု စိတ်ချရ"}
]'::jsonb,
    updated_at = NOW()
WHERE brand = 'honda';

-- ตรวจ: SELECT jsonb_pretty(benefits) FROM site_config WHERE brand='honda';
