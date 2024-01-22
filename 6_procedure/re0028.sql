SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0028(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   F_DATE       IN VARCHAR2,
                                   T_DATE       IN VARCHAR2,
                                   I_BRID       IN VARCHAR2,
                                   RECUSTODYCD  IN VARCHAR2,
                                   PV_CUSTODYCD IN VARCHAR2) IS

  --BÁO CÁO LICH SU DIEU CHINH LOAI HINH RE
  --Create by NNha PHS
  --Date create : 19/06/2015
  --Modified

  V_STROPTION VARCHAR2(5);
  V_STRBRID   VARCHAR2(40);
  V_INBRID    VARCHAR2(5);

  VF_DATE     DATE;
  VT_DATE     DATE;
  V_I_BRID    VARCHAR2(10);
  V_PV_CUSTID VARCHAR2(10);
  V_CUSTID    VARCHAR2(10);

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

  -- Tai khoan moi gioi cham soc
  IF UPPER(RECUSTODYCD) <> 'ALL' THEN
    V_CUSTID := RECUSTODYCD;
  ELSE
    V_CUSTID := '%';
  END IF;

  -- From to
  VF_DATE := TO_DATE(F_DATE, 'DD/MM/RRRR');
  VT_DATE := TO_DATE(T_DATE, 'DD/MM/RRRR');

  OPEN PV_REFCURSOR FOR
  
    SELECT VF_DATE FDATE,
           VT_DATE TDATE,
           TLLOGFLD.TXDATE,
           CF.BRID,
           BR.BRNAME,
           TLLOGFLD.RECUSTODYCD MSGACCT,
           CFRE.TLNAME || '_' || CFRE.TLFULLNAME FULLNAME,
           TLLOGFLD.RETYPEOLD,
           TLLOGFLD.RETYPENEW,
           CFRE.CUSTODYCD,
           CFRE.FULLNAME CUSTONAME,
           TLP1.TLNAME || '_' || TLP1.TLFULLNAME TLID,
           TLP2.TLNAME || '_' || TLP2.TLFULLNAME OFFID,
           TLLOGFLD.TXDESC
      FROM (SELECT VTA.TXNUM,
                   VTA.TXDATE,
                   VTA.TLID,
                   VTA.OFFID,
                   MAX(CASE
                         WHEN VTFA.FLDCD = '01' THEN
                          NVL(VTFA.CVALUE, TO_CHAR(VTFA.NVALUE))
                         ELSE
                          ''
                       END) RECUSTODYCD,
                   MAX(CASE
                         WHEN VTFA.FLDCD = '02' THEN
                          NVL(VTFA.CVALUE, TO_CHAR(VTFA.NVALUE))
                         ELSE
                          ''
                       END) RETYPEOLD,
                   MAX(CASE
                         WHEN VTFA.FLDCD = '03' THEN
                          NVL(VTFA.CVALUE, TO_CHAR(VTFA.NVALUE))
                         ELSE
                          ''
                       END) RETYPENEW,
                   MAX(CASE
                         WHEN VTFA.FLDCD = '30' THEN
                          NVL(VTFA.CVALUE, TO_CHAR(VTFA.NVALUE))
                         ELSE
                          ''
                       END) TXDESC
              FROM VW_TLLOG_ALL VTA, VW_TLLOGFLD_ALL VTFA
             WHERE VTA.TXNUM = VTFA.TXNUM
               AND VTA.TXDATE = VTFA.TXDATE
               AND VTA.TXDATE BETWEEN VF_DATE AND VT_DATE
               AND VTA.TLTXCD = '0313'
               AND VTA.DELTD <> 'Y'
             GROUP BY VTA.TXDATE, VTA.TXNUM, VTA.OFFID, VTA.TLID) TLLOGFLD,
           
           (SELECT LNK.TXNUM,
                   LNK.TXDATE,
                   CFCUST.CUSTODYCD,
                   CFCUST.FULLNAME,
                   RF.BRID,
                   RF.BRNAME,
                   RF.CUSTID RECUSTID,
                   RF.TLNAME,
                   RF.TLFULLNAME,
                   SUBSTR(LNK.REACCTNO, 11, 14) RETYPE,
                   LNK.STATUS
              FROM REAFLNK LNK,
                   CFMAST CFCUST,
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
               AND LNK.TXDATE BETWEEN VF_DATE AND VT_DATE
               AND RF.CUSTID = SUBSTR(LNK.REACCTNO, 1, 10)
               AND RET.ACTYPE = SUBSTR(LNK.REACCTNO, 11, 14)
            --AND LNK.STATUS = 'A'
            ) CFRE,
           TLPROFILES TLP1,
           TLPROFILES TLP2,
           CFMAST CF,
           BRGRP BR
     WHERE CFRE.RECUSTID = TLLOGFLD.RECUSTODYCD
       AND CFRE.RETYPE = TLLOGFLD.RETYPENEW
       AND CFRE.TXNUM = TLLOGFLD.TXNUM
       AND CFRE.TXDATE = TLLOGFLD.TXDATE
       AND TLP1.TLID = TLLOGFLD.TLID
       AND TLP2.TLID = TLLOGFLD.OFFID
       AND CF.CUSTID = TLLOGFLD.RECUSTODYCD
       AND CF.BRID = BR.BRID
       AND CF.BRID LIKE V_I_BRID
       AND CFRE.CUSTODYCD LIKE V_PV_CUSTID
       AND TLLOGFLD.RECUSTODYCD LIKE V_CUSTID
     ORDER BY TLLOGFLD.TXDATE, TLLOGFLD.RETYPEOLD, TLLOGFLD.RETYPENEW ASC;

EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
 
 
/
