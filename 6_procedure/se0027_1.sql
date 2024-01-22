SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0027_1 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_SYMBOL         IN    VARCHAR2,
   PV_PLACE       IN       VARCHAR2
       )
IS

-- RP NAME : Danh sach nguoi so huu de nghi luu ky chung khoan
-- PERSON : QUYET.KIEU
-- DATE : 13/02/2011
-- COMMENTS : CREATE NEW
-- ---------   ------  -------------------------------------------

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (600);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (40);

   V_SYMBOL  VARCHAR2 (20);
   V_CUSTODYCD VARCHAR2 (15);
    V_PLACE VARCHAR2 (400);
    v_COMPANYCD VARCHAR2(100);
    v_BRNAME VARCHAR2 (200);
BEGIN
-- GET REPORT'S PARAMETERS

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   IF (V_STROPTION = 'A') THEN
        V_STRBRID := '%';
   ELSif V_STROPTION = 'B' then
        select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
    else
        V_STRBRID := V_INBRID;
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

   Select max(case when  varname='BRNAME' then varvalue else '' end),
       max(case when  varname='COMPANYCD' then varvalue else '' end)
       into v_BRNAME,v_COMPANYCD
   from sysvar WHERE varname IN ('BRNAME','COMPANYCD');

SELECT CDCONTENT INTO V_PLACE FROM ALLCODE WHERE CDNAME='BRANCH' AND CDVAL=PV_PLACE;
-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
Select TB.* ,BRID branchID,V_PLACE PLACE, PV_PLACE p_sent,v_BRNAME TVLK,v_COMPANYCD SOHIEU_TV from
(
SELECT
         nvl(A2.cdcontent ,'') san,
         nvl(cf.fullname,'') fullname,
         nvl(cf.custodycd,'') custodycd,
         (case when substr(nvl(cf.custodycd ,''),4,1)='F' then  cf.tradingcode else to_char(nvl(cf.idcode,'')) end) idcode,
         (case when substr(nvl(cf.custodycd ,''),4,1)='F' then  cf.tradingcodedt else to_date(nvl(cf.iddate,'')) end) iddate,
        (Case when A1.cdval='001' then '1'
              when A1.cdval='005' then '3'
              when A1.cdval='009' then '2'
           else '4' end
        ) IDTYPE,
         nvl(sb.symbol,'') codeid,
         nvl(iss.fullname,'') CK_Name,
         sum(nvl(tl.msgamt,0)) So_luong,
          tl.type, nvl(sb.PARVALUE,'') Menh_gia, V_SYMBOL V_SYMBOL
  FROM   (
         SELECT  DISTINCT SED.AUTOID ,SUBSTR (msgacct, 0, 10) acctno,nvl(sb.refcodeid,sb.codeid) codeid, depotrade      msgamt,  (case when  sb.refcodeid is null then 1 else 7 end ) type
           FROM   tllog tl, setran se , sedeposit sed, sbsecurities sb
           WHERE   tl.tltxcd = '2240' AND tl.DELTD = 'N' and tl.txdate = se.txdate
           and tl.txnum = se.txnum  and se.txcd='0050'
           and tl.txnum = sed.txnum and se.txdate = sed.txdate
           and depotrade >0 and sb.codeid = substr(se.acctno,11)
           and sed.deltd <> 'Y'
           ---AND tl.txdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
           ---AND tl.txdate <= TO_DATE (T_DATE  ,'DD/MM/YYYY')

  union all
        SELECT   DISTINCT SED.AUTOID ,SUBSTR (msgacct, 0, 10) acctno, nvl(sb.refcodeid,sb.codeid) codeid, depoblock        msgamt, (case when  sb.refcodeid is null then 2 else 8 end ) type
           FROM   tllog tl, setran se , sedeposit sed, sbsecurities sb
           WHERE   tl.tltxcd = '2240' AND tl.DELTD = 'N' and tl.txdate = se.txdate
           and tl.txnum = se.txnum  and se.txcd='0050' and tl.txnum = sed.txnum
           and depoblock >0 and sb.codeid = substr(se.acctno,11)
           and sed.deltd <> 'Y' --and sed.status ='S'
           and se.txdate = sed.txdate
           ---AND tl.txdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
           ---AND tl.txdate <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
  UNION all
        SELECT   DISTINCT SED.AUTOID ,SUBSTR (msgacct, 0, 10) acctno,nvl(sb.refcodeid,sb.codeid) codeid, depotrade      msgamt,  (case when  sb.refcodeid is null then 1 else 7 end ) type
           FROM   tllogall tl, setrana se , sedeposit sed, sbsecurities sb
           WHERE   tl.tltxcd = '2240' AND tl.DELTD = 'N' and tl.txdate = se.txdate
           and tl.txnum = se.txnum  and se.txcd='0050' and tl.txnum = sed.txnum
           and depotrade >0 and sb.codeid = substr(se.acctno,11)
           and sed.deltd <> 'Y'
           and se.txdate = sed.txdate
           ---AND tl.txdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
           ---AND tl.txdate <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
  union all
       SELECT   DISTINCT SED.AUTOID ,SUBSTR (msgacct, 0, 10) acctno, nvl(sb.refcodeid,sb.codeid) codeid, depoblock        msgamt, (case when  sb.refcodeid is null then 2 else 8 end ) type
           FROM   tllogall tl, setrana se , sedeposit sed, sbsecurities sb
           WHERE   tl.tltxcd = '2240' AND tl.DELTD = 'N' and tl.txdate = se.txdate
           and tl.txnum = se.txnum  and se.txcd='0050' and tl.txnum = sed.txnum
           and depoblock >0 and sb.codeid = substr(se.acctno,11)
           and sed.deltd <> 'Y'
           and se.txdate = sed.txdate
           ---AND tl.txdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
           ---AND tl.txdate <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
           ) tl,
         afmast af,
         VW_CFMAST_M cf,
         sbsecurities sb,
         issuers iss,
         ALLCODE A1,
         ALLCODE A2 /*(
            select ra.afacctno, rc.brid
            from reaflnk ra, recflnk rc
            where ra.status='A' and rc.status='A'
                and substr(ra.reacctno,1,10)=rc.custid
            group by ra.afacctno, rc.brid
         ) re */
 WHERE       tl.acctno = af.acctno
         AND af.custid = cf.custid
         --AND AF.ACTYPE NOT IN ('0000')
         AND tl.codeid = sb.codeid
         AND sb.tradeplace IN ('001', '002', '005', '009')
         -----------------
         AND A1.CDTYPE = 'CF' AND A1.CDNAME = 'IDTYPE'
         AND A1.CDVAL = CF.IDTYPE
         AND iss.issuerid = sb.issuerid
         AND A2.CDTYPE = 'SE' AND A2.CDNAME = 'TRADEPLACE'
         AND A2.CDVAL = sb.tradeplace
         AND sb.tradeplace = A2.cdval
         --and cf.custid=re.afacctno(+)
         --and (nvl(re.brid,cf.brid) like V_STRBRID or INSTR(V_STRBRID,nvl(re.brid,cf.brid)) <> 0)
         ---AND Cf.custodycd_org LIKE V_CUSTODYCD
        ---AND sb.symbol    LIKE V_SYMBOL

       Group by
       A2.cdcontent ,
       cf.fullname,
       cf.custodycd,
       cf.idcode ,
       cf.iddate ,
       cf.tradingcode,
       cf.tradingcodedt,
       A1.cdval,
       sb.symbol,
       iss.fullname,
       sb.PARVALUE,
        tl.type,
       V_SYMBOL
    )TB
         ;

EXCEPTION
   WHEN OTHERS
   THEN
   plog.error ('se0027_1: ' || SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
