SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0087 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   I_BRID         IN       VARCHAR2,
   PV_TRADEPLACE  IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_AFTYPE      IN       VARCHAR2,
   PV_SETYPR      IN       VARCHAR2
  )
IS
--
/*
thunt:them lay theo trung tam luu ky
*/
--
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   v_strIBRID     VARCHAR2 (4);
   vn_BRID        varchar2(50);
   vn_TRADEPLACE varchar2(50);
   v_strTRADEPLACE VARCHAR2 (4);
   v_OnDate date;
   v_CurrDate date;
   v_Symbol varchar2(20);
   V_STRaftype varchar2(20);
   V_SETYPR  varchar2(20);
BEGIN
V_STROPTION := upper(OPT);
IF V_STROPTION = 'A' THEN
    V_STRBRID := '%';
ELSIF V_STROPTION = 'B' then
    V_STRBRID:= substr(BRID,1,2) || '__';
else
    V_STRBRID := BRID;
END IF;
IF  (PV_SYMBOL <> 'ALL')
THEN
      v_Symbol := upper(PV_SYMBOL);
ELSE
   v_Symbol := '%%';
END IF;
IF  (upper(I_BRID) <> 'ALL')
THEN
      v_strIBRID := upper(I_BRID);
      SELECT brname INTO vn_BRID FROM brgrp WHERE brgrp.brid LIKE I_BRID;
ELSE
   v_strIBRID := '%%';
   vn_BRID := 'ALL';
END IF;
IF  (upper(PV_TRADEPLACE) <> 'ALL')
THEN
    v_strTRADEPLACE := upper(PV_TRADEPLACE);
    SELECT cdcontent INTO vn_TRADEPLACE FROM allcode WHERE cdtype = 'SE' AND cdname = 'TRADEPLACE' AND cdval like PV_TRADEPLACE ;
ELSE
   v_strTRADEPLACE := '%%';
   vn_TRADEPLACE := 'ALL';
END IF;
v_OnDate:= to_date(I_DATE,'DD/MM/RRRR');
-- Get Current date
select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';
if v_Symbol = 'ALL' or v_Symbol is null then
    v_Symbol := '%';
else
    v_Symbol := '%'||v_Symbol||'%';
end if;
if (upper(PV_AFTYPE) = 'ALL' or PV_AFTYPE is null) then
    V_STRaftype := '%';
else
    V_STRaftype := PV_AFTYPE;
end if;
if (upper(PV_SETYPR) = 'ALL' or PV_SETYPR is null) then
    V_SETYPR := '%';
else
    V_SETYPR := PV_SETYPR;
end if;
-- Main report
OPEN PV_REFCURSOR FOR
select * from (
    SELECT  v_OnDate currdate, symbol, parvalue,
        VW.custodycd,fullname, idcode, iddate,idplace,country,cd.cdcontent QTTY_TYPE,cd.lstodr,
        decode(cd.cdval,'TRADE', sum(end_trade_bal+end_netting_bal + camco_df + end_mortage_bal + end_WITHDRAW_bal + HOLD + end_emkqtty_bal - MORTAGE_CANCEL_PENDING - end_BLOCKTRANFER_bal), --Do trong WITHDRAW co thua BLOCKTRANFER nen tru di vi BLOCKTRANFER la BLOCKQTTY
                        'BLOCKQTTY',sum(end_blocked_bal+WITHDRAW_HCCN+end_BLOCKWITHDRAW_bal+end_BLOCKTRANFER_bal),
                        'NETTING', sum(NETTING_bal),
                        'MORTAGE',sum( end_STANDING_bal + MORTAGE_CANCEL_PENDING) ,  ---sua lai gia tri cam co
                       -- 'MORTAGE',sum( end_MOTAGE_TTLK_bal),
                        --17/02/2016 DieuNDA Tach Cho giao dich TDCN va Cho giao dich HCCN
                        --'WTRADE',sum(ck_cho_gd + end_WITHDRAW_bal_cho_gd ),
                        'WTRADE',sum(ck_cho_gd_TDCN ),
                        'WBLOCK',sum(ck_cho_gd_HCCN),
                        --End 17/02/2016 DieuNDA
                        'WITHDRAW',0,
                        'BLOCKED',0,
                        0) QTTY
                        --  'WITHDRAW',sum(end_WITHDRAW_bal),
                        --  'BLOCKED',sum(end_mortage_bal),0) QTTY
    FROM
    (
        select sebal.afacctno, sebal.acctno, sebal.parvalue,
            sebal.custodycd,sebal.fullname, sebal.idcode, sebal.iddate, sebal.idplace,sebal.country,
            CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN substr(sebal.symbol,1, instr(sebal.symbol,'_WFT')-1) ELSE sebal.symbol END symbol,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(se_balance,0) END se_balance,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(trade,0) END trade,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(trade,0) - nvl(se_trade_move_amt,0) -
                --nvl(trade_sell_qtty,0) + NVL(SR_QTTY.se_RETAIL_move_amt,0) END  end_trade_bal, --nam.ly 03/03/2020 Bo phat sinh netting trong ngay
                NVL(SR_QTTY.se_RETAIL_move_amt,0) END  end_trade_bal,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(blocked,0) END blocked,
            CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN 0 ELSE nvl(se_block.curr_block_qtty,0)
                --    nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0)
                    - nvl(se_BLOCKED_move_HCCN,0) END end_blocked_bal, -- han che CN
            CASE WHEN instr(sebal.symbol,'_WFT') = 0 THEN 0 ELSE nvl(se_block.curr_block_qtty,0) -
                    nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0)
                    - nvl(se_blocked_move_amt,0) END hccn_chogiao,
            CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN 0 ELSE nvl(mortage,0) END mortage,
            CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN 0 ELSE nvl(se_block.curr_block_pt,0) -
                    nvl(se_block_move.cr_block_amt_pt,0) + nvl(se_block_move.dr_block_amt_pt,0)
                     END  end_mortage_bal,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(netting,0) END netting,
            0 end_netting_bal,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(khop_today.khop_qtty,0) END khop_qtty,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(STANDING,0) END  standing,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE abs(nvl(sebal.STANDING,0)-nvl(se_STANDING_move_amt,0)) END end_STANDING_bal , -- Do standing luon <=0
            0 MORTAGE_CANCEL_PENDING,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(mortage,0)- nvl(se_mortage_move_amt,0) END end_MOTAGE_TTLK_bal,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(mortage,0)- nvl(se_mortage_move_amt,0) - (- (  nvl(STANDING,0) - nvl(se_STANDING_move_amt,0) )) END camco_df,
        /*    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(mortage,0)- nvl(se_mortage_move_amt,0)  END camco_df,*/
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(RECEIVING,0) END receiving,
            nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) +  nvl(CA_RECEIVING,0) + nvl(order_buy_today.receiving_qtty,0 ) end_RECEIVING_bal,
            CASE WHEN instr(sebal.symbol,'_WFT') = 0 THEN 0 ELSE nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) +
                nvl(order_buy_today.receiving_qtty,0) END CA_RECEIVING,
            CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(WITHDRAW,0) END  WITHDRAW,
               (CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0
                ELSE nvl(WITHDRAW,0)  -  NVL(WITHDRAW_HCCN.WITHDRAW_HCCN,0) -
                nvl(se_WITHDRAW_move_amt,0)  +
                ----24/09/2018 Bo doan nay Nguyen nhan no dang lay sai So luong HCCN cua CK quyen=> Lam so du Giao dich tinh sai trong truong hop thuc hien GD 3320_Huy dang ky CK
                --nvl(sebal.blocked,0) - nvl(se_block.curr_block_pt,0) - nvl(se_block.curr_block_qtty,0) -  nvl(se_BLOCKED_move_amt,0)
                - nvl(EMKQTTY,0) + nvl(se_EMKQTTY_move_amt,0) --26/09/2018: Do PHS mong muon khong so du TRADE khong cong SL CK bi phong toa tai cong ty vao de cuoi ngay tien doi chieu
                 + nvl(DTOCLOSE,0) - nvl(se_DTOCLOSE_move_amt,0)  end ) end_WITHDRAW_bal,
                 (CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0
                ELSE nvl(BLOCKWITHDRAW,0)  - nvl(se_BLOCKWITHDRAW_move_amt,0)
                END) end_BLOCKWITHDRAW_bal,
                (CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0
                ELSE nvl(BLOCKTRANFER,0)  - nvl(se_BLOCKTRANFER_move_amt,0)
                END) end_BLOCKTRANFER_bal,
                 --WITHDRAW_hccn
                     CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE NVL(WITHDRAW_HCCN.WITHDRAW_HCCN,0) - nvl(se_WITHDRAW_move_amt_hccn,0)  END  WITHDRAW_HCCN,
                   --Chung khoan cho giao dich
              (CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN nvl(DTOCLOSE,0) - nvl(se_DTOCLOSE_move_amt,0)  ELSE 0 END)   end_WITHDRAW_bal_cho_gd,
            CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN (
                nvl(trade,0) - nvl(se_trade_move_amt,0) +
                --- nvl(order_today.trade_sell_qtty,0) - nvl(order_today.mtg_sell_qtty,0) --nam.ly 03/03/2020 Bo phat sinh netting trong ngay
                --nvl(mortage,0) - nvl(se_mortage_move_amt,0) -
                --(nvl(STANDING,0) - nvl(se_STANDING_move_amt,0)) +
                nvl(netting,0) - nvl(se_netting_move_amt,0) - NVL(SR_QTTY.se_RETAIL_move_amt,0) +
                nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0) +
                nvl(DTOCLOSE,0) - nvl(se_DTOCLOSE_move_amt,0)
                --NVL(sebal.blocked,0) - nvl(se_BLOCKED_move_wft,0)
                ) ELSE 0 END ck_cho_gd_TDCN,
            CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN (
                nvl(mortage,0) - nvl(se_mortage_move_amt,0) +
                (nvl(STANDING,0) - nvl(se_STANDING_move_amt,0)) +
                nvl(EMKQTTY,0) - nvl(se_EMKQTTY_move_amt,0) +
                NVL(sebal.blocked,0) - nvl(se_BLOCKED_move_wft,0)+
                nvl(BLOCKWITHDRAW,0) - nvl(se_BLOCKWITHDRAW_move_amt,0)
                ) ELSE 0 END ck_cho_gd_HCCN,
            --End 17/02/2016 DieuNDA
            case when instr(sebal.symbol,'_WFT') <> 0 then 0
            else nvl(khop_qtty.execqtty,0) end ck_execqtty,
            case when instr(sebal.symbol,'_WFT') <> 0 then 0
            --else nvl(NETTING,0) - nvl(se_NETTING_move_amt,0) + nvl(order_today.EXECQTTY,0) - NVL(SR_QTTY.se_RETAIL_move_amt,0) end NETTING_bal
            else nvl(NETTING,0) - nvl(se_NETTING_move_amt,0) - NVL(SR_QTTY.se_RETAIL_move_amt,0) end NETTING_bal, --nam.ly 02/03/2020
            (CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN 0 ELSE nvl(HOLD,0) - nvl(se_HOLD,0) END) HOLD,
            (CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN 0 ELSE nvl(EMKQTTY,0) - nvl(se_EMKQTTY_move_amt,0) END) end_emkqtty_bal
        from
        (
        -- Tong so du CK hien tai group by tieu khoan, Symbol
            select
                cf.custid, cf.custodycd,cf.fullname,  DECODE(SUBSTR(CF.CUSTODYCD,4,1),'F',CF.TRADINGCODE,CF.IDCODE) idcode, cf.iddate, cf.idplace,cd.cdcontent country,
                af.acctno afacctno, symbol, se.acctno,
                sum(trade + blocked + mortage + netting + receiving) se_balance,
                sum(trade) trade, sum(blocked) blocked, sum(mortage) mortage, sum(netting) netting,
                sum(STANDING) STANDING, sum(RECEIVING) RECEIVING, sum(WITHDRAW) WITHDRAW, sum(BLOCKWITHDRAW) BLOCKWITHDRAW, sum(BLOCKTRANFER) BLOCKTRANFER, sum(DTOCLOSE) DTOCLOSE,
                max(parvalue) parvalue, sum(EMKQTTY) EMKQTTY, sum(HOLD) HOLD
            from cfmast cf, afmast af, semast se, --sbsecurities sb
                (select sb.*, nvl(wtf.tradeplace,sb.tradeplace) wtf_tradeplace, fn_symbol_tradeplace( nvl(wtf.codeid,sb.codeid), i_date  ) tradeplacenew
                from sbsecurities sb,sbsecurities wtf
                    where sb.refcodeid = wtf.codeid(+) and sb.depository IN ('001','002')) sb,--thunt:them lay theo trung tam luu ky --NAM.LY 10/03/2020 THEM DEPOSITORY = 002
                    (select * from allcode where  cdname='COUNTRY' and cdtype='CF') cd
            where cf.custid = af.custid and af.acctno = se.afacctno
                and cf.custatcom = 'Y'
                and se.codeid = sb.codeid
                and sb.symbol like v_Symbol
                --26/06/2018 DieuNDA: Sua san giong bao cao SE0008
                and sb.tradeplacenew like v_strTRADEPLACE
                --and sb.wtf_tradeplace like v_strTRADEPLACE
                --End 26/06/2018 DieuNDA
                and SUBSTR(cf.custodycd,4,1) like V_STRaftype
                and sb.sectype like V_SETYPR
                and sb.sectype <> '004'
                AND substr( CF.CUSTID, 1,4) LIKE v_strIBRID
                AND substr( CF.CUSTID, 1,4) LIKE V_STRBRID
                and cd.cdval = cf.country
            group by  cf.custid, af.acctno, symbol,se.acctno,cf.custodycd,cf.fullname,cf.idcode, cf.iddate, cf.idplace,cd.cdcontent,CF.TRADINGCODE
        ) sebal --on af.acctno = sebal.afacctno -------cf.custid=sebal.custid ---dien sua 2-10-2010
        left join
        (
            select sum(blocked+ sblocked) WITHDRAW_HCCN,acctno
            from sesendout
            where deltd <>'Y'
            group by acctno
            having sum(blocked+ sblocked) >0
        ) WITHDRAW_HCCN ON sebal.acctno = WITHDRAW_HCCN.acctno
        left join
        (
            select seacctno, sum(execqtty) execqtty
            from
            (
                select codeid, afacctno, seacctno, execqtty, txdate
                from odmast
                where execqtty > 0
                and exectype in ('MS','NS')
                and txdate <= v_OnDate
                union all
                select odhist.codeid, odhist.afacctno, odhist.seacctno, odhist.execqtty, odhist.txdate from odmasthist odhist, stschdhist  sthist
                where odhist.execqtty > 0
                and odhist.txdate <= v_OnDate
                and odhist.exectype in ('MS','NS')
                --and getduedate(txdate, clearcd, '000', clearday) > v_OnDate
                AND sthist.orgorderid=odhist.orderid
                AND sthist.duetype='RM'
                AND sthist.cleardate > v_OnDate
            )
            group by seacctno
        ) khop_qtty on sebal.acctno = khop_qtty.seacctno
        left join
        (   -- Phat sinh mua chung khoan ngay hom nay
            select st.afacctno acctno, case when v_CurrDate = v_OnDate then SUM(qtty) else 0 end receiving_qtty
            from sbsecurities sb, stschd  st
            where st.codeid = sb.codeid and sb.sectype <>'004'
            and st.duetype = 'RS' and st.status = 'P'
            and st.txdate = v_CurrDate
            and sb.depository='001'
            group by st.afacctno
        ) order_buy_today on sebal.acctno = order_buy_today.acctno
        left join
        (   -- Khop mua chung khoan ngay hom nay
            select st.afacctno acctno,SUM(qtty) khop_qtty
            from sbsecurities sb,
            (
                select *
                from stschd
                where txdate = v_OnDate
                union all
                select *
                from stschdhist
                where txdate = v_OnDate
            ) st
            where st.codeid = sb.codeid
            and sb.sectype <>'004'
            and st.duetype = 'SS' ---- and st.status = 'N'
            and sb.depository='001'
            group by st.afacctno
        ) khop_today on sebal.acctno = khop_today.acctno
        left join
        (
            -- Tong phat sinh field cac loai so du CK tu Txdate den ngay hom nay
            select tr.acctno,
                sum
                (case when field = 'TRADE' then
                        case when tr.txtype = 'D' then -tr.namt else tr.namt end
                    else 0
                    end
                ) se_trade_move_amt,            -- Phat sinh CK giao dich
                sum
                (case when field = 'MORTAGE' then
                        case when tr.txtype = 'D' then -tr.namt else tr.namt end
                     else 0
                     end
                ) se_MORTAGE_move_amt ,         -- Phat sinh CK Phong toa gom ca STANDING
                sum
                (case when field = 'BLOCKED'  and (nvl(tr.ref,'000') not in ('007','002') /*or tltxcd='2244'*/)  and tr.tltxcd not in ('2203','2202','2257','2263','3351') --19/10/2016 DieuNDA
                        then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0
                    end
                 ) se_BLOCKED_move_amt,      -- Phat sinh CK tam giu
                 sum
                (
                    case when field = 'BLOCKED'
                        then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0 end
                 ) se_BLOCKED_move_HCCN,      -- Phat sinh CK HCCN

                 sum
                (
                    case when field = 'BLOCKED'
                    then (case when tr.txtype = 'C' then tr.namt else -tr.namt end) else 0 end
                ) se_BLOCKED_move_wft, --CK cho giao dich
                sum
                ( case when field = 'NETTING' then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0
                    end
                ) se_NETTING_move_amt ,         -- Phat sinh CK cho giao
                sum
                ( case when field = 'STANDING' then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0
                    end
                ) se_STANDING_move_amt,         -- Phat sinh CK cam co len TT Luu ky
                sum
                ( case when field = 'RECEIVING' then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0
                    end
                ) se_RECEIVING_move_amt,         -- Phat sinh CK cho nhan ve
                sum
                ( case when field = 'RECEIVING' and txcd in('3351','3350') then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0
                    end
                ) CA_RECEIVING,
                sum
                ( case when field = 'WITHDRAW' AND NVL(TR.REF,'-')<> '002' then
                        (case when tr.txtype = 'D'  then -tr.namt else tr.namt end)
                    else 0
                    end
                ) se_WITHDRAW_move_amt,         -- Phat sinh CK cho nhan ve
                sum
                ( case when field = 'WITHDRAW' AND TR.REF ='002' then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0
                    end
                ) se_WITHDRAW_move_amt_HCCN,         -- Phat sinh CK cho nhan ve
                sum
                ( case when field = 'BLOCKWITHDRAW' then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0
                    end
                ) se_BLOCKWITHDRAW_move_amt, --Cho chuyen ra ngoai Blocked
                sum
                ( case when field = 'BLOCKTRANFER' then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0
                    end
                ) se_BLOCKTRANFER_move_amt, --Cho chuyen ra ngoai Blocked
                sum
                ( case when field = 'DTOCLOSE' then
                        (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
                    else 0
                    end
                ) se_DTOCLOSE_move_amt,
                sum
                ( case when field = 'BLOCKED' and tr.tltxcd = '2232'
                    then (case when tr.txtype = 'C' then tr.namt else 0 end)
                    else 0
                    end
                ) se_BLOCKED_move_2232,
                sum
                ( case when field = 'BLOCKED' and tr.tltxcd = '2251'
                    then (case when tr.txtype = 'D' then tr.namt else 0 end)
                    else 0 end
                ) se_BLOCKED_move_2251,
                sum
                (case when field = 'EMKQTTY' then
                        case when tr.txtype = 'D' then -tr.namt else tr.namt end
                     else 0
                     end
                ) se_EMKQTTY_move_amt,-- Phat sinh chung khoan phong toa khac EMKQTTY
                sum(case when field = 'HOLD' then
                        case when tr.txtype = 'D' then -tr.namt else tr.namt end
                      else 0
                 end) se_HOLD
            from vw_setran_gen tr
            where tr.busdate > v_OnDate and tr.busdate <= v_CurrDate
            and tr.sectype <> '004'
            and tr.field in ('EMKQTTY','TRADE','MORTAGE','BLOCKED','NETTING','STANDING','RECEIVING','WITHDRAW','DTOCLOSE','BLOCKWITHDRAW','BLOCKTRANFER','HOLD')
            group by tr.acctno
        ) se_field_move on sebal.acctno = se_field_move.acctno
        left join   -- So du chung khoan chuyen nhuong co dieu kien
        (
            select se.acctno, se.blocked curr_block_qtty, se.emkqtty curr_block_pt
            from semast se, sbsecurities sb
            where se.codeid = sb.codeid
            and sb.sectype <>'004'
            and sb.depository='001'
        ) se_block on sebal.acctno = se_block.acctno
        left join   -- Phat sinh giao dich phong toa/giai toa CK chuyen nhuong co dieu kien
        (
            select tr.acctno,
                sum(case when  (tr.tltxcd = '2202' OR ( tr.tltxcd = '9902' AND TXTYPE='C')) and tr.field='BLOCKED' /*tr.ref = '002'*/ then namt else 0 end) cr_block_amt,
                sum(case when (tr.tltxcd = '2203' OR ( tr.tltxcd = '9902' AND TXTYPE='D')) and tr.field='BLOCKED' /*tr.ref = '002'*/ then namt else 0 end) dr_block_amt,
                sum(case when (tr.tltxcd = '2202' OR ( tr.tltxcd = '9902' AND TXTYPE='C')) and tr.field='EMKQTTY' /*tr.ref = '007'*/ then namt else 0 end) cr_block_amt_pt,
                sum(case when (tr.tltxcd = '2203' OR ( tr.tltxcd = '9902' AND TXTYPE='D')) and tr.field='EMKQTTY' /*tr.ref = '007'*/ then namt else 0 end) dr_block_amt_pt
            from vw_setran_gen tr
            where tr.field in ('BLOCKED','EMKQTTY')
                AND tr.symbol LIKE '%'
                and tr.tltxcd in ('2202','2203','9902') /*and tr.ref in ('002','007')*/ and tr.namt <> 0
                and tr.busdate > v_OnDate and tr.busdate <= v_CurrDate and tr.deltd <> 'Y'
            group by tr.acctno
        ) se_block_move on sebal.acctno = se_block_move.acctno
        LEFT JOIN
        (   -- SO LUONG CK LO LE CHO BAN'
            SELECT TR.acctno, SUM(tr.qtty) se_RETAIL_move_amt
            FROM seretail TR
            WHERE tr.busdate <= v_OnDate
                AND nvl(tr.sdate,v_CurrDate+1) >  v_OnDate
                --AND tr.status NOT IN ('C','I')
                AND tr.busdate <> nvl(tr.sdate,v_CurrDate+1)
            GROUP BY TR.ACCTNO
        ) SR_QTTY ON SEBAL.ACCTNO = SR_QTTY.ACCTNO
        where v_OnDate <= v_CurrDate
        order by sebal.symbol, sebal.afacctno
    ) dt,
    (select * from allcode where cdname = 'TRADETYPE' and cdtype = 'SE') CD,
    (select CUSTODYCD_ORG, CUSTODYCD from VW_CFMAST_M) VW
    where CD.CDVAL is not null
    AND dt.CUSTODYCD = VW.CUSTODYCD_ORG
    group by symbol, parvalue,VW.custodycd,fullname, idcode, iddate,idplace,country, cd.cdval,cd.cdcontent,cd.lstodr
    having sum(end_trade_bal+end_mortage_bal+camco_df+end_netting_bal+end_WITHDRAW_bal+HOLD+end_emkqtty_bal-MORTAGE_CANCEL_PENDING-end_BLOCKTRANFER_bal) <> 0 or
           sum(end_blocked_bal+end_BLOCKWITHDRAW_bal+end_BLOCKTRANFER_bal+WITHDRAW_HCCN) <> 0 or
           sum(end_STANDING_bal+MORTAGE_CANCEL_PENDING) <> 0 or
           sum(hccn_chogiao) <> 0 or
           sum(ck_cho_gd_TDCN) <> 0 or
           sum(ck_cho_gd_HCCN) <> 0 or
           sum(ck_execqtty) <> 0 or
           sum(NETTING_bal) <> 0
)
where QTTY > 0;

EXCEPTION
  WHEN OTHERS
   THEN
        PLOG.ERROR('SE0087: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN;
END;
/
