SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_DDTRAN_GEN
(AUTOID, CUSTODYCD, CUSTID, TXNUM, TXDATE, 
 ACCTNO, TXCD, NAMT, CAMT, REF, 
 DELTD, ACCTREF, TLTXCD, BUSDATE, TXDESC, 
 TXTIME, BRID, TLID, OFFID, CHID, 
 TXTYPE, FIELD, TLLOG_AUTOID, TRDESC, COREBANK)
AS 
SELECT CI.AUTOID,
             DD.CUSTODYCD,
             DD.CUSTID,
             CI.TXNUM,
             CI.TXDATE,
             CI.ACCTNO,
             CI.TXCD,
             CI.NAMT,
             CI.CAMT,
             CI.REF,
             NVL(CI.DELTD, 'N') DELTD,
             CI.ACCTREF,
             TL.TLTXCD,
             TL.BUSDATE,
             CASE
               WHEN TL.TLID = '6868' THEN
                TRIM(TL.TXDESC) || ' (Online)'
               ELSE
                TL.TXDESC
             END TXDESC,
             TL.TXTIME,
             TL.BRID,
             TL.TLID,
             TL.OFFID,
             TL.CHID,
             APP.TXTYPE,
             APP.FIELD,
             TL.AUTOID TLLOG_AUTOID,
             CASE
               WHEN CI.TRDESC IS NOT NULL THEN
                (CASE
                  WHEN TL.TLID = '6868' THEN
                   TRIM(CI.TRDESC) || ' (Online)'
                  ELSE
                   CI.TRDESC
                END)
               ELSE
                CI.TRDESC
             END TRDESC,
             'Y' COREBANK
        FROM DDTRAN CI,
             TLLOG TL,
             DDMAST DD,
             APPTX APP
       WHERE CI.TXDATE = TL.TXDATE
         AND CI.TXNUM = TL.TXNUM
         AND CI.ACCTNO = DD.ACCTNO
         AND CI.TXCD = APP.TXCD
         AND APP.APPTYPE = 'DD'
         AND APP.TXTYPE IN ('D', 'C')
         AND TL.DELTD <> 'Y'
         AND CI.NAMT <> 0
         
UNION ALL

select AUTOID, CUSTODYCD, CUSTID, TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, ACCTREF, TLTXCD, BUSDATE, TXDESC, TXTIME, BRID, TLID, OFFID, CHID, TXTYPE, FIELD, TLLOG_AUTOID, TRDESC, COREBANK
from ddtran_gen where DELTD <> 'Y'
/
