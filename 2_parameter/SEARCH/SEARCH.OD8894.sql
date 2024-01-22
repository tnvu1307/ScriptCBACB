SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD8894','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD8894', 'Hủy kết quả giao dịch', 'Cancel order results from source', 'select a.*, A1.<@CDCONTENT> ASSETTYPE
from
(
    select ''Client'' source, A1.CDCONTENT VIA,to_char(txtime,''dd/MM/RRRR'')recorddate,dp.shortname ctck,od.custodycd,od.sec_id symbol,A2.CDCONTENT ODTYPE,
    od.trade_date tradedate,od.settle_date settledate,od.price,od.quantity qtty, od.gross_amount grossamount, nvl(od.commission_fee,''0'') fee,
    nvl(od.tax,''0'')tax,fileid IDFILE,autoid,A3.CDCONTENT STATUSTEXT,A3.CDVAL STATUS
    from odmastcust od, deposit_member dp, allcode A1, allcode A2, allcode A3
    where od.via = A1.cdval and A1.cdtype = ''OD'' and A1.cdname = ''VIA''
    and od.broker_code = dp.depositid
    and A2.cdname = ''EXECTYPE'' and A2.cdtype = ''OD'' and A2.cdval = od.trans_type
    and od.isodmast = ''N''
    and A3.cdname = ''CORDER'' and A3.cdtype = ''OD'' and A3.cdval = od.deltd
    and deltd <> ''Y''
    union all
    select ''Broker'' source, (case when length(fileid) >17 then ''Manual'' else ''Import'' end) VIA,to_char(txtime,''dd/MM/RRRR'')recorddate,dp.shortname ctck,od.custodycd,od.sec_id symbol,A2.CDCONTENT ODTYPE,
    od.trade_date tradedate,od.settle_date settledate,od.price,od.quantity qtty, od.gross_amount grossamount, nvl(od.commission_fee,''0'') fee,
    nvl(od.tax,''0'')tax,fileid IDFILE,autoid,A3.CDCONTENT STATUSTEXT,A3.CDVAL STATUS
    from odmastcmp od, deposit_member dp, allcode A2, allcode A3
    where od.broker_code = dp.depositid
    and A2.cdname = ''EXECTYPE'' and A2.cdtype = ''OD'' and A2.cdval = od.trans_type
    and od.isodmast = ''N''
    and A3.cdname = ''CORDER'' and A3.cdtype = ''OD'' and A3.cdval = od.deltd
    and deltd <> ''Y''
    union all
    select ''VSD'' source, (case when length(fileid) >17 then ''Manual'' else ''Import'' end) VIA,to_char(txtime,''dd/MM/RRRR'')recorddate,dp.shortname ctck,od.custodycd,od.sec_id symbol,A2.CDCONTENT ODTYPE,
    od.trade_date tradedate,od.settle_date settledate,od.price,od.quantity qtty, od.grossamount grossamount,--to_char((od.price*od.quantity)) grossamount,
    ''0'' fee,
    ''0'' tax,fileid IDFILE,autoid,A3.CDCONTENT STATUSTEXT,A3.CDVAL STATUS
    from odmastvsd od, deposit_member dp, allcode A2, allcode A3
    where od.broker_code = dp.depositid
    and A2.cdname = ''EXECTYPE'' and A2.cdtype = ''OD'' and A2.cdval = od.trans_type
    and od.isodmast = ''N''
    and A3.cdname = ''CORDER'' and A3.cdtype = ''OD'' and A3.cdval = od.deltd
    and deltd <> ''Y''
) a, sbsecurities sb,
(SELECT * FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''ASSETTYPE'') A1
where 0 = 0
and a.symbol = sb.symbol
and (CASE WHEN SB.TRADEPLACE = ''099'' THEN ''TPRL'' ELSE ''CKNY'' END) = A1.CDVAL(+)
and not exists (
    select f.nvalue
    from tllog tl, tllogfld f
    where tl.txnum = f.txnum
    and tl.txdate = f.txdate
    and tl.tltxcd = ''8802''
    and f.fldcd = ''01''
    and tl.txstatus in(''1'', ''4'')
    and f.nvalue = a.autoid
)', 'OD8894', '', 'IDFILE', '8802', 0, 5000, 'N', 30, 'NNNNYYYNNN', 'N', 'T', '', 'N', '');COMMIT;