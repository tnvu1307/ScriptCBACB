SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_RE0003
(COMMDATE, RETYPE, DESC_RETYPE, CAREBY, TLNAME, 
 CUSTID, FULLNAME, MINDREVAMT, MINIREVAMT, MININCOME, 
 MINRATESAL, SALTYPE, DIRECTACR, DIRECTFEEACR, INDIRECTACR, 
 INDIRECTFEEACR, REVENUE, COMMISION, AUTOID, SALARY, 
 TOTALSAL, TAX, ISDG, MINCOMPLETED, DRATEMINCOMPLETED, 
 IRATEMINCOMPLETED, RFMATCHAMT, INRFMATCHAMT)
AS 
(
    SELECT a.commdate, a.retype,a1.cdcontent DESC_RETYPE, cf.CAREBY, nvl(tl.tlname,'') tlname, a.custid, cf.fullname,
      A.mindrevamt,
       a.minirevamt, a.minincome, a.minratesal, a.saltype,
        com.directacr, com.directfeeacr,
       com.indirectacr, com.indirectfeeacr,
         com.revenue, com.commision, a.autoid, A.minincome SALARY,
         (A.SALARY -a.tax +  com.commision) totalsal,
        a.tax, a.isdg,(A.SALARY-A.minincome)  MINCOMPLETED,A.RATEMINCOMPLETED DRATEMINCOMPLETED,
        A.RATEMINCOMPLETED IRATEMINCOMPLETED,
        a.rfmatchamt , a.inrfmatchamt
  FROM resalary a,
  (select commdate,custid,sum(directacr) directacr,sum(directfeeacr-rfmatchamt-rffeeacr) directfeeacr,sum(indirectacr) indirectacr,
sum(indirectfeeacr-inrfmatchamt-inrffeeacr) indirectfeeacr,sum(rffeecomm) rffeecomm,sum(inrffeecomm) inrffeecomm, sum(revenue) revenue, sum(commision) commision
from   recommision
group by commdate,custid) com, cfmast cf , allcode a1, recflnk rf, tlprofiles tl
  where a.custid=cf.custid
  and a1.cdtype='RE' and a1.cdname='RETYPE'
  and a.retype=a1.cdval
  and a.custid=rf.custid
  and rf.status = 'A'
  and a.commdate = com.commdate and a.custid = com.custid
  and rf.tlid=tl.tlid(+) --and (<$BRID> ='0001' or RF.BRID = <$BRID>)
)
/
