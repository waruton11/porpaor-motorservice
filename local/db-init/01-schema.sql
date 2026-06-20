-- ==========================================================
-- Local test schema — จำลอง production พอสำหรับทดสอบ auth / CRM / categories / catalog
-- รันอัตโนมัติตอน docker compose up ครั้งแรก (docker-entrypoint-initdb.d)
-- หมายเหตุ: bike_catalog ไม่มี base schema ในรีโป (prod มีแต่ ALTER) — ตารางนี้สร้างใหม่
--           จากคอลัมน์ที่สังเกตจาก bike-catalog-display (best-effort) เพื่อให้ทดสอบ catalog ได้
-- ==========================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ---------- users (รวม auth + brand + email) ----------
CREATE TABLE IF NOT EXISTS users (
  id            SERIAL PRIMARY KEY,
  username      TEXT UNIQUE NOT NULL,
  password      TEXT,
  password_hash TEXT,
  role          TEXT DEFAULT 'sales',
  name          TEXT,
  email         TEXT,
  active        BOOLEAN DEFAULT true,
  brand         VARCHAR(20) NOT NULL DEFAULT 'honda',
  created_at    TIMESTAMP DEFAULT NOW()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email ON users (lower(email)) WHERE email IS NOT NULL;

-- ---------- sessions (token หลัง login) ----------
CREATE TABLE IF NOT EXISTS sessions (
  token      TEXT PRIMARY KEY,
  username   TEXT NOT NULL,
  role       TEXT,
  name       TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_sessions_expires ON sessions(expires_at);

-- ---------- customers ----------
CREATE TABLE IF NOT EXISTS customers (
  id             SERIAL PRIMARY KEY,
  line_user_id   TEXT UNIQUE NOT NULL,
  display_name   TEXT,
  phone          TEXT,
  status         TEXT DEFAULT 'new',
  assignee       TEXT,
  interest_model TEXT,
  lead_count     INT DEFAULT 0,
  purchase_date  DATE,
  note           TEXT,
  first_seen     TIMESTAMP DEFAULT NOW(),
  last_seen      TIMESTAMP DEFAULT NOW(),
  updated_at     TIMESTAMP DEFAULT NOW(),
  brand          VARCHAR(20) NOT NULL DEFAULT 'honda'
);
CREATE INDEX IF NOT EXISTS idx_customers_status ON customers(status);

-- ---------- leads ----------
CREATE TABLE IF NOT EXISTS leads (
  id           SERIAL PRIMARY KEY,
  lead_type    TEXT NOT NULL,
  model        TEXT, variant TEXT, color TEXT, pay_type TEXT,
  down_pct     NUMERIC, installment INT, period INT, price INT,
  cust_name    TEXT, cust_phone TEXT, line_user_id TEXT,
  detail       JSONB DEFAULT '{}'::jsonb,
  created_at   TIMESTAMP DEFAULT NOW(),
  brand        VARCHAR(20) NOT NULL DEFAULT 'honda'
);
CREATE INDEX IF NOT EXISTS idx_leads_created ON leads(created_at DESC);

-- ---------- site_config ----------
CREATE TABLE IF NOT EXISTS site_config (
  id          INT PRIMARY KEY DEFAULT 1,
  hero_image  TEXT DEFAULT '',
  benefits    JSONB DEFAULT '[]'::jsonb,
  updated_at  TIMESTAMP DEFAULT NOW(),
  brand       VARCHAR(20) NOT NULL DEFAULT 'honda',
  CONSTRAINT single_row CHECK (id = 1)
);

-- ---------- brand_categories (+ backup) ----------
CREATE TABLE IF NOT EXISTS brand_categories (
  brand       VARCHAR(20) PRIMARY KEY,
  categories  JSONB NOT NULL DEFAULT '[]'::jsonb,
  updated_at  TIMESTAMP DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS brand_categories_backup (
  id           SERIAL PRIMARY KEY,
  brand        VARCHAR(20) NOT NULL,
  categories   JSONB NOT NULL,
  num_models   INT,
  backed_up_at TIMESTAMP DEFAULT NOW()
);

-- ---------- bike_catalog (reconstructed) + price_list ----------
CREATE TABLE IF NOT EXISTS bike_catalog (
  id                   SERIAL PRIMARY KEY,
  bike_type            TEXT,
  submodel_name        TEXT,
  model_name           TEXT,
  variant_name         TEXT,
  marketing_name       TEXT DEFAULT '',
  transmission         TEXT DEFAULT 'Automatic',
  note                 TEXT,
  badge                TEXT DEFAULT '',
  colors               TEXT DEFAULT '[]',
  freebies             JSONB DEFAULT '[]'::jsonb,
  engine_cc            INT,
  is_active            BOOLEAN DEFAULT true,
  sort_order           INT DEFAULT 0,
  auto_rate            NUMERIC DEFAULT 0,
  auto_rate_unit       TEXT DEFAULT 'month',
  auto_down_pcts       TEXT DEFAULT '',
  auto_rate2           NUMERIC DEFAULT 0,
  auto_rate2_min_down  INT DEFAULT 0,
  price                INT DEFAULT 0,
  finance_price        INT DEFAULT 0,
  brand                VARCHAR(20) NOT NULL DEFAULT 'honda'
);
CREATE INDEX IF NOT EXISTS idx_bike_catalog_brand ON bike_catalog(brand);

CREATE TABLE IF NOT EXISTS price_list (
  id            SERIAL PRIMARY KEY,
  model_code    VARCHAR(150) NOT NULL,
  variant_code  VARCHAR(100) NOT NULL DEFAULT '',
  price         INTEGER NOT NULL DEFAULT 0,
  finance_price INTEGER NOT NULL DEFAULT 0,
  file_type     VARCHAR(10),
  updated_at    TIMESTAMP DEFAULT NOW(),
  UNIQUE(model_code, variant_code)
);
