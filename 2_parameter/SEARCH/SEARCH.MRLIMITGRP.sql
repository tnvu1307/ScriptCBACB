SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MRLIMITGRP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MRLIMITGRP', 'Quản lý nhóm hạn mức vay cho khách hàng', 'Customer margin limit management', 'SELECT MST.AUTOID, MST.GRPNAME, MRLIMIT,nvl(fn_getUsedMrLimitByGroup(mst.autoid),0) usedmrlimit, A1.CDCONTENT STATUS, NOTE,
(CASE WHEN STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW
FROM MRLIMITGRP MST, ALLCODE A1
WHERE A1.CDTYPE=''SY'' AND A1.CDNAME=''APPRV_STS'' AND A1.CDVAL=MST.STATUS ', 'MRLIMITGRP', 'frmMRLIMITGRP', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;