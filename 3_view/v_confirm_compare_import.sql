SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CONFIRM_COMPARE_IMPORT
(CODEID, BONDTYPE, SYMBOL, ACCTNO, CUSTID, 
 DDACCTNO, SEACCTNO, CUSTODYCD, EXECTYPE, CITAD, 
 IDENTITY, TRADE_DATE, SETTLE_DATE, PRICE, QUANTITY, 
 FEE, TAX, AUTOID)
AS 
select  sb.codeid,sb.bondtype,sb.symbol,af.acctno,cf.custid, dd.acctno ddacctno , af.acctno ||sb.codeid seacctno , cf.custodycd,
        cu.trans_type exectype,cu.citad,cu.identity,cu.trade_date,cu.settle_date settle_date,cm.price price, cm.quantity quantity,
        nvl(cu.commission_fee_cu,0) fee, nvl(cu.tax_cu,0) tax, fa.autoid
        from cfmast cf, afmast af, ddmast dd,
            v_sum_client_import cu, -- Lenh tu KH
            odmastcmp cm,           -- Lenh tu Broker/Cty Ck
            v_sum_vsd_import vs,     -- Lenh tu VSD
            sbsecurities sb,famembers fa
        where   (cu.commission_fee_cu = cm.commission_fee and cu.tax_cu = cm.tax and cu.trade_date = cm.trade_date
                   and cu.custodycd = cm.custodycd and cu.trans_type =cm.trans_type
                   or cu.broker_code = cm.broker_code and cu.broker_code = vs.broker_code
                    and cu.quantity = cm.quantity and cu.quantity = vs.quantity
                    and cu.custodycd = vs.custodycd and cm.custodycd = vs.custodycd and cu.trans_type = cm.trans_type and cu.trans_type = vs.trans_type)
                and cu.custodycd =cf.custodycd
                and cu.custodycd = dd.custodycd and dd.isdefault = 'Y' and dd.status <> 'C' and dd.ccycd = 'VND'
                and af.custid = cf.custid
                and cu.sec_id = sb.symbol
                and fa.depositmember = cu.broker_code
                and cu.isodmast = 'N'
                and cm.deltd <> 'Y'
                and cu.broker_code = vs.broker_code(+)
                and cm.broker_code = vs.broker_code(+)
/
