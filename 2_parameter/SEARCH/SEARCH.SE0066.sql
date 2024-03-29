SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE0066','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE0066', 'Danh sách bảng kê chứng khoán giao dịch lô lẻ', 'List of odd lot trading ', '
SELECT MST.OBJNAME, MST.TXDATE, MST.OBJKEY, FN_CRB_GETVOUCHERNO(LG.TRFCODE, LG.TXDATE, LG.VERSION) VOUCHERNO,  A0.CDCONTENT DESC_STATUS,
MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, RF.*
FROM CRBTXREQ MST, CRBTRFLOG LG, CRBTRFLOGDTL LGDTL, ALLCODE A0,
(SELECT *
FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
        FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.REQID=DTL.REQID )
PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN
(''QTTY'' as QTTY, ''LICENSE'' as LICENSE, ''IDDATE'' as IDDATE,
''CUSTNAME'' as CUSTNAME, ''CUSTODYCD'' as CUSTODYCD, ''BOARD'' as BOARD, ''SYMBOL'' as SYMBOL))
ORDER BY REQID) RF
WHERE MST.REQID=RF.REQID
AND LG.AUTOID = LGDTL.VERSION
AND LGDTL.REFREQID = MST.REQID
AND A0.CDTYPE=''RM'' AND A0.CDNAME=''TRFLOGSTS'' AND A0.CDVAL=LG.STATUS
AND LG.TRFCODE = ''SEODDLOT''', 'AAAA', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;