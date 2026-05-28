# porpaor-motorservice

## Dev Notes

### กฎสำคัญ — ห้ามเดา
ถ้าต้องการข้อมูลใด เช่น โครงสร้าง Excel, ค่าในฐานข้อมูล, รหัสรุ่น → **ขอไฟล์หรือข้อมูลจริงมาวิเคราะห์เสมอ อย่าเดา**

---

### โครงสร้าง Excel ราคา (ไฟล์รถเล็ก)
ตรวจสอบจากไฟล์ `ราคาขายใหม่ล่าสุด.xlsx` (28/05/2569)

| Column | Index | หัวตาราง | ใช้งาน |
|--------|-------|-----------|--------|
| A | 0 | (รหัสรุ่น) | `model_code` เช่น `ACF125CBT` |
| B | 1 | (variant) | `variant_code` เช่น `TH` |
| C | 2 | ราคาทุน | ❌ ไม่ใช้ |
| D | 3 | ราคาแนะนำ | ❌ ไม่ใช้ |
| E | 4 | สด-แนะนำ (ส่วนลดจาก MSRP) | ❌ ไม่ใช้ |
| **F** | **5** | **ราคาเงินสด ป.เปา** | ✅ `price` |
| G | 6 | ราคาเงินสด (ทั่วไป) | ❌ ไม่ใช้ |
| H | 7 | สช > ป.เปา | ❌ ไม่ใช้ |
| I | 8 | ป.เปา > ทุน | ❌ ไม่ใช้ |
| J | 9 | (ว่าง) | - |
| **K** | **10** | **ราคาขายไฟแนนซ์ ป.เปา** | ✅ `finance_price` |
| L | 11 | ราคาไฟแนนซ์-แนะนำ | ❌ ไม่ใช้ |
| M | 12 | ราคาขายไฟแนนซ์ (ทั่วไป) | ❌ ไม่ใช้ |
| ... | ... | ... | ... |

**ตัวอย่าง ACF125CBT / TH (Honda Giorno+ CBS):**
- ราคาเงินสด ป.เปา (Col F): **71,600 บาท**
- ราคาขายไฟแนนซ์ ป.เปา (Col K): **75,600 บาท**

---

### ข้อควรระวัง — Push to GitHub
**ต้องถามก่อนทุกครั้งก่อน push** — ห้าม push โดยไม่ได้รับอนุญาต

---

### n8n Webhooks
| Endpoint | วัตถุประสงค์ |
|----------|-------------|
| `GET /bike-catalog` | ดึง catalog ทั้งหมด (admin) |
| `GET /bike-catalog-display` | ดึง catalog + ราคา (index.html) |
| `POST /save-bike-catalog` | บันทึก catalog (DELETE+INSERT) |
| `POST /update-catalog-rates` | อัปเดตอัตราดอกเบี้ย+ดาวน์ (exact submodel_name match) |
| `GET /bike-models-list` | รายชื่อรุ่นจาก bike_models table |
| `POST /save-price-list` | บันทึกราคาจาก Excel |

---

### DB Tables
- `bike_catalog` — แคตตาล็อกรุ่นรถ (badge, colors JSON, auto_rate, auto_down_pcts)
- `price_list` — ราคาขาย (model_code, variant_code, price, finance_price)
- `bike_models` — รายชื่อรุ่นอ้างอิง
