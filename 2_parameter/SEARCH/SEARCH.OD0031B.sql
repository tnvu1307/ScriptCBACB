SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0031B','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0031B', 'Nhận TPCP mua', 'Receive Government bonds', 'SELECT OD.ORDERID,OD.TXNUM,DD.ACCTNO DDACCTNO,OD.SYMBOL,OD.CODEID,CF.CUSTODYCD,CF.FULLNAME,OD.NETAMOUNT AMOUNT,OD.IDENTITY ,CRB.BANKNAME,OD.CITAD,''SE''TYPE,OD.SEACCTNO,OD.EXECQTTY QTTY
        from odmast od,ddmast dd,cfmast cf,crbbanklist crb,sbsecurities sb
        where   od.ddacctno = dd.acctno
            and dd.status <> ''C'' and dd.isdefault = ''Y''
            and od.custid = cf.custid
            and od.citad = crb.citad
            and od.codeid = sb.codeid
            and sb.bondtype = ''001''
            and od.exectype = ''NB''
            --and od.cleardate = getcurrdate
            --AND OD.ORSTATUS NOT IN (''5'',''7'')
            and not exists ( select f1.cvalue from
                                    tllog tl, tllogfld f1 where tl.txnum = f1.txnum and
                                    tl.txdate = f1.txdate and tl.tltxcd = ''8849'' and f1.fldcd
                                    in(''12'') and tl.txstatus in(''1'', ''4'') and f1.cvalue = od.IDENTITY )', 'OD.ODMAST', 'frmODMAST', '', '8849', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;