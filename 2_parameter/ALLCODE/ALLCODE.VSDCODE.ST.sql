SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('VSDCODE','NULL') AND NVL(CDTYPE,'NULL') = NVL('ST','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDCODE', 'VSDSVN01', 'Trung tâm Lưu ký Chứng khoán Việt Nam', 0, 'Y', 'Vietnam Securities Depository Center');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDCODE', 'VSDSVN02', 'Chi nhánh Trung tâm Lưu ký Chứng khoán Việt Nam', 1, 'Y', 'Vietnam Securities Depository Center Branch');COMMIT;