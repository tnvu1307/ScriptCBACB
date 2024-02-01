SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CIMAST_TX','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CIMAST_TX', 'Tra cứu nhanh thông tin tiểu khoản', 'CI account inquiry', 'select substr(cf.custodycd,1,4) || ''.'' ||
substr(cf.custodycd,5,6) custodycd ,
SUBSTR(af.ACCTNO,1,4) || ''.'' || SUBSTR(af.ACCTNO,5,6)
afACCTNO, cf.idcode, cf.fullname, typename, cf.iddate,
cf.idplace
from cfmast cf, afmast af, aftype t
where cf.custid = af.custid and af.actype = t.actype', 'CIMAST_TX', ' ', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;