SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('GR.GRMAST','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('BALANCE', 'GR.GRMAST', 0, 'V', '>=', '@0', '', 'Gia tri hop dong phai lon hon 0!', 'Contract value cannot less than 0!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('GRRATIO', 'GR.GRMAST', 1, 'V', '>=', '@0', '', 'Ty le ky quy phai lon hon 0!', 'Underwrite ratio cannot less than 0!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('GRRATIO', 'GR.GRMAST', 2, 'V', '<=', '@1', '', 'Ty le ky quy phai nho hon 1!', 'Underwrite ratio cannot greater than 1!', '', '', 0);COMMIT;