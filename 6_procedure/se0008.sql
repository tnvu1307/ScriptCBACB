SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0008 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   I_BRID         IN       VARCHAR2,
   PV_TRADEPLACE  IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   TLID            IN       VARCHAR2
  )
IS
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPT       VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (100);                   -- USED WHEN V_NUMOPTION > 0
   V_INBRID       VARCHAR2 (5);
   v_strIBRID     VARCHAR2 (4);
   vn_BRID        varchar2(50);
   vn_TRADEPLACE varchar2(50);
   v_strTRADEPLACE VARCHAR2 (4);
   v_OnDate date;
   v_CurrDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);
   v_Symbol varchar2(20);
   V_STRTLID           VARCHAR2(6);
BEGIN
/*IF V_STROPTION = 'A' THEN
    V_STRBRID := '%';
ELSIF V_STROPTION = 'B' then
    V_STRBRID := BRID;
else
    V_STRBRID := BRID;
END IF;*/
    V_STRTLID:= TLID;
    V_STROPT := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPT = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPT = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;
--
IF  (PV_SYMBOL <> 'ALL')
THEN
      v_Symbol := upper(REPLACE (PV_SYMBOL,' ','_'));
ELSE
   v_Symbol := '%';
END IF;
--
IF PV_CUSTODYCD = 'ALL' OR PV_CUSTODYCD IS NULL --NAM.LY 12-12-2019
THEN
    v_CustodyCD := '%';
ELSE
    v_CustodyCD := upper(PV_CUSTODYCD);
END IF;
--
IF  (PV_AFACCTNO <> 'ALL')
THEN
      v_AFAcctno := upper(PV_AFACCTNO);
ELSE
   v_AFAcctno := '%';
END IF;
--

IF  (upper(I_BRID) <> 'ALL')
THEN
      v_strIBRID := upper(I_BRID);
      SELECT brname INTO vn_BRID FROM brgrp WHERE brgrp.brid LIKE I_BRID;
ELSE
   v_strIBRID := '%';
   vn_BRID := 'ALL';
END IF;
--
IF  (upper(PV_TRADEPLACE) <> 'ALL')
THEN
      v_strTRADEPLACE := upper(PV_TRADEPLACE);
      SELECT cdcontent INTO vn_TRADEPLACE FROM allcode WHERE cdtype = 'SE' AND cdname = 'TRADEPLACE' AND cdval like PV_TRADEPLACE ;
ELSE
   v_strTRADEPLACE := '%';
   vn_TRADEPLACE := 'ALL';
END IF;
--
v_OnDate:= to_date(I_DATE,'DD/MM/RRRR');
-- Get Current date
select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';
--
if v_AFAcctno = 'ALL' or v_AFAcctno is null then
    v_AFAcctno := '%';
else
    v_AFAcctno := v_AFAcctno;
end if;
--
if v_Symbol = 'ALL' or v_Symbol is null then
    v_Symbol := '%';
else
    v_Symbol := '%'|| v_Symbol||'%';
end if;
-- Main report
OPEN PV_REFCURSOR FOR
SELECT * FROM (
select v_OnDate txdate, vn_BRID chi_nhanh, vn_TRADEPLACE san_gd, v_CustodyCD custody, DECODE(v_CustodyCD,'%',v_AFAcctno,CF.CIFID) afacc, v_Symbol lsymbol,
    I_DATE ngay_tc,
    cf.custodycd, cf.fullname, aft.mnemonic, NULL SEACCTNO, AF.ACCTNO afacctno,
    (case when SB.REFSYMBOL is null then SB.SYMBOL else SB.REFSYMBOL end) SYMBOL,
    SB.TRADEPLACE, a0.cdcontent TRADEPLACE_name,
        --chung khoan giao dich.
        sum(case when SB.REFSYMBOL is null then SE.TRADE - NVL(TR.TRADE_NAMT,0)-nvl(order_sell_today.trade_qtty,0) else 0 end) TRADE_AMT,
        --chung khoan han che chuyen nhuong.
        sum(case when SB.REFSYMBOL is null then se.BLOCKED-nvl(tr.BLOCKED_NAMT,0) else 0 end) BLOCKED_AMT,
        --- chung khoan phong toa khac.
        sum(case when SB.REFSYMBOL is null then se.EMKQTTY-nvl(tr.EMKQTTY_NAMT,0) else 0 end) EMKQTTY_AMT,
        --- chung khoan cam co
        --sum(case when SB.REFSYMBOL is null then se.MORTAGE-nvl(tr.MORTAGE_NAMT,0) else 0 end) MORTAGE_AMT,
        0 MORTAGE_AMT,
        0 BLKMORTAGE_AMT,
        --- chung khoan cam co VSD
        sum(case when SB.REFSYMBOL is null then abs(se.STANDING)-nvl(tr.STANDING_NAMT,0) else 0 end) STANDING_AMT,
        --- chung khoan cho ve
        --03/09/2015, TruongLD modified
        -- Lay tu tran la du --> khong can lay theo cong thuc ben duoi
        sum(case when SB.REFSYMBOL is null then (nvl(SE.RECEIVING,0) - nvl(tr.RECEIVING_NAMT,0) - nvl(order_buy_today.receiving_qtty,0))
                    else 0 end + nvl(se_rcv_move.ca_receiving_moveall_amt,0)) RECEIVING_AMT,
        /*
        sum(case when SB.REFSYMBOL is null then
                (
                    - nvl(tr.RECEIVING_NAMT,0) +  nvl(tr.CA_RECEIVING_NAMT,0) + nvl(order_buy_today.receiving_qtty,0)) else 0 end)
                + sum(nvl(RECEIVING,0) - nvl(se_RECEIVING_moveall_amt,0) - nvl(tr.CA_RECEIVING_NAMT,0)-nvl(se_rcv_move.CA_RECEIVING_moveall_amt,0)) RECEIVING_AMT,
        */
        sum(nvl(RECEIVING,0) - nvl(se_RECEIVING_moveall_amt,0) - nvl(tr.CA_RECEIVING_NAMT,0)) RECEIVING_CA_AMT,
        --- chung khoan cho chuyen ra ngoai
        sum(case when SB.REFSYMBOL is null then se.WITHDRAW-nvl(tr.WITHDRAW_NAMT,0) else 0 end) WITHDRAW_AMT,
        --- chung khoan cho dong
        sum(case when SB.REFSYMBOL is null then se.DTOCLOSE-nvl(tr.DTOCLOSE_NAMT,0) else 0 end) DTOCLOSE_AMT,
        --- chung khoan cho chuyen ra ngoai HCCN
        sum(case when SB.REFSYMBOL is null then se.BLOCKWITHDRAW-nvl(tr.BLOCKWITHDRAW_NAMT,0) else 0 end) BLOCKWITHDRAW_AMT,
        --- chung khoan cho dong HCCN
        sum(case when SB.REFSYMBOL is null then se.BLOCKDTOCLOSE-nvl(tr.BLOCKDTOCLOSE_NAMT,0) else 0 end) BLOCKDTOCLOSE_AMT,
        --- ban cho giao
        --sum(case when SB.REFSYMBOL is null then (se.netting + nvl(order_today.khop_qtty,0) - nvl(tr.NETTING_NAMT,0)) else 0 end) khop_qtty,
        sum(case when SB.REFSYMBOL is null then (se.netting - nvl(tr.NETTING_NAMT,0)) else 0 end) khop_qtty, --nam.ly 23/03/2020 kl ban trong ngay da cong vao netting roi
        --- ban cho khop
        sum(case when SB.REFSYMBOL is null then (nvl(order_today.trade_sell_qtty,0) + nvl(order_today.mtg_sell_qtty,0) - nvl(order_today.khop_qtty,0)) else 0 end ) end_netting_bal,
        --chung khoan cho giao dich.
        --chung khoan giao dich.
        sum(case when SB.REFSYMBOL is null then 0 else SE.TRADE-NVL(TR.TRADE_NAMT,0) end) TRADE_WFT_AMT,
        --chung khoan han che chuyen nhuong.
        sum(case when SB.REFSYMBOL is null then 0 else se.BLOCKED-nvl(tr.BLOCKED_NAMT,0) end) BLOCKED_WFT_AMT,
        --- chung khoan phong toa khac.
        sum(case when SB.REFSYMBOL is null then 0 else se.EMKQTTY-nvl(tr.EMKQTTY_NAMT,0) end) EMKQTTY_WFT_AMT,
        --- chung khoan cam co
        sum(case when SB.REFSYMBOL is null then 0 else se.MORTAGE-nvl(tr.MORTAGE_NAMT,0) end) MORTAGE_WFT_AMT,
        --- chung khoan cam co VSD
        sum(case when SB.REFSYMBOL is null then 0 else se.STANDING-nvl(tr.STANDING_NAMT,0) end) STANDING_WFT_AMT,
        --- chung khoan cho chuyen ra ngoai
        sum(case when SB.REFSYMBOL is null then 0 else se.WITHDRAW-nvl(tr.WITHDRAW_NAMT,0) end) WITHDRAW_WFT_AMT,
        --- chung khoan cho dong
        sum(case when SB.REFSYMBOL is null then 0 else se.DTOCLOSE-nvl(tr.DTOCLOSE_NAMT,0) end) DTOCLOSE_WFT_AMT,
        --- chung khoan cho chuyen ra ngoai HCCN
        sum(case when SB.REFSYMBOL is null then 0 else se.BLOCKWITHDRAW-nvl(tr.BLOCKWITHDRAW_NAMT,0) end) BLOCKWITHDRAW_WFT_AMT,
        --- chung khoan cho dong HCCN
        sum(case when SB.REFSYMBOL is null then 0 else se.BLOCKDTOCLOSE-nvl(tr.BLOCKDTOCLOSE_NAMT,0) end) BLOCKDTOCLOSE_WFT_AMT
    FROM allcode a0, cfmast cf, afmast af, aftype aft,
    (
    SELECT SB.CODEID, SB.SYMBOL,
        (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE,
        SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL
    FROM SBSECURITIES SB, SBSECURITIES SB1
    WHERE SB.REFCODEID = SB1.CODEID(+)
        and sb.sectype <> '004'
    ) SB, SEMAST SE
    left join
    (
        SELECT ACCTNO,
            SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) TRADE_NAMT,
            SUM(CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) BLOCKED_NAMT,
            SUM(CASE WHEN FIELD = 'NETTING' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) NETTING_NAMT,
            SUM(CASE WHEN FIELD = 'EMKQTTY' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) EMKQTTY_NAMT,
            SUM(CASE WHEN FIELD = 'MORTAGE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) MORTAGE_NAMT,
            SUM(CASE WHEN FIELD = 'STANDING' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) STANDING_NAMT,
            SUM(CASE WHEN FIELD = 'RECEIVING' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) RECEIVING_NAMT,
            SUM(CASE WHEN FIELD = 'RECEIVING' AND TXCD IN('3351','3350') THEN
                (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) CA_RECEIVING_NAMT,
            SUM(CASE WHEN FIELD = 'WITHDRAW' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) WITHDRAW_NAMT,
            SUM(CASE WHEN FIELD = 'DTOCLOSE' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) DTOCLOSE_NAMT,
            SUM(CASE WHEN FIELD = 'BLOCKWITHDRAW' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) BLOCKWITHDRAW_NAMT,
            SUM(CASE WHEN FIELD = 'BLOCKDTOCLOSE' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) BLOCKDTOCLOSE_NAMT
        FROM VW_SETRAN_GEN
        WHERE DELTD <> 'Y'
        AND TXCD IN ('C','D')
        AND FIELD IN ('TRADE','BLOCKED','NETTING','EMKQTTY','MORTAGE','STANDING','WITHDRAW','DTOCLOSE','BLOCKWITHDRAW','BLOCKDTOCLOSE','RECEIVING')
        AND BUSDATE  > V_ONDATE
            --27/08/2015, TruongLD Modified, bo dieu kien nay --> ko hieu ban dev nao them DK nay o day
            --> Neu them DK nay o day, truong hop user lam GD chuyen CK tu cho GD thanh GD --> So du ngay qua khu se bi sai
            --and ACCTNO not in (select ACCTNO from vw_setran_gen where tltxcd = 3356 )
            --End TruongLD
        GROUP BY ACCTNO
        HAVING SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'NETTING' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'EMKQTTY' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'MORTAGE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'STANDING' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'RECEIVING' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'RECEIVING' AND TXCD IN('3351','3350') THEN
                (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'WITHDRAW' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'DTOCLOSE' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'BLOCKWITHDRAW' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'BLOCKDTOCLOSE' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0
    ) TR
    on SE.ACCTNO = TR.ACCTNO
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
            ) CA_RECEIVING_moveall_amt
        from vw_setran_gen tr
        where tr.sectype <> '004'
            AND TR.deltd <> 'Y'
            and tr.field = 'RECEIVING'
            and tr.busdate <= v_OnDate
            --27/08/2015, TruongLD Modified, bo dieu kien nay --> ko hieu ban dev nao them DK nay o day
            --> Neu them DK nay o day, truong hop user lam GD chuyen CK tu cho GD thanh GD --> So du ngay qua khu se bi sai
            -- and tr.ACCTNO not in (select ACCTNO from vw_setran_gen where tltxcd = 3356 )
            -- End TruongLD
        group by tr.acctno
    ) se_rcv_move on se.acctno = se_rcv_move.acctno
    left join
    (   -- Phat sinh mua chung khoan trong ngay
        select se.acctno, SUM(qtty) receiving_qtty
        from semast se, stschd  st, odmast od
        where se.acctno = st.seacctno and st.duetype = 'RS' and st.status = 'N'
            and st.deltd <> 'Y'
            --and od.stsstatus <> 'C'  --T11/2015 TTBT T+2: Nhung lenh co status = C da dc cong vao SEMAST.RECEIVING nen k lay nhung lenh nay nua
            and st.txdate = v_CurrDate
            and st.txdate = v_OnDate
            and od.orderid = st.orderid
            and od.orstatus <> '7' --nam.ly 23/03/2020
        group by se.acctno
    ) order_buy_today on se.acctno = order_buy_today.acctno
    left join
    (   -- Phat sinh ban chung khoan trong ngay
        select se.acctno, SUM(qtty) trade_qtty
        from semast se, stschd  st, odmast od
        where se.acctno = st.seacctno and st.duetype = 'SS' and st.status = 'N'
            and st.deltd <> 'Y'
            --and od.stsstatus <> 'C'  --T11/2015 TTBT T+2: Nhung lenh co status = C da dc tru vao SEMAST.TRADE nen k lay nhung lenh nay nua
            and st.txdate = v_CurrDate
            and st.txdate = v_OnDate
            and od.orderid = st.orderid
        group by se.acctno
    ) order_sell_today on se.acctno = order_sell_today.acctno
    left join
    (--- so luong chung khoan ban cho giao
        select seacctno, sum(execqtty) execqtty
        from
        (
            select codeid, afacctno, seacctno, execqtty, txdate
            from odmast
            where execqtty > 0
                and exectype in ('MS','NS')
                and txdate <= v_OnDate
                and deltd <> 'Y'
                --and stsstatus <> 'C'
            union all
            select odhist.codeid, odhist.afacctno, odhist.seacctno, execqtty, odhist.txdate
            from odmasthist odhist, stschdhist  sthist
            where execqtty > 0
                and odhist.txdate <= v_OnDate
                and exectype in ('MS','NS')
                AND sthist.orgorderid = odhist.orderid
                AND sthist.duetype = 'RM'
                AND sthist.cleardate > v_OnDate
            union all
            select substr(acctno,11,6) codeid, substr(acctno,0,10) afacctno, acctno seacctno, QTTY execqtty, SE.BUSDATE txdate
            from SERETAIL SE
            where  SE.BUSDATE <= v_OnDate
                AND nvl(SE.SDATE,'30/12/2099') > v_OnDate --SONLT: Neu chua thuc chuyen thi cung xem nhu van con nam cho giao
        )
        group by seacctno
    ) khop_qtty on se.acctno = khop_qtty.seacctno
    left join
    (   -- Phat sinh ban chung khoan ngay hom nay
        SELECT SEACCTNO, SUM(case when v_OnDate = v_CurrDate then SECUREAMT else 0 end) trade_sell_qtty,
            SUM(case when v_OnDate = v_CurrDate then SECUREMTG else 0 end) mtg_sell_qtty,
            SUM(case when v_OnDate = v_CurrDate then RECEIVING else 0 end) SERECEIVING,
            SUM(case when v_OnDate = v_CurrDate then EXECQTTY else 0 end) khop_qtty
         FROM (
                SELECT OD.SEACCTNO,
                    CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN to_number(nvl(varvalue,0))* NVL(REMAINQTTY,0) + NVL(EXECQTTY,0) ELSE 0 END SECUREAMT,
                    CASE WHEN OD.EXECTYPE = 'MS'  THEN to_number(nvl(varvalue,0)) * NVL(REMAINQTTY,0) + NVL(EXECQTTY,0) ELSE 0 END SECUREMTG,
                    0 RECEIVING, CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN OD.EXECQTTY ELSE 0 END EXECQTTY
                FROM ODMAST OD, SYSVAR SY
                WHERE OD.EXECTYPE IN ('NS', 'SS','MS')
                    and sy.grname='SYSTEM' and sy.varname='HOSTATUS'
                    AND OD.TXDATE = v_OnDate
                    AND NVL(OD.GRPORDER,'N') <> 'Y'
                    and od.deltd <> 'Y'
                    AND od.orstatus <> '7' --nam.ly 23/03/2020
                    --and od.stsstatus <> 'C'
            )
        GROUP BY SEACCTNO
    ) order_today on se.acctno = order_today.SEACCTNO
WHERE SE.CODEID = SB.CODEID
        and se.afacctno = af.acctno
        and cf.custid = af.custid
        and af.actype = aft.actype
        and sb.symbol like v_Symbol
         --and nvl(sb.REFSYMBOL,sb.symbol) like v_Symbol
        AND case when length(PV_SYMBOL) = 3 and PV_SYMBOL <> 'ALL' and (nvl(sb.REFSYMBOL,sb.symbol) like PV_SYMBOL or nvl(sb.REFSYMBOL,sb.symbol) LIKE PV_SYMBOL||'_WFT') then 1
             when PV_SYMBOL = 'ALL' then 1
             when length(PV_SYMBOL) > '3' then 1
             ELSE 0 END > 0
        --and sb.TRADEPLACE like v_strTRADEPLACE
        and cf.custodycd like v_CustodyCD
        and af.acctno like v_AFAcctno
        and sb.TRADEPLACE = a0.cdval and a0.cdname = 'TRADEPLACE' and a0.cdtype = 'SE'
---        and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_STRTLID )
group by cf.custodycd, cf.fullname, aft.mnemonic, SE.AFACCTNO,AF.ACCTNO,CF.CIFID,
    (case when SB.REFSYMBOL is null then SB.SYMBOL else SB.REFSYMBOL end), SB.TRADEPLACE, a0.cdcontent
having sum(case when SB.REFSYMBOL is null then SE.TRADE-NVL(TR.TRADE_NAMT,0)-nvl(order_sell_today.trade_qtty,0) else 0 end) <> 0 or
        --chung khoan han che chuyen nhuong.
        sum(case when SB.REFSYMBOL is null then se.BLOCKED-nvl(tr.BLOCKED_NAMT,0) else 0 end)  <> 0 or
        --- chung khoan phong toa khac.
        sum(case when SB.REFSYMBOL is null then se.EMKQTTY-nvl(tr.EMKQTTY_NAMT,0) else 0 end)  <> 0 or
        --- chung khoan cam co
        --- chung khoan cam co VSD
        sum(case when SB.REFSYMBOL is null then se.STANDING-nvl(tr.STANDING_NAMT,0) else 0 end)  <> 0 or
        --- chung khoan cho ve
        --03/09/2015, TruongLD modified
        -- Lay tu tran la du --> khong can lay theo cong thuc ben duoi
        sum(case when SB.REFSYMBOL is null then
                    (nvl(SE.RECEIVING,0) - nvl(tr.RECEIVING_NAMT,0)
                    + nvl(order_buy_today.receiving_qtty,0)) else 0 end + nvl(se_rcv_move.ca_receiving_moveall_amt,0)) <> 0 or
        /*sum(
             case when SB.REFSYMBOL is null then
                ( - nvl(tr.RECEIVING_NAMT,0) +  nvl(tr.CA_RECEIVING_NAMT,0) + nvl(order_buy_today.receiving_qtty,0)) else 0 end)
                + sum(nvl(RECEIVING,0) - nvl(se_RECEIVING_moveall_amt,0) - nvl(tr.CA_RECEIVING_NAMT,0)-nvl(se_rcv_move.CA_RECEIVING_moveall_amt,0))  <> 0 or*/
        --- chung khoan quyen cho ve
        --sum(nvl(RECEIVING,0) - nvl(se_RECEIVING_moveall_amt,0) - nvl(tr.CA_RECEIVING_NAMT,0)) <> 0 or
        --- chung khoan cho chuyen ra ngoai
        sum(case when SB.REFSYMBOL is null then se.WITHDRAW-nvl(tr.WITHDRAW_NAMT,0) else 0 end)  <> 0 or
        --- chung khoan cho dong
        sum(case when SB.REFSYMBOL is null then se.DTOCLOSE-nvl(tr.DTOCLOSE_NAMT,0) else 0 end)  <> 0 or
        --- chung khoan cho chuyen ra ngoai HCCN
        sum(case when SB.REFSYMBOL is null then se.BLOCKWITHDRAW-nvl(tr.BLOCKWITHDRAW_NAMT,0) else 0 end)  <> 0 or
        --- chung khoan cho dong HCCN
        sum(case when SB.REFSYMBOL is null then se.BLOCKDTOCLOSE-nvl(tr.BLOCKDTOCLOSE_NAMT,0) else 0 end)  <> 0 or
        --- ban cho giao
        /*sum(case when SB.REFSYMBOL is null then (nvl(khop_qtty.execqtty,0)
     --locpt comment do tinh double    + NVL(SR_QTTY.se_RETAIL_move_amt,0)
                           ) else 0 end)*/
        sum(case when SB.REFSYMBOL is null then (se.netting + nvl(order_today.khop_qtty,0) - nvl(tr.NETTING_NAMT,0)
       --  + NVL(SR_QTTY.se_RETAIL_move_amt,0)
         ) else 0 end)  <> 0 or
        --- ban cho khop
        sum(case when SB.REFSYMBOL is null then (nvl(order_today.trade_sell_qtty,0) + nvl(order_today.mtg_sell_qtty,0) - nvl(order_today.khop_qtty,0)) else 0 end )  <> 0 or
        --chung khoan cho giao dich.
        --chung khoan giao dich.
        sum(case when SB.REFSYMBOL is null then 0 else SE.TRADE-NVL(TR.TRADE_NAMT,0) end)  <> 0 or
        --chung khoan han che chuyen nhuong.
        sum(case when SB.REFSYMBOL is null then 0 else se.BLOCKED-nvl(tr.BLOCKED_NAMT,0) end)  <> 0 or
        --- chung khoan phong toa khac.
        sum(case when SB.REFSYMBOL is null then 0 else se.EMKQTTY-nvl(tr.EMKQTTY_NAMT,0) end)  <> 0 or
        --- chung khoan cam co
        sum(case when SB.REFSYMBOL is null then 0 else se.MORTAGE-nvl(tr.MORTAGE_NAMT,0) end)  <> 0 or
        --- chung khoan cam co VSD
        sum(case when SB.REFSYMBOL is null then 0 else se.STANDING-nvl(tr.STANDING_NAMT,0) end)  <> 0 or
        --- chung khoan cho chuyen ra ngoai
        sum(case when SB.REFSYMBOL is null then 0 else se.WITHDRAW-nvl(tr.WITHDRAW_NAMT,0) end)  <> 0 or
        --- chung khoan cho dong
        sum(case when SB.REFSYMBOL is null then 0 else se.DTOCLOSE-nvl(tr.DTOCLOSE_NAMT,0) end)  <> 0 or
        --- chung khoan cho chuyen ra ngoai HCCN
        sum(case when SB.REFSYMBOL is null then 0 else se.BLOCKWITHDRAW-nvl(tr.BLOCKWITHDRAW_NAMT,0) end)  <> 0 or
        --- chung khoan cho dong HCCN
        sum(case when SB.REFSYMBOL is null then 0 else se.BLOCKDTOCLOSE-nvl(tr.BLOCKDTOCLOSE_NAMT,0) end)  <> 0
) sb --, setradeplace setr
       where --sb.codeid = setr.codeid (+)

       --and case when nvl(setr.codeid,'xxx') = sb.codeid and setr.txdate > v_OnDate then setr.frtradeplace
       --         else sb.TRADEPLACE  end like v_strTRADEPLACE
       --AND
       sb.TRADEPLACE  like v_strTRADEPLACE
;
EXCEPTION
  WHEN OTHERS
   THEN
   dbms_output.put_line('12233');
      RETURN;
END;
/
