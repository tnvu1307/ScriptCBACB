SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SBFXRT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SBFXRT', 'Quản lý tỷ giá quy đổi ngoại tệ', 'Currency exchange rate ', 'SELECT DISTINCT AUTOID,SBCURRENCY.SHORTCD CCYCD, EDATE,A0.CDCONTENT RATENUM, RATEBCY, RATEUSD,RATELCY 
FROM SBFXRT SBFXRT, ALLCODE A0,SBCURRENCY SBCURRENCY 
WHERE A0.CDTYPE = ''SY'' and A0.CDNAME =''RATENUM'' AND A0.CDVAL = RATENUM and SBCURRENCY.CCYCD = SBFXRT.CCYCD', 'SBFXRT', 'frmSBFXRT', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;