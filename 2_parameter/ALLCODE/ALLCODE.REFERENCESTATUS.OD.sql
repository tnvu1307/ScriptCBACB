SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('REFERENCESTATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('OD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'REFERENCESTATUS', '001', 'Thường', 0, 'Y', 'Normal');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'REFERENCESTATUS', '002', 'Cổ tức', 1, 'Y', 'Dividend');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'REFERENCESTATUS', '003', 'Thực hiện quyền', 2, 'Y', 'Corporate action');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'REFERENCESTATUS', '004', 'Loại cổ tức', 3, 'Y', 'Type of dividend');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'REFERENCESTATUS', '005', 'Chia', 4, 'Y', 'Divide');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'REFERENCESTATUS', '006', 'Gộp', 5, 'Y', 'Group');COMMIT;