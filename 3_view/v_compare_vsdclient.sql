SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_COMPARE_VSDCLIENT
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
select case when vs.broker_code = cu.broker_code
                and nvl(vs.quantity,0) = nvl(cu.quantity,0)
                and vs.gross_amount = cu.gross_amount
                and vs.custodycd = cu.custodycd
                and vs.trans_type = cu.trans_type
                and vs.settle_date = cu.settle_date
                 then 'Matched' else 'Mismatched' end note1,
        'Mismatched'  note,
        nvl(vs.custodycd,cu.custodycd)custodycd, nvl(vs.trans_type,cu.trans_type) transtype, nvl(vs.sec_id,cu.sec_id) symbol,
        cu.trade_date tradedate, '' tradedatectck,vs.trade_date tradedatevsd,cu.settle_date custsettledate, '' cmpsettledate,vs.settle_date vsdsettledate,
        0 CMPQTTY, 0 cmpprice,
        to_number(nvl(vs.quantity,0)) vsdqtty, to_number(nvl(round(vs.price,6),0)) vsdprice,
        to_number(nvl(cu.quantity,0)) custqtty, to_number(nvl(round(cu.price,6),0)) custprice,
        nvl(round(cu.gross_amount,2),0) custamount,
        0 cmpamount,
        nvl(round(vs.gross_amount,2),0) vsdamount,
        0 cmpfee, to_number(nvl(cu.commission_fee_cu,0)) custfee,
        0 cmptax, to_number(nvl(cu.tax_cu,0)) custtax,
        cu.shortname CUSTMEMBER,'' CMPMEMBER, vs.shortname vsdmember, 'T' status,
        case  when  vs.quantity <>cu.quantity   or cu.broker_code <> vs.broker_code then 'VSD  Mismatch Client'
             else '' end desct,
        (case when trim(cm.isodmast) = 'Y' OR trim(cu.isodmast) = 'Y' or trim(vs.isodmast) = 'Y' then 'Confirmed' else 'Not confirmed' end )ISODMAST,
        '' citad,'' identity,
        (case when trim(cm.isodmast) = 'Y' OR trim(cu.isodmast) = 'Y' or trim(vs.isodmast) = 'Y' then 'Y' else 'N' end )ISODMASTVAL,
        vs.txtime,0 CMPAMOUNTNET,to_number(nvl(cu.net_amount,0)) CUSTAMOUNTNET,to_number(nvl(vs.net_amount,0)) VSDAMOUNTNET
    from (SELECT * FROM V_SUM_BROKER_IMPORT_M WHERE DELTD <> 'Y') CM,
         (SELECT * FROM V_SUM_CLIENT_IMPORT_M WHERE DELTD <> 'Y') CU,
         (SELECT * FROM V_SUM_VSD_IMPORT WHERE DELTD <> 'Y') VS,
         (SELECT *FROM FAMEMBERS  WHERE ROLES = 'BRK') FA
    WHERE VS.BROKER_CODE= FA.DEPOSITMEMBER

    AND VS.SEC_ID = CU.SEC_ID(+)
    AND VS.CUSTODYCD = CU.CUSTODYCD(+)
    AND VS.TRANS_TYPE = CU.TRANS_TYPE(+)
    AND VS.TRADE_DATE = CU.TRADE_DATE(+)
    AND VS.SETTLE_DATE = CU.SETTLE_DATE(+)
    AND VS.BROKER_CODE = CU.BROKER_CODE(+)
    AND VS.QUANTITY = CU.QUANTITY(+)
    AND VS.ISODMAST = CU.ISODMAST(+)

    AND VS.SEC_ID = CM.SEC_ID(+)
    AND VS.CUSTODYCD = CM.CUSTODYCD(+)
    AND VS.TRANS_TYPE = CM.TRANS_TYPE(+)
    AND VS.TRADE_DATE = CM.TRADE_DATE(+)
    AND VS.SETTLE_DATE = CM.SETTLE_DATE(+)
    AND VS.BROKER_CODE = CM.BROKER_CODE(+)
    AND VS.ISODMAST = CM.ISODMAST(+)

)a,(SELECT sbdate
  FROM (SELECT ROWNUM DAY, cldr.sbdate
          FROM (SELECT   sbdate
                    FROM sbcldr
                   WHERE sbdate < (select to_date(varvalue,'dd/MM/RRRR') from sysvar where varname = 'CURRDATE')
                     AND holiday = 'N'
                     AND cldrtype = '001'
                ORDER BY sbdate DESC) cldr) rl
 WHERE rl.DAY = 2)b
where to_date(tradedatevsd,'dd/MM/RRRR') >= b.sbdate
/
