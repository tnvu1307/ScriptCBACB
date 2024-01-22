SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_COMPARE_IMPORTHIST
(NOTE1, NOTEVSBR, NOTE, ISODMAST, CUSTODYCD, 
 TRANSTYPE, SYMBOL, TRADEDATE, TRADEDATECTCK, TRADEDATEVSD, 
 CUSTSETTLEDATE, CMPSETTLEDATE, VSDSETTLEDATE, CMPQTTY, CMPPRICE, 
 VSDQTTY, VSDPRICE, CUSTQTTY, CUSTPRICE, CUSTAMOUNT, 
 CMPAMOUNT, VSDAMOUNT, CMPFEE, CUSTFEE, CMPTAX, 
 CUSTTAX, CUSTMEMBER, CMPMEMBER, VSDMEMBER, STATUS, 
 DESCT, CITAD, IDENTITY, ISODMASTVAL, TXTIME, 
 CMPAMOUNTNET, CUSTAMOUNTNET, VSDAMOUNTNET)
AS 
select "NOTE1","NOTEVSBR","NOTE","ISODMAST","CUSTODYCD","TRANSTYPE","SYMBOL","TRADEDATE","TRADEDATECTCK","TRADEDATEVSD","CUSTSETTLEDATE","CMPSETTLEDATE","VSDSETTLEDATE","CMPQTTY","CMPPRICE","VSDQTTY","VSDPRICE","CUSTQTTY","CUSTPRICE","CUSTAMOUNT","CMPAMOUNT","VSDAMOUNT","CMPFEE","CUSTFEE","CMPTAX","CUSTTAX","CUSTMEMBER","CMPMEMBER","VSDMEMBER","STATUS","DESCT","CITAD","IDENTITY","ISODMASTVAL","TXTIME","CMPAMOUNTNET","CUSTAMOUNTNET","VSDAMOUNTNET"
from(
select case when nvl(cu.commission_fee_cu,0) = nvl(cm.commission_fee,0)
                and nvl(cu.tax_cu,0) = nvl(cm.tax,0)
                and cu.trade_date = cm.trade_date
                and cu.settle_date = cm.settle_date
                and cu.custodycd = cm.custodycd
                and cu.quantity = cm.quantity
                and cu.broker_code  = cm.broker_code
                and cu.gross_amount = cm.gross_amount
                and cu.net_amount = cm.net_amount
                and cu.trans_type = cm.trans_type then 'Matched' else 'Mismatched' end note1,
        case when cm.broker_code = vs.broker_code
                and nvl(cm.quantity,0) = nvl(vs.quantity,0)
                and cm.gross_amount = vs.gross_amount
                and cm.custodycd = vs.custodycd
                and cm.trans_type = vs.trans_type
                and cm.settle_date = vs.settle_date
            then 'Matched' else 'Mismatched' end notevsbr,
        case when cu.broker_code = cm.broker_code and cu.broker_code = vs.broker_code
                and nvl(cu.quantity,0) = nvl(cm.quantity,0) and nvl(cu.quantity,0) = nvl(vs.quantity,0)
                --and nvl(cu.price,0) = nvl(cm.price,0) and nvl(cu.price,0) = nvl(vs.price,0)
                and cu.gross_amount = cm.gross_amount and cm.gross_amount = vs.gross_amount
                and cu.custodycd = vs.custodycd and cm.custodycd = vs.custodycd
                and cu.trans_type = cm.trans_type and cu.trans_type = vs.trans_type
                and cm.settle_date = cu.settle_date and cm.settle_date = vs.settle_date
            then 'Matched' else 'Mismatched' end note,
        nvl(cu.custodycd,cm.custodycd)custodycd, nvl(cu.trans_type,cm.trans_type) transtype, nvl(cu.sec_id,cm.sec_id) symbol,
        cu.trade_date tradedate, cm.trade_date tradedatectck,vs.trade_date tradedatevsd,cu.settle_date custsettledate, cm.settle_date cmpsettledate,vs.settle_date vsdsettledate,
        to_number(nvl(cm.quantity,0)) cmpqtty, to_number(nvl(round(cm.price,6),0)) cmpprice,
        to_number(nvl(vs.quantity,0)) vsdqtty, to_number(nvl(round(vs.price,6),0)) vsdprice,
        to_number(nvl(cu.quantity,0)) custqtty, to_number(nvl(round(cu.price,6),0)) custprice,
        nvl(round(cu.gross_amount,2),0) custamount,
        nvl(round(cm.gross_amount,2),0) cmpamount,
        nvl(round(vs.gross_amount,2),0) vsdamount,
        to_number(nvl(CM.commission_fee,0)) cmpfee, to_number(nvl(CU.commission_fee_cu,0)) custfee,
        to_number(nvl(CM.TAX,0)) cmptax, to_number(nvl(cu.tax_cu,0)) custtax,
        cu.shortname CUSTMEMBER,fa.shortname CMPMEMBER, vs.shortname vsdmember, 'T' status,
        case when cu.commission_fee_cu <> cm.commission_fee or cu.tax_cu <> cm.tax or cu.trade_date <> cm.trade_date then 'Client Mismatch Broker'
             when cu.quantity <> cm.quantity or cu.quantity <> vs.quantity or cu.broker_code <> vs.broker_code then 'Client and Broker Mismatch VSD'
             else '' end desct,
        (case when cm.isodmast = 'Y' AND cu.isodmast = 'Y' then 'Confirmed' else 'Not confirmed' end )ISODMAST,
        cu.citad,vs.identity,
        (case when cm.isodmast = 'Y' AND cu.isodmast = 'Y' then 'Y' else 'N' end )ISODMASTVAL,cm.txtime,to_number(nvl(cm.net_amount,0)) CMPAMOUNTNET,to_number(nvl(cu.net_amount,0)) CUSTAMOUNTNET,to_number(nvl(vs.net_amount,0)) VSDAMOUNTNET
    from  odmastcmp cm
        left  join
            v_sum_client_import cu
            on  cu.sec_id = cm.sec_id and cu.custodycd = cm.custodycd and cu.trans_type = cm.trans_type and cm.trade_date = cu.trade_date and cu.isodmast <> 'Y' and cm.broker_code = cu.broker_code
        left join
            v_sum_vsd_import vs
            on  vs.sec_id = cm.sec_id and vs.custodycd = cm.custodycd and vs.trans_type = cm.trans_type and cm.trade_date = vs.trade_date and vs.isodmast <> 'Y' and cm.broker_code = vs.broker_code
        ,(select *from FAMEMBERS  where roles ='BRK') FA
    where   cm.deltd <> 'Y'
        and cm.isodmast <> 'Y'
        and cm.broker_code= fa.depositmember
union all -- da sinh odmast
select  case when nvl(cu.commission_fee_cu,0) = nvl(cm.commission_fee,0)
                and nvl(cu.tax_cu,0) = nvl(cm.tax,0)
                and cu.trade_date = cm.trade_date
                and cu.settle_date = cm.settle_date
                and cu.custodycd = cm.custodycd
                and cu.quantity = cm.quantity
                and cu.broker_code  = cm.broker_code
                and cu.gross_amount = cm.gross_amount
                and cu.net_amount = cm.net_amount
                and cu.trans_type = cm.trans_type then 'Matched' else 'Mismatched' end note1,
        case when cm.broker_code = vs.broker_code
                and nvl(cm.quantity,0) = nvl(vs.quantity,0)
                and cm.gross_amount = vs.gross_amount
                and cm.custodycd = vs.custodycd
                and cm.trans_type = vs.trans_type
                and cm.settle_date = vs.settle_date
            then 'Matched' else 'Mismatched' end notevsbr,
        case when cu.broker_code = cm.broker_code and cu.broker_code = vs.broker_code
                and nvl(cu.quantity,0) = nvl(cm.quantity,0) and nvl(cu.quantity,0) = nvl(vs.quantity,0)
                and cu.gross_amount = cm.gross_amount and cm.gross_amount = vs.gross_amount
                and cu.custodycd = vs.custodycd and cm.custodycd = vs.custodycd
                and cu.trans_type = cm.trans_type and cu.trans_type = vs.trans_type
                and cm.settle_date = cu.settle_date and cm.settle_date = vs.settle_date
            then 'Matched' else 'Mismatched' end note,
        nvl(cu.custodycd,cm.custodycd)custodycd, nvl(cu.trans_type,cm.trans_type) transtype, nvl(cu.sec_id,cm.sec_id) symbol,
        cu.trade_date tradedate, cm.trade_date tradedatectck,vs.trade_date tradedatevsd,cu.settle_date custsettledate, cm.settle_date cmpsettledate,vs.settle_date vsdsettledate,
        to_number(nvl(cm.quantity,0)) cmpqtty, to_number(nvl(cm.price,6)) cmpprice,
        to_number(nvl(vs.quantity,0)) vsdqtty, to_number(nvl(vs.price  ,6)) vsdprice,
        to_number(nvl(cu.quantity,0)) custqtty, to_number(nvl(cu.price,6)) custprice,
        nvl(round(cu.gross_amount,2),0) custamount,
        nvl(round(cm.gross_amount,2),0) cmpamount,
        nvl(round(vs.gross_amount,2),0) vsdamount,
        to_number(nvl(CM.commission_fee,0)) cmpfee, to_number(nvl(CU.commission_fee_cu,0)) custfee,
        to_number(nvl(CM.TAX,0)) cmptax, to_number(nvl(cu.tax_cu,0)) custtax,
        cu.shortname CUSTMEMBER,fa.shortname CMPMEMBER, vs.shortname vsdmember, 'T' status,
        case when cu.commission_fee_cu <> cm.commission_fee or cu.tax_cu <> cm.tax or cu.trade_date <> cm.trade_date then 'Client Mismatch Broker'
             when cu.quantity <> cm.quantity or cu.quantity <> vs.quantity or cu.broker_code <> vs.broker_code then 'Client and Broker Mismatch VSD'
             else '' end desct,
        'Confirmed' ISODMAST,
        cu.citad,vs.identity,
        'Y' ISODMASTVAL,cm.txtime,to_number(nvl(cm.net_amount,0)) CMPAMOUNTNET,to_number(nvl(cu.net_amount,0)) CUSTAMOUNTNET,to_number(nvl(vs.net_amount,0)) VSDAMOUNTNET
    from  odmastcmp cm
        left  join
            v_sum_client_import cu
            on cu.broker_code = cm.broker_code and cu.sec_id = cm.sec_id and cu.custodycd = cm.custodycd and cu.trans_type = cm.trans_type and cm.trade_date = cu.trade_date and cm.broker_code = cu.broker_code
        left join
            v_sum_vsd_import vs
            on vs.broker_code = cm.broker_code and vs.sec_id = cm.sec_id and vs.custodycd = cm.custodycd and vs.trans_type = cm.trans_type and cm.trade_date = vs.trade_date and cm.broker_code = vs.broker_code
        ,FAMEMBERS FA
    where   cm.deltd <> 'Y'
        and fa.roles ='BRK'
        and cm.isodmast = 'Y'
        and fa.depositmember = cm.broker_code
)where 0 = 0
/
