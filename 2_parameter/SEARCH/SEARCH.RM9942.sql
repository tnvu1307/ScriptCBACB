SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM9942','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM9942', 'Tra cứu điện thông báo từ VSD', 'Manage MT598 infiniti from VSD', 'SELECT AUTOID, VSDMSGID, TRF.DESCRIPTION VSDPROMSG, VSDPROMSGID VSDPROMSG_VALUE, SYMBOL, VSDMSGDATE, VSDMSGDATEEFF, A2.CDCONTENT
VSDMSGTYPE, QTTY
FROM (select * from VSD_MT598_INF union all select * from vsd_mt598_inf_hist) VSD, VSDTRFCODE TRF, ALLCODE A2,
     (
        select max(to_date(decode(varname,''CURRDATE'',varvalue,''01/01/1900''),''DD/MM/RRRR'')) CURRDATE, max(decode(varname,''STPBKDAY'',to_number(varvalue),0)) STPBKDAY
        from sysvar where varname in (''CURRDATE'',''STPBKDAY'') and grname=''SYSTEM''
    ) sy
WHERE TRF.TRFCODE = VSDPROMSG
AND A2.CDTYPE = ''SA''
AND A2.CDNAME = ''VSDTYPE_598''
AND A2.CDVAL = VSDMSGTYPE
AND sy.currdate - VSD.vsdmsgdate <= sy.stpbkday', 'CFMAST', 'frmMT598', 'AUTOID DESC', NULL, 0, 5000, 'Y', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;