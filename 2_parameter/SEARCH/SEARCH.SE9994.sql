SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE9994','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE9994', 'Danh sách khách hàng sở hữu chứng quyền chưa thực hiện', 'Customer List warrants owned unrealized', ' select * from vw_se9994cw where 0 = 0 ', 'SE9994', '', ' CWSYMBOL, SYMBOL, CUSTODYCD, AFACCTNO ', '', NULL, 1000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;