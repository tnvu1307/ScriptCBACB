SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AFSERULE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AFSERULE', 'Chính sách đầu tư chứng khoán', 'Securities policies', 'SELECT DTL.AUTOID, SYM.SYMBOL, MST.ACTYPE, DTL.CODEID, DTL.TERMVAL, DTL.TERMRATIO,
A0.CDCONTENT POLICYCD, A0.EN_CDCONTENT EN_POLICYCD,
A2.CDCONTENT BORS, A2.EN_CDCONTENT EN_BORS,
DTL.EFFDATE, DTL.EXPDATE
FROM AFSERULE DTL, AFTYPE MST, SBSECURITIES SYM, ALLCODE A0, ALLCODE A1, ALLCODE A2
WHERE DTL.TYPORMST=''T'' AND MST.ACTYPE=''<$KEYVAL>''
AND MST.ACTYPE=DTL.REFID AND SYM.CODEID=DTL.CODEID
AND A0.CDTYPE=''CF'' AND A0.CDNAME=''REFPOLICYCD'' AND A0.CDVAL=MST.POLICYCD
AND A1.CDTYPE=''SA'' AND A1.CDNAME=''FOA'' AND A1.CDVAL=DTL.FOA
AND A2.CDTYPE=''SA'' AND A2.CDNAME=''BORS'' AND A2.CDVAL=DTL.BORS', 'CF.AFSERULE', 'frmAFSERULE', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;