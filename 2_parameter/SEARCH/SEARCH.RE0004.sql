SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RE0004','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RE0004', 'Tra cứu khách hàng chưa gán môi giới', 'View custommer not belong to any Remiser/Broker', 'SELECT DISTINCT NVL(cf.custodycd,''A'')custodycd , cf.fullname , cf.opndate,brgrp.brname
FROM cfmast cf,brgrp
WHERE cf.custodycd IS NOT NULL AND cf.isbanking <> ''Y'' AND cf.status <> ''C''
and cf.brid=brgrp.brid
AND cf.custid NOT IN
(SELECT DISTINCT afacctno
FROM reaflnk
WHERE status = ''A''
    )', 'RE.REMAST', 'frmREMAST', NULL, NULL, 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;