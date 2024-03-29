SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CUSTODYCD_CF_EX','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CUSTODYCD_CF_EX', 'Tra cứu nhanh thông tin khách hàng', 'Customer information', 'SELECT format_custid(CF.CUSTID) CUSTID,
  case when CF.CUSTODYCD is null then '''' else CF.CUSTODYCD end CUSTODYCD,AF.ACCTNO,
  CF.SHORTNAME,CF.FULLNAME,CF.DATEOFBIRTH,CF.IDCODE,CF.IDDATE ,CF.IDCODE || '' - ('' || TO_CHAR(CF.IDDATE,''DD/MM/RRRR'') || '')'' IDCODE_DATE,CF.IDPLACE,CF.ADDRESS, mrloanlimit,t0loanlimit, AF.TLID OLDTLID, AF.CAREBY, CF.CUSTID T_CUSTID
  ,CF.MOBILESMS PHONE, NVL(CF.USERNAME, CF.CUSTODYCD) USERNAME,
  A1.cdcontent AFSTATUS
FROM CFMAST CF, TLGROUPS GRP, AFMAST AF , allcode a1
WHERE AF.CUSTID=CF.CUSTID
AND AF.CAREBY = GRP.GRPID
and a1.cdtype=''RE'' and cdname=''AFSTATUS'' AND A1.cdval=CF.afstatus
AND (SUBSTR(CF.CUSTID,1,4) = DECODE(''<$BRID>'', ''<$HO_BRID>'', SUBSTR(CF.CUSTID,1,4), ''<$BRID>'')
      OR AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
    )
 union all
 select ''---'' CUSTID,''---'' CUSTODYCD,'''' ACCTNO,
 '''' SHORTNAME,'''' FULLNAME,null DATEOFBIRTH,'''' IDCODE,null IDDATE,
  '''' IDCODE_DATE,'''' IDPLACE,'''' ADDRESS,
  0 mrloanlimit,0 t0loanlimit, '''' OLDTLID, '''' CAREBY, '''' T_CUSTID,'''' PHONE,
  '''' USERNAME,
  '''' AFSTATUS
 from dual', 'CUSTODYCD_CF_EX', NULL, NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;