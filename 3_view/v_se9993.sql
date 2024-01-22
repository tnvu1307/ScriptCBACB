SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SE9993
(TRADINGDATE, SYMBOL, TRADEPLACE, CLOSEPRICE, FLOORPRICE, 
 CEILINGPRICE)
AS 
(
select
    TO_CHAR(Log.happened,'DD/MM/YYYY') TRADINGDATE,
    Log.symbol,
    allc.cdcontent tradeplace,
    substr(pricelog,1,idx_floor_price-1) CLOSEPRICE,
    substr(pricelog,idx_floor_price+15,idx_ceiling_price-idx_floor_price-15) FLOORPRICE,
    substr(pricelog, idx_ceiling_price+17) CEILINGPRICE


from sbsecurities sb, allcode allc,
(
    Select SUBSTR(e.logdetail,26,3) symbol,
    e.happened, e.logdetail,
    SUBSTR(e.logdetail,44,Length(e.logdetail)) pricelog, --29
    instr(SUBSTR(e.logdetail,44,Length(e.logdetail)),' p_floor_price:') idx_floor_price,
    instr(SUBSTR(e.logdetail,44,Length(e.logdetail)),' p_ceiling_price:') idx_ceiling_price
    from errors e
    where message like 'pr_updatepricefromgw'
          --and TRUNC(happened) = TRUNC(sysdate -1)
          and logdetail like 'p_update_mode:CN symbol: %'
)log
where sb.symbol = log.symbol
AND allc.CDTYPE = 'SA' AND allc.CDNAME = 'TRADEPLACE' AND allc.CDVAL = sb.TRADEPLACE
)
/
