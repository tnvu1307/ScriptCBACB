SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR0026','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR0026', 'Cảnh báo tài khoản còn nợ hết chứng khoán', 'View account having dept and empty stocks', 'select cf.custodycd, af.acctno, cf.fullname,(ci.odamt + ci.cidepofeeacr + ci.depofeeamt + ci.lnfeeext + ci.smsfeeamt) odamt,
        (ci.odamt)loanamt,
        (ci.cidepofeeacr + ci.depofeeamt + ci.lnfeeext + ci.smsfeeamt) otheramt,
        (ci.balance+ bci.avladvance)  balance, a.cdcontent status
from afmast af, cfmast cf,buf_ci_account bci,
 (select s.afacctno,sum(s.trade+nvl(s.receivingod,0 ) /*+ s.netting*/) trade
  from  semast s , sbsecurities sb
  where s.codeid = sb.codeid   and sb.tradeplace in (''001'',''002'',''005'') and sb.sectype <> ''006''  and sb.sectype <> ''004''

  group by s.afacctno )se,

 cimast ci, allcode a, aftype ft, mrtype mt
,/*    (select afacctno,sum(case   when exectype in (''NS'',''MS'') then EXECQTTY else 0 end) SellQtty,
         sum(case   when exectype in (''NB'',''BC'') then EXECQTTY else 0 end) BuyQtty
     from buf_od_account
     group by afacctno) od
 */
 (
    select afacctno, sum(case when duetype=''SS'' then qtty else 0 end) SellQtty,
                     sum(case when duetype=''RS'' then qtty else 0 end) BuyQtty
    from stschd
    where status <> ''C'' and deltd <> ''Y''
    group by afacctno
)od
where af.custid =cf.custid
and af.acctno = se.afacctno(+)
and af.acctno = ci.afacctno
and af.acctno = bci.afacctno
and af.actype = ft.actype
and ft.mrtype = mt.actype
--and mt.mrtype =''T''
and af.acctno =od.afacctno(+)
and a.cdtype=''CF'' and a.cdname=''STATUS'' and a.cdval = af.status
and a.cdval <> ''B'' and a.cdval<> ''C''
and (ci.odamt + ci.cidepofeeacr+ ci.depofeeamt + ci.lnfeeext + ci.smsfeeamt)>0
and (nvl(se.trade,0) - nvl(od.SellQtty,0) + nvl(od.BuyQtty,0)) <=0
and EXISTS (select * from tlgrpusers g where g.grpid = af.careby and g.tlid = <$TELLERID> )
', 'MR0026', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'N', 'T', NULL, 'N', NULL);COMMIT;