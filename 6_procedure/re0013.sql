SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0013 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTID         IN       VARCHAR2
 )
IS
--bao cao gia tri giao dich
--created by Chaunh at 11/01/2012
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

   VF_DATE DATE;
   VT_DATE DATE;
   V_CUSTID varchar2(10);

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

   -----------------------
   IF (UPPER(CUSTID) = 'ALL' OR CUSTID IS NULL) THEN
        V_CUSTID := '%';
   ELSE
        V_CUSTID := UPPER(CUSTID);
   END IF;

   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');


OPEN PV_REFCURSOR FOR
select custid, ACCTNO, FULLNAME, DESC_RETYPE, DESC_REROLE,
    tong_gia_tri_gd, phi_giamtru, doanh_thu, hoa_hong,
    (nvl(resa.salary,0)) salary
from
(
SELECT mst.custid, MST.ACCTNO, CF.FULLNAME,
        A0.CDCONTENT DESC_RETYPE,  MST.TYPENAME || '-' || A2.CDCONTENT DESC_REROLE,
        SUM(nvl(comm.directacr,0) + nvl(comm.indirectacr,0)) tong_gia_tri_gd,
        SUM(nvl(comm.rffeeacr,0)) phi_giamtru,
        SUM(case when MST.RETYPE = 'D' then nvl(comm.directfeeacr,0) else nvl(comm.indirectfeeacr,0) end ) doanh_thu,  SUM(nvl(comm.commision,0)) hoa_hong        ,
        mst.reacctno, mst.rerole
    FROM RECFLNK RF, CFMAST CF, ---RETYPE TYP,
        ALLCODE A0, ALLCODE A2,
        (select mst.acctno, mst.custid, mst.actype, TYP.RETYPE, TYP.REROLE, TYP.TYPENAME,
              custid || retype reacctno
        from remast mst, RETYPE TYP
        where MST.ACTYPE = TYP.ACTYPE) MST
        left join (select * from recommision where commdate <= VT_DATE AND commdate >= VF_DATE
        ) comm
        on mst.acctno = comm.acctno
    WHERE  MST.CUSTID = CF.CUSTID AND RF.CUSTID = MST.CUSTID
        AND A0.CDTYPE = 'RE' AND A0.CDNAME = 'RETYPE' AND MST.RETYPE = A0.CDVAL
        AND A2.CDTYPE = 'RE' AND A2.CDNAME = 'REROLE' AND MST.REROLE = A2.CDVAL
        AND MST.custid LIKE V_CUSTID
    GROUP BY mst.custid, MST.ACCTNO, CF.FULLNAME, A0.CDCONTENT ,  MST.TYPENAME || '-' || A2.CDCONTENT,
        mst.reacctno, mst.rerole
) mst
left join
(
    SELECT isdg, custid || retype reacctno, sum(nvl(salary,0)) salary
    FROM resalary
    where (commdate >= VF_DATE AND commdate <= VT_DATE)
    group by custid || retype, isdg
) resa
on  mst.reacctno = resa.reacctno
and (case when mst.rerole = 'DG' then 'Y' else 'N' end) = resa.isdg
;


EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
 
 
 
 
 
 
 
 
 
 
/
