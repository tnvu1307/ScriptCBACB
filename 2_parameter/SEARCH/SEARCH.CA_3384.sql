SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA_3384','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA_3384', 'Thông tin dang ký mua', 'Buying information', 'SELECT * FROM (
select log.txdate,log.txnum,

max(case when fldcd = ''02'' then fld.cvalue else '''' end ) CAMASTID,
max(case when fldcd = ''96'' then fld.cvalue else '''' end ) CUSTODYCD,
max(case when fldcd = ''03'' then fld.cvalue else '''' end ) AFACCTNO,
max(case when fldcd = ''08'' then fld.cvalue else '''' end ) FULLNAME,
max(case when fldcd = ''04'' then fld.cvalue else '''' end ) SYMBOL,
max(case when fldcd = ''05'' then fld.nvalue else 0 end ) price,
max(case when fldcd = ''21'' then fld.nvalue else 0 end ) qtty
from vw_tllogfld_all fld, vw_tllog_all log
where fld.txdate = log.txdate and fld.txnum = log.txnum and tltxcd = ''3384''

and   fld.fldcd in (''02'',''05'',''21'',''04'',''08'',''03'',''96'')
group by log.txdate, log.txnum
)
WHERE 0=0', 'CA_3384', 'frmCA_3384', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;