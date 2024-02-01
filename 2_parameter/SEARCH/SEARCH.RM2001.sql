SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM2001','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM2001', 'Danh sách các giao dịch thu hộ', 'List of collecting transaction ', '
select * from
(SELECT CRB.autoid, CRB.txdate, CRB.transactionnumber, A1.CDCONTENT status, CRB.trnref,  CRB.trn_dt, CRB.desbankaccount, CRB.accname,
    CRB.accnum, CRB.bankcode,   CRB.branch, CRB.location, CRB.amount, CRB.keyacct1, CRB.keyacct2,  CRB.transactiondescription,
    CRB.isconfirmed, CRB.ismanual, CRB.usercreated, CRB.createdt, CRB.errordesc
FROM crbbankrequest CRB, ALLCODE A1, SYSVAR SYS
where CRB.STATUS =A1.CDVAL AND A1.CDTYPE = ''RM'' AND A1.CDNAME = ''CRBRQDSTS''
AND SYS.GRNAME = ''SYSTEM'' AND SYS.VARNAME =''CURRDATE''
AND to_date(SYS.VARVALUE,''DD/MM/YYYY'') - CRB.txdate <= 30
order by CRB.autoid desc
) where 0=0
', 'RM2001', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;