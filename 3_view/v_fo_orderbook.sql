SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_FO_ORDERBOOK
(ORDERID, REFORDERID, TXDATE, AFACCTNO, DF_SE_CODE, 
 EXECTYPE, QUOTEPRICE, ORDERQTTY, FULLNAME, FEEACR, 
 DF_SE_FLOOR_CODE, CUSTODYCD, VIA, TXTIME, MATCHQTTY, 
 MATCHPRICE, EXECAMT, CONFIRM_NO)
AS 
select o.orderid,o.orderid reforderid,o.txdate,o.afacctno, i.symbol df_se_code, o.exectype, O.orderprice  quoteprice, o.orderqtty, c.fullname, o.feeacr, sb.tradeplace df_se_floor_code,
c.custodycd, o.via, o.txtime, i.execqtty matchqtty, i.execprice matchprice, I.execamt execamt, i.confirm_no
from
   odmast o,
   iod i,
   cfmast c,
   sbsecurities sb
where o.orderid =i.orderid(+)
and i.custodycd =c.custodycd
and o.codeid =sb.codeid
/
