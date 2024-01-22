SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE DD6010 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   --TLGOUPS        IN       varchar2,
   --TLSCOPE        IN       VARCHAR2,
   P_MONTH        IN       VARCHAR2,
   P_GCB          IN       VARCHAR2
)
IS
-- ---------   ------  -------------------------------------------
    V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_INBRID        VARCHAR2(4);
    V_STRBRID      VARCHAR2 (50);
    l_frDate       DATE;
    l_toDate       DATE;

BEGIN
  l_frDate := trunc(to_date(p_month,'mm/rrrr'));
  l_toDate := add_months(l_frdate, 1) - 1;
  
  OPEN PV_REFCURSOR 
  FOR
      SELECT cf.fullname, 
             cf.cifid,
             cf.amcid,
             decode(cf.country,'234', substr(cf.custodycd, 5), cf.tradingcode) tradingcode,
             fee.feeamt
      FROM cfmast cf, famembers fa,
           (
               SELECT vw.CUSTODYCD, SUM(vw.FEEAMT) feeamt
               FROM vw_feetran_all vw
               WHERE vw.TXDATE BETWEEN l_frDate AND l_toDate
               GROUP BY vw.CUSTODYCD
           ) fee
      WHERE cf.custodycd = fee.custodycd
      AND fa.roles = 'GCB' AND fa.autoid = cf.gcbid AND fa.shortname = P_GCB
      ORDER BY cf.amcid, cf.cifid
    ;



EXCEPTION
   WHEN OTHERS
   THEN
    plog.error('DD6010.' || sqlerrm || '.At:' || dbms_utility.format_error_backtrace);
      RETURN;
END;

/
