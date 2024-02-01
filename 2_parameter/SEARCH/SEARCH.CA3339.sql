SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3339','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3339', 'Danh sách khách hàng cắt tiền đăng ký quyền mua trước ngày', 'List of customers cut money to register the right issue before the date', 'SELECT MST.*,CF.CIFID, DD.ACCTNO, DD.CCYCD, ''D'' DORC,CA.DEBITDATE,CA.ISINCODE, CA.TOCODEID CODEID,
    SB1.SYMBOL, NVL(SB3.SYMBOL,SB2.SYMBOL) TOSYMBOL,MST.AMOUNT/MST.QTTY EXPRICE,DD.BALANCE,DD.REFCASAACCT REMOACCOUNT,
    (CASE WHEN MST.MSGSTATUS IN (''B'',''E'') THEN MST.ERRMSG ELSE A1.<@CDCONTENT> END) STATUS,
    CF.MCUSTODYCD, CF.FULLNAME
FROM (
    SELECT CAR.CAMASTID,CAR.CUSTODYCD,CAR.AFACCTNO,CAR.TRFACCTNO,SUM(CAR.QTTY) QTTY,SUM(CAR.exprice*(CAR.QTTY)) AMOUNT,
        SUM(CAR.CANCELQTTY) CANCELQTTY, CAR.REQTXNUM, ''INTRFCAREG'' TRFTYPE, MAX(CAR.ERRMSG) ERRMSG,MAX(CAR.MSGSTATUS) MSGSTATUS
    FROM CAREGISTER CAR
    WHERE CAR.QTTY > 0
    AND CAR.MSGSTATUS IN (''H'')
    AND CAR.DELTD <> ''Y''
    GROUP BY CAR.CAMASTID,CAR.CUSTODYCD,CAR.AFACCTNO,CAR.TRFACCTNO,CAR.REQTXNUM
)
MST, DDMAST DD, CAMAST CA, SBSECURITIES SB1, SBSECURITIES SB2, SBSECURITIES SB3, ALLCODE A1,CFMAST CF
WHERE MST.AFACCTNO=DD.AFACCTNO
AND MST.TRFACCTNO=DD.ACCTNO
AND MST.CAMASTID=CA.CAMASTID
AND CA.CODEID=SB1.CODEID
AND CA.OPTCODEID=SB2.CODEID
AND CA.TOCODEID=SB3.CODEID
AND MST.TRFACCTNO=DD.ACCTNO
AND A1.CDTYPE = ''CA'' AND A1.CDNAME = ''MSGSTATUS''
AND MST.MSGSTATUS=A1.CDVAL(+)
AND DD.status =''A''
AND CF.CUSTODYCD = MST.CUSTODYCD
AND CA.STATUS NOT IN (''C'')', 'CAMAST', NULL, 'DEBITDATE DESC', '3339', 0, 5000, 'N', 30, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;