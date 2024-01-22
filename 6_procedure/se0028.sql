SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0028 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_PLACE       IN       VARCHAR2
       )
IS

-- RP NAME : Danh sach nguoi so huu de nghi luu ky chung khoan
-- PERSON : QUYET.KIEU
-- DATE : 13/02/2011
-- COMMENTS : CREATE NEW
-- ---------   ------  -------------------------------------------

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (400);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_SYMBOL  VARCHAR2 (20);
   V_CUSTODYCD VARCHAR2 (15);
   V_PLACE VARCHAR2 (400);
BEGIN
-- GET REPORT'S PARAMETERS

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   IF (V_STROPTION = 'A') AND (V_INBRID  = '0001')
   THEN
        V_STRBRID := '%';
   ELSE if V_STROPTION = 'B' then
        select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
        V_STRBRID := V_INBRID;
        end if;
   END IF;

   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := REPLACE(trim(PV_SYMBOL),' ','_');
   ELSE
      V_SYMBOL := '%';
   END IF;

   SELECT CDCONTENT INTO V_PLACE FROM ALLCODE WHERE CDNAME='BRANCH' AND CDVAL=PV_PLACE;

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
SELECT T.*, BRID branchID,V_PLACE PLACE FROM
(
SELECT
         nvl(A2.cdcontent ,'') san,
         nvl(cf.fullname,'') fullname,
         nvl(cf.custodycd,'') custodycd,
         (case when A1.cdval='009' then cf.tradingcode else nvl(cf.idcode ,'') end) idcode,
         (case when A1.cdval='009' then cf.tradingcodedt else nvl(cf.iddate ,'') end) iddate,
          (Case when A1.cdval='001' then '1'
              when A1.cdval='009' then '2'
              when A1.cdval='005' then '3'
           else '4' end
         ) IDTYPE,
         nvl(sb.symbol,'') codeid,
         nvl(iss.fullname,'') CK_Name,
         Sum(nvl(tl.msgamt,'')) So_luong,
         nvl(sb.PARVALUE,'') Menh_gia,
         tl.type type, tl.securitiestype sectype,
         nvl(PV_SYMBOL,'') PV_SYMBOL
  FROM   (
            SELECT txdate ,afacctno acctno, sb.codeid  codeid , withdraw  msgamt,
                    (case when sb.refcodeid is null then '1' else '7' end) TYPE,
                    (CASE WHEN sb.sectype IN ('001','002') THEN 'Co phieu'
                          WHEN sb.sectype IN ('003','006','012') THEN 'Trai phieu'
                          WHEN sb.sectype IN ('007','008') THEN 'Chung chi'
                          ELSE ' ' END) securitiestype
            From sewithdrawdtl , sbsecurities sb
            where sewithdrawdtl.codeid=sb.codeid and txdatetxnum in
                (
                 Select to_char(busdate, 'DD/MM/RRRR') || txnum from  tLlog
                  WHERE tltxcd = '2200'
                     AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                     AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
                 Union all
                 Select to_char(busdate, 'DD/MM/RRRR') || txnum from  tLlogALl
                  WHERE tltxcd = '2200'
                      AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                      AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
                )
                AND withdraw > 0
            UNION ALL
            SELECT txdate ,afacctno acctno , sb.codeid codeid , blockwithdraw  msgamt ,
                    (case when sb.refcodeid is null then '2' else '8' end) TYPE,
                    (CASE WHEN sb.sectype IN ('001','002') THEN 'Co phieu'
                          WHEN sb.sectype IN ('003','006','012') THEN 'Trai phieu'
                          WHEN sb.sectype IN ('007','008') THEN 'Chung chi'
                          ELSE ' ' END) securitiestype
            From sewithdrawdtl , sbsecurities sb
            where sewithdrawdtl.codeid=sb.codeid and txdatetxnum in
                (
                 Select to_char(busdate, 'DD/MM/RRRR') || txnum from  tLlog
                  WHERE tltxcd = '2200'
                     AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                     AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
                 Union all
                 Select to_char(busdate, 'DD/MM/RRRR') || txnum from  tLlogALl
                  WHERE       tltxcd = '2200'
                      AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                      AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
                )
                AND blockwithdraw > 0
        ) tl, afmast af, VW_CFMAST_M cf, sbsecurities sb, issuers iss, ALLCODE A1, ALLCODE A2,
            sbsecurities sb1
 WHERE       tl.acctno = af.acctno
         AND af.custid = cf.custid
         --AND AF.ACTYPE NOT IN ('0000')
         AND tl.CODEID = sb.codeid
         AND sb.tradeplace IN ('001', '002', '005','006','010')
         and sb.refcodeid = sb1.codeid (+)
         and (case when sb.refcodeid is null then sb.tradeplace else sb1.tradeplace end) = A2.CDVAL
         AND A1.CDTYPE = 'CF' AND A1.CDNAME = 'IDTYPE'
         AND A1.CDVAL = CF.IDTYPE
         AND iss.issuerid = sb.issuerid
         AND A2.CDTYPE = 'SE' AND A2.CDNAME = 'TRADEPLACE'
---         AND A2.CDVAL = sb.tradeplace
----         AND sb.tradeplace = A2.cdval
         and (af.brid like V_STRBRID or INSTR(V_STRBRID,af.brid) <> 0)
         AND Cf.custodycd_org LIKE V_CUSTODYCD
         AND sb.symbol    LIKE V_SYMBOL
        -- AND sb.tradeplace = PV_TRADEPLACE
        Group BY cf.fullname,cf.custodycd,cf.idcode ,cf.iddate ,A1.cdval,sb.symbol,iss.fullname,sb.PARVALUE,A2.cdcontent,
            tl.TYPE, tl.securitiestype,cf.tradingcode,cf.tradingcodedt
) T
 ;

EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('SE0028 ERROR');
   
      RETURN;
END;
/
