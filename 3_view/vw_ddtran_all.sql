SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_DDTRAN_ALL
(AUTOID, TXDATE, TXNUM, ACCTNO, TXCD, 
 NAMT, CAMT, REF, ACCTREF, DELTD, 
 TLTXCD, BKDATE, TRDESC)
AS 
select AUTOID,TXDATE,TXNUM,ACCTNO,TXCD,NAMT,CAMT,REF,ACCTREF,DELTD,TLTXCD,BKDATE,TRDESC from ddtran where DELTD <> 'Y'
UNION all
select AUTOID,TXDATE,TXNUM,ACCTNO,TXCD,NAMT,CAMT,REF,ACCTREF,DELTD,TLTXCD,BKDATE,TRDESC from ddtrana where DELTD <> 'Y'
/
