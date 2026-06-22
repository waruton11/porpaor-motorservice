# กฎการทำงาน — ป.เปา มอเตอร์เซอร์วิส (Honda) + สิงห์ชัยสยามยนต์ (Yamaha)

> ไฟล์นี้คือ "ข้อตกลงการทำงาน" ที่ต้องทำตามทุก session อ่านให้จบก่อนเริ่มงานเสมอ
> กฎเหล่านี้ override พฤติกรรมปกติ — ต้องทำตามเป๊ะ เพราะนี่คือธุรกิจจริงที่มีลูกค้าจริง ผิดพลาดกระทบคนจริง

---

## ⚠️ กฎเหล็ก 4 ข้อ

1. **ถามก่อน `git push` / `git commit` ทุกครั้ง** — ห้าม push/commit เองเด็ดขาด
   ก่อน push ให้ถาม: *"แก้เสร็จแล้ว — พร้อม push ขึ้น GitHub ไหมครับ?"* แล้วรอเจ้าของยืนยัน
   (เพราะ push = production: Render auto-deploy หน้าเว็บใน ~2 นาที)

2. **LOCAL-FIRST** — แก้ + ทดสอบใน local ให้สมบูรณ์ก่อน ค่อย push
   - หน้าเว็บ (`index.html`/`admin.html`): แก้ → เปิด preview server เทสกับไฟล์จริง → push เมื่อเทสผ่าน + เจ้าของอนุญาต
   - ข้อควรระวัง: **ไม่มี local n8n / local DB** (อยู่บน cloud หมด) → preview frontend ยิงเข้า n8n/DB จริง การ re-import workflow ก็เกิดบน instance จริง
   - n8n: ตรวจ JSON + logic ใน local, เปลี่ยนแบบ non-destructive/guarded, แล้ว curl เทส endpoint จริงทันทีหลังเจ้าของ re-import

3. **ไม่เดา** — ไม่ชัวร์ให้ขอไฟล์/ข้อมูลจริงก่อน อย่าเดาแล้วทำเลย

4. **Secrets อยู่ใน `IMPORT-*.json` ที่ gitignore เท่านั้น** — ไฟล์ที่ commit ใช้ placeholder เช่น `SALES_TOKEN_HERE` (repo เป็น private)

---

## วิธีแก้ n8n (สำคัญ)

- ส่งไฟล์ `IMPORT-xxx.json` ที่ import ได้เลย แล้วให้เจ้าของ: ลบ workflow เก่า → Add blank workflow → Import → ตั้ง Postgres credential → Active
  (อย่าให้เจ้าของแก้โค้ด node เอง — "re-import ง่ายสุด")
- **import ลง workflow เปล่าจริงๆ เท่านั้น** — import ทับอันที่มี node อยู่จะ merge/ซ้ำ (เห็น suffix "1")
  ยกเว้นไฟล์ที่ตั้งใจมี node ซ้ำหน้าที่ (เช่นหลาย "LINE Push") — แบบนั้น suffix "2"/"3" ถือว่าปกติ
- **n8n NODE typeVersion: prod เก่ากว่า local!** (prod < 1.121) — typeVersion ใหม่ผ่านบน local แต่พังบน prod ("?" node + HTTP 500)
  ใช้เวอร์ชันที่ workflow เดิมบน prod ใช้อยู่: webhook 2, code 2, postgres 2.5 (2.6 ก็ได้), if 2, **respondToWebhook 1.1**
- **workflow ที่ SQL เขียนลงตารางจะ FAIL เงียบ (200 ว่าง ไม่ save ไม่ Respond) บน prod ถ้าตารางนั้นยังไม่มี**
  → ก่อน deploy workflow ที่อ้างตารางใหม่ ต้องรัน `db-migration-*.sql` บน prod ก่อน และ**เทส path ที่ authorized บน prod** (ไม่ใช่แค่ 401) — local จับ bug นี้ไม่ได้

---

## ความปลอดภัยข้อมูล (เคยพังมาแล้ว — อย่าให้ซ้ำ)

- **ห้ามรันฟังก์ชัน admin ที่มี side-effect เขียน DB ระหว่าง preview/test**
  `saveModel`/`saveData` เรียก `saveCategoriesToDB`/`syncRatesToDB`/`_syncToN8n` ซึ่ง POST ลง DB จริง
  → เคยทำ preview `saveModel()` ดัน localStorage เก่าทับ `brand_categories` honda จริง = ข้อมูลหาย
  ถ้าจะเทส JS ของ admin ให้ stub fetch/save หรืออ่านอย่างเดียว อย่าเรียก save จริง
- **ห้าม restore ข้อมูลจริงจาก `data.categories` default ใน admin.html** — มันคือ seed demo เก่า (15 รุ่นปลอม) ไม่ใช่ catalog จริง ใช้ restore ยิ่งพัง
- **แหล่งข้อมูล Honda จริง = ตาราง `bike_catalog`** (ผ่าน `bike-catalog-display?brand=honda`, ~45 แถว/19 รุ่นจริง, ไม่เคยเสีย)
  สร้าง `brand_categories` ใหม่จากมันได้: group `bike_type`→category, `submodel_name` split " / " →model+variant, ดึง price/auto_rate/auto_down_pcts/freebies/colors/badge มาด้วย

---

## โครงสร้างโปรเจกต์ & Stack

- `index.html` — หน้าเว็บลูกค้า (พารามิเตอร์ด้วย brand: `?brand=yamaha` → โหมด Yamaha; default = Honda)
- `admin.html` — Admin Panel (auth ด้วย session token + bcrypt + Sign in with Google)
- `singchai.html` — URL ชื่อร้าน Yamaha → redirect ไป `/?brand=yamaha`
- `n8n/` — workflow (ไฟล์ที่ commit ใช้ placeholder; `_build_*.js` gitignore)
- Frontend: Static HTML/CSS/JS (ไม่มี framework) — Deploy GitHub → Render auto-deploy
- Backend: n8n (https://n8n-wt11.onrender.com) · DB: PostgreSQL บน Render (Singapore)

## Workflow ที่ถูกต้อง

1. แก้โค้ด
2. ทดสอบใน Local (preview server / live endpoint)
3. **ถามเจ้าของก่อน** → ได้รับอนุญาตแล้วค่อย commit + push
4. Render deploy อัตโนมัติใน ~2 นาที

---

## บันทึกเพิ่มเติม (รายละเอียดงานที่ทำค้าง)

ดู memory files ประกอบ: `porpaor-two-shop-plan` (สถาปัตยกรรม 2 ร้าน + progress Yamaha),
`porpaor-honda-system-map` (stack/ตาราง DB จริง), `porpaor-auth-hardening` (security Tier),
`porpaor-local-stack` (Docker test), `porpaor-working-rules` (กฎฉบับเต็ม)
