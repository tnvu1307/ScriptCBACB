SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE mr0067 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LINHLNB   11-Apr-2012  CREATED

-- ---------   ------  -------------------------------------------
   l_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   l_STRBRID          VARCHAR2 (4);

   V_IDATE           DATE; --ngay lam viec gan ngay fdate nhat
   v_TDATE           DATE; --ngay lam viec gan ngay tdate nhat
   v_CurrDate        DATE;
   V_INBRID         VARCHAR2(4);
   V_STRBRID        VARCHAR2 (50);
   V_STROPTION      VARCHAR2(10);
   V_LOANTYPE varchar2(50);
   v_todate date;


-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE


BEGIN
   V_STROPTION := upper(pv_OPT);
   V_INBRID := pv_BRID;

 -- END OF GETTING REPORT'S PARAMETERS

    V_IDATE := to_date(I_DATE,'DD/MM/RRRR');
    v_todate:= getcurrdate;

  -- GET REPORT'S DATA
OPEN PV_REFCURSOR FOR


select V_IDATE IDATE, v_todate TODATE,
    max(case when varname='BRADDRESS' then en_vardesc else '' end) BRADDRESS,
    max(case when varname='HEADOFFICE' then en_vardesc else '' end) HEADOFFICE,
    max(case when varname='BRPHONEFAX' then en_vardesc else '' end) BRPHONEFAX
from sysvar where varname in ('BRADDRESS','HEADOFFICE','BRPHONEFAX');


 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
 
 
/
