SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CIBK83','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CIBK83', 'Tạo bảng kê thu phí lưu ký gửi NH', 'Create collection depository fee to send to bank', 'SELECT MST.OBJNAME, MST.TXDATE, MST.OBJKEY, MST.NOTES,
MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE LICENSE, RF.*
FROM CFMAST CF, AFMAST AF, CRBTXREQ MST, (SELECT *
FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
        FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.STATUS=''P'' AND MST.REQID=DTL.REQID AND MST.TRFCODE=''TRFSEFEE'')
PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN  (''TODATE'' as DUEDATE))
ORDER BY REQID) RF
WHERE CF.CUSTID=AF.CUSTID AND AF.ACCTNO=MST.AFACCTNO AND MST.REQID=RF.REQID', 'BANKINFO', 'TRFSEFEE', 'TXDATE, OBJKEY', 'EXEC', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;