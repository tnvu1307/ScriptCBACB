SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0030 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                              IN       VARCHAR2,
   BRID                             IN       VARCHAR2,
   F_DATE                         IN       VARCHAR2,
   T_DATE                         IN       VARCHAR2,
   TLNAME                       IN       VARCHAR2,
   TLID                             IN       VARCHAR2,
   PV_TRANSTYPE             IN       VARCHAR2
 )
IS

--Information Report
--------------------------------------------------------------------------------------------
--Report: Bao Cao Lich Su Thang Chuc Giang Chuc
--Creator: HoangNX
--Created Date: 19/06/2015
--------------------------------------------------------------------------------------------

--Local Variable
--------------------------------------------------------------------------------------------

   V_STROPTION               VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID                    VARCHAR2 (40);
   V_INBRID                      VARCHAR2 (5);

   v_FromDate                  DATE;
   v_ToDate                      DATE;
   v_Tlname                      VARCHAR2(10);
   v_TLID                          VARCHAR2(10);
   v_TransType                 VARCHAR2(10);

--------------------------------------------------------------------------------------------

--Initialize Variables and Get Data For Report
---------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
     --Initialize Variables
  	 -----------------------------------------------------------------------------------------------------------------------------------------------------------

       V_STROPTION := UPPER(OPT);
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

        IF (UPPER(TLID) = 'ALL' OR TLID IS NULL)  THEN
           v_TLID := '%';
       ELSE
           v_TLID := UPPER(TLID);
       END IF;

       IF (UPPER(TLNAME) = 'ALL' OR TLNAME IS NULL) THEN
            v_Tlname := '%';
       ELSE
            v_Tlname := UPPER(TLNAME);
       END IF;

       IF (UPPER(PV_TRANSTYPE) = 'ALL' OR PV_TRANSTYPE IS NULL) THEN
            v_TransType := '%';
       ELSE
            v_TransType := UPPER(PV_TRANSTYPE);
       END IF;


       v_FromDate := to_date(F_DATE,'DD/MM/RRRR');
       v_ToDate := to_date(T_DATE,'DD/MM/RRRR');

     -----------------------------------------------------------------------------------------------------------------------------------------------------------

     --Get Data For Report
  	 -----------------------------------------------------------------------------------------------------------------------------------------------------------
      OPEN PV_REFCURSOR FOR
           SELECT ReviewID, ReviewName, mst.txdate AdjDate, mst.TLNAME, mst.TLFULLNAME, MatchValueAVG, DirectRevenue,
                      GroupRevenue, NewBroker, NewFreeLancer, EmpRate, SalaryCurr, SalaryAdjust, SalaryNew, NewCustRevenue, NewManager,
                      CASE WHEN TransType = 'C' THEN 'Thăng chức' ELSE 'Giáng chức' END TransType,
                      tl.tlname /*|| '_' || tl.tlfullname*/ TellerID, apr.tlname /*|| '_' || apr.tlfullname*/ ApprovedID
           FROM
                     (
                      SELECT tlg.txnum, tlg.txdate,
                                 max(CASE WHEN tlf.fldcd = '03' THEN nvl(tlf.cvalue, tlf.nvalue) ELSE ' ' END) ReviewID,
                                 max(CASE WHEN tlf.fldcd = '04' THEN nvl(tlf.cvalue, tlf.nvalue) ELSE ' ' END) ReviewName,
                                 max(CASE WHEN tlf.fldcd = '20' THEN nvl(tlf.cvalue, ' ') ELSE ' ' END) TLNAME,
                                 max(CASE WHEN tlf.fldcd = '02' THEN nvl(tlf.cvalue, ' ') ELSE ' ' END) TLFULLNAME,
                                 max(CASE WHEN tlf.fldcd = '21' THEN nvl(tlf.nvalue, 0) ELSE 0 END) MatchValueAVG,
                                 max(CASE WHEN tlf.fldcd = '12' THEN nvl(tlf.nvalue,0) ELSE 0 END) DirectRevenue,
                                 max(CASE WHEN tlf.fldcd = '13' THEN nvl(tlf.nvalue, 0) ELSE 0 END) GroupRevenue,
                                 max(CASE WHEN tlf.fldcd = '14' THEN nvl(tlf.nvalue, 0) ELSE 0 END) NewCustRevenue,
                                 max(CASE WHEN tlf.fldcd = '07' THEN nvl(tlf.nvalue, 0) ELSE 0 END) NewBroker,
                                 max(CASE WHEN tlf.fldcd = '08' THEN nvl(tlf.nvalue, 0) ELSE 0 END) NewFreeLancer,
                                 max(CASE WHEN tlf.fldcd = '09' THEN nvl(tlf.nvalue, 0) ELSE 0 END) NewManager,
                                 max(CASE WHEN tlf.fldcd = '22' THEN nvl(tlf.nvalue, 0) ELSE 0 END) EmpRate,
                                 max(CASE WHEN tlf.fldcd = '23' THEN nvl(tlf.nvalue,0) ELSE 0 END) SalaryCurr,
                                 max(CASE WHEN tlf.fldcd = '24' THEN nvl(tlf.nvalue, 0) ELSE 0 END) SalaryAdjust,
                                 max(CASE WHEN tlf.fldcd = '25' THEN nvl(tlf.nvalue, 0) ELSE 0 END) SalaryNew,
                                 max(CASE WHEN tlf.fldcd = '26' THEN nvl(tlf.cvalue, ' ') ELSE NULL END) TransType,
                                 max(tlg.tlid) TellerID, max(tlg.offid) ApprovedID
                      FROM vw_tllog_all_re tlg, vw_tllogfld_re tlf
                      WHERE tlg.txnum = tlf.txnum
                                  AND tlg.txdate = tlf.txdate
                                  AND tlg.tltxcd IN ('0388')
                                  AND tlg.busdate BETWEEN v_FromDate AND v_ToDate
                                  AND tlf.txdate BETWEEN v_FromDate AND v_ToDate
                      GROUP BY tlg.txnum, tlg.txdate
                    ) mst,
                    tlprofiles tl, tlprofiles apr
            WHERE mst.TellerID = tl.tlid
                      AND mst.ApprovedID = apr.tlid
                      AND mst.tlname LIKE v_Tlname
                      AND mst.TransType LIKE v_TransType;
      -----------------------------------------------------------------------------------------------------------------------------------------------------------
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
END;

 
 
/
