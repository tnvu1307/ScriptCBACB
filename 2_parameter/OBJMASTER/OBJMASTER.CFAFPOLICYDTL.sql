SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.AFPOLICYDTL','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CF', 'CF.AFPOLICYDTL', 'Chi tiết chính sách đầu tư', 'Detail of investment policy for sub-account', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;