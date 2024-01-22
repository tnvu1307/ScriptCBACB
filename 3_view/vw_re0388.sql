SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_RE0388
(REACCTNO, REPROMREVIEWTERMID, TERMNAME, FRDATE, TODATE, 
 NOTE, TLNAME, FULLNAME, FEEAMT, AVGFEEAMT, 
 AVGNEWFEE, CURRSALARY, ADJSALARY, NEWSALARY, MG_MOI, 
 CTV_MOI, SLTP, TP_MG_MOI, TP_CTV_MOI, SLMG_KT, 
 SLMG_HT, RATEMEMBINGRP, FEEAMT_GRP, NEWFEEAMT, CURRPOSITION, 
 CURRPOSTEXT, NEWPOSITIONTEXT, NEWPOSITION, NEWPOSITION2)
AS 
SELECT a.reacctno,a.repromreviewtermid, a.termname, a.frdate, a.todate,'' note,
       a.tlname, a.fullname,a.feeamt,a.avgfeeamt,a.avgnewfee,a.currsalary,0,a.currsalary,
       a.mg_moi, a.ctv_moi, a.sltp, a.tp_mg_moi,
       a.tp_ctv_moi, a.slmg_kt, a.slmg_ht, a.ratemembingrp,
       a.feeamt_grp, a.newfeeamt,  a.currposition, a1.cdcontent currpostext, a2.cdcontent newpositiontext,
       a.newposition, a.newposition
  FROM review0388 a, allcode a1, allcode a2
  where a1.cdname='POSITION' and a1.cdtype ='RE' and a1.cdval = a.currposition
and   a2.cdname='POSITION' and a2.cdtype ='RE' and a2.cdval = a.newposition
/
