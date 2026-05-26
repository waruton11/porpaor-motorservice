-- ====================================================
-- ป.เปา มอเตอร์เซอร์วิส — สร้างตารางรุ่นรถ Honda
-- รัน script นี้ใน PostgreSQL (porpaor database)
-- ====================================================

-- ==================== CREATE TABLES ====================

CREATE TABLE IF NOT EXISTS bike_categories (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  icon        VARCHAR(10)  DEFAULT '🛵',
  color       VARCHAR(20)  DEFAULT '#f5f5f5',
  sort_order  INTEGER      DEFAULT 0
);

CREATE TABLE IF NOT EXISTS bike_models (
  id          SERIAL PRIMARY KEY,
  category_id INTEGER REFERENCES bike_categories(id) ON DELETE CASCADE,
  name        VARCHAR(100) NOT NULL,
  badge       VARCHAR(50)  DEFAULT '',
  icon        VARCHAR(10)  DEFAULT '🛵',
  down_text   VARCHAR(100) DEFAULT '',
  sort_order  INTEGER      DEFAULT 0
);

CREATE TABLE IF NOT EXISTS bike_variants (
  id           SERIAL PRIMARY KEY,
  model_id     INTEGER REFERENCES bike_models(id) ON DELETE CASCADE,
  name         VARCHAR(100) NOT NULL,
  price        INTEGER      NOT NULL,
  finance_base INTEGER      DEFAULT 0,
  rate_unit    VARCHAR(10)  DEFAULT 'month',
  sort_order   INTEGER      DEFAULT 0
);

CREATE TABLE IF NOT EXISTS bike_downs (
  id            SERIAL PRIMARY KEY,
  variant_id    INTEGER      REFERENCES bike_variants(id) ON DELETE CASCADE,
  down_amount   INTEGER      NOT NULL,
  interest_rate DECIMAL(5,3) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS bike_installments (
  id          SERIAL PRIMARY KEY,
  variant_id  INTEGER REFERENCES bike_variants(id) ON DELETE CASCADE,
  down_amount INTEGER NOT NULL,
  months      INTEGER NOT NULL,
  amount      INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS bike_colors (
  id           SERIAL PRIMARY KEY,
  model_id     INTEGER REFERENCES bike_models(id) ON DELETE CASCADE,
  name         VARCHAR(100) DEFAULT '',
  hex          VARCHAR(10)  DEFAULT '#000000',
  hex2         VARCHAR(10)  DEFAULT '',
  img          TEXT         DEFAULT '',
  variant_name VARCHAR(100) DEFAULT ''
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_models_cat     ON bike_models(category_id);
CREATE INDEX IF NOT EXISTS idx_variants_model ON bike_variants(model_id);
CREATE INDEX IF NOT EXISTS idx_downs_variant  ON bike_downs(variant_id);
CREATE INDEX IF NOT EXISTS idx_inst_variant   ON bike_installments(variant_id, down_amount);
CREATE INDEX IF NOT EXISTS idx_colors_model   ON bike_colors(model_id);

-- ==================== INSERT CATEGORIES ====================

INSERT INTO bike_categories (id, name, icon, color, sort_order) VALUES
  (1, 'ครอบครัว (Family)',             '🏘️', '#e8f5e9', 1),
  (2, 'สกู๊ตเตอร์ออโตเมติก',           '🛵', '#fff3e0', 2),
  (3, 'สปอร์ต (Sport)',                '🏍️', '#fce4ec', 3),
  (4, 'ผจญภัย (Adventure)',            '🗺️', '#e3f2fd', 4),
  (5, 'บ๊อบเบอร์ & นีโอสปอร์ตคาเฟ่',  '☕', '#f3e5f5', 5),
  (6, 'รถไฟฟ้า (EV)',                 '⚡', '#e0f7fa', 6)
ON CONFLICT (id) DO NOTHING;
SELECT setval('bike_categories_id_seq', 6);

-- ==================== INSERT MODELS ====================

INSERT INTO bike_models (id, category_id, name, badge, icon, down_text, sort_order) VALUES
  -- ครอบครัว (Family)
  (1,  1, 'Honda Wave110i',   '',          '🛵', '',                    1),
  (2,  1, 'Honda Wave125i',   '',          '🛵', '',                    2),
  (3,  1, 'Honda Super Cub',  '',          '🛵', '',                    3),
  -- สกู๊ตเตอร์ออโตเมติก
  (4,  2, 'Honda Scoopy',     'NEW',       '🛵', '',                    1),
  (5,  2, 'Honda Giorno+',    '',          '🛵', '',                    2),
  (6,  2, 'Honda Lead125',    '',          '🛵', '',                    3),
  (7,  2, 'Honda Click125',   '',          '🛵', '',                    4),
  (8,  2, 'Honda Click160',   'ยอดนิยม',  '🛵', '',                    5),
  (9,  2, 'Honda ADV160',     '',          '🛵', '',                    6),
  (10, 2, 'Honda PCX160',     'ขายดี',    '🛵', '',                    7),
  (11, 2, 'Honda Forza350',   'พรีเมียม', '🛵', 'ดาวน์เริ่มต้น 10%',   8),
  (12, 2, 'Honda ADV350',     '',          '🛵', 'ดาวน์เริ่มต้น 10%',   9),
  -- สปอร์ต
  (13, 3, 'GROM',             '',          '🏍️', '',                   1),
  (14, 3, 'Honda CBR150R',    'NEW',       '🏍️', '',                   2),
  -- ผจญภัย
  (15, 4, 'Honda CRF300 L',   'NEW',       '🏍️', 'ดาวน์เริ่มต้น 15%',  1),
  -- บ๊อบเบอร์
  (16, 5, 'Honda CB150R',     '',          '🏍️', '',                   1),
  (17, 5, 'Honda CB300R',     '',          '🏍️', 'ดาวน์เริ่มต้น 15%',  2),
  (18, 5, 'Honda CL300',      'New',       '🛵', 'ดาวน์เริ่มต้น 10%',  3),
  (19, 5, 'Honda Rebel300',   'New',       '🛵', 'ดาวน์เริ่มต้น 15%',  4),
  -- EV
  (20, 6, 'Honda UC3',        'EV',        '⚡', '',                   1)
ON CONFLICT (id) DO NOTHING;
SELECT setval('bike_models_id_seq', 20);

-- ==================== INSERT VARIANTS ====================

INSERT INTO bike_variants (id, model_id, name, price, finance_base, rate_unit, sort_order) VALUES
  -- Honda Wave110i (model 1)
  (1,  1,  'ล้อซี่ลวด (ดรัมเบรก)',              41900,      0, 'month', 1),
  (2,  1,  'ล้อซี่ลวด (ดิสก์เบรก)',             49200,      0, 'month', 2),
  (3,  1,  'ล้อแม็ก',                           51200,      0, 'month', 3),
  (4,  1,  'ล้อแม็ก (สเปเชียล)',                51700,      0, 'month', 4),
  -- Honda Wave125i (model 2)
  (5,  2,  'ล้อลวด',                            60100,      0, 'month', 1),
  (6,  2,  'ล้อแม็ก',                           62300,      0, 'month', 2),
  (7,  2,  'ล้อแม็ก (รีโมท)',                   63700,      0, 'month', 3),
  -- Honda Super Cub (model 3)
  (8,  3,  'ล้อลวด',                            53500,      0, 'month', 1),
  -- Honda Scoopy (model 4)
  (9,  4,  'URBAN (ล้อลวด)',                     53500,      0, 'month', 1),
  (10, 4,  'PRESTIGE (ล้อแม็ก)',                56600,      0, 'month', 2),
  (11, 4,  'CLUB12 (ล้อแม็ก รีโมท)',            58000,      0, 'month', 3),
  (12, 4,  'CLUB12 Cinnamoroll Limited Edition', 62700,      0, 'month', 4),
  -- Honda Giorno+ (model 5)
  (13, 5,  'CBS',                               71600,      0, 'month', 1),
  (14, 5,  'ABS',                               76600,      0, 'month', 2),
  -- Honda Lead125 (model 6)
  (15, 6,  'CBS',                               64900,      0, 'month', 1),
  (16, 6,  'ABS',                               69900,      0, 'month', 2),
  -- Honda Click125 (model 7)
  (17, 7,  'ล้อแม็ก',                           59800,      0, 'month', 1),
  -- Honda Click160 (model 8)
  (18, 8,  'STANDARD',                          73300,      0, 'month', 1),
  (19, 8,  'SPECIAL',                           73800,      0, 'month', 2),
  -- Honda ADV160 (model 9)
  (20, 9,  'STANDARD',                         104300,      0, 'month', 1),
  (21, 9,  'SPECIAL',                          104800,      0, 'month', 2),
  -- Honda PCX160 (model 10)
  (22, 10, 'STANDARD',                          99900,      0, 'month', 1),
  (23, 10, 'ROADSYNC',                         102100,      0, 'month', 2),
  -- Honda Forza350 (model 11) — ดอกเบี้ย %/ปี
  (24, 11, 'ROADSYNC',                         187600,      0, 'year',  1),
  -- Honda ADV350 (model 12) — ดอกเบี้ย %/ปี
  (25, 12, 'ROADSYNC',                         194800,      0, 'year',  1),
  -- GROM (model 13)
  (26, 13, 'ABS',                               80800,      0, 'month', 1),
  -- Honda CBR150R (model 14)
  (27, 14, 'มาตรฐาน',                          102900,      0, 'month', 1),
  -- Honda CRF300L (model 15) — ดอกเบี้ย %/ปี
  (28, 15, 'มาตรฐาน',                          158000,      0, 'year',  1),
  -- Honda CB150R (model 16) — มี financeBase
  (29, 16, 'มาตรฐาน',                          115500, 116500, 'month', 1),
  -- Honda CB300R (model 17) — ดอกเบี้ย %/ปี
  (30, 17, 'มาตรฐาน',                          157200,      0, 'year',  1),
  -- Honda CL300 (model 18) — ดอกเบี้ย %/ปี
  (31, 18, 'E-CLUTCH',                         167400,      0, 'year',  1),
  -- Honda Rebel300 (model 19) — ดอกเบี้ย %/ปี
  (32, 19, 'E-CLUTCH',                         164400,      0, 'year',  1),
  -- Honda UC3 (model 20)
  (33, 20, 'มาตรฐาน',                          132600,      0, 'month', 1)
ON CONFLICT (id) DO NOTHING;
SELECT setval('bike_variants_id_seq', 33);

-- ==================== INSERT DOWNS + RATES ====================
-- down_amount = จำนวนดาวน์ (บาท), interest_rate = อัตราดอกเบี้ย

INSERT INTO bike_downs (variant_id, down_amount, interest_rate) VALUES
  -- Wave110i ดรัม (v1) — 1.09%/เดือน
  (1,0,1.09),(1,5000,1.09),(1,10000,1.09),
  -- Wave110i ดิสก์ (v2)
  (2,0,1.09),(2,5000,1.09),(2,10000,1.09),
  -- Wave110i แม็ก (v3)
  (3,0,1.09),(3,5000,1.09),(3,10000,1.09),
  -- Wave110i แม็กสเปเชียล (v4)
  (4,0,1.09),(4,5000,1.09),(4,10000,1.09),
  -- Wave125i ลวด (v5)
  (5,0,1.09),(5,5000,1.09),(5,10000,1.09),
  -- Wave125i แม็ก (v6)
  (6,0,1.09),(6,5000,1.09),(6,10000,1.09),
  -- Wave125i แม็กรีโมท (v7)
  (7,0,1.09),(7,5000,1.09),(7,10000,1.09),
  -- Super Cub (v8)
  (8,0,1.09),(8,5000,1.09),(8,10000,1.09),
  -- Scoopy URBAN (v9)
  (9,0,1.09),(9,5000,1.09),(9,10000,1.09),
  -- Scoopy PRESTIGE (v10)
  (10,0,1.09),(10,5000,1.09),(10,10000,1.09),
  -- Scoopy CLUB12 (v11)
  (11,0,1.09),(11,5000,1.09),(11,10000,1.09),
  -- Scoopy Cinnamoroll (v12)
  (12,0,1.09),(12,5000,1.09),(12,10000,1.09),
  -- Giorno+ CBS (v13)
  (13,0,1.09),(13,5000,1.09),(13,10000,1.09),
  -- Giorno+ ABS (v14)
  (14,0,1.09),(14,5000,1.09),(14,10000,1.09),
  -- Lead125 CBS (v15)
  (15,0,1.09),(15,5000,1.09),(15,10000,1.09),
  -- Lead125 ABS (v16)
  (16,0,1.09),(16,5000,1.09),(16,10000,1.09),
  -- Click125 แม็ก (v17)
  (17,0,1.09),(17,5000,1.09),(17,10000,1.09),
  -- Click160 STANDARD (v18)
  (18,0,1.09),(18,5000,1.09),(18,10000,1.09),
  -- Click160 SPECIAL (v19)
  (19,0,1.09),(19,5000,1.09),(19,10000,1.09),
  -- ADV160 STANDARD (v20)
  (20,0,1.09),(20,5000,1.09),(20,10000,1.09),
  -- ADV160 SPECIAL (v21)
  (21,0,1.09),(21,5000,1.09),(21,10000,1.09),
  -- PCX160 STANDARD (v22)
  (22,0,1.09),(22,5000,1.09),(22,10000,1.09),
  -- PCX160 ROADSYNC (v23)
  (23,0,1.09),(23,5000,1.09),(23,10000,1.09),
  -- Forza350 (v24) — %/ปี ต่างกันตามดาวน์
  (24,20800,7.00),(24,30100,5.00),(24,39400,5.00),
  -- ADV350 (v25) — %/ปี
  (25,21800,7.00),(25,30500,5.00),(25,40000,5.00),
  -- GROM (v26)
  (26,0,1.09),(26,5000,1.09),(26,10000,1.09),
  -- CBR150R (v27)
  (27,0,1.09),(27,5000,1.09),(27,10000,1.09),
  -- CRF300L (v28) — %/ปี
  (28,25500,7.00),(28,33300,5.00),(28,43000,5.00),
  -- CB150R (v29)
  (29,0,1.09),(29,5000,1.09),(29,10000,1.09),
  -- CB300R (v30) — %/ปี
  (30,25300,7.00),(30,33100,5.00),(30,48600,5.00),
  -- CL300 (v31) — %/ปี
  (31,19000,7.00),(31,27200,5.00),(31,35500,5.00),
  -- Rebel300 (v32) — %/ปี
  (32,18700,7.00),(32,26800,5.00),(32,34900,5.00),
  -- UC3 (v33) — %/เดือน ต่างกันตามดาวน์
  (33,0,0.49),(33,13260,0.39),(33,26520,0.99);

-- ==================== INSERT INSTALLMENTS ====================
-- ค่างวดที่กำหนดไว้จากตารางไฟแนนซ์จริง (บาท/เดือน)

INSERT INTO bike_installments (variant_id, down_amount, months, amount) VALUES
  -- Wave110i ล้อซี่ลวด (ดรัมเบรก) variant_id=1
  (1,0,24,2203),(1,0,30,1854),(1,0,36,1621),(1,0,42,1455),(1,0,48,1330),
  (1,5000,24,1940),(1,5000,30,1633),(1,5000,36,1428),(1,5000,42,1281),(1,5000,48,1171),
  (1,10000,24,1677),(1,10000,30,1412),(1,10000,36,1234),(1,10000,42,1108),(1,10000,48,1013),
  -- Wave110i ล้อซี่ลวด (ดิสก์เบรก) variant_id=2
  (2,0,24,2870),(2,0,30,2418),(2,0,36,2124),(2,0,42,1918),(2,0,48,1754),
  (2,5000,24,2610),(2,5000,30,2198),(2,5000,36,1931),(2,5000,42,1743),(2,5000,48,1594),
  (2,10000,24,2348),(2,10000,30,1978),(2,10000,36,1738),(2,10000,42,1568),(2,10000,48,1435),
  -- Wave110i ล้อแม็ก variant_id=3
  (3,0,24,2975),(3,0,30,2506),(3,0,36,2202),(3,0,42,1987),(3,0,48,1818),
  (3,5000,24,2714),(3,5000,30,2286),(3,5000,36,2008),(3,5000,42,1813),(3,5000,48,1658),
  (3,10000,24,2452),(3,10000,30,2066),(3,10000,36,1815),(3,10000,42,1638),(3,10000,48,1499),
  -- Wave110i ล้อแม็ก (สเปเชียล) variant_id=4
  (4,0,24,3001),(4,0,30,2529),(4,0,36,2221),(4,0,42,2005),(4,0,48,1834),
  (4,5000,24,2740),(4,5000,30,2308),(4,5000,36,2028),(4,5000,42,1830),(4,5000,48,1674),
  (4,10000,24,2478),(4,10000,30,2088),(4,10000,36,1834),(4,10000,42,1656),(4,10000,48,1515),
  -- Wave125i ล้อลวด variant_id=5
  (5,0,24,3440),(5,0,30,2898),(5,0,36,2546),(5,0,42,2298),(5,0,48,2102),
  (5,5000,24,3179),(5,5000,30,2678),(5,5000,36,2353),(5,5000,42,2123),(5,5000,48,1943),
  (5,10000,24,2917),(5,10000,30,2458),(5,10000,36,2159),(5,10000,42,1949),(5,10000,48,1783),
  -- Wave125i ล้อแม็ก variant_id=6
  (6,0,24,3555),(6,0,30,2995),(6,0,36,2631),(6,0,42,2375),(6,0,48,2172),
  (6,5000,24,3294),(6,5000,30,2775),(6,5000,36,2438),(6,5000,42,2200),(6,5000,48,2013),
  (6,10000,24,3032),(6,10000,30,2555),(6,10000,36,2244),(6,10000,42,2026),(6,10000,48,1853),
  -- Wave125i ล้อแม็ก (รีโมท) variant_id=7
  (7,0,24,3628),(7,0,30,3057),(7,0,36,2685),(7,0,42,2424),(7,0,48,2217),
  (7,5000,24,3367),(7,5000,30,2837),(7,5000,36,2492),(7,5000,42,2249),(7,5000,48,2058),
  (7,10000,24,3106),(7,10000,30,2617),(7,10000,36,2298),(7,10000,42,2075),(7,10000,48,1898),
  -- Super Cub ล้อลวด variant_id=8
  (8,0,24,2797),(8,0,30,2357),(8,0,36,2070),(8,0,42,1869),(8,0,48,1709),
  (8,5000,24,2536),(8,5000,30,2137),(8,5000,36,1877),(8,5000,42,1694),(8,5000,48,1550),
  (8,10000,24,2287),(8,10000,30,1925),(8,10000,36,1683),(8,10000,42,1510),(8,10000,48,1381),
  -- Scoopy PRESTIGE variant_id=10
  (10,0,24,3038),(10,0,30,2559),(10,0,36,2248),(10,0,42,2029),(10,0,48,1856),
  (10,5000,24,2776),(10,5000,30,2339),(10,5000,36,2055),(10,5000,42,1855),(10,5000,48,1697),
  (10,10000,24,2529),(10,10000,30,2128),(10,10000,36,1861),(10,10000,42,1670),(10,10000,48,1527),
  -- Scoopy CLUB12 variant_id=11
  (11,0,24,3111),(11,0,30,2621),(11,0,36,2302),(11,0,42,2078),(11,0,48,1901),
  (11,5000,24,2850),(11,5000,30,2401),(11,5000,36,2109),(11,5000,42,1904),(11,5000,48,1741),
  (11,10000,24,2603),(11,10000,30,2190),(11,10000,36,1915),(11,10000,42,1819),(11,10000,48,1571),
  -- Scoopy Cinnamoroll variant_id=12
  (12,0,24,3296),(12,0,30,2774),(12,0,36,2426),(12,0,42,2177),(12,0,48,1990),
  (12,5000,24,3034),(12,5000,30,2553),(12,5000,36,2232),(12,5000,42,2003),(12,5000,48,1832),
  (12,10000,24,2771),(12,10000,30,2332),(12,10000,36,2039),(12,10000,42,1830),(12,10000,48,1673),
  -- CB150R variant_id=29 (financeBase=116500)
  (29,0,24,6090),(29,0,30,5131),(29,0,36,4507),(29,0,42,4068),(29,0,48,3721),
  (29,5000,24,5829),(29,5000,30,4911),(29,5000,36,4314),(29,5000,42,3893),(29,5000,48,3562),
  (29,10000,24,5567),(29,10000,30,4691),(29,10000,36,4120),(29,10000,42,3719),(29,10000,48,3402);

-- ==================== INSERT COLORS ====================

INSERT INTO bike_colors (model_id, name, hex, hex2, img, variant_name) VALUES
  -- Wave110i (model 1)
  (1,'ดำ',              '#000000','',        '/images/WAVE 110 2025/WAVE1102025spoke/Black.png',                        'ล้อซี่ลวด (ดรัมเบรก)'),
  (1,'ดำ',              '#000000','',        '/images/WAVE 110 2025/WAVE1102025dise/WheelBlack.png',                    'ล้อซี่ลวด (ดิสก์เบรก)'),
  (1,'น้ำเงิน-ดำ',      '#1220d2','#000000', '/images/WAVE 110 2025/WAVE1102025dise/WheelBlue.png',                    'ล้อซี่ลวด (ดิสก์เบรก)'),
  (1,'เทา-ดำ',          '#b1b1b1','#000000', '/images/WAVE 110 2025/WAVE1102025dise/WheelGray.png',                    'ล้อซี่ลวด (ดิสก์เบรก)'),
  (1,'น้ำเงิน',         '#1220d2','',        '/images/WAVE 110 2025/WAVE1102025alloy/MaxWheelBlue.png',                'ล้อแม็ก'),
  (1,'เทา',             '#b1b1b1','',        '/images/WAVE 110 2025/WAVE1102025alloy/MaxWheelGray.png',                'ล้อแม็ก'),
  (1,'แดง',             '#d20008','',        '/images/WAVE 110 2025/WAVE1102025alloy/MaxWheelRed.png',                 'ล้อแม็ก'),
  (1,'ดำ-น้ำตาล',       '#000000','#342e26', '/images/WAVE 110 2025/WAVE1102025alloySpecial/SpecialBlackBBR.png',      'ล้อแม็ก (สเปเชียล)'),
  (1,'ขาว-น้ำตาล',      '#ffffff','#342e26', '/images/WAVE 110 2025/WAVE1102025alloySpecial/SpecialWhiteWBR.png',      'ล้อแม็ก (สเปเชียล)'),
  -- Wave125i (model 2)
  (2,'ดำ',              '#000000','',        '/images/WAVE 125 2025/WAVE1252025dise/ThaiHondaWave1252025BLK.png',      'ล้อลวด'),
  (2,'แดง-ดำ',          '#b70818','#000000', '/images/WAVE 125 2025/WAVE1252025dise/ThaiHondaWave1252025R-B.png',      'ล้อลวด'),
  (2,'ดำ',              '#000000','',        '/images/WAVE 125 2025/WAVE1252025alloy/ThaiHondaWave1252025BLK.png',     'ล้อแม็ก'),
  (2,'น้ำตาล-ดำ',       '#6f605d','#000000', '/images/WAVE 125 2025/WAVE1252025alloy/ThaiHondaWave1252025BRB.png',     'ล้อแม็ก'),
  (2,'น้ำเงิน-ดำ',      '#25344f','#000000', '/images/WAVE 125 2025/WAVE1252025alloy/ThaiHondaWave1252025BUB.png',     'ล้อแม็ก'),
  (2,'ขาว-ดำ',          '#ffffff','#000000', '/images/WAVE 125 2025/WAVE1252025alloy/ThaiHondaWave1252025W-B.png',     'ล้อแม็ก'),
  (2,'ดำ',              '#000000','',        '/images/WAVE 125 2025/WAVE1252025alloySpecial/ThaiHondaWave1252025SmartKeyBLK.png','ล้อแม็ก (รีโมท)'),
  (2,'น้ำตาล-ดำ',       '#6f605d','#000000', '/images/WAVE 125 2025/WAVE1252025alloySpecial/ThaiHondaWave1252025SmartKeyBRB.png','ล้อแม็ก (รีโมท)'),
  (2,'น้ำเงิน-ดำ',      '#25344f','#000000', '/images/WAVE 125 2025/WAVE1252025alloySpecial/ThaiHondaWave1252025SmartKeyBUB.png','ล้อแม็ก (รีโมท)'),
  (2,'ขาว-ดำ',          '#ffffff','#000000', '/images/WAVE 125 2025/WAVE1252025alloySpecial/ThaiHondaWave1252025SmartKeyW-B.png','ล้อแม็ก (รีโมท)'),
  -- Super Cub (model 3)
  (3,'เขียว',           '#515f50','',        '/images/SUPERCUB 2025/ThaiHondaSupercub2025GRN.png',                    'ล้อลวด'),
  (3,'เทา-ขาว',         '#6a7c88','#ffffff', '/images/SUPERCUB 2025/ThaiHondaSupercub2025GW.png',                     'ล้อลวด'),
  (3,'ฟ้า-ขาว',         '#b9c6d6','#ffffff', '/images/SUPERCUB 2025/ThaiHondaSupercub2025SBW.png',                    'ล้อลวด'),
  (3,'เหลือง-ขาว',      '#f8a12e','#ffffff', '/images/SUPERCUB 2025/ThaiHondaSupercub2025YW.png',                     'ล้อลวด'),
  -- Scoopy (model 4)
  (4,'ดำ',              '#000000','',        '/images/SCOOPY 2026/SCOOPY URBAN/ColorsectionSCOOPYB.png',              'URBAN (ล้อลวด)'),
  (4,'ขาว-ฟ้า',         '#96aec9','',        '/images/SCOOPY 2026/SCOOPY URBAN/ColorsectionSCOOPYBL.png',             'URBAN (ล้อลวด)'),
  (4,'ดำ',              '#000000','',        '/images/SCOOPY 2026/SCOOPY PRESTIGE/ColorsectionSCOOPY5v.png',          'PRESTIGE (ล้อแม็ก)'),
  (4,'เขียว',           '#62705a','',        '/images/SCOOPY 2026/SCOOPY PRESTIGE/ColorsectionSCOOPY6v.png',          'PRESTIGE (ล้อแม็ก)'),
  (4,'ขาว',             '#ffffff','',        '/images/SCOOPY 2026/SCOOPY PRESTIGE/ColorsectionSCOOPY7v.png',          'PRESTIGE (ล้อแม็ก)'),
  (4,'ชมพู',            '#f67c6f','',        '/images/SCOOPY 2026/SCOOPY CLUB12/ColorsectionSCOOPY1v.png',           'CLUB12 (ล้อแม็ก รีโมท)'),
  (4,'เทา-ขาว',         '#ffffff','#a4a4a2', '/images/SCOOPY 2026/SCOOPY CLUB12/ColorsectionSCOOPY2v.png',           'CLUB12 (ล้อแม็ก รีโมท)'),
  (4,'ดำ-แดง',          '#000000','#650000', '/images/SCOOPY 2026/SCOOPY CLUB12/ColorsectionSCOOPY3v.png',           'CLUB12 (ล้อแม็ก รีโมท)'),
  (4,'ขาว-น้ำเงิน',     '#cc0000','',        '/images/SCOOPY 2026/SCOOPY CLUB12/ColorsectionSCOOPY4v.png',           'CLUB12 (ล้อแม็ก รีโมท)'),
  (4,'ขาว-ฟ้า Cinnamoroll','#ccced0','#8eafd6','/images/SCOOPY 2026/SCOOPY CLUB12/ColorSectior01.png',               'CLUB12 Cinnamoroll Limited Edition'),
  -- Giorno+ (model 5)
  (5,'เทา-ดำ',          '#b5b7ba','#000000', '/images/GIORNO 2026/GIORNO CBS/G-B.png',                               'CBS'),
  (5,'เขียว-ดำ',        '#707e6d','#000000', '/images/GIORNO 2026/GIORNO CBS/GNB.png',                               'CBS'),
  (5,'ฟ้า-ดำ',          '#c6d9ec','#000000', '/images/GIORNO 2026/GIORNO CBS/SBB.png',                               'CBS'),
  (5,'ดำ-น้ำตาล',       '#000000','#685447', '/images/GIORNO 2026/GIORNO ABS/BBR.png',                               'ABS'),
  (5,'เทา-น้ำตาล',      '#a29d96','#685447', '/images/GIORNO 2026/GIORNO ABS/GBR.png',                               'ABS'),
  (5,'ขาว-น้ำตาล',      '#dbdbdb','#685447', '/images/GIORNO 2026/GIORNO ABS/WBR.png',                               'ABS'),
  (5,'เหลือง-น้ำตาล',   '#f7be2e','#685447', '/images/GIORNO 2026/GIORNO ABS/YBR.png',                               'ABS'),
  -- Lead125 (model 6)
  (6,'ดำ',              '#1d2224','',        '/images/LEAD 2026/LEAD CBS/Colorsection01.png',                        'CBS'),
  (6,'ขาว',             '#ffffff','',        '/images/LEAD 2026/LEAD CBS/Colorsection02.png',                        'CBS'),
  (6,'ดำ',              '#252a2d','',        '/images/LEAD 2026/LEAD ABS/Colorsection03.png',                        'ABS'),
  (6,'เทา',             '#4d5a64','',        '/images/LEAD 2026/LEAD ABS/Colorsection4.png',                         'ABS'),
  -- Click125 (model 7)
  (7,'ดำ-แดง',          '#000000','#7b333d', '/images/CLICK 125 2022/CLICK125alloy/Click125B-R.png',                 'ล้อแม็ก'),
  (7,'เทา-แดง',         '#848e9b','#813d44', '/images/CLICK 125 2022/CLICK125alloy/Click125G-R.png',                 'ล้อแม็ก'),
  (7,'แดง-ดำ',          '#cb2037','#000000', '/images/CLICK 125 2022/CLICK125alloy/Click125R-B.png',                 'ล้อแม็ก'),
  -- Click160 (model 8)
  (8,'แดง-ดำ',          '#ba001e','#000000', '/images/CLICK 160 2024/CLICK160/CLICK16020241.png',                    'STANDARD'),
  (8,'เทา-ดำ',          '#babdbd','#000000', '/images/CLICK 160 2024/CLICK160/CLICK16020242.png',                    'STANDARD'),
  (8,'ดำ',              '#000000','',        '/images/CLICK 160 2024/CLICK160/CLICK16020243.png',                    'STANDARD'),
  (8,'ดำ-น้ำตาล',       '#000000','#d6b76c', '/images/CLICK 160 2024/CLICK160 SPECIAL/CLICK16020244.png',            'SPECIAL'),
  -- ADV160 (model 9)
  (9,'น้ำเงิน',         '#1c2e6c','',        '/images/ADV 160 2026/ADV160Blue.png',                                  'STANDARD'),
  (9,'น้ำตาล',          '#bcb195','',        '/images/ADV 160 2026/ADV160Brown.png',                                 'STANDARD'),
  (9,'เขียว',           '#435231','',        '/images/ADV 160 2026/ADV160Green.png',                                 'STANDARD'),
  (9,'ดำ',              '#000000','',        '/images/ADV 160 2026/ADV160Black.png',                                 'SPECIAL'),
  -- PCX160 (model 10)
  (10,'ส้ม',            '#e77e00','',        '/images/PCX 2025/PCX160STANDARD/ColorChartAmberBlaze.png',             'STANDARD'),
  (10,'ดำ',             '#000000','',        '/images/PCX 2025/PCX160STANDARD/ColorChartBLACK.png',                  'STANDARD'),
  (10,'น้ำเงิน',        '#0068b5','',        '/images/PCX 2025/PCX160STANDARD/ColorChartBLUE.png',                   'STANDARD'),
  (10,'เทา',            '#b2b2b2','',        '/images/PCX 2025/PCX160STANDARD/ColorChartSMOKYGRAY.png',              'STANDARD'),
  (10,'น้ำเงิน',        '#4a5164','',        '/images/PCX 2025/PCX160ROADSYNZ/ColorChartBLUE.png',                   'ROADSYNC'),
  (10,'แดง',            '#841222','',        '/images/PCX 2025/PCX160ROADSYNZ/ColorChartRED.png',                    'ROADSYNC'),
  (10,'ขาว',            '#ffffff','',        '/images/PCX 2025/PCX160ROADSYNZ/ColorChartWhiteBlaze.png',             'ROADSYNC'),
  -- Forza350 (model 11)
  (11,'เทา-ดำ',         '#4a4a4c','#000000', '/images/FORZA 350 2026/01STORMYGREY.png',                              'ROADSYNC'),
  (11,'ดำ',             '#000000','',        '/images/FORZA 350 2026/02ECLIPSEBLACK.png',                            'ROADSYNC'),
  (11,'แดง-ดำ',         '#c52d3a','#000000', '/images/FORZA 350 2026/03SOLARRED.png',                                'ROADSYNC'),
  (11,'ดำ-แดง',         '#000000','#920011', '/images/FORZA 350 2026/Color.png',                                     'ROADSYNC'),
  -- ADV350 (model 12)
  (12,'ดำ',             '#000000','',        '/images/ADV 350 2025/ColorChartADV350BLACK.png',                       'ROADSYNC'),
  (12,'แดง',            '#c0000f','',        '/images/ADV 350 2025/ColorChartADV350CANYONRED.png',                   'ROADSYNC'),
  (12,'น้ำเงิน',        '#39559b','',        '/images/ADV 350 2025/ColorChartADV350OCEANBLUE.png',                   'ROADSYNC'),
  -- GROM (model 13)
  (13,'ดำ-เทา',         '#000000','#5b5f69', '/images/GROM 2024/05ThHondaGrom2023Black.png',                         'ABS'),
  (13,'น้ำเงิน-ดำ',     '#0077c9','#000000', '/images/GROM 2024/05ThHondaGrom2023Blue.png',                          'ABS'),
  (13,'แดง-ดำ',         '#ec001f','#000000', '/images/GROM 2024/05ThHondaGrom2023Red.png',                           'ABS'),
  -- CBR150R (model 14)
  (14,'ดำ',             '#000000','',        '/images/CBR 150 2025/NewCBR150RColorChartBlackLowres.jpg',             'มาตรฐาน'),
  (14,'แดง',            '#f51422','',        '/images/CBR 150 2025/NewCBR150RColorChartRedLowres.jpg',              'มาตรฐาน'),
  -- CRF300L (model 15)
  (15,'แดง-ขาว',        '#fa1c2d','#ffffff', '/images/CRF300L 2024/ThaiHondaCRF300L20241.jpg',                       'มาตรฐาน'),
  (15,'เทา-ดำ',         '#979799','#000000', '/images/CRF300L 2024/ThaiHondaCRF300L20242.jpg',                       'มาตรฐาน'),
  -- CB150R (model 16)
  (16,'ดำ',             '#212121','',        '/images/CB150R 2024/ThaiHondaCB150R2023black.png',                     'มาตรฐาน'),
  (16,'ขาว',            '#ffffff','',        '/images/CB150R 2024/ThaiHondaCB150R2023white.png',                     'มาตรฐาน'),
  -- CB300R (model 17)
  (17,'ดำ',             '#212121','',        '/images/CB300R 2022/ThHondaWingCenterColorchartNEOSprotsCafeCB300R2022Black.png', 'มาตรฐาน'),
  (17,'แดง-ดำ',         '#bb2230','#000000', '/images/CB300R 2022/ThHondaWingCenterColorchartNEOSprotsCafeCB300R2022Red.png',   'มาตรฐาน'),
  (17,'เหลือง-ดำ',      '#f3c700','#000000', '/images/CB300R 2022/ThHondaWingCenterColorchartNEOSprotsCafeCB300R2022Yellow.png','มาตรฐาน'),
  -- CL300 (model 18)
  (18,'ดำ',             '#000000','',        '/images/CL300 2025/ThaiHondaCL300Eclutch.png',                         'E-CLUTCH'),
  -- Rebel300 (model 19)
  (19,'ดำ',             '#000000','',        '/images/REBEL300 2025/ThaiHondaREBEL3002023.png',                      'E-CLUTCH'),
  -- UC3 (model 20)
  (20,'ขาว',            '#ffffff','',        '/images/UC3 2026/K4HA1288S08.png',                                     'มาตรฐาน'),
  (20,'ดำ',             '#212121','',        '/images/UC3 2026/K4HA1288S08Black.png',                                'มาตรฐาน');

-- ==================== VERIFY ====================

SELECT c.name AS category, m.name AS model, v.name AS variant, v.price
FROM bike_categories c
JOIN bike_models m ON m.category_id = c.id
JOIN bike_variants v ON v.model_id = m.id
ORDER BY c.sort_order, m.sort_order, v.sort_order;

SELECT COUNT(*) AS total_variants FROM bike_variants;
SELECT COUNT(*) AS total_downs     FROM bike_downs;
SELECT COUNT(*) AS total_installments FROM bike_installments;
SELECT COUNT(*) AS total_colors    FROM bike_colors;
