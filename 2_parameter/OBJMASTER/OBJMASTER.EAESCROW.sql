SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('EA.ESCROW','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('EA', 'EA.ESCROW', 'Hợp đồng Escrow', 'Escrow contract', 'Y', 'N', 'NNNYYYY', 'NET');COMMIT;