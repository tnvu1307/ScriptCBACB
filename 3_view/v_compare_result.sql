SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_COMPARE_RESULT
(ORDERID, NOTE1, NOTEVSBR, NOTE, ISODMAST, 
 CUSTODYCD, TRANSTYPE, SYMBOL, TRADEDATE, TRADEDATECTCK, 
 TRADEDATEVSD, CUSTSETTLEDATE, CMPSETTLEDATE, VSDSETTLEDATE, CMPQTTY, 
 CMPPRICE, VSDQTTY, VSDPRICE, CUSTQTTY, CUSTPRICE, 
 CUSTAMOUNT, CMPAMOUNT, VSDAMOUNT, CMPFEE, CUSTFEE, 
 CMPTAX, CUSTTAX, CUSTMEMBER, CMPMEMBER, VSDMEMBER, 
 STATUS, DESCT, CITAD, IDENTITY, ISODMASTVAL, 
 TXTIME, CMPAMOUNTNET, CUSTAMOUNTNET, VSDAMOUNTNET)
AS 
select "ORDERID","NOTE1","NOTEVSBR","NOTE","ISODMAST","CUSTODYCD","TRANSTYPE","SYMBOL","TRADEDATE","TRADEDATECTCK","TRADEDATEVSD","CUSTSETTLEDATE","CMPSETTLEDATE","VSDSETTLEDATE","CMPQTTY","CMPPRICE","VSDQTTY","VSDPRICE","CUSTQTTY","CUSTPRICE","CUSTAMOUNT","CMPAMOUNT","VSDAMOUNT","CMPFEE","CUSTFEE","CMPTAX","CUSTTAX","CUSTMEMBER","CMPMEMBER","VSDMEMBER","STATUS","DESCT","CITAD","IDENTITY","ISODMASTVAL","TXTIME","CMPAMOUNTNET","CUSTAMOUNTNET","VSDAMOUNTNET"
from(
select cm.orderid,case when nvl(cu.commission_fee_cu,0) = nvl(cm.commission_fee,0)
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
        nvl(round(cu.gross_amount,0),0) custamount,
        nvl(round(cm.gross_amount,0),0) cmpamount,
        nvl(round(vs.gross_amount,0),0) vsdamount,
        to_number(nvl(CM.commission_fee,0)) cmpfee, to_number(nvl(CU.commission_fee_cu,0)) custfee,
        to_number(nvl(CM.TAX,0)) cmptax, to_number(nvl(cu.tax_cu,0)) custtax,
        cu.shortname CUSTMEMBER,fa.shortname CMPMEMBER, vs.shortname vsdmember, 'T' status,
        case when cu.commission_fee_cu <> cm.commission_fee or cu.tax_cu <> cm.tax or cu.trade_date <> cm.trade_date then 'Client Mismatch Broker'
             when cu.quantity <> cm.quantity or cu.quantity <> vs.quantity or cu.broker_code <> vs.broker_code then 'Client and Broker Mismatch VSD'
             else '' end desct,
        'Confirmed' ISODMAST, cu.citad,vs.identity,  'Y'  ISODMASTVAL,cm.txtime,to_number(nvl(cm.net_amount,0)) CMPAMOUNTNET,to_number(nvl(cu.net_amount,0)) CUSTAMOUNTNET,to_number(nvl(vs.net_amount,0)) VSDAMOUNTNET
    from (SELECT * FROM VW_ODMAST_IMPORT WHERE STATUS = '7') OD,
         (SELECT * FROM ODMASTCMP WHERE DELTD <> 'Y' AND TRIM(ISODMAST) = 'Y') CM,
         (SELECT * FROM V_SUM_CLIENT_IMPORT WHERE DELTD <> 'Y') CU,
         (SELECT * FROM V_SUM_VSD_IMPORT WHERE DELTD <> 'Y') VS,
         (SELECT *FROM FAMEMBERS  WHERE ROLES = 'BRK') FA
    WHERE CM.ORDERID = OD.ORDERID
    AND CM.BROKER_CODE= FA.DEPOSITMEMBER

    AND CM.SEC_ID = CU.SEC_ID(+)
    AND CM.CUSTODYCD = CU.CUSTODYCD(+)
    AND CM.TRANS_TYPE = CU.TRANS_TYPE(+)
    AND CM.TRADE_DATE = CU.TRADE_DATE(+)
    AND CM.SETTLE_DATE = CU.SETTLE_DATE(+)
    AND CM.BROKER_CODE = CU.BROKER_CODE(+)
    AND CM.QUANTITY = CU.QUANTITY(+)

    AND CM.SEC_ID = VS.SEC_ID(+)
    AND CM.CUSTODYCD = VS.CUSTODYCD(+)
    AND CM.TRANS_TYPE = VS.TRANS_TYPE(+)
    AND CM.TRADE_DATE = VS.TRADE_DATE(+)
    AND CM.SETTLE_DATE = VS.SETTLE_DATE(+)
    AND CM.BROKER_CODE = VS.BROKER_CODE(+)

)where 0 = 0
/
