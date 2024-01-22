SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SUM_BROKER_M
(SEC_ID, BROKER_CODE, TRADE_DATE, SETTLE_DATE, TRANS_TYPE, 
 CUSTODYCD, ISODMAST, CITAD, IDENTITY, QUANTITY, 
 PRICE, COMMISSION_FEE, TAX, GROSS_AMOUNT, NET_AMOUNT, 
 TXTIME, DELTD, SHORTNAME, MCUSTODYCD, CUSTID)
AS 
select c.sec_id,c.broker_code,c.trade_date,c.settle_date,c.trans_type,c.custodycd,c.isodmast, c.citad,c.identity,
        c.quantity,
        c.price ,
        c.commission_fee,
        c.tax,
        c.gross_amount,
        c.net_amount,max(c.txtime),c.deltd,fa.shortname,nvl(max(cf.mcustodycd),c.custodycd)mcustodycd,max(cf.custid)custid
    from odmastcmp c, famembers fa,cfmast cf
    where   c.deltd <> 'Y'
        and c.broker_code = fa.depositmember
        and c.custodycd = cf.custodycd
        and fa.roles = 'BRK'
    group by c.broker_code,c.trade_date,c.trans_type,c.custodycd,c.sec_id,c.settle_date,c.isodmast,c.citad,c.identity,c.deltd,fa.shortname,c.quantity,c.price,c.commission_fee,c.tax,c.gross_amount,
            c.net_amount
/
