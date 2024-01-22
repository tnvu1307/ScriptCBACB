SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE bo1013 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BO1013: Phieu lenh mua TP/TPKB(Buy on bond/T-bill order)
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DIEUNDA   15-MAY-15  CREATED
-- ---------   ------  -------------------------------------------
    V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_INBRID        VARCHAR2(4);
    V_STRBRID      VARCHAR2 (50);


    v_IDATE date;

BEGIN
   V_STROPTION := OPT;

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


   v_IDATE:=TO_DATE(I_DATE,'dd/MM/rrrr');


OPEN PV_REFCURSOR FOR

    select od.txdate, od.txtime, od.orderid, cf.custodycd, cf.fullname, af.acctno afacctno, sb.symbol,
        /*decode(od.contrafirm,'022',od.clientid,null)*/ od.contrafirm||' - '||depo.fullname clientid, od.contrafirm,
        od.orderqtty orderqtty, od.orderprice quoteprice, od.orderqtty*od.orderprice orderamt, od.orderprice/1000 GiaYet, tlp.tlname, tlp.tlfullname,
        od.exectype, a0.cdcontent pexectype
    from vw_odmast_all od, afmast af, cfmast cf, sbsecurities sb, bondsinfo bo, tlprofiles tlp, allcode a0, deposit_member depo
    where od.afacctno=af.acctno
        and af.custid=cf.custid
        and sb.codeid=od.codeid
        and sb.codeid=bo.codeid
        and tlp.tlid=od.tlid
        and depo.depositid=od.contrafirm
        and od.exectype='NB'
        and od.deltd = 'N'
        and od.matchtype='P'
        and sb.sectype in ('006','222','003','444')
        and a0.cdname='EXECTYPE' and a0.cdtype='OD'  and a0.cdval=od.exectype
        and not EXISTS (select * from tbl_odrepo tb where tb.orderid=od.orderid or ref_orderid=od.orderid)
        and cf.custodycd = PV_CUSTODYCD
        and od.txdate = v_IDATE
    ;



EXCEPTION
   WHEN OTHERS
   THEN
    plog.error('BO1013.' || sqlerrm || '.At:' || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
