SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR0005','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR0005', 'Tra cứu hạn mức Margin của tiểu khoản', 'View customer margin limit', '
select af.actype, aft.typename, cf.custodycd, af.acctno afacctno,
cf.fullname ,cf.mrloanlimit ,cf.t0loanlimit,
af.mrcrlimitmax ,af.advanceline ,af.mrcrlimitmax - dfodamt - nvl(marginamt,0) avlmrloanlimit,
nvl(ADVT0AMT,0) avlt0loanlimit
from afmast af, cimast ci, cfmast cf, aftype aft,
(select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) marginamt
    from lnmast where ftype = ''AF'' group by trfacctno) ln, vw_account_advt0 t0
where af.custid=cf.custid
and af.actype =aft.actype
and af.acctno = ci.acctno
and af.acctno = ln.trfacctno(+)
and af.acctno = t0.acctno(+)
', 'MRTYPE', '', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;