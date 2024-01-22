SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE fo0011 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE        IN       VARCHAR2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_AFACCTNO         IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- FO0011: Daily transaction 
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DIEUNDA   26-NOV-14  CREATED
-- HNP       24/12/2014  MODIFY
-- ---------   ------  -------------------------------------------
    V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID            VARCHAR2 (4);
    V_CUSTODYCD           VARCHAR2 (15);
    V_AFACCTNO           VARCHAR2 (15);

    IDATE Date;



BEGIN
   V_STROPTION := OPT;


   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

   IF(UPPER(PV_CUSTODYCD) <> 'ALL')
   THEN
        V_CUSTODYCD := UPPER(PV_CUSTODYCD);
   ELSE
        V_CUSTODYCD := '%';
   END IF;



   IF(UPPER(PV_AFACCTNO) <> 'ALL')
   THEN
        V_AFACCTNO := UPPER(PV_AFACCTNO);
   ELSE
        V_AFACCTNO := '%';
   END IF;
   IDATE:=TO_DATE(I_DATE,'dd/MM/rrrr');

OPEN PV_REFCURSOR FOR

select I_DATE I_DATE, PV_CUSTODYCD P_CUSTODYCD, PV_AFACCTNO P_AFACCTNO
from dual;

EXCEPTION
   WHEN OTHERS
   THEN
    plog.error('FO0011.' || sqlerrm || '.At:' || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
