SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('REGRPTYPE_R','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('REGRPTYPE_R', 'Đại lý/môi giới', 'Broker/Remiser management', 'SELECT RF.AUTOID, CF.FULLNAME, RF.FULLNAME GRPNAME, RF.GRPLEVEL, A0.CDCONTENT DESC_STATUS, RF.CUSTID, RF.EFFDATE, RF.EXPDATE, RF.FULLNAME || '': '' || CF.FULLNAME RETVALUE, RF.ACTYPE, SP_FORMAT_REGRP_MAPCODE(RF.AUTOID) MAPCODE, SP_FORMAT_REGRP_GRPLEVEL(RF.AUTOID) MAPLEVEL FROM REGRP RF, CFMAST CF, ALLCODE A0 WHERE A0.CDTYPE=''RE'' AND A0.CDNAME=''STATUS'' AND A0.CDVAL=RF.STATUS AND RF.CUSTID=CF.CUSTID AND RF.CUSTID=CF.CUSTID AND RF.STATUS=''A'' AND RF.GRPTYPE = ''R''', 'REGRPLNK', 'frmRECFLNK', 'FULLNAME', NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;