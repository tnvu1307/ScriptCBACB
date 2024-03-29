SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DD1011','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DD1011', 'Hủy tất toán phí', 'Cancel fee settlement', 'SELECT * FROM (
    SELECT FEE.AUTOID, CF.FULLNAME, CF.CUSTODYCD, FEE.BANKACCOUNT BANKACCTNO, FEE.CIFID PROFOLIOCD, FEE.CURRENCY CCYCD, FEE.FEEAMOUNT, FEE.FXRATE, FEE.FXAMOUNT, NVL(FEE.TAXAMOUNT,0) TAXAMOUNT,
            DECODE(FEE.CURRENCY,''VND'',ROUND((NVL(FEE.FEEAMOUNT,0) + NVL(FEE.TAXAMOUNT,0)),0),ROUND((NVL(FEE.FEEAMOUNT,0) + NVL(FEE.TAXAMOUNT,0)),2)) FEEAMTVAT,
            AL.CDVAL STATUSCDVAL, FEE.FEECODE, FEE.SETTLEDATE PAIDDATE, FEE.REMARK, TO_CHAR(FEE.TRANSDATE, ''DD/MM/RRRR'') TRANSDATE, TO_CHAR(FEE.SETTLEDATE, ''DD/MM/RRRR'') SETTLEDATE,
            FEE.TXDATE, FEE.FEETXDATE, FEE.FEETXNUM, FEE.BANKREFID, FEE.SPRACNO,
            TO_DATE(TO_CHAR(FEE.LASTCHANGE,''DD/MM/RRRR''),''DD/MM/RRRR'')LASTCHANGE,
            TO_CHAR(FEE.LASTCHANGE,''HH24:MI:SS'') CREATEDATE,A2.CDVAL DELTDCDVAL,FEE.FEENAME FEENAMECSTD,FEE.MCIFID,CF.MCUSTODYCD,
            AMC.SHORTNAME AMCSHORTNAME, GCB.SHORTNAME GCBSHORTNAME, NVL(CF.SETTLETYPE, ''60'') SETTLETYPE, ''Cancel the fee settlement ('' || FEE.REMARK || '')'' SETTREMARK,
            AL.<@CDCONTENT> STATUS, A2.<@CDCONTENT> DELTD, A3.<@CDCONTENT> AUTOFEE
    FROM SETTLE_FEE_LOG LOG,
    (
        SELECT * FROM FEE_BOOKING_RESULT
        UNION ALL
        SELECT*FROM FEE_BOOKING_RESULTHIST
    ) FEE,
    (
        SELECT CF.* FROM CFMAST CF WHERE CF.SUPEBANK = ''N'' AND CF.STATUS NOT IN (''C'')
    ) CF,
    (SELECT * FROM ALLCODE WHERE CDTYPE = ''DD'' AND CDNAME = ''FSTATUS'') AL,
    (SELECT * FROM ALLCODE WHERE CDTYPE = ''DD'' AND CDNAME = ''DELTDTEXT'') A2,
    (SELECT * FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'') A3,
    (SELECT * FROM FAMEMBERS WHERE ROLES = ''AMC'') AMC,
    (SELECT * FROM FAMEMBERS WHERE ROLES = ''GCB'') GCB
    WHERE FEE.CIFID = CF.CIFID
    AND LOG.FEEBOOKINGAUOID = FEE.AUTOID
    AND FEE.STATUS = AL.CDVAL(+)
    AND FEE.DELTD = A2.CDVAL(+)
    AND CF.AMCID = AMC.AUTOID(+)
    AND CF.GCBID = GCB.AUTOID(+)
    AND NVL(FEE.DELTD,''N'') NOT IN (''Y'')
    AND FEE.STATUS = ''S''
    AND LOG.STATUS = ''C''
    AND NVL(CF.AUTOSETTLEFEE, ''Y'') = A3.CDVAL(+)
)
WHERE 0=0', 'DD1011', 'frmFEEBOOKING', 'LASTCHANGE desc,CREATEDATE desc', '1208', 0, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;