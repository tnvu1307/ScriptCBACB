SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DF2680','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DF2680', 'Báo cầm cố lên trung tâm lưu ký', 'View send mortgage to depository center', '
SELECT v.*, (v.dfqtty + v.rcvqtty + v.carcvqtty + v.blockqtty)  SENDQTTY
FROM v_getdealinfo v  WHERE  v.status =''N'' and v.dftype=''M''
and  v.dfqtty + v.rcvqtty + v.carcvqtty + v.blockqtty>0 ', 'DFMAST', NULL, 'v.ACCTNO DESC', '2680', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;