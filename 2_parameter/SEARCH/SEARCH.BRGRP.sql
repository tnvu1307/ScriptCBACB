SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BRGRP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('BRGRP', 'Quản lý chi nhánh', 'Branch management', 'SELECT BRID, PRBRID, BRNAME, DCNAME,CUSTODYCDFROM,CUSTODYCDTO, A1.CDCONTENT STATUS, DESCRIPTION, GLBRID, GLDEPT , ISEDIT
 FROM BRGRP, ALLCODE A1 
 WHERE A1.CDTYPE = ''SA'' AND A1.CDNAME = ''BRSTATUS'' AND A1.CDVAL=STATUS', 'BRGRP', 'frmBRGRP', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;