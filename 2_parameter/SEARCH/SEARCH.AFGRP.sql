SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AFGRP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AFGRP', 'Quản lý nhóm tiểu khoản', 'Account group management', 'SELECT AFG.*, A.CDCONTENT STATUSCONTENT,(CASE WHEN AFG.STATUS=''P'' THEN ''Y'' ELSE ''N'' END) APRALLOW
FROM AFGRP AFG, ALLCODE A
where 0=0
AND cdtype = ''SA'' AND CDNAME  = ''AFGRPSTATUS''
AND A.CDVAL = AFG.STATUS', 'AFGRP', 'frmAFGRP', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;