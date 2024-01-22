SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca0011 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,

   CACODE         IN       VARCHAR2, --Mã s? ki?n
   P_NUMBER      IN  VARCHAR2, --SO
   PLSENT         in       varchar2 -- NOI GUI
   )
IS
--
-- RePort NAME: GIAY DANG KY MUA CK
-- Date : 24/05/2011
-- Hien.vu
-----------------------------------------------

V_STRCACODE   VARCHAR2 (20);
V_NUMBER   VARCHAR2 (20);
v_VSDBANKNAME VARCHAR2 (200);
v_VSDACCTNO VARCHAR2 (200);
v_PHONE             varchar2(200);
v_FAX               varchar2(200);
v_sysvar varchar2(100);

BEGIN
V_STRCACODE :=  CACODE;
V_NUMBER :=P_NUMBER;

Select max(case when  varname='VSDBANKNAME' then varvalue else '' end),
       max(case when  varname='VSDACCTNO' then varvalue else '' end),
       max(case when  varname='PHONE' then varvalue else '' end),
       max(case when  varname='FAX' then varvalue else '' end)
into v_VSDBANKNAME,v_VSDACCTNO,v_PHONE,v_FAX
from sysvar WHERE varname IN ('VSDBANKNAME','VSDACCTNO','PHONE','FAX');

SELECT varvalue into v_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';
-- GET REPORT'S PARAMETERS
OPEN PV_REFCURSOR
   FOR
SELECT PLSENT sendto,P_NUMBER as PNUMBER,v_VSDBANKNAME AS ACCOUNT_NAME,v_VSDACCTNO AS ACCOUNT_NO,v_FAX AS FAX,v_PHONE AS PHONE,
sec.secname, sec.seccode, sec.parvalue, sec.symbol, replace(UTILS.so_thanh_chu(ca.exprice),',','.') exprice, ca.reportdate,CA.optsymbol ISINCODE,
----    SUBSTR (cf.custodycd, 4, 1) custodycd,
    replace(UTILS.so_thanh_chu(sum(case when SUBSTR (cf.custodycd,4,1) in ('C','B') then caschd.qtty else 0 end)),',','.')c_qtty,
    --sum(case when SUBSTR (cf.custodycd,4,1) in ('C','B') then caschd.qtty else 0 end) c_qtty,
    replace(UTILS.so_thanh_chu(sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then caschd.qtty else 0 end)),',','.') f_qtty,
    --sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then caschd.qtty else 0 end) f_qtty,
    replace(UTILS.so_thanh_chu(sum(case when SUBSTR (cf.custodycd,0,4) = v_sysvar then caschd.qtty else 0 end)),',','.') p_qtty,
    replace(UTILS.so_thanh_chu(sum( caschd.qtty)),',','.') s_qtty,
    -- caschd.pbalance+caschd.roretailbal
/*
    sum(case when SUBSTR (cf.custodycd,4,1) = 'C' then caschd.retailbal+caschd.roretailbal+caschd.inbalance else 0 end) c_pqtty,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then caschd.retailbal+caschd.roretailbal+caschd.inbalance else 0 end) f_pqtty,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'P' then caschd.retailbal+caschd.roretailbal+caschd.inbalance else 0 end) p_pqtty,
*/

    replace(UTILS.so_thanh_chu(sum(case when SUBSTR (cf.custodycd,4,1) in ('C','B') then caschd.pbalance+caschd.balance else 0 end)),',','.') c_pqtty,
    replace(UTILS.so_thanh_chu(sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then caschd.pbalance+caschd.balance else 0 end)),',','.') f_pqtty,
    replace(UTILS.so_thanh_chu(sum(case when SUBSTR (cf.custodycd,0,4) = v_sysvar then caschd.pbalance+caschd.balance else 0 end)),',','.') p_pqtty,
    replace(UTILS.so_thanh_chu(sum(caschd.pbalance+caschd.balance)),',','.') s_pqtty,

    replace(UTILS.so_thanh_chu(sum(case when SUBSTR (cf.custodycd,4,1) in ('C','B') then caschd.aamt else 0 end)),',','.') c_aamt,
    replace(UTILS.so_thanh_chu(sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then caschd.aamt else 0 end)),',','.') f_aamt,
    replace(UTILS.so_thanh_chu(sum(case when SUBSTR (cf.custodycd,0,4) = v_sysvar then caschd.aamt else 0 end)),',','.') p_aamt,
    replace(UTILS.so_thanh_chu(sum(caschd.aamt)),',','.') s_aamt
FROM CFMAST cf, afmast af, caschd, camast ca,
    (
        SELECT sb.codeid, iss.issuerid, iss.shortname seccode, iss.fullname secname, sb.parvalue, sb.symbol
        FROM issuers iss, sbsecurities sb
        WHERE iss.issuerid = sb.issuerid
    ) sec
WHERE cf.custid = af.custid
    AND af.acctno = caschd.afacctno
    AND caschd.camastid = ca.camastid
    --AND caschd.codeid = sec.codeid --chaunh 02/10/2012 moved
    AND nvl(ca.tocodeid,ca.codeid) = sec.codeid --chaunh 02/10/2012 added
    AND caschd.deltd <> 'Y'
    AND caschd.status <> 'C'
    AND ca.deltd <> 'Y'
    --AND ca.status <> 'C'
    AND ca.catype = '014'
    AND ca.camastid = v_strcacode
group by sec.secname, sec.seccode, sec.parvalue, sec.symbol, ca.exprice, ca.reportdate,CA.optsymbol
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
