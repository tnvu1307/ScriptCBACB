SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFMAST_CUSTODY_TX','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFMAST_CUSTODY_TX', 'Tra cứu nhanh thông tin khách hàng', 'Customer information', 'SELECT format_custid(CF.CUSTID) CUSTID,
  case when CF.CUSTODYCD is null then '''' else format_custodycd(CF.CUSTODYCD) end CUSTODYCD,
   case when CF.CUSTODYCD is null then '''' else (CF.CUSTODYCD) end CUSTODYCD_SRCH,
  CF.SHORTNAME,CF.FULLNAME,CF.DATEOFBIRTH,CF.IDCODE,CF.IDDATE,CF.IDPLACE,CF.ADDRESS, mrloanlimit
FROM CFMAST CF, TLGROUPS GRP, AFMAST AF
WHERE   AF.CUSTID=CF.CUSTID
AND AF.CAREBY = GRP.GRPID
AND (SUBSTR(CF.CUSTID,1,4) = DECODE(''<$BRID>'', ''<$HO_BRID>'', SUBSTR(CF.CUSTID,1,4), ''<$BRID>'')
      OR AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
    )', 'CFMAST_CUSTODY_TX', '', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;