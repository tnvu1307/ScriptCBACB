SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('POMAST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('POMAST', 'Tra cứu nhanh bảng kê UNC', 'Payment order information', '
select TXDATE,TXNUM,AMT,BRID,DELTD,cd.cdcontent STATUS,BANKID,BANKNAME,BANKACC,
BANKACCNAME,GLACCTNO,FEETYPE,POTYPE,BENEFACCT,BENEFNAME,BENEFCUSTNAME,DESCRIPTION
from pomast po, allcode cd
where cd.cdname =''POSTATUS'' and cd.cdtype =''SA''
and cd.cdval= po.status
', 'POMAST', NULL, NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;