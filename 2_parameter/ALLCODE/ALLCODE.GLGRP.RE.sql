SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('GLGRP','NULL') AND NVL(CDTYPE,'NULL') = NVL('RE','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'GLGRP', '0000', 'Mặc định', 0, 'Y', 'Default');COMMIT;