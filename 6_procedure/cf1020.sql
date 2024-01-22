SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf1020 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   PV_AFACCTNO       IN       VARCHAR2,
   TLID IN VARCHAR2
  )
IS
--

-- BAO CAO Sao ke tien cua tai khoan khach hang
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TUNH        13-05-2010           CREATED
-- TUNH        31-08-2010           Lay dien giai chi tiet o cac table xxTRAN
-- HUNG.LB     03-11-2010           6.3.1
-- TruongLD    18/03/2015           Modified
-- Lay theo CF1002 nhung lay tat ca GD, khong bo cac GD 66xx
--------------------------------------------------------------------
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   v_FromDate date;
   v_ToDate date;
   v_CurrDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);
   v_TLID varchar2(4);
   V_TRADELOG CHAR(2);
   V_AUTOID NUMBER;


BEGIN

-- return;

    v_TLID := TLID;
    V_STROPTION := OPT;
    IF V_STROPTION = 'A' then
        V_STRBRID := '%%';
    ELSIF V_STROPTION = 'B' then
        V_STRBRID := substr(BRID,1,2) || '__' ;
    else
        V_STRBRID:=BRID;
    END IF;

    v_FromDate:= to_date(F_DATE,'DD/MM/RRRR');
    v_ToDate:= to_date(T_DATE,'DD/MM/RRRR');
    v_CustodyCD:= upper(replace(pv_custodycd,'.',''));
    v_AFAcctno:= upper(replace(PV_AFACCTNO,'.',''));

    if v_AFAcctno = 'ALL' or v_AFAcctno is null then
        v_AFAcctno := '%%';
    else
        v_AFAcctno := v_AFAcctno;
    end if;

    select to_date(VARVALUE,'DD/MM/YYYY') into v_CurrDate from sysvar where grname='SYSTEM' and varname='CURRDATE';



    OPEN PV_REFCURSOR FOR

    select 0 tmtracham, cf.custid, cf.custodycd, cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.mobile, cf.address, PV_AFACCTNO S_AFACCTNO,
           tr.autoid, cibal.refcasaacct afacctno, tr.bkdate busdate,
           nvl(se_credit_amt,0) se_credit_amt, nvl(se_debit_amt,0) se_debit_amt,
           nvl(ci_credit_amt,0) ci_credit_amt, nvl(ci_debit_amt,0) ci_debit_amt,
           ci_balance, ci_balance - nvl(ci_total_move_frdt_amt,0) ci_begin_bal,
           tr.txnum,
           tr.txdesc txdesc, tr.tltxcd
    from cfmast cf
    inner join
    (
        -- Tong so du CI hien tai group by TK luu ky
        select cf.custid, cf.custodycd, DD.REFCASAACCT, DD.ACCTNO DDACCTNO,
            sum(balance) ci_balance,
            sum(RECEIVING) CI_RECEIVING
        from cfmast cf, afmast af, ddmast DD
        where cf.custid = af.custid and af.acctno = DD.afacctno
            and cf.custodycd = v_CustodyCD
            and DD.acctno like v_AFAcctno
        group by  cf.custid, cf.custodycd, DD.REFCASAACCT, DD.ACCTNO
    ) cibal on cf.custid = cibal.custid
    left join
    (
        -- Danh sach giao dich CI: tu From Date den ToDate
        select tci.custid, tci.custodycd, tci.ddacctno ddacctno,
            tci.autoid autoid, tllog_autoid,tci.txtype,
            tci.busdate,
            CASE WHEN TLTXCD = '3350' THEN  tci.txdesc ELSE nvl(tci.trdesc,tci.txdesc) END txdesc,
             '' symbol, 0 se_credit_amt, 0 se_debit_amt,
            case when tci.txtype = 'C' then namt else 0 end ci_credit_amt,
            case when tci.txtype = 'D' then namt else 0 end ci_debit_amt,
            tci.txnum, '' tltx_name, tci.tltxcd, tci.txdate, tci.txcd, tci.dfacctno dealno,
            tci.old_dfacctno description, tci.trdesc, tci.bkdate,
            tci.txdesc tltxdesc
        from   (select tr.autoid, cf.custodycd, cf.custid,
                tr.txnum, tr.txdate, tr.acctno ddacctno, tr.txcd, tr.namt,
                tr.camt, tr.ref, nvl(tr.deltd, 'N') deltd, tr.acctref,
                tl.tltxcd, tl.busdate, tl.txdesc txdesc, tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
                tr.ref dfacctno, ' ' old_dfacctno,
                app.txtype, app.field, tl.autoid tllog_autoid, tr.trdesc, nvl(tr.busdate, tr.txdate) bkdate
                from    (SELECT * FROM vw_ddtran_gen) tr,
                        VW_TLLOG_ALL TL, cfmast cf, apptx app--, VW_DFMAST_ALL df
                where   tr.txdate       =    tl.txdate
                and     tr.txnum        =    tl.txnum
                and     cf.custodycd    =    tr.custodycd
                and     tr.txcd         =    app.txcd
                and     app.apptype     =    'DD'
                and     app.txtype      in   ('D','C')
                and     tl.TLTXCD NOT IN ('3324','6668','6650')
                and     tl.deltd        <>  'Y'
                and     tr.deltd        <>  'Y'
                and     tr.namt         <>  0

                UNION ALL

                SELECT 0 AUTOID, CF.custodycd, cf.custid, TL.txnum, TL.txdate, TL.MSGacct acctno, 'D' txcd,
                case when tl.TLTXCD IN ('6668','6650') then tl.msgamt else 0 end namt,
                '' camt, '' ref, nvl(TL.deltd, 'N') deltd, TL.MSGacct acctref,
                tl.tltxcd, tl.busdate, tl.txdesc
                , tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
                '' dfacctno,' ' old_dfacctno,
                case when tl.TLTXCD IN ('6668','6650') then 'C' else 'D' end txtype, 'BALANCE' field,
                 tl.autoid+1 tllog_autoid,
                '' trdesc, TL.txdate bkdate
                FROM VW_TLLOG_ALL TL, cfmast cf, ddmast dd
                where   cf.custid       =    dd.custid
                and     TL.MSGacct       =    dd.acctno
                and     tl.deltd        <>  'Y'
                 AND TL.TLTXCD in ('3324','6668','6650')
                ) tci
        where  tci.bkdate between v_FromDate and v_ToDate
           and tci.custodycd = v_CustodyCD
           and tci.ddacctno like v_AFAcctno
           and tci.field = 'BALANCE'

    ) tr on cibal.custid = tr.custid and cibal.ddacctno = tr.ddacctno
    left join
    (
        -- Tong phat sinh CI tu From date den ngay hom nay
        select tr.custid, tr.ddacctno,
            sum(case when tr.txtype = 'D' then -tr.namt else tr.namt end) ci_total_move_frdt_amt
        from   (select (case when tl.tltxcd = '1153' and app.txtype = 'C'
                             then ci.autoid-1 else ci.autoid+1 end) autoid,
                cf.custodycd, cf.custid,
                ci.txnum, ci.txdate, ci.acctno ddacctno, ci.txcd, ci.namt,
                ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
                tl.tltxcd, tl.busdate, tl.txdesc
                , tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
                ci.ref dfacctno,
                ' ' old_dfacctno,
                app.txtype, app.field,
                (case when tl.tltxcd = '1153' and app.txtype = 'C'
                      then tl.autoid-1 else tl.autoid+1 end) tllog_autoid,
                ci.trdesc, nvl(ci.busdate, ci.txdate) bkdate
                from    (SELECT * FROM vw_ddtran_gen) CI,
                        VW_TLLOG_ALL TL, cfmast cf, afmast af, apptx app
                where   ci.txdate       =    tl.txdate
                and     ci.txnum        =    tl.txnum
                and     cf.custid       =    af.custid
                and     ci.acctno       =    af.acctno
                and     ci.txcd         =    app.txcd
                and     app.apptype     =    'CI'
                and     app.txtype      in   ('D','C')
                and ci.corebank <> 'Y'
                and     tl.deltd        <>  'Y'
                and     ci.deltd        <>  'Y'
                and     ci.namt         <>  0
                    ) tr
        where
            tr.bkdate >= v_FromDate and tr.bkdate <= v_CurrDate
            and tr.custodycd = v_CustodyCD
            and tr.ddacctno like v_AFAcctno
            and tr.field in ('BALANCE')
        group by tr.custid, tr.ddacctno
    ) ci_move_fromdt on cibal.custid = ci_move_fromdt.custid and cibal.ddacctno = ci_move_fromdt.ddacctno
    where cf.custodycd = v_CustodyCD
          and exists (select gu.grpid from tlgrpusers gu where cf.careby = gu.grpid and gu.tlid = v_TLID)
    order by tr.bkdate, tr.tllog_autoid,  tr.txnum, tr.txtype, tr.autoid
    ;
EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/
