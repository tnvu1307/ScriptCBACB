SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2872','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('05', '2872', 1, 'V', '<=', '06', NULL, 'Từ ngày phải nhỏ hơn hay bằng đến ngày!', 'From date must be earlier or equal to to date!', NULL, NULL, 0);COMMIT;