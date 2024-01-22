SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3386','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3386', 'Hủy đăng ký mua CP phát hành thêm', 'Cancel right issue register', 'SELECT CA.ISINCODE, CS.CAMASTID, CF.CIFID, CS.AUTOID, CAR.CUSTODYCD, CS.AFACCTNO, SYM_ORG.SYMBOL SYMBOL_ORG, SYM.SYMBOL,
       A1.<@CDCONTENT> STATUS, CS.PBALANCE - CS.QTTYCANCEL PBALANCE, CAR.BALANCE, CAR.QTTY MAXQTTY, CAR.QTTY QTTY,
       CS.NMQTTY, CAR.AMT AAMT, CA.EXPRICE, SYM.PARVALUE, CA.DESCRIPTION, A2.<@CDCONTENT> CATYPE,
       (CASE WHEN CAR.MSGSTATUS=''E'' AND CAR.ERRMSG IS NOT NULL THEN CAR.ERRMSG ELSE A3.<@CDCONTENT> END) MSGSTATUS,
       CAR.SEACCTNO, CAR.OPTSEACCTNO, ISS.FULLNAME, CA.REPORTDATE, CA.TOCODEID CODEID, CAR.AUTOID REFCODE, ''N'' CONNECTS, ''YES'' COREBANK, ''1'' ISCOREBANK
FROM CAREGISTER CAR, CAMAST CA, CASCHD CS, AFMAST AF, SBSECURITIES SYM_ORG, SBSECURITIES SYM,
     ALLCODE A2, ALLCODE A1, ISSUERS ISS, ALLCODE A3, CRBTXREQ REQ, CFMAST CF, CRBTXREQ REQ1
WHERE CAR.CAMASTID = CA.CAMASTID
AND CAR.CAMASTID = CS.CAMASTID
AND CAR.AFACCTNO = CS.AFACCTNO
AND CAR.AFACCTNO = AF.ACCTNO
AND CA.CODEID = SYM_ORG.CODEID
AND CS.DELTD <> ''Y''
AND NVL(CA.TOCODEID,CA.CODEID) = SYM.CODEID
AND CA.CATYPE = A2.CDVAL AND A2.CDTYPE = ''CA'' AND A2.CDNAME = ''CATYPE''
AND A1.CDTYPE = ''CA'' AND A1.CDNAME = ''CASTATUS'' AND A1.CDVAL = CS.STATUS
AND A3.CDTYPE = ''CA'' AND A3.CDNAME = ''MSGSTATUS'' 
AND A3.CDVAL = CASE WHEN REQ.STATUS=''C'' AND CAR.MSGSTATUS = ''U'' AND REQ1.STATUS IS NULL THEN ''A''
                    WHEN REQ.STATUS=''C'' AND CAR.MSGSTATUS = ''P'' AND REQ1.STATUS = ''C''  THEN ''C''
                    WHEN REQ.STATUS <> ''C'' AND REQ.STATUS IS NOT NULL THEN ''E''
                    WHEN REQ1.STATUS <> ''C'' AND REQ1.STATUS IS NOT NULL THEN ''E''
                ELSE CAR.MSGSTATUS END
AND ISS.ISSUERID = SYM.ISSUERID
AND CAR.DELTD = ''N'' AND CA.CATYPE = ''014''
AND CAR.QTTY - CAR.CANCELQTTY > 0
AND CS.STATUS IN( ''M'',''A'',''S'')
AND CF.CUSTODYCD = CAR.CUSTODYCD
AND CAR.REQTXNUM=REQ.REQTXNUM(+)
AND CAR.BANKTXNUM=REQ1.REQTXNUM(+)', 'CAMAST', '', 'CAMASTID DESC', '3386', 0, 5000, 'N', 1, 'NYNNYYYNNY', 'Y', 'T', '', 'N', '');COMMIT;