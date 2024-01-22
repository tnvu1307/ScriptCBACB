SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CHECKGIA
(SYMBOL, BASICPRICE)
AS 
select distinct symbol,basicprice
  from securities_info
  order by symbol asc
/
