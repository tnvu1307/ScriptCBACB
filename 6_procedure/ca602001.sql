SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CA602001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,

   P_CACODE       IN       VARCHAR2
)
IS
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- TRI.BUI     08/07/2020           CREATED
    RE_DATE       VARCHAR2 (20);
    CRE_DATE       VARCHAR2 (50);
    V_CACODE       VARCHAR2 (20);
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
BEGIN
    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:= BRID;
    END IF;
    V_CACODE := P_CACODE;
    -----
    SELECT TO_CHAR(GETCURRDATE,'DD Mon RRRR') INTO RE_DATE FROM DUAL;
    SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS AM') INTO CRE_DATE  FROM DUAL;
--==============MAIN QUERY================
 OPEN PV_REFCURSOR
 FOR

       SELECT 'ACTIVE' AS STC FROM DUAL
 
;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CA602001: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;                                                 -- PROCEDURE
/
