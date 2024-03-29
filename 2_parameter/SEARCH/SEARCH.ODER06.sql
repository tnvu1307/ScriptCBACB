SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ODER06','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ODER06', 'Hoàn tất sửa lỗi giao dịch (8849)', 'Complete fix error order (8849)', 'SELECT OD.TXDATE, OD.ORDERID, CF.CUSTODYCD, STS.AFACCTNO, SB.CODEID, SB.SYMBOL, OD.EXECTYPE EXECTYPEVL, A.CDCONTENT EXECTYPE,
        OD.ORDERQTTY, OD.QUOTEPRICE, STS.QTTY MATCHQTTY, STS.AMT MATCHAMT, STS.CLEARDATE, A2.CDCONTENT ERRREASON, CF.FULLNAME
    FROM STSCHD STS, ODMAST OD, CFMAST CF, AFMAST AF, SBSECURITIES SB, ALLCODE A, ALLCODE A2
    WHERE STS.AFACCTNO = AF.ACCTNO AND CF.CUSTID = AF.CUSTID
        AND STS.CODEID = SB.CODEID AND STS.ORGORDERID = OD.ORDERID
        AND STS.DUETYPE IN (''RM'',''RS'') AND STS.DELTD = ''Y''
        AND OD.ERROD = ''Y'' AND INSTR(DECODE(OD.ERRREASON,''02'',''E/G'',''G''),OD.ERRSTS) >0
        AND A.CDTYPE = ''OD'' AND A.CDNAME = ''EXECTYPE'' AND A.CDVAL = OD.EXECTYPE
        AND A2.CDTYPE = ''OD'' AND A2.CDNAME = ''ERRREASON'' AND A2.CDVAL = OD.ERRREASON
        --Neu lenh sua loi tu doanh thi phai lam 8848 truoc.
        AND (case when OD.ERRREASON =''01'' then remainqtty else 0 end) = 0', 'OD.ODMAST', NULL, 'TXDATE DESC, CUSTODYCD, SYMBOL, ORDERID', '8849', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;