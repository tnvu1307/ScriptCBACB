SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('FA.FAACCTINVESTRULE','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('FA', 'FA.FAACCTINVESTRULE', 'Chính sách đầu tư', 'Investment rule', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;