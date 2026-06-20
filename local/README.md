# ชุดทดสอบ Local (n8n + Postgres)

ทดสอบ workflow / migration / DB ในเครื่องก่อน แล้วค่อยขึ้น production (Render)
แยกขาดจากของจริง 100% — DB คนละก้อน, n8n คนละตัว

## 0) ติดตั้ง Docker Desktop (ครั้งเดียว)
1. โหลด: https://www.docker.com/products/docker-desktop/  → Windows (AMD64)
2. ติดตั้ง → ตอนถามให้ติ๊ก **"Use WSL 2"** → ติดตั้งเสร็จ **restart เครื่อง**
3. เปิด Docker Desktop รอจนมุมล่างซ้ายเป็นสีเขียว (Engine running)
4. เช็ก: เปิด PowerShell → `docker --version` ต้องขึ้นเวอร์ชัน

## 1) สตาร์ทชุดทดสอบ
```
cd C:\Users\Admin\Documents\GitHub\porpaor-motorservice\local
docker compose up -d
```
ครั้งแรกจะโหลด image สักพัก แล้วได้:
- **Postgres** ที่ `localhost:5432`  (user/pass/db = `porpaor` / `porpaor` / `porpaor`) — schema + seed รันอัตโนมัติ
- **n8n** ที่ http://localhost:5678

## 2) ตั้งค่า n8n (ครั้งแรก)
1. เปิด http://localhost:5678 → สร้างบัญชีเจ้าของ n8n (อีเมล/รหัสอะไรก็ได้ — แค่ใช้ในเครื่อง)
2. สร้าง Postgres credential: **Credentials → New → Postgres**
   - Name: **Postgres account**  ← ต้องชื่อนี้เป๊ะ (workflow อ้างชื่อนี้)
   - Host: `db`   Port: `5432`   Database: `porpaor`   User: `porpaor`   Password: `porpaor`   SSL: `disable`
   - Save (กด Test ได้)
3. Import workflow ที่จะทดสอบ (เช่น `../n8n/n8n-users-login.json`) → ผูก Postgres cred → Active

## 3) ทดสอบ
- ยิง endpoint ที่ `http://localhost:5678/webhook/<path>` (เหมือน production แต่ในเครื่อง)
- รัน migration ใหม่ทดสอบได้ที่ DB local ก่อน (psql / pgAdmin ต่อ `localhost:5432`)

## คำสั่งที่ใช้บ่อย
| ทำอะไร | คำสั่ง (ในโฟลเดอร์ local) |
|---|---|
| สตาร์ท | `docker compose up -d` |
| ดู log | `docker compose logs -f` |
| ปิด (เก็บข้อมูล) | `docker compose down` |
| ล้างเริ่มใหม่ (schema/seed รันใหม่) | `docker compose down -v` แล้ว `up -d` |
| ต่อ DB ด้วย psql | `docker exec -it porpaor-db psql -U porpaor` |

## หมายเหตุ
- `01-schema.sql` / `02-seed.sql` รัน **เฉพาะตอนสร้าง DB ครั้งแรก** — แก้แล้วต้อง `down -v` เพื่อให้รันใหม่
- `bike_catalog` เป็น schema สร้างใหม่ (best-effort) เพราะ prod ไม่มีไฟล์ base — ถ้าจะทดสอบ catalog ละเอียด ค่อย dump schema จริงจาก prod มาทับ
- บัญชีทดสอบ: `admin / papao2569` (owner), `salesA / sales123` (sales), Gmail `waruton11@gmail.com`
