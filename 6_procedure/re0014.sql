SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0014 (
     PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
     OPT              IN       VARCHAR2,
     BRID             IN       VARCHAR2,
     F_DATE         IN       VARCHAR2,
     T_DATE         IN       VARCHAR2
 )
IS
--Information Report
--------------------------------------------------------------------------------------------
--Report: Bao Cao Gia Tri Giao Dich
--Creator: HoangNX
--Created Date: 03/06/2015
--------------------------------------------------------------------------------------------

--Local Variable
--------------------------------------------------------------------------------------------
   V_STROPTION    VARCHAR2 (5);            --Note:  A: ALL, B: BRANCH, S: SUB-BRANCH
   V_STRBRID         VARCHAR2 (40);
   V_INBRID           VARCHAR2 (5);
   VF_DATE            DATE;
   VT_DATE            DATE;
   V_CUSTID           VARCHAR2(10);
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

     VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
     VT_DATE := to_date(T_DATE,'DD/MM/RRRR');
     -----------------------------------------------------------------------------------------------------------------------------------------------------------

     --Get Data For Report
  	 -----------------------------------------------------------------------------------------------------------------------------------------------------------
      OPEN PV_REFCURSOR FOR
              SELECT FDATE, TDATE, txdate, hoseexecamt, pthoseexecamt, hnxexecamt, pthnxexecamt
              FROM
              (
                  SELECT VF_DATE FDATE,VT_DATE TDATE,txdate, MAX(hoseexecamt) hoseexecamt, MAX(pthoseexecamt) pthoseexecamt,
                             MAX(hnxexecamt) hnxexecamt, MAX(pthnxexecamt) pthnxexecamt
                  FROM REEXECAMT
                  WHERE txdate  BETWEEN VF_DATE AND VT_DATE
                  GROUP BY txdate

                  UNION ALL

                  SELECT VF_DATE FDATE,VT_DATE TDATE,txdate, MAX(hoseexecamt) hoseexecamt, MAX(pthoseexecamt) pthoseexecamt,
                             MAX(hnxexecamt) hnxexecamt, MAX(pthnxexecamt) pthnxexecamt
                  FROM REEXECAMT_HIST
                  WHERE txdate  BETWEEN VF_DATE AND VT_DATE
                  GROUP BY txdate
              )
              ORDER BY txdate;
      -----------------------------------------------------------------------------------------------------------------------------------------------------------

EXCEPTION
      WHEN OTHERS THEN
                --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
END;

 
 
/
