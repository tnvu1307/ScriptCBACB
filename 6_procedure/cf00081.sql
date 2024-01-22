SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf00081 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE       COMMENTS
-- Diennt      30/09/2011 Create
-- ---------   ------     -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH

   -- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
   V_STRPV_CUSTODYCD VARCHAR2(20);
   V_STRPV_AFACCTNO VARCHAR2(20);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STRTLID           VARCHAR2(6);
   V_BALANCE        number;
   V_BALDEFOVD      number;
   V_IN_DATE        date;
   V_CURRDATE       date;
BEGIN
/*
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;*/

--   V_STRTLID:=TLID;
   /*IF(TLID <> 'ALL' AND TLID IS NOT NULL)
   THEN
        V_STRTLID := TLID;
   ELSE
        V_STRTLID := 'ZZZZZZZZZ';
   END IF;
*/
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


    V_STRPV_CUSTODYCD  := upper(PV_CUSTODYCD);
   IF(PV_AFACCTNO <> 'ALL' AND PV_AFACCTNO IS NOT NULL)
   THEN
        V_STRPV_AFACCTNO := PV_AFACCTNO;
   ELSE
        V_STRPV_AFACCTNO := '%';
   END IF;
    V_IN_DATE       := to_date(I_DATE,'dd/mm/rrrr');
    select to_date(varvalue,'dd/mm/rrrr') into V_CURRDATE from sysvar where varname = 'CURRDATE';


OPEN PV_REFCURSOR
  FOR
    select sb.symbol, sum(sts.qtty) qtty, sts.price, sts.cleardate, sts.txdate,
        '01' txdesc
    from
    (
        select txdate, codeid, afacctno, cleardate, status, qtty, round(amt/qtty,5) price
        from stschd
        where duetype = 'RS' and deltd <> 'Y'
            and txdate <= V_IN_DATE and cleardate >= V_IN_DATE
        union all
        select txdate, codeid, afacctno, cleardate, status, qtty, round(amt/qtty,5) price
        from stschdhist
        where duetype = 'RS'  and deltd <> 'Y'
            and txdate <= V_IN_DATE and cleardate >= V_IN_DATE
    ) sts, sbsecurities sb, cfmast cf, afmast af
    where sts.codeid = sb.codeid
        and sts.afacctno = af.acctno
        --T11/2015 TTBT T+2. Begin: TH ngay T0 chung khoan ve DN thi khong hien CK cho ve, nhung chu ky cua trai phieu TP ve cuoi ngay nen van hien TP cho ve
        and (
                case when V_IN_DATE=V_CURRDATE and sts.status = 'C' then 0
                    when cleardate=V_IN_DATE and V_IN_DATE<>V_CURRDATE then 0
                else sts.qtty end
            ) > 0
        --T11/2015 TTBT T+2. End
        and af.custid = cf.custid and cf.custodycd = V_STRPV_CUSTODYCD
        AND AF.ACCTNO LIKE V_STRPV_AFACCTNO
    group by sb.symbol, sts.price, sts.cleardate, sts.txdate
;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
 
 
/
