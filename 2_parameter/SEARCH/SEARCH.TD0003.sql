SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TD0003','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TD0003', 'Trang thai so du gui ho tro lai suat (khong chan careby)', 'Interest supported account status (non careby)', 'SELECT mst.actype, A3.CDCONTENT DESC_SCHDTYPE, tlgroups.grpname,
    MST.ACCTNO, MST.AFACCTNO, CF.FULLNAME, MST.ORGAMT, MST.FRDATE,
    (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = ''000''
                                AND SBDATE >= MST.TODATE AND HOLIDAY = ''N'') TODATE,
    MST.BALANCE, MST.INTPAID,
    FN_TDMASTINTRATIO(MST.ACCTNO,TO_DATE(SYSVAR.VARVALUE,''DD/MM/YYYY''),MST.BALANCE) INTAVLAMT,
    MST.INTPAID+
    FN_TDMASTINTRATIO(MST.ACCTNO,TO_DATE(SYSVAR.VARVALUE,''DD/MM/YYYY''),MST.BALANCE) total_INT,
    (MST.ORGAMT-MST.BALANCE) WITHDRAWAL,
    A4.cdcontent BUYINGPOWER,
    CF.CUSTODYCD
FROM TDMAST MST, AFMAST AF, CFMAST CF, ALLCODE A3, SYSVAR, tlgroups,allcode A4
WHERE MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND MST.STATUS in (''N'',''A'')
    and cf.careby = tlgroups.grpid
    AND A3.CDTYPE=''TD'' AND A3.CDNAME=''SCHDTYPE'' AND MST.SCHDTYPE=A3.CDVAL
    AND SYSVAR.VARNAME= ''CURRDATE''
    AND mst.balance > 0
    AND A4.CDTYPE=''SY'' AND A4.CDNAME=''YESNO'' AND MST.BUYINGPOWER=A4.CDVAL

', 'TDMAST', 'frmTDMAST', NULL, NULL, 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;