SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TD0005','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TD0005', 'Sao ke trang thai (khong chan careby)', 'Statement of status (not need careby)', 'select af.actype aftype, tl.grpname careby, td.acctno, td.afacctno, cf.fullname, td.actype, td.orgamt,
    td.frdate, td.todate, (td.tdterm || '' '' || al.cdcontent) cdcontent,
    pck_bps.fnc_get_AdvIntRate (td.actype, td.orgamt) intrate, td.printpaid,
    fn_tdmastintratio(td.acctno, td.todate, td.orgamt) INTAMT, td.intpaid,
    fn_tdmastintratio(td.acctno, td.todate, td.orgamt) - td.intpaid chenhlechlai,
    fn_tdmastintratio(td.acctno, td.todate, td.balance) INTAVAMT, td.balance,
    a3.cdcontent buyingpower,
    CF.CUSTODYCD
from tdmast td, afmast af, cfmast cf, allcode al, tlgroups tl,allcode a3
where td.status in (''N'',''A'')
    and td.afacctno = af.acctno and af.custid = cf.custid
    and al.cdtype = ''TD'' and al.cdname = ''TERMCD''
    and td.termcd = al.cdval
    and cf.careby = tl.grpid
    AND A3.CDTYPE=''SY'' AND A3.CDNAME=''YESNO'' AND td.BUYINGPOWER=A3.CDVAL ', 'TDMAST', 'frmTDMAST', NULL, NULL, 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;