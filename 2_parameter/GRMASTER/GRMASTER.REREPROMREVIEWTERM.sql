SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('RE.REPROMREVIEWTERM','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('RE', 'RE.REPROMREVIEWTERM', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'Common', 'N', '', 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('RE', 'RE.REPROMREVIEWTERM', 1, 'REPROMREVIEWTERMTIERS', 'G', 'EEEENNNN', 'Tham sô bậc thang', 'Promotion schema parameters ', 'N', 'REPROMRVWTERMTIERS', 'N');COMMIT;