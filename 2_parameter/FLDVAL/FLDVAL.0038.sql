SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('0038','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('04', '0038', 2, 'V', '<>', '06', NULL, 'Trạng thái mới phải khác trạng thái cũ!', 'The New status must be different from the Old status!', NULL, NULL, 0);COMMIT;