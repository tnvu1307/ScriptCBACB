SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba6001(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2,
   --PV_CUSTODYCD           IN       VARCHAR2,
   PV_CONTRACT            IN       VARCHAR2,
   PV_SYMBOL              IN       VARCHAR2
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
     /*IF  (PV_CUSTODYCD = 'ALL') THEN
        V_CUSTODYCD := '%';
     ELSE
        V_CUSTODYCD := PV_CUSTODYCD;
     END IF;*/
     IF  (PV_CONTRACT = 'ALL') THEN
        V_CONTRACTNO := '%';
     ELSE
        V_CONTRACTNO := PV_CONTRACT;
     END IF;
     V_IDATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
OPEN PV_REFCURSOR FOR
    SELECT BONDSYMBOL,CREATEDATE,CONTRACT,SECTYPE,FULLNAMEBOND,CONTRACTNO,CONTRACTDATE,THIRDPARTNER,ISSUEDATE,EXPDATE,VALUEOFISSUE,PARVALUE,INTCOUPON
    FROM(
    SELECT  BSE.BONDSYMBOL,
            V_IDATE CREATEDATE,
            PV_CONTRACT CONTRACT,
			SB.SECTYPE,
            ISS.FULLNAME FULLNAMEBOND,    --TEN TCPH
            MST.CONTRACTNO,                --SO HOP DONG AGENCY AGREEMENT (111706)
            MST.CONTRACTDATE,              --NGAY HOP DONG  AGENCY AGREEMENT (111706)
            SB.THIRDPARTNER,
            SB.ISSUEDATE,                 -- NGAY PHAT HANH
            SB.EXPDATE,                   -- NGAY DAO HAN
            TO_CHAR(UTILS.SO_THANH_CHU(NVL(SB.VALUEOFISSUE,0))) AS VALUEOFISSUE, --GIA TRI PHAT HANH
            SB.PARVALUE,                  -- MENH GIA
            SB.INTCOUPON                  -- LAI SUAT
        FROM SBSECURITIES SB, ISSUERS ISS, --CFMAST CF,
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
                 AND A.BKDATE > V_IDATE
                 AND A.DELTD <> 'Y'
                 GROUP BY A.ACCTNO
            ) TRANC,
            (    SELECT A.ACCTNO,NVL(SUM(A.NAMT), 0) DAMT
                 FROM VW_BONDTRAN A, APPTX APP
                 WHERE A.TXCD = APP.TXCD
                 AND APP.TXTYPE = 'D'
                 AND A.BKDATE > V_IDATE
                 AND A.DELTD <> 'Y'
                 GROUP BY A.ACCTNO
            ) TRAND
            WHERE BO.ACCTNO = TRANC.ACCTNO(+)
            AND BO.ACCTNO = TRAND.ACCTNO(+)
        ) BSE,(SELECT ISS.ISSUECODE,ISS.ISSUERID,BI.BONDCODE,MST.CONTRACTNO,MST.CONTRACTDATE FROM ISSUER_CONTRACTNO MST, ISSUES ISS,BONDISSUE BI
                WHERE ISS.AUTOID = MST.ISSUESID AND BI.ISSUESID = ISS.AUTOID
                AND MST.CONTRACTTYPE='003')MST
        WHERE BSE.QTTY > 0
        AND BSE.BONDCODE= SB.CODEID
        --AND BSE.CUSTODYCD = CF.CUSTODYCD
        AND SB.ISSUERID = ISS.ISSUERID
        AND ISS.ISSUERID=MST.ISSUERID (+)
        AND BSE.BONDCODE=MST.BONDCODE (+)
        --AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND SB.SYMBOL LIKE V_SYMBOL
        --AND SB.CONTRACTNO LIKE V_CONTRACTNO
        ) BA
    GROUP BY BONDSYMBOL,CREATEDATE,CONTRACT,SECTYPE,FULLNAMEBOND,CONTRACTNO,CONTRACTDATE,THIRDPARTNER,ISSUEDATE,EXPDATE,VALUEOFISSUE,PARVALUE,INTCOUPON;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('BA6001: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
