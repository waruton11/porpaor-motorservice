-- ตาราง leads: เก็บทุก lead ที่ลูกค้าส่งเข้ามา (ค่างวด/เทิร์น/ทดลองขับ)
CREATE TABLE IF NOT EXISTS leads (
  id SERIAL PRIMARY KEY,
  lead_type TEXT NOT NULL,          -- installment / cash / tradein / testride
  model TEXT,                       -- รุ่นรถ (หรือรถเก่า/รถที่ลอง)
  variant TEXT,
  color TEXT,
  pay_type TEXT,                    -- installment / cash
  down_pct NUMERIC,
  installment INT,
  period INT,
  price INT,
  cust_name TEXT,
  cust_phone TEXT,
  line_user_id TEXT,
  detail JSONB DEFAULT '{}'::jsonb,  -- ข้อมูลเฉพาะประเภท (old_year, new_model, datetime ฯลฯ)
  created_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_leads_created ON leads(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_leads_type ON leads(lead_type);
