SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CA0040 (
       PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
       OPT            IN       VARCHAR2,
       BRID           IN       VARCHAR2,
       F_DATE         IN       VARCHAR2,
       T_DATE         IN       VARCHAR2,
       E_EXCHANGE     IN       VARCHAR2
)
IS

-- PURPOSE:
--
-- PERSON               DATE                COMMENTS
-- ---------------      ----------          ----------------------

-- ---------------      ----------          ----------------------

  V_STROPTION           VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH

  V_INBRID        VARCHAR2(4);
  V_STRBRID      VARCHAR2 (50);

BEGIN


    V_STROPTION := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;






   OPEN PV_REFCURSOR
   FOR
     SELECT 1 FROM DUAL
;



EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
 
 
 
 
/
