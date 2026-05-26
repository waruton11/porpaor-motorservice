-- ====================================================
-- ป.เปา มอเตอร์เซอร์วิส — แก้ encoding ชื่อแบบ bike_variants
-- รัน script นี้ใน pgAdmin Query Tool (ไม่ใช่ psql terminal)
-- ใช้ PostgreSQL U&'\XXXX' syntax (ASCII ล้วน — ไม่ขึ้นกับ encoding ของ client)
-- ====================================================

-- Honda Wave110i (model_id=1)
UPDATE bike_variants SET name = U&'\0E25\0E49\0E2D\0E0B\0E35\0E48\0E25\0E27\0E14 (\0E14\0E23\0E31\0E21\0E40\0E1A\0E23\0E01)'  WHERE id = 1;
UPDATE bike_variants SET name = U&'\0E25\0E49\0E2D\0E0B\0E35\0E48\0E25\0E27\0E14 (\0E14\0E34\0E2A\0E01\0E4C\0E40\0E1A\0E23\0E01)' WHERE id = 2;
UPDATE bike_variants SET name = U&'\0E25\0E49\0E2D\0E41\0E21\0E47\0E01'                                                           WHERE id = 3;
UPDATE bike_variants SET name = U&'\0E25\0E49\0E2D\0E41\0E21\0E47\0E01 (\0E2A\0E40\0E1B\0E40\0E0A\0E35\0E22\0E25)'               WHERE id = 4;

-- Honda Wave125i (model_id=2)
UPDATE bike_variants SET name = U&'\0E25\0E49\0E2D\0E25\0E27\0E14'                                                                WHERE id = 5;
UPDATE bike_variants SET name = U&'\0E25\0E49\0E2D\0E41\0E21\0E47\0E01'                                                           WHERE id = 6;
UPDATE bike_variants SET name = U&'\0E25\0E49\0E2D\0E41\0E21\0E47\0E01 (\0E23\0E35\0E42\0E21\0E17)'                               WHERE id = 7;

-- Honda Super Cub (model_id=3)
UPDATE bike_variants SET name = U&'\0E25\0E49\0E2D\0E25\0E27\0E14'                                                                WHERE id = 8;

-- Honda Scoopy (model_id=4)
UPDATE bike_variants SET name = U&'URBAN (\0E25\0E49\0E2D\0E25\0E27\0E14)'                                                        WHERE id = 9;
UPDATE bike_variants SET name = U&'PRESTIGE (\0E25\0E49\0E2D\0E41\0E21\0E47\0E01)'                                                WHERE id = 10;
UPDATE bike_variants SET name = U&'CLUB12 (\0E25\0E49\0E2D\0E41\0E21\0E47\0E01 \0E23\0E35\0E42\0E21\0E17)'                       WHERE id = 11;

-- Honda Click125 (model_id=7)
UPDATE bike_variants SET name = U&'\0E25\0E49\0E2D\0E41\0E21\0E47\0E01'                                                           WHERE id = 17;

-- Honda CBR150R (model_id=14)
UPDATE bike_variants SET name = U&'\0E21\0E32\0E15\0E23\0E10\0E32\0E19'                                                           WHERE id = 27;

-- Honda CRF300L (model_id=15)
UPDATE bike_variants SET name = U&'\0E21\0E32\0E15\0E23\0E10\0E32\0E19'                                                           WHERE id = 28;

-- Honda CB150R (model_id=16)
UPDATE bike_variants SET name = U&'\0E21\0E32\0E15\0E23\0E10\0E32\0E19'                                                           WHERE id = 29;

-- Honda CB300R (model_id=17)
UPDATE bike_variants SET name = U&'\0E21\0E32\0E15\0E23\0E10\0E32\0E19'                                                           WHERE id = 30;

-- Honda UC3 (model_id=20)
UPDATE bike_variants SET name = U&'\0E21\0E32\0E15\0E23\0E10\0E32\0E19'                                                           WHERE id = 33;

-- ตรวจสอบผลลัพธ์
SELECT id, model_id, name FROM bike_variants ORDER BY model_id, sort_order;
