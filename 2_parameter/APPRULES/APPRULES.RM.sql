SET DEFINE OFF;DELETE FROM APPRULES WHERE 1 = 1 AND NVL(APPTYPE,'NULL') = NVL('RM','NULL');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('RM', '01', 'CRBDEFBANK', 'STATUS', 'IN', -660001, 'Bank status invalid', 'CRBDEFBANK', NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('RM', '02', 'CRBTRFLOG', 'STATUS', 'IN', -100432, 'Trạng thái bảng kê không hợp lệ', 'CRBDEFBANK', NULL);Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('RM', '03', 'CRBTRFLOG', 'ERRSTS', 'IN', -100432, 'Trạng thái bảng kê không hợp lệ', 'CRBDEFBANK', NULL);COMMIT;