SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_SECURITIES_PRICE
(CODEID, SYMBOL, REFPRICE, BASICPRICE, MARGINPRICE, 
 MARGINREFPRICE, MARGINCALLPRICE, MARGINREFCALLPRICE)
AS 
select si.codeid, si.symbol, to_number(nvl(s.closeprice, si.basicprice)) REFPRICE, si.basicprice, si.marginprice, si.marginrefprice, si.margincallprice, si.marginrefcallprice
from securities_info si,
(select s.* from stockinfor s, sysvar sys
    where sys.grname = 'SYSTEM' and sys.varname = 'CURRDATE' and tradingdate = sys.varvalue) s
where si.symbol = s.symbol(+)
/
