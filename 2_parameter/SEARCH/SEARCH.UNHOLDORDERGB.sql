SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('UNHOLDORDERGB','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('UNHOLDORDERGB', 'Unhold số tiền phong tỏa lệnh mua G-Bond', 'Unhold  buy order G-Bond', 'SELECT DD.CUSTODYCD,crb.objkey REFTXNUM ,od.trade_date TRADEDATE,OD.cleardate SETTLE_DATE,DD.AFACCTNO SECACCOUNT,DD.ACCTNO DDACCTNO,CF.FULLNAME CUSTNAME,OD.ORDERID,
        DD.REFCASAACCT REFCASAACCT,DD.BALANCE,DD.HOLDBALANCE,vmb.value MEMBERID,'''' BRNAME,'''' BRPHONE,crb.currency CCYCD,CRB.TXAMT AMOUNT,'''' NOTE
    from crbtxreq crb,ddmast dd,cfmast cf,odmast od,sbsecurities sb,VW_CUSTODYCD_MEMBER vmb,
            (select varvalue  from sysvar where varname = ''DEALINGCUSTODYCD'')sys
    where   crb.objname = ''6690''
        and crb.reqcode = ''HOLDOD''
        --vw_custodycd_member
        and vmb.filtercd = dd.custodycd and vmb.value = od.member
        and dd.acctno = crb.afacctno
        and dd.custodycd = cf.custodycd
        and od.orderid = crb.reqtxnum
        and od.codeid = sb.codeid
        and sb.bondtype = ''001''
        and crb.unhold = ''N''
        and SUBSTR(od.custodycd,0,4) not like sys.varvalue
        and crb.status = ''C''
        and NOT EXISTS ( SELECT F.CVALUE FROM
                                    TLLOG TL, TLLOGFLD F WHERE TL.TXNUM = F.TXNUM AND
                                    TL.TXDATE = F.TXDATE AND TL.TLTXCD = ''6623'' AND F.FLDCD
                                    = ''95'' AND TL.TXSTATUS IN(''1'', ''4'') AND F.CVALUE =  OD.ORDERID)', 'UNHOLDORDERGB', '', '', '6623', NULL, 5000, 'N', 30, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;