SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('VSDIDTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSDIDTYPE', '001', 'VISD/IDNO', 0, 'Y', 'VISD/IDNO');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSDIDTYPE', '002', 'VISD/CCPT', 1, 'Y', 'VISD/CCPT');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSDIDTYPE', '003', 'VISD/OTHR/VN', 2, 'Y', 'VISD/OTHR/VN');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSDIDTYPE', '004', 'VISD/OTHR/VN', 3, 'Y', 'VISD/OTHR/VN');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSDIDTYPE', '005', 'VISD/CORP', 4, 'Y', 'VISD/CORP');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSDIDTYPE', '006', 'VISD/OTHR/VN', 5, 'Y', 'VISD/OTHR/VN');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSDIDTYPE', '009', 'VISD/ARNU', 9, 'Y', 'VISD/ARNU');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSDIDTYPE', '010', 'VISD/OTHR', 10, 'Y', 'VISD/OTHR');COMMIT;