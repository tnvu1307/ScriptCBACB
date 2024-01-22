SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0029(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   F_DATE       IN VARCHAR2,
                                   T_DATE       IN VARCHAR2,
                                   I_BRID       IN VARCHAR2,
                                   RECUSTODYCD  IN VARCHAR2,
                                   TLTXCD       IN VARCHAR2) IS

  --BAO CAO LICH SU DIEU CHINH DOANH SO
  --Create by NNha PHS
  --Date create : 18/06/2015
  --Modified

  V_STROPTION VARCHAR2(5);
  V_STRBRID   VARCHAR2(40);
  V_INBRID    VARCHAR2(5);
  VF_DATE     DATE;
  VT_DATE     DATE;
  V_I_BRID    VARCHAR2(10);
  V_CUSTID    VARCHAR2(10);
  V_TLTXCD    VARCHAR2(10);
BEGIN
  -- System --
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

  -- Parameters --

  -- Chi nhanh
  IF UPPER(I_BRID) <> 'ALL' THEN
    V_I_BRID := I_BRID;
    --SELECT (BRID || '_' || BRNAME) INTO V_I_BRID_NAME FROM BRGRP BR WHERE BR.BRID = V_I_BRID;
  ELSE
    V_I_BRID := '%';
    --V_I_BRID_NAME := 'ALL';
  END IF;

  -- So luu ky
  /*IF UPPER(PV_CUSTODYCD) <> 'ALL' THEN
    V_PV_CUSTID := PV_CUSTODYCD;
  ELSE
    V_PV_CUSTID := '%';
  END IF;
  */
  -- Tai khoan moi gioi
  IF UPPER(RECUSTODYCD) <> 'ALL' THEN
    V_CUSTID := RECUSTODYCD;
  ELSE
    V_CUSTID := '%';
  END IF;

  -- Ma giao dich dieu chinh
  IF UPPER(TLTXCD) <> 'ALL' THEN
    V_TLTXCD := TLTXCD;
  ELSE
    V_TLTXCD := '%';
  END IF;

  -- From to
  VF_DATE := TO_DATE(F_DATE, 'DD/MM/RRRR');
  VT_DATE := TO_DATE(T_DATE, 'DD/MM/RRRR');

  OPEN PV_REFCURSOR FOR
  
    SELECT VF_DATE FDATE,
           VT_DATE TDATE,
           VWTLLALL.TXDATE,
           CF.BRID,
           BR.BRNAME,
           SUBSTR(VWTLLALL.MSGACCT, 1, 10) MSGACCT,
           CF.FULLNAME,
           VWTLLALL.TLTXCD,
           VWTLLALL.MSGAMT,
           VWTLLALL.TXDESC,
           TLP1.TLNAME || '_' || TLP1.TLFULLNAME TLID,
           TLP2.TLNAME || '_' || TLP2.TLFULLNAME OFFID
    --VWTLLALL.TLID,
    --VWTLLALL.OFFID
      FROM VW_TLLOG_ALL VWTLLALL,
           TLPROFILES   TLP1,
           TLPROFILES   TLP2,
           BRGRP        BR,
           CFMAST       CF
     WHERE VWTLLALL.TXDATE BETWEEN VF_DATE AND VT_DATE
       AND VWTLLALL.TLTXCD IN ('0310', '0311', '0312')
       AND VWTLLALL.DELTD <> 'Y'
       AND TLP1.TLID = VWTLLALL.TLID
       AND TLP2.TLID = VWTLLALL.OFFID
       AND BR.BRID = CF.BRID
       AND CF.CUSTID = SUBSTR(VWTLLALL.MSGACCT, 1, 10)
       AND SUBSTR(VWTLLALL.MSGACCT, 1, 10) LIKE V_CUSTID
       AND VWTLLALL.TLTXCD LIKE V_TLTXCD
       AND CF.BRID LIKE V_I_BRID
     ORDER BY VWTLLALL.TXDATE ASC;

EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
 
 
/
