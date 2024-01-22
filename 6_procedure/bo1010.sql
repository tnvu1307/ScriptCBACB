SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE bo1010 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_ORDERID     IN       VARCHAR2,
   PV_BTYPE     IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BO1010: Phieu ket qua giao dich trai phieu(GD mua di ban lai)
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

select PV_BTYPE btype, od.txdate, od.txtime, od.orderid, SUBSTR(cf.custodycd,1,3) TVLK, cf.custodycd, af.acctno, cf.fullname,
    --decode(od.contrafirm,'022',od.clientid,null) clientid, od.contrafirm,
    sb.codeid, sb.symbol,od.exectype, a0.cdcontent pexectype, od.matchqtty, od.matchprice, od.matchamt,
    getnextbusinessdate(od.txdate,od.clearday) cleardate, tbl.exptdate DaoHan,
    nvl(od2.txdate,null) txdate2, nvl(od2.matchqtty,0) matchqtty2, nvl(od2.matchprice,0) matchprice2, nvl(od2.matchamt,0) matchamt2,
    getnextbusinessdate(nvl(od2.txdate,null),nvl(od2.clearday,0)) cleardate2,
    getnextbusinessdate(nvl(od2.txdate,null),nvl(od2.clearday,0))-getnextbusinessdate(od.txdate,od.clearday) kyhanMBL,
    bo.INTMBL,bo.INTCOUPON, bo.LSTDPRICE, bo.PVRRRATE, bo.INTREPO, a2.cdcontent INTPAYMODE,
    round(bo.PERIODICPRICE)||' '||a1.cdcontent Term, sb.tradeplace, od.matchqtty*100000 faceAmt

from afmast af, cfmast cf, sbsecurities sb, bondsinfo bo,
    (
        select od.txdate, od.txtime, od.orderid,od.codeid, od.afacctno, io.execqtty matchqtty, io.execprice matchprice, io.execprice*io.execqtty matchamt,
            od.clearday,od.exectype
        from vw_odmast_all od, vw_iod_all io
        where io.orderid=od.orderid
        and io.deltd = 'N'
        and od.deltd = 'N'
        and od.matchtype = 'P'
        and io.execprice > 0
    ) od, --lenh goc
    allcode a0, allcode a1, allcode a2,
    tbl_odrepo tbl,
    (
        select od.txdate, od.txtime, od.orderid,od.codeid, od.afacctno, io.execqtty matchqtty, io.execprice matchprice, io.execprice*io.execqtty matchamt,
            od.clearday,od.exectype
        from vw_odmast_all od, vw_iod_all io
        where io.orderid=od.orderid
        and io.deltd = 'N'
        and od.deltd = 'N'
        and od.matchtype = 'P'
        and io.execprice > 0
    ) od2
where od.afacctno=af.acctno
    and af.custid=cf.custid
    and od.codeid=sb.codeid
    and bo.codeid=sb.codeid
    and sb.sectype in ('003','006','222','444')
    and a0.cdname='EXECTYPE' and a0.cdtype='OD'  and a0.cdval=od.exectype
    and a1.cdname='TYPETERM' and a1.cdtype='SA'  and a1.cdval=bo.TYPETERM
    and a2.cdname='INTPAYMODE' and a2.cdtype='SA'  and a2.cdval=nvl(sb.INTPAYMODE,'000')
    and od.orderid = tbl.orderid
    and tbl.orderid2 = od2.orderid(+)
    and od.orderid = pv_ORDERID
    and od.txdate = v_IDATE
    and (case when PV_BTYPE='001' and sb.tradeplace<>'010' then 1
            when PV_BTYPE='002' and sb.tradeplace='010' then 1
            else 0
        end) = 1

    ;



EXCEPTION
   WHEN OTHERS
   THEN
    plog.error('BO1010.' || sqlerrm || '.At:' || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
