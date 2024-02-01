SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CL.CLMAST','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('SECUREDRATIO', 'CL.CLMAST', 0, 'V', '>>', '@0', NULL, 'Ty le dam bao phai lon hon 0!', 'Secured ratio cannot less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('SECUREDRATIO', 'CL.CLMAST', 0, 'V', '<=', '@100', NULL, 'Ty le dam bao phai nho hon hoac bang 100!', 'Secured ratio cannot be greater than 100!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('SECUREDRATIO', 'CL.CLMAST', 1, 'V', '>=', 'SECUREDRATIOTYPE|--|DELTA', NULL, 'Ty le dam bao phai nam trong bien do cho phep!', 'Secured ratio cannot be less than secured ratio of type minus delta!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('SECUREDRATIO', 'CL.CLMAST', 2, 'V', '<=', 'SECUREDRATIOTYPE|++|DELTA', NULL, 'Ty le dam bao phai nam trong bien do cho phep!', 'Secured ratio cannot be less than secured ratio of type minus delta!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('SECUREDAMT', 'CL.CLMAST', 3, 'V', '>=', '@0', NULL, 'Gia tri da the chap phai lon hon 0!', 'Secured amount cannot less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('BOOKVALUE', 'CL.CLMAST', 4, 'V', '>=', '@0', NULL, 'Gia tri hach toan phai lon hon 0!', 'Booking amount must be greater than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('CLVALUE', 'CL.CLMAST', 5, 'V', '>>', '@0', NULL, 'Thi gia cua tai san phai lon hon 0!', 'Market value cannot less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('CLAMT', 'CL.CLMAST', 6, 'V', '>>', '@0', NULL, 'Gia tri dung de dam bao phai lon hon 0!', 'Secured value must be greater than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('CLAMT', 'CL.CLMAST', 7, 'E', 'EX', 'CLVALUE|**|SECUREDRATIO|//|@100', NULL, NULL, NULL, NULL, NULL, 0);COMMIT;