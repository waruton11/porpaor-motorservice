# กฎการทำงาน — ป.เปา มอเตอร์เซอร์วิส

## ⚠️ กฎสำคัญ: Git Push / Commit

**ห้าม push หรือ commit โดยไม่ถามเจ้าของโปรเจกต์ก่อนทุกครั้ง**

ก่อน `git commit` หรือ `git push` ต้องถามว่า:
> "แก้โค้ดเสร็จแล้ว — พร้อม push ขึ้น GitHub ไหมครับ?"

รอให้เจ้าของยืนยันก่อนเสมอ เพื่อให้สามารถทดสอบใน Local ก่อนที่จะขึ้น production

---

## โครงสร้างโปรเจกต์

- `index.html` — หน้าเว็บลูกค้า
- `admin.html` — Admin Panel (รหัสผ่านเก็บใน code)
- `CLAUDE.md` — ไฟล์นี้ (กฎการทำงาน)

## Stack

- Frontend: Static HTML/CSS/JS (ไม่มี framework)
- Backend: n8n (https://n8n-wt11.onrender.com)
- Database: PostgreSQL บน Render (Singapore)
- Deploy: GitHub → Render (auto-deploy เมื่อ push main)

## Workflow ที่ถูกต้อง

1. แก้โค้ด
2. ทดสอบใน Local ด้วย Live Server
3. **ถามเจ้าของก่อน** → ได้รับอนุญาตแล้วค่อย commit + push
4. Render deploy อัตโนมัติใน ~2 นาที
