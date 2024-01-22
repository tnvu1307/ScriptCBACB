SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ea6001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   P_ESCROW       IN       VARCHAR2
)
IS
    v_CreateDate     DATE;
    V_ESCROW   VARCHAR2 (10);
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
    v_CreateDate := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    --v_ToDate := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    -----
    IF P_ESCROW IS NULL OR P_ESCROW ='ALL'
    THEN
        V_ESCROW := '%';
    ELSE
        V_ESCROW := P_ESCROW;
    END IF;
 OPEN PV_REFCURSOR
 FOR
    SELECT
        v_CreateDate createdate,
        e.escrowid, --so hop dong
        e.sfullname, --ten ben chuyen nhuong
        cf.address saddress,--dia chi
        al.cdcontent scdcontent, --chuc vu
        cf.email semail,
        cf.faxno sfaxno,
        e.bfullname, --ten ben nhan chuyen nhuong
        cf1.address baddress,
        alc.cdcontent bcdcontent,
        cf1.email bemail,
        cf1.faxno bfaxno,
        e.signdate, --ngay ky
        --TO_CHAR(UTILS.SO_THANH_CHU(NVL(e.blkamt,0))) blkamt,
        --TO_CHAR(UTILS.SO_THANH_CHU(NVL(e.blkamt,0))) blkamtvn,--so tien phong toa
        --UTILS.FNC_NUMBER2WORK(e.blkamt) blkamten,
        (DECODE(tllog.time1,'','',TO_CHAR(UTILS.SO_THANH_CHU(NVL(e.blkamt,0))))) blkamt,
        nvl((DECODE(tllog.time1,'','',TO_CHAR(UTILS.SO_THANH_CHU(NVL(e.blkamt,0))))),0) blkamtvn,--so tien phong toa
        (DECODE(tllog.time1,'','',UTILS.FNC_NUMBER2WORK(e.blkamt))) blkamten,
        (DECODE(tllog.time2,'','',e.blockedqtty)) blockedqtty,
        e.bddacctno_escrow, --so tk tien  escrow
        dd.refcasaacct,
        cf.cifid,
        SUBSTR(tllog.time1,1,5) txtimemoney, --thoi gian phong toa tien
        SUBSTR(tllog.time2,1,5) txtimestock --thoi gian phong toa chung khoan
        from (cfmast cf left join (SELECT * FROM ALLCODE WHERE CDNAME='POSITION' AND CDTYPE ='CF') al on cf.position = al.cdval),
        (cfmast cf1 left join (SELECT * FROM ALLCODE WHERE CDNAME='POSITION' AND CDTYPE ='CF') alc on cf1.position = alc.cdval),
        escrow e, ddmast dd,
                (select a.cvalue escrowid1 ,b.cvalue escrowid2,a.txtime time1,b.txtime time2,a.txdate txdate1, b.txdate txdate2 from
                (select b.cvalue,a.txtime txtime, a.txdate from vw_tllog_all a, vw_tllogfld_all b
                where a.tltxcd ='1102' and a.txdate = b.txdate and a.txnum = b.txnum and b.fldcd ='01')a FULL OUTER JOIN
                (select b.cvalue,a.txtime txtime, a.txdate from vw_tllog_all a, vw_tllogfld_all b
                where a.tltxcd ='1101' and a.txdate = b.txdate and a.txnum = b.txnum and b.fldcd ='01') b
                on a.cvalue = b.cvalue and a.txdate = b.txdate) tllog
        where e.scustid = cf.custid and e.bcustid = cf1.custid
        and (e.escrowid = tllog.escrowid1 or e.escrowid = tllog.escrowid2)
        and dd.acctno = e.bddacctno_escrow
        and (tllog.escrowid1 like v_CreateDate or tllog.txdate2 like v_CreateDate)
        and e.escrowid like V_ESCROW;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('EA6001: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
