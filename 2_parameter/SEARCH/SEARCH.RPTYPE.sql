SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RPTYPE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RPTYPE', 'Quản lý tài khoản Repo', 'Repo account management', 'select ACTYPE,ACNAME,GLGRP,TPR,A1.CDCONTENT STATUS,A2.CDCONTENT RPCLASS,A3.CDCONTENT RPTYPE,
A4.CDCONTENT CLEANDARCD,SPOTDAY,FORWARDAY, A5.CDCONTENT ACCRUED,A6.CDCONTENT TRTYPE
from RPTYPE,ALLCODE A1,ALLCODE A2,ALLCODE A3,ALLCODE A4,ALLCODE A5,ALLCODE A6
where
A1.CDTYPE = ''SY'' AND A1.CDNAME = ''YESNO'' AND A1.CDVAL= STATUS 
and A2.CDTYPE = ''RP'' AND A2.CDNAME = ''RPCLASS'' AND A2.CDVAL= RPCLASS 
and A3.CDTYPE = ''RP'' AND A3.CDNAME = ''RPTYPE'' AND A3.CDVAL= RPTYPE 
and A4.CDTYPE = ''RP'' AND A4.CDNAME = ''CLEANDARCD'' AND A4.CDVAL= CLEANDARCD 
and A5.CDTYPE = ''SY'' AND A5.CDNAME = ''YESNO'' AND A5.CDVAL= ACCRUED
AND A6.CDTYPE = ''RP'' AND A6.CDNAME = ''TRTYPE'' AND TRIM(A6.CDVAL)= TRIM(RPTYPE.TRTYPE)', 'RPTYPE', 'frmRPTYPE', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;