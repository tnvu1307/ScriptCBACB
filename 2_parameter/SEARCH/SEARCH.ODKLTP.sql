SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ODKLTP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ODKLTP', 'Danh sách khớp lệnh trái phiếu', 'List of bond trading', '
select * from
(
    select od.txdate, od.txtime, od.orderid, cf.custodycd, af.acctno, cf.fullname, sb.codeid, sb.symbol, od.exectype, a0.cdcontent pexectype,
        od.reforderid, iod.matchqtty, iod.matchprice, iod.matchprice*iod.matchqtty matchamt, iod.iodfeeacr,
        iod.iodtaxsellamt, od.clearday, getnextbusinessdate(od.txdate,od.clearday) cleardate,
        case when sb.tradeplace=''010'' then ''TP kho bạc'' else ''TP thông thường'' end btype
    from vw_odmast_all od, afmast af, cfmast cf, sbsecurities sb, vw_iod_all iod, allcode a0
    where od.afacctno=af.acctno
        and af.custid=cf.custid
        and od.codeid=sb.codeid
        and iod.orgorderid=od.orderid
        and iod.deltd = ''N''
        and od.deltd = ''N''
        and od.matchtype=''P''
        and a0.cdname=''EXECTYPE'' and a0.cdtype=''OD'' and a0.cdval=od.exectype
        and sb.sectype in (''006'',''222'',''003'',''444'')
        and not EXISTS (select * from TBL_ODREPO t where t.orderid=od.orderid or t.ref_orderid=od.orderid)
        order BY od.txdate desc, cf.custodycd asc, af.acctno asc, od.txtime asc
)
where 0=0
    ', 'OD.ODMAST', 'frmODMAST', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;