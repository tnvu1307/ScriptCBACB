SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RSA0007','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RSA0007', 'Danh sách chi nhánh/ Nhóm NSD/ NSD', 'List of Branch/Groups/User', 'SELECT * FROM
(SELECT ''Branch'' objtype, ''B'' || br.brid objid, br.brname objname
FROM brgrp br
UNION ALL
SELECT ''Group'' objtype, ''G'' || tlg.grpid objid, tlg.grpname objname
FROM tlgroups tlg
UNION ALL
SELECT ''User'' objtype, ''U'' || tl.tlid objid, tl.tlname objname
FROM tlprofiles tl) A
WHERE 0 = 0 ', 'TLGROUPS', 'frmTLGROUPS', 'OBJTYPE, OBJID', NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;