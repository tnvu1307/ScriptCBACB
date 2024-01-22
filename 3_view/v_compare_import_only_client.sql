SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_COMPARE_IMPORT_ONLY_CLIENT
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
select  /*case when nvl(cu.commission_fee_cu,0) = nvl(cm.commission_fee,0)
                and nvl(cu.tax_cu,0) = nvl(cm.tax,0)
                and cu.trade_date = cm.trade_date
                and cu.settle_date = cm.settle_date
                and cu.custodycd = cm.custodycd
                and cu.quantity = cm.quantity
                and cu.broker_code  = cm.broker_code
                and cu.gross_amount = cm.gross_amount
                and cu.net_amount = cm.net_amount
                and cu.trans_type = cm.trans_type then 'Matched' else 'Mismatched' end */ 'Matched' note1,
        case when nvl(cu.commission_fee_cu,0) = nvl(cm.commission_fee,0)
                and nvl(cu.tax_cu,0) = nvl(cm.tax,0)
                and cu.trade_date = cm.trade_date
                and cu.settle_date = cm.settle_date
                and cu.custodycd = cm.custodycd
                and cu.quantity = cm.quantity
                and cu.broker_code  = cm.broker_code
                and cu.gross_amount = cm.gross_amount
                and cu.net_amount = cm.net_amount
                and cu.trans_type = cm.trans_type   then 'Matched' else 'Mismatched' end notevsbr,
        case when cu.broker_code = vs.broker_code
                and nvl(cu.quantity,0) = nvl(vs.quantity,0)
                and cu.gross_amount = vs.gross_amount
                and cu.custodycd = vs.custodycd
                and cu.trans_type = vs.trans_type
                and cu.settle_date = vs.settle_date then 'Matched' else 'Mismatched' end note,
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
        (case when trim(cm.isodmast) = 'Y' OR trim(cu.isodmast) = 'Y' or trim(vs.isodmast) = 'Y' then 'Confirmed' else 'Not confirmed' end )ISODMAST,
        cu.citad,vs.identity,
        (case when trim(cm.isodmast) = 'Y' OR trim(cu.isodmast) = 'Y' or trim(vs.isodmast) = 'Y' then 'Y' else 'N' end )ISODMASTVAL,
        cm.txtime,to_number(nvl(cm.net_amount,0)) CMPAMOUNTNET,to_number(nvl(cu.net_amount,0)) CUSTAMOUNTNET,to_number(nvl(vs.net_amount,0)) VSDAMOUNTNET
    from (SELECT * FROM V_SUM_CLIENT_IMPORT_M WHERE DELTD <> 'Y') CU,
         (SELECT * FROM V_SUM_BROKER_IMPORT_M WHERE DELTD <> 'Y') CM,
         (SELECT * FROM V_SUM_VSD_IMPORT WHERE DELTD <> 'Y') VS,
         (SELECT *FROM FAMEMBERS  WHERE ROLES = 'BRK') FA
    WHERE CU.BROKER_CODE= FA.DEPOSITMEMBER

    AND CU.SEC_ID = CM.SEC_ID(+)
    AND CU.CUSTODYCD = CM.CUSTODYCD(+)
    AND CU.TRANS_TYPE = CM.TRANS_TYPE(+)
    AND CU.TRADE_DATE = CM.TRADE_DATE(+)
    AND CU.BROKER_CODE = CM.BROKER_CODE(+)
    AND CU.QUANTITY = CM.QUANTITY(+)
    AND CU.ISODMAST = CM.ISODMAST(+)

    AND CU.SEC_ID = VS.SEC_ID(+)
    AND CU.CUSTODYCD = VS.CUSTODYCD(+)
    AND CU.TRANS_TYPE = VS.TRANS_TYPE(+)
    AND CU.TRADE_DATE = VS.TRADE_DATE(+)
    AND CU.BROKER_CODE = VS.BROKER_CODE(+)
    AND CU.ISODMAST = VS.ISODMAST(+)
)a,(SELECT sbdate
  FROM (SELECT ROWNUM DAY, cldr.sbdate
          FROM (SELECT   sbdate
                    FROM sbcldr
                   WHERE sbdate < (select to_date(varvalue,'dd/MM/RRRR') from sysvar where varname = 'CURRDATE')
                     AND holiday = 'N'
                     AND cldrtype = '001'
                ORDER BY sbdate DESC) cldr) rl
 WHERE rl.DAY = 2)b
where to_date(tradedate,'dd/MM/RRRR') >= b.sbdate
/
