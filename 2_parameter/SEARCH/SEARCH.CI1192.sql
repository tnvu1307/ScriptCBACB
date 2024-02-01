SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI1192','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI1192', 'Thu phí GD khách hàng lưu ký nơi khác', 'Collect maturity depository fee', 'select * from 
(
select cf.custodycd, cf.fullname, af.acctno afacctno,  sum(log.feeacr - log.feeamt) amt, 
max(a.cdcontent) transtype, log.bors,
case when log.bors = ''B'' then ''001'' else ''002'' end transtypecd,
af.acctno || log.bors keyval
from cfmast cf, afmast af, excustodfeelog log, allcode a 
where cf.custid = af.custid and af.acctno = log.afacctno 
and feeacr > feeamt 
and A.CDTYPE=''CI'' AND A.CDNAME=''DEPTYPETP'' and a.cdval = case when log.bors = ''B'' then ''001'' else ''002'' end
group by  cf.custodycd, cf.fullname, af.acctno, log.bors, af.acctno || log.bors
) where 0=0', 'CIMAST', 'CI1192', 'custodycd, afacctno', '1192', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;