SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.ATTACHMENTS','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.ATTACHMENTS', 'Quản lý báo cáo gửi kèm E-mail', 'E-mail report attachment management', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;