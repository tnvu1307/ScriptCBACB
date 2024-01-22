SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF9904 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   pv_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   pv_FULLNAME    IN       VARCHAR2,
   CF_ONPDATE     IN       VARCHAR2,
   CF_BALANCE     IN       NUMBER,
   CF_ADDRESS     IN       VARCHAR2,
   CF_PHONE       IN       VARCHAR2,
   CF_MOBILE      IN       VARCHAR2,
   CF_GRINVESTORS IN       VARCHAR2,
   CF_QuocTich    IN       VARCHAR2


 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE       COMMENTS
-- Diennt      30/09/2011 Create
-- ---------   ------     -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   -- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
   V_STRPV_CUSTODYCD  VARCHAR2(20);
   V_STRPV_AFACCTNO   VARCHAR2(20);
   V_INBRID           VARCHAR2(4);
--   V_STRBRID        VARCHAR2 (50);
--   V_STRTLID        VARCHAR2(6);
--   V_BALANCE        number;
--   V_BALDEFOVD      number;
--   v_bankbalance    number;
--   v_bankavlbal     number;
--   v_fullname       varchar2(500);
--   V_NBAMT          number;
--   V_IN_DATE        date;
--   V_CURRDATE       date;
--   v_strmnemonic    varchar2(50);
BEGIN
/*
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;*/

--   V_STRTLID:=TLID;
   /*IF(TLID <> 'ALL' AND TLID IS NOT NULL)
   THEN
        V_STRTLID := TLID;
   ELSE
        V_STRTLID := 'ZZZZZZZZZ';
   END IF;
*/
/*    V_STROPTION := upper(OPT);
    V_INBRID := BRID;

    if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;
*/

    V_STRPV_CUSTODYCD  := upper(PV_CUSTODYCD);
    IF V_STRPV_CUSTODYCD = 'ALL' THEN
      V_STRPV_CUSTODYCD := '%';
    END IF;

   IF(upper(PV_AFACCTNO) <> 'ALL' AND PV_AFACCTNO IS NOT NULL)
   THEN
        V_STRPV_AFACCTNO := PV_AFACCTNO;
   ELSE
        V_STRPV_AFACCTNO := '%';
   END IF;
 /*  select max(nvl(aft.mnemonic ,'-')) into v_strmnemonic
    from afmast af, aftype aft
    where af.actype = aft.actype
        and af.acctno = V_STRPV_AFACCTNO; */

 /*   v_strmnemonic := nvl(v_strmnemonic,'-');

    V_IN_DATE       := to_date(I_DATE,'dd/mm/rrrr');
    select to_date(varvalue,'dd/mm/rrrr') into V_CURRDATE from sysvar where varname = 'CURRDATE';
        SELECT sum(TRUNC(CI.BALANCE-ci.holdbalance) - NVL(TR.NAMT_BALANCE,0)) BALANCE,
            sum(GREATEST(CI.BALANCE-ci.holdbalance - NVL(TR.NAMT_BALANCE,0) - CI.OVAMT - NVL(TR.NAMT_OVAMT,0) -
            CI.DUEAMT - NVL(TR.NAMT_DUEAMT,0) - CI.DFDEBTAMT - NVL(TR.NAMT_DFDEBTAMT,0) - NVL (B.OVERAMT, 0) -
            NVL(B.SECUREAMT,0) - CI.TRFBUYAMT - NVL(TR.NAMT_TRFBUYAMT,0) - NVL(PD.DEALPAIDAMT,0) - CI.DEPOFEEAMT -
            NVL(TR.NAMT_DEPOFEEAMT,0),0)) BALDEFOVD, sum(ci.bankbalance) bankbalance, sum(ci.bankavlbal) bankavlbal,
            cf.fullname
        into V_BALANCE, V_BALDEFOVD, v_bankbalance, v_bankavlbal, v_fullname
        FROM afmast af, cfmast cf, CIMAST CI
        LEFT JOIN
        (SELECT AFACCTNO, sum(SECUREAMT) SECUREAMT, sum(ADVAMT) ADVAMT, sum(OVERAMT) OVERAMT
        FROM V_GETBUYORDERINFO
        group by AFACCTNO
        ) B
        ON CI.ACCTNO = B.AFACCTNO
        LEFT JOIN
        (
            SELECT AFACCTNO, sum(AAMT) AAMT, sum(DEPOAMT) AVLADVANCE, sum(ADVAMT) ADVANCEAMOUNT, sum(PAIDAMT) PAIDAMT
            FROM V_GETACCOUNTAVLADVANCE group by AFACCTNO
        ) ADV
        ON ADV.AFACCTNO=CI.ACCTNO
        LEFT JOIN
        (
            SELECT AFACCTNO, sum(DEALPAIDAMT) DEALPAIDAMT
            FROM V_GETDEALPAIDBYACCOUNT P
            group by P.AFACCTNO
        ) PD
        ON PD.AFACCTNO=CI.ACCTNO
        LEFT JOIN
        (
        SELECT ACCTNO,
            SUM(CASE WHEN FIELD = 'BALANCE' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) NAMT_BALANCE,
            SUM(CASE WHEN FIELD = 'TRFBUYAMT' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) NAMT_TRFBUYAMT,
            SUM(CASE WHEN FIELD = 'OVAMT' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) NAMT_OVAMT,
            SUM(CASE WHEN FIELD = 'DUEAMT' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) NAMT_DUEAMT,
            SUM(CASE WHEN FIELD = 'DFDEBTAMT' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) NAMT_DFDEBTAMT,
            SUM(CASE WHEN FIELD = 'DEPOFEEAMT' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) NAMT_DEPOFEEAMT
        FROM VW_CITRAN_GEN
        WHERE DELTD <> 'Y' AND FIELD IN ('BALANCE','TRFBUYAMT','OVAMT','DUEAMT','DFDEBTAMT','DEPOFEEAMT')
            and custodycd = V_STRPV_CUSTODYCD
            and txdate > V_IN_DATE
        GROUP BY ACCTNO
        ) TR
        ON CI.ACCTNO = TR.ACCTNO
        WHERE af.custid = cf.custid
            and cf.custodycd = V_STRPV_CUSTODYCD
            and ci.afacctno = af.acctno
            and af.acctno like V_STRPV_AFACCTNO
        GROUP BY cf.custodycd, cf.fullname
    ;
*/
OPEN PV_REFCURSOR
  FOR
 select cf.CUSTODYCD,
       af.acctno,
       cf.FUllNAME,
       cf.OPNDATE,
       SUM(ci.balance) BALANCE,
       cf.ADDRESS,
       cf.PHONE,
       cf.MOBILE,
       (case
         when cf.GRINVESTOR = '001' then
          'Trong Nuoc'
         when cf.country = '002' then
          'Nuoc Ngoai'
         else
          'Khac'
       end) GRINVENTORS,
       (a.cdcontent)QuocTich
  from ddmast ci inner join afmast af on ci.afacctno=af.acctno inner join cfmast cf on af.custid=cf.custid
 inner join allcode a
    on cf.country = a.cdval
   and a.cdname = 'COUNTRY'
 where af.status='A' and cf.opndate <= TO_DATE(CF_ONPDATE,'dd/mm/yyyy')
 group by cf.CUSTODYCD,af.acctno,cf.FUllNAME,cf.OPNDATE,
 cf.ADDRESS,cf.PHONE,cf.MOBILE,cf.grinvestor,cf.country,a.cdcontent;
 /*   SELECT V_IN_DATE INDATE, SE.custodycd, SE.fullname, v_strmnemonic mnemonic,
        (case when V_STRPV_AFACCTNO = '%' then 'ALL' else  PV_AFACCTNO end ) AFACCTNO,
        (case when SB.REFSYMBOL is null then SB.SYMBOL else SB.REFSYMBOL end) SYMBOL,
        SB.TRADEPLACE, a0.cdcontent TRADEPLACE_name,
        --chung khoan giao dich.
        sum(case when SB.REFSYMBOL is null then SE.TRADE-NVL(TR.TRADE_NAMT,0) else 0 end)-
        SUM(NVL(ODONDAY.execqttyDAY,0)) TRADE_AMT,
        --chung khoan han che chuyen nhuong.
        sum(case when SB.REFSYMBOL is null then se.BLOCKED-nvl(tr.BLOCKED_NAMT,0) else 0 end) BLOCKED_AMT,
        ---chung khoan da ban.
        sum(NVL(ODONDAY.execqtty,0)) NETTING_AMT,
        --- chung khoan phong toa khac.
        sum(case when SB.REFSYMBOL is null then se.EMKQTTY-nvl(tr.EMKQTTY_NAMT,0) else 0 end) EMKQTTY_AMT,
        --chung khoan cho giao dich.
        sum(case when SB.REFSYMBOL is null then 0 else SE.TRADE-NVL(TR.TRADE_NAMT,0) end) TRADE_WFT,
        --chung khoan cho giao dich HCCN.
        sum(case when SB.REFSYMBOL is null then 0 else se.BLOCKED-nvl(tr.BLOCKED_NAMT,0) end) BLOCKED_WFT,
        -- gia chung khoan tai ngay bao cao.
        max(nvl(sec.basicprice,0)) basicprice ,
        V_BALANCE ciBALANCE, V_BALDEFOVD ciBALDEFOVD,
        sum(nvl(dftr.dfqtty,0)) DFQTTY, sum(nvl(dftr.blockqtty,0)) RCVDFQTTY, max(nvl(od.AMT,0)) NBAMT,
        - sum(case when SB.REFSYMBOL is null then se.standing-nvl(tr.standing_NAMT,0) else 0 end) BLOCKED_VSD,
        v_bankbalance bankbalance, v_bankavlbal bankavlbal
    FROM
    (
        SELECT CF.custodycd, SE.codeid, CF.fullname,  MAX(AF.actype) ACTYPE,
            SUM(TRADE) TRADE, SUM(BLOCKED) BLOCKED, SUM(EMKQTTY) EMKQTTY, SUM(NETTING) NETTING,
            SUM(NVL(standing,0)) standing
        FROM SEMAST SE, cfmast cf, afmast af
        WHERE SE.afacctno = AF.acctno AND AF.custid= CF.custid
            AND CF.custodycd = V_STRPV_CUSTODYCD
            AND SE.afacctno LIKE V_STRPV_AFACCTNO
        GROUP BY CF.custodycd, SE.CODEID, CF.fullname
    ) SE,
    (
        SELECT SB.sectype, SB.CODEID, SB.SYMBOL,
            (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE,
            SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL
        FROM SBSECURITIES SB, SBSECURITIES SB1
        WHERE SB.REFCODEID = SB1.CODEID(+)
    ) SB,
    (
        SELECT custodycd, codeid,
            SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) TRADE_NAMT,
            SUM(CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) BLOCKED_NAMT,
            SUM(CASE WHEN FIELD = 'NETTING' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) NETTING_NAMT,
            SUM(CASE WHEN FIELD = 'EMKQTTY' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) EMKQTTY_NAMT,
            SUM(CASE WHEN FIELD = 'STANDING' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) STANDING_NAMT
        FROM VW_SETRAN_GEN
        WHERE DELTD <> 'Y' AND FIELD IN ('TRADE','BLOCKED','NETTING','EMKQTTY','STANDING')
            and txdate > V_IN_DATE
            and custodycd = V_STRPV_CUSTODYCD
            AND afacctno LIKE V_STRPV_AFACCTNO
        GROUP BY custodycd, codeid
        HAVING SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'NETTING' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
            SUM(CASE WHEN FIELD = 'EMKQTTY' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0
    ) TR,
    (
        select symbol, max(basicprice) basicprice
        from
        (
            select V_CURRDATE txdate, symbol, basicprice
            from securities_info
            where V_CURRDATE = V_IN_DATE
            union all
            select histdate txdate, symbol, basicprice
            from securities_info_hist
            where histdate = V_IN_DATE
        )
        group by symbol
    )sec, allcode a0, aftype aft,
    (
        SELECT cf.custodycd, SUM((OD.ORDERQTTY) * OD.QUOTEPRICE * (1 +  (MOD(OD.BRATIO,1)/100)))  AS AMT
        FROM ODMAST OD, afmast af, cfmast cf,
        (SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') CURRDATE FROM sysvar WHERE varname ='CURRDATE') SY
        WHERE OD.EXECTYPE = 'NB' AND OD.TXDATE = SY.CURRDATE and od.deltd <> 'Y'
            and od.AFACCTNO = af.acctno and af.custid = cf.custid
            and af.acctno like V_STRPV_AFACCTNO and cf.custodycd = V_STRPV_CUSTODYCD
        GROUP BY cf.custodycd
    ) OD,
    (
        select codeid, custodycd, sum(NVL(execqtty,0)) execqtty, SUM(NVL(execqttyDAY,0)) execqttyDAY
        from
        (
            select OD.codeid, CF.custodycd, OD.execqtty,
                (CASE WHEN OD.stsstatus = 'N'  THEN OD.execqtty ELSE 0 END) execqttyDAY
            from odmast OD, AFMAST AF, CFMAST CF
            where OD.execqtty > 0
                and OD.exectype in ('MS','NS')
                and OD.txdate <= V_IN_DATE
                and OD.deltd <> 'Y'
                AND OD.afacctno = AF.acctno AND AF.custid = CF.custid
                AND CF.custodycd = V_STRPV_CUSTODYCD
                AND AF.acctno LIKE V_STRPV_AFACCTNO
            union all
            select odhist.codeid, CF.custodycd, odhist.execqtty, 0 execqttyDAY
            from odmasthist odhist, stschdhist  sthist, AFMAST AF, CFMAST CF
            where execqtty > 0
                and odhist.txdate <= V_IN_DATE
                and exectype in ('MS','NS')
                AND sthist.orgorderid = odhist.orderid
                AND sthist.duetype = 'RM'
                AND sthist.cleardate > V_IN_DATE
                AND odhist.afacctno = AF.acctno AND AF.custid = CF.custid
                AND CF.custodycd = V_STRPV_CUSTODYCD
                AND AF.acctno LIKE V_STRPV_AFACCTNO
        )
        group by codeid, custodycd
    )ODONDAY,
    (
        select CF.CUSTODYCD , df.codeid,
            sum(df.dfqtty-nvl(dftr.DFqtty,0)) DFQTTY,
            sum((df.RCVQTTY+df.BLOCKQTTY)-nvl(dftr.DFqtty,0) - nvl(dftr.BLOCKQTTY,0)) BLOCKQTTY
        from vw_dfmast_all df, AFMAST AF, CFMAST CF,
            (
                select tran.acctno,
                    sum(case when FIELD = 'DFQTTY' then
                        (case when ap.txtype = 'D' then namt else -namt end) else 0 end) DFqtty,
                    sum(case when FIELD <> 'DFQTTY' then
                        (case when ap.txtype = 'D' then namt else -namt end) else 0 end) BLOCKQTTY
                from vw_dftran_all tran, apptx ap----, vw_dfmast_all df
                where tran.txcd = ap.txcd and ap.apptype = 'DF'  and tran.deltd <> 'Y'
                    and ap.field in ('DFQTTY', 'RCVQTTY', 'BLOCKQTTY')
                    and ap.txtype in ('C','D')--- and df.acctno = tran.acctno
                    and tran.txdate > V_IN_DATE
                group by  tran.acctno
            ) dftr
        where df.acctno = dftr.acctno(+)
            AND df.afacctno = AF.acctno AND AF.custid = CF.custid
            and cf.custodycd = V_STRPV_CUSTODYCD
            and af.acctno like V_STRPV_AFACCTNO
        group by CF.CUSTODYCD, df.codeid
    ) dftr
    WHERE SE.CODEID = SB.CODEID
        AND SE.custodycd = OD.custodycd(+)
        and se.CODEID = dftr.CODEID(+)
        and se.custodycd = dftr.custodycd(+)
---        AND SE.custodycd = CI.custodycd(+)
        AND SE.custodycd =  TR.custodycd(+)
        and se.CODEID = TR.CODEID(+)
        AND SE.custodycd =  ODONDAY.custodycd(+)
        and se.CODEID = ODONDAY.CODEID(+)
        and SE.custodycd = V_STRPV_CUSTODYCD
        and SE.actype = aft.actype
        AND SB.SECTYPE <> '004'
        and sb.TRADEPLACE = a0.cdval and a0.cdname = 'TRADEPLACE' and a0.cdtype = 'SE'
        and (case when sb.REFSYMBOL is null then sb.symbol else sb.REFSYMBOL end) = sec.symbol(+)
----        and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_STRTLID )
    group by SE.custodycd, SE.fullname,
        (case when SB.REFSYMBOL is null then SB.SYMBOL else SB.REFSYMBOL end), SB.TRADEPLACE, a0.cdcontent
    HAVING sum(case when SB.REFSYMBOL is null then SE.TRADE-NVL(TR.TRADE_NAMT,0) else 0 end) <> 0 OR
        --chung khoan han che chuyen nhuong.
        sum(case when SB.REFSYMBOL is null then se.BLOCKED-nvl(tr.BLOCKED_NAMT,0) else 0 end) <> 0 OR
        ---chung khoan da ban.
        sum(NVL(ODONDAY.execqtty,0)) <> 0 OR
        --- chung khoan phong toa khac.
        sum(case when SB.REFSYMBOL is null then se.EMKQTTY-nvl(tr.EMKQTTY_NAMT,0) else 0 end) <> 0 OR
        --chung khoan cho giao dich.
        sum(case when SB.REFSYMBOL is null then 0 else SE.TRADE-NVL(TR.TRADE_NAMT,0) end) <> 0 OR
        --chung khoan cho giao dich HCCN.
        sum(case when SB.REFSYMBOL is null then 0 else se.BLOCKED-nvl(tr.BLOCKED_NAMT,0) end) <> 0
        -- gia chung khoan tai ngay bao cao.
        or max(nvl(od.AMT,0)) <> 0
        or sum(nvl(dftr.dfqtty,0)) <> 0
        or sum(nvl(dftr.blockqtty,0)) <> 0
        OR sum(case when SB.REFSYMBOL is null then se.standing-nvl(tr.standing_NAMT,0) else 0 end) <> 0
    union all
    SELECT V_IN_DATE INDATE, V_STRPV_CUSTODYCD custodycd, v_fullname fullname, v_strmnemonic mnemonic,
        (case when V_STRPV_AFACCTNO = '%' then 'ALL' else  V_STRPV_AFACCTNO end ) AFACCTNO,
        NULL SYMBOL,
        NULL TRADEPLACE, NULL TRADEPLACE_name,
        0 TRADE_AMT, 0 BLOCKED_AMT, 0 NETTING_AMT, 0 EMKQTTY_AMT,
        0 TRADE_WFT, 0 BLOCKED_WFT, 0 basicprice ,
        V_BALANCE ciBALANCE, V_BALDEFOVD ciBALDEFOVD,
        0 DFQTTY, 0 RCVDFQTTY, 0 NBAMT, 0 BLOCKED_VSD,
        v_bankbalance bankbalance, v_bankavlbal bankavlbal
    from dual
;
*/

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/
