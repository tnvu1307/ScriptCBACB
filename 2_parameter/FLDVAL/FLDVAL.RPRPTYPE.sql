SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('RP.RPTYPE','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('SPOTDAY', 'RP.RPTYPE', 1, 'V', '>=', '@0', '', 'Số ngày Spot lớn hơn 0!', 'Spot term must be greater than  zero!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FORWARDAY', 'RP.RPTYPE', 2, 'V', '>=', '@0', '', 'Số ngày Forward lớn hơn', 'Forward term must be greater than zero!', '', '', 0);COMMIT;