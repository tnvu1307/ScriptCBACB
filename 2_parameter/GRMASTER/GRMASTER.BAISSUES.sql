SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('BA.ISSUES','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('BA', 'BA.ISSUES', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'General', 'N', '', 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('BA', 'BA.ISSUES', 1, 'BABONDISSUE', 'G', 'EEEENNNN', 'TT trái phiếu', 'Securities', 'N', 'BABONDISSUE', 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('BA', 'BA.ISSUES', 2, 'BACONTRACT', 'G', 'EEEENNNN', 'TT hợp đồng', 'Contract information', 'N', 'BACONTRACT', 'N');COMMIT;