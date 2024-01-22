SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se00174 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
)
IS

-- RP NAME : YEU CAU CHUYEN KHOAN CHUNG KHOAN TAT TOAN TAI KHOAN
-- PERSON --------------DATE---------------------COMMENTS
-- THANHNM            17/07/2012                 CREATE
-- SE00171: report main
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_TYPE  VARCHAR2(10);
   V_CURRDATE DATE;
   V_FLAG NUMBER(2,0);

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
  SELECT DT.*,

                    (CASE WHEN SB.TRADEPLACE='002' THEN 'A. HNX'
                          WHEN SB.TRADEPLACE='001' THEN 'B. HOSE'
                          WHEN SB.TRADEPLACE='005' THEN 'C. UPCOM'
						  WHEN SB.TRADEPLACE='010' THEN 'D. BOND'
                          ELSE 'C. UPCOM' END)  SAN_GD
 FROM (

        SELECT MAX(CF.CUSTODYCD) CUSTODYCD, MAX(REPLACE(SB.SYMBOL,'_WFT',''))  SYMBOL, CA.REPORTDATE,
                MAX(DECODE(CA.CATYPE,'014', CA.RIGHTOFFRATE,'021',CA.SPLITRATE,'006',CA.DEVIDENTSHARES,'011',CA.DEVIDENTSHARES,
                '005',CA.DEVIDENTSHARES,'010', CA.DEVIDENTRATE,'023',CA.EXRATE, '1/1')) CA_TYLE, CAS.RETAILBAL BALANCE,
                MAX(CAS.TRADE)  REPORT_QTTY,
                SUM(CAS.CUTPBALANCE) CUTPBALANCE,
                SUM(cas.pbalance + cas.balance + cas.cutpbalance)  QTTY,
                SUM(CAS.CUTAQTTY) CUTAQTTY,
                SUM(CAS.AMT + cas.cutamt + cas.sendamt ) AMT,
                0 CP_LE, 0 RIGHT_QTTY,
                --CAL.QTTY CK_MUA,
                sum(CAS.QTTY + cas.cutqtty + cas.sendqtty)  CK_MUA,
                ' ' NOTE

        FROM CASCHD  CAS, CAMAST CA, CFMAST CF, AFMAST AF, SBSECURITIES SB --,CACLSTRANSFER CAL,VW_SETRAN_GEN SE
        WHERE CF.CUSTODYCD = V_CUSTODYCD AND CF.CUSTID = AF.CUSTID
                AND CAS.AFACCTNO = AF.ACCTNO AND CA.CAMASTID = CAS.CAMASTID
                AND CAS.CODEID = SB.CODEID
                AND CA.CATYPE='014' AND AF.ACCTNO LIKE V_STRAFACCTNO
                /*
                AND CAL.CATYPE=CA.CATYPE
                AND CAL.CASCHDID = CAS.AUTOID
                AND CAL.TXDATE = SE.TXDATE
                AND CAL.TXNUM = SE.TXNUM
                AND SE.BUSDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
                AND SE.BUSDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
                */
                AND CAS.STATUS  IN ('O','A','S')
                and exists (select 1 from vw_tllog_all t where t.tltxcd in ('2247','2257') and t.msgacct = AF.acctno || sb.codeid
                        and t.busdate between TO_DATE(F_DATE,'DD/MM/YYYY') and TO_DATE(T_DATE,'DD/MM/YYYY'))
        GROUP BY CA.CAMASTID,CA.REPORTDATE, CAS.RETAILBAL,SB.TRADEPLACE,SB.MARKETTYPE,SB.SECTYPE --,CAL.QTTY
    )DT, SBSECURITIES SB WHERE DT.SYMBOL = SB.SYMBOL;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
 
 
 
 
/
