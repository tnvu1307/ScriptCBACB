SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3385','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3385', 'Hoàn tất nhận chuyển nhượng(GD 3385)', 'Complete transfer (Transaction 3385)', 'SELECT TO_CHAR(MST.TXDATE,''DDMMRRRR'') || MST.TXNUM TXKEY, MST.CAMASTID, CAMAST.OPTCODEID, CAMAST.CODEID,
    NVL(CAMAST.TOCODEID,CAMAST.CODEID) TOCODEID,
    SYM.SYMBOL, SYM2.SYMBOL TOSYMBOL, MST.AMT,
    UPPER(MST.TOACCTNO) CUSTODYCD,CFT.CIFID TOCIFID, SUBSTR(MST.OPTSEACCTNOCR,1,10) TOAFACCTNO,
    MST.CUSTODYCD TOCUSTODYCD,CF.CIFID, SUBSTR(OPTSEACCTNODR,0,10) AFACCTNO,
    MST.CUSTNAME FULLNAME, MST.LICENSE IDCODE, MST.IDDATE IDDATE, MST.IDPLACE IDPLACE, MST.COUNTRY COUNTRY,
    MST.CUSTNAME2 TOFULLNAME, MST.LICENSE2 TOIDCODE, MST.IDDATE2 TOIDDATE, MST.IDPLACE2 TOIDPLACE, MST.COUNTRY2 TOCOUNTRY,
    MST.ADDRESS2 TOADDRESS, CAMAST.ISINCODE, MST.VSDSTOCKTYPE, MST.DDACCTNO, MST.NOTRANSCT, MST.REMOACCOUNT, CFT.MCUSTODYCD
FROM CATRANSFER MST, (SELECT * FROM CAMAST ORDER BY AUTOID DESC) CAMAST, SBSECURITIES SYM,
    SBSECURITIES SYM2, CFMAST CF,CFMAST CFT
WHERE (MST.STATUS = ''P'' OR (MST.STATUS = ''H'' AND THGOMONEY=''N'')) AND MST.OPTSEACCTNODR IS NULL
    AND MST.CAMASTID = CAMAST.CAMASTID
    AND CAMAST.CODEID = SYM.CODEID
    AND NVL(CAMAST.TOCODEID,CAMAST.CODEID)  = SYM2.CODEID
    AND CF.CUSTODYCD(+) = MST.CUSTODYCD
    AND CFT.CUSTODYCD(+) = MST.TOACCTNO', 'CAMAST', '', '', '3385', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;