SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE SE9913
(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   
   I_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2
 )
IS

-- PURPOSE: Cam ket phong toa chung khoan
-- CREATOR: HoangNX
-- Created Date: 08/12/2014
   
   --Cac bien
   V_OPTION           VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_CUSTODYCD        VARCHAR2(20);
   V_IDATE            DATE;
   V_BRID             VARCHAR2 (50);        

BEGIN
   --Chuan hoa tham so
   V_OPTION := UPPER(OPT);
   V_BRID := BRID;
    
   IF (V_OPTION <> 'A') AND (BRID <> 'ALL') THEN
       V_BRID := BRID;
   ELSE
       V_BRID := '%';
   END IF;
   
   IF(PV_CUSTODYCD <> 'ALL') THEN
        V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;

   v_IDATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
   
   --Lay du lieu cho bao cao
   OPEN PV_REFCURSOR FOR
       WITH ars AS 
             (SELECT tran.acctno,
                     SUM(CASE  WHEN tx.txtype ='C' THEN tran.NAMT ELSE tran.NAMT * (-1) END) blocked
              FROM vw_setran_all tran, apptx TX
              WHERE tran.txcd = tx.txcd
                    AND tx.Apptype = 'SE'
                    AND tx.Tblname = 'SEMAST'
                    AND tx.Field IN ('EMKQTTY')
                    AND tx.Txtype IN ('C','D')
                    AND tran.tltxcd IN ('2202', '2203')
                    AND tran.deltd <> 'Y'
                    AND tran.txdate <= V_IDATE
              GROUP BY tran.acctno
              )   
       SELECT v_IDATE rptDate, cf.fullname, cf.custodycd, cf.idcode, cf.iddate, a.cdcontent TradePlace, 
              (CASE WHEN sb.refcodeid IS NOT NULL THEN 
                    (SELECT t.symbol FROM sbsecurities t WHERE t.codeid = sb.refcodeid)
              ELSE sb.symbol
              END) symbol,
              CASE WHEN sb.tradeplace = '006' THEN '(7)' ELSE '(1)' END StockType,
              ars.blocked, sb.parvalue, round(ars.blocked * sb.parvalue,0) StockValue
       FROM semast se, ars, afmast af, cfmast cf, sbsecurities sb, allcode a
       WHERE af.custid = cf.custid
             AND cf.custodycd LIKE V_CUSTODYCD
             AND se.afacctno = af.acctno
             AND se.acctno = ars.acctno
             AND se.codeid = sb.codeid
             AND (CASE WHEN sb.refcodeid IS NOT NULL THEN 
                       (SELECT t.tradeplace FROM sbsecurities t WHERE t.codeid = sb.refcodeid)
                  ELSE sb.tradeplace
                  END) = a.cdval
             AND a.cdtype = 'SE'
             AND a.cdname = 'TRADEPLACE'
             AND ars.blocked > 0;
              
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END SE9913;
 
 
 
 
/
