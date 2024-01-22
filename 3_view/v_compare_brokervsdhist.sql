SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_COMPARE_BROKERVSDHIST
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
select case when vs.broker_code = cm.broker_code
                and nvl(vs.quantity,0) = nvl(cm.quantity,0)
                and vs.gross_amount = cm.gross_amount
                and vs.custodycd = cm.custodycd
                and vs.trans_type = cm.trans_type
                and vs.settle_date = cm.settle_date
                 then 'Matched' else 'Mismatched' end note1,
        case when vs.broker_code = cm.broker_code
                and nvl(vs.quantity,0) = nvl(cm.quantity,0)
                and vs.gross_amount = cm.gross_amount
                and vs.custodycd = cm.custodycd
                and vs.trans_type = cm.trans_type
                and vs.settle_date = cm.settle_date
                 then 'Matched' else 'Mismatched' end  note,
        nvl(vs.custodycd,cm.custodycd)custodycd, nvl(vs.trans_type,cm.trans_type) transtype, nvl(vs.sec_id,cm.sec_id) symbol,
        '' tradedate, cm.trade_date tradedatectck,vs.trade_date tradedatevsd,'' custsettledate, cm.settle_date cmpsettledate,vs.settle_date vsdsettledate,
        to_number(nvl(cm.quantity,0)) cmpqtty, to_number(nvl(round(cm.price,6),0)) cmpprice,
        to_number(nvl(vs.quantity,0)) vsdqtty, to_number(nvl(round(vs.price,6),0)) vsdprice,
        0 custqtty, 0 custprice,0 custamount,
        nvl(round(cm.gross_amount,2),0) cmpamount,
        nvl(round(vs.gross_amount,2),0) vsdamount,
        to_number(nvl(CM.commission_fee,0)) cmpfee, 0 custfee,
        to_number(nvl(CM.TAX,0)) cmptax, 0 custtax,
        '' CUSTMEMBER,cm.shortname CMPMEMBER, vs.shortname vsdmember, 'T' status,
        case  when  cm.quantity <> vs.quantity or cm.broker_code <> vs.broker_code then 'Broker  Mismatch VSD'
             else '' end desct,
        (case when trim(cm.isodmast) = 'Y' OR trim(cu.isodmast) = 'Y' or trim(vs.isodmast) = 'Y' then 'Confirmed' else 'Not confirmed' end )ISODMAST,
        '' citad,vs.identity,
        (case when trim(cm.isodmast) = 'Y' OR trim(cu.isodmast) = 'Y' or trim(vs.isodmast) = 'Y' then 'Y' else 'N' end )ISODMASTVAL,
        vs.txtime,to_number(nvl(cm.net_amount,0)) CMPAMOUNTNET,0 CUSTAMOUNTNET,to_number(nvl(vs.net_amount,0)) VSDAMOUNTNET
    FROM (SELECT * FROM V_SUM_BROKER_IMPORT_M WHERE DELTD <> 'Y') CM,
         (SELECT * FROM V_SUM_CLIENT_IMPORT_M WHERE DELTD <> 'Y') CU,
         (SELECT * FROM V_SUM_VSD_IMPORT WHERE DELTD <> 'Y') VS,
         (SELECT *FROM FAMEMBERS  WHERE ROLES = 'BRK') FA
    WHERE CM.BROKER_CODE= FA.DEPOSITMEMBER

    AND CM.SEC_ID = CU.SEC_ID(+)
    AND CM.CUSTODYCD = CU.CUSTODYCD(+)
    AND CM.TRANS_TYPE = CU.TRANS_TYPE(+)
    AND CM.TRADE_DATE = CU.TRADE_DATE(+)
    AND CM.SETTLE_DATE = CU.SETTLE_DATE(+)
    AND CM.BROKER_CODE = CU.BROKER_CODE(+)
    AND CM.QUANTITY = CU.QUANTITY(+)
    AND CM.ISODMAST = CU.ISODMAST(+)

    AND CM.SEC_ID = VS.SEC_ID(+)
    AND CM.CUSTODYCD = VS.CUSTODYCD(+)
    AND CM.TRANS_TYPE = VS.TRANS_TYPE(+)
    AND CM.TRADE_DATE = VS.TRADE_DATE(+)
    AND CM.SETTLE_DATE = VS.SETTLE_DATE(+)
    AND CM.BROKER_CODE = VS.BROKER_CODE(+)
    AND CM.ISODMAST = VS.ISODMAST(+)
)where 0 = 0
/
