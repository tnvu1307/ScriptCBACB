SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_CIFEESCHD_ALL
(AUTOID, AFACCTNO, FEETYPE, TXNUM, TXDATE, 
 NMLAMT, PAIDAMT, FLOATAMT, FRDATE, TODATE, 
 REFACCTNO, DELTD)
AS 
select autoid, afacctno, feetype, txnum, txdate, nmlamt, paidamt, floatamt, frdate, todate, refacctno, deltd from cifeeschd
union all
select autoid, afacctno, feetype, txnum, txdate, nmlamt, paidamt, floatamt, frdate, todate, refacctno, deltd from cifeeschdhist
/
