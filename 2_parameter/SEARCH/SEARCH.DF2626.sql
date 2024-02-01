SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DF2626','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DF2626', 'Giải tỏa chứng khoán cầm cố VSD về chứng khoán thường (2626)', 'Rlease VSD DF stock to normal (2626)', 'select lns.autoid, DF.GROUPID,CF.CUSTODYCD,CF.FULLNAME,AF.ACCTNO AFACCTNO, SB.SYMBOL, SB.CODEID,
    DF.dfqtty + DF.dfstanding - NVL(ODM.SELLQTTY,0) DFQTTY, DF.AFACCTNO || DF.CODEID SEACCTNO,DF.ACCTNO DFACCTNO,
    CF.ADDRESS,CF.IDCODE, DECODE(DF.LIMITCHK,''N'',0,1) LIMITCHECK ,
    DF.ORGAMT AMT, NVL(LNS.NML,0) + NVL(LNS.OVD,0) LNAMT, NVL(LNS.PAID,0) PAIDAMT , DF.LNACCTNO , DF.STATUS DEALSTATUS ,DF.ACTYPE ,DF.RRTYPE, DF.DFTYPE, DF.CUSTBANK, DF.CIACCTNO,DF.FEEMIN,
    DF.TAX,DF.AMTMIN,DF.IRATE,DF.MRATE,DF.LRATE,DF.RLSAMT,DF.DESCRIPTION,
    (case when df.ciacctno is not null then df.ciacctno when df.custbank is not null then   df.custbank else '''' end )
    RRID , decode (df.RRTYPE,''O'',1,0) CIDRAWNDOWN,decode (df.RRTYPE,''B'',1,0) BANKDRAWNDOWN,
    decode (df.RRTYPE,''C'',1,0) CMPDRAWNDOWN,dftype.AUTODRAWNDOWN,df.calltype,
    A4.CDCONTENT RRTYPENAME, CF.MOBILESMS FAX1, CF.EMAIL
from dftype, afmast af , cfmast cf, allcode A4, SBSECURITIES SB,
    DFMAST DF
         LEFT JOIN LNSCHD LNS ON DF.LNACCTNO = LNS.ACCTNO AND LNS.REFTYPE=''P''
    LEFT JOIN (SELECT REFID, SUM(QTTY) SELLQTTY FROM ODMAPEXT WHERE DELTD <> ''Y'' GROUP BY REFID) ODM ON DF.ACCTNO = ODM.REFID
where df.afacctno= af.acctno and af.custid= cf.custid and df.actype=dftype.actype
and A4.cdname = ''RRTYPE'' and A4.cdtype =''DF''
AND SB.CODEID = DF.CODEID AND A4.CDVAL = DF.RRTYPE
AND dftype.isvsd=''Y'' AND DF.dfqtty + DF.dfstanding - NVL(ODM.SELLQTTY,0) > 0', 'DFGROUP', NULL, NULL, '2626', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;