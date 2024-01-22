SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf2005 (
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

   /* select CF_DK_CN_NN, CF_DK_TC_NN, CF_DK_CN_TN, CF_DK_TC_TN,

           */
    select
        A.CF_CK_CN_NN + A.CF_TK_CN_NN_Credit - A.CF_TK_CN_NN_Debit CF_DK_CN_NN,
        A.CF_CK_TC_NN + A.CF_TK_TC_NN_Credit - A.CF_TK_TC_NN_Debit CF_DK_TC_NN,
        A.CF_CK_CN_TN + A.CF_TK_CN_TN_Credit - A.CF_TK_CN_TN_Debit CF_DK_CN_TN,
        A.CF_CK_TC_TN + A.CF_TK_TC_TN_Credit - A.CF_TK_TC_TN_Debit CF_DK_TC_TN,

        /*A.CF_TK_TC_TN_Credit, A.CF_TK_TC_TN_Debit, A.CF_TK_CN_TN_Credit, A.CF_TK_CN_TN_Debit,
        A.CF_TK_TC_NN_Credit, A.CF_TK_TC_NN_Debit, A.CF_TK_CN_NN_Credit, A.CF_TK_CN_NN_Debit,*/

        A.CF_TK_TC_TN_Debit CF_TK_TC_TN_Credit, A.CF_TK_TC_TN_Credit CF_TK_TC_TN_Debit,
        A.CF_TK_CN_TN_Debit CF_TK_CN_TN_Credit, A.CF_TK_CN_TN_Credit CF_TK_CN_TN_Debit,
        A.CF_TK_TC_NN_Debit CF_TK_TC_NN_Credit, A.CF_TK_TC_NN_Credit CF_TK_TC_NN_Debit,
        A.CF_TK_CN_NN_Debit CF_TK_CN_NN_Credit, A.CF_TK_CN_NN_Credit CF_TK_CN_NN_Debit,

        A.CF_CK_TC_TN, A.CF_CK_CN_TN, A.CF_CK_TC_NN, A.CF_CK_CN_NN,
        B.TK_CN_NN_Trade, B.TK_TC_NN_Trade, B.TK_CN_TN_Trade, B.TK_TC_TN_Trade
    from (
        SELECT
        --- TRONG KY
            (
                SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate >= V_FROMDATE and busdate <= V_TODATE
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                    AND cf.custatcom = 'Y' AND deltd <> 'Y'
                    AND cf.custodycd IS NOT NULL
                    and nvl(cf.country,'234') = '234'
            ) CF_TK_TC_TN_Credit,
            (
                SELECT count(*) amt FROM
                (
                    SELECT cf.custid FROM cfmast cf
                    WHERE cf.opndate >= V_FROMDATE and cf.opndate <= V_TODATE
                        AND cf.custtype = 'B'
                        and cf.status <> 'P'
                        AND cf.custodycd IS NOT NULL
                        and nvl(cf.country,'234') = '234'
                        AND cf.custatcom = 'Y'
                    union all
                    SELECT vw_tllog_all.msgacct FROM vw_tllog_all, cfmast cf
                    WHERE tltxcd = '0067' AND busdate >= V_FROMDATE AND busdate <= V_TODATE AND deltd <> 'Y'
                        AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                        and cf.status <> 'P'
                        AND cf.custatcom = 'Y' AND CF.custodycd IS NOT NULL
                        and nvl(cf.country,'234') = '234'
                )
            ) CF_TK_TC_TN_Debit,
            (
                SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate >= V_FROMDATE and busdate <= V_TODATE
                    AND deltd <> 'Y'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                    AND cf.custatcom = 'Y' AND CF.custodycd IS NOT NULL
                    and nvl(country,'234') = '234'
            ) CF_TK_CN_TN_Credit,
            (
                 SELECT count(*) amt FROM
                (
                SELECT cf.custid FROM cfmast cf WHERE cf.opndate >= V_FROMDATE and cf.opndate <= V_TODATE
                        AND cf.custtype = 'I'
                        AND cf.custodycd IS NOT NULL
                        and nvl(cf.country,'234') = '234'
                        and cf.status <> 'P'
                        AND cf.custatcom = 'Y'
                union all
                SELECT vw_tllog_all.msgacct FROM vw_tllog_all, cfmast cf
                    WHERE tltxcd = '0067' AND busdate >= V_FROMDATE and busdate <= V_TODATE AND deltd <> 'Y'
                    and cf.status <> 'P'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                    AND cf.custatcom = 'Y' AND CF.custodycd IS NOT NULL
                    and nvl(country,'234') = '234'
                )
            )CF_TK_CN_TN_Debit,
            (
                SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate >= V_FROMDATE and busdate <= V_TODATE  AND deltd <> 'Y'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                    AND cf.custatcom = 'Y'
                    AND CF.custodycd IS NOT NULL
                    and nvl(country,'234') <> '234'
            ) CF_TK_TC_NN_Credit,
            (
                SELECT count(*) amt FROM
                (
                SELECT cf.custid FROM cfmast cf  WHERE cf.opndate >= V_FROMDATE and cf.opndate <= V_TODATE
                        AND cf.custtype = 'B'
                        and cf.status <> 'P'
                        AND cf.custodycd IS NOT NULL
                        and nvl(cf.country,'234') <> '234'
                        AND cf.custatcom = 'Y'
                union all
                SELECT vw_tllog_all.msgacct FROM vw_tllog_all, cfmast cf
                    WHERE tltxcd = '0067' AND busdate >= V_FROMDATE and busdate <= V_TODATE AND deltd <> 'Y'
                    and cf.status <> 'P'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                    AND cf.custatcom = 'Y'
                    AND CF.custodycd IS NOT NULL
                    and nvl(country,'234') <> '234'
                )
            )CF_TK_TC_NN_Debit,
            (
                SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate >= V_FROMDATE and busdate <= V_TODATE AND deltd <> 'Y'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                    AND cf.custatcom = 'Y'
                    AND CF.custodycd IS NOT NULL
                    and nvl(country,'234') <> '234'
            ) CF_TK_CN_NN_Credit,
            (
                SELECT count(*) amt FROM
                (
                    SELECT cf.custid FROM cfmast cf  WHERE cf.opndate >= V_FROMDATE and cf.opndate <= V_TODATE
                        AND cf.custtype = 'I'
                        and cf.status <> 'P'
                        AND cf.custodycd IS NOT NULL
                        and nvl(cf.country,'234') <> '234'
                        AND cf.custatcom = 'Y'
                    union all
                    SELECT vw_tllog_all.msgacct FROM vw_tllog_all, cfmast cf
                    WHERE tltxcd = '0067' AND busdate >= V_FROMDATE and busdate <= V_TODATE AND deltd <> 'Y'
                        AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                        and cf.status <> 'P'
                        AND cf.custatcom = 'Y'
                        AND CF.custodycd IS NOT NULL
                        and nvl(country,'234') <> '234'
                )
            )CF_TK_CN_NN_Debit,
       --CUOI KY
        (
            SELECT GREATEST( a.amt + b.amt - c.amt,0) FROM
            (
                SELECT count(*) amt FROM (
                    select DISTINCT cf.* from cfmast cf, afmast af
                    where cf.custid = af.custid
                       /* and af.status in('A','N')*/) cf
                WHERE cf.status = 'A' AND cf.custtype = 'B' AND cf.custatcom = 'Y'
                    AND cf.custodycd IS NOT NULL
                    and cf.status <> 'P'
                    and nvl(cf.country,'234') = '234'
            ) a,
            (
                SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate > V_TODATE AND deltd <> 'Y'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                    AND cf.custatcom = 'Y' AND cf.custodycd IS NOT NULL
                    and nvl(cf.country,'234') = '234'
            ) b,
            (
                SELECT count(*) amt FROM
                (
                    SELECT cf.custid FROM cfmast cf
                    WHERE cf.opndate > V_TODATE
                        AND cf.custtype = 'B'
                        and cf.status <> 'P'
                        AND cf.custodycd IS NOT NULL
                        and nvl(cf.country,'234') = '234'
                        AND cf.custatcom = 'Y'
                    union all
                    SELECT vw_tllog_all.msgacct FROM vw_tllog_all, cfmast cf
                    WHERE tltxcd = '0067' AND busdate > V_TODATE AND deltd <> 'Y'
                        AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                        AND cf.custatcom = 'Y' AND CF.custodycd IS NOT NULL
                        and nvl(cf.country,'234') = '234'
                        and cf.status <> 'P'
                )
            ) c
        ) CF_CK_TC_TN,
       (SELECT GREATEST( a.amt + b.amt - c.amt,0) FROM
            (
                SELECT count(*) amt FROM (
                    select DISTINCT cf.* from cfmast cf, afmast af
                    where cf.custid = af.custid
                        /*and af.status in('A','N')*/) cf
                WHERE cf.status = 'A' AND cf.custtype = 'I' AND cf.custatcom = 'Y'
                    AND cf.custodycd IS NOT NULL
                    and nvl(cf.country,'234') = '234'
            ) a,
            (
                SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate > V_TODATE AND deltd <> 'Y'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                    AND cf.custatcom = 'Y' AND CF.custodycd IS NOT NULL
                    and nvl(country,'234') = '234'
            ) b,
            (
                 SELECT count(*) amt FROM
                (SELECT cf.custid FROM cfmast cf WHERE cf.opndate > V_TODATE
                        AND cf.custtype = 'I'
                        AND cf.custodycd IS NOT NULL
                        and nvl(cf.country,'234') = '234'
                        AND cf.custatcom = 'Y'
                union all
                SELECT vw_tllog_all.msgacct FROM vw_tllog_all, cfmast cf
                    WHERE tltxcd = '0067' AND busdate > V_TODATE AND deltd <> 'Y'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                    AND cf.custatcom = 'Y' AND CF.custodycd IS NOT NULL
                    and nvl(country,'234') = '234'
                )
            )c
       ) CF_CK_CN_TN,
       (SELECT GREATEST( a.amt + b.amt - c.amt,0) FROM
            (SELECT count(*) amt FROM (
                    select DISTINCT cf.* from cfmast cf, afmast af
                    where cf.custid = af.custid
                        /*and af.status in('A','N')*/) cf WHERE STATUS = 'A'
                    AND cf.custtype = 'B' AND cf.custodycd IS NOT NULL
                    and nvl(cf.country,'234') <> '234' AND cf.custatcom = 'Y'
            ) a,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate > V_TODATE  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y' AND CF.custodycd IS NOT NULL
                and nvl(country,'234') <> '234'
            ) b,
            (
                SELECT count(*) amt FROM
                (SELECT cf.custid FROM cfmast cf  WHERE cf.opndate > V_TODATE
                        AND cf.custtype = 'B'
                        AND cf.custodycd IS NOT NULL
                        and nvl(cf.country,'234') <> '234'
                        AND cf.custatcom = 'Y'
                union all
                SELECT vw_tllog_all.msgacct FROM vw_tllog_all, cfmast cf
                    WHERE tltxcd = '0067' AND busdate > V_TODATE AND deltd <> 'Y'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                    AND cf.custatcom = 'Y' AND CF.custodycd IS NOT NULL
                    and nvl(country,'234') <> '234'
                )
            )c
       ) CF_CK_TC_NN,
       (SELECT GREATEST( a.amt + b.amt - c.amt,0) FROM
            (
                SELECT count(*) amt FROM (
                    select DISTINCT cf.* from cfmast cf, afmast af
                    where cf.custid = af.custid
                        /*and af.status in('A','N')*/) cf WHERE STATUS = 'A'
                    AND cf.custtype = 'I'
                    AND cf.custodycd IS NOT NULL
                    and nvl(cf.country,'234') <> '234'
                    AND cf.custatcom = 'Y'
            ) a,
            (
                SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate > V_TODATE AND deltd <> 'Y'
                    AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                    AND cf.custatcom = 'Y'
                    AND CF.custodycd IS NOT NULL
                    and nvl(country,'234') <> '234'
            ) b,
            (
                SELECT count(*) amt FROM
                (
                    SELECT cf.custid FROM cfmast cf  WHERE cf.opndate > V_TODATE
                        AND cf.custtype = 'I'
                        AND cf.custodycd IS NOT NULL
                        and nvl(cf.country,'234') <> '234'
                        AND cf.custatcom = 'Y'
                    union all
                    SELECT vw_tllog_all.msgacct FROM vw_tllog_all, cfmast cf
                    WHERE tltxcd = '0067' AND busdate > V_TODATE AND deltd <> 'Y'
                        AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                        AND cf.custatcom = 'Y'
                        AND CF.custodycd IS NOT NULL
                        and nvl(country,'234') <> '234'
                )
            )c
       ) CF_CK_CN_NN
    FROM DUAL ) A,
        (
            SELECT sum( CASE WHEN nvl(cf.country,'234') <> '234' AND cf.custtype = 'I' THEN 1 ELSE 0 END) TK_CN_NN_Trade,
               sum( CASE WHEN nvl(cf.country,'234') <> '234' AND cf.custtype = 'B' THEN 1 ELSE 0 END) TK_TC_NN_Trade,
               sum( CASE WHEN nvl(cf.country,'234') = '234' AND cf.custtype = 'I' THEN 1 ELSE 0 END) TK_CN_TN_Trade,
               sum( CASE WHEN nvl(cf.country,'234') = '234' AND cf.custtype = 'B' THEN 1 ELSE 0 END) TK_TC_TN_Trade
            FROM (select distinct cf.custid from vw_odmast_all od, afmast af, cfmast cf
             where od.txdate BETWEEN V_FROMDATE AND V_TODATE and od.execqtty <> 0
                and od.afacctno = af.acctno and af.custid = cf.custid
             ) od,
                cfmast cf
            WHERE od.custid = cf.custid
        ) B ;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
 
 
 
 
/
