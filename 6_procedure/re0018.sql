SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0018 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                     IN       VARCHAR2,
   BRID                    IN       VARCHAR2,
   F_MONTH            IN       VARCHAR2,
   T_MONTH            IN       VARCHAR2,
   RECUSTODYCD     IN       VARCHAR2,
   REROLE               IN       VARCHAR2,
   TLID                   IN        VARCHAR2 default null
 )
IS

--Information Report
--------------------------------------------------------------------------------------------
--Report: Bao Cao Thu Nhap Moi Gioi
--Creator: HoangNX
--Created Date: 20/06/2015
--------------------------------------------------------------------------------------------

--Local Variable
--------------------------------------------------------------------------------------------
     V_STROPTION    VARCHAR2 (5);
     V_STRBRID      VARCHAR2 (40);
     V_INBRID     VARCHAR2 (5);

     VF_DATE DATE;
     VT_DATE DATE;
     V_CUSTID varchar2(10);
     V_FMONTH VARCHAR2 (7);
     V_TMONTH VARCHAR2 (7);
     V_REROLE varchar2(10);
     v_TLID varchar2(10);

--------------------------------------------------------------------------------------------

--Initialize Variables and Get Data For Report
---------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
     --Initialize Variables
     -----------------------------------------------------------------------------------------------------------------------------------------------------------

     V_STROPTION := upper(OPT);
     V_INBRID := BRID;

     IF (V_STROPTION = 'A') THEN
          V_STRBRID := '%';
      ELSE
          IF (V_STROPTION = 'B') THEN
              SELECT br.mapid INTO V_STRBRID FROM brgrp br WHERE  br.brid = V_INBRID;
          ELSE
              V_STRBRID := BRID;
          END IF;
      END IF;

     -----------------------

     IF (UPPER(RECUSTODYCD) = 'ALL' OR RECUSTODYCD IS NULL) THEN
          V_CUSTID := '%';
     ELSE
          V_CUSTID := UPPER(RECUSTODYCD);
     END IF;

     IF (UPPER(REROLE) = 'ALL' OR REROLE IS NULL) THEN
          V_REROLE := '%';
     ELSE
          V_REROLE := UPPER(REROLE);
     END IF;

     IF (upper(TLID) = 'ALL' or TLID is null)  THEN
        v_TLID := '%';
     ELSE
        v_TLID := UPPER(TLID);
     END IF;

     VF_DATE := to_date(F_MONTH,'MM/RRRR');
     VT_DATE := LAST_DAY(to_date(T_MONTH,'MM/RRRR'));
     -----------------------------------------------------------------------------------------------------------------------------------------------------------

     --Get Data For Report
     -----------------------------------------------------------------------------------------------------------------------------------------------------------
      OPEN PV_REFCURSOR FOR
              SELECT to_char(VF_DATE, 'MM/RRRR')  FromMonth, to_char(VT_DATE, 'MM/RRRR') ToMonth, to_char(a.commdate, 'MM/RRRR') ComMonth,
                        a.commdate, rf.brid, brgrp.brname, a.custid, cf.fullname,
                       (MAX(a.SALARY)) salary,
                       NVL(MAX(cm.dcommision),0) dcommision,
                       NVL(MAX(cm.icommision),0) icommision,
                       MAX(rf.positionName) REROLE,MAX(NVL(rf.tlid,' ')) tlid, MAX(NVL(tl.tlname,'')) tlname

              FROM resalary a, cfmast cf , allcode a1, brgrp, tlprofiles tl,
                        (SELECT  cm.commdate, cm.custid,
                                 SUM(CASE WHEN cm.retype = 'D' THEN cm.commision ELSE 0 END) dcommision,
                                 SUM(CASE WHEN cm.retype = 'I' THEN cm.commision ELSE 0 END) icommision
                        FROM recommision cm
                        WHERE cm.commdate BETWEEN VF_DATE and VT_DATE
                              AND cm.custid LIKE V_CUSTID
                        GROUP BY cm.commdate, cm.custid
                        ) cm,
                        (--Lay Rerole tu loai hinh RE
                        SELECT DISTINCT rf.*, a.cdcontent positionName, rt.rerole --left join
                        FROM recflnk rf, recfdef rd, retype rt, allcode a
                        WHERE rf.autoid = rd.refrecflnkid
                        AND rd.reactype = rt.actype
                        AND a.cdtype = 'RE'
                        AND a.cdname = 'POSITION'
                        AND rf.status = 'A'
                        AND rd.status = 'A'
                        AND a.cdval = rf.position
                        ) rf  --End HoangNX
                where a.custid=cf.custid
                AND a1.cdtype='RE' AND a1.cdname='RETYPE'
                AND a.retype=a1.cdval
                AND a.custid=rf.custid
                AND a.commdate = cm.commdate
                AND a.custid = cm.custid
                AND rf.brid=brgrp.brid
                AND tl.tlid(+)=rf.tlid
                AND a.retype = 'D' --Fix 07/07/2015
                AND EXISTS (select gu.grpid from tlgrpusers gu WHERE cf.careby = gu.grpid and gu.tlid like v_TLID)
                AND A.CUSTID LIKE V_CUSTID
                AND a.commdate BETWEEN VF_DATE and VT_DATE
                AND rf.rerole LIKE V_REROLE
                AND (rf.brid LIKE V_STRBRID OR rf.brid = '0001')
              GROUP BY rf.brid,brgrp.brname,a.custid, cf.fullname,a.commdate
              HAVING (MAX(a.SALARY)+ NVL(MAX(cm.dcommision),0) + NVL(MAX(cm.icommision),0)) > 0
              ORDER BY a.commdate, rf.brid;
       -----------------------------------------------------------------------------------------------------------------------------------------------------------

      EXCEPTION
         WHEN OTHERS
         THEN
          --dbms_output.put_line(dbms_utility.format_error_backtrace);
            RETURN;
End;

 
 
/
