SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ASSETRANGE','NULL') AND NVL(CDTYPE,'NULL') = NVL('CF','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'ASSETRANGE', '000', 'Khác', 0, 'Y', 'Other');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'ASSETRANGE', '001', '< 1 tỷ', 1, 'Y', '< 1 billion');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'ASSETRANGE', '002', 'Từ 1 - 3 tỷ', 2, 'Y', '1-3 billion');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'ASSETRANGE', '003', 'Từ 3 - 5 tỷ', 3, 'Y', '3-5 billion');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'ASSETRANGE', '004', '> 5 tỷ', 4, 'Y', '> 5 billion');COMMIT;