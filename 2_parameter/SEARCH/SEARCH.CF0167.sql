SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0167','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0167', 'Tra cứu re-active tài khoản giao dịch chứng khoán', 'EN:Tra cứu re-active tài khoản giao dịch chứng khoán', 'SELECT MST.CUSTID, MST.CUSTODYCD, MST.FULLNAME,
(case when  mst.idtype <> ''009'' then mst.idcode else mst.tradingcode end) IDCODE,
(case when  mst.idtype <> ''009'' then mst.iddate else mst.tradingcodedt end) IDDATE,
(case when  mst.idtype <> ''009'' then mst.idplace else ''Trung tâm lưu ký chứng khoán Việt Nam'' end) IDPLACE,
MST.IDTYPE, MST.COUNTRY, MST.ADDRESS, MST.MOBILESMS MOBILE, MST.EMAIL, MST.DESCRIPTION,
(''VISD/'' ||
    case when mst.idtype = ''001'' then ''IDNO''
         when mst.idtype = ''002'' then ''CCPT''
         when mst.idtype = ''005'' then ''CORP''
         when mst.idtype = ''009'' and mst.custtype = ''B'' then ''FIIN''
         when mst.idtype = ''009'' and mst.custtype = ''I'' then ''ARNU''
         else ''OTHR''
end) VSD_IDTYPE, A1.CDCONTENT VSD_COUNTRY,
A3.CDCONTENT DESC_IDTYPE, A4.CDCONTENT DESC_COUNTRY,MST.IDEXPIRED
FROM CFMAST MST, ALLCODE A1,ALLCODE A3, ALLCODE A4
WHERE MST.STATUS = ''C'' AND MST.ACTIVESTS = ''N'' and nsdstatus in (''R'',''K'',''P'',''N'',''C'')
AND A1.CDTYPE=''CF'' AND A1.CDNAME=''NATIONAL'' AND A1.CDVAL=MST.COUNTRY
AND A3.CDTYPE=''CF'' AND A3.CDNAME=''IDTYPE'' AND A3.CDVAL=MST.IDTYPE
AND A4.CDTYPE=''CF'' AND A4.CDNAME=''COUNTRY'' AND A4.CDVAL=MST.COUNTRY
AND MST.CUSTODYCD IS NOT NULL', 'CFMAST', 'frmSATLID', 'CUSTODYCD', '0037', NULL, 5000, 'N', 30, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;