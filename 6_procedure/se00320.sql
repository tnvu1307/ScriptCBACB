SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se00320 (
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
    BEGIN
        SELECT REPLACE(SB.SYMBOL,'_WFT','') INTO v_sym311
        FROM SBSECURITIES SB, CASCHD CAS, AFMAST AF, CAMAST CA, VW_CFMAST_M CF
        WHERE SB.CODEID= CAS.CODEID
              AND CAS.AFACCTNO = AF.ACCTNO
              AND CA.CAMASTID = CAS.CAMASTID
              AND CA.CATYPE='011'
              AND CF.CUSTID = AF.CUSTID
              AND (CF.CUSTODYCD = V_CUSTODYCD OR CF.CUSTODYCD_ORG = V_CUSTODYCD)
              AND CAS.STATUS ='O'
              AND AF.ACCTNO LIKE V_STRAFACCTNO;
    EXCEPTION WHEN OTHERS THEN
        v_sym311 := 'XXX';
    END;
-----------------------------------------------------
    BEGIN
        SELECT REPLACE(SB.SYMBOL,'_WFT','') INTO v_sym312
        FROM SBSECURITIES SB, CASCHD CAS, AFMAST AF, CAMAST CA, VW_CFMAST_M CF
        WHERE SB.CODEID= CAS.CODEID
              AND CAS.AFACCTNO = AF.ACCTNO
              AND CA.CAMASTID = CAS.CAMASTID
              AND CA.CATYPE='010'
              AND CF.CUSTID = AF.CUSTID
              AND (CF.CUSTODYCD = V_CUSTODYCD OR CF.CUSTODYCD_ORG = V_CUSTODYCD)
              AND CAS.STATUS ='O'
              AND AF.ACCTNO LIKE V_STRAFACCTNO;
    EXCEPTION WHEN OTHERS THEN
        v_sym312 := 'XXX';
    END;
-----------------------------------------------------
    BEGIN
        SELECT REPLACE(SB.SYMBOL,'_WFT','')
        INTO v_sym313
        FROM SBSECURITIES SB, CASCHD CAS, AFMAST AF, CAMAST CA, VW_CFMAST_M CF
        WHERE SB.CODEID= CAS.CODEID
              AND CAS.AFACCTNO = AF.ACCTNO
              AND CA.CAMASTID = CAS.CAMASTID
              AND CA.CATYPE='021'
              AND CF.CUSTID = AF.CUSTID
              AND (CF.CUSTODYCD = V_CUSTODYCD OR CF.CUSTODYCD_ORG = V_CUSTODYCD)
              AND CAS.STATUS ='O'
              AND AF.ACCTNO LIKE V_STRAFACCTNO;
    EXCEPTION WHEN OTHERS THEN
        v_sym313 := 'XXX';
    END;
-----------------------------------------------------
    BEGIN
        SELECT REPLACE(SB.SYMBOL,'_WFT','') INTO v_sym314
        FROM SBSECURITIES SB, CASCHD CAS, AFMAST AF, CAMAST CA, VW_CFMAST_M CF
        WHERE SB.CODEID= CAS.CODEID
              AND CAS.AFACCTNO = AF.ACCTNO
              AND CA.CAMASTID = CAS.CAMASTID
              AND CA.CATYPE='014'
              AND CF.CUSTID = AF.CUSTID
              AND (CF.CUSTODYCD = V_CUSTODYCD OR CF.CUSTODYCD_ORG = V_CUSTODYCD)
              AND CAS.STATUS ='O'
              AND AF.ACCTNO LIKE V_STRAFACCTNO;
    EXCEPTION WHEN OTHERS THEN
        v_sym314 := 'XXX';
    END;
-----------------------------------------------------
    BEGIN
        SELECT REPLACE(SB.SYMBOL,'_WFT','') INTO v_sym315
        FROM SBSECURITIES SB, CASCHD CAS, AFMAST AF, CAMAST CA, VW_CFMAST_M CF
        WHERE SB.CODEID= CAS.CODEID
              AND CAS.AFACCTNO = AF.ACCTNO
              AND CA.CAMASTID = CAS.CAMASTID
              AND CA.CATYPE='020'
              AND CF.CUSTID = AF.CUSTID
              AND (CF.CUSTODYCD = V_CUSTODYCD OR CF.CUSTODYCD_ORG = V_CUSTODYCD)
              AND CAS.STATUS ='O'
              AND AF.ACCTNO LIKE V_STRAFACCTNO;
    EXCEPTION WHEN OTHERS THEN
        v_sym315 := 'XXX';
    END;
-----------------------------------------------------
    BEGIN
        SELECT REPLACE(SB.SYMBOL,'_WFT','') INTO v_sym316
        FROM SBSECURITIES SB, CASCHD CAS, AFMAST AF, CAMAST CA, VW_CFMAST_M CF
        WHERE SB.CODEID= CAS.CODEID
              AND CAS.AFACCTNO = AF.ACCTNO
              AND CA.CAMASTID = CAS.CAMASTID
              AND CA.CATYPE IN ('017','023')
              AND CF.CUSTID = AF.CUSTID
              AND (CF.CUSTODYCD = V_CUSTODYCD OR CF.CUSTODYCD_ORG = V_CUSTODYCD)
              AND CAS.STATUS ='O'
              AND AF.ACCTNO LIKE V_STRAFACCTNO;
    EXCEPTION WHEN OTHERS THEN
        v_sym316 := 'XXX';
    END;
-----------------------------------------------------
    BEGIN
        SELECT REPLACE(SB.SYMBOL,'_WFT','') INTO v_sym318
        FROM SBSECURITIES SB, CASCHD CAS, AFMAST AF, CAMAST CA, VW_CFMAST_M CF
        WHERE SB.CODEID= CAS.CODEID
              AND CAS.AFACCTNO = AF.ACCTNO
              AND CA.CAMASTID = CAS.CAMASTID
              AND CA.CATYPE NOT IN ('011','010','014','020','017','021','023')
              AND CF.CUSTID = AF.CUSTID
              AND (CF.CUSTODYCD = V_CUSTODYCD OR CF.CUSTODYCD_ORG = V_CUSTODYCD)
              AND CAS.STATUS ='O'
              AND AF.ACCTNO LIKE V_STRAFACCTNO;
    EXCEPTION WHEN OTHERS THEN
        v_sym318 := 'XXX';
    END;
-----------------------------------------------------

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
SELECT
       v_sym311 sym311,v_sym312 sym312,v_sym313 sym313,v_sym314 sym314,v_sym315 sym315,v_sym316 sym316,v_sym318 sym318
from dual;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
