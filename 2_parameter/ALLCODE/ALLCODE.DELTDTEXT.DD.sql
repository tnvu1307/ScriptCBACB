SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DELTDTEXT','NULL') AND NVL(CDTYPE,'NULL') = NVL('DD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DD', 'DELTDTEXT', 'N', 'Chưa xóa', 0, 'Y', 'Not deleted');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DD', 'DELTDTEXT', 'Y', 'Đã xóa', 1, 'Y', 'Deleted');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DD', 'DELTDTEXT', 'I', 'Đã xóa (1444)', 2, 'Y', 'Deleted (1444)');COMMIT;