SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0110 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_MKID     IN       VARCHAR2,
   TLID     IN       VARCHAR2


       )
IS

--
-- PURPOSE: BAO CAO DANG KY/HUY DANG KY EMAIL/SMS
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS

-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);
    L_MKID              VARCHAR2(20);
    L_CUSTODYCD         VARCHAR2(20);
    L_FRDATE            DATE;
    L_TODATE            DATE;


BEGIN
    -- GET REPORT'S PARAMETERS
    V_STROPTION := OPT;

    if (PV_CUSTODYCD = 'ALL' or PV_CUSTODYCD is null) then
      L_CUSTODYCD := '%';
    else
      L_CUSTODYCD := UPPER(PV_CUSTODYCD);
    end if;

    if (PV_MKID = 'ALL' or PV_MKID is null) then
      L_MKID := '%';
    else
      L_MKID := UPPER(PV_MKID);
    end if;

    L_FRDATE := TO_DATE(F_DATE,'DD/MM/YYYY');
    L_TODATE := TO_DATE(T_DATE,'DD/MM/YYYY');

     OPEN PV_REFCURSOR FOR
        SELECT L_FRDATE FRDATE, L_TODATE TODATE,CF.CUSTODYCD, CF.FULLNAME, LG.BEGINDATE, LG.ENDDATE, A1.CDCONTENT ACTION, LG.APPROVEDATE, LG.template_code, T.SUBJECT, LG.TLID, MK.TLNAME
        FROM aftemplateslog LG, templates T, cfmast CF, tlprofiles MK, allcode a1
        WHERE LG.template_code = T.CODE
            AND LG.CUSTID = CF.CUSTID
            AND LG.TLID = MK.TLID
            AND DECODE(LG.ACTION,'DELETE','DEL',LG.ACTION) = A1.CDVAL AND A1.CDNAME='SMSACTION' AND A1.CDTYPE='CF'
            AND CF.CUSTODYCD LIKE L_CUSTODYCD
            AND LG.TLID LIKE L_MKID
            AND NVL(LG.ENDDATE,LG.BEGINDATE) BETWEEN L_FRDATE AND L_TODATE
        ORDER BY LG.LAST_CHANGE    ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
 
 
/
