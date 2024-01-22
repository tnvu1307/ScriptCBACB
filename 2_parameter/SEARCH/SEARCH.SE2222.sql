SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2222','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2222', 'Tra cứu tài khoản Chứng khoán để điều chỉnh giá (2222)', 'Adjust costprice (2222)', 'SELECT actype,
          SUBSTR (acctno, 1, 4)
       || ''.''
       || SUBSTR (acctno, 5, 6)
       || ''.''
       || SUBSTR (acctno, 11, 6) acctno,
       sym.codeid codeid, sym.symbol symbol,
       SUBSTR (afacctno, 1, 4) || ''.'' || SUBSTR (afacctno, 5, 6) afacctno,
       opndate, clsdate, lastdate, a1.cdcontent status, pstatus,
       a2.cdcontent irtied, a3.cdcontent iccftied, ircd, costprice, (trade -NVL(od.secureamt,0)) trade,
       (mortage -NVL(od.securemtg,0)) mortage, margin, netting, standing, withdraw, deposit, transfer, loan,
       SUBSTR (custid, 1, 4) || ''.'' || SUBSTR (custid, 5, 6) custid, costdt,
       blocked, ''Adjust costprice'' description, receiving, cf.custodycd
  FROM semast, sbsecurities sym, allcode a1, allcode a2, allcode a3,
  (SELECT    seacctno seacctno,
        SUM (case when od.exectype IN (''NS'', ''SS'') then remainqtty + execqtty else 0 end)  secureamt,
        SUM (case when od.exectype =''MS'' then remainqtty + execqtty else 0 end)  securemtg
        FROM odmast od
        WHERE deltd <> ''Y'' AND od.exectype IN (''NS'', ''SS'',''MS'')
        and txdate = (select to_date(VARVALUE,''DD/MM/YYYY'') from sysvar where grname=''SYSTEM'' and varname=''CURRDATE'')
   group by   seacctno
  ) od, (select custodycd, custid custidcfmast from cfmast) cf, (select custid custidafmast, acctno acctnoafmast from afmast) af
 WHERE a1.cdtype = ''SE''
   AND a1.cdname = ''STATUS''
   AND a1.cdval = semast.status
   AND a2.cdtype = ''SY''
   AND a2.cdname = ''YESNO''
   AND a2.cdval = irtied
   AND sym.codeid = semast.codeid
   AND a3.cdtype = ''SY''
   AND a3.cdname = ''YESNO''
   AND a3.cdval = semast.iccftied
   AND semast.afacctno = af.acctnoafmast
   and af.custidafmast = cf.custidcfmast
   AND acctno =od.seacctno(+)', 'SEMAST', '', '', '2222', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;