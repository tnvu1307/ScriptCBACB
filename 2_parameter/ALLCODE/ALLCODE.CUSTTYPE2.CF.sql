SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('CUSTTYPE2','NULL') AND NVL(CDTYPE,'NULL') = NVL('CF','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'CUSTTYPE2', '000', 'ALL', -1, 'Y', 'ALL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'CUSTTYPE2', '001', 'Cá nhân trong nước', 0, 'Y', 'Domestic individual');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'CUSTTYPE2', '002', 'Tổ chức trong nước', 1, 'Y', 'Domestic organization');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'CUSTTYPE2', '003', 'Cá nhân nước ngoài', 2, 'Y', 'Foreign individual');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'CUSTTYPE2', '004', 'Tổ chức nước ngoài', 3, 'Y', 'Foreign organization');COMMIT;