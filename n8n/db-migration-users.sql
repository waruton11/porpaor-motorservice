-- ตาราง users: บัญชีเข้า admin (owner = เจ้าของ, sales = เซล)
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  role TEXT DEFAULT 'sales',     -- owner / sales
  name TEXT,                     -- ชื่อที่แสดง (ใช้เป็น assignee ตอนรับเคส)
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);
-- บัญชีเจ้าของเริ่มต้น (รหัสเดิม) — เปลี่ยนทีหลังได้
INSERT INTO users (username, password, role, name)
VALUES ('admin', 'papao2569', 'owner', 'เจ้าของร้าน')
ON CONFLICT (username) DO NOTHING;
