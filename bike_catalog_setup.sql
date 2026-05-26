-- ====================================================
-- ป.เปา มอเตอร์เซอร์วิส — สร้างตาราง bike_catalog
-- รัน script นี้ใน PostgreSQL บน Render ครั้งเดียว
-- ====================================================

-- สร้างตาราง
CREATE TABLE IF NOT EXISTS bike_catalog (
  id              SERIAL PRIMARY KEY,
  bike_type       VARCHAR(100) NOT NULL,          -- ประเภทรถ เช่น ครอบครัว (Family)
  model_name      VARCHAR(100) NOT NULL,          -- รุ่น เช่น Wave 110i
  variant_name    VARCHAR(100) DEFAULT '',        -- แบบ เช่น ล้อลวด, ABS, DCT
  engine_cc       INTEGER      DEFAULT 0,         -- ขนาดเครื่อง cc
  transmission    VARCHAR(30)  DEFAULT 'Automatic', -- เกียร์
  is_active       BOOLEAN      DEFAULT true,      -- มีจำหน่ายหรือไม่
  sort_order      INTEGER      DEFAULT 0,         -- ลำดับแสดงผล
  note            TEXT         DEFAULT '',        -- หมายเหตุเพิ่มเติม
  created_at      TIMESTAMP    DEFAULT NOW(),
  updated_at      TIMESTAMP    DEFAULT NOW()
);

-- Index เพื่อให้ query เร็วขึ้น
CREATE INDEX IF NOT EXISTS idx_bike_catalog_type     ON bike_catalog(bike_type);
CREATE INDEX IF NOT EXISTS idx_bike_catalog_active   ON bike_catalog(is_active);
CREATE INDEX IF NOT EXISTS idx_bike_catalog_sort     ON bike_catalog(sort_order, id);

-- ข้อมูลตัวอย่าง Honda ที่ร้านมักจำหน่าย (ลบหรือแก้ไขได้)
INSERT INTO bike_catalog (bike_type, model_name, variant_name, engine_cc, transmission, is_active, sort_order) VALUES
  ('ครอบครัว (Family)', 'Wave 110i',        'มาตรฐาน',  110, 'Manual',    true, 10),
  ('ครอบครัว (Family)', 'Wave 125i',        'ล้อลวด',   125, 'Manual',    true, 20),
  ('ครอบครัว (Family)', 'Wave 125i',        'ล้อแม็ก',  125, 'Manual',    true, 21),
  ('ครอบครัว (Family)', 'Dash 125',         'มาตรฐาน',  125, 'Manual',    true, 30),
  ('ครอบครัว (Family)', 'Super Cub C125',   'มาตรฐาน',  125, 'Manual',    true, 40),
  ('สกู๊ตเตอร์ออโตเมติก', 'CLICK 125i',    'ล้อแม็ก',  125, 'Automatic', true, 50),
  ('สกู๊ตเตอร์ออโตเมติก', 'CLICK 160',     'STANDARD', 160, 'Automatic', true, 51),
  ('สกู๊ตเตอร์ออโตเมติก', 'CLICK 160',     'SPECIAL',  160, 'Automatic', true, 52),
  ('สกู๊ตเตอร์ออโตเมติก', 'SCOOPY',        'มาตรฐาน',  110, 'Automatic', true, 60),
  ('สกู๊ตเตอร์ออโตเมติก', 'PCX160',        'STANDARD', 160, 'Automatic', true, 70),
  ('สกู๊ตเตอร์ออโตเมติก', 'PCX160',        'ROADSYNC', 160, 'Automatic', true, 71),
  ('สกู๊ตเตอร์ออโตเมติก', 'ADV160',        'STANDARD', 160, 'Automatic', true, 80),
  ('สกู๊ตเตอร์ออโตเมติก', 'ADV160',        'SPECIAL',  160, 'Automatic', true, 81),
  ('สกู๊ตเตอร์ออโตเมติก', 'Forza350',      'ROADSYNC', 350, 'Automatic', true, 90),
  ('สกู๊ตเตอร์ออโตเมติก', 'ADV350',        'ROADSYNC', 350, 'Automatic', true, 91),
  ('สปอร์ต (Sport)',    'CBR150R',           'มาตรฐาน',  150, 'Manual',    true, 100),
  ('สปอร์ต (Sport)',    'CBR300R',           'ABS',      300, 'Manual',    true, 110),
  ('ผจญภัย (Adventure)', 'CRF300L',         'มาตรฐาน',  300, 'Manual',    true, 120),
  ('บ๊อบเบอร์ & นีโอสปอร์ตคาเฟ่', 'CB300R',  'มาตรฐาน', 300, 'Manual',  true, 130),
  ('บ๊อบเบอร์ & นีโอสปอร์ตคาเฟ่', 'CL300',   'E-Clutch', 300, 'E-Clutch', true, 131),
  ('บ๊อบเบอร์ & นีโอสปอร์ตคาเฟ่', 'Rebel300', 'E-Clutch', 300, 'E-Clutch', true, 132),
  ('รถไฟฟ้า (EV)',      'EM1 e:',            'มาตรฐาน',    0, 'Automatic', true, 140)
ON CONFLICT DO NOTHING;

-- ตรวจสอบ
SELECT COUNT(*) AS total_bikes FROM bike_catalog;
SELECT bike_type, COUNT(*) AS count FROM bike_catalog GROUP BY bike_type ORDER BY MIN(sort_order);
