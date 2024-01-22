SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CUSTODYCD_DL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CUSTODYCD_DL', 'Thông tin tài khoản lưu ký', 'Customer custody code', 'SELECT format_custid(CF.CUSTID) CUSTID, CF.CUSTODYCD,
CF.SHORTNAME,CF.FULLNAME,CF.MNEMONIC,CF.DATEOFBIRTH,A1.CDCONTENT IDTYPE,CF.IDCODE,CF.IDDATE,CF.IDPLACE,CF.IDEXPIRED,CF.ADDRESS,CF.MOBILE,
CF.PHONE,CF.FAX,CF.EMAIL,A2.CDCONTENT COUNTRY,A3.CDCONTENT PROVINCE,CF.POSTCODE,A5.CDCONTENT CLASS,A6.CDCONTENT GRINVESTOR,
A7.CDCONTENT INVESTRANGE,A8.CDCONTENT TIMETOJOIN,A9.CDCONTENT STAFF,CF.COMPANYID,CF.ISSUERID,A10.CDCONTENT POSITION,A11.CDCONTENT SEX,
A12.CDCONTENT SECTOR,A13.CDCONTENT FOCUSTYPE,A14.CDCONTENT BUSINESSTYPE,A15.CDCONTENT INVESTTYPE,A16.CDCONTENT EXPERIENCETYPE,
A17.CDCONTENT INCOMERANGE,A18.CDCONTENT ASSETRANGE,CF.BRID,GRP.GRPNAME CAREBY,CF.APPROVEID,CF.LASTDATE,CF.AUDITORID,CF.AUDITDATE,
A19.CDCONTENT LANGUAGE,CF.BANKACCTNO,CF.bankcode BANKCODE1,
A20.CDCONTENT BANKCODE,A21.CDCONTENT MARRIED,CF.DESCRIPTION,A22.CDCONTENT STATUS,A23.CDCONTENT ISBANKING,CF.CLASS CLASS1,CF.STAFF STAFF1,
CF.FOCUSTYPE FOCUSTYPE1,CF.REFNAME REFNAME1, MRLOANLIMIT, CF.TRADINGCODE, CF.TRADINGCODEDT,
(CASE WHEN CF.STATUS IN (''B'',''C'',''N'') THEN ''N'' ELSE ''Y'' END) EDITALLOW,
(CASE WHEN CF.STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW, ''Y'' DELALLOW
FROM
CFMAST CF, AFMAST AF,TLGROUPS GRP, ALLCODE A1, ALLCODE A2,ALLCODE A3,ALLCODE A5,ALLCODE A6,ALLCODE A7,ALLCODE A8,ALLCODE A9,ALLCODE A10, ALLCODE A11,ALLCODE A12,ALLCODE A13,ALLCODE A14,ALLCODE A15,ALLCODE A16,ALLCODE A17, ALLCODE A18,ALLCODE A19,ALLCODE A20,ALLCODE A21,ALLCODE A22, ALLCODE A23
WHERE
AF.CUSTID=CF.CUSTID
AND AF.CAREBY = GRP.GRPID
AND A1.CDTYPE = ''CF'' AND A1.CDNAME = ''IDTYPE'' AND A1.CDVAL= CF.IDTYPE
AND A2.CDTYPE = ''CF'' AND A2.CDNAME = ''COUNTRY'' AND A2.CDVAL= CF.COUNTRY
AND A3.CDTYPE = ''CF'' AND A3.CDNAME = ''PROVINCE'' AND A3.CDVAL= CF.PROVINCE
AND A5.CDTYPE = ''CF'' AND A5.CDNAME = ''CLASS'' AND A5.CDVAL= CF.CLASS
AND A6.CDTYPE = ''CF'' AND A6.CDNAME = ''GRINVESTOR'' AND A6.CDVAL= CF.GRINVESTOR
AND A7.CDTYPE = ''CF'' AND A7.CDNAME = ''INVESTRANGE'' AND A7.CDVAL= CF.INVESTRANGE
AND A8.CDTYPE = ''CF'' AND A8.CDNAME = ''TIMETOJOIN'' AND A8.CDVAL= CF.TIMETOJOIN
AND A9.CDTYPE = ''CF'' AND A9.CDNAME = ''STAFF'' AND A9.CDVAL= CF.STAFF
AND A10.CDTYPE = ''CF'' AND A10.CDNAME = ''POSITION'' AND A10.CDVAL= CF.POSITION
AND A11.CDTYPE = ''CF'' AND A11.CDNAME = ''SEX'' AND A11.CDVAL= CF.SEX
AND A12.CDTYPE = ''CF'' AND A12.CDNAME = ''SECTOR'' AND A12.CDVAL= CF.SECTOR
AND A13.CDTYPE = ''CF'' AND A13.CDNAME = ''FOCUSTYPE'' AND A13.CDVAL= CF.FOCUSTYPE
AND A14.CDTYPE = ''CF'' AND A14.CDNAME = ''BUSINESSTYPE'' AND A14.CDVAL= CF.BUSINESSTYPE
AND A15.CDTYPE = ''CF'' AND A15.CDNAME = ''INVESTTYPE'' AND A15.CDVAL= CF.INVESTTYPE
AND A16.CDTYPE = ''CF'' AND A16.CDNAME = ''EXPERIENCETYPE'' AND A16.CDVAL= CF.EXPERIENCETYPE
AND A17.CDTYPE = ''CF'' AND A17.CDNAME = ''INCOMERANGE'' AND A17.CDVAL= CF.INCOMERANGE
AND A18.CDTYPE = ''CF'' AND A18.CDNAME = ''ASSETRANGE'' AND A18.CDVAL= CF.ASSETRANGE
AND A19.CDTYPE = ''CF'' AND A19.CDNAME = ''LANGUAGE'' AND A19.CDVAL= CF.LANGUAGE
AND A20.CDTYPE = ''CF'' AND A20.CDNAME = ''BANKCODE'' AND A20.CDVAL= CF.BANKCODE
AND A21.CDTYPE = ''CF'' AND A21.CDNAME = ''MARRIED'' AND A21.CDVAL= CF.MARRIED
AND A22.CDTYPE = ''CF'' AND A22.CDNAME = ''CFSTATUS'' AND A22.CDVAL= CF.STATUS
AND A23.CDTYPE = ''SY'' AND A23.CDNAME = ''YESNO'' AND A23.CDVAL= CF.ISBANKING
AND SUBSTR(CF.custodycd,4,1)=''P''
AND (SUBSTR(CF.CUSTID,1,4) = DECODE(''<$BRID>'', ''<$HO_BRID>'', SUBSTR(CF.CUSTID,1,4), ''<$BRID>'')
    OR AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
    )', 'CFLINK', 'frmCFMAST', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;