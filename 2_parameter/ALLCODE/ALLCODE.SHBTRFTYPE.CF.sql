SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('SHBTRFTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('CF','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'SHBTRFTYPE', '001', 'Chuyển từ SHV', 0, 'Y', 'From Shinhan');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'SHBTRFTYPE', '002', 'Chuyển tới SHV', 1, 'Y', 'To Shinhan');COMMIT;