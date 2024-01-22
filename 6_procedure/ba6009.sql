SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba6009(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,

   I_DATE                 IN       VARCHAR2,
   PV_ISSUERS             IN       VARCHAR2,
   P_ISSUECODE           IN       VARCHAR2,
   P_DATE                 IN       VARCHAR2,
   P_TAX                  IN       VARCHAR2
   )
IS
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    V_PDATE         DATE;
    V_IDATE         DATE;
    V_currdate      DATE;
    V_ISSUER        VARCHAR(20);
    V_CONTRACTNO    VARCHAR(20);
    V_ISSUECODE        VARCHAR(20);
    V_CHECK        NUMBER;
BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;

    V_currdate := GETCURRDATE;


    V_ISSUER:= PV_ISSUERS;
    V_ISSUECODE:= P_ISSUECODE;
    V_PDATE := TO_DATE(P_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_IDATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    -----------------------
OPEN PV_REFCURSOR FOR
SELECT DISTINCT
         SB.SYMBOL, -- MA TRAI PHIEU
         ISS.FULLNAME FULLNAMEBOND, -- TEN TCPH
         SB.ISSUEDATE, -- NGAY PHAT HANH
         SB.EXPDATE, --NGAY HET HAN
         SB.MATURITYDATE, -- NGAY DAO HAN
         TO_CHAR(UTILS.SO_THANH_CHU(NVL(SB.VALUEOFISSUE,0))) AS VALUEOFISSUE, -- GIA TRI PHAT HANH
         SB.INTCOUPON  INTCOUPON,        -- LAI SUAT TP
         CASE WHEN P_TAX ='N' THEN 0 ELSE 5 END TAX,        --THUE
         CF.FULLNAME, -- TEN KH
         (CASE WHEN CF.COUNTRY ='234' THEN CF.IDCODE ELSE CF.TRADINGCODE END) IDCODE,
         (BSE.TRADE -  NVL(SO_DU_QK,0)) TRADE, --SL NAM GIU NGAY TAO BAO CAO
         --DD.CCYCD, --DON VI TIEN TE
         SBC.SHORTCD CCYCD,
         SB.PARVALUE, --MANH GIA
         ((BSE.TRADE -  NVL(SO_DU_QK,0)) * SB.PARVALUE) SVALUE, --TONG GIA TRI
         BTP.BEGINDATE,--NGAY BAT DAU TINH LAI
         BTP.PAYMENTDATE,-- NGAY THANH TOAN
         (BTP.PAYMENTDATE - BTP.BEGINDATE) SDATE,--SO NGAY LAI
         --ROUND(((((BSE.TRADE -  NVL(SO_DU_QK,0)) * SB.PARVALUE) * (BTP.PAYMENTDATE - BTP.BEGINDATE) *  SB.INTCOUPON )/ SB.INTERESTDATE),4) INTERSET,--LAI
         round(((BSE.TRADE -  NVL(SO_DU_QK,0))* SB.PARVALUE) *((BTP.PAYMENTDATE - BTP.BEGINDATE)/SB.INTERESTDATE) * SB.INTCOUPON /100,0) INTERSET,--LAI
         CFO.BANKACNAME AS FULLNAMEACC
         ,(CASE WHEN SUBSTR(CF.CUSTODYCD,1,3) = 'SHV' THEN  NVL(DD.REFCASAACCT, CFO.BANKACC) ELSE CFO.BANKACC END) SOACC
         ,CFO.CRBANKNAME BANKACC
        FROM SBSECURITIES SB, ISSUERS ISS, ISSUES ISE, BONDSEMAST BSE, CFMAST CF, BONDTYPEPAY BTP, BONDISSUE BI,
            (
                SELECT * FROM SBCURRENCY WHERE CCYCD = '00'
            ) SBC,
            (
                SELECT * FROM DDMAST WHERE STATUS NOT IN ('C') AND ISDEFAULT = 'Y'
            ) DD,
            (
                SELECT CFO.*, (CASE WHEN NVL(TRIM(CFO.CITYBANK),'--') = '--' THEN CFO.BANKNAME ELSE CFO.BANKNAME || ' - ' || CFO.CITYBANK END) CRBANKNAME
                FROM CFOTHERACC CFO, CRBBANKLIST CR
                WHERE CFO.BANKCODE = CR.CITAD(+)
                AND CFO.DEFAULTACCT ='Y'
                AND NVL(CFO.DELTD,'N') = 'N'
            ) CFO,
                -------------------LAY SO DU QUA KHU----------------
            (
                SELECT ACCTNO,TXCD,SUM(NAMT) SO_DU_QK
                FROM (

                        SELECT BO.TXDATE,ACCTNO,TXCD,TRDESC,
                               (CASE WHEN TXCD = '1902' THEN BO.NAMT ELSE -BO.NAMT END) NAMT
                        FROM BONDSETRAN BO
                        WHERE BO.TXDATE > V_IDATE
                    )
                GROUP BY ACCTNO, TXCD
            )BO------------------------------------------------
        WHERE   SB.CODEID = BI.BONDCODE
            AND BI.ISSUESID = ISE.AUTOID
            AND ISS.ISSUERID = ISE.ISSUERID
            AND BI.BONDCODE = BSE.BONDCODE
            AND BSE.AFACCTNO = CF.CUSTID
            AND BSE.BONDCODE = BTP.BONDCODE
            AND BSE.AFACCTNO = DD.AFACCTNO(+)
            AND CF.CUSTID = CFO.CFCUSTID(+)
            AND BSE.ACCTNO = BO.ACCTNO(+)
            AND ISS.SHORTNAME LIKE PV_ISSUERS
            AND ISE.ISSUECODE LIKE V_ISSUECODE
            AND BTP.PAYMENTDATE = V_PDATE
            AND (BSE.TRADE -  NVL(SO_DU_QK,0)) <> 0
        ;
--END IF;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('BA6009: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
