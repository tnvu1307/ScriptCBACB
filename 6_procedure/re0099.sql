SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0099(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   T_DATE       IN VARCHAR2,
                                   I_BRID       IN VARCHAR2,
                                   GROUPID      IN VARCHAR2,
                                   RECUSTODYCD  IN VARCHAR2) IS

  --Bao Cao Danh Sach Moi Gioi
  --Create by NNha PHS
  --Date create : 05/06/2015
  --Modified

  V_STROPTION VARCHAR2(5);
  V_STRBRID   VARCHAR2(40);
  V_INBRID    VARCHAR2(5);
  VT_DATE     DATE;
  V_GROUPID   VARCHAR2(10);

  V_GROUPCUSTID VARCHAR2(20);
  V_I_BRID      VARCHAR2(10);
  --V_I_BRID_NAME VARCHAR2(50);
  V_CUSTID VARCHAR2(10);
BEGIN

  V_STROPTION := UPPER(OPT);
  V_INBRID    := BRID;

  IF (V_STROPTION = 'A') THEN
    V_STRBRID := '%';
  ELSE
    IF (V_STROPTION = 'B') THEN
      SELECT BR.MAPID
        INTO V_STRBRID
        FROM BRGRP BR
       WHERE BR.BRID = V_INBRID;
    ELSE
      V_STRBRID := BRID;
    END IF;
  END IF;

  IF GROUPID <> 'ALL' THEN
    BEGIN
      V_GROUPID := GROUPID;
      SELECT RECFLNK.BRID
        INTO V_GROUPCUSTID
        FROM REGRP G, RECFLNK
       WHERE SP_FORMAT_REGRP_MAPCODE(G.AUTOID) LIKE V_GROUPID
         AND G.CUSTID = RECFLNK.CUSTID;
    END;
  ELSE
    BEGIN
      V_GROUPID     := '%';
      V_GROUPCUSTID := ' ';
    END;
  END IF;

  IF UPPER(I_BRID) <> 'ALL' THEN
    V_I_BRID := I_BRID;
    --SELECT (BRID || '_' || BRNAME) INTO V_I_BRID_NAME FROM BRGRP BR WHERE BR.BRID = V_I_BRID;
  ELSE
    V_I_BRID := '%';
    --V_I_BRID_NAME := 'ALL';
  END IF;

  IF UPPER(RECUSTODYCD) <> 'ALL' THEN
    V_CUSTID := RECUSTODYCD;
  ELSE
    V_CUSTID := '%';
  END IF;
  ------------------------

  VT_DATE := TO_DATE(T_DATE, 'DD/MM/RRRR');

  OPEN PV_REFCURSOR FOR
  
    SELECT T_DATE T_DATE,
           TB1.CUSTID,
           TB1.BRID,
           TB1.BRNAME,
           TB1.FULLNAME,
           TB1.POSITION,
           SP_FORMAT_REGRP_MAPCODE(TB1.GROUPID) GROUPID,
           TB1.GROUPNAME,
           TB1.LEADER,
           TB1.FROMDATE,
           TB1.TODATE,
           TBN.ACTYPE AS ACTYPE_D_N,
           TBO.ACTYPE AS ACTYPE_D_O,
           TBD.ACTYPE AS ACTYPE_D_D,
           TBCSH.ACTYPE AS ACTYPE_D_CSH,
           TBIM.ACTYPE AS ACTYPE_I_M,
           TBIR.ACTYPE AS ACTYPE_I_R
      FROM (SELECT RE1.CUSTID,
                   RE1.BRID,
                   RE1.BRNAME,
                   RE1.FULLNAME,
                   RE1.CDCONTENT AS POSITION,
                   RE2.GROUPID,
                   RE2.GROUPNAME,
                   RE2.LEADER,
                   RE2.FROMDATE,
                   RE2.TODATE
              FROM (SELECT RECF.CUSTID,
                           RECF.BRID,
                           (BR.BRID || '_' || BR.BRNAME) AS BRNAME,
                           (TL.TLNAME || '_' || CF.FULLNAME) AS FULLNAME,
                           RECFDERET.CDCONTENT
                      FROM RECFLNK RECF,
                           TLPROFILES TL,
                           CFMAST CF,
                           BRGRP BR,
                           (SELECT RECFD.REFRECFLNKID,
                                   RET.REROLE,
                                   ALLC.CDCONTENT
                              FROM RECFDEF RECFD, RETYPE RET, ALLCODE ALLC
                             WHERE RET.ACTYPE = RECFD.REACTYPE
                               AND ALLC.CDTYPE = 'RE'
                               AND ALLC.CDNAME = 'REROLE'
                               AND ALLC.CDVAL = RET.REROLE) RECFDERET
                     WHERE CF.CUSTID = RECF.CUSTID
                       AND TL.TLID = RECF.TLID
                       AND RECF.STATUS = 'A'
                       AND RECF.AUTOID = RECFDERET.REFRECFLNKID(+)
                       AND RECF.EFFDATE <= VT_DATE
                       AND BR.BRID = RECF.BRID
                       AND RECF.BRID LIKE V_I_BRID
                       AND RECF.CUSTID LIKE V_CUSTID) RE1,
                   (SELECT REG.CUSTID,
                           NULL         AS REACCTNO,
                           REG.AUTOID   GROUPID,
                           REG.FULLNAME GROUPNAME,
                           CF.FULLNAME  LEADER,
                           REG.EFFDATE  AS FROMDATE,
                           REG.EXPDATE  AS TODATE
                      FROM REGRP REG, CFMAST CF
                     WHERE REG.EFFDATE <= VT_DATE
                       AND CF.CUSTID = REG.CUSTID
                    
                    UNION ALL
                    
                    SELECT REGLL.CUSTID,
                           MAX(REGLL.REACCTNO),
                           REGLL.REFRECFLNKID,
                           REGLL.FULLNAME,
                           REGLL.LEADER,
                           REGLL.FRDATE,
                           REGLL.TODATE
                      FROM (SELECT REGL.CUSTID,
                                   REGL.REACCTNO,
                                   REGL.REFRECFLNKID,
                                   REG.FULLNAME,
                                   CF.FULLNAME LEADER,
                                   REGL.FRDATE,
                                   REGL.TODATE
                              FROM REGRPLNK REGL, REGRP REG, CFMAST CF
                             WHERE REG.AUTOID(+) = REGL.REFRECFLNKID
                               AND CF.CUSTID = REG.CUSTID) REGLL
                     WHERE REGLL.FRDATE <= VT_DATE
                     GROUP BY REGLL.CUSTID,
                              REGLL.REFRECFLNKID,
                              REGLL.FULLNAME,
                              REGLL.LEADER,
                              REGLL.FRDATE,
                              REGLL.TODATE) RE2
             WHERE RE2.CUSTID(+) = RE1.CUSTID
               AND SP_FORMAT_REGRP_MAPCODE(RE2.GROUPID) LIKE V_GROUPID) TB1,
           (SELECT RE.CUSTID,
                   RE.ACCTNO,
                   (RET.ACTYPE || '-' || RET.TYPENAME) AS ACTYPE,
                   RET.AFSTATUS,
                   ALLC.CDCONTENT
              FROM REMAST RE, RETYPE RET, ALLCODE ALLC
             WHERE RET.ACTYPE = RE.ACTYPE
               AND RET.RETYPE = 'D'
               AND RET.REROLE <> 'DG'
               AND ALLC.CDTYPE = 'RE'
               AND ALLC.CDNAME = 'AFSTATUS'
               AND ALLC.CDVAL = RET.AFSTATUS
               AND RET.AFSTATUS = 'N') TBN,
           (SELECT RE.CUSTID,
                   RE.ACCTNO,
                   (RET.ACTYPE || '-' || RET.TYPENAME) AS ACTYPE,
                   RET.AFSTATUS,
                   ALLC.CDCONTENT
              FROM REMAST RE, RETYPE RET, ALLCODE ALLC
             WHERE RET.ACTYPE = RE.ACTYPE
               AND RET.RETYPE = 'D'
               AND RET.REROLE <> 'DG'
               AND ALLC.CDTYPE = 'RE'
               AND ALLC.CDNAME = 'AFSTATUS'
               AND ALLC.CDVAL = RET.AFSTATUS
               AND RET.AFSTATUS = 'O') TBO,
           (SELECT RE.CUSTID,
                   RE.ACCTNO,
                   (RET.ACTYPE || '-' || RET.TYPENAME) AS ACTYPE,
                   RET.AFSTATUS,
                   ALLC.CDCONTENT
              FROM REMAST RE, RETYPE RET, ALLCODE ALLC
             WHERE RET.ACTYPE = RE.ACTYPE
               AND RET.RETYPE = 'D'
               AND RET.REROLE <> 'DG'
               AND ALLC.CDTYPE = 'RE'
               AND ALLC.CDNAME = 'AFSTATUS'
               AND ALLC.CDVAL = RET.AFSTATUS
               AND RET.AFSTATUS = 'D') TBD,
           (SELECT RE.CUSTID,
                   RE.ACCTNO,
                   (RET.ACTYPE || '-' || RET.TYPENAME) AS ACTYPE,
                   RET.AFSTATUS
              FROM REMAST RE, RETYPE RET
             WHERE RET.ACTYPE = RE.ACTYPE
               AND RET.RETYPE = 'D'
               AND RET.REROLE = 'DG') TBCSH,
           (SELECT REG.AUTOID AS GROUPID,
                   (RET.ACTYPE || '-' || RET.TYPENAME) AS ACTYPE,
                   REG.GRPTYPE
              FROM REGRP REG, RETYPE RET
             WHERE RET.ACTYPE = REG.ACTYPE
               AND REG.GRPTYPE = 'M'
               AND RET.RETYPE = 'I') TBIM,
           (SELECT REG.AUTOID AS GROUPID,
                   (RET.ACTYPE || '-' || RET.TYPENAME) AS ACTYPE,
                   REG.GRPTYPE
              FROM REGRP REG, RETYPE RET
             WHERE RET.ACTYPE = REG.ACTYPE
               AND REG.GRPTYPE = 'R'
               AND RET.RETYPE = 'I') TBIR
     WHERE TBN.CUSTID(+) = TB1.CUSTID
       AND TBO.CUSTID(+) = TB1.CUSTID
       AND TBD.CUSTID(+) = TB1.CUSTID
       AND TBCSH.CUSTID(+) = TB1.CUSTID
       AND TBIM.GROUPID(+) = TB1.GROUPID
       AND TBIR.GROUPID(+) = TB1.GROUPID
     ORDER BY TB1.BRID, TB1.LEADER;

EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
 
 
/
