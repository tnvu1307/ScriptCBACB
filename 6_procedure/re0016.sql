SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0016 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_MONTH           IN       VARCHAR2,
   T_MONTH           IN       VARCHAR2,
   RECUSTODYCD    IN       VARCHAR2,
   GROUPID            IN       VARCHAR2,
   I_BRID                 IN       VARCHAR2,
   REROLE               IN       VARCHAR2,
   TLID                   IN        VARCHAR2 default null
 )
IS

--Information Report
--------------------------------------------------------------------------------------------
--Report: Bao Cao Hoa Hong Truc Tiep
--Creator: HoangNX
--Created Date: 03/06/2015
--------------------------------------------------------------------------------------------

--Local Variable
--------------------------------------------------------------------------------------------
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);
   V_INBRID     VARCHAR2 (5);

   VF_DATE DATE;
   VT_DATE DATE;
   V_CUSTID varchar2(10);
   V_FMONTH VARCHAR2 (7);
   V_TMONTH VARCHAR2 (7);
   v_GROUPID varchar2(10);
   v_IBRID varchar2(10);
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

   IF (UPPER(I_BRID) = 'ALL' OR I_BRID IS NULL) THEN
        v_IBRID := '%';
   ELSE
        v_IBRID := UPPER(I_BRID);
   END IF;

   IF (UPPER(GROUPID) = 'ALL' OR GROUPID IS NULL) THEN
        v_GROUPID := '%';
   ELSE
        v_GROUPID := UPPER(GROUPID);
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
            SELECT  to_char(VF_DATE, 'MM/RRRR')  FRMONTH, to_char(VT_DATE, 'MM/RRRR') TOMONTH, dtl.commdate, rf.brid, brgrp.brname,
                    dtl.retype, dtl.actype, dtl.typename, dtl.custid, cf.fullname,
                    sum(dtl.directacr) directacr, sum(dtl.directfeeacr) directfeeacr, sum(dtl.rffeeacr) rffeeacr, sum(dtl.Fee_Minus) Fee_Minus, sum(dtl.Fee_Add) Fee_Add,
                    sum(dtl.Fee_Minus) + sum(dtl.Fee_Add) Fee_Adj, 0 addfeeacr,
                    sum(dtl.commision) commision, max(dtl.icrate) icrate, 0 addcommision, 0 execcommision, sum(dtl.Com_Minus) Com_Minus, sum(dtl.Com_Add) Com_Add,
                    sum(dtl.Com_Minus) + sum(dtl.Com_Add) Com_Adj,
                    sum(disrfmatchamt) disrfmatchamt,
                    sum(disrfmatchamt) + sum(disrffeeacr) /*+ SUM(drfeecallcenter) + SUM(drfeebondtypetp) + sum(feedisposal)*/ disrffeeacr, --phi giam tru
                    sum(rffeecomm) rffeecomm, tl.tlname
            FROM
                ( --Chi tiet
                  SELECT a.commdate, a.custid, a.retype, ret.actype, ret.typename,
                         SUM(a.directacr) directacr, SUM(a.directfeeacr) directfeeacr, SUM(a.rffeeacr) rffeeacr, SUM(NVL(ps.Fee_Minus, 0)) Fee_Minus,
                         SUM(NVL(ps.Fee_Add, 0)) Fee_Add, SUM(a.commision) commision, max(a.icrate) icrate, SUM(NVL(ps.Com_Minus, 0)) Com_Minus,
                         SUM(NVL(ps.Com_Add, 0)) Com_Add,
                         SUM(CASE WHEN a.retype = 'I' THEN a.inrfmatchamt ELSE a.disrfmatchamt END) disrfmatchamt,
                         SUM(CASE WHEN a.retype = 'I' THEN a.inrffeeacr ELSE a.disrffeeacr END) disrffeeacr,
                         SUM(CASE WHEN a.retype = 'I' THEN a.irfeecallcenter ELSE a.drfeecallcenter END) drfeecallcenter,
                         SUM(CASE WHEN a.retype = 'I' THEN a.inrffeeacr ELSE a.drfeebondtypetp END) drfeebondtypetp,
                         SUM(CASE WHEN a.retype = 'I' THEN a.ifeedisposal ELSE a.feedisposal END) feedisposal,
                         SUM(CASE WHEN a.retype = 'I' THEN a.INRFFEECOMM ELSE a.rffeecomm END) rffeecomm
                  FROM
                  	(SELECT *
                             FROM recommision a
                             WHERE commdate BETWEEN VF_DATE and VT_DATE /*AND commision > 0*/) a
                  INNER JOIN retype ret ON ret.actype = a.reactype AND ret.rerole LIKE V_REROLE
                  LEFT JOIN
                  (
                    SELECT to_char(CASE WHEN to_char(t.txdate, 'DD') > 25 THEN ADD_MONTHS(t.txdate, 1) ELSE t.txdate END , 'YYYY-MM') AdjMonth, t.acctno,
                          SUM(CASE WHEN t.tltxcd = '0312' AND t.txcd = '0028' AND t.namt < 0 THEN t.namt ELSE 0 END) Fee_Minus,
                          SUM(CASE WHEN t.tltxcd = '0312' AND t.txcd = '0028' AND t.namt > 0 THEN t.namt ELSE 0 END) Fee_Add,
                          SUM(CASE WHEN t.tltxcd = '0310' AND t.txcd = '0020' AND t.namt < 0 THEN t.namt ELSE 0 END) Com_Minus,
                          SUM (CASE WHEN t.tltxcd = '0310' AND t.txcd = '0020' AND t.namt > 0 THEN t.namt ELSE 0 END) Com_Add
                     FROM
                     (SELECT * FROM retran UNION ALL SELECT * FROM retrana) t
                     WHERE t.tltxcd IN ('0310', '0312')
                          AND t.txdate BETWEEN VF_DATE and VT_DATE
                     GROUP BY   to_char(CASE WHEN to_char(t.txdate, 'DD') > 25 THEN ADD_MONTHS(t.txdate, 1) ELSE t.txdate END , 'YYYY-MM'), t.acctno
                   ) ps ON a.acctno = ps.acctno AND to_char(a.commdate, 'YYYY-MM') = ps.AdjMonth
                   GROUP BY a.commdate, a.custid, a.retype, ret.actype, ret.typename
                 ) dtl,
                 --End chi tiet
                 cfmast cf , allcode a1, recflnk rf, brgrp, tlprofiles tl,
            (
                select txdate,recustid,max(grpid) grpid,max(grpcode)grpcode  from vw_recfingrp where txdate BETWEEN VF_DATE and VT_DATE group by txdate,recustid
                    UNION all
                select txdate,recustid,max(grpid) grpid,max(grpcode) grpcode  from recfingrp_log where txdate BETWEEN VF_DATE and VT_DATE group by txdate,recustid
            ) gr
              where dtl.custid=cf.custid
              and a1.cdtype='RE' and a1.cdname='RETYPE'
              and dtl.retype=a1.cdval
              and dtl.custid=rf.custid
              and rf.brid=brgrp.brid
              AND rf.tlid = tl.tlid(+)
              and dtl.retype='D'
              and dtl.custid = gr.recustid(+)
              and dtl.commdate = gr.txdate(+)
              AND EXISTS (select gu.grpid from tlgrpusers gu WHERE cf.careby = gu.grpid and gu.tlid like v_TLID)
              AND dtl.CUSTID LIKE V_CUSTID
              and dtl.commdate BETWEEN VF_DATE and VT_DATE
              and rf.brid like v_IBRID
              AND (rf.brid LIKE V_STRBRID OR rf.brid = '0001')
              and (nvl(gr.grpcode,' ') like v_GROUPID or instr(nvl(gr.grpcode,' '),v_GROUPID)>0)
              --AND ROUND(dtl.commision,0) > 0
            group by rf.brid, brgrp.brname, dtl.custid, cf.fullname, tl.tlname, dtl.commdate, dtl.retype, dtl.actype, dtl.typename
            --HAVING (sum(dtl.commision) - sum(rffeecomm) - sum(dtl.Com_Minus) + sum(dtl.Com_Add)) > 0
            order by rf.brid, tl.tlname, dtl.commdate;
     -----------------------------------------------------------------------------------------------------------------------------------------------------------
    EXCEPTION
       WHEN OTHERS
       THEN
        --dbms_output.put_line(dbms_utility.format_error_backtrace);
          RETURN;
END;

 
 
/
