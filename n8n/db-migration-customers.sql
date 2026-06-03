-- ตาราง customers: โปรไฟล์ลูกค้า 1 คน/userId (รวมจาก leads)
CREATE TABLE IF NOT EXISTS customers (
  id SERIAL PRIMARY KEY,
  line_user_id TEXT UNIQUE NOT NULL,   -- Customer ID (key)
  display_name TEXT,                   -- ชื่อที่เซลแก้ได้ (รหัสอ่านง่าย PP-#### = 'PP-'+id)
  phone TEXT,
  status TEXT DEFAULT 'new',           -- new🔴 / following🟡 / approved🟢 / rejected⚫ / owner🔵
  assignee TEXT,                       -- เซลที่รับเคส (กันโทรซ้ำ)
  interest_model TEXT,                 -- รุ่นที่สนใจล่าสุด
  lead_count INT DEFAULT 0,
  purchase_date DATE,                  -- วันออกรถ (ไว้คำนวณ 30 วัน → owner)
  note TEXT,                           -- โน้ตเซล
  first_seen TIMESTAMP DEFAULT NOW(),
  last_seen TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_customers_status ON customers(status);
CREATE INDEX IF NOT EXISTS idx_customers_interest ON customers(interest_model);
