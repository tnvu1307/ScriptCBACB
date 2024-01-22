SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('V_SE2202','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('V_SE2202', 'Danh sách import giao dịch phong tỏa chứng khoán (2202)', 'Import transaction block securities (2202)', '
select cf.custodycd, imp.codeid, af.acctno afacctno, imp.acctno acctno, cf.fullname custname, 
cf.address, cf.idcode license, imp.amt TAMT, imp.qttytype, imp.tradeamt amt, 
0 price, imp.des description, imp.symbol, imp.autoid, imp.parvalue
from tblse2202 imp, afmast af, cfmast cf
where nvl(imp.deltd,''N'') <> ''Y''
and imp.afacctno = af.acctno and af.custid = cf.custid
and imp.tradeamt > 0 and nvl(imp.status,''P'') <> ''C''
 ', 'SEMAST', '', '', '2202', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;