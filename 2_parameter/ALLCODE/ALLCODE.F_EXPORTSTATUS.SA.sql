SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('F_EXPORTSTATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'F_EXPORTSTATUS', 'P', 'Chờ xác nhận', 0, 'Y', 'Pending to confirm');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'F_EXPORTSTATUS', 'C', 'Hoàn thành', 1, 'Y', 'Successfull');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'F_EXPORTSTATUS', 'E', 'Lỗi', 2, 'Y', 'Error');COMMIT;