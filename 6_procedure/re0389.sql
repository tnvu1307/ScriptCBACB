SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0389(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   F_DATE       IN VARCHAR2,
                                   T_DATE       IN VARCHAR2,
                                   --I_BRID       IN VARCHAR2,
                                   RECUSTODYCD IN VARCHAR2) IS
  --PV_CUSTODYCD IN VARCHAR2)

  --BÁO CÁO LICH SU DIEU CHINH LUONG
  --Create by NNha PHS
  --Date create : 22/06/2015
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
  /*IF UPPER(I_BRID) <> 'ALL' THEN
    V_I_BRID := I_BRID;
    --SELECT (BRID || '_' || BRNAME) INTO V_I_BRID_NAME FROM BRGRP BR WHERE BR.BRID = V_I_BRID;
  ELSE
    V_I_BRID := '%';
    --V_I_BRID_NAME := 'ALL';
  END IF;*/

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

  -- From to
  VF_DATE := TO_DATE(F_DATE, 'DD/MM/RRRR');
  VT_DATE := TO_DATE(T_DATE, 'DD/MM/RRRR');

  OPEN PV_REFCURSOR FOR
  
    SELECT VF_DATE FDATE,
           VT_DATE TDATE,
           VTAF.TXNUM,
           VTAF.TXDATE,
           TLP1.TLNAME || '_' || TLP1.TLFULLNAME TLID,
           TLP2.TLNAME || '_' || TLP2.TLFULLNAME OFFID,
           VTAF.REVIEWID,
           VTAF.TRADEVALUEAVG,
           VTAF.FEEINCOMEINVESNEW,
           VTAF.RECUSTODYCD,
           VTAF.RECUSTODYNAME,
           VTAF.INCREASE,
           VTAF.SALARYOLD,
           VTAF.SALARYNEW,
           VTAF.TXDESC
      FROM (SELECT *
              FROM VW_TLLOG_ALL
             WHERE TLTXCD = '0387'
               AND DELTD <> 'Y'
               AND TXDATE >= VF_DATE
               AND TXDATE <= VT_DATE) VTLA,
           
           (SELECT VTA.TXNUM,
                   VTA.TXDATE,
                   MAX(CASE
                         WHEN VTA.FLDCD = '02' THEN
                          NVL(VTA.CVALUE, TO_CHAR(VTA.NVALUE))
                         ELSE
                          ''
                       END) REVIEWID,
                   MAX(CASE
                         WHEN VTA.FLDCD = '15' THEN
                          NVL(VTA.CVALUE, TO_CHAR(VTA.NVALUE))
                         ELSE
                          ''
                       END) TRADEVALUEAVG,
                   MAX(CASE
                         WHEN VTA.FLDCD = '16' THEN
                          NVL(VTA.CVALUE, TO_CHAR(VTA.NVALUE))
                         ELSE
                          ''
                       END) FEEINCOMEINVESNEW,
                   MAX(CASE
                         WHEN VTA.FLDCD = '07' THEN
                          NVL(VTA.CVALUE, TO_CHAR(VTA.NVALUE))
                         ELSE
                          ''
                       END) RECUSTODYCD,
                   MAX(CASE
                         WHEN VTA.FLDCD = '08' THEN
                          NVL(VTA.CVALUE, TO_CHAR(VTA.NVALUE))
                         ELSE
                          ''
                       END) RECUSTODYNAME,
                   MAX(CASE
                         WHEN VTA.FLDCD = '10' THEN
                          NVL(VTA.CVALUE, TO_CHAR(VTA.NVALUE))
                         ELSE
                          ''
                       END) INCREASE,
                   MAX(CASE
                         WHEN VTA.FLDCD = '11' THEN
                          NVL(VTA.CVALUE, TO_CHAR(VTA.NVALUE))
                         ELSE
                          ''
                       END) SALARYOLD,
                   MAX(CASE
                         WHEN VTA.FLDCD = '12' THEN
                          NVL(VTA.CVALUE, TO_CHAR(VTA.NVALUE))
                         ELSE
                          ''
                       END) SALARYNEW,
                   MAX(CASE
                         WHEN VTA.FLDCD = '30' THEN
                          NVL(VTA.CVALUE, TO_CHAR(VTA.NVALUE))
                         ELSE
                          ''
                       END) TXDESC
            
              FROM (SELECT *
                      FROM VW_TLLOGFLD_ALL
                     WHERE TXDATE >= VF_DATE
                       AND TXDATE <= VT_DATE) VTA,
                   (SELECT *
                      FROM FLDMASTER
                     WHERE OBJNAME = '0387'
                       AND MODCODE = 'RE') FDM
             WHERE FDM.FLDNAME = VTA.FLDCD
             GROUP BY VTA.TXNUM, VTA.TXDATE) VTAF,
           
           TLPROFILES TLP1,
           TLPROFILES TLP2
     WHERE VTAF.TXNUM = VTLA.TXNUM
       AND VTAF.TXDATE = VTLA.TXDATE
       AND TLP1.TLID = VTLA.TLID
       AND TLP2.TLID = VTLA.TLID
       AND NVL(VTAF.RECUSTODYCD, ' ') LIKE V_CUSTID;

EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
 
 
/
