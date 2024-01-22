SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE gl0040 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE        IN       VARCHAR2,
   T_DATE        IN       VARCHAR2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_ASSTYPE    IN       VARCHAR2,
   PV_ACCTYPE    IN       VARCHAR2

)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- GL0040: Investment
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DIEUNDA   29-JUN-15  CREATED
-- ---------   ------  -------------------------------------------
    V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_INBRID        VARCHAR2(4);
    V_STRBRID      VARCHAR2 (60);
    V_CUSTODYCD           VARCHAR2 (15);

    FDATE Date;
    TDATE Date;
    --

    --v_IDATE date;
    v_fdate_mk date;
    v_bdate date;
    v_bdate_mk date;
    v_edate_mk date;

    v_fdate_cp date;
    v_bdate_cp date;
    v_edate_cp date;

    V_ASSTYPE varchar2(10);
    V_ACCTYPE varchar2(10);
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

   IF(UPPER(PV_CUSTODYCD) <> 'ALL')
   THEN
        V_CUSTODYCD := UPPER(PV_CUSTODYCD);
   ELSE
        V_CUSTODYCD := '%';
   END IF;

   IF(UPPER(PV_ASSTYPE) <> 'ALL')
   THEN
        V_ASSTYPE := UPPER(PV_ASSTYPE);
   ELSE
        V_ASSTYPE := '%';
   END IF;

   IF(UPPER(PV_ACCTYPE) <> 'ALL')
   THEN
        V_ACCTYPE := UPPER(PV_ACCTYPE);
   ELSE
        V_ACCTYPE := '%';
   END IF;


   FDATE:=TO_DATE(F_DATE,'dd/MM/rrrr');
   TDATE:=TO_DATE(T_DATE,'dd/MM/rrrr');
   select MAX(histdate) into v_fdate_mk from vw_securities_info_hist where histdate < FDATE;
   v_bdate:=TO_DATE('01/'||SUBSTR(T_DATE,4,10),'dd/MM/rrrr');
   select MAX(histdate) into v_bdate_mk from vw_securities_info_hist where histdate < v_bdate;
   select MAX(histdate) into v_edate_mk from vw_securities_info_hist where histdate <= TDATE;

   select min(txdate) into v_fdate_cp from secostprice where txdate >= FDATE;
   select min(txdate) into v_bdate_cp from secostprice where txdate >= v_bdate;
   -- select MAX(txdate) into v_edate_cp from secostprice where txdate <= v_bdate;


OPEN PV_REFCURSOR FOR
select FDATE FRDATE, TDATE TODATE, a.type, a.symbol, a.issfullname, a.en_issfullname, a.StockExchange, decode(a.type,'CPNYLL', 'I','SLGD','II','III') grp,
    a.riskrate, round(a.riskrate/100*a.MarketAMT) MarketRisk, round(case when (a.riskrate/100*a.MarketAMT>0) then 0 else 0.5*a.CloseAMT end) Bookval50,
    a.BeginQTTY, a.BeginAMT, a.DividendQTTY, a.DividendAMT,
    a.IncrQTTY, a.IncrAMT, a.DecrQTTY, a.DecrPrice, a.DecrAMT,
    a.CloseQTTY, a.CloseAMT, a.SellQTTY, a.SellPrice, a.SellAMT,
    (case when a.SellAMT<a.DecrAMT then a.SellAMT-a.DecrAMT else 0 end) Loss, (case when a.SellAMT>a.DecrAMT then a.SellAMT-a.DecrAMT else 0 end) Profits,
    a.MarketPrice, a.MarketAMT, (case when a.MarketAMT-a.CloseAMT>0 then a.MarketAMT-a.CloseAMT else 0 end) ProviProfit,
    (case when a.MarketAMT-a.CloseAMT<0 then a.CloseAMT-a.MarketAMT else 0 end) ProviLoss,
    /*--An di cac tham so ProviLoss, ProviProfit, rever, provd vi cac tham so nay su dung so du cua ky truoc lam nang bao cao
    a.BeginProviProfit, a.BeginProviLoss,
    greatest(a.BeginProviLoss-(case when a.MarketAMT-a.CloseAMT<0 then a.CloseAMT-a.MarketAMT else 0 end),0) rever,
    greatest((case when a.MarketAMT-a.CloseAMT<0 then a.CloseAMT-a.MarketAMT else 0 end)-a.BeginProviLoss,0) provd,*/
    a.issued_shares_qtty listingqtty
from
(
    select mst.type, mst.symbol, mst.issfullname, mst.en_issfullname, mst.tradeplace,
        (case when mst.tradeplace='001' then 'HO'
                when mst.tradeplace='002' then 'HA'
                when mst.tradeplace='005' then 'UPCOM'
            else 'delisted' end) StockExchange,
        (case when mst.tradeplace='001' then 10 --HO
                when mst.tradeplace='002' then 15 --HA
                when mst.tradeplace='005' then 20 --UPCOM
            else 0 end) riskrate,
        mst.BeginQTTY, mst.BeginAMT, mst.DividendQTTY, mst.DividendAMT,mst.IncrQTTY, mst.IncrAMT, mst.DecrQTTY,
        round(case when mst.DecrQTTY>0 and (mst.BeginQTTY+mst.DividendQTTY+mst.IncrQTTY)<>0
            then (mst.BeginAMT+mst.DividendAMT+mst.IncrAMT)/(mst.BeginQTTY+mst.DividendQTTY+mst.IncrQTTY) else 0 end) DecrPrice,
        round((case when mst.DecrQTTY>0 and (mst.BeginQTTY+mst.DividendQTTY+mst.IncrQTTY)<>0
            then (mst.BeginAMT+mst.DividendAMT+mst.IncrAMT)/(mst.BeginQTTY+mst.DividendQTTY+mst.IncrQTTY) else 0 end)*mst.DecrQTTY) DecrAMT,
        (mst.BeginQTTY+mst.DividendQTTY+mst.IncrQTTY-mst.DecrQTTY) CloseQTTY,
        (mst.BeginAMT+mst.DividendAMT+mst.IncrAMT
            - round(mst.DecrQTTY*(case when mst.DecrQTTY>0 and (mst.BeginQTTY+mst.DividendQTTY+mst.IncrQTTY)<>0
                                then (mst.BeginAMT+mst.DividendAMT+mst.IncrAMT)/(mst.BeginQTTY+mst.DividendQTTY+mst.IncrQTTY) else 0 end)
                    )
        ) CloseAMT, mst.SellQTTY, mst.SellPrice, mst.SellAMT, mst.MarketPrice,
        (mst.BeginQTTY+mst.DividendQTTY+mst.IncrQTTY-mst.DecrQTTY)*mst.MarketPrice MarketAMT,
        /*case when mst.BeginAMT_MK-mst.BeginAMT_CP > 0 then mst.BeginAMT_MK else 0 end BeginProviProfit,
        case when mst.BeginAMT_CP-mst.BeginAMT_MK > 0 then mst.BeginAMT_CP else 0 end BeginProviLoss,*/--> Tam thoi an 2 tham so ProviProfit,ProviLoss cua ky truoc vi no lam nang bao cao
        mst.issued_shares_qtty issued_shares_qtty

    from
    (

        select (case when af.isoddlot = 'Y' then 'CPNYLL'
                    when af.acctno = '0001920029' then 'SLGD'
                    else 'CPNY'
               end) type, sb.symbol, iss.fullname issfullname, iss.en_fullname en_issfullname, sb.tradeplace,
            (
                (se.trade+se.receiving+se.blocked)
                -( nvl(tr.trade_namt,0)+nvl(tr.receiving_namt,0)+nvl(tr.blocked_namt,0)+nvl(se_move.CA_RECEIVING_moveall_amt,0) )
            ) BeginQTTY,
            (se.trade+se.receiving+se.blocked-nvl(tr.trade_namt,0)-nvl(tr.receiving_namt,0)-nvl(tr.blocked_namt,0)-nvl(se_move.CA_RECEIVING_moveall_amt,0)
            )*nvl(a.costprice,0) BeginAMT,
            /* -- An di cac gia tri cua ky truoc
            (se.trade+se.receiving+se.blocked-nvl(tr2.trade_namt,0)-nvl(tr2.receiving_namt,0)-nvl(tr2.blocked_namt,0)-nvl(se_move.CA_RECEIVING_moveall_amt,0)
            )*nvl(aa.costprice,0) BeginAMT_CP,
            (se.trade+se.receiving+se.blocked-nvl(tr2.trade_namt,0)-nvl(tr2.receiving_namt,0)-nvl(tr2.blocked_namt,0)-nvl(se_move.CA_RECEIVING_moveall_amt,0)
            )*nvl(bb.avgprice,0) BeginAMT_MK,
            */
            nvl(io.DividendQTTY,0) DividendQTTY, nvl(io.DividendAMT,0) DividendAMT, nvl(io.IncrQTTY,0) IncrQTTY, nvl(io.IncrAMT,0) IncrAMT,
            nvl(io.DecrQTTY,0) DecrQTTY, nvl(sell.QTTY,0) SellQTTY, nvl(sell.Price,0) SellPrice, nvl(sell.AMT,0) SellAMT,
            NVL(C.avgprice,0) MarketPrice, nvl(c.issued_shares_qtty,0) issued_shares_qtty --, 0 BeginProviProfit, 0 BeginProviLoss

        from semast se
            left join --phat sinh chung khoan dau ky
            (
               SELECT ACCTNO,
                   SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) TRADE_NAMT,
                   SUM(CASE WHEN FIELD = 'RECEIVING' and tltxcd<>'3351' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) RECEIVING_NAMT,
                   SUM(CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) BLOCKED_NAMT
               FROM VW_SETRAN_GEN
               WHERE DELTD <> 'Y' AND FIELD IN ('TRADE','RECEIVING','BLOCKED')
                   and busdate >= FDATE
                   and tltxcd not in ('3384')
               GROUP BY ACCTNO
               HAVING SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END
                           + CASE WHEN FIELD = 'RECEIVING' and tltxcd<>'3351' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END
                           + CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END
                          ) <> 0
            ) TR
            on SE.ACCTNO = TR.ACCTNO
            /*
            --An di cac tham so tinh toan cua ky truoc
            LEFT JOIN
            (--phat sinh chung khoan cuoi ky truoc
               SELECT ACCTNO,
                   SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) TRADE_NAMT,
                   SUM(CASE WHEN FIELD = 'RECEIVING' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) RECEIVING_NAMT,
                   SUM(CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) BLOCKED_NAMT
               FROM VW_SETRAN_GEN
               WHERE DELTD <> 'Y' AND FIELD IN ('TRADE','RECEIVING','BLOCKED')
                   and busdate >= v_bdate
                   and tltxcd not in ('3384')
               GROUP BY ACCTNO
               HAVING SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END
                           + CASE WHEN FIELD = 'RECEIVING' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END
                           + CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END
                          ) <> 0
            ) TR2
            on SE.ACCTNO = TR2.ACCTNO*/
            LEFT JOIN
            (   --LAY GIA VON DAU DAU KY
               SELECT ACCTNO,PREVQTTY,COSTPRICE
               FROM SECOSTPRICE
               WHERE TXDATE = v_fdate_cp
            )A ON SE.ACCTNO = A.ACCTNO
            LEFT JOIN
            (   --LAY GIA THI TRUONG DAU KY
               SELECT s.CODEID, s.SYMBOL, s.avgprice avgprice
               FROM vw_securities_info_hist s --, (Select * from securities_Delisting  where txdate<=v_fdate_mk) del
               WHERE s.histdate = v_fdate_mk
                    --and s.codeid=del.codeid(+)
            )B ON SE.CODEID = B.CODEID
            /*--An di tinh toan cua ky truoc
            LEFT JOIN
            (   --LAY GIA VON CUOI KY TRUOC
               SELECT ACCTNO,PREVQTTY,COSTPRICE
               FROM SECOSTPRICE
               WHERE TXDATE = v_bdate_cp
            )AA ON SE.ACCTNO = AA.ACCTNO
            LEFT JOIN
            (   --LAY GIA THI TRUONG CUOI KY TRUOC
               SELECT s.CODEID, s.SYMBOL, s.avgprice avgprice
               FROM vw_securities_info_hist s --, (Select * from securities_Delisting  where txdate<=v_bdate_mk) del
               WHERE s.histdate = v_bdate_mk
                    --and s.codeid=del.codeid(+)
            )BB ON SE.CODEID = BB.CODEID*/
            LEFT JOIN
            (   --LAY GIA THI TRUONG CUOI KY
               SELECT s.CODEID, s.SYMBOL, s.avgprice avgprice, s.issued_shares_qtty
               FROM vw_securities_info_hist s --, (Select * from securities_Delisting  where txdate<=v_edate_mk) del
               WHERE s.histdate = v_edate_mk
                    --and s.codeid=del.codeid(+)
            )C ON SE.CODEID = C.CODEID
            left join
            ( --phat sinh tang/giam ck
                select mst.acctno, mst.codeid, sum(mst.DividendQTTY) DividendQTTY, sum(mst.DividendAMT) DividendAMT, sum(mst.IncrQTTY) IncrQTTY,
                    sum(mst.IncrAMT) IncrAMT,sum(mst.DecrQTTY) DecrQTTY, sum(mst.DecrAMT) DecrAMT
                from
                (
                    select sec.acctno, sec.codeid, sum(decode(sec.camastid,null,0,' ',0,sec.qtty)) DividendQTTY,
                        sum(decode(sec.camastid,null,0,' ',0,sec.qtty*sec.costprice)) DividendAMT,
                        sum(decode(sec.ptype,'I',1,0)*decode(sec.camastid,
                                                                  null,case when tl.tltxcd in ('2245','2263','2242') then tl.msgamt else sec.qtty end,
                                                                  ' ',case when tl.tltxcd in ('2245','2263','2242') then tl.msgamt else sec.qtty end,
                                                                  0)
                            ) IncrQTTY,
                        sum(decode(sec.ptype,'I',1,0)*decode(sec.camastid,
                                                                null,case when tl.tltxcd in ('2245','2263','2242') then tl.msgamt else sec.qtty end*sec.costprice,
                                                                ' ',case when tl.tltxcd in ('2245','2263','2242') then tl.msgamt else sec.qtty end*sec.costprice,
                                                                0)
                            ) IncrAMT,
                        sum(decode(sec.ptype,'O',1,0)*decode(sec.camastid,
                                                                null,case when tl.tltxcd in ('2242') then tl.msgamt else sec.qtty end,
                                                                ' ',case when tl.tltxcd in ('2242') then tl.msgamt else sec.qtty end,
                                                            0)
                            ) DecrQTTY,
                        sum(decode(sec.ptype,'O',1,0)*decode(sec.camastid,
                                                                null,case when tl.tltxcd in ('2242') then tl.msgamt else sec.qtty end*sec.costprice,
                                                                ' ',case when tl.tltxcd in ('2242') then tl.msgamt else sec.qtty end*sec.costprice,
                                                            0)
                            ) DecrAMT
                    from secmast sec, vw_tllog_all tl, afmast af, cfmast cf
                    where sec.busdate BETWEEN FDATE and TDATE
                        --and camastid is not null
                        and sec.txnum=tl.txnum
                        and sec.busdate=tl.busdate
                        and sec.acctno=af.acctno
                        and af.custid=cf.custid
                        and cf.custodycd like '022P%'
                        --and tl.tltxcd <> '2201'
                        and tl.deltd <> 'Y'
                    group by sec.acctno, sec.codeid
                    union all
                    select sec.acctno, sb.codeid, sum(decode(sec.camastid,null,0,-sec.qtty)) DividendQTTY,
                        sum(decode(sec.camastid,null,0,-sec.qtty*sec.costprice)) DividendAMT,
                        sum(decode(sec.ptype,'O',1,0)*decode(sec.camastid,null,sec.qtty,0)) IncrQTTY,
                        sum(decode(sec.ptype,'O',1,0)*decode(camastid,null,sec.qtty*sec.costprice,0)) IncrAMT,
                        sum(decode(sec.ptype,'I',1,0)*decode(camastid,null,case when tl.tltxcd in('2263') then tl.msgamt else sec.qtty end,0)) DecrQTTY,
                        sum(decode(sec.ptype,'I',1,0)*decode(camastid,null,case when tl.tltxcd in('2263') then tl.msgamt else sec.qtty end*sec.costprice,0)) DecrAMT
                    from secmast sec, vw_tllog_all tl, afmast af, cfmast cf, sbsecurities sbr, sbsecurities sb
                    where sec.busdate BETWEEN FDATE and TDATE
                        and sec.txnum=tl.txnum
                        and sec.busdate=tl.busdate
                        and sec.acctno=af.acctno
                        and af.custid=cf.custid
                        and sb.symbol=sbr.symbol||'_WFT'
                        and sbr.codeid=sec.codeid
                        and cf.custodycd like '022P%'
                        and tl.deltd <> 'Y'
                        and tl.tltxcd in ('3356','3355','2263')
                    group by sec.acctno, sb.codeid
                    union all
                    /*select csh.afacctno acctno, csh.codeid, 0 DividendQTTY, sum(csh.amt) DividendAMT, 0 IncrQTTY, 0 IncrAMT, 0 DecrQTTY, 0 DecrAMT
                    from vw_tllog_all tl , vw_caschd_all csh, sbsecurities sb, afmast af, cfmast cf
                    where tl.tltxcd='3342'
                        and tl.busdate BETWEEN FDATE and TDATE
                        and cf.custodycd like '022P%'
                        and tl.msgacct = csh.camastid
                        and csh.codeid = sb.codeid
                        and csh.afacctno=af.acctno
                        and af.custid=cf.custid
                        and csh.amt>0
                        and tl.deltd <> 'Y' and csh.deltd <> 'Y'
                    group by csh.afacctno, csh.codeid*/
                    -- TH su kien quyen tien
                    select af.acctno acctno, fld.cvalue codeid, 0 DividendQTTY, sum(tl.msgamt) DividendAMT, 0 IncrQTTY, 0 IncrAMT, 0 DecrQTTY, 0 DecrAMT
                    from vw_tllog_all tl , afmast af, cfmast cf, vw_tllogfld_all fld
                    where tl.tltxcd in ('3354','3350')
                        and tl.busdate BETWEEN FDATE and TDATE
                        and tl.deltd <> 'Y'
                        and cf.custodycd like '022P%'
                        and fld.fldcd='24'
                        and tl.msgamt > 0
                        and tl.msgacct = af.acctno
                        and af.custid=cf.custid
                        and tl.txdate=fld.txdate
                        and tl.txnum=fld.txnum
                    group by af.acctno, fld.cvalue


                ) mst
                group by mst.acctno, mst.codeid

            ) io on SE.AFACCTNO = io.ACCTNO and SE.codeid = io.codeid
            left join
             (    -- Tong phat sinh field cac loai so du CK tu Txdate den ngay hom nay
                select tr.acctno,
                    sum
                    ( case when field = 'RECEIVING' and substr(tltxcd,1,2) not in ('22','33') then
                            (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                        else 0
                        end
                    ) se_RECEIVING_moveall_amt,         -- Phat sinh CK cho nhan ve
                    sum
                    ( case when field = 'RECEIVING' and substr(tltxcd,1,2) in ('22','33') then
                            (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                        else 0
                        end
                    ) CA_RECEIVING_moveall_amt  --Phat sinh quyen ve
                from vw_setran_gen tr
                where tr.sectype <> '004'
                    AND TR.deltd <> 'Y'
                    and tr.field = 'RECEIVING'
                    --and acctno like '0001000085%'
                    --and tr.txdate >= FDATE
                group by tr.acctno

                /*
                --phat sinh ck quyen 3384
                SELECT ACCTNO,
                   SUM(CASE WHEN FIELD = 'RECEIVING'  THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) RECEIVING_NAMT
               FROM VW_SETRAN_GEN
               WHERE DELTD <> 'Y' AND FIELD IN ('RECEIVING')
                   --and busdate >= FDATE
                   and tltxcd in ('3384')
               GROUP BY ACCTNO
               HAVING SUM(CASE WHEN FIELD = 'RECEIVING'  THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END
                          ) <> 0
               */
            ) se_move on se.acctno = se_move.acctno
            left join
            (--phat sinh ban
                select od.afacctno, od.codeid, sum(od.execqtty) qtty, round(sum(od.execamt)/sum(od.execqtty)) price, sum(od.execamt) amt
                from vw_odmast_all od
                where od.exectype='NS' and od.deltd <> 'Y'
                    and txdate BETWEEN FDATE and TDATE
                    and od.execqtty <> 0
                group by od.afacctno, od.codeid
            ) sell on SE.AFACCTNO = sell.AFACCTNO and SE.codeid = sell.codeid,
            sbsecurities sb, issuers iss, afmast af, cfmast cf
        where se.codeid = sb.codeid
            and se.afacctno = af.acctno
            and af.custid = cf.custid
            and iss.issuerid = sb.issuerid
            and cf.custodycd like '022P%'
            and sb.sectype<>'004'
            and (case when PV_ASSTYPE = 'ALL' then 1
                    when PV_ASSTYPE = 'C' and sb.sectype not in ('444','003','006','222') then 1
                    when PV_ASSTYPE = 'T' and sb.sectype in ('444','003','006','222') then 1
                    else 0 end) = 1
            and cf.custodycd like V_CUSTODYCD
    ) mst
    where mst.BeginQTTY+mst.DividendQTTY+mst.IncrQTTY+mst.DecrQTTY+mst.DividendAMT+mst.IncrAMT>0
) a
where a.type like V_ACCTYPE
order by decode(a.type,'CPNYLL', 'I','II') asc,a.symbol asc;

EXCEPTION
   WHEN OTHERS
   THEN
    plog.error('GL0040.' || sqlerrm || '.At:' || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
