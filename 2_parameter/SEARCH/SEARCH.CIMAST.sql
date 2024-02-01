SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CIMAST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CIMAST', 'Quản lý tiểu khoản tiền đầu tư', 'CI account management', 'SELECT CF.CUSTODYCD, CI.CUSTID,CI.ACTYPE, SUBSTR(CI.ACCTNO,1,4) || ''.'' || SUBSTR(CI.ACCTNO,5,6) ACCTNO,
SB.SHORTCD, SUBSTR(CI.AFACCTNO,1,4) || ''.'' || SUBSTR(CI.AFACCTNO,5,6) AFACCTNO,CF.FULLNAME, CF.ADDRESS, CF.IDCODE LICENSE, CF.IDDATE, CF.IDPLACE, CI.OPNDATE, CI.CLSDATE,CI.LASTDATE, CI.DORMDATE,
A0.CDCONTENT STATUS, CI.BALANCE,CI.CRAMT,CI.DRAMT,CI.CRINTACR,CI.CRINTDT,CI.ODINTACR,CI.ODINTDT,CI.AVRBAL,CI.MDEBIT,CI.MCREDIT,CI.AAMT,CI.RAMT,BAMT,CI.EMKAMT,CI.MMARGINBAL, CI.MARGINBAL,
CI.ODLIMIT ,CI.ICCFCD, A1.CDCONTENT ICCFTIED, AF.CAREBY CAREBY, AFT.LNTYPE, getavlCIwithdraw(CI.AFACCTNO,''U'') AVLCASH,getbaldefovd(CI.AFACCTNO) BALDEFOVD,
GET_DFDEBTAMT_RELEASE(CI.AFACCTNO,''U'') AVLRELEASE, CI.CIDEPOFEEACR, CI.HOLDBALANCE, CI.BANKBALANCE, CI.BANKAVLBAL
FROM CIMAST CI, ALLCODE A0 ,ALLCODE A1,CFMAST CF,SBCURRENCY SB, AFMAST AF, AFTYPE AFT
WHERE
CF.CUSTID = CI.CUSTID AND CI.CCYCD =SB.CCYCD AND
A0.CDTYPE = ''CI'' AND A0.CDNAME = ''STATUS'' AND A0.CDVAL=CI.STATUS
AND A1.CDTYPE = ''SY'' AND A1.CDNAME = ''YESNO'' AND A1.CDVAL=CI.ICCFTIED
AND AF.STATUS NOT IN (''C'')
AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
AND CI.AFACCTNO = AF.ACCTNO AND AF.ACTYPE = AFT.ACTYPE', 'CIMAST', 'frmCIMAST', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;