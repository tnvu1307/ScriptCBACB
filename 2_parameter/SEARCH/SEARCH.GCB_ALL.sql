SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('GCB_ALL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('GCB_ALL', 'Thông tin GCB', 'GCB information', 'select fa.autoid, fa.shortname, fa.fullname, fa.taxcode, fa.taxcodedate, a1.en_cdcontent nationality
from FAMEMBERS fa, sbcurrency ccy, Allcode a1
where fa.roles = ''GCB''
and fa.taxccy = ccy.shortcd
and a1.cdtype = ''CF'' and a1.cdname = ''COUNTRY'' and a1.cdval = fa.nationality', 'GCB_ALL', NULL, NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;