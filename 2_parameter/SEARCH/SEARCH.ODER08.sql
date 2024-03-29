SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ODER08','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ODER08', 'Xóa đánh dấu ứng trước cầm cố VSD (8837)', 'Unmark mortgage advanced payment VSD (8837)', 'SELECT OD.TXDATE, OD.ORDERID, CF.CUSTODYCD, STS.AFACCTNO, SB.CODEID, SB.SYMBOL, OD.EXECTYPE EXECTYPEVL, A.CDCONTENT EXECTYPE, ODM.REFID DFACCTNO,
        OD.ORDERQTTY,  STS.AMT/STS.QTTY QUOTEPRICE, ODM.EXECQTTY MATCHQTTY, STS.AMT/STS.QTTY * ODM.EXECQTTY MATCHAMT, STS.CLEARDATE, '''' ERRREASON,
        CF.FULLNAME, CF.ADDRESS, CF.IDCODE
    FROM STSCHD STS, ODMAST OD, CFMAST CF, AFMAST AF, SBSECURITIES SB, ALLCODE A, DFMAST DF, ODMAPEXT ODM, DFTYPE DFT,
         (select * from sysvar where varname = ''CURRDATE'' and grname = ''SYSTEM'') sy
    WHERE STS.AFACCTNO = AF.ACCTNO AND CF.CUSTID = AF.CUSTID
        AND STS.CODEID = SB.CODEID AND STS.ORGORDERID = OD.ORDERID
        AND OD.ORDERID=ODM.ORDERID AND DF.ACCTNO = ODM.REFID
        AND DF.ACTYPE = DFT.ACTYPE AND DFT.ISVSD=''Y''
        AND STS.DUETYPE IN (''RM'') AND STS.DELTD <> ''Y''
        AND ODM.ISVSD = ''Y'' and sts.txdate = to_date(sy.varvalue,''DD/MM/RRRR'')
        AND A.CDTYPE = ''OD'' AND A.CDNAME = ''EXECTYPE'' AND A.CDVAL = OD.EXECTYPE', 'OD.ODMAST', NULL, 'TXDATE DESC, CUSTODYCD, SYMBOL, ORDERID', '8837', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;