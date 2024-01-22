SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0021B','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0021B', 'Nhận tiền bán G-Bond', 'Get money for selling G-Bond', 'SELECT  OD.TXNUM,OD.ORDERID,A1.<@CDCONTENT> TYPE,A1.CDVAL TYPECODE,OD.SYMBOL TPCP,OD.CODEID CODEID,OD.CUSTODYCD,OD.IDENTITY,OD.CITAD,OD.EXECQTTY QTTY,(CASE WHEN trim(CF.FEEDAILY) = ''Y'' THEN OD.NETAMOUNT ELSE OD.EXECAMT END) AMOUNT,
        OD.DDACCTNO,OD.AFACCTNO || OD.CODEID ACCTNO,''DD''TYPE_1,
        ''SETTLE-SELL - ''||OD.ORDERID || '' - '' || OD.symbol || '' - '' || od.execqtty DESCRIPTION
    from allcode A1 , odmast od,sbsecurities sb,cfmast cf
    where   od.codeid = sb.codeid
        and sb.bondtype = ''001''
        and od.exectype = A1.cdval and A1.cdname = ''ORDERSIDE'' and A1.cdtype = ''OD''
        and od.exectype = ''NS''
        and od.custid = cf.custid
        and od.cleardate = getcurrdate
        and od.ISPAYMENT = ''N''
        and not exists ( select f1.cvalue,l.txstatus from
                                    tllog l, tllogfld f1 where l.txnum = f1.txnum and
                                    l.txdate = f1.txdate and l.tltxcd = ''8880'' and f1.fldcd
                                    in(''35'',''31'') and l.txstatus in(''1'', ''4'') and f1.cvalue = od.ORDERID and f1.cvalue =''DD'')', 'OD.ODMAST', 'frmODMAST', 'TXNUM', '8880', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'N', 'T', '', 'N', '');COMMIT;