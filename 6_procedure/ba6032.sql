SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba6032(
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
    SELECT distinct BONDSYMBOL,to_char(CREATEDATE,'DD/MM/RRRR')CREATEDATE,CONTRACT,FULLNAMEBOND,BNDTYPE,GPDKKD,ADDRESS,PERIODINTEREST,TERM,
    CONTRACTNO,CONTRACTDATE,THIRDPARTNER,to_char(ISSUEDATE,'DD/MM/RRRR')ISSUEDATE,to_char(EXPDATE,'DD/MM/RRRR')EXPDATE,VALUEOFISSUE,PARVALUE,INTCOUPON
    FROM(
    SELECT  BSE.BONDSYMBOL,
            V_IDATE CREATEDATE,
            PV_CONTRACT CONTRACT,
            ISS.EN_FULLNAME FULLNAMEBOND,    --TEN TCPH
            ISS.ADDRESS,
            SB.CONTRACTNO,                --SO HOP DONG
            SB.CONTRACTDATE,              --NGAY HOP DONG
            SB.THIRDPARTNER,
            ISS.LICENSENO GPDKKD,
             A2.en_cdcontent PERIODINTEREST,
            SB.ISSUEDATE,                 -- NGAY PHAT HANH
            SB.EXPDATE,                   -- NGAY DAO HAN
            sb.TERM,
            BSE.BNDTYPE,                --BondType
            TO_CHAR(UTILS.SO_THANH_CHU(NVL(BSE.VALUEOFISSUE,0))) || '('||UTILS.FNC_NUMBER2WORK(NVL(BSE.VALUEOFISSUE,0),'Viet Nam Dong')||')' VALUEOFISSUE, --GIA TRI PHAT HANH
            TO_CHAR(UTILS.SO_THANH_CHU(NVL(SB.PARVALUE,0))) || '('||UTILS.FNC_NUMBER2WORK(NVL(SB.PARVALUE,0),'Viet Nam Dong')||')' PARVALUE,                  -- MENH GIA
            SB.INTCOUPON                  -- LAI SUAT
        FROM SBSECURITIES SB, ISSUERS ISS,ALLCODE A2, CFMAST CF,CFMAST CF2,
        (
            SELECT BO.* , (BO.TRADE - NVL(TRANC.CAMT,0) + NVL(TRAND.DAMT,0)) QTTY
            FROM (select iss.issuerid ,iss.issuecode,iss.valueofissue,iss.issuedate,bse.* ,a1.en_cdcontent BNDTYPE
            from ISSUES ISS ,BONDISSUE BISS,BONDSEMAST BSE,ALLCODE A1
            where iss.autoid =biss.issuesid and biss.bondcode=BSE.bondcode 
            and a1.cdname='BONDTYPE' and a1.cdtype='SA' and a1.cdval=biss.bondtype
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
        WHERE BSE.QTTY > 0
        AND BSE.BONDCODE= SB.CODEID
        and a2.cdtype = 'CB' and a2.cdname = 'PERIODINTEREST' and a2.cdval = sb.periodinterest
        AND BSE.CUSTODYCD = CF.CUSTODYCD
        AND SB.ISSUERID = ISS.ISSUERID
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND SB.SYMBOL LIKE V_SYMBOL
         AND ISS.CUSTID=CF2.CUSTID (+)
        ) BA;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('BA6032: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
