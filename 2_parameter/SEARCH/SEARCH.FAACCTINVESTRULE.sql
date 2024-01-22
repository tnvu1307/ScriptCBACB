SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FAACCTINVESTRULE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FAACCTINVESTRULE', 'Chính sách đầu tư', 'Investment rule', 'SELECT MST.AUTOID, MST.CUSTODYCD, MST.DESCRIPTION, MST.STATUS, MST.EFFDATE, MST.EXPDATE, MST.MINRATIO, MST.MAXRATIO,
A2.CDCONTENT DESCRATIOTYP , A1.CDCONTENT DESCRULECD, A0.CDCONTENT DESCSTATUS
FROM FAACCTINVESTRULE MST, ALLCODE A0, ALLCODE A1, ALLCODE A2
WHERE MST.CUSTODYCD=''<$KEYVAL>'' 
AND MST.STATUS=A0.CDVAL AND A0.CDTYPE=''SY'' AND A0.CDNAME=''YESNO''
AND MST.RULECD=A1.CDVAL AND A1.CDTYPE=''FA'' AND A1.CDNAME=''RULECD''
AND MST.RATIOTYP=A2.CDVAL AND A2.CDTYPE=''FA'' AND A2.CDNAME=''RATIOTYP''', 'FA.FAACCTINVESTRULE', '', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;