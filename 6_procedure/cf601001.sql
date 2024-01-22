SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf601001(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   P_REPORTNO             IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*TU NGAY */
   T_DATE                 IN       VARCHAR2, /*DEN NGAY */
   P_CUSTODYCD            IN       VARCHAR2, /*SO TK LUU KY */
   P_SYMBOL               IN       VARCHAR2, /*MA CHUNG KHOAN */
   P_SHARESOUTTYP         IN       VARCHAR2, /*KL LUU HANH */
   P_SIGNTYPE             IN       VARCHAR2 /*NGUOI KY */
   )
IS
    -- REPORT ON THE DAY BECOME/IS NO LONGER MAJOR SHAREHOLDER, INVESTORS HOLDING 5% OR MORE OF SHARES
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- DU.PHAN    23-10-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_FROMDATE          DATE;
    V_TODATE            DATE;
    V_CURRDATE          DATE;
    V_CUSTODYCD         VARCHAR2(20);

    V_AMCID             VARCHAR2(20);
BEGIN
     V_STROPTION := OPT;
     V_CURRDATE   := GETCURRDATE;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;

    V_CUSTODYCD := REPLACE(P_CUSTODYCD,'.','');
-- LAY THONG TIN AMC
BEGIN
    SELECT CF.AMCID
    INTO V_AMCID
    FROM CFMAST CF
    WHERE CUSTODYCD=V_CUSTODYCD
    AND CF.STATUS NOT IN ('C');
EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_AMCID:= NULL;

END;


OPEN PV_REFCURSOR FOR
    WITH  TMPCOUNTRY AS (
        SELECT CDVAL COUNTRYID,CDCONTENT AS COUNTRY,EN_CDCONTENT  EN_COUNTRY
        FROM ALLCODE
        WHERE CDNAME='COUNTRY'
    ), TMPMST AS (
        SELECT CF.CUSTODYCD,
                CF.FULLNAME  CFFULLNAME,
                CF.IDPLACE CFIDPLACE,
                CASE WHEN CF.IDTYPE='009' THEN CF.TRADINGCODEDT
                    ELSE CF.IDDATE
                END CFIDDATE,
                CASE WHEN CF.IDTYPE='009' THEN CF.TRADINGCODE
                    ELSE CF.IDCODE
                END CFIDCODE,
               CF.CIFID
        FROM CFMAST CF
            LEFT JOIN TMPCOUNTRY C ON CF.COUNTRY = C.COUNTRYID
        WHERE CF.AMCID = V_AMCID
        AND CF.STATUS NOT IN ('C')
  )
    SELECT
   ROWNUM NO,
           MST.CUSTODYCD,
           MST.CFFULLNAME,
           MST.CFIDCODE,
           MST.CFIDDATE,
           MST.CFIDPLACE

   FROM TMPMST MST
   WHERE MST.CUSTODYCD!=V_CUSTODYCD
    ORDER BY 1;

EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CF601001: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
