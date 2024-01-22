SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3398','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3398', 'DS KH chờ nhận chuyển nhượng quyền mua(GD 3398)', 'List of pending right issue receiving (3398)', 'SELECT TO_CHAR(MST.TXDATE,''DDMMRRRR'') || MST.TXNUM TXKEY, MST.CAMASTID, CAMAST.OPTCODEID, CAMAST.CODEID,
    NVL(CAMAST.TOCODEID,CAMAST.CODEID) TOCODEID,
    SYM.SYMBOL, SYM2.SYMBOL TOSYMBOL, MST.AMT,
    UPPER(MST.TOACCTNO) TOCUSTODYCD, SUBSTR(MST.OPTSEACCTNOCR,1,10) TOAFACCTNO,
    CF.CUSTODYCD, AF.ACCTNO AFACCTNO, CF.FULLNAME, CF.IDCODE, CF.IDDATE, CF.IDPLACE, A1.CDCONTENT COUNTRY,CF.CIFID,
    CF2.FULLNAME TOFULLNAME, CF2.IDCODE TOIDCODE, CF2.IDDATE TOIDDATE, CF2.IDPLACE TOIDPLACE, A2.CDCONTENT TOCOUNTRY,CF2.CIFID TOCIFID,
    CF2.ADDRESS TOADDRESS, camast.isincode, MST.OPTSEACCTNOCR
FROM CATRANSFER MST, (SELECT * FROM CAMAST ORDER BY AUTOID DESC) CAMAST, SBSECURITIES SYM, AFMAST AF,
    CFMAST CF, SBSECURITIES SYM2, ALLCODE A1, AFMAST AF2, CFMAST CF2, ALLCODE A2
WHERE MST.STATUSRE = ''N'' AND  SUBSTR(MST.TOACCTNO,1,3) = ''022''
    AND MST.STATUS NOT IN (''Y'',''C'')
    AND MST.CAMASTID = CAMAST.CAMASTID
    AND CAMAST.CODEID = SYM.CODEID
    AND NVL(CAMAST.TOCODEID,CAMAST.CODEID)  = SYM2.CODEID
    AND SUBSTR(OPTSEACCTNODR,1,10) =  AF.ACCTNO
    AND AF.CUSTID = CF.CUSTID
    AND A1.CDTYPE = ''CF'' AND A1.CDNAME = ''COUNTRY'' AND CF.COUNTRY = A1.CDVAL(+)
    AND SUBSTR(OPTSEACCTNOCR,1,10) =  AF2.ACCTNO
    AND AF2.CUSTID = CF2.CUSTID
    AND A2.CDTYPE = ''CF'' AND A2.CDNAME = ''COUNTRY'' AND CF2.COUNTRY = A2.CDVAL(+)', 'CAMAST', '', '', '3398', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;