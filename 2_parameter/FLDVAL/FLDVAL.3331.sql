SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('3331','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('04', '3331', 8, 'V', '<>', '02', '', 'Tiểu khoản nhận phải khác tiểu khoản chuyển', 'To sub account must be different from From Sub account', '', '', 0);COMMIT;