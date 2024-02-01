SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DF3001','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DF3001', 'View theo dõi trạng thái Deal tổng', 'Group Deal Status', 'select FN_GET_LOCATION(AF.BRID) LOCATION, al1.cdcontent DEALFLAGTRIGGER,DF.GROUPID,CF.CUSTODYCD,CF.FULLNAME,AF.ACCTNO AFACCTNO,CF.ADDRESS,CF.IDCODE,DECODE(DF.LIMITCHK,''N'',0,1) LIMITCHECK ,
DF.ORGAMT -DF.RLSAMT AMT, DF.LNACCTNO , DF.STATUS DEALSTATUS ,DF.ACTYPE ,DF.RRTYPE, DF.DFTYPE, DF.CUSTBANK, DF.CIACCTNO,DF.FEEMIN,
DF.TAX,DF.AMTMIN,DF.IRATE,DF.MRATE,DF.LRATE,DF.RLSAMT,DF.DESCRIPTION, lns.rlsdate, lns.overduedate,
to_date (lns.overduedate,''DD/MM/RRRR'') - to_date ((SELECT VARVALUE FROM SYSVAR WHERE VARNAME=''CURRDATE''),''DD/MM/RRRR'') duenum,
(case when df.ciacctno is not null then df.ciacctno when df.custbank is not null then   df.custbank else '''' end )
RRID , decode (df.RRTYPE,''O'',1,0) CIDRAWNDOWN,decode (df.RRTYPE,''B'',1,0) BANKDRAWNDOWN,
decode (df.RRTYPE,''C'',1,0) CMPDRAWNDOWN,dftype.AUTODRAWNDOWN,df.calltype,LN.RLSAMT AMTRLS,
LN.RATE1,LN.RATE2,LN.RATE3,LN.CFRATE1,LN.CFRATE2,LN.CFRATE3,
A1.CDCONTENT PREPAIDDIS,A3.CDCONTENT AUTOAPPLYDIS,TADF,DDF, RTTDF RTT, ODCALLDF, ODCALLSELLDF ODSELLDF, ODCALLRTTDF, ODCALLMRATE ODCALLRTTF,
ODCALLSELLRCB, ODCALLSELLIRATE, ODCALLSELLIRATE - NVL(od.sellamount,0) ODCALLSELLMR, ODCALLSELLRXL,
CURAMT, CURINT, CURFEE, LNS.PAID, DF.DFBLOCKAMT, vndselldf, ROUND(vndwithdrawdf) vndwithdrawdf, ROUND(tadf - ddf*(v.irate/100),0) vwithdrawdf,
LEAST(ln.MInterm, TO_NUMBER( TO_DATE(lns.OVERDUEDATE,''DD/MM/RRRR'') - TO_DATE(lns.RLSDATE,''DD/MM/RRRR'')) )  MInterm, lnt.WARNINGDAYS,
A4.CDCONTENT RRTYPENAME, CF.MOBILESMS FAX1, CF.EMAIL, DF.ORGAMT,
A2.CDCONTENT INTPAIDMETHODDIS, ln.intpaidmethod, A5.CDCONTENT DRATEDIS, ln.DRATE, df.dfamt, dn.MKAMT, DFTYPE.TYPENAME
from dfgroup df, dftype, lnmast ln, lntype lnt ,(SELECT * FROM lnschd UNION SELECT * FROM lnschdhist) lns, afmast af , cfmast cf, allcode al1,
   ALLCODE A1, ALLCODE A2, ALLCODE A3, v_getgrpdealformular v , allcode A4, allcode A5, v_getdealsellamt od,
   (
    SELECT sum((DFQTTY + BLOCKQTTY+ RCVQTTY +CARCVQTTY) * si.DFREFPRICE) MKAMT, dn.groupid
    FROM dfmast dn, SECURITIES_INFO si
    WHERE dn.codeid = si.codeid GROUP BY groupid
   ) dn
where df.lnacctno= ln.acctno and ln.acctno=lns.acctno and ln.actype=lnt.actype and lns.reftype=''P'' and df.afacctno= af.acctno and af.custid= cf.custid and df.actype=dftype.actype
and A1.cdname = ''YESNO'' and A1.cdtype =''SY'' AND A1.CDVAL = LN.PREPAID
and A2.cdname = ''INTPAIDMETHOD'' and A2.cdtype =''LN'' AND A2.CDVAL = LN.INTPAIDMETHOD
and A3.cdname = ''AUTOAPPLY'' and a3.cdtype =''LN'' AND A3.CDVAL = LN.AUTOAPPLY
and A4.cdname = ''RRTYPE'' and A4.cdtype =''DF'' AND A4.CDVAL = DF.RRTYPE
and A5.cdname = ''DRATE'' and a5.cdtype =''LN'' AND A5.CDVAL = LN.DRATE
and df.flagtrigger=al1.cdval and al1.cdname=''FLAGTRIGGER'' and (oddf<>0 OR ta0df<>0)
and df.groupid=v.groupid and df.groupid=od.groupid(+) and df.afacctno=od.afacctno(+)
AND df.groupid=dn.groupid', 'DFGROUP', 'frmViewDFMAST', 'GROUPID DESC', NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;