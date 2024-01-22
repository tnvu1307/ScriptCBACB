SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf20051 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
 )
IS
--

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);      -- USED WHEN V_NUMOPTION > 0

   V_TODATE     DATE;
   V_FROMDATE   DATE;

    v_DK_CN_NN NUMBER;
    v_DK_TC_NN NUMBER;
    v_DK_CN_TN NUMBER;
    v_DK_TC_TN NUMBER;
    v_TK_CN_NN_Credit NUMBER;
    v_TK_TC_NN_Credit NUMBER;
    v_TK_CN_TN_Credit NUMBER;
    v_TK_TC_TN_Credit NUMBER;
    v_TK_CN_NN_Debit NUMBER;
    v_TK_TC_NN_Debit NUMBER;
    v_TK_CN_TN_Debit NUMBER;
    v_TK_TC_TN_Debit NUMBER;
    v_CK_CN_NN NUMBER;
    v_CK_TC_NN NUMBER;
    v_CK_CN_TN NUMBER;
    v_CK_TC_TN NUMBER;


-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

BEGIN
-- INSERT INTO TEMP_BUG(TEXT) VALUES('CF0001');COMMIT;
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    V_FROMDATE := to_date(F_DATE,'DD/MM/RRRR');
    V_TODATE := to_date(T_DATE,'DD/MM/RRRR');

OPEN PV_REFCURSOR FOR


select --CUSTODYCD, AFACCTNO, ACCTNO,
    DK_CN_TN, DK_TC_TN, DK_CN_NN, DK_TC_NN,
    TK_CN_TN_Debit, TK_CN_TN_credit, TK_TC_TN_Debit, TK_TC_TN_credit, TK_CN_NN_Debit, TK_CN_NN_credit, TK_TC_NN_Debit, TK_TC_NN_credit,
    DK_CN_TN + TK_CN_TN_credit -  TK_CN_TN_Debit CK_CN_TN,
    DK_TC_TN + TK_TC_TN_credit -  TK_TC_TN_Debit CK_TC_TN,
    DK_CN_NN + TK_CN_NN_credit -  TK_CN_NN_Debit CK_CN_NN,
    DK_TC_NN + TK_TC_NN_credit -  TK_TC_NN_Debit CK_TC_NN
from (
--- nvl(cf.country,'234') <> '234'
 select sum(CASE  WHEN nvl(cf.country,'234') = '234' AND cf.custtype = 'I'
            THEN (CASE WHEN af.corebank='N' THEN  ci.balance ELSE 0 END) - nvl(TK_CN_TN_credit_all,0) + nvl(TK_CN_TN_Debit_all,0) + nvl(a.amt,0)  ELSE 0 END) DK_CN_TN, -- dau ky ca nhan trong nuoc,
        sum(CASE  WHEN nvl(cf.country,'234') = '234' AND cf.custtype = 'B'
            THEN (CASE WHEN af.corebank='N' THEN  ci.balance ELSE 0 END) - nvl(TK_TC_TN_credit_all,0) + nvl(TK_TC_TN_Debit_all,0) + nvl(a.amt,0)  ELSE 0 END) DK_TC_TN, --dau ky to chuc trong nuoc,
        sum(CASE  WHEN  nvl(cf.country,'234') <> '234' AND cf.custtype = 'I'
            THEN (CASE WHEN af.corebank='N' THEN  ci.balance ELSE 0 END) - nvl(TK_CN_NN_credit_all,0) + nvl(TK_CN_NN_Debit_all,0) + nvl(a.amt,0)  ELSE 0 END) DK_CN_NN, -- dau ky ca nhan nuoc ngoai,
        sum(CASE  WHEN nvl(cf.country,'234') <> '234' AND cf.custtype = 'B'
            THEN (CASE WHEN af.corebank='N' THEN  ci.balance ELSE 0 END) - nvl(TK_TC_NN_credit_all,0) + nvl(TK_TC_NN_Debit_all,0) + nvl(a.amt,0)  ELSE 0 END) DK_TC_NN, --dau ky to chuc nuoc ngoai,

        SUM(nvl(TK_CN_TN_Debit,0)) TK_CN_TN_Debit,
        SUM(nvl(TK_CN_TN_credit,0)) TK_CN_TN_credit,
        SUM(nvl(TK_TC_TN_Debit,0)) TK_TC_TN_Debit,
        SUM(nvl(TK_TC_TN_credit,0)) TK_TC_TN_credit,
        SUM(nvl(TK_CN_NN_Debit,0)) TK_CN_NN_Debit,
        SUM(nvl(TK_CN_NN_credit,0)) TK_CN_NN_credit,
        SUM(nvl(TK_TC_NN_Debit,0)) TK_TC_NN_Debit,
        SUM(nvl(TK_TC_NN_credit,0)) TK_TC_NN_credit,


        af.bankname --, V_CN_TN CN_TN, V_TC_TN TC_TN, V_CN_NN CN_NN, V_TC_NN TC_NN, V_TODATE TODATE
    from cfmast cf, afmast af, ddmast ci,

    -- Tong phat sinh CI tu From Date den To Date
    (
        select tr.custid, tr.custodycd, tr.acctno ddAcctno,
            sum (case when tr.txtype = 'D' and nvl(cf.country,'234') = '234' AND cf.custtype = 'I' then tr.namt else 0 end) TK_CN_TN_Debit,
            sum (case when tr.txtype = 'C' and nvl(cf.country,'234') = '234' AND cf.custtype = 'I' then tr.namt else 0 end) TK_CN_TN_credit,
            sum (case when tr.txtype = 'D' and nvl(cf.country,'234') = '234' AND cf.custtype = 'B' then tr.namt else 0 end) TK_TC_TN_Debit,
            sum (case when tr.txtype = 'C' and nvl(cf.country,'234') = '234' AND cf.custtype = 'B' then tr.namt else 0 end) TK_TC_TN_credit,
            sum (case when tr.txtype = 'D' and nvl(cf.country,'234') <> '234' AND cf.custtype = 'I' then tr.namt else 0 end) TK_CN_NN_Debit,
            sum (case when tr.txtype = 'C' and nvl(cf.country,'234') <> '234' AND cf.custtype = 'I' then tr.namt else 0 end) TK_CN_NN_credit,
            sum (case when tr.txtype = 'D' and nvl(cf.country,'234') <> '234' AND cf.custtype = 'B' then tr.namt else 0 end) TK_TC_NN_Debit,
            sum (case when tr.txtype = 'C' and nvl(cf.country,'234') <> '234' AND cf.custtype = 'B' then tr.namt else 0 end) TK_TC_NN_credit
        from vw_ddtran_gen tr, cfmast cf
        where txtype in ('D','C')
            and field = 'BALANCE'
            and tr.busdate BETWEEN V_FROMDATE AND V_TODATE
            and tr.custid = cf.custid
            AND tr.corebank='N'
        group by tr.custid, tr.custodycd, tr.acctno

    )  tr_from_cur,
    -- Tong phat sinh CI tu From date den ngay hom nay
    (
        select citr.custid, citr.custodycd, citr.acctno DDAcctno,
            sum (case when citr.txtype = 'D' and nvl(cf.country,'234') = '234' AND cf.custtype = 'I' then citr.namt else 0 end) TK_CN_TN_Debit_all,
            sum (case when citr.txtype = 'C' and nvl(cf.country,'234') = '234' AND cf.custtype = 'I' then citr.namt else 0 end) TK_CN_TN_credit_all,
            sum (case when citr.txtype = 'D' and nvl(cf.country,'234') = '234' AND cf.custtype = 'B' then citr.namt else 0 end) TK_TC_TN_Debit_all,
            sum (case when citr.txtype = 'C' and nvl(cf.country,'234') = '234' AND cf.custtype = 'B' then citr.namt else 0 end) TK_TC_TN_credit_all,
            sum (case when citr.txtype = 'D' and nvl(cf.country,'234') <> '234' AND cf.custtype = 'I' then citr.namt else 0 end) TK_CN_NN_Debit_all,
            sum (case when citr.txtype = 'C' and nvl(cf.country,'234') <> '234' AND cf.custtype = 'I' then citr.namt else 0 end) TK_CN_NN_credit_all,
            sum (case when citr.txtype = 'D' and nvl(cf.country,'234') <> '234' AND cf.custtype = 'B' then citr.namt else 0 end) TK_TC_NN_Debit_all,
            sum (case when citr.txtype = 'C' and nvl(cf.country,'234') <> '234' AND cf.custtype = 'B' then citr.namt else 0 end) TK_TC_NN_credit_all
        FROM  vw_ddtran_gen citr, cfmast cf
                WHERE field = 'BALANCE'
                    AND citr.busdate >= V_FROMDATE AND citr.DELTD <> 'Y'
                    and citr.custid = cf.custid
                    AND CF.custatcom ='Y' AND SUBSTR(CF.custodycd,4,1) <> 'P'
                    and citr.txtype in ('D','C')
                    AND citr.corebank='N'
                GROUP BY citr.custid, citr.custodycd, citr.acctno
    )  tr_from_Open,
    (
        select sum(tr.amt) amt, tr.ddacctno acctno,
             cf.custodycd custodycd, CF.custtype
        from vw_stschd_all tr, afmast af, cfmast cf
        where tr.duetype = 'SM' and tr.deltd <> 'Y' and tr.cleardate >= V_FROMDATE
            and tr.txdate < V_FROMDATE
            and tr.ddacctno = af.acctno and af.custid = cf.custid
            AND CF.custatcom = 'Y' AND SUBSTR(CF.custodycd,4,1) <> 'P'
        group by tr.ddacctno, cf.custodycd , CF.custtype
    )A
    where cf.custid = af.custid and af.acctno = ci.acctno
        and ci.acctno = a.acctno (+)
        and ci.acctno = tr_from_cur.ddacctno (+)
        and af.acctno = tr_from_open.ddacctno (+)
        and cf.custatcom = 'Y'
        AND SUBSTR(CF.CUSTODYCD ,4,1) <> 'P'
) a where
    DK_CN_TN + DK_TC_TN + DK_CN_NN + DK_TC_NN +  TK_CN_TN_Debit + TK_CN_TN_credit + TK_TC_TN_Debit +
            TK_TC_TN_credit + TK_CN_NN_Debit + TK_CN_NN_credit + TK_TC_NN_Debit + TK_TC_NN_credit > 0

;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/
