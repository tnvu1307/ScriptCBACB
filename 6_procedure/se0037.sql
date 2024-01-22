SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0037 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PLSENT         IN       VARCHAR2
)
IS

-- RP NAME : YEU CAU CHUYEN KHOAN CAM CO CHUNG KHOAN 20A/LK
-- PERSON              DATE            COMMENTS
-- QUYET.KIEU          05/04/2011      CREATE
-- DIENNT              12/01/2012      EDIT
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (20);
   V_CUSTODYCD VARCHAR2 (15);
   V_TRADEPLACE VARCHAR2 (15);

   V_STRPLSENT VARCHAR2 (150);
   v_BRNAME VARCHAR2 (200);
BEGIN
-- GET REPORT'S PARAMETERS


   IF  (TRADEPLACE <> 'ALL')
   THEN
         V_TRADEPLACE := TRADEPLACE;
   ELSE
        V_TRADEPLACE := '%';
   END IF;


   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := PV_SYMBOL;
   ELSE
      V_SYMBOL := '%';
   END IF;

   V_STRPLSENT := PLSENT;

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
 SELECT V_STRPLSENT PLSENT,v_BRNAME TVLK,san,Codeid,symbol,SUM(Parvalue) Parvalue,SUM(msgamt) msgamt, SUM(GIA_TRI) GIA_TRI
 FROM (
Select (case
          when sb.tradeplace='002' then '1. HNX'
          when sb.tradeplace='001' then '2. HOSE'
          when sb.tradeplace='005' then '3. UPCOM'
          when sb.tradeplace='010' then '4. BOND'
          else '' end) san,
          se.Codeid ,
          REPLACE(sb.symbol,'_WFT','') symbol,
          nvl(sb.Parvalue,0) Parvalue ,
          sum(nvl(se.msgamt,0)) msgamt,
          (  sum(nvl(se.msgamt,0)) * nvl(sb.Parvalue,0)) Gia_tri,
          (case when substr(cf.custodycd,4,1)='F' then '01213.006'
                when substr(cf.custodycd,4,1)='P' then '01211.006'
                else '01212.006' end) ACCTNO,
          (case when substr(cf.custodycd,4,1)='F' then '01233.006'
                when substr(cf.custodycd,4,1)='P' then '01231.006'
                else '01232.006' end) TK_GHICO

 from (
        SELECT   txdate,
                 SUBSTR (acctno, 0, 10) acctno,
                 SUBSTR (acctno, 11, 6) codeid,
                 namt msgamt
          FROM   vw_setran_all
         WHERE       tltxcd = '2232'
                 AND txcd = '0011'
                 AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                 AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
                 ) SE ,
         (select nVL(SB1.Parvalue,SB.Parvalue) Parvalue,  NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE, NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
    nvl(sb1.symbol,sb.symbol) symbol, nvl(sb1.CODEID,sb.CODEID) REFCODEID
from sbsecurities sb, sbsecurities sb1
where nvl(sb.refcodeid,' ') = sb1.codeid(+) ) sb,afmast af,VW_CFMAST_M cf
 where se.codeid = sb.codeid
       AND se.acctno = af.acctno
       AND af.custid = cf.custid
     --  AND AF.ACTYPE NOT IN ('0000')
       AND sb.tradeplace IN ('001', '002', '005','006')
       AND Cf.CUSTODYCD_ORG  LIKE V_CUSTODYCD
       AND sb.symbol     LIKE V_SYMBOL
       AND sb.tradeplace like V_TRADEPLACE
    Group by
        sb.tradeplace ,
        se.Codeid ,
        REPLACE(sb.symbol,'_WFT',''),
        sb.Parvalue,
        substr(cf.custodycd,4,1)
        )
    GROUP BY SAN,CODEID,SYMBOL
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
