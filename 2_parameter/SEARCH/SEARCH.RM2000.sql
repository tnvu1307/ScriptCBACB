SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM2000','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM2000', 'Danh sách các giao dịch chi hộ', 'List of collecting transaction ', '
select * from
(SELECT mst.REQID,mst.TRFCODE,mst.REFCODE,mst.TXDATE,mst.OBJKEY, cf.custodycd, mst.AFACCTNO,
    mst.diraccname accname,mst.TXAMT, mst.DIRBANKCODE BANKCODE,mst.BANKACCT,  mst.dirbankname
BANKNAME, mst.dirbankcity BANKCITY,
    fn_gettcdtdesbankacc(substr(mst.AFACCTNO,1,4)) DESACCTNO,  fn_gettcdtdesbankname(substr
(mst.AFACCTNO,1,4)) DESACCTNAME, A1.CDCONTENT STATUS, mst.NOTES, MST.ERRORDESC
FROM (select * from CRBTXREQ union all select * from CRBTXREQhist)MST,CIREMITTANCE rm, afmast af, cfmast cf, 
     ALLCODE A1, SYSVAR SYS
WHERE MST.OBJTYPE = ''T'' AND MST.VIA = ''DIR'' and mst.afacctno = af.acctno and af.custid = cf.custid
AND SYS.GRNAME = ''SYSTEM'' AND SYS.VARNAME =''CURRDATE''
AND to_date(SYS.VARVALUE,''DD/MM/YYYY'') - mst.txdate <= 30
and mst.txdate = rm.txdate (+) and rm.txnum(+) = mst.objkey
AND MST.STATUS = A1.CDVAL AND A1.CDTYPE = ''RM'' AND A1.CDNAME = ''CRBSTATUS''
order by mst.REQID desc
) where 0=0
', 'CRBTXREQ', '', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;