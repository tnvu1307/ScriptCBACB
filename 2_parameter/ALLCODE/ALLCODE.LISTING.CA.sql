SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('LISTING','NULL') AND NVL(CDTYPE,'NULL') = NVL('CA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CA', 'LISTING', '001', 'Niêm yết mới', 1, 'Y', 'Listing order new');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CA', 'LISTING', '002', 'Niêm yết bổ sung', 2, 'Y', 'Listing additional');COMMIT;