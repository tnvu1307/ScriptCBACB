SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ORTYPE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ORTYPE', 'Quản lý loại hình lệnh giao dịch', 'OD type', 'SELECT ACTYPE, TYPENAME, GLGRP, BRATIO, A1.CDCONTENT TIMETYPE, A2.CDCONTENT NORK, A3.CDCONTENT VIA, A4.CDCONTENT STATUS, DESCRIPTION FROM ORTYPE, ALLCODE A1, ALLCODE A2,ALLCODE A3, ALLCODE A4 WHERE A1.CDTYPE = ''OD'' AND A1.CDNAME = ''TIMETYPE'' AND A1.CDVAL=TIMETYPE AND A2.CDTYPE = ''OD'' AND A2.CDNAME = ''NORK'' AND A2.CDVAL=NORK AND A3.CDTYPE = ''OD'' AND A3.CDNAME = ''VIA'' AND A3.CDVAL=VIA AND A4.CDTYPE = ''SY'' AND A4.CDNAME = ''YESNO'' AND A4.CDVAL=STATUS', 'ORTYPE', 'frmORTYPE', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;