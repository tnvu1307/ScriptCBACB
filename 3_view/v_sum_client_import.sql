SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SUM_CLIENT_IMPORT
(SEC_ID, BROKER_CODE, TRADE_DATE, SETTLE_DATE, TRANS_TYPE, 
 CUSTODYCD, ISODMAST, CITAD, IDENTITY, QUANTITY, 
 PRICE, COMMISSION_FEE_CU, TAX_CU, GROSS_AMOUNT, NET_AMOUNT, 
 TXTIME, DELTD, SHORTNAME, MCUSTODYCD, CUSTID)
AS 
select c.sec_id,c.broker_code,c.trade_date,c.settle_date,c.trans_type,c.custodycd,c.isodmast, c.citad,c.identity,
        sum(nvl(c.quantity,0)) quantity,
        round(sum(c.price * c.quantity)/sum(c.quantity),6) price,
        sum(nvl(c.commission_fee,0)) commission_fee_cu,
        sum(nvl(c.tax,0)) tax_cu,
        sum(nvl(c.gross_amount,0)) gross_amount,
        sum(nvl(c.net_amount,0)) net_amount,max(c.txtime),c.deltd,fa.shortname,nvl(max(cf.mcustodycd),c.custodycd)mcustodycd,max(cf.custid) custid
    from odmastcust c, famembers fa,cfmast cf
    where   c.deltd <> 'Y'
        and c.broker_code = fa.depositmember
        and c.custodycd = cf.custodycd
        and fa.roles = 'BRK'
    group by c.broker_code,c.trade_date,c.trans_type,c.custodycd,c.sec_id,c.settle_date,c.isodmast,c.citad,c.identity,c.deltd,fa.shortname
/
