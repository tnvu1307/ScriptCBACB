SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf1008 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2,
   T_DATE                 IN       VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2,
   PV_AFACCTNO            IN       VARCHAR2,
   TLID                   IN       VARCHAR2
  )
IS
--

-- BAO CAO SAO KE TIEN CUA TAI KHOAN KHACH HANG
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TUNH        13-05-2010           CREATED
-- TUNH        31-08-2010           Lay dien giai chi tiet o cac table xxTRAN
-- HUNG.LB     03-11-2010           6.3.1
-- QUOCTA      12-01-2012           BVS - LAY THEO NGAY BACKDATE CUA GD

   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   v_FromDate     date;
   v_ToDate       date;
   v_CurrDate     date;
   v_CustodyCD    varchar2(20);
   v_AFAcctno     varchar2(20);
   v_TLID         varchar2(4);
   V_TRADELOG CHAR(2);
   V_AUTOID NUMBER;
   L_TRANS_OF_BANK VARCHAR2(3900);

BEGIN

   v_TLID := TLID;

   V_STROPTION := OPT;

   IF V_STROPTION = 'A' then
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' then
      V_STRBRID := substr(BRID,1,2) || '__' ;
   else
    V_STRBRID:=BRID;
   END IF;

   v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
   v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

   v_CustodyCD :=     upper(replace(pv_custodycd,'.',''));
   v_AFAcctno  :=     upper(replace(PV_AFACCTNO,'.',''));

   Begin
        select varvalue into L_TRANS_OF_BANK from sysvar where varname='TRANS_OF_BANK';
    EXCEPTION
        WHEN OTHERS THEN  L_TRANS_OF_BANK := '660';
    End;

   if (v_AFAcctno = 'ALL' or v_AFAcctno is null) then
      v_AFAcctno := '%';
   else
      v_AFAcctno := v_AFAcctno;
   end if;

   select TO_DATE(VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) into v_CurrDate from SYSVAR where grname='SYSTEM' and varname='CURRDATE';


OPEN PV_REFCURSOR FOR
select 0 tmtracham, cf.custid, cf.custodycd, cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.mobile, cf.address, PV_AFACCTNO S_AFACCTNO,
    tr.autoid, tr.afacctno, tr.bkdate busdate, nvl(tr.symbol,' ') tran_symbol,
    nvl(se_credit_amt,0) se_credit_amt, nvl(se_debit_amt,0) se_debit_amt,
    nvl(ci_credit_amt,0) ci_credit_amt, nvl(ci_debit_amt,0) ci_debit_amt,
    ci_balance, ci_balance - nvl(ci_total_move_frdt_amt,0)  ci_begin_bal,
    CI_RECEIVING, CI_RECEIVING - nvl(ci_RECEIVING_move,0) ci_receiving_bal,
    CI_EMKAMT, CI_EMKAMT - nvl(ci_EMKAMT_move,0) ci_EMKAMT_bal,
    CI_DFDEBTAMT - nvl(ci_DFDEBTAMT_move,0) ci_DFDEBTAMT_bal,
    nvl(secu.od_buy_secu,0) od_buy_secu,
    tr.txnum,
    case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien dan han phai thanh toan'
         when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Pha ung truoc'
         --else to_char(decode(substr(tr.txnum,1,2),'68', tr.txdesc || ' (Online)',tr.txdesc))
         else to_char(decode(substr(tr.txnum,1,2),'68', tr.txdesc || ' (Online)',
                                                  '69',tr.txdesc || ' (Home)',
                                                  '99',tr.txdesc || ' (Auto)',
                                                  '70',tr.txdesc || ' (Mobile)',tr.txdesc))
         --else to_char(tr.txdesc)
    end txdesc,
    tr.tltxcd,

    case when tr.tltxcd in ('2641','2642','2643','2660','2678','2670') then
            (case when trim(tr.description) is not null
                    then nvl(tr.description, ' ')
                else
                    tr.dealno
             end
            )
    end dfaccno, (case when u.tokenid is null then '-' else SUBSTR(u.tokenid, instr(u.tokenid, '{', 1, 2) + 1, instr(u.tokenid, '}', 1, 1) - instr(u.tokenid, '{', 1, 2) - 1) end) tokenid

from cfmast cf

inner join afmast af on cf.custid = af.custid
inner join
(
    -- Tong so du CI hien tai group by TK luu ky
    select cf.custid, cf.custodycd,
        /*sum(case when af.corebank = 'Y' then 0 else balance + emkamt end) ci_balance, --them emkamt GianhVG
        sum(case when af.corebank = 'Y' then 0 else RECEIVING end) CI_RECEIVING,
        sum(case when af.corebank = 'Y' then 0 else EMKAMT end) CI_EMKAMT,
        sum(case when af.corebank = 'Y' then 0 else DFDEBTAMT end) CI_DFDEBTAMT*/
        sum(balance + holdbalance) ci_balance, --them emkamt GianhVG
        sum(RECEIVING) CI_RECEIVING,
        0 CI_EMKAMT,
        0 CI_DFDEBTAMT
    from cfmast cf, afmast af, ddmast ci
    where cf.custid = af.custid and af.acctno = ci.afacctno
        and cf.custodycd = v_CustodyCD
        and af.acctno like v_AFAcctno
    group by  cf.custid, cf.custodycd
) cibal on cf.custid = cibal.custid
left join  (select distinct username,tokenid from userlogin where status ='A') u on cf.username = u.username
left join
(
    -- Danh sach giao dich CI: tu From Date den ToDate
    select tci.autoid orderid, tci.custid, tci.custodycd, tci.acctno afacctno, tci.tllog_autoid autoid, tci.txtype,
        tci.busdate,
        nvl(tci.trdesc,tci.txdesc) txdesc,
        --CASE WHEN TLTXCD = '3350' THEN tci.txdesc ELSE nvl(tci.trdesc,tci.txdesc) END txdesc,
        '' symbol, 0 se_credit_amt, 0 se_debit_amt,
        case when tci.txtype = 'C' then namt else 0 end ci_credit_amt,
        case when tci.txtype = 'D' then namt else 0 end ci_debit_amt,
        tci.txnum, '' tltx_name, tci.tltxcd, tci.txdate, tci.txcd, tci.dfacctno dealno,
        tci.old_dfacctno description, tci.trdesc, tci.bkdate
    from   (
            select ci.autoid, cf.custodycd, cf.custid,
            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
            ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
            tl.tltxcd, tl.busdate, tl.txdesc, tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
            --(case when tl.tltxcd in ('2670') then ci.ref else df.acctno end) dfacctno,
            ci.ref dfacctno,
            --(case when df.txdate <= '31-may-2010' then nvl(df.description, ' ') else '' end) old_dfacctno,
            ' ' old_dfacctno,
            app.txtype, app.field, tl.autoid tllog_autoid, ci.trdesc, nvl(ci.busdate, ci.txdate) bkdate
            from    (SELECT * FROM vw_ddtran_gen) CI,
                    VW_TLLOG_ALL TL, cfmast cf, afmast af, apptx app --, VW_DFMAST_ALL df
            where   ci.txdate       =    tl.txdate
            and     ci.txnum        =    tl.txnum
            and     cf.custid       =    af.custid
            and     ci.acctno       =    af.acctno
            and     ci.txcd         =    app.txcd
            and CI.corebank <> 'Y'
            and     app.apptype     =    'CI'
            and     app.txtype      in   ('D','C')
            --and     ci.ref          =    df.lnacctno (+)
            and     tl.deltd        <>  'Y'
            and     ci.deltd        <>  'Y'
            and     ci.namt         <>  0
            --and tl.tltxcd not in ('6690','6691','6621','6660','6600','6601','6602')
            --and tl.TLTXCD NOT IN ('6690','6691','6621','6660','6600','6601','6602','6692','6693','6674')
            and instr(L_TRANS_OF_BANK, tl.tltxcd) = 0
            UNION ALL
            SELECT 0 AUTOID, CF.custodycd, cf.custid, TL.txnum, TL.txdate, TL.MSGacct acctno,'D' txcd,
            (case when TL.TLTXCD IN ('6668','6650') then tl.msgamt else 0 end) namt,
            '' camt, '' ref, nvl(TL.deltd, 'N') deltd, TL.MSGacct acctref,
            tl.tltxcd, tl.busdate, tl.txdesc, tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
            '' dfacctno,' ' old_dfacctno,
            (case when TL.TLTXCD IN ('6668','6650') then 'C' else 'D' end) txtype, 'BALANCE' field,
             tl.autoid+1 tllog_autoid,
            '' trdesc, TL.txdate bkdate
            FROM VW_TLLOG_ALL TL, cfmast cf, afmast af
            where   cf.custid       =    af.custid
            and     TL.MSGacct       =    af.acctno
           -- and af.corebank <> 'Y'
            --and     ci.ref          =    df.lnacctno (+)
            and     tl.deltd        <>  'Y'
             AND TL.TLTXCD in ('3324','6668','6650')
            ) tci
    where  tci.bkdate between v_FromDate and v_ToDate
       and tci.custodycd = v_CustodyCD
       and tci.acctno like v_AFAcctno
       and tci.field = 'BALANCE'
       AND TCI.TLTXCD NOT IN ('8855','8865','8856','8866','0066','1144','1145','8889')  -- them 2 giao dich '1144','1145' phong toa, GianhVG

       union all
       -------Tach giao dich mua ban
       select  max(tci.autoid) orderid, tci.custid, tci.custodycd, tci.acctno afacctno, max(tci.tllog_autoid) autoid, tci.txtype,
        tci.busdate, case when TCI.TLTXCD = '8865' then 'Tra tien mua CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        when TCI.TLTXCD = '8889' then 'Tra tien mua CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        when TCI.TLTXCD = '8856' then 'Tra phi ban CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        when TCI.TLTXCD = '8866' then 'Nhan tien ban CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        else  'Tra phi mua CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        end TXDESC,
         '' symbol, 0 se_credit_amt, 0 se_debit_amt,
        SUM(case when tci.txtype = 'C' then namt else 0 end) ci_credit_amt,
        SUM(case when tci.txtype = 'D' then namt else 0 end) ci_debit_amt,
        '' txnum, '' tltx_name, tci.tltxcd,  tci.txdate, tci.txcd, '' dealno,
        '' description, '' trdesc, tci.bkdate
    from   (select ci.autoid, cf.custodycd, cf.custid,
            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
            ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
            tl.tltxcd, tl.busdate, tl.txdesc, tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
            --(case when tl.tltxcd in ('2670') then ci.ref else df.acctno end) dfacctno,
            ci.ref dfacctno,
            --(case when df.txdate <= '31-may-2010' then nvl(df.description, ' ') else '' end) old_dfacctno,
            ' ' old_dfacctno,
            app.txtype, app.field, tl.autoid tllog_autoid, ci.trdesc, nvl(ci.busdate, ci.txdate) bkdate, od.txdate oddate
            from    (SELECT * FROM vw_ddtran_gen) CI,
                    vw_odmast_all od,
                    VW_TLLOG_ALL TL, cfmast cf, afmast af, apptx app --, VW_DFMAST_ALL df
            where   ci.txdate       =    tl.txdate
            and     ci.txnum        =    tl.txnum
            and     cf.custid       =    af.custid
            and     ci.acctno       =    af.acctno
            and     ci.txcd         =    app.txcd
            and     app.apptype     =    'CI'
            and CI.corebank <> 'Y'
            and     app.txtype      in   ('D','C')
            --and     ci.ref          =    df.lnacctno (+)
            and     tl.deltd        <>  'Y'
            and     ci.deltd        <>  'Y'
            and     ci.ref= od.orderid
            and     ci.namt         <>  0) tci
    where  tci.bkdate between v_FromDate and v_ToDate
       and tci.custodycd = v_CustodyCD
       and tci.acctno like v_AFAcctno
       and tci.field = 'BALANCE'
         AND TCI.TLTXCD IN ('8855','8865','8856','8866','8889')
         GROUP BY tci.custid, tci.custodycd, tci.acctno ,  tci.txtype, tci.busdate, tci.tltxcd, tci.txcd,tci.txdate,tci.bkdate

      union all
       -----Thue TNCN:
     SELECT max(tci.autoid) orderid,  tci.custid, tci.custodycd, tci.acctno afacctno, max(tci.tllog_autoid) autoid, tci.txtype,
        tci.busdate, tci.description TXDESC,
        /*case when TCI.TXCD = '0011' then tci.txdesc--'Thu? TNCN CK B?ng?' || TO_CHAR(tci.busdate)
                        else  'Thu? TNCN b?CK c? t?c B?ng CP ng?' || TO_CHAR(tci.busdate) end TXDESC */
         '' symbol, 0 se_credit_amt, 0 se_debit_amt,
        SUM(case when tci.txtype = 'C' then namt else 0 end) ci_credit_amt,
        SUM(case when tci.txtype = 'D' then namt else 0 end) ci_debit_amt,
        '' txnum, '' tltx_name, tci.tltxcd, tci.txdate, tci.txcd, '' dealno,
        '' description, '' trdesc, tci.bkdate
    from   (
           select ci.autoid, cf.custodycd, cf.custid,
            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
            ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
            tl.tltxcd, tl.busdate, tl.txdesc, tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
            --(case when tl.tltxcd in ('2670') then ci.ref else df.acctno end) dfacctno,
            ci.ref dfacctno,
            --(case when df.txdate <= '31-may-2010' then nvl(df.description, ' ') else '' end) old_dfacctno,
            ' ' old_dfacctno,
            app.txtype, app.field, tl.autoid tllog_autoid, ci.trdesc, nvl(ci.busdate, ci.txdate) bkdate,
            CASE WHEN ci.txcd = '0011' THEN tl.txdesc
                 WHEN ci.txcd = '0028' THEN ci.trdesc || ' Ngay' || substr(tl.txdesc, length(tl.txdesc) -10, 10)
                 END description
            from    (SELECT * FROM vw_ddtran_gen) CI,
                    VW_TLLOG_ALL TL, cfmast cf, afmast af, apptx app--, VW_DFMAST_ALL df
            where   ci.txdate       =    tl.txdate
            and     ci.txnum        =    tl.txnum
            and     cf.custid       =    af.custid
            and     ci.acctno       =    af.acctno
            and     ci.txcd         =    app.txcd
            and     app.apptype     =    'CI'
            and     app.txtype      in   ('D','C')
            and CI.corebank <> 'Y'
            --and     ci.ref          =    df.lnacctno (+)
            and     tl.deltd        <>  'Y'
            and     ci.deltd        <>  'Y'
            and     ci.namt         <>  0


            ) tci
    where  tci.bkdate between v_FromDate and v_ToDate
       and tci.custodycd = v_CustodyCD
       and tci.acctno like v_AFAcctno
       and tci.field = 'BALANCE'
       AND TCI.TLTXCD IN ('0066')
       GROUP BY tci.custid, tci.custodycd, tci.acctno ,  tci.txtype, tci.busdate, tci.tltxcd, tci.txcd,tci.txdate,tci.bkdate, tci.description
) tr on cf.custid = tr.custid and af.acctno = tr.afacctno

left join
(
    -- Tong phat sinh CI tu From date den ngay hom nay
    select tr.custid,
        sum(case when tr.field = 'HOLDBALANCE' then tr.namt else
            (case when tr.txtype = 'D' then -tr.namt else tr.namt end) end) ci_total_move_frdt_amt
    from   (select ci.autoid, cf.custodycd, cf.custid,
            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
            ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
            tl.tltxcd, tl.busdate, tl.txdesc, tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
            --(case when tl.tltxcd in ('2670') then ci.ref else df.acctno end) dfacctno,
            ci.ref dfacctno,
            --(case when df.txdate <= '31-may-2010' then nvl(df.description, ' ') else '' end) old_dfacctno,
            ' ' old_dfacctno,
            app.txtype, app.field, tl.autoid tllog_autoid, ci.trdesc, nvl(ci.busdate, ci.txdate) bkdate
            from    (SELECT * FROM vw_ddtran_gen) CI,
                    VW_TLLOG_ALL TL, cfmast cf, afmast af, apptx app--, VW_DFMAST_ALL df
            where   ci.txdate       =    tl.txdate
            and     ci.txnum        =    tl.txnum
            and     cf.custid       =    af.custid
            and     ci.acctno       =    af.acctno
            and     ci.txcd         =    app.txcd
            and     app.apptype     =    'CI'
            and     app.txtype      in   ('D','C')
            --and     ci.ref          =    df.lnacctno (+)
            and     tl.deltd        <>  'Y'
            and     ci.deltd        <>  'Y'
            and CI.corebank <> 'Y'
            and     ci.namt         <>  0) tr
    where
        tr.bkdate >= v_FromDate and tr.bkdate <= v_CurrDate
        and tr.custodycd = v_CustodyCD
        and tr.acctno like v_AFAcctno
        and tr.field in ('HOLDBALANCE','BALANCE')
        --AND tr.tltxcd NOT IN ('1144','1145','6690','6691','6621','6660','6600','6601','6602') -- bo giao dich phong toa , GianhVG
        --and tr.TLTXCD NOT IN ('1144','1145','6690','6691','6621','6660','6600','6601','6602','6692','6693','6674')
        and instr(L_TRANS_OF_BANK, tr.tltxcd) = 0
    group by tr.custid
) ci_move_fromdt on cf.custid = ci_move_fromdt.custid

left join
(
    -- Tong phat sinh CI.RECEIVING tu Todate + 1 den ngay hom nay
    select tr.custid,
        sum(
            case when field = 'RECEIVING' then
                case when tr.txtype = 'D' then -tr.namt else tr.namt end
            else 0
            end
            ) ci_RECEIVING_move,

        sum(
            case when field IN ('EMKAMT') then
                case when tr.txtype = 'D' then -tr.namt else tr.namt end
            else 0
            end
            ) ci_EMKAMT_move,

        sum(
            case when field = 'DFDEBTAMT' then
                case when tr.txtype = 'D' then -tr.namt else tr.namt end
            else 0
            end
            ) ci_DFDEBTAMT_move
    from   (select ci.autoid, cf.custodycd, cf.custid,
            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
            ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
            tl.tltxcd, tl.busdate, tl.txdesc, tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
            --(case when tl.tltxcd in ('2670') then ci.ref else df.acctno end) dfacctno,
            ci.ref dfacctno,
            --(case when df.txdate <= '31-may-2010' then nvl(df.description, ' ') else '' end) old_dfacctno,
            ' ' old_dfacctno,
            app.txtype, app.field, tl.autoid tllog_autoid, ci.trdesc, nvl(ci.busdate, ci.txdate) bkdate
            from    (SELECT * FROM vw_ddtran_gen) CI,
                    VW_TLLOG_ALL TL, cfmast cf, afmast af, apptx app--, VW_DFMAST_ALL df
            where   ci.txdate       =    tl.txdate
            and     ci.txnum        =    tl.txnum
            and     cf.custid       =    af.custid
            and     ci.acctno       =    af.acctno
            and     ci.txcd         =    app.txcd
            and     app.apptype     =    'CI'
            and     app.txtype      in   ('D','C')
            and CI.corebank <> 'Y'
            --and     ci.ref          =    df.lnacctno (+)
            and     tl.deltd        <>  'Y'
            and     ci.deltd        <>  'Y'
            and     ci.namt         <>  0) tr
    where
        tr.bkdate > v_ToDate and tr.bkdate <= v_CurrDate
        and tr.custodycd = v_CustodyCD
        and tr.acctno like v_AFAcctno
        and tr.field in ('RECEIVING','EMKAMT','DFDEBTAMT')
    group by tr.custid
) ci_RECEIV on cf.custid = ci_RECEIV.custid

left join
(
    select cf.custid, cf.custodycd,
        case when v_CurrDate = v_ToDate then SUM(secureamt + advamt) else 0 end od_buy_secu
    from v_getbuyorderinfo V, afmast af, cfmast cf
    where v.afacctno = af.acctno and af.custid = cf.custid
        and cf.custodycd = v_CustodyCD and af.acctno like v_AFAcctno
    group by cf.custid, cf.custodycd
) secu on cf.custid = secu.custid

where
    cf.custodycd = v_CustodyCD
    and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID)   -- check careby cf.careby = gu.grpid
order by --tr.bkdate, tr.autoid, tr.txtype, tr.txnum,
         --tr.autoid, tr.bkdate, tr.txnum, tr.txtype, tr.orderid,
          tr.bkdate, tr.autoid, tr.txnum, tr.txtype, tr.orderid,
         case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien den han phai thanh toan'
              when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phi ung truoc'
              else to_char(tr.txdesc)
    end ;      -- Chu y: Khong thay doi thu tu Order by


EXCEPTION
  WHEN OTHERS
   THEN
      Return;
End;
/
