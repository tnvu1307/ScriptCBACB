SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.BONDIPO','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CF', 'CF.BONDIPO', 'Đấu thầu trái phiếu', 'Bond IPO', 'N', 'N', 'NNNNYYY', 'NET');COMMIT;