SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CRBFILEEXPORT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CRBFILEEXPORT', 'Quản lý file bảng kê Offline', 'Offline list of voucher management', 'SELECT  F.FILEID, F.BANKCODE, B.BANKNAME, F.CREATEDATE, F.FILENAME, F.STATUS, A1.CDCONTENT DESC_STATUS,
         to_char(F.LASTDATE, ''DD/MM/RRRR hh24:mi:ss'') LASTDATE
FROM CRBFILEEXPORT F, CRBDEFBANK B, ALLCODE A1
WHERE F.BANKCODE = B.BANKCODE
      AND A1.CDNAME=''F_EXPORTSTATUS'' AND A1.CDTYPE =''SA'' AND A1.CDVAL = F.STATUS', 'CRBFILEEXPORT', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYYNYYNNNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;