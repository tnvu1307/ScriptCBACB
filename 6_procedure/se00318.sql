SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se00318 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PLSENT         IN       VARCHAR2
)
IS

-- RP NAME : YEU CAU CHUYEN KHOAN CHUNG KHOAN TAT TOAN TAI KHOAN
-- PERSON --------------DATE---------------------COMMENTS
-- THANHNM            17/07/2012                 CREATE
-- SE00311: report main
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_TYPE  VARCHAR2(10);
   V_CURRDATE DATE;
   V_FLAG NUMBER(2,0);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);

BEGIN
-- GET REPORT'S PARAMETERS
    V_CUSTODYCD := UPPER( PV_CUSTODYCD);

    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
     FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';

   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
         V_STRAFACCTNO := '%';
   END IF;


-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
        SELECT distinct DT.*,
            /*
            (CASE WHEN  nvl(sb.tradeplace,'') = '010' AND sb.sectype IN ('003','006','222','333','444') THEN '4. BOND'
                  ELSE
                      (CASE WHEN SB.TRADEPLACE='002' THEN '1. HNX'
                            WHEN SB.TRADEPLACE='001' THEN '2. HOSE'
                            WHEN SB.TRADEPLACE='005' THEN '3. UPCOM'
                            WHEN SB.TRADEPLACE='003' THEN '5. OTC'
                            WHEN SB.TRADEPLACE='009' THEN '6. DCCNY'
                            --when SB.TRADEPLACE='010' THEN 'D. BOND'
                            ELSE '3. UPCOM' END) END
            ) SAN_GD, */

            --//-------------NAM.LY 12-11-2019---------------------//--
            (CASE WHEN  NVL(SB.TRADEPLACE,'') = '010' AND SB.SECTYPE IN ('003','006','222','333','444') THEN 'BOND'
                  ELSE
                      (CASE WHEN SB.TRADEPLACE='002' THEN 'HNX'
                            WHEN SB.TRADEPLACE='001' THEN 'HOSE'
                            WHEN SB.TRADEPLACE='005' THEN 'UPCOM'
                            WHEN SB.TRADEPLACE='003' THEN 'OTC'
                            WHEN SB.TRADEPLACE='009' THEN 'DCCNY'
                            ELSE 'UPCOM' END) END
            ) SAN_GD,
            RANK() OVER (ORDER BY ( (CASE WHEN  NVL(SB.TRADEPLACE,'') = '010' AND SB.SECTYPE IN ('003','006','222','333','444') THEN 4
                ELSE
                    (CASE WHEN SB.TRADEPLACE ='002' THEN 1
                          WHEN SB.TRADEPLACE='001' THEN 2
                          WHEN SB.TRADEPLACE='005' THEN 3
                          WHEN SB.TRADEPLACE='003' THEN 5
                          WHEN SB.TRADEPLACE='009' THEN 6
                          ELSE 3 END) END )))  ORD_NUM
            --//-------------------------------------------------//--
        FROM (
     SELECT MAX(CF.CUSTODYCD) CUSTODYCD, MAX(REPLACE(SB.SYMBOL,'_WFT',''))  SYMBOL, CA.REPORTDATE,
        MAX(DECODE(CA.CATYPE,'014', CA.RIGHTOFFRATE,'021',CA.SPLITRATE,'006',CA.DEVIDENTSHARES,'011',CA.DEVIDENTSHARES,
        '005',CA.DEVIDENTSHARES,'010', CA.DEVIDENTRATE||'%','023',CA.EXRATE,'015',
           ca.interestrate||'%' , '016',ca.interestrate||'%', '1/1')) CA_TYLE,
--        ca.interestrate || '(%)', '016',ca.interestrate|| '(%)', '1/1')) CA_TYLE,
        NVL(SUM(CAS.TRADE),0)  REPORT_QTTY,
        NVL(SUM(CAS.CUTPBALANCE),0) CUTPBALANCE,
        CASE WHEN   max(CA.CATYPE) = '015' OR  max(CA.CATYPE) = '016' THEN
        NVL(SUM(CAS.AMT + cas.cutamt + cas.sendamt ),0)
        ELSE  NVL(SUM(cas.pbalance + cas.balance + cas.cutpbalance),0) END  QTTY,
        NVL(SUM(CAS.CUTAQTTY),0) CUTAQTTY,
        NVL(SUM(CAS.AMT + cas.cutamt + cas.sendamt ),0)   AMT,
         0 CP_LE, 0 RIGHT_QTTY, 0 CK_MUA, ' ' NOTE,PLSENT  PL_SENT
        FROM CASCHD  CAS, CAMAST CA, VW_CFMAST_M CF,
         AFMAST AF, SBSECURITIES SB
        WHERE CF.CUSTODYCD = V_CUSTODYCD AND CF.CUSTID = AF.CUSTID
        AND CAS.AFACCTNO = AF.ACCTNO AND CA.CAMASTID = CAS.CAMASTID
        AND CAS.CODEID = SB.CODEID
        --AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
        AND CA.CATYPE NOT IN ('011','010','014','020','017','021','023') AND AF.ACCTNO LIKE V_STRAFACCTNO --CA.CATYPE IN ('022','005','006')
        AND CAS.STATUS ='O'
        --AND CA.reportdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
        --AND CA.reportdate <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
GROUP BY CA.CAMASTID,CA.REPORTDATE )DT, SBSECURITIES SB WHERE DT.SYMBOL = SB.SYMBOL

        UNION ALL

       SELECT V_CUSTODYCD  CUSTODYCD, 'XXX' SYMBOL, TO_DATE(F_DATE,'DD/MM/YYYY') REPORTDATE,
        ' ' CA_TYLE,
       0  REPORT_QTTY,
        0 CUTPBALANCE, 0  QTTY,
         0 CUTAQTTY
        , 0   AMT, 0 CP_LE, 0 RIGHT_QTTY, 0 CK_MUA, ' ' NOTE,PLSENT  PL_SENT,'UPCOM' SAN_GD, 3 ORD_NUM
       FROM DUAL
         ;


EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('SE00318 ERROR');
   PLOG.ERROR('SE00318: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
