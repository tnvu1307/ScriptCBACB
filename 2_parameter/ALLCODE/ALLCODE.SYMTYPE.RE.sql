SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('SYMTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('RE','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'SYMTYPE', '000', 'Tất cả', 0, 'Y', 'All');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'SYMTYPE', 'EQT', 'Cổ phiếu/Chứng chỉ quỹ', 1, 'Y', 'Stock and Bond');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'SYMTYPE', 'DEB', 'Trái phiếu', 2, 'Y', 'Bond');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'SYMTYPE', 'OTH', 'Loại khác', 3, 'Y', 'Others');COMMIT;