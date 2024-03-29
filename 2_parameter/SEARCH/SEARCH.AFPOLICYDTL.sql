SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AFPOLICYDTL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AFPOLICYDTL', 'Chi tiết chính sách đầu tư', 'Detail of investment policy for sub-account', 'SELECT MST.AUTOID, MST.MAXRATIO, MST.MAXVALUE, A0.CDCONTENT DESC_ATYPE,
A1.CDCONTENT DESC_TRADEPLACE, A2.CDCONTENT DESC_ECONOMIC, SBSYM.SYMBOL, SBCCY.SHORTCD
FROM AFPOLICYDTL MST, ALLCODE A0, ALLCODE A1, ALLCODE A2, SBSECURITIES SBSYM, SBCURRENCY SBCCY
WHERE A0.CDTYPE=''CF'' AND A0.CDNAME=''ATYPE'' AND A0.CDVAL=MST.ATYPE
AND A1.CDTYPE=''SA'' AND A1.CDNAME=''TRADEPLACE'' AND A1.CDVAL=MST.TRADEPLACE
AND A2.CDTYPE=''SA'' AND A2.CDNAME=''ECONOMIC'' AND A2.CDVAL=MST.SECTOR
AND MST.CODEID=SBSYM.CODEID AND MST.CCYCD=SBCCY.CCYCD AND MST.MSTID=''<$KEYVAL>''', 'CF.AFPOLICYDTL', 'frmAFPOLICYDTL', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;