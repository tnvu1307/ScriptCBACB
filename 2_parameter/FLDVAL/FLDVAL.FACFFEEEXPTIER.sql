SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('FA.CFFEEEXPTIER','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FRVAL', 'FA.CFFEEEXPTIER', 0, 'V', '<=', 'TOVAL', '', 'Khoảng giá trị không hợp lệ!', 'Range of value is invalid!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FEEVAL', 'FA.CFFEEEXPTIER', 1, 'V', '>=', '@0', '', 'Tỷ lệ phí không nhỏ hơn 0!', 'The fee value can not less than 0!', '', '', 0);COMMIT;