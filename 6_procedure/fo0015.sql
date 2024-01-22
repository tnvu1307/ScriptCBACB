SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE fo0015 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_MONTH         IN       VARCHAR2

 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- FO0015: Tinh hinh tai chinh (tai khoan tu doanh)
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DIEUNDA   26-NOV-14  CREATED
-- ---------   ------  -------------------------------------------
--

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (60);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);      -- USED WHEN V_NUMOPTION > 0

   V_TODATE     DATE;
   V_FROMDATE   DATE;



-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

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

    V_FROMDATE := to_date('01/'||I_MONTH,'DD/MM/RRRR');
    V_TODATE := LAST_DAY(TO_DATE(I_MONTH,'MM/rrrr'));




OPEN PV_REFCURSOR FOR


SELECT I_MONTH IMONTH from dual;
EXCEPTION
   WHEN OTHERS
   THEN
    plog.error('FO0015.' || sqlerrm || '.At:' || dbms_utility.format_error_backtrace);
      RETURN;
End;
 
 
/
