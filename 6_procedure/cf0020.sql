SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0020 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   I_BRIDGD       IN       VARCHAR2,
   TLID           IN       VARCHAR2
 )
IS
--
-- PURPOSE: BAO CAO DSKH MO TK (GUI HNX)
-- MODIFICATION HISTORY
-- PERSON      DATE      COMMENTS
-- QUOCTA   23-12-2011   CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION         VARCHAR2  (5);

   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);

   V_F_DATE            DATE;
   V_T_DATE            DATE;

   V_I_BRIDGD          VARCHAR2(100);
   V_BRNAME            NVARCHAR2(400);
   V_STRTLID varchar2(4);

BEGIN
  /* V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;
*/
    V_STROPTION := upper(OPT);
 V_INBRID := BRID;
    V_STRTLID:= TLID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;
   -- GET REPORT'S PARAMETERS
   V_F_DATE        := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
   V_T_DATE        := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      V_I_BRIDGD :=  I_BRIDGD;
   ELSE
      V_I_BRIDGD := '%%';
   END IF;

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      BEGIN
            SELECT BRNAME INTO V_BRNAME FROM BRGRP WHERE BRID LIKE I_BRIDGD;
      END;
   ELSE
      V_BRNAME   :=  ' To?c?ty ';
   END IF;

   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
FOR

SELECT CF.FULLNAME,case when cf.custatcom = 'Y' then '005' else 'N/A' end  TVCODE, CF.CUSTODYCD, CF.IDCODE, CF.ADDRESS, CF.IDDATE, CF.IDPLACE,
    (CASE WHEN substr(cf.custodycd,4,1) = 'F' THEN 'NN' ELSE 'TN' END) || '-' ||
    (CASE WHEN CF.CUSTTYPE = 'I' THEN 'CN' WHEN CF.CUSTTYPE = 'B' THEN 'TC' END) CUSTTYPE_NAME,
----    (CASE WHEN substr(cf.custodycd,4,1) = 'F' THEN 'NN' ELSE 'TN' END) businesstype,
           CF.OPNDATE, AL.CDCONTENT COUNTRY_NAME,
    al2.cdcontent, CR.grpname,nvl(re.custid,' ') recustid, nvl(re.fullname,' ') refullname
FROM  CFMAST CF, ALLCODE AL, allcode al2,(select * from tlgroups where GRPTYPE = '2' and Active ='Y') CR, vw_reinfo re
WHERE CF.COUNTRY = AL.CDVAL
    AND AL.CDNAME  = 'COUNTRY'
    AND AL.CDTYPE  = 'CF'
    and cf.status <> 'P'
    and al2.cdtype = 'CF' and al2.cdname = 'COUNTRY'
    AND CF.COUNTRY = AL2.CDVAL
    and cf.CUSTODYCD is not null
    and cf.custatcom = 'Y'
    AND CF.OPNDATE >= V_F_DATE AND cf.opndate <= V_T_DATE
    AND nvl(re.brid,CF.BRID) LIKE V_I_BRIDGD
    --AND substr(cf.custid,1,4) LIKE V_I_BRIDGD
    --AND (cf.brid LIKE V_STRBRID or instr(V_STRBRID,cf.brid) <> 0 )
    --AND (substr(cf.custid,1,4) LIKE V_STRBRID or instr(V_STRBRID,substr(cf.custid,1,4)) <> 0 )
    AND cf.careby = cr.grpid(+)
    and fn_getcarebydirectbroker(cf.custid, to_date(T_DATE,'dd/mm/rrrr'))=re.autoid(+)
    and exists (select gu.grpid from tlgrpusers gu where cf.careby = gu.grpid and gu.tlid = V_STRTLID )
---    ORDER BY CF.CUSTODYCD
union all
SELECT CF.FULLNAME,case when cf.custatcom = 'Y' then '005' else 'N/A' end  TVCODE, CF.CUSTODYCD, CF.IDCODE, CF.ADDRESS, CF.IDDATE, CF.IDPLACE,
    (CASE WHEN substr(cf.custodycd,4,1) = 'F' THEN 'NN' ELSE 'TN' END) || '-' ||
    (CASE WHEN CF.CUSTTYPE = 'I' THEN 'CN' WHEN CF.CUSTTYPE = 'B' THEN 'TC' END) CUSTTYPE_NAME,
----    (CASE WHEN substr(cf.custodycd,4,1) = 'F' THEN 'NN' ELSE 'TN' END) businesstype,
           busdate OPNDATE, AL.CDCONTENT COUNTRY_NAME,
    al.cdcontent, CR.grpname,nvl(re.custid,' ') recustid, nvl(re.fullname,' ') refullname
FROM vw_tllog_all, cfmast cf, ALLCODE AL,(select * from tlgroups where GRPTYPE = '2' and Active ='Y') CR, vw_reinfo re
    WHERE tltxcd = '0067' AND busdate <= to_date(T_DATE,'dd/mm/rrrr')
        AND busdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
        AND cf.custid = vw_tllog_all.msgacct
        AND cf.custatcom = 'Y' and CF.COUNTRY = AL.CDVAL
        AND AL.CDNAME  = 'COUNTRY'
        AND AL.CDTYPE  = 'CF'
        and cf.status <> 'P'
        /*AND CF.BRID LIKE V_I_BRIDGD
        AND (cf.brid LIKE V_STRBRID or instr(V_STRBRID,cf.brid) <> 0 )
        AND (cf.brid LIKE V_STRBRID or instr(V_STRBRID,cf.brid) <> 0 )*/
        AND nvl(re.brid,CF.BRID) LIKE V_I_BRIDGD
        --AND substr(cf.custid,1,4) LIKE V_I_BRIDGD
        --AND (substr(cf.custid,1,4) LIKE V_STRBRID or instr(V_STRBRID,substr(cf.custid,1,4)) <> 0 )
        AND cf.careby = cr.grpid(+)
        and nvl(fn_getcarebydirectbroker(cf.custid, to_date(T_DATE,'dd/mm/rrrr')),-1)=re.autoid
        and exists (select gu.grpid from tlgrpusers gu where cf.careby = gu.grpid and gu.tlid = V_STRTLID )
        --AND (substr(custid,1,4) LIKE V_STRBRID or instr(V_STRBRID,substr(custid,1,4)) <> 0 )
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;


-- End of DDL Script for Procedure HOST.CF0017
 
 
/
