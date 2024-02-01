SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE8878','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE8878', 'Tra cứu trạng thái lô lẻ ', 'Odd lot trading status', '
select sb.symbol,cf.custodycd,se.qtty,se.price,se.qtty*se.price amt,af.acctno afacctno
, case when se.status =''R'' then ''Đã xóa'' when  se.status =''N'' then ''Đã HT xuất CK'' else ''Đã nhập CK tự doanh'' end  status
,mk.tlname maker, ck.tlname cheker,se.txdate ,se.vdate
from seretail se,sbsecurities sb,afmast af, cfmast cf, vw_tllog_all tl,tlprofiles mk, tlprofiles ck
where substr( se.acctno,11)= sb.codeid and
substr(se.acctno,1,10)= af.acctno and af.custid = cf.custid
and se.txnum = tl.txnum  and se.txdate = tl.txdate
and tl.TLID = mk.tlid and tl.OFFID = ck.tlid
and tl.tltxcd =''8878''', 'SEMAST', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;