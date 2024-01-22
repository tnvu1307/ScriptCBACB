SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf9004 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   pv_CUSTODYCD   IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- thunt
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (60);              -- USED WHEN V_NUMOPTION > 0
   V_BRID            VARCHAR2 (4);
   V_CUSTODYCD       VARCHAR2 (50);

BEGIN
   V_STROPTION := OPT;
   V_BRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_BRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;


   IF (pv_CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD:= pv_CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%%';
   END IF;

OPEN PV_REFCURSOR
FOR
select
cf.*,dd.*
from
cfmast cf, ddmast dd
where cf.custodycd=dd.custodycd and cf.custodycd like V_CUSTODYCD;

 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
