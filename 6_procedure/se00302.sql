SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se00302 (
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

-- RP NAME : YEU CAU CHUYEN KHOAN CHUNG KHOAN LO LE
-- PERSON --------------DATE---------------------COMMENTS
-- NAM.LY            18/11/2019                 CREATE
-- SE00302: REPORT MAIN
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
  V_CUSTODYCD := UPPER(REPLACE( PV_CUSTODYCD,'.',''));

  SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
   FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';

 IF  (PV_AFACCTNO <> 'ALL')
 THEN
       V_STRAFACCTNO := PV_AFACCTNO;
 ELSE
       V_STRAFACCTNO := '%';
 END IF;


-- GET REPORT'S DATA  DEVIDENTRATE
OPEN PV_REFCURSOR
FOR
SELECT DT.*,
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
      FROM (
  SELECT MAX(CF.CUSTODYCD) CUSTODYCD, MAX(REPLACE(SB.SYMBOL,'_WFT',''))  SYMBOL, CA.REPORTDATE,
      --  MAX(DECODE(CA.DEVIDENTRATE,0,CA.DEVIDENTVALUE ||'(/cp)' , CA.DEVIDENTRATE|| '(%)')) CA_TYLE,
      MAX(DECODE(CA.DEVIDENTRATE,0,TO_CHAR(CA.DEVIDENTVALUE)||'/cp'  , TO_CHAR(CA.DEVIDENTRATE)||'%')) CA_TYLE,

      NVL(SUM(CAS.TRADE),0)  REPORT_QTTY, NVL(SUM(CAS.CUTPBALANCE),0) CUTPBALANCE,
      NVL(SUM(CAS.QTTY + cas.cutqtty + cas.sendqtty),0)  QTTY,
      NVL(SUM(CAS.CUTAQTTY),0) CUTAQTTY,
      NVL(SUM(CAS.AMT + cas.cutamt + cas.sendamt),0)   AMT,
       0 CP_LE, 0 RIGHT_QTTY, 0 CK_MUA, ' ' NOTE
      FROM CASCHD  CAS, CAMAST CA, CFMAST CF,
          AFMAST AF, SBSECURITIES SB
      WHERE CF.CUSTODYCD = V_CUSTODYCD AND CF.CUSTID = AF.CUSTID
          AND CAS.AFACCTNO = AF.ACCTNO AND CA.CAMASTID = CAS.CAMASTID
          AND CA.CATYPE='010' AND AF.ACCTNO LIKE V_STRAFACCTNO
          AND CAS.CODEID = SB.CODEID
          --AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
          AND CAS.STATUS ='O'
          --AND CA.reportdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
          --AND CA.reportdate <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
      GROUP BY CA.CAMASTID,CA.REPORTDATE ) DT, SBSECURITIES SB
  WHERE DT.SYMBOL = SB.SYMBOL

  UNION ALL

     SELECT V_CUSTODYCD  CUSTODYCD, 'XXX' SYMBOL, TO_DATE(F_DATE,'DD/MM/YYYY') REPORTDATE,
      ' ' CA_TYLE,
     0  REPORT_QTTY,
      0 CUTPBALANCE, 0  QTTY,
       0 CUTAQTTY
      , 0   AMT, 0 CP_LE, 0 RIGHT_QTTY, 0 CK_MUA, ' ' NOTE,'UPCOM' SAN_GD, 3 ORD_NUM
     FROM DUAL
       ;


EXCEPTION
WHEN OTHERS
 THEN
 DBMS_OUTPUT.PUT_LINE('SE00302 ERROR');
 PLOG.ERROR('SE00302: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN;
END;
/
