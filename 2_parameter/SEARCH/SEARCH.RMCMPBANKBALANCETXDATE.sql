SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RMCMPBANKBALANCETXDATE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RMCMPBANKBALANCETXDATE', 'Đối chiếu số dư tiền CB và corebank', 'Compare cash balance from CB with corebank', 'SELECT ROWNUM RN,REFCASAACCT, CCYCD, FLEXREFCASAACCT, CIFID, FULLNAME, CUSTODYCD, ACCTNO, STATUS, MATCHSTS, BANKBALANCE, BALANCE,
       BANKHOLDBALANCE, HOLDBALANCE, LASTREQBANK, OPNDATE, SUPEBANK, TXDATE
FROM (
    SELECT MST.*, NVL(A1.CDCONTENT,''-'') MATCHSTS, NVL(A2.CDCONTENT,''-'') SUPEBANK
    FROM (
        SELECT D.REFCASAACCT, D.ACCTNO, D.CCYCD,
            CASE WHEN NVL(RQ.STATUS,''R'') = ''C'' THEN RQ.BANKBALANCE ELSE 0 END BANKBALANCE,
            CASE WHEN NVL(RQ.STATUS,''R'') = ''C'' THEN RQ.BANKHOLDBALANCE ELSE 0 END BANKHOLDBALANCE,
            CASE WHEN NVL(RQ.STATUS,''-'') IN (''E'',''R'') THEN ''E''
                WHEN NVL(RQ.STATUS,''-'') = ''C'' THEN (CASE WHEN RQ.BANKBALANCE = RQ.BALANCE AND RQ.BANKHOLDBALANCE = RQ.HOLDBALANCE THEN ''Y'' ELSE ''N'' END)
                WHEN NVL(RQ.STATUS,''-'') = ''-'' THEN ''ZZ''
                ELSE ''P''
            END STATUS,
            D.REFCASAACCT FLEXREFCASAACCT, CF.CIFID, CF.FULLNAME, CF.CUSTODYCD, RQ.BALANCE, RQ.HOLDBALANCE, D.OPNDATE,
            NVL(TO_CHAR(RQ.CREATEDATE,''DD/MM/RRRR HH24:MI:SS''),'''') LASTREQBANK, CF.SUPEBANK SUPEBANKV,
            NVL(RQ.TXDATE, TO_DATE(''<@KEYVALUE>'',''DD/MM/RRRR'')) TXDATE
        FROM DDMAST D, CFMAST CF,
        (
            SELECT * FROM INQACCT_LOG WHERE TO_CHAR(TXDATE,''DD/MM/RRRR'') = ''<@KEYVALUE>''
        ) RQ,
        (
            SELECT VARVALUE  FROM SYSVAR WHERE VARNAME = ''DEALINGCUSTODYCD''
        )SYS
        WHERE CF.CUSTID = D.CUSTID
        AND D.ACCTNO = RQ.AFACCTNO(+)
        AND D.STATUS NOT IN (''C'')
        AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE SYS.VARVALUE
    )MST,
    (
        SELECT * FROM ALLCODE WHERE CDTYPE LIKE ''RM'' AND CDNAME = ''RMCMPBANKBALANCESTS''
    ) A1,
    (
        SELECT * FROM ALLCODE WHERE CDTYPE LIKE ''SY'' AND CDNAME = ''YESNO''
    ) A2
    WHERE MST.STATUS = A1.CDVAL(+)
    AND MST.SUPEBANKV = A2.CDVAL(+)
    AND TO_CHAR(MST.TXDATE,''DD/MM/RRRR'') = ''<@KEYVALUE>''
    ORDER BY MST.STATUS, MST.CUSTODYCD, MST.REFCASAACCT
) WHERE 0=0', 'RMCMPBANKBALANCETXDATE', 'frmRMCMPBANKBALANCETXDATE', NULL, '6671', NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;