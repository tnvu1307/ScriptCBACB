SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('GLGRP','NULL') AND NVL(CDTYPE,'NULL') = NVL('CI','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CI', 'GLGRP', '0000', 'Khách hàng', 0, 'Y', 'Customer');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CI', 'GLGRP', '6666', 'Tự doanh', 1, 'Y', 'DL');COMMIT;