SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('SYNSTATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('SB','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'SYNSTATUS', 'A', 'Đã duyệt', 2, 'Y', 'Approved');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'SYNSTATUS', 'R', 'Từ chối', 3, 'Y', 'Rejected');COMMIT;