SET DEFINE OFF;DELETE FROM APPRULES WHERE 1 = 1 AND NVL(APPTYPE,'NULL') = NVL('CL','NULL');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('CL', '01', 'CLMAST', 'STATUS', 'IN', -530001, '[-530001]: Trạng thái tài sản không hợp lệ !', NULL, NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('CL', '02', 'CLMAST', 'BOOKTYPE', 'IN', -530002, '[-530002]: Booktype không hợp lệ !', NULL, NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('CL', '03', 'CLMAST', 'SECUREDAMT', '>=', -530003, 'Not enought secured amount', NULL, NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('CL', '04', 'CLMAST', 'SECUREDAMT', '==', -530004, 'The secured amount must be zero', NULL, NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('CL', '05', 'CLMAST', 'CLAMT', '>=', -530005, 'Not enought the collaterall using amount', NULL, NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('CL', '06', 'CLMAST', 'BOOKVALUE', '>=', -530006, 'Not enought the collaterall book value', NULL, NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('CL', '07', 'CLMAST', 'CLVALUE', '>=', -530007, 'Not enought the collaterall value', NULL, NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('CL', '08', 'CLMAST', 'SECUREDAMT', '<=', -530008, 'Not enought secured amount', NULL, NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('CL', '09', 'CLMAST', 'CLAMT', '<=', -530010, 'Less than using amount', NULL, NULL);COMMIT;