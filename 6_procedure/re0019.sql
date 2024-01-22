SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0019(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   F_MONTH      IN VARCHAR2,
                                   T_MONTH      IN VARCHAR2,
                                   I_BRID       IN VARCHAR2,
                                   RECUSTODYCD  IN VARCHAR2,
                                   GROUPID      IN VARCHAR2) IS
  --Bao Cao Hoa Hong Gian Tiep
  --created by NhaNV PHS at 07/07/2015

  V_STROPTION VARCHAR2(5); -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID   VARCHAR2(60); -- USED WHEN V_NUMOPTION > 0
  V_INBRID    VARCHAR2(5);

  VF_DATE DATE;
  VT_DATE DATE;
  --V_TERMCD VARCHAR2 (7);
  V_CUSTID  VARCHAR2(10);
  V_GROUPID VARCHAR2(10);
  V_IBRID   VARCHAR2(10);

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

  -----------------------

  VF_DATE := TO_DATE(F_MONTH, 'MM/RRRR');
  VT_DATE := LAST_DAY(TO_DATE(T_MONTH, 'MM/RRRR'));

  IF (UPPER(GROUPID) = 'ALL' OR GROUPID IS NULL) THEN
    V_GROUPID := '%';
  ELSE
    V_GROUPID := UPPER(GROUPID);
  END IF;

  /*IF (UPPER(REROLE) = 'ALL' OR REROLE IS NULL) THEN
       V_REROLE := '%';
  ELSE
       V_REROLE := UPPER(REROLE);
  END IF;*/

  IF (UPPER(RECUSTODYCD) = 'ALL' OR RECUSTODYCD IS NULL) THEN
    V_CUSTID := '%';
  ELSE
    V_CUSTID := UPPER(RECUSTODYCD);
  END IF;

  IF (UPPER(I_BRID) = 'ALL' OR I_BRID IS NULL) THEN
    V_IBRID := '%';
  ELSE
    V_IBRID := UPPER(I_BRID);
  END IF;

  OPEN PV_REFCURSOR FOR
  
    SELECT VF_DATE IFDATE,
           VT_DATE ITDATE,
           TO_CHAR(COM.COMMDATE, 'MM/RRRR') COMMONTH,
           SP_FORMAT_REGRP_MAPCODE(GR.AUTOID) GRPID,
           GR.FULLNAME GRPNAME,
           GR.CUSTID || GR.ACTYPE LEADID,
           GL.CUSTID,
           -- GL.REACCTNO,
           RE.CUSTNAME, --|| '_' || GL.REACCTNO CUSTNAME,
           RE.POSITION,
           RE.BRID,
           RE.BRNAME,
           COM.DIRECTACR    DIRECTACR,
           COM.DIRECTFEEACR DIRECTFEEACR,
           COM.COMMISION    DCOMMISION,
           COM1.COMMISION   ICOMMISION,
           COM1.ICRATE,
           COM1.REVENUE
      FROM (SELECT GL.CUSTID,
                   -- GL.REACCTNO REACCTNO,
                   GL.REFRECFLNKID --,
            --    GL.FRDATE,
            --   NVL(GL.CLSTXDATE, GL.TODATE) TODATE
              FROM REGRPLNK GL
             WHERE NVL(GL.CLSTXDATE, GL.TODATE) >= VF_DATE
             GROUP BY GL.CUSTID, GL.REFRECFLNKID) GL
           
          ,
           REGRP GR,
           (SELECT CUSTID,
                   COMMDATE,
                   SUM(DIRECTACR) DIRECTACR,
                   SUM(DIRECTFEEACR) DIRECTFEEACR,
                   SUM(COMMISION) COMMISION
              FROM RECOMMISION
             WHERE RETYPE = 'D'
             GROUP BY CUSTID, COMMDATE) COM,
           (SELECT * FROM RECOMMISION WHERE RETYPE = 'I') COM1,
           
           (SELECT RECF.CUSTID,
                   CF.FULLNAME    CUSTNAME,
                   TL.TLNAME,
                   ALLC.CDCONTENT POSITION,
                   RECF.BRID,
                   BR.BRNAME      BRNAME
              FROM RECFLNK    RECF,
                   BRGRP      BR,
                   ALLCODE    ALLC,
                   TLPROFILES TL,
                   CFMAST     CF
             WHERE BR.BRID = RECF.BRID
               AND TL.TLID = RECF.TLID
               AND ALLC.CDTYPE = 'RE'
               AND ALLC.CDNAME = 'POSITION'
               AND ALLC.CDVAL = RECF.POSITION
               AND CF.CUSTID = RECF.CUSTID
               AND RECF.STATUS = 'A') RE
    
     WHERE GL.REFRECFLNKID = GR.AUTOID
       AND GL.CUSTID = COM.CUSTID
       AND GR.CUSTID || GR.ACTYPE = COM1.CUSTID || COM1.REACTYPE
       AND RE.CUSTID = GL.CUSTID
       AND COM.COMMDATE >= VF_DATE
       AND COM.COMMDATE <= VT_DATE
       AND COM1.COMMDATE >= VF_DATE
       AND COM1.COMMDATE <= VT_DATE
       AND RE.BRID LIKE V_IBRID
       AND GR.CUSTID LIKE V_CUSTID
       AND SP_FORMAT_REGRP_MAPCODE(GR.AUTOID) LIKE V_GROUPID
     ORDER BY RE.BRID, COM.COMMDATE;

EXCEPTION
  WHEN OTHERS THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
    RETURN;
END;
 
 
/
