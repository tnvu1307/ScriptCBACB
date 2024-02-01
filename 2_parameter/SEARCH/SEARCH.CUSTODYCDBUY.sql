SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CUSTODYCDBUY','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CUSTODYCDBUY', 'Tra cứu nhanh thông tin khách hàng', 'Customer information', 'SELECT format_custid(CF.CUSTID) CUSTID,
  case when CF.CUSTODYCD is null then '''' else CF.CUSTODYCD end CUSTODYCD,AF.ACCTNO
  , (CASE WHEN CF.IDTYPE=''009'' THEN CF.tradingcode ELSE CF.IDCODE END ) tradingcode,
   (CASE WHEN CF.IDTYPE=''009'' THEN CF.tradingcodedt ELSE CF.IDDATE END ) tradingcodedt,
  CF.SHORTNAME,CF.FULLNAME,CF.DATEOFBIRTH,CF.IDCODE,CF.IDDATE , a2.cdcontent country, CF.IDCODE || '' - ('' || TO_CHAR(CF.IDDATE,''DD/MM/RRRR'') || '')'' IDCODE_DATE,CF.IDPLACE,CF.ADDRESS, mrloanlimit,t0loanlimit, AF.TLID OLDTLID, AF.CAREBY, CF.CUSTID T_CUSTID,
  CF.MOBILESMS PHONE, NVL(CF.USERNAME, CF.CUSTODYCD) USERNAME,
  A1.cdcontent AFSTATUS,
  (SELECT BANKACC FROM (SELECT * FROM CFOTHERACC ORDER BY AUTOID) CFO WHERE CFO.cfcustid LIKE CF.custid AND ROWNUM = 1  AND TYPE =1) BANKACC
  ,CF.CIFID, CF.CUSTATCOM, CF.CIFID Margincontractno,CF.COUNTRY COUNTTRYID
FROM CFMAST CF, TLGROUPS GRP, AFMAST AF, allcode a1, ALLCODE A2
WHERE AF.CUSTID=CF.CUSTID
AND AF.CAREBY = GRP.GRPID
AND A2.CDTYPE = ''CF'' AND A2.CDNAME = ''COUNTRY'' AND cf.country = a2.cdval
and a1.cdtype=''RE'' and A1.cdname=''AFSTATUS'' AND A1.cdval= CF.afstatus
AND (SUBSTR(CF.CUSTID,1,4) = DECODE(''<$BRID>'', ''<$HO_BRID>'', SUBSTR(CF.CUSTID,1,4), ''<$BRID>'')
      OR AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
    )', 'CUSTODYCDBUY', NULL, NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;