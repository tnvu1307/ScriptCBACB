SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CUSTODYCD_BOND','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CUSTODYCD_BOND', 'Thông tin tài khoản lưu ký', 'Custody code information', 'SELECT format_custid(CF.CUSTID) CUSTID, CF.CUSTODYCD,CF.CIFID,
CF.FULLNAME,CF.SHORTNAME,CF.DATEOFBIRTH,A1.CDCONTENT IDTYPE,CF.IDCODE,CF.IDDATE,CF.IDPLACE,CF.IDEXPIRED,
A3.CDCONTENT STATUS,A2.CDCONTENT COUNTRY,CF.TRADINGCODE, CF.TRADINGCODEDT
FROM
CFMAST CF, AFMAST AF,ALLCODE A1, ALLCODE A2,ALLCODE A3
, (
    SELECT DISTINCT CUSTODYCD
    FROM SBSECURITIES SB, BONDSEMAST SE
    WHERE SB.CODEID = SE.BONDCODE
  ) CS
WHERE
AF.CUSTID=CF.CUSTID
AND CF.CUSTODYCD=CS.CUSTODYCD
AND A1.CDTYPE(+) = ''CF'' AND A1.CDNAME(+) = ''IDTYPE'' AND A1.CDVAL(+)= CF.IDTYPE
AND A2.CDTYPE(+) = ''CF'' AND A2.CDNAME(+) = ''COUNTRY'' AND A2.CDVAL(+)= CF.COUNTRY
AND A3.CDTYPE(+) = ''CF'' AND A3.CDNAME(+) = ''CFSTATUS'' AND A3.CDVAL(+)= CF.STATUS', 'CFLINK', 'frmCFMAST', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;