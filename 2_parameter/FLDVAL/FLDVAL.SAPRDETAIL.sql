SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.PRDETAIL','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('INUSED', 'SA.PRDETAIL', 0, 'V', '>=', '@0', '', 'Giá trị nguồn đã dùng phải lớn hơn hoặc bằng 0!', 'INUSED >= 0 !', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('PRLIMIT', 'SA.PRDETAIL', 0, 'V', '>=', 'INUSED', '', 'Tổng tối đa của nguồn phải lớn hơn giá trị nguồn đã dùng !', 'PRLIMIT >= INUSED !', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('PRLIMIT', 'SA.PRDETAIL', 0, 'V', '>=', '@0', '', 'Tổng tối đa của nguồn phải lớn hơn hoặc bằng 0 !', 'PRLIMIT >=0 !', '', '', 0);COMMIT;