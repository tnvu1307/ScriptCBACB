SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AMC_ALL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AMC_ALL', 'Thông tin AMC', 'AMC information', 'select fa.autoid, fa.shortname, fa.fullname, fa.taxcode, fa.taxcodedate, a1.en_cdcontent nationality
from FAMEMBERS fa, sbcurrency ccy, Allcode a1
where fa.roles = ''AMC''
and fa.taxccy = ccy.shortcd
and a1.cdtype = ''CF'' and a1.cdname = ''COUNTRY'' and a1.cdval = fa.nationality', 'AMC_ALL', NULL, NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;