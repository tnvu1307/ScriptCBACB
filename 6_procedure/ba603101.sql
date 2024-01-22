SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba603101(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2,
   PV_CONTRACT            IN       VARCHAR2,
   PV_SYMBOL              IN       VARCHAR2,
    PV_CUSTODYCD           IN       VARCHAR2
   )
IS
    V_STROPTION           VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID             VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    V_IDATE               DATE;
    V_CURRDATE            DATE;
    V_ISSUER              VARCHAR(50);
    V_CONTRACTNO          VARCHAR(50);
    V_SYMBOL              VARCHAR(50);
    V_CUSTODYCD           VARCHAR2 (15);
    V_PREVDATE              DATE;
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
     IF(PV_SYMBOL='ALL') THEN
        V_SYMBOL:='%';
     ELSE
        V_SYMBOL:=PV_SYMBOL;
     END IF;
     IF  (PV_CUSTODYCD = 'ALL') THEN
        V_CUSTODYCD := '%';
     ELSE
        V_CUSTODYCD := PV_CUSTODYCD;
     END IF;
     IF  (PV_CONTRACT = 'ALL') THEN
        V_CONTRACTNO := '%';
     ELSE
        V_CONTRACTNO := PV_CONTRACT;
     END IF;
     V_IDATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_PREVDATE :=getprevdate(V_IDATE,1);
OPEN PV_REFCURSOR FOR
      select * from (SELECT CF.FULLNAME,             --TEN KH
            a1.cdcontent CUSTTYPE,
            (CASE WHEN CF.COUNTRY ='234' THEN CF.IDCODE ELSE CF.TRADINGCODE END) IDCODE,
            (CASE WHEN CF.COUNTRY ='234' THEN CF.IDDATE ELSE CF.TRADINGCODEDT END) IDDATE,
            CF.IDPLACE,             --NOI CAP GIAY TO
            CF.ADDRESS,             --DIA CHI KH
            BSE.QTTY TRADE,       --SL TRAI PHIEU NAM GIU CUA TRAI CHU TAI NGAY TAO BAO CAO
            sb.parvalue,
            BSE.QTTY*sb.parvalue amount,
            BSE.BONDSYMBOL,         --MA TRAI PHIEU NAM GIU
            SB.ISSUEDATE,            -- NGAY PHAT HANH
            cth.bankacc,cth.bankacname,cth.bankname
        FROM SBSECURITIES SB, ISSUERS ISS, CFMAST CF,allcode a1,
        (select * from cfotheracc where defaultacct ='Y' and deltd <> 'Y') cth,
        (
            SELECT BO.* , (BO.TRADE - NVL(TRANC.CAMT,0) + NVL(TRAND.DAMT,0)) QTTY
            FROM (select iss.issuerid ,iss.issuecode,iss.valueofissue,iss.issuedate,bse.* 
            from ISSUES ISS ,BONDISSUE BISS,BONDSEMAST BSE
            where iss.autoid =biss.issuesid and biss.bondcode=BSE.bondcode 
            AND ISS.issuecode LIKE V_CONTRACTNO) BO,
            (
                 SELECT A.ACCTNO, NVL(SUM(A.NAMT), 0) CAMT
                 FROM VW_BONDTRAN A, APPTX APP
                 WHERE A.TXCD = APP.TXCD
                 AND APP.TXTYPE = 'C'
                 AND A.BKDATE > V_PREVDATE
                 AND A.DELTD <> 'Y'
                 GROUP BY A.ACCTNO
            ) TRANC,
            (    SELECT A.ACCTNO,NVL(SUM(A.NAMT), 0) DAMT
                 FROM VW_BONDTRAN A, APPTX APP
                 WHERE A.TXCD = APP.TXCD
                 AND APP.TXTYPE = 'D'
                 AND A.BKDATE > V_PREVDATE
                 AND A.DELTD <> 'Y'
                 GROUP BY A.ACCTNO
            ) TRAND
            WHERE BO.ACCTNO = TRANC.ACCTNO(+)
            AND BO.ACCTNO = TRAND.ACCTNO(+)
        ) BSE
        WHERE  BSE.BONDCODE= SB.CODEID
        AND BSE.CUSTODYCD = CF.CUSTODYCD
        and cf.custid = cth.cfcustid(+) 
        and a1.cdtype = 'CF' and a1.cdname = 'CUSTTYPE' and a1.cdval = cf.custtype
        AND SB.ISSUERID = ISS.ISSUERID
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
       AND SB.SYMBOL LIKE V_SYMBOL
    ) where trade <> 0;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('BA603101: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END BA603101;
/
