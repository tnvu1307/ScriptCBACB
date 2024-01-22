SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0022 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PLSENT         in       varchar2,
   PV_TOCUSTODYCD   IN       VARCHAR2
)
IS

-- RP NAME : BAO CAO BANG KE CHUNG KHOAN GIAO DICH LO LE
-- PERSON --------------DATE---------------------COMMENTS
-- QUYET.KIEU           11/02/2011               CREATE NEW
-- DIENNT               09/01/2012               EDIT
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_RECUSTODYCD VARCHAR2 (15);
   V_TYPE  VARCHAR2(10);
   V_FROMDATE DATE;
   V_TODATE DATE;
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);
   --V_CURRDATE date;
   v_sym311 VARCHAR2 (20);
   v_sym312 VARCHAR2 (20);
   v_sym313 VARCHAR2 (20);
   v_sym314 VARCHAR2 (20);
   v_sym315 VARCHAR2 (20);
   v_sym316 VARCHAR2 (20);
   v_sym318 VARCHAR2 (20);

BEGIN
-- GET REPORT'S PARAMETERS
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;
    V_CUSTODYCD := upper( REPLACE(PV_CUSTODYCD,'.',''));
    /*select to_date(varvalue,'DD/MM/RRRR') into V_CURRDATE
     from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';*/

     V_FROMDATE := TO_DATE(F_DATE, 'DD/MM/RRRR');
     V_TODATE := TO_DATE(T_DATE, 'DD/MM/RRRR');

   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
         V_STRAFACCTNO := '%';
   END IF;

   IF(upper(PV_TOCUSTODYCD) = 'ALL' or length(PV_TOCUSTODYCD) < 1) THEN
        V_RECUSTODYCD := '%';
   ELSE
        V_RECUSTODYCD := upper(REPLACE(PV_TOCUSTODYCD,'.',''));
   END IF;
-----------------------------------------------------
    SELECT REPLACE(SB.SYMBOL,'_WFT','')
    INTO v_sym311
    FROM SBSECURITIES SB
        ,CASCHD  CAS
        ,AFMAST AF
        ,CAMAST CA
        ,CFMAST CF
    WHERE SB.CODEID= CAS.CODEID
          AND CAS.AFACCTNO = AF.ACCTNO
          AND CA.CAMASTID = CAS.CAMASTID
          AND CA.CATYPE='011'
          AND CF.CUSTID = AF.CUSTID
          AND CF.CUSTODYCD = V_CUSTODYCD
          AND CAS.STATUS ='O'
          AND AF.ACCTNO LIKE V_STRAFACCTNO
    UNION ALL SELECT 'XXX' FROM DUAL;
-----------------------------------------------------
    SELECT REPLACE(SB.SYMBOL,'_WFT','')
    INTO v_sym312
    FROM SBSECURITIES SB
        ,CASCHD  CAS
        ,AFMAST AF
        ,CAMAST CA
        ,CFMAST CF
    WHERE SB.CODEID= CAS.CODEID
          AND CAS.AFACCTNO = AF.ACCTNO
          AND CA.CAMASTID = CAS.CAMASTID
          AND CA.CATYPE='010'
          AND CF.CUSTID = AF.CUSTID
          AND CF.CUSTODYCD = V_CUSTODYCD
          AND CAS.STATUS ='O'
          AND AF.ACCTNO LIKE V_STRAFACCTNO
    UNION ALL SELECT 'XXX' FROM DUAL;
-----------------------------------------------------
    SELECT REPLACE(SB.SYMBOL,'_WFT','')
    INTO v_sym313
    FROM SBSECURITIES SB
        ,CASCHD  CAS
        ,AFMAST AF
        ,CAMAST CA
        ,CFMAST CF
    WHERE SB.CODEID= CAS.CODEID
          AND CAS.AFACCTNO = AF.ACCTNO
          AND CA.CAMASTID = CAS.CAMASTID
          AND CA.CATYPE='021'
          AND CF.CUSTID = AF.CUSTID
          AND CF.CUSTODYCD = V_CUSTODYCD
          AND CAS.STATUS ='O'
          AND AF.ACCTNO LIKE V_STRAFACCTNO
    UNION ALL SELECT 'XXX' FROM DUAL;
-----------------------------------------------------
    SELECT REPLACE(SB.SYMBOL,'_WFT','')
    INTO v_sym314
    FROM SBSECURITIES SB
        ,CASCHD  CAS
        ,AFMAST AF
        ,CAMAST CA
        ,CFMAST CF
    WHERE SB.CODEID= CAS.CODEID
          AND CAS.AFACCTNO = AF.ACCTNO
          AND CA.CAMASTID = CAS.CAMASTID
          AND CA.CATYPE='014'
          AND CF.CUSTID = AF.CUSTID
          AND CF.CUSTODYCD = V_CUSTODYCD
          AND CAS.STATUS ='O'
          AND AF.ACCTNO LIKE V_STRAFACCTNO
    UNION ALL SELECT 'XXX' FROM DUAL;
-----------------------------------------------------
    SELECT REPLACE(SB.SYMBOL,'_WFT','')
    INTO v_sym315
    FROM SBSECURITIES SB
        ,CASCHD  CAS
        ,AFMAST AF
        ,CAMAST CA
        ,CFMAST CF
    WHERE SB.CODEID= CAS.CODEID
          AND CAS.AFACCTNO = AF.ACCTNO
          AND CA.CAMASTID = CAS.CAMASTID
          AND CA.CATYPE='020'
          AND CF.CUSTID = AF.CUSTID
          AND CF.CUSTODYCD = V_CUSTODYCD
          AND CAS.STATUS ='O'
          AND AF.ACCTNO LIKE V_STRAFACCTNO
    UNION ALL SELECT 'XXX' FROM DUAL;
-----------------------------------------------------
    SELECT REPLACE(SB.SYMBOL,'_WFT','')
    INTO v_sym316
    FROM SBSECURITIES SB
        ,CASCHD  CAS
        ,AFMAST AF
        ,CAMAST CA
        ,CFMAST CF
    WHERE SB.CODEID= CAS.CODEID
          AND CAS.AFACCTNO = AF.ACCTNO
          AND CA.CAMASTID = CAS.CAMASTID
          AND CA.CATYPE IN ('017','023')
          AND CF.CUSTID = AF.CUSTID
          AND CF.CUSTODYCD = V_CUSTODYCD
          AND CAS.STATUS ='O'
          AND AF.ACCTNO LIKE V_STRAFACCTNO
    UNION ALL SELECT 'XXX' FROM DUAL;
-----------------------------------------------------
    SELECT REPLACE(SB.SYMBOL,'_WFT','')
    INTO v_sym318
    FROM SBSECURITIES SB
        ,CASCHD  CAS
        ,AFMAST AF
        ,CAMAST CA
        ,CFMAST CF
    WHERE SB.CODEID= CAS.CODEID
          AND CAS.AFACCTNO = AF.ACCTNO
          AND CA.CAMASTID = CAS.CAMASTID
          AND CA.CATYPE NOT IN ('011','010','014','020','017','021','023')
          AND CF.CUSTID = AF.CUSTID
          AND CF.CUSTODYCD = V_CUSTODYCD
          AND CAS.STATUS ='O'
          AND AF.ACCTNO LIKE V_STRAFACCTNO
    UNION ALL SELECT 'XXX' FROM DUAL;
-----------------------------------------------------

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
SELECT CF.FULLNAME SENDER, CF.CUSTODYCD SENDER_CUSTCD, AF.ACCTNO SENDER_ACC , SB2.SYMBOL SYMBOL,
       OU.RECUSTODYCD, OU.RECUSTNAME, OU.outward,OU.TRTYPE,
       v_sym311 sym3111,v_sym312 sym3122,v_sym313 sym3133,v_sym314 sym3144,v_sym315 sym3155,v_sym316 sym3166,v_sym318 sym3188,
       trade +  caqtty + strade +  scaqtty + ctrade +  ccaqtty MSGAMT, SB.parvalue,
       CASE WHEN SB.refcodeid IS NOT NULL AND TRADE + CAQTTY + STRADE + SCAQTTY + CTRADE + CCAQTTY > 0 THEN '7'
            WHEN SB.REFCODEID IS NULL AND TRADE + CAQTTY + STRADE + SCAQTTY + CTRADE + CCAQTTY >0 THEN  '1'
            END LOAI_CK,
       CASE --WHEN SB2.SECTYPE IN ('003','006','111','222','333') AND SB2.MARKETTYPE = '001' THEN ' TR?I PHI?U CHUY? BI?T'
            --LONGNH 2014-11-28
            WHEN  nvl(sb2.tradeplace,'') = '010' AND sb2.sectype IN ('003','006','222','333','444', '012') THEN 'BOND' --ngay 12/02/2019 NamTv them TPDN
            WHEN SB2.MARKETTYPE = '000' AND SB2.TRADEPLACE = '001' THEN ' HOSE'
            WHEN SB2.MARKETTYPE = '000' AND SB2.TRADEPLACE = '002' THEN ' HNX'
            WHEN SB2.MARKETTYPE = '000' AND SB2.TRADEPLACE = '005' THEN ' UPCOM'
            END SAN, PLSENT SENTO, MEM.FULLNAME DEPOSITNAME,TR.CDCONTENT AS LOAI_CK,
      /* CASE WHEN ou.trtype = '001' THEN 1
            WHEN ou.trtype = '002' THEN 2
            WHEN ou.trtype = '003' THEN 3
            WHEN ou.trtype = '004' THEN 4
            WHEN ou.trtype = '005' THEN 5
            WHEN ou.trtype = '006' THEN 6
            WHEN ou.trtype = '007' THEN 7
            WHEN ou.trtype = '008' THEN 8
            WHEN ou.trtype = '009' THEN 9
            ELSE 10 END */
            to_number(ou.trtype) LD_CK
FROM SESENDOUT OU,  CFMAST CF, AFMAST AF, sbsecurities SB, sbsecurities SB2, deposit_member MEM,
        (select * from allcode where cdtype ='SE' and cdname='TRTYPE')TR
WHERE OU.DELTD <> 'Y'
AND CF.CUSTID = AF.CUSTID
AND SUBSTR(OU.ACCTNO,1,10) = AF.ACCTNO
AND OU.CODEID = SB.CODEID
AND TO_DATE(substr(ID2255,1,10),'DD/MM/RRRR') <= V_TODATE AND  TO_DATE(substr(ID2255,1,10),'DD/MM/RRRR') >= V_FROMDATE
--AND OU.TXDATE <= V_TODATE AND  OU.TXDATE >= V_FROMDATE
AND NVL(SB.refcodeid,SB.codeid) = SB2.CODEID
AND OU.outward = MEM.depositid (+)
AND OU.TRTYPE = TR.CDVAL (+)
--AND OU.ID2255 IS NOT NULL
AND CF.CUSTODYCD = V_CUSTODYCD
AND AF.ACCTNO LIKE V_STRAFACCTNO
AND  TRADE + CAQTTY + STRADE + SCAQTTY + CTRADE + CCAQTTY > 0
AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
AND upper(OU.RECUSTODYCD) LIKE upper(V_RECUSTODYCD)
UNION ALL
SELECT CF.FULLNAME SENDER, CF.CUSTODYCD SENDER_CUSTCD, AF.ACCTNO SENDER_ACC , SB2.SYMBOL SYMBOL,
        NULL sym3111,NULL sym3122,NULL sym3133,NULL sym3144,NULL sym3155,NULL sym3166,NULL sym3188,
       OU.RECUSTODYCD, OU.RECUSTNAME, OU.outward,OU.TRTYPE,
       blocked + sblocked + cblocked  MSGAMT, SB.parvalue,
       CASE WHEN SB.refcodeid IS NOT NULL AND BLOCKED + SBLOCKED + CBLOCKED > 0 THEN '8'
            WHEN SB.REFCODEID IS NULL AND BLOCKED + SBLOCKED + CBLOCKED > 0 THEN '2'
            END LOAI_CK,
       CASE --WHEN SB2.SECTYPE IN ('003','006','111','222','333') AND SB2.MARKETTYPE = '001' THEN ' TR?I PHI?U CHUY? BI?T'
            --LONGNH 2014-11-28
            WHEN  nvl(sb2.tradeplace,'') = '010' AND sb2.sectype IN ('003','006','222','333','444','012') THEN 'BOND' --ngay 12/02/2019 NamTv them TPDN
            WHEN SB2.MARKETTYPE = '000' AND SB2.TRADEPLACE = '001' THEN ' HOSE'
            WHEN SB2.MARKETTYPE = '000' AND SB2.TRADEPLACE = '002' THEN ' HNX'
            WHEN SB2.MARKETTYPE = '000' AND SB2.TRADEPLACE = '005' THEN ' UPCOM'
            END SAN, PLSENT SENTO, MEM.FULLNAME DEPOSITNAME,TR.CDCONTENT AS LOAI_CK,
       /*CASE WHEN ou.trtype = '001' THEN 1
            WHEN ou.trtype = '004' THEN 4
            WHEN ou.trtype = '005' THEN 8
            WHEN ou.trtype = '006' THEN 2
            WHEN ou.trtype = '007' THEN 6
            WHEN ou.trtype = '009' THEN 9
            ELSE 10 END */
            to_number(ou.trtype) LD_CK
FROM SESENDOUT OU,  CFMAST CF, AFMAST AF, sbsecurities SB, sbsecurities SB2, deposit_member MEM,
        (select * from allcode where cdtype ='SE' and cdname='TRTYPE')TR
WHERE OU.DELTD <> 'Y'
AND CF.CUSTID = AF.CUSTID
--AND OU.ID2255 IS NOT NULL
AND SUBSTR(OU.ACCTNO,1,10) = AF.ACCTNO
AND OU.CODEID = SB.CODEID
AND TO_DATE(substr(ID2255,1,10),'DD/MM/RRRR') <= V_TODATE AND  TO_DATE(substr(ID2255,1,10),'DD/MM/RRRR') >= V_FROMDATE
AND OU.TXDATE <= V_TODATE AND  OU.TXDATE >= V_FROMDATE
AND NVL(SB.refcodeid,SB.codeid) = SB2.CODEID
AND OU.outward = MEM.depositid (+)
AND OU.TRTYPE = TR.CDVAL (+)
AND CF.CUSTODYCD = V_CUSTODYCD
AND AF.ACCTNO LIKE V_STRAFACCTNO
AND  BLOCKED + SBLOCKED + CBLOCKED > 0
AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
AND upper(OU.RECUSTODYCD) LIKE upper(V_RECUSTODYCD)
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
