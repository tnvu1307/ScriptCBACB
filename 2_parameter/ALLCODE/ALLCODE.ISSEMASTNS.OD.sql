SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ISSEMASTNS','NULL') AND NVL(CDTYPE,'NULL') = NVL('OD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ISSEMASTNS', 'P', 'Chưa cắt CK bán', 6, '1', 'Not cut CK sold');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ISSEMASTNS', '7', 'Đã cắt CK bán', 6, '0', 'Cut CK sell');COMMIT;