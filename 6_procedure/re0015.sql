SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0015 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   TERMCD         IN       VARCHAR2,
   RECUSTODYCD         IN       VARCHAR2
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
   V_TERMCD VARCHAR2 (7);

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

   IF (UPPER(RECUSTODYCD) = 'ALL' OR RECUSTODYCD IS NULL) THEN
        V_CUSTID := '%';
   ELSE
        V_CUSTID := UPPER(RECUSTODYCD);
   END IF;

    V_TERMCD := TO_CHAR(add_months('01/'||SUBSTR(TERMCD,0,2)||'/'||SUBSTR(TERMCD,3,4),0),'MM/RRRR');

OPEN PV_REFCURSOR FOR
        SELECT V_TERMCD termcd,a.commdate,rf.brid,brgrp.brname,a.custid, cf.fullname,
            max(a.RATEMINCOMPLETED) RATEMINCOMPLETED,max(A.MINCOMPLETED) MINCOMPLETED, max(a.SALARY) minincome,
            max(a.MINCOMPLETED+A.SALARY) SUMSALARY,max(nvl(rf.tlid,' ')) tlid
        FROM resalary a, cfmast cf , allcode a1, recflnk rf,brgrp
          where a.custid=cf.custid
          and a1.cdtype='RE' and a1.cdname='RETYPE'
          and a.retype=a1.cdval
          and a.custid=rf.custid
          and rf.brid=brgrp.brid
          AND A.CUSTID LIKE V_CUSTID
          AND TO_CHAR(a.commdate,'MM/RRRR') LIKE V_TERMCD
        group by rf.brid,brgrp.brname,a.custid, cf.fullname,a.commdate;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
 
 
/
