SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SUM_CLIENT_IMPORT_M
(SEC_ID, BROKER_CODE, TRADE_DATE, SETTLE_DATE, TRANS_TYPE, 
 CUSTODYCD, ISODMAST, CITAD, IDENTITY, QUANTITY, 
 PRICE, COMMISSION_FEE_CU, TAX_CU, GROSS_AMOUNT, NET_AMOUNT, 
 TXTIME, DELTD, SHORTNAME)
AS 
select vw.sec_id,vw.broker_code,vw.trade_date,vw.settle_date,vw.trans_type,max(vw.mcustodycd) custodycd,max(vw.isodmast) isodmast,max(vw.citad) citad ,max(vw.identity) identity,
        sum(nvl(vw.quantity,0)) quantity,
        round(max(vw.price),6) price,
        sum(nvl(vw.commission_fee_cu,0)) commission_fee_cu,
        sum(nvl(vw.tax_cu,0)) tax_cu,
        sum(nvl(vw.gross_amount,0)) gross_amount,
        sum(nvl(vw.net_amount,0)) net_amount,max(vw.txtime)txtime,max(vw.deltd) deltd,max(vw.shortname) shortname
    From v_sum_client_import vw, cfmast cf 
    where   vw.mcustodycd = cf.custodycd
    group by vw.mcustodycd,vw.broker_code,vw.trade_date,vw.trans_type,vw.sec_id,vw.settle_date
/
