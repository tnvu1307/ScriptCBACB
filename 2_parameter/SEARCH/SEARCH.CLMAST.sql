SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CLMAST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CLMAST', 'Tài sản đảm bảo của khách hàng', 'Customer collateral', 'SELECT MST.ACTYPE, MST.BOOKVALUE, MST.CLVALUE, MST.CLAMT, MST.SECUREDRATIO, MST.SECUREDAMT, TYP.TYPENAME, MST.CUSTID, CF.FULLNAME, MST.ACCTNO, SBY.SHORTCD, MST.CCYCD, A0.CDCONTENT DESC_STATUS, MST.NOTES  FROM CLTYPE TYP, CLMAST MST, SBCURRENCY SBY, CFMAST CF, ALLCODE A0  WHERE MST.CCYCD=SBY.CCYCD AND TYP.ACTYPE=MST.ACTYPE AND MST.CUSTID=CF.CUSTID AND A0.CDTYPE=''CL'' AND A0.CDNAME=''STATUS'' AND A0.CDVAL=MST.STATUS', 'CLMAST', 'frmCLMAST', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;