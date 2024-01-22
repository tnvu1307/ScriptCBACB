SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0386(PV_REFCURSOR  IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT           IN VARCHAR2,
                                   BRID          IN VARCHAR2,
                                   F_DATE        IN VARCHAR2,
                                   T_DATE        IN VARCHAR2,
                                   I_BRID        IN VARCHAR2,
                                   PV_CUSTODYCD  IN VARCHAR2,
                                   O_RECUSTODYCD IN VARCHAR2,
                                   N_RECUSTODYCD IN VARCHAR2) IS

  --Bao Cao BÁO CÁO KHÁCH HÀNG MO MOI
  --Create by NNha PHS
  --Date create : 18/06/2015
  --Modified

  V_STROPTION VARCHAR2(5);
  V_STRBRID   VARCHAR2(40);
  V_INBRID    VARCHAR2(5);
  VF_DATE     DATE;
  VT_DATE     DATE;
  V_I_BRID    VARCHAR2(10);
  V_PV_CUSTID VARCHAR2(10);
  V_CUSTID_O  VARCHAR2(10);
  V_CUSTID_N  VARCHAR2(10);
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
  IF UPPER(PV_CUSTODYCD) <> 'ALL' THEN
    V_PV_CUSTID := PV_CUSTODYCD;
  ELSE
    V_PV_CUSTID := '%';
  END IF;

  -- Tai khoan moi gioi cham soc ban dau
  IF UPPER(O_RECUSTODYCD) <> 'ALL' THEN
    V_CUSTID_O := O_RECUSTODYCD;
  ELSE
    V_CUSTID_O := '%';
  END IF;

  -- Tai khoan moi gioi cham soc hien tai
  IF UPPER(N_RECUSTODYCD) <> 'ALL' THEN
    V_CUSTID_N := N_RECUSTODYCD;
  ELSE
    V_CUSTID_N := '%';
  END IF;

  -- From to
  VF_DATE := TO_DATE(F_DATE, 'DD/MM/RRRR');
  VT_DATE := TO_DATE(T_DATE, 'DD/MM/RRRR');

  OPEN PV_REFCURSOR FOR
  
    SELECT VF_DATE FDATE,
           VT_DATE TDATE,
           BROKERSECOND.BRID,
           BROKERSECOND.BRNAME,
           CF.CUSTODYCD,
           CF.FULLNAME,
           ALLC.CDCONTENT CUSTOMERTYPE,
           TO_CHAR(CF.OPNDATE, 'dd/mm/yyyy') OPNDATE,
           ODALL.MINDATE TXDATE_MIN,
           ODALL.MAXDATE TXDATE_MAX,
           NVL(BROKERFIRST.TLNAME, BROKERSECOND.TLNAME) BROKERID_FIRST,
           NVL(BROKERFIRST.TLFULLNAME, BROKERSECOND.TLFULLNAME) BROKERNAME_FIRST,
           NVL(BROKERSECOND.TLNAME, ' ') BROKERID_SECOND,
           NVL(BROKERSECOND.TLFULLNAME, ' ') BROKERNAME_SECOND,
           BROKERSECOND.RETYPE,
           ODALL.EXECAMT,
           ODALL.FEEACR
      FROM CFMAST CF,
           (SELECT *
              FROM ALLCODE
             WHERE CDTYPE = 'CF'
               AND CDNAME = 'CUSTTYPE') ALLC,
           (SELECT CF.CUSTODYCD,
                   MAX(OD.TXDATE) MAXDATE,
                   MIN(OD.TXDATE) MINDATE,
                   SUM(NVL(OD.EXECAMT, 0)) EXECAMT,
                   SUM(NVL(DECODE(OD.FEEAMT,
                                  0,
                                  DECODE(OD.FEEACR,
                                         0,
                                         OD.EXECAMT * ODT.DEFFEERATE / 100,
                                         OD.FEEACR)),
                           OD.FEEAMT)) FEEACR
              FROM VW_ODMAST_ALL OD, ODTYPE ODT, AFMAST AF, CFMAST CF
             WHERE ODT.ACTYPE = OD.ACTYPE
               AND OD.AFACCTNO = AF.ACCTNO
               AND AF.CUSTID = CF.CUSTID
               AND OD.TXDATE BETWEEN VF_DATE AND VT_DATE
               AND OD.DELTD <> 'Y'
             GROUP BY CF.CUSTODYCD) ODALL,
           (SELECT CFCUST.CUSTODYCD,
                   RF.CUSTID RECUSTID,
                   RF.TLNAME,
                   RF.TLFULLNAME,
                   (RE.ACTYPE || '_' || RET.TYPENAME) RETYPE
              FROM REAFLNK LNK,
                   (SELECT *
                      FROM CFMAST
                     WHERE OPNDATE BETWEEN VF_DATE AND VT_DATE) CFCUST,
                   REMAST RE,
                   RETYPE RET,
                   (SELECT TL.TLNAME,
                           TL.TLFULLNAME,
                           RECF.CUSTID,
                           BR.BRNAME,
                           RECF.AUTOID
                      FROM RECFLNK RECF, TLPROFILES TL, BRGRP BR
                     WHERE RECF.TLID = TL.TLID
                       AND BR.BRID = TL.BRID) RF
             WHERE CFCUST.CUSTID = LNK.AFACCTNO
               AND RET.ACTYPE = RE.ACTYPE
               AND LNK.STATUS = 'C'
               AND RE.CUSTID = RF.CUSTID
               AND RE.ACCTNO = LNK.REACCTNO
               AND LNK.AUTOID = (SELECT MIN(AUTOID)
                                   FROM REAFLNK
                                  WHERE AFACCTNO = CFCUST.CUSTID
                                    AND DELTD = 'N')) BROKERFIRST,
           (SELECT CFCUST.CUSTODYCD,
                   RF.BRID,
                   RF.BRNAME,
                   RF.CUSTID RECUSTID,
                   RF.TLNAME,
                   RF.TLFULLNAME,
                   SUBSTR(LNK.REACCTNO, 11, 14) || '_' || RET.TYPENAME RETYPE,
                   LNK.STATUS
              FROM REAFLNK LNK,
                   (SELECT *
                      FROM CFMAST
                     WHERE OPNDATE BETWEEN VF_DATE AND VT_DATE) CFCUST,
                   
                   (SELECT TL.BRID,
                           BR.BRNAME,
                           TL.TLNAME,
                           TL.TLFULLNAME,
                           RECF.CUSTID,
                           RECF.AUTOID
                      FROM RECFLNK RECF, TLPROFILES TL, BRGRP BR
                     WHERE RECF.TLID = TL.TLID
                       AND BR.BRID = TL.BRID) RF,
                   RETYPE RET
             WHERE CFCUST.CUSTID = LNK.AFACCTNO
               AND RF.CUSTID = SUBSTR(LNK.REACCTNO, 1, 10)
               AND RET.ACTYPE = SUBSTR(LNK.REACCTNO, 11, 14)
               AND LNK.STATUS = 'A') BROKERSECOND
     WHERE ODALL.CUSTODYCD(+) = CF.CUSTODYCD
       AND BROKERFIRST.CUSTODYCD(+) = CF.CUSTODYCD
       AND BROKERSECOND.CUSTODYCD(+) = CF.CUSTODYCD
       AND NVL(BROKERSECOND.BRID, ' ') LIKE '%'
       AND CF.OPNDATE BETWEEN VF_DATE AND VT_DATE
       AND CF.CUSTODYCD LIKE V_PV_CUSTID
       AND NVL(BROKERFIRST.CUSTODYCD, BROKERSECOND.CUSTODYCD) LIKE
           V_CUSTID_O
       AND NVL(BROKERSECOND.CUSTODYCD, ' ') LIKE V_CUSTID_N
       AND ALLC.CDVAL = CF.CUSTTYPE
     ORDER BY CF.OPNDATE ASC;

EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
 
 
/
