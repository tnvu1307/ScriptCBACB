SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.AFMRLIMITGRP','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.AFMRLIMITGRP', 'Danh sách tiểu khoản', 'Sub-Account list', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;