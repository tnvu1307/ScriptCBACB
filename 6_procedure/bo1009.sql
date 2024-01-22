SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE bo1009 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_ORDERID     IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BO1009: Phieu ket qua giao dich trai phieu(GD thong thuong)
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DIEUNDA   12-MAY-15  CREATED
-- ---------   ------  -------------------------------------------
    V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_INBRID        VARCHAR2(4);
    V_STRBRID      VARCHAR2 (50);


    v_IDATE date;
    v_ORDERID   varchar2(20);


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

select od.txdate, od.txtime, od.orderid, SUBSTR(cf.custodycd,1,3) TVLK, cf.custodycd, af.acctno, cf.fullname,
    sb.codeid, sb.symbol,od.exectype, a0.cdcontent pexectype, iod.execqtty matchqtty, iod.execprice matchprice, iod.execprice*iod.execamt matchamt,
    getnextbusinessdate(od.txdate,od.clearday) cleardate,  a2.cdcontent INTPAYMODE,
    bo.yield LoiSuat, bo.LSTDPRICE GiaYet, bo.INTCOUPON LaiCoupon, round(bo.PERIODICPRICE)||' '||a1.cdcontent Term, sb.tradeplace
from vw_odmast_all od, vw_iod_all iod, afmast af, cfmast cf, sbsecurities sb, bondsinfo bo,
    allcode a0, allcode a1, allcode a2
where od.afacctno=af.acctno
    and af.custid=cf.custid
    and od.codeid=sb.codeid
    and bo.codeid=sb.codeid
    and iod.orderid=od.orderid
    and iod.deltd = 'N'
    and od.deltd = 'N'
    and od.matchtype='P'
    and sb.sectype in ('006','222','003','444')
    and a0.cdname='EXECTYPE' and a0.cdtype='OD'  and a0.cdval=od.exectype
    and a1.cdname='TYPETERM' and a1.cdtype='SA'  and a1.cdval=bo.TYPETERM
    and a2.cdname='INTPAYMODE' and a2.cdtype='SA'  and a2.cdval=nvl(sb.INTPAYMODE,'000')
    and not EXISTS (select * from TBL_ODREPO t where t.orderid=od.orderid)
    and od.orderid = pv_ORDERID
    and od.txdate = v_IDATE
    ;



EXCEPTION
   WHEN OTHERS
   THEN
    plog.error('BO1009.' || sqlerrm || '.At:' || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
