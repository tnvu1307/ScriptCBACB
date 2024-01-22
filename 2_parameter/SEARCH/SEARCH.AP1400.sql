SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AP1400','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AP1400', 'Tra Cứu Lệnh Bán Physical 1400', 'View 1400 Sell Physical', 'SELECT crs.crphysagreeid,cr.no crphysagreeno ,crs.txdate,crs.txnum,app.autoid APPENDIXID,app.name APPENDIXNAME,app.EFFDATE,cr.symbol,cf.CIFID,cf.custodycd,crs.buycustodycd CUSTODYCDBUY,
        crs.fullname FULLNAME,(CR.QTTY-CR.REQTTY) AVQTTY,crs.qtty SELLQTTY,crs.AMT AMTSELL,crs.TAX,a1.<@CDCONTENT> TAXABLEPARTY,crs.NETAMT,crs.selldate SETTLEDATE,
        (case when APP.STATUS =''R'' then A2.<@CDCONTENT> ELSE A3.<@CDCONTENT> END )PAYSTATUS,
        (case when APP.STATUS =''R'' then A2.CDVAL ELSE A3.CDVAL END )PAYSTATUSVAL,
        (case when sell_1403.type = ''W'' then A2.<@CDCONTENT> ELSE A3.<@CDCONTENT> END) BALANCESTATUS,
        (case when sell_1403.type = ''W'' then A2.CDVAL ELSE A3.CDVAL END) BALANCESTATUSVAL
    from crphysagree cr, crphysagree_sell_log crs, (SELECT *FROM APPENDIX WHERE DELTD <> ''Y'') app,cfmast cf,(select *from allcode where cdname = ''YESNO'' AND CDVAL =''Y'') A2,
            (select *from allcode where cdname = ''YESNO'' AND CDVAL =''N'') A3,
            (select *from allcode where cdname = ''TAXABLEPARTY'') a1,
            (select * from CRPHYSAGREE_LOG  where TYPE = ''W'') sell_1403
    where   cr.crphysagreeid = crs.CRPHYSAGREEID
        and cr.CRPHYSAGREEID= app.CRPHYSAGREEID(+)
        and cr.acctno = cf.custid 
        and app.taxableparty = a1.cdval
        --and app.status =''P'' and app.autoid = sell_1403.appendixid(+)
        and crs.status =''P''
        and app.txdate = crs.txdate
        and app.txnum = crs.txnum
        and cr.crphysagreeid = sell_1403.crphysagreeid(+)', 'CRPHYSAGREE', '', 'SETTLEDATE desc', '1444', 0, 5000, 'N', 1, 'NNNNYNYNNNN', 'Y', 'T', '', 'N', '');COMMIT;