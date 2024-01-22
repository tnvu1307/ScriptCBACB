SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0045 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_TRANSACTION IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PLSENT         IN       VARCHAR2,
   P_NUMBER       IN       VARCHAR2
)
IS

-- RP NAME : Danh sach nguoi so huu de nghi luu ky chung khoan 11B/LK
-- PERSON              DATE            COMMENTS
-- TriBui          23/07/2020      CREATE
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (20);
   V_TRANSACTION  VARCHAR2 (20);
   V_CUSTODYCD VARCHAR2 (15);
   V_TRADEPLACE VARCHAR2 (15);
   V_STRPLSENT VARCHAR2 (150);
   v_BRNAME VARCHAR2 (200);
   v_CURRDATE DATE;
BEGIN
-- GET REPORT'S PARAMETERS
   IF  (TRADEPLACE <> 'ALL')
   THEN
         V_TRADEPLACE := TRADEPLACE;
   ELSE
        V_TRADEPLACE := '%';
   END IF;
   ----------
   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;
   ----------
   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := PV_SYMBOL;
   ELSE
      V_SYMBOL := '%';
   END IF;
   ----------
   V_STRPLSENT := PLSENT;
   V_TRANSACTION:= PV_TRANSACTION;
   ----------
   SELECT MAX(CASE WHEN  VARNAME='BRNAME' THEN VARVALUE ELSE '' END)
       INTO V_BRNAME
   FROM SYSVAR WHERE VARNAME IN ('BRNAME');

   SELECT GETCURRDATE INTO v_CURRDATE FROM DUAL;
-- GET REPORT'S DATA

IF V_TRANSACTION ='001' THEN --BLOCK
OPEN PV_REFCURSOR
FOR
 SELECT V_STRPLSENT AS PLSENT,
        V_BRNAME AS TVLK,
        V_TRANSACTION AS PGT,
        P_NUMBER AS NO,
        I_DATE AS VALDATE,
        V_CURRDATE AS CURRDATE,
        V_TRANSACTION AS ND,
        SAN,
        SYMBOL,
        CUSTODYCD,
        FULLNAME,
        IDCODE,
        IDDATE,
        TXDATE,
        SUM(MSGAMT) MSGAMT
 FROM (
        SELECT
                  CASE
                      WHEN SB.TRADEPLACE='002' THEN 'HNX'
                      WHEN SB.TRADEPLACE='001' THEN 'HOSE'
                      WHEN SB.TRADEPLACE='005' THEN 'UPCOM'
                      WHEN SB.TRADEPLACE='010' THEN 'BOND'
                      ELSE ''
                  END SAN,
                  REPLACE(SB.SYMBOL,'_WFT','') SYMBOL,
                  CF.CUSTODYCD,
                  CF.FULLNAME,
                  CASE
                        WHEN SUBSTR(CF.CUSTODYCD,4,1)='F' THEN CF.TRADINGCODE
                        ELSE CF.IDCODE
                  END IDCODE,
                  CASE
                        WHEN SUBSTR(CF.CUSTODYCD,4,1)='F' THEN TO_CHAR(CF.TRADINGCODEDT,'DD/MM/YYYY')
                        ELSE TO_CHAR(CF.IDDATE,'DD/MM/YYYY')
                  END IDDATE,
                  TO_CHAR(SE.TXDATE,'DD/MM/YYYY')TXDATE,
                  SUM(NVL(SE.MSGAMT,0)) MSGAMT

         FROM (
                SELECT   TXDATE,
                         SUBSTR (ACCTNO, 0, 10) ACCTNO,
                         SUBSTR (ACCTNO, 11, 6) CODEID,
                         NAMT MSGAMT
                  FROM   VW_SETRAN_ALL
                 WHERE       TLTXCD = '2232'
                         AND TXCD = '0011'
                         AND TXDATE = TO_DATE (I_DATE, 'DD/MM/YYYY')
              ) SE ,
              (
                SELECT NVL(SB1.PARVALUE,SB.PARVALUE) PARVALUE,  NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE, NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
                NVL(SB1.SYMBOL,SB.SYMBOL) SYMBOL, NVL(SB1.CODEID,SB.CODEID) REFCODEID
                FROM SBSECURITIES SB, SBSECURITIES SB1
                WHERE NVL(SB.REFCODEID,' ') = SB1.CODEID(+)
              ) SB,AFMAST AF,VW_CFMAST_M CF
         WHERE SE.CODEID = SB.CODEID
               AND SE.ACCTNO = AF.ACCTNO
               AND AF.CUSTID = CF.CUSTID
               AND SB.TRADEPLACE IN ('001', '002', '005','006')
               AND CF.CUSTODYCD_ORG  LIKE V_CUSTODYCD
               AND SB.SYMBOL     LIKE V_SYMBOL
               AND SB.TRADEPLACE LIKE V_TRADEPLACE
        GROUP BY
                SB.TRADEPLACE,
                CF.CUSTODYCD,
                CF.FULLNAME,
                CF.TRADINGCODE,
                CF.IDCODE,
                CF.IDDATE,
                SE.TXDATE,
                CF.TRADINGCODEDT,
                REPLACE(SB.SYMBOL,'_WFT',''),
                SUBSTR(CF.CUSTODYCD,4,1)
 ) GROUP BY SAN,SYMBOL,CUSTODYCD,FULLNAME,IDCODE,IDDATE,TXDATE;
 ELSE --UNBLOCK
 OPEN PV_REFCURSOR
 FOR
 SELECT V_STRPLSENT PLSENT,
        V_BRNAME TVLK,
        V_TRANSACTION AS PGT,
        P_NUMBER AS NO,
        I_DATE AS VALDATE,
        V_CURRDATE AS CURRDATE,
        V_TRANSACTION AS ND,
        SAN,
        SYMBOL,
        CUSTODYCD,
        FULLNAME,
        IDCODE,
        IDDATE,
        TXDATE,
        SUM(MSGAMT) MSGAMT
 FROM (
        SELECT
                  CASE
                      WHEN SB.TRADEPLACE='002' THEN 'HNX'
                      WHEN SB.TRADEPLACE='001' THEN 'HOSE'
                      WHEN SB.TRADEPLACE='005' THEN 'UPCOM'
                      WHEN SB.TRADEPLACE='010' THEN 'BOND'
                      ELSE ''
                  END SAN,
                  REPLACE(SB.SYMBOL,'_WFT','') SYMBOL,
                  CF.CUSTODYCD,
                  CF.FULLNAME,
                  CASE
                        WHEN SUBSTR(CF.CUSTODYCD,4,1)='F' THEN CF.TRADINGCODE
                        ELSE CF.IDCODE
                  END IDCODE,
                  CASE
                        WHEN SUBSTR(CF.CUSTODYCD,4,1)='F' THEN TO_CHAR(CF.TRADINGCODEDT,'DD/MM/YYYY')
                        ELSE TO_CHAR(CF.IDDATE,'DD/MM/YYYY')
                  END IDDATE,
                  TO_CHAR(SE.TXDATE,'DD/MM/YYYY')TXDATE,
                  SUM(NVL(SE.MSGAMT,0)) MSGAMT

         FROM (
/*
                SELECT   TXDATE,
                         SUBSTR (ACCTNO, 0, 10) ACCTNO,
                         SUBSTR (ACCTNO, 11, 6) CODEID,
                         NAMT MSGAMT
                  FROM   VW_SETRAN_ALL
                 WHERE       TLTXCD = '2253'
                         AND TXCD = '0014'
                         AND TXDATE = TO_DATE (I_DATE, 'DD/MM/YYYY')
*/
                SELECT
                     TL.TXDATE,
                     SUBSTR (TL.MSGACCT, 0, 10) ACCTNO,
                     SUBSTR (TL.MSGACCT, 11, 6) CODEID,
                     MSGAMT MSGAMT
                FROM   vw_tllog_all TL, VW_TLLOGFLD_ALL FLD, SEMORTAGE SE,SEMORTAGE SE1
                WHERE TL.tltxcd = '2233'
                      AND TL.TXDATE=FLD.TXDATE
                      AND TL.TXNUM=FLD.TXNUM
                      AND TL.TXDATE=SE1.TXDATE(+)
                      AND TL.TXNUM=SE1.TXNUM(+)
                      AND FLD.FLDCD='50'
                      AND FLD.CVALUE=SE.AUTOID
                      AND SE.DELTD<>'Y'
                      AND SE.STATUS <>'E'
                      AND SE1.STATUS <>'E'
                      AND TL.DELTD<>'Y' AND TL.TXSTATUS IN ('1','4','7')
                      AND NVL(SE1.DELTD,'N')<>'Y'
                      AND TL.txdate = TO_DATE (I_DATE, 'DD/MM/YYYY')
              ) SE ,
              (
                SELECT NVL(SB1.PARVALUE,SB.PARVALUE) PARVALUE,  NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE, NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
                NVL(SB1.SYMBOL,SB.SYMBOL) SYMBOL, NVL(SB1.CODEID,SB.CODEID) REFCODEID
                FROM SBSECURITIES SB, SBSECURITIES SB1
                WHERE NVL(SB.REFCODEID,' ') = SB1.CODEID(+)
              ) SB,AFMAST AF,VW_CFMAST_M CF
         WHERE SE.CODEID = SB.CODEID
               AND SE.ACCTNO = AF.ACCTNO
               AND AF.CUSTID = CF.CUSTID
               AND SB.TRADEPLACE IN ('001', '002', '005','006')
               AND CF.CUSTODYCD_ORG  LIKE V_CUSTODYCD
               AND SB.SYMBOL     LIKE V_SYMBOL
               AND SB.TRADEPLACE LIKE V_TRADEPLACE
        GROUP BY
                SB.TRADEPLACE,
                CF.CUSTODYCD,
                CF.FULLNAME,
                CF.TRADINGCODE,
                CF.IDCODE,
                CF.IDDATE,
                SE.TXDATE,
                CF.TRADINGCODEDT,
                REPLACE(SB.SYMBOL,'_WFT',''),
                SUBSTR(CF.CUSTODYCD,4,1)
 ) GROUP BY SAN,SYMBOL,CUSTODYCD,FULLNAME,IDCODE,IDDATE,TXDATE;
 END IF;

EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('SE0045 ERROR');
   
      RETURN;
END;
/
