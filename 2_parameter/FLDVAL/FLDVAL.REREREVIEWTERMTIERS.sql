SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('RE.REREVIEWTERMTIERS','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FRVALUE', 'RE.REREVIEWTERMTIERS', 0, 'V', '<=', 'TOVALUE', '', 'Gia tri toi thieu phai nho hon gia tri toi da!', 'The minimum value must be less than maximum value!', '', '', 0);COMMIT;