SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0018','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0018', 'Quản lý thanh toán tiền nghiệp vụ bán TRPL', 'Management of selling transactions payment PPBs', 'SELECT NVL(SE.AUTOID, 0) AUTOID, CF.FULLNAME, CF.CIFID, CF.CUSTODYCD, DD.REFCASAACCT,
    OD.ORDERID, OD.CODEID, OD.ORDERQTTY QTTY, OD.EXECAMT AMT, OD.FEEAMT, OD.TAXAMT, OD.CLEARDATE, SB.SYMBOL, NVL(ODV.COMPLETE_AMT, 0) COMPLETE_AMT, 
    FA.SHORTNAME BROKER, FA.AUTOID BROKERVAL,
    A1.<@CDCONTENT> STATUS
FROM FAMEMBERS FA, 
(SELECT * FROM SBSECURITIES WHERE TRADEPLACE = ''099'') SB,
(SELECT * FROM DDMAST WHERE STATUS NOT IN (''C'')) DD,
(SELECT * FROM ODMAST WHERE EXECTYPE = ''NS'' AND DELTD = ''N'') OD, 
(
    SELECT ORDERID, SUM(GROSSAMOUNT) COMPLETE_AMT
    FROM ODMASTVSD 
    WHERE DELTD = ''N'' AND ISODMAST = ''Y'' AND ISPAYMENT = ''Y'' AND VSDORDERID IS NOT NULL 
    GROUP BY ORDERID
) ODV,
(SELECT * FROM VSTP_SETTLE_LOG WHERE DELTD = ''N'') SE,
(SELECT * FROM CFMAST WHERE STATUS NOT IN (''C'')) CF,
(SELECT * FROM SYSVAR WHERE GRNAME = ''SYSTEM'' AND VARNAME = ''CURRDATE'') CRD,
(SELECT * FROM ALLCODE WHERE CDNAME = ''VSTP_SETTLE_STATUS'' AND CDTYPE = ''SA'') A1
WHERE OD.CUSTID = CF.CUSTID
AND OD.MEMBER = FA.AUTOID
AND OD.DDACCTNO = DD.ACCTNO
AND OD.CODEID = SB.CODEID
AND OD.ORDERID = ODV.ORDERID(+)
AND OD.ORDERID = SE.ORDERID(+)
AND NVL(SE.STATUS, ''3.1'') = A1.CDVAL(+)
AND TO_DATE(OD.CLEARDATE, ''DD/MM/RRRR'') = TO_DATE(CRD.VARVALUE,''DD/MM/RRRR'')
AND 0 = 0', 'OD0018', 'frmOD0018', 'ORDERID DESC', '8823', NULL, 5000, 'N', 30, 'NNNNYNYNNNN', 'Y', 'T', '', 'N', '');COMMIT;