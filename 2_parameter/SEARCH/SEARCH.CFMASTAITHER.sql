SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFMASTAITHER','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFMASTAITHER', 'Đồng bộ thông tin khách hàng từ DNA', 'Customer information', 'SELECT A.REQID, A.ACTIONTYPE ACTIONTYPEVAL, A1.CDCONTENT ACTIONTYPE, CF.CUSTID,
      CF.CIFID, A.CIFID CIFIDA, CF.CUSTODYCD, CF.CUSTTYPE,
      CF.FULLNAME, A.NAME FULLNAMEA,
      CF.INTERNATION, A.NAME INTERNATIONA,
      CF.SHORTNAME, A.SHORTNAME SHORTNAMEA,
      CF.IDCODE, (CASE WHEN INSTR(A.IDNO,''-'',2,3) > 0  THEN SUBSTR(A.IDNO,0,INSTR (A.IDNO,''-'',2,3) -1) ELSE A.IDNO END) IDCODEA,
      CF.TAXCODE, (CASE WHEN INSTR(A.IDNO,''-'',2,3) > 0  THEN SUBSTR(A.IDNO,0,INSTR (A.IDNO,''-'',2,3) -1) ELSE A.IDNO END) TAXCODEA,
      CF.SUBTAXCODE, A.IDNO SUBTAXCODEA,
      CF.IDPLACE, A.IDPLACE IDPLACEA,
      CF.TAXCODEISSUEORGAN, A.IDPLACE TAXCODEISSUEORGANA,
      TO_CHAR(CF.IDDATE,''DD/MM/RRRR'') IDDATE, DECODE(NVL(TRIM(A.IDDATE),''XX''),''XX'',NULL,TO_CHAR(TO_DATE(A.IDDATE,''RRRR/MM/DD''),''DD/MM/RRRR'')) IDDATEA,
      TO_CHAR(CF.TAXCODEEXPIRYDATE,''DD/MM/RRRR'') TAXCODEEXPIRYDATE, DECODE(NVL(TRIM(A.IDDATE),''XX''),''XX'',NULL,TO_CHAR(TO_DATE(A.IDDATE,''RRRR/MM/DD''),''DD/MM/RRRR'')) TAXCODEEXPIRYDATEA,
      TO_CHAR(CF.IDEXPIRED,''DD/MM/RRRR'') IDEXPIRED, DECODE(NVL(TRIM(A.EXPIRED_DATE),''XX''),''XX'',NULL,TO_CHAR(TO_DATE(A.EXPIRED_DATE,''RRRR/MM/DD''),''DD/MM/RRRR'')) IDEXPIREDA,
      CF.COUNTRY, A.NATIONAL COUNTRYA,
      CF.PLACEOFBIRTH, A.NATIONAL PLACEOFBIRTHA,
      TO_CHAR(CF.DATEOFBIRTH,''DD/MM/RRRR'') DATEOFBIRTH, DECODE(NVL(TRIM(A.ESTABLISHDATE),''XX''),''XX'',NULL,TO_CHAR(TO_DATE(A.ESTABLISHDATE,''RRRR/MM/DD''),''DD/MM/RRRR'')) DATEOFBIRTHA,
      TO_CHAR(CF.ESTABLISHDATE,''DD/MM/RRRR'') ESTABLISHDATE, DECODE(NVL(TRIM(A.ESTABLISHDATE),''XX''),''XX'',NULL,TO_CHAR(TO_DATE(A.ESTABLISHDATE,''RRRR/MM/DD''),''DD/MM/RRRR'')) ESTABLISHDATEA,
      CF.ADDRESS, TRIM(A.ADDR1)||'' ''||TRIM(A.ADDR2)||'' ''||TRIM(A.ADDR3) ADDRESSA,
      CF.MOBILE, A.MOBILE MOBILEA,
      CF.CEO, TRIM(A.CEONAME) CEONAME,
      CF.FAX, TRIM(A.FAX) FAXA,
      CF.EMAIL, TRIM(A.EMAIL) EMAILA,
      CF.IDTYPE, ''005'' IDTYPEA,
      TO_CHAR(A.LASTCHANGE,''DD/MM/RRRR HH24:MI:SS'') LASTCHANGE
FROM CFMAST_AITHER A
LEFT JOIN CFMAST CF ON NVL(CF.MCIFID,CF.CIFID) = A.CIFID,
(SELECT *FROM ALLCODE  WHERE CDTYPE = ''RM'' AND CDNAME = ''ACTIONTYPE'') A1
WHERE ACTIONTYPE = A1.CDVAL
AND A.STATUS =''P''', 'CFMASTAITHER', NULL, 'REQID desc', '6679', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;