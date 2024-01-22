SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SUM_VSD_IMPORT
(SEC_ID, BROKER_CODE, TRADE_DATE, SETTLE_DATE, TRANS_TYPE, 
 CUSTODYCD, QUANTITY, PRICE, GROSS_AMOUNT, NET_AMOUNT, 
 TXTIME, ISODMAST, DELTD, SHORTNAME, IDENTITY)
AS 
select vs.sec_id, vs.broker_code, vs.trade_date, vs.settle_date, vs.trans_type, vs.custodycd,
       sum(vs.quantity) quantity,
       --round(sum(vs.grossamount)/sum(vs.quantity),6) price,
       round(max(vs.price),6) price,
       sum(vs.grossamount) gross_amount,
       sum(vs.net_amount) net_amount,
       max(vs.txtime) txtime,
       vs.isodmast,
       vs.deltd,
       fa.shortname,
       vs.identity
from odmastvsd vs,famembers fa
where deltd <> 'Y'
and vs.broker_code = fa.depositmember
and fa.roles = 'BRK' --and vs.isodmast <> 'Y'
group by vs.broker_code,vs.trade_date,vs.trans_type,vs.custodycd,vs.sec_id,vs.settle_date,vs.isodmast,vs.deltd,fa.shortname,vs.identity
/
