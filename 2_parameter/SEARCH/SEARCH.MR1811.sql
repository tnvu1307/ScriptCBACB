SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR1811','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR1811', 'Danh sách tiểu khoản chờ thu hồi hạn mức T0 (GD 1811)', 'View allocate guarantee T0 (waiting for 1811)', 'SELECT MST.TLID USERID, MST.TLNAME USERNAME, MST.ACCTNO, MST.CUSTODYCD, MST.FULLNAME, ACCLIMIT, MST.USRLIMIT, MST.T0AMT, 
MST.T0ACCUSER,MST.acclimit_today, MST.ADVT0AMT,
MST.ADVT0AMT AS ADVT0AMTMAX, MST.ACCUSERHIST, MST.ADVAMTHIST, MST.ADVAMTHIST AS ADVAMTHISTMAX,
mst.advanceline - mst.advt0amt USEDADVT0AMT,mst.advanceline,
CF1.FULLNAME REFULLNAME,
CF2.CUSTID REGRCUSTID, cf2.fullname REGRFULLNAME
FROM VW_ACCOUNT_ADVT0 MST, regrplnk regl, regrp reg, cfmast cf1, cfmast cf2, reaflnk ref, afmast af
where MST.ADVAMTHIST + MST.ADVT0AMT > 0
--and substr(fn_get_broker(mst.acctno,''AFACCTNO''),1,10)||substr(fn_get_broker(mst.acctno,''AFACCTNO''),12,4) = regl.reacctno(+)
and ref.status = ''A'' 
and mst.acctno = af.acctno 
and af.custid = ref.afacctno and ref.reacctno = regl.reacctno(+)
and regl.refrecflnkid = reg.autoid(+)
--and substr(fn_get_broker(mst.acctno,''AFACCTNO''),1,10) = cf1.custid(+)
and ref.recfcustid = cf1.custid(+)
and reg.custid = cf2.custid(+)', 'MRTYPE', '', '', '1811', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;