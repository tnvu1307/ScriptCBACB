SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0026 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                IN       VARCHAR2,
   BRID               IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   I_BRID            IN       VARCHAR2,
   CUSTTYPE       IN       VARCHAR2,
   TLID               IN       VARCHAR2
 )
IS
--Bao cao doanh thu theo chi nhanh
--Created by HoangNX
--Created date 15/06/2015

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

   v_FromDate DATE;
   v_ToDate DATE;
   v_CustType  VARCHAR2(30);
   v_TLID   VARCHAR2(10);
   v_BridPrm  VARCHAR2(5);

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

    IF (upper(TLID) = 'ALL' or TLID is null)  THEN
       v_TLID := '%';
   ELSE
       v_TLID := UPPER(TLID);
   END IF;

   -----------------------
   IF (upper(CUSTTYPE) = 'ALL' or CUSTTYPE is null)  THEN
       v_CustType := '%';
   ELSE
         v_CustType := UPPER(CUSTTYPE) || '%';
   END IF;

   IF (upper(I_BRID) = 'ALL' or I_BRID is null)  THEN
    v_BridPrm := '%';
   ELSE
    v_BridPrm := UPPER(I_BRID);
   END IF;

   v_FromDate := to_date(F_DATE,'DD/MM/RRRR');
   v_ToDate := to_date(T_DATE,'DD/MM/RRRR');


OPEN PV_REFCURSOR FOR
select * from dual;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/
