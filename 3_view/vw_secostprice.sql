SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_SECOSTPRICE
(ACCTNO, TXDATE, COSTPRICE)
AS 
select acctno,txdate,costprice from secostprice
union all
select acctno, getcurrdate() txdate,costprice from  semast
/
