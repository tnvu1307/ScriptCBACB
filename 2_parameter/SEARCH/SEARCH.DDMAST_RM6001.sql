SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DDMAST_RM6001','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DDMAST_RM6001', 'Quản lý tài khoản tiền', 'DD account management', 'select CF.CUSTODYCD, CF.FULLNAME, DD.AFACCTNO, DD.ACCTNO, DD.CCYCD, DD.REFCASAACCT,DD.BALANCE, DD.HOLDBALANCE,
        (DD.BALANCE + DD.HOLDBALANCE+Dd.PENDINGHOLD+Dd.pendingunhold)TOTAL,
        DD.bankbalance BANKAVABALANCE,NVL(DD.bankbalance + DD.bankholdbalance,0) BANKBALANCE,
        case when dd.ccycd = ''VND'' then 1 else nvl(ex.rate,0) end TTM_RATE
from DDMAST DD,AFMAST AF, CFMAST CF, (select currency, max(vnd) rate from exchangerate where rtype = ''TTM'' and itype = ''SHV'' group by currency) ex
where CF.custid = AF.CUSTID AND AF.ACCTNO = DD.AFACCTNO 
    and dd.ccycd = ex.currency(+)', 'DDMAST_RM6001', 'frmDDMAST', NULL, NULL, 0, 1000, 'N', 30, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;