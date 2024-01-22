SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DF2669','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DF2669', 'Gia hạn hợp đồng vay (Giao dịch 2669)', 'Loan renew (2269)', 'select lnc.autoid ,lnc.acctno , ln.trfacctno afacctno, cf.fullname CUSTNAME,cf.idcode LICENSE,
cf.address,cf.custodycd,lnc.overduedate,lntype.typename  PRODUCTNAME,
ROUND(lnc.nml) AMT,
ROUND(lnc.intnmlacr+lnc.intdue) ointnmlacr,ROUND(lnc.feeintnmlacr+lnc.feeintdue) ofeeintnmlacr,
ROUND(lnc.intnmlacr+lnc.intdue) intnmlacr,ROUND(lnc.feeintnmlacr+lnc.feeintdue) feeintnmlacr,
ROUND(lnc.intnmlacr+lnc.intdue) + ROUND(lnc.feeintnmlacr+lnc.feeintdue) totalint,
lnc.rate1 orate1, lnc.rate2 orate2, lnc.rate3 orate3, lnc.cfrate1 ocfrate1, lnc.cfrate2 ocfrate2, lnc.cfrate3 ocfrate3, c1.cdcontent autoapply_desc,
lnc.rate1, lnc.rate2, lnc.rate3, lnc.cfrate1, lnc.cfrate2, lnc.cfrate3, ln.autoapply, ln.autoapply oautoapply
from  lnschd lnc , lnmast ln, afmast af , cfmast cf,lntype, sysvar sys, allcode c1  
where lnc.acctno = ln.acctno and ln.trfacctno= af.acctno
and af.custid = cf.custid  and lntype.actype= ln.actype
and sys.grname = ''SYSTEM'' and sys.varname = ''CURRDATE'' and lnc.overduedate >= to_date(sys.varvalue,''DD/MM/RRRR'')
and lnc.reftype = ''P'' and ln.ftype = ''DF''
and c1.cdtype = ''LN'' and c1.cdname = ''AUTOAPPLY'' and c1.cdval = ln.autoapply', 'SEMAST', 'frmSEMAST', '', '2669', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', 'CUSTODYCD', 'N', '');COMMIT;