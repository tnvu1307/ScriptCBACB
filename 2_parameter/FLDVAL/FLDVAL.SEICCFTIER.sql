SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SE.ICCFTIER','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TOAMT', 'SE.ICCFTIER', 0, 'V', '>>', 'FRAMT', NULL, 'Số dư sau phải lớn hơn số dư trước!', 'To AMT must be greater than from AMT!', NULL, NULL, 0);COMMIT;