SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('PR.PRSECMAP','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('ROOMLIMIT', 'PR.PRSECMAP', 1, 'V', '>=', '@0', NULL, 'Hạn mức không được nhỏ hơn 0!', 'The room limit can not less than 0!', NULL, NULL, 0);COMMIT;