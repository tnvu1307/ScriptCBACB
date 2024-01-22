SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba6022(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2,
   T_DATE                 IN       VARCHAR2,
   P_ISSUECODE              IN       VARCHAR2,
   PV_TXNUM               IN       VARCHAR2,
   PV_REPORTNO            IN       VARCHAR2
   )
IS
-- PERSON    DATE          COMMENTS
-- NAM.LY    17-FEB-2020   ADD
    V_STROPTION     VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID       VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    V_TODATE        DATE;
    V_FROMDATE      DATE;
    V_CURRDATE      DATE;
    V_ISSUECODE        VARCHAR2(20);
    V_TXNUM         VARCHAR2(10);
    V_REPORTNO      VARCHAR2(10);
BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
    V_CURRDATE := GETCURRDATE;
    --
    IF(PV_TXNUM='ALL') THEN
        V_TXNUM:='%';
    ELSE
        V_TXNUM:=PV_TXNUM;
    END IF;
    --
    V_ISSUECODE     :=  P_ISSUECODE;
    V_FROMDATE      :=  TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_TODATE        :=  TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_REPORTNO      :=  PV_REPORTNO;
OPEN PV_REFCURSOR FOR
            SELECT V_CURRDATE CREATED_DATE,
                   (CASE WHEN V_REPORTNO IS NULL THEN '...../' ELSE V_REPORTNO||'/' END)||TO_CHAR(V_CURRDATE,'YYYY')||'/SSD-SHBVN' REPORTING_NO,
                   BST.TXNUM,                   --SO CHUNG TU
                   BST.TXDATE,                  --NGAY GIAO DICH
                   BST.BKDATE,                  --NGAY CHUNG TU
                   BSM.BONDCODE,                --MA QUY UOC TP
                   SB.SYMBOL,                   --MA TP
                   A1.CDCONTENT SECTYPE_NAME,   --LOAI CHUNG KHOAN
                   SB.THIRDPARTNER,             --
                   ISS.FULLNAME ISSFULLNAME,    --TEN TCPH
                   MST.CONTRACTNO,               --SO HOP DONG DAI LY
                   MST.CONTRACTDATE,             --NGAY HOP DONG TRAI PHIEU
                   MST1.CONTRACTNO CONTRACTNO1,
                   MST1.CONTRACTDATE CONTRACTDATE1,
                   BST.NAMT QTTY                --SO LUONG CHUYEN NHUONG
            FROM  BONDSETRAN BST, BONDSEMAST BSM, SBSECURITIES SB, ALLCODE A1, ISSUERS ISS, ISSUES IE, BONDISSUE BI,(SELECT ISS.ISSUECODE,ISS.ISSUERID,BI.BONDCODE,MST.CONTRACTNO,MST.CONTRACTDATE FROM ISSUER_CONTRACTNO MST, ISSUES ISS,BONDISSUE BI
                                        WHERE ISS.AUTOID = MST.ISSUESID AND BI.ISSUESID = ISS.AUTOID
                                        AND MST.CONTRACTTYPE='003')MST,(SELECT ISS.ISSUECODE,ISS.ISSUERID,BI.BONDCODE,MST.CONTRACTNO,MST.CONTRACTDATE FROM ISSUER_CONTRACTNO MST, ISSUES ISS,BONDISSUE BI
                                        WHERE ISS.AUTOID = MST.ISSUESID AND BI.ISSUESID = ISS.AUTOID
                                        AND MST.CONTRACTTYPE='001')MST1
            WHERE BST.TXCD = '1903' AND
                  BST.ACCTNO = BSM.ACCTNO AND
                  BSM.BONDCODE = SB.CODEID AND
                  BST.TLTXCD ='1911' AND
                  A1.CDNAME ='SECTYPE' AND A1.CDVAL = SB.SECTYPE AND
                  A1.CDTYPE ='SA' AND
                  SB.ISSUERID = ISS.ISSUERID AND
                  BSM.BONDCODE = BI.BONDCODE AND
                  IE.AUTOID = BI.ISSUESID AND
                  BST.TXNUM LIKE V_TXNUM AND
                  IE.ISSUECODE LIKE V_ISSUECODE AND
                  BST.BKDATE BETWEEN V_FROMDATE AND V_TODATE
                  AND ISS.ISSUERID=MST.ISSUERID (+)
                  AND BI.BONDCODE=MST.BONDCODE (+)
                  AND ISS.ISSUERID=MST1.ISSUERID (+)
                  AND BI.BONDCODE=MST1.BONDCODE (+)
                  ;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('BA6022: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
