SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2302','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2302', 'Tra cứu các tài khoản đã lưu ký chưa lên VSD để hủy (TPRL)(2302)', 'Look up deposited accounts that have not been listed on VSD for cancellation (PPBs)(2302)', 'SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.REFERENCEID, 
    SB.CODEID, SB.SYMBOL,
    CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS,
    A1.<@CDCONTENT> TRADEPLACE, A2.<@CDCONTENT> CQTTYTYPE
FROM SEMAST SE, SBSECURITIES SB,
(SELECT * FROM SEDEPOSIT_TPRL WHERE DELTD = ''N'' AND STATUS IN (''P'',''R'')) SED,
(SELECT * FROM ALLCODE WHERE CDNAME = ''TRADEPLACE'' AND CDTYPE = ''SE'') A1,
(SELECT * FROM ALLCODE A WHERE CDNAME = ''VSDDEALTYPE'' AND CDTYPE = ''ST'') A2,
(
    SELECT C.CUSTID, C.CUSTODYCD, C.MCUSTODYCD, C.FULLNAME, C.ADDRESS, C.DATEOFBIRTH, C.PROVINCE, C.EMAIL, C.IDPLACE,
        (CASE WHEN SUBSTR(C.CUSTODYCD, 4, 1) = ''F'' THEN C.TRADINGCODE ELSE C.IDCODE END) IDCODE,  
        (CASE WHEN SUBSTR(C.CUSTODYCD, 4, 1) = ''F'' THEN C.TRADINGCODEDT ELSE C.IDDATE END) IDDATE, 
        ''VISD/'' || (CASE WHEN C.IDTYPE = ''001'' THEN ''IDNO''
             WHEN C.IDTYPE = ''002'' THEN ''CCPT''
             WHEN C.IDTYPE = ''005'' THEN ''CORP''
             WHEN C.IDTYPE = ''009'' AND C.CUSTTYPE = ''B'' THEN ''FIIN''
             WHEN C.IDTYPE = ''009'' AND C.CUSTTYPE = ''I'' THEN ''ARNU''
             ELSE ''OTHR'' END) ALTERNATEID,
        C.IDTYPE, C.CUSTTYPE, C.MOBILESMS PHONE, A1.CDCONTENT COUNTRY 
    FROM CFMAST C
    LEFT JOIN (
        SELECT *
        FROM ALLCODE A 
        WHERE CDNAME =  ''NATIONAL''
        AND A.EN_CDCONTENT IS NOT NULL
    ) A1 ON C.COUNTRY = A1.CDVAL(+)
    WHERE C.STATUS = ''A''
) CF
WHERE SE.ACCTNO = SED.ACCTNO
AND SE.CODEID = SB.CODEID
AND SED.CUSTODYCD = CF.CUSTODYCD
AND SB.TRADEPLACE = A1.CDVAL
AND SED.QTTYTYPE = A2.CDVAl
AND NOT EXISTS ( 
    SELECT F.CVALUE 
    FROM TLLOG TL, TLLOGFLD F 
    WHERE TL.TXNUM = F.TXNUM 
    AND TL.TXDATE = F.TXDATE 
    AND TL.TLTXCD = ''2302'' 
    AND TL.TXSTATUS IN (''4'') 
    AND F.FLDCD = ''99'' 
    AND F.NVALUE = SED.AUTOID
)', 'SE2302', 'frmSE2302', 'AUTOID DESC', '2302', 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;