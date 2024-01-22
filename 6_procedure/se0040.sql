SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0040 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PLSENT         IN       VARCHAR2
  -- HDNUM          IN       VARCHAR2
       )
IS

-- RP NAME : BANG KE CHUNG KHOAN GIAI TOA CAM CO 21B/LK
-- PERSON : QUYET.KIEU
-- DATE :   07/05/2011
-- COMMENTS : CREATE NEW
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (20);
   V_CUSTODYCD VARCHAR2 (15);
   V_TRADEPLACE VARCHAR2 (15);
   v_FromDate   date;
   v_ToDate date;
   V_STRPLSENT VARCHAR2 (150);

BEGIN
-- GET REPORT'S PARAMETERS
 v_FromDate   :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
 v_ToDate   :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
   IF  (TRADEPLACE <> 'ALL')
   THEN
         V_TRADEPLACE := TRADEPLACE;
   ELSE
        V_TRADEPLACE := '%';
   END IF;

   V_CUSTODYCD  := REPLACE(PV_CUSTODYCD ,'.','');
   IF  (V_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := V_CUSTODYCD;
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
SELECT  V_STRPLSENT PLSENT,A.SAN, A.FULLNAME, A.SO_TK_LUUKY, A.IDCODE,
 A.NGAY_CAP, A.AFACCTNO, A.NGAY_GIAI_TOA, A.CODEID, A.MA_CK,
  A.MENH_GIA, sum(A.SOLUONG) SOLUONG, B.BEN_GIAI_TOA_CAM_CO,B.Ngay_hop_dong_camco, B.So_hop_dong_camco
  FROM
    (
    Select
            (case
            when sb.tradeplace='002' then '1. HNX'
              when sb.tradeplace='001' then '2. HOSE'
              when sb.tradeplace='005' then '3. UPCOM'
              when sb.tradeplace='010' then '4. BOND'
              else '' end) san,
          Cf.fullname ,
          cf.custodycd So_TK_luuKY,
          (case when cf.country='234' then cf.IDcode
          else cf.tradingcode end) IDcode,
          --cf.IDcode IDcode,
          Cf.iddate Ngay_cap,
          se.acctno Afacctno ,
          tl.txdate Ngay_giai_toa,
         (CASE WHEN instr(sb.symbol1,'_WFT') <> 0 then '7' else '1' end) Codeid ,
         sb.symbol Ma_CK,
         (nvl(sb.Parvalue,0)) Menh_Gia
         ,nvl(tl.msgamt,0) soluong
    from semortage mor, semast se,
            (select nVL(SB1.Parvalue,SB.Parvalue) Parvalue,  NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE, NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
                nvl(sb1.symbol,sb.symbol) symbol, nvl(sb1.CODEID,sb.CODEID) REFCODEID, sb.symbol symbol1
                    from sbsecurities sb, sbsecurities sb1
                        where nvl(sb.refcodeid,' ') = sb1.codeid(+)) sb,
            afmast af,
            VW_CFMAST_M cf,
            (select * from tllog union select * from tllogall) tl
    where   se.codeid = sb.codeid
        AND se.afacctno = af.acctno
        AND af.custid = cf.custid
        --AND AF.ACTYPE NOT IN ('0000')
        AND sb.tradeplace IN ('001', '002', '005')
        and tl.tltxcd = '2233'
        and tl.txnum = mor.txnum
        and tl.txdate = mor.txdate
        and se.acctno = mor.acctno
        and mor.status in ('C','E')
        --and mor.status in ('N','E')
        and Cf.CUSTODYCD_ORG  like V_CUSTODYCD
        and sb.symbol     like V_SYMBOL
        and sb.tradeplace like V_TRADEPLACE
    ) A,
    (select acctno,crfullname BEN_GIAI_TOA_CAM_CO, to_char(mor.mdate,'DD/MM/YYYY') Ngay_hop_dong_camco, mor.num_mg So_hop_dong_camco
        from semortage mor where tltxcd = '2232' and status = 'C'
    ) B
WHERE B.ACCTNO = A.AFACCTNO
      AND A.NGAY_GIAI_TOA BETWEEN v_FromDate and v_ToDate
        group by A.SAN, A.FULLNAME, A.SO_TK_LUUKY, A.IDCODE, A.NGAY_CAP, A.AFACCTNO, A.NGAY_GIAI_TOA, A.CODEID, A.MA_CK,
      A.MENH_GIA,  B.BEN_GIAI_TOA_CAM_CO,
      B.Ngay_hop_dong_camco, B.So_hop_dong_camco;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
