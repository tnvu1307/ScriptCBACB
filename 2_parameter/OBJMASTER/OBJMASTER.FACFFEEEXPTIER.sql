SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('FA.CFFEEEXPTIER','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('FA', 'FA.CFFEEEXPTIER', 'Bậc thang biểu phí', 'Tier', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;