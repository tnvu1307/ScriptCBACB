SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SE.SEMAST','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('COSTPRICE', 'SE.SEMAST', 0, 'V', '>=', '@0', NULL, 'Thang giá phải lớn hơn  0!', 'Ticksize must be greater than zero!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('STANDING', 'SE.SEMAST', 7, 'E', 'EX', 'STANDING|**|@-1', NULL, NULL, NULL, NULL, NULL, 0);COMMIT;