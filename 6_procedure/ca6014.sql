SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca6014 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   --F_DATE         IN       VARCHAR2,
   --T_DATE         IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   P_CUSTODYCD   IN       VARCHAR2
   --PV_AFACCTNO    IN       VARCHAR2
   --PLSENT         in       varchar2 -- NOI GUI
   )
IS

    V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID            VARCHAR2 (4);
    --V_STRAFACCTNO     VARCHAR2 (20);
    V_STRCUSTODYCD     VARCHAR2 (20);
    V_STRCACODE     VARCHAR2 (20);
    V_todate DATE;
    V_fromdate DATE;
    v_CurrDate     date;
BEGIN
    V_STROPTION := OPT;
     v_CurrDate   := getcurrdate;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;

  /* V_STROPTION := UPPER(OPT);
    V_INBRID := BRID;

    IF (V_STROPTION = 'A') THEN
         V_STRBRID := '%';
    ELSE IF (V_STROPTION = 'B') THEN
            SELECT BRGRP.MAPID INTO V_STRBRID FROM BRGRP WHERE BRGRP.BRID = V_INBRID;
        ELSE
            V_STRBRID := V_INBRID;
        END IF;
    END IF;     */                                    ---hoangnd loc theo pham vi

    /*IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;*/

     IF (P_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTODYCD := P_CUSTODYCD;
   ELSE
      V_STRCUSTODYCD := '%%';
   END IF;


   IF (CACODE <> 'ALL')
   THEN
      V_STRCACODE := CACODE;
   ELSE
      V_STRCACODE := '%%';
   END IF;

   --V_todate := to_date(T_DATE,'DD/MM/RRRR');
   --V_fromdate := to_date(F_DATE,'DD/MM/RRRR');



   --GET REPORT'S PARAMETERS

OPEN PV_REFCURSOR FOR

select --PLSENT sendto,
    v_CurrDate createdate,
    cf.fullname,
    (case when  cf.country = '234' then cf.idcode else cf.tradingcode end) idcode,
    cf.tradingcode,
    a1.cdcontent country,
    cf.custodycd,
    iss.fullname fullnamecode,
    sb.symbol,
    --sum(cas.trade) strade, --SL trai phieu so huu
    Replace(utils.so_thanh_chu(sum(cas.trade)),',','.')strade,
    --sum(cas.aqtty)  saqtty, -- SL trai phieu dc quyen chuyen doi
    Replace(utils.so_thanh_chu(sum(cas.aqtty) ),',','.')saqtty,
    --sum(cas.aqtty - cas.balance) saqttybalance, -- SL trai phieu dang ky chuyen doi thanh co phieu
    Replace(utils.so_thanh_chu(sum(cas.aqtty - cas.balance)),',','.')saqttybalance,
    --sum(cas.balance) sbalance --SL trai phieu dang ky nhan thanh toan bang tien mat
    Replace(utils.so_thanh_chu(sum(cas.balance) ),',','.')sbalance
from VW_CFMAST_M cf, afmast af, semast se,caschd cas, camast ca,issuers iss, allcode a1, sbsecurities sb
where cf.custid = af.custid
    and af.acctno = se.afacctno
    and af.acctno = CAS.afacctno
    and se.codeid = CAS.codeid
    and se.codeid = sb.codeid
    and sb.sectype <> '004'
    and ca.camastid = cas.camastid
    and cas.deltd <> 'Y'
    and sb.issuerid = iss.issuerid
    AND a1.cdname = 'COUNTRY'
    and a1.cdtype ='CF'
    and ca.catype ='023'
    and a1.cdval = cf.country
    AND cf.custodycd like V_STRCUSTODYCD
    AND ca.camastid like V_STRCACODE
group by cf.fullname,cf.tradingcode,a1.cdcontent,cf.custodycd,iss.fullname,sb.symbol,
    (case when  cf.country = '234' then cf.idcode else cf.tradingcode end)

 ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
