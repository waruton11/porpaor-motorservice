-- เพิ่มคอลัมน์ไอคอนการ์ดบริการ (เทิร์นรถเก่า / ทดลองขับขี่ฟรี) แก้ได้จาก admin
ALTER TABLE site_config ADD COLUMN IF NOT EXISTS svc_tradein_icon TEXT DEFAULT '';
ALTER TABLE site_config ADD COLUMN IF NOT EXISTS svc_testride_icon TEXT DEFAULT '';
