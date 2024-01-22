SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0026_1 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   PV_BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_TOCUSTODYCD   IN       VARCHAR2
  -- PLSENT         in       varchar2
)
IS

-- RP NAME : BAO CAO BANG KE CHUNG KHOAN CHUYEN KHOAN MOT PHAN
-- PERSON --------------DATE---------------------COMMENTS
--NGOCVTT 20/04/2015
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_RECUSTODYCD VARCHAR2 (15);
   V_TYPE  VARCHAR2(10);
   V_FROMDATE DATE;
   V_TODATE DATE;
   V_CURRDATE date;
   v_flag number(2,0);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);
   v_BRNAME VARCHAR2 (200);

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
   V_INBRID := PV_BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.brid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;


    V_CUSTODYCD := upper( PV_CUSTODYCD);
    V_RECUSTODYCD := upper(PV_TOCUSTODYCD);
    select to_date(varvalue,'DD/MM/RRRR') into V_CURRDATE
     from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';


   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
         V_STRAFACCTNO := '%';
   END IF;

     V_FROMDATE := TO_DATE(F_DATE, 'DD/MM/RRRR');
     V_TODATE := TO_DATE(T_DATE, 'DD/MM/RRRR');
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
   Select max(case when  varname='BRNAME' then varvalue else '' end)
       into v_BRNAME
   from sysvar WHERE varname IN ('BRNAME');
-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
SELECT v_BRNAME TVLK,FULLNAME, CUSTODYCD, ACCTNO,SYMBOL, IDCODE, IDDATE,IDPLACE, ADDRESS,MOBILE,RECUSTODYCD,RECUSTNAME, outward,
       SUM(TRADE) TRADE, SUM(BLOCKED) BLOCKED,parvalue,LOAI_CK,SAN,DEPOSITNAME,LD_CK,
       v_sym311 sym311,v_sym312 sym312,v_sym313 sym313,v_sym314 sym314,v_sym315 sym315,v_sym316 sym316,v_sym318 sym318
FROM(SELECT CF.FULLNAME , CF.CUSTODYCD, AF.ACCTNO , SB2.SYMBOL SYMBOL,
        (case when substr(nvl(cf.custodycd ,''),4,1)='F' then  cf.tradingcode else to_char(nvl(cf.idcode,'')) end) idcode,
        (case when substr(nvl(cf.custodycd ,''),4,1)='F' then  cf.tradingcodedt else to_date(nvl(cf.iddate,'')) end) iddate,
        CF.IDPLACE,CF.ADDRESS,
       NVL(CF.MOBILESMS,'') MOBILE,OU.RECUSTODYCD, OU.RECUSTNAME, A1.CDCONTENT outward,
       trade /*+  caqtty*/ + strade /*+  scaqtty*/ + ctrade /*+  ccaqtty*/ TRADE,
        blocked + sblocked + cblocked BLOCKED, SB.parvalue,
       CASE WHEN SB.REFCODEID IS NULL THEN  'TD' ELSE 'WAIT'END LOAI_CK,
        CASE  when sb2.tradeplace='002' then 'HNX'
          when sb2.tradeplace='001' then 'HOSE'
          when sb2.tradeplace='005' then 'UPCOM'
          when sb2.tradeplace='007' then 'TR?I PHI? CHUY? BI?T'
          when sb2.tradeplace='008' then 'T? PHI?U'
          when sb2.tradeplace='009' then '?CNY'
          else ''END SAN, MEM.FULLNAME DEPOSITNAME,--, PLSENT SENTO
            to_number(ou.trtype) LD_CK
FROM SESENDOUT OU,  CFMAST CF, AFMAST AF, sbsecurities SB, sbsecurities SB2, deposit_member MEM,
 (SELECT * FROM VW_TLLOGFLD_ALL WHERE FLDCD='31') FLD,
 (SELECT * FROM ALLCODE WHERE CDTYPE = 'SE' AND CDNAME = 'TRTYPE')A1
WHERE OU.DELTD <> 'Y'
AND CF.CUSTID = AF.CUSTID
AND SUBSTR(OU.ACCTNO,1,10) = AF.ACCTNO
AND OU.CODEID = SB.CODEID
AND OU.TXDATE=FLD.TXDATE
AND OU.TXNUM=FLD.TXNUM
AND FLD.CVALUE IN ('017','020')
AND FLD.CVALUE=A1.CDVAL
AND OU.TXDATE <= V_TODATE AND  OU.TXDATE >= V_FROMDATE
AND OU.DELTD<>'Y'
AND NVL(SB.refcodeid,SB.codeid) = SB2.CODEID
AND OU.outward = MEM.depositid (+)
--AND OU.ID2255 IS NOT NULL
AND CF.CUSTODYCD = V_CUSTODYCD
AND OU.RECUSTODYCD= V_RECUSTODYCD
AND AF.ACCTNO LIKE V_STRAFACCTNO
AND  TRADE /*+ CAQTTY*/ + STRADE /*+ SCAQTTY*/ + CTRADE /*+ CCAQTTY*/+BLOCKED + SBLOCKED + CBLOCKED > 0
AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
)
GROUP BY FULLNAME, CUSTODYCD, ACCTNO,SYMBOL, IDCODE, IDDATE,IDPLACE, ADDRESS,MOBILE,RECUSTODYCD,RECUSTNAME,outward,
       parvalue,LOAI_CK,SAN,DEPOSITNAME,LD_CK
ORDER BY SYMBOL
 ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
