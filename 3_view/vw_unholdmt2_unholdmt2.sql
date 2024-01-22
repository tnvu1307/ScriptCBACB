SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_UNHOLDMT2_UNHOLDMT2
(CUSTODYCD, REFTXNUM, TRADEDATE, SETTLE_DATE, SECACCOUNT, 
 DDACCTNO, CUSTNAME, ORDERID, REFCASAACCT, BALANCE, 
 HOLDBALANCE, MEMBERID, BRNAME, BRPHONE, CCYCD, 
 AMOUNT, NOTE)
AS 
SELECT DD.CUSTODYCD,crb.objkey REFTXNUM,od.trade_date TRADEDATE,OD.cleardate SETTLE_DATE ,DD.AFACCTNO SECACCOUNT,DD.ACCTNO DDACCTNO,CF.FULLNAME CUSTNAME,OD.ORDERID,
        DD.REFCASAACCT REFCASAACCT,DD.BALANCE,DD.HOLDBALANCE,vmb.value MEMBERID,'' BRNAME,'' BRPHONE,crb.currency CCYCD,CRB.TXAMT AMOUNT,'' NOTE
    from crbtxreq crb,ddmast dd,cfmast cf,odmast od,sbsecurities sb,VW_CUSTODYCD_MEMBER vmb,
        (select varvalue  from sysvar where varname = 'DEALINGCUSTODYCD')sys
    where   crb.objname = '6690'
        and crb.reqcode = 'HOLDOD'
        --vw_custodycd_member
        and vmb.filtercd = dd.custodycd and vmb.value = od.member
        and dd.acctno = crb.afacctno
        and dd.custodycd = cf.custodycd
        and od.orderid = crb.reqtxnum
        and od.codeid = sb.codeid
        and sb.bondtype <> '001'
        and crb.unhold = 'N'
        and crb.status = 'C'
        and od.cleardate = getcurrdate
        and SUBSTR(od.custodycd,0,4) not like sys.varvalue
/
