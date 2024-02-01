SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CRBBANKREQUEST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CRBBANKREQUEST', 'Tra cứu điện nhận từ ngân hàng', 'Bank request management', 'SELECT R.AUTOID REQID,R.AUTOID,R.TRANSACTIONNUMBER,R.TXDATE TXDATE,R.REFTXNUM REQTXNUM,T.DESCRIPTION TRFCODE,to_char(R.CREATEDT,''dd/MM/yyyy hh24:mi:ss'') CREATEDATE,
        D.CUSTODYCD, R.DESBANKACCOUNT BANKACCT,D.CCYCD CURRENCY,R.AMOUNT AMOUNT,R.ISCONFIRMED STATUS,A1.<@CDCONTENT> STATUSTEXT,R.ERRORDESC,
        R.CFSTATUS,A2.<@CDCONTENT> CFSTATUSTEXT,R.CBOBJ,R.BANKOBJ,R.TRANSACTIONDESCRIPTION
FROM CRBBANKREQUEST R, DDMAST D,(SELECT *FROM ALLCODE WHERE CDNAME = ''RMSTATUS'' AND CDTYPE = ''RM'')A1,(SELECT * FROM ALLCODE WHERE  CDNAME = ''RMSTATUS'' AND CDTYPE = ''CI'')A2,
        BANKOBJ  T
WHERE   R.bankobj = T.FROBJ(+)
    AND R.DESBANKACCOUNT = D.REFCASAACCT(+)
    --AND R.MSGTYPE=''RQ''
    AND R.ISCONFIRMED = A1.CDVAL(+)
    AND R.CFSTATUS =A2.CDVAL(+)', 'CRBBANKREQUEST', NULL, 'AUTOID DESC', NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;