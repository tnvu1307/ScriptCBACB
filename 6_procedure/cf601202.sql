SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf601202 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*TU NGAY */
   T_DATE                 IN       VARCHAR2, /*DEN NGAY */
   REPORT_NO              IN       VARCHAR2, -- SO CHUNG TU
   PV_CUSTODYCD           IN       VARCHAR2, /*SO TK LUU KY */
   P_SYMBOL               IN       VARCHAR2, -- CHUNG KHOAN
   P_SHARESOUTTYP         IN       VARCHAR2, -- KL LUU HANH
   P_SIGNUSER             IN       VARCHAR2 -- NGUOI KY
   )
IS
    -- GIAY DANG KY MA SO GIAO DICH
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- TRUONGLD    18-10-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_CUSTODYCD         VARCHAR2(20);
    -- TY LE SO HUU CO DONG LON

    V_AMCID             VARCHAR2(200);

BEGIN

   V_STROPTION := OPT;
----------------------------------------------------------------------
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:=BRID;
    END IF;
----------------------------------------------------------------------
    V_CUSTODYCD := REPLACE(PV_CUSTODYCD,'.','');
----------------------------------------------------------------------
    BEGIN
    SELECT  AMCID INTO V_AMCID FROM CFMAST WHERE CUSTODYCD= V_CUSTODYCD;
    EXCEPTION
      WHEN OTHERS
        THEN V_AMCID := '';
    END;
----------------------------------------------------------------------
OPEN PV_REFCURSOR FOR
    SELECT FULLNAME AS AMC_FULLNAME, TRADINGCODE AS AMC_TRADINGCODE
    FROM CFMAST
    WHERE AMCID = V_AMCID
    AND STATUS <> 'C'
    AND SUBSTR(CUSTODYCD,0,3) <> 'OTC'
    ;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CF601202: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
