SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE bo1012 (
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
-- BO1012: Bond/T-Bill trading results(Repos trading)
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DIEUNDA   14-MAY-15  CREATED
-- ---------   ------  -------------------------------------------
    V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_INBRID        VARCHAR2(4);
    V_STRBRID      VARCHAR2 (50);


    v_IDATE date;
    v_ORDERID   varchar2(20);
    v_currdate date;
    v_BRADDRESS varchar2(300);
    v_HEADOFFICE varchar2(150);

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

    select max(case when varname='BRADDRESS' then en_vardesc else '' end) ,
        max(case when varname='HEADOFFICE' then en_vardesc else '' end) into v_BRADDRESS,v_HEADOFFICE
    from sysvar
    where varname in ('BRADDRESS','HEADOFFICE') and grname='SYSTEM';

   v_IDATE:=TO_DATE(I_DATE,'dd/MM/rrrr');
    v_currdate:=getcurrdate;

OPEN PV_REFCURSOR FOR

select PV_BTYPE btype, v_currdate currdate, v_BRADDRESS BRADDRESS, v_HEADOFFICE HEADOFFICE, od.txdate, od.txtime, od.orderid, SUBSTR(cf.custodycd,1,3) TVLK, cf.custodycd, af.acctno, cf.fullname,
    /*decode(od.contrafirm,'022',od.clientid,null)*/ '' clientid, '' contrafirm,
    sb.codeid, sb.symbol,od.exectype, a0.en_cdcontent pexectype, od.matchqtty, od.matchprice, od.matchamt,
    getnextbusinessdate(od.txdate,od.clearday) cleardate, tbl.exptdate DaoHan,
    tbl.exptdate txdate2, od.matchqtty matchqtty2, tbl.price2*1000 matchprice2, od.matchqtty*tbl.price2*1000 matchamt2,
    getnextbusinessdate(tbl.exptdate,1) cleardate2,
    getnextbusinessdate(tbl.exptdate,1)-getnextbusinessdate(od.txdate,od.clearday) kyhanMBL,
    bo.INTMBL,bo.INTCOUPON, bo.LSTDPRICE, bo.PVRRRATE, bo.INTREPO, a2.en_cdcontent INTPAYMODE,
    round(bo.PERIODICPRICE)||' '||a1.en_cdcontent Term, sb.tradeplace, od.matchqtty*100000 faceAmt

from afmast af, cfmast cf, sbsecurities sb, bondsinfo bo,
    (
        select od.txdate, od.txtime, od.orderid,od.codeid, od.afacctno, io.execqtty matchqtty, io.execprice matchprice, io.execprice*io.execqtty matchamt,
            od.clearday,od.exectype
        from vw_odmast_all od, vw_iod_all io
        where io.orderid=od.orderid
        and io.deltd = 'N'
        and od.deltd = 'N'
        and od.matchtype = 'P'
        and io.execqtty > 0
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
        and io.execqtty > 0
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
    plog.error('BO1012.' || sqlerrm || '.At:' || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
