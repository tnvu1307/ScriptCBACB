SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CA0101 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CATYPE         IN       VARCHAR2
)
IS
--
-- CREATE BY LOCPT

-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);
   V_STRCATYPE        VARCHAR2 (16);


-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN

   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

   IF (CATYPE <> 'ALL')
   THEN
      V_STRCATYPE := CATYPE;
   ELSE
      V_STRCATYPE := '%%';
   END IF;


OPEN PV_REFCURSOR
    FOR
SELECT * FROM V_CAMAST WHERE 0=0 AND TRUNC(REPORTDATE) >= TRUNC(TO_DATE (F_DATE   ,'DD/MM/YYYY'))
                                 AND TRUNC(REPORTDATE) <= TRUNC(TO_DATE (T_DATE   ,'DD/MM/YYYY'))
                                 AND typeid like V_STRCATYPE;


 EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
END;                                                              -- PROCEDURE
 
 
 
 
/
