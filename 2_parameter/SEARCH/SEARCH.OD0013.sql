SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0013','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0013', 'Danh sách chờ nhận/giao chứng khoán cơ cấu', 'List of waiting receipt/ delivery component securities', 'select eq.txdate ,OD.ORDERID txnum,od.custodycd,cf.fullname,eq.qt QTTYCKCC,od.codeid ETFID ,od.symbol ETFIDMA,iss.<@CDCONTENT> ETFNAME,A1.<@CDCONTENT> type,od.execqtty ETFQTTY ,od.nav NAV ,
        od.execamt AMOUNT,od.orderid ORDERID,od.exectype
    from  odmast od,cfmast cf,sbsecurities sb,allcode A1 ,(SELECT ISSUERID,fullname CDCONTENT,en_fullname EN_CDCONTENT FROM ISSUERS ISS ) ISS,
        (
            select txdate,txnum,orderid,status,sum(qtty) qt
            from etfwsap
                group by txdate,txnum,orderid,status
        )eq
        where   od.custodycd = cf.custodycd

            and eq.status = ''P''
            and sb.codeid = od.codeid
            and A1.cdval = od.exectype and A1.cdname = ''TYPEETF''
            and eq.orderid = od.orderid
            and SB.ISSUERID = ISS.ISSUERID
            and not exists ( select f.cvalue from
                                    tllog tl, tllogfld f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = ''8896'' and f.fldcd
                                    = ''22'' and tl.txstatus in(''1'', ''4'') and f.cvalue = eq.orderid)', 'OD0013', 'frmODMAST', 'TXNUM DESC', '8896', NULL, 5000, 'N', 30, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;