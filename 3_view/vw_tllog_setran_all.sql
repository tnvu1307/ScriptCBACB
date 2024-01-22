SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_TLLOG_SETRAN_ALL
(AUTOID, TXNUM, TXDATE, TXTIME, BRID, 
 TLID, OFFID, OVRRQS, CHID, CHKID, 
 TLTXCD, IBT, BRID2, TLID2, CCYUSAGE, 
 OFF_LINE, DELTD, BRDATE, BUSDATE, TXDESC, 
 IPADDRESS, WSNAME, TXSTATUS, MSGSTS, OVRSTS, 
 BATCHNAME, MSGAMT, MSGACCT, CHKTIME, OFFTIME, 
 CAREBYGRP, ACCTNO, TXCD, NAMT, CAMT, 
 REF, ACCTREF, TRAN_AUTOID)
AS 
select tl."AUTOID",tl."TXNUM",tl."TXDATE",tl."TXTIME",tl."BRID",tl."TLID",tl."OFFID",tl."OVRRQS",tl."CHID",tl."CHKID",tl."TLTXCD",tl."IBT",tl."BRID2",tl."TLID2",tl."CCYUSAGE",tl."OFF_LINE",tl."DELTD",tl."BRDATE",tl."BUSDATE",tl."TXDESC",tl."IPADDRESS",tl."WSNAME",tl."TXSTATUS",tl."MSGSTS",tl."OVRSTS",tl."BATCHNAME",tl."MSGAMT",tl."MSGACCT",tl."CHKTIME",tl."OFFTIME",tl."CAREBYGRP", tr.acctno, tr.txcd, tr.namt, tr.camt, tr.ref, tr.acctref, tr.autoid tran_autoid
from
    (
        select * from tllog where deltd <> 'Y'
        union all
        select * from tllogall where deltd <> 'Y'
    ) tl,
    (
        select * from setran where deltd <> 'Y'
        union all
        select * from setrana  where deltd <> 'Y'
    ) tr
where tl.txdate = tr.txdate and tl.txnum = tr.txnum
/
