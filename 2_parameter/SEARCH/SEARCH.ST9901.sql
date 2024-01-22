SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ST9901','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ST9901', 'Thông báo đăng ký mã chứng khoán mới', 'Notice of new stock code registration', 'SELECT NT.TRFCODE, VSD.DESCRIPTION, NT.VSDMSGDATE, NT.SYMBOL, NT.ISINCODE, A.CDCONTENT TRADEPLACE, NT.TRADE,
    (CASE WHEN NT.TRADE = 0 THEN ''SE NEW'' ELSE ''CA NEW'' END) TYPEMT
FROM NEWSTOCKREGISTER NT, VSDTRFCODE VSD,
(
    SELECT * FROM ALLCODE WHERE CDNAME = ''TRADEPLACE'' AND CDTYPE = ''RM''
)A
WHERE NT.DELTD <> ''Y''
AND NT.TRFCODE = VSD.TRFCODE
AND NT.TRADEPLACE = A.CDVAL(+)', 'ST9901', '', '', '', NULL, 5000, 'N', 30, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;