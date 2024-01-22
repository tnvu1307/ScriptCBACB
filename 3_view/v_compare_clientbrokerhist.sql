SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_COMPARE_CLIENTBROKERHIST
(NOTE1, NOTE, ISODMAST, CUSTODYCD, TRANSTYPE, 
 SYMBOL, TRADEDATE, TRADEDATECTCK, TRADEDATEVSD, CUSTSETTLEDATE, 
 CMPSETTLEDATE, VSDSETTLEDATE, CMPQTTY, CMPPRICE, VSDQTTY, 
 VSDPRICE, CUSTQTTY, CUSTPRICE, CUSTAMOUNT, CMPAMOUNT, 
 VSDAMOUNT, CMPFEE, CUSTFEE, CMPTAX, CUSTTAX, 
 CUSTMEMBER, CMPMEMBER, VSDMEMBER, STATUS, DESCT, 
 CITAD, IDENTITY, ISODMASTVAL, TXTIME, CMPAMOUNTNET, 
 CUSTAMOUNTNET, VSDAMOUNTNET)
AS 
select "NOTE1","NOTE","ISODMAST","CUSTODYCD","TRANSTYPE","SYMBOL","TRADEDATE","TRADEDATECTCK","TRADEDATEVSD","CUSTSETTLEDATE","CMPSETTLEDATE","VSDSETTLEDATE","CMPQTTY","CMPPRICE","VSDQTTY","VSDPRICE","CUSTQTTY","CUSTPRICE","CUSTAMOUNT","CMPAMOUNT","VSDAMOUNT","CMPFEE","CUSTFEE","CMPTAX","CUSTTAX","CUSTMEMBER","CMPMEMBER","VSDMEMBER","STATUS","DESCT","CITAD","IDENTITY","ISODMASTVAL","TXTIME","CMPAMOUNTNET","CUSTAMOUNTNET","VSDAMOUNTNET"
from(
select case when nvl(cu.commission_fee_cu,0) = nvl(cm.commission_fee_cm,0)
                and nvl(cu.tax_cu,0) = nvl(cm.tax_cm,0)
                and cu.trade_date = cm.trade_date
                and cu.settle_date = cm.settle_date
                and cu.custodycd = cm.custodycd
                and cu.quantity = cm.quantity
                and cu.broker_code  = cm.broker_code
                and cu.gross_amount = cm.gross_amount
                and cu.net_amount = cm.net_amount
                and cu.trans_type = cm.trans_type then 'Matched' else 'Mismatched' end note1,
       'Mismatched' note,
        nvl(cu.custodycd,cm.custodycd)custodycd, nvl(cu.trans_type,cm.trans_type) transtype, nvl(cu.sec_id,cm.sec_id) symbol,
        cu.trade_date tradedate, cm.trade_date tradedatectck,'' tradedatevsd,cu.settle_date custsettledate, cm.settle_date cmpsettledate,'' vsdsettledate,
        to_number(nvl(cm.quantity,0)) cmpqtty, to_number(nvl(round(cm.price,6),0)) cmpprice,
        0 vsdqtty, 0 vsdprice,
        to_number(nvl(cu.quantity,0)) custqtty, to_number(nvl(round(cu.price,6),0)) custprice,
        nvl(round(cu.gross_amount,2),0) custamount,
        nvl(round(cm.gross_amount,2),0) cmpamount,
        0 vsdamount,
        to_number(nvl(cm.commission_fee_cm,0)) cmpfee, to_number(nvl(CU.commission_fee_cu,0)) custfee,
        to_number(nvl(cm.tax_cm,0)) cmptax, to_number(nvl(cu.tax_cu,0)) custtax,
        cu.shortname CUSTMEMBER,cm.shortname CMPMEMBER, '' vsdmember, 'T' status,
        case when cu.commission_fee_cu <> cm.commission_fee_cm or cu.tax_cu <> cm.tax_cm or cu.trade_date <> cm.trade_date then 'Broker Mismatch Client'
             else '' end desct,
        (case when trim(cm.isodmast) = 'Y' OR trim(cu.isodmast) = 'Y' then 'Confirmed' else 'Not confirmed' end )ISODMAST,
        cu.citad,cu.identity,
        (case when trim(cm.isodmast) = 'Y' OR trim(cu.isodmast) = 'Y' then 'Y' else 'N' end )ISODMASTVAL,
        cm.txtime,to_number(nvl(cm.net_amount,0)) CMPAMOUNTNET,to_number(nvl(cu.net_amount,0)) CUSTAMOUNTNET,0 VSDAMOUNTNET
    FROM (SELECT * FROM V_SUM_BROKER_IMPORT WHERE DELTD <> 'Y') CM,
         (SELECT * FROM V_SUM_CLIENT_IMPORT WHERE DELTD <> 'Y') CU,
         (SELECT *FROM FAMEMBERS  WHERE ROLES = 'BRK') FA
    WHERE CU.BROKER_CODE = FA.DEPOSITMEMBER

    AND CU.SEC_ID = CM.SEC_ID(+)
    AND CU.CUSTODYCD = CM.CUSTODYCD(+)
    AND CU.TRANS_TYPE = CM.TRANS_TYPE(+)
    AND CU.TRADE_DATE = CM.TRADE_DATE(+)
    AND CU.SETTLE_DATE = CM.SETTLE_DATE(+)
    AND CU.BROKER_CODE = CM.BROKER_CODE(+)
    AND CU.ISODMAST = CM.ISODMAST(+)
)where 0 = 0
/
