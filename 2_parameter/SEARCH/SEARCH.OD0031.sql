SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0031','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0031', 'Cắt TPCP bán', 'Cut government bonds sold', 'SELECT  OD.TXNUM,OD.ORDERID,A1.<@CDCONTENT> TYPE,A1.CDVAL TYPECODE,OD.SYMBOL TPCP,OD.CODEID CODEID,OD.CUSTODYCD,OD.IDENTITY,OD.CITAD,OD.EXECQTTY QTTY,OD.NETAMOUNT AMOUNT,
        OD.DDACCTNO,OD.AFACCTNO || OD.CODEID ACCTNO,''SE''TYPE_1
from allcode A1 , odmast od,sbsecurities sb
where od.codeid = sb.codeid
and sb.bondtype = ''001''
and od.exectype = A1.cdval and A1.cdname = ''ORDERSIDE'' and A1.cdtype = ''OD''
and od.exectype = ''NS''
and od.cleardate = getcurrdate
--AND OD.ORSTATUS NOT IN (''5'',''7'')
and not exists (
    select f1.cvalue,l.txstatus 
    from tllog l, tllogfld f1 
    where l.txnum = f1.txnum 
    and l.txdate = f1.txdate 
    and l.tltxcd = ''8881'' 
    and f1.fldcd = ''12'' 
    and l.txstatus in(''1'', ''4'') 
    and f1.cvalue = od.IDENTITY
)   
and not exists ( 
    select f1.cvalue,l.txstatus 
    from tllog l, tllogfld f1 
    where l.txnum = f1.txnum 
    and l.txdate = f1.txdate 
    and l.tltxcd = ''8881'' 
    and f1.fldcd = ''35'' 
    and l.txstatus in(''1'', ''4'') 
    and f1.cvalue = od.ORDERID
)', 'OD.ODMAST', 'frmODMAST', '', '8881', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;