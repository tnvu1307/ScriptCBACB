SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CUSTODYCD_CF_CHILD','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CUSTODYCD_CF_CHILD', 'Tra cứu nhanh thông tin khách hàng', 'Customer information', 'SELECT FORMAT_CUSTID(CF.CUSTID) CUSTID, CF.CUSTODYCD, AF.ACCTNO, CF.IDPLACE, CF.ADDRESS, CF.MRLOANLIMIT, CF.T0LOANLIMIT, AF.TLID OLDTLID, AF.CAREBY, CF.CUSTID T_CUSTID,
    (CASE WHEN CF.IDTYPE=''009'' THEN CF.TRADINGCODE ELSE CF.IDCODE END ) TRADINGCODE,
    (CASE WHEN CF.IDTYPE=''009'' THEN CF.TRADINGCODEDT ELSE CF.IDDATE END ) TRADINGCODEDT,
    CF.SHORTNAME, CF.FULLNAME,CF.DATEOFBIRTH, CF.IDCODE,CF.IDDATE , A2.CDCONTENT COUNTRY, CF.IDCODE || '' - ('' || TO_CHAR(CF.IDDATE,''DD/MM/RRRR'') || '')'' IDCODE_DATE,
    CF.MOBILESMS PHONE, NVL(CF.USERNAME, CF.CUSTODYCD) USERNAME,
    A1.CDCONTENT AFSTATUS,
    (SELECT BANKACC FROM (SELECT * FROM CFOTHERACC ORDER BY AUTOID) CFO WHERE CFO.CFCUSTID LIKE CF.CUSTID AND ROWNUM = 1  AND TYPE =1) BANKACC
    ,CF.CIFID, CF.CUSTATCOM, CF.CIFID MARGINCONTRACTNO,CF.COUNTRY COUNTTRYID
FROM CFMAST CF, TLGROUPS GRP, AFMAST AF,
    (SELECT CF.CUSTODYCD, CF.MCUSTODYCD FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = ''<@KEYVALUE>'') CF_CHILE,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''AFSTATUS'' AND CDTYPE = ''RE'') A1,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''COUNTRY'' AND CDTYPE = ''CF'') A2
WHERE AF.CUSTID=CF.CUSTID
AND AF.CAREBY = GRP.GRPID
AND NVL(CF.MCUSTODYCD, CF.CUSTODYCD) = NVL(CF_CHILE.MCUSTODYCD, CF_CHILE.CUSTODYCD)
AND CF.CUSTODYCD <> CF_CHILE.CUSTODYCD
AND CF.COUNTRY = A2.CDVAL(+)
AND CF.AFSTATUS = A1.CDVAL(+)
AND (SUBSTR(CF.CUSTID,1,4) = DECODE(''<$BRID>'', ''<$HO_BRID>'', SUBSTR(CF.CUSTID,1,4), ''<$BRID>'') OR AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>''))', 'CUSTODYCD_CF', NULL, NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;