SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0026 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_VIA         in       VARCHAR2,
   PV_BRID         in       VARCHAR2
)
IS

-- RP NAME : BAO CAO BANG KE CHUNG KHOAN GIAO DICH LO LE
-- PERSON : DIEUNTA
-- DATE : 08/12/2014
-- COMMENTS : HIEN TAI CHUA THUC HIEN GIAO DICH THEO KENH, HAU HET DEU THUC HIEN BANG FLEX NEN CHUA LOC DC DK THEO VIA
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_STRSYMBOL VARCHAR2 (20);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);
   V_BRID   VARCHAR2(5);
   V_VIA   VARCHAR2(5);

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

   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%';
   END IF;

   IF  (UPPER(PV_SYMBOL) <> 'ALL' AND PV_SYMBOL IS NOT NULL)
   THEN
         V_STRSYMBOL := PV_SYMBOL;
   ELSE
      V_STRSYMBOL := '%';
   END IF;

   IF  (UPPER(PV_VIA) <> 'ALL' AND PV_VIA IS NOT NULL)
   THEN
         V_VIA := upper(PV_VIA);
   ELSE
      V_VIA := '%';
   END IF;

   IF  (UPPER(PV_BRID) <> 'ALL' AND PV_BRID IS NOT NULL)
   THEN
         V_BRID := PV_BRID;
   ELSE
      V_BRID := '%';
   END IF;

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR


SELECT
    (case when sb.tradeplace='002' then '1. HNX'
          when sb.tradeplace='001' then '2. HOSE'
          when sb.tradeplace='005' then '3. UPCOM'
          when sb.tradeplace='010' then '4. BOND' else '' end) san,
         nvl(  cf.fullname,'') fullname,
         nvl(cf.idcode ,'')idcode,
         nvl( cf.iddate ,'')iddate,
         nvl(cf.custodycd,'') custodycd,
         nvl(sb.symbol,'') codeid,
         nvl(tl.msgamt,'') sl_lole,
         rt.nvalue price,
         case when tl.txnum like '68%' then 'O' else 'F' end via,
         af.brid, a0.brname

  FROM   (

         SELECT a.txdate, a.txnum, substr(a.msgacct,1,10) acctno, substr(a.msgacct,11,6) codeid, a.msgacct, a.msgamt FROM
         (SELECT to_date(n_date,'DDMMRRRR') n_date,
              n_num, tltxcd, msgacct, msgamt, count(*) n, max(txdate) txdate, max(txnum) txnum   FROM
         (
         SELECT tl.autoid, tl.txnum, tl.txdate, tl.txtime , tl.tltxcd, tl.msgacct ,tl.msgamt,
               Max(CASE WHEN fld.fldcd = '04' THEN fld.cvalue ELSE '0' END) n_date,
               MAX(CASE WHEN fld.fldcd = '05' THEN fld.cvalue ELSE '0' END) n_num
         FROM vw_tllog_all tl, vw_tllogfld_all fld
         WHERE tltxcd IN ('8815') AND deltd <> 'Y'
         --AND msgacct = '0101535098000125'
         AND fld.txdate = tl.txdate AND fld.txnum = tl.txnum and fld.fldcd IN ('04','05')
         GROUP BY tl.autoid, tl.txnum, tl.txdate, tl.txtime , tl.tltxcd, tl.msgacct, tl.msgamt
         ORDER BY txdate, txnum, txtime
         )
         GROUP BY n_date, n_num, tltxcd, msgacct, msgamt) a

         LEFT JOIN

         (SELECT to_date(n_date,'DDMMRRRR') n_date,
              n_num, tltxcd, msgacct,msgamt, count(*) n,  max(txdate) txdate, max(txnum) txnum   FROM
                (
                SELECT tl.autoid, tl.txnum, tl.txdate, tl.txtime , tl.tltxcd, tl.msgacct ,tl.msgamt,
                      Max(CASE WHEN fld.fldcd = '04' THEN fld.cvalue ELSE '0' END) n_date,
                      MAX(CASE WHEN fld.fldcd = '05' THEN fld.cvalue ELSE '0' END) n_num
                FROM vw_tllog_all tl, vw_tllogfld_all fld
                WHERE tltxcd IN ('8816') AND deltd <> 'Y'
                --AND msgacct = '0101535098000125'
                AND fld.txdate = tl.txdate AND fld.txnum = tl.txnum and fld.fldcd IN ('04','05')
                GROUP BY tl.autoid, tl.txnum, tl.txdate, tl.txtime , tl.tltxcd, tl.msgacct, tl.msgamt
                ORDER BY txdate, txnum, txtime
                )
         GROUP BY n_date, n_num, tltxcd, msgacct, msgamt) b
         ON a.n_date = b.n_date AND a.n_num = b.n_num
         WHERE a.n > nvl(b.n,0)
           ) tl,
         afmast af, cfmast cf, sbsecurities sb, vw_tllogfld_all rt, brgrp a0 --, seretail
 WHERE       tl.acctno = af.acctno
         --AND seretail.acctno = tl.msgacct
         --AND seretail.status <> 'R'
         AND tl.txdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
         AND tl.txdate <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
         AND af.custid = cf.custid
         AND tl.codeid = sb.codeid
         AND sb.tradeplace IN ('001', '002', '005')
         AND rt.txdate = tl.txdate AND rt.txnum = tl.txnum AND rt.fldcd = '11'
         and af.brid=a0.brid

         AND Cf.CUSTODYCD LIKE V_CUSTODYCD
         AND tl.acctno LIKE V_STRAFACCTNO
         AND SB.SYMBOL LIKE V_STRSYMBOL
         --AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
         AND (af.brid LIKE V_BRID or instr(V_BRID,af.brid) <> 0 )
         and 1 =  case when (upper(PV_VIA)='O' and tl.txnum like '68%') or (upper(PV_VIA)='F' and tl.txnum not like '68%') or (upper(PV_VIA)='ALL') then 1 else 0 end
         ORDER BY cf.custodycd
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
