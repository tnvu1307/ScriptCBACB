SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf20053 (
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


SELECT A.SECTYPE,
    SUM(CP_Buy_Val_DK_NN) CP_Buy_Val_DK_NN, SUM(CP_Buy_Val_DK_TN) CP_Buy_Val_DK_TN, SUM(CP_Buy_Qty_DK_NN) CP_Buy_Qty_DK_NN,
    SUM(CP_Buy_Qty_DK_TN) CP_Buy_Qty_DK_TN, SUM(CP_SELL_Val_DK_NN) CP_SELL_Val_DK_NN, SUM(CP_SELL_Val_DK_TN) CP_SELL_Val_DK_TN,
    SUM(CP_SELL_Qty_DK_NN) CP_SELL_Qty_DK_NN, SUM(CP_SELL_Qty_DK_TN) CP_SELL_Qty_DK_TN,
    SUM(CP_Buy_Val_TK_NN) CP_Buy_Val_TK_NN, SUM(CP_Buy_Val_TK_TN) CP_Buy_Val_TK_TN, SUM(CP_Buy_Qty_TK_NN) CP_Buy_Qty_TK_NN,
    SUM(CP_Buy_Qty_TK_TN) CP_Buy_Qty_TK_TN, SUM(CP_SELL_Val_TK_NN) CP_SELL_Val_TK_NN, SUM(CP_SELL_Val_TK_TN) CP_SELL_Val_TK_TN,
    SUM(CP_SELL_Qty_TK_NN) CP_SELL_Qty_TK_NN, SUM(CP_SELL_Qty_TK_TN) CP_SELL_Qty_TK_TN,
    SUM(CP_Buy_Val_CK_NN) CP_Buy_Val_CK_NN, SUM(CP_Buy_Val_CK_TN) CP_Buy_Val_CK_TN,
    SUM(CP_Buy_Qty_CK_NN) CP_Buy_Qty_CK_NN, SUM(CP_Buy_Qty_CK_TN) CP_Buy_Qty_CK_TN,
    SUM(CP_SELL_Val_CK_NN) CP_SELL_Val_CK_NN, SUM(CP_SELL_Val_CK_TN) CP_SELL_Val_CK_TN,
    SUM(CP_SELL_Qty_CK_NN) CP_SELL_Qty_CK_NN, SUM(CP_SELL_Qty_CK_TN) CP_SELL_Qty_CK_TN
FROM
(

    SELECT  SECTYPE,
            CP_Buy_Val_DK_NN, CP_Buy_Val_DK_TN, CP_Buy_Qty_DK_NN, CP_Buy_Qty_DK_TN, CP_SELL_Val_DK_NN,
            CP_SELL_Val_DK_TN, CP_SELL_Qty_DK_NN, CP_SELL_Qty_DK_TN,
            CP_Buy_Val_TK_NN, CP_Buy_Val_TK_TN, CP_Buy_Qty_TK_NN, CP_Buy_Qty_TK_TN, CP_SELL_Val_TK_NN,
            CP_SELL_Val_TK_TN, CP_SELL_Qty_TK_NN, CP_SELL_Qty_TK_TN,
            CP_Buy_Val_DK_NN + CP_Buy_Val_TK_NN CP_Buy_Val_CK_NN, CP_Buy_Val_DK_TN + CP_Buy_Val_TK_TN CP_Buy_Val_CK_TN,
            CP_Buy_Qty_DK_NN + CP_Buy_Qty_TK_NN CP_Buy_Qty_CK_NN, CP_Buy_Qty_DK_TN + CP_Buy_Qty_TK_TN CP_Buy_Qty_CK_TN,
            CP_SELL_Val_DK_NN + CP_SELL_Val_TK_NN CP_SELL_Val_CK_NN, CP_SELL_Val_DK_TN + CP_SELL_Val_TK_TN CP_SELL_Val_CK_TN,
            CP_SELL_Qty_DK_NN + CP_SELL_Qty_TK_NN CP_SELL_Qty_CK_NN, CP_SELL_Qty_DK_TN + CP_SELL_Qty_TK_TN CP_SELL_Qty_CK_TN
    FROM
    (
        SELECT A.SECTYPE,
               CP_Buy_Val_NN CP_Buy_Val_DK_NN, CP_Buy_Val_TN CP_Buy_Val_DK_TN,
               CP_Buy_Qty_NN CP_Buy_Qty_DK_NN, CP_Buy_Qty_TN CP_Buy_Qty_DK_TN,
               CP_SELL_Val_NN CP_SELL_Val_DK_NN, CP_SELL_Val_TN CP_SELL_Val_DK_TN,
               CP_SELL_Qty_NN CP_SELL_Qty_DK_NN, CP_SELL_Qty_TN CP_SELL_Qty_DK_TN,
               CP_Buy_Val_TK_NN, CP_Buy_Val_TK_TN, CP_Buy_Qty_TK_NN, CP_Buy_Qty_TK_TN,
               CP_SELL_Val_TK_NN, CP_SELL_Val_TK_TN, CP_SELL_Qty_TK_NN, CP_SELL_Qty_TK_TN
        FROM
        (
        ---- CP_Phat sinh mua ban trong FromDate toi ngay ToDate
        SELECT SECTYPE,
               sum( CASE WHEN substr(od.custodycd,4,1) = 'F' THEN case when bors='B' then execamt else 0 end ELSE 0 END) CP_Buy_Val_TK_NN,
               sum( CASE WHEN substr(od.custodycd,4,1) <> 'F' THEN case when bors='B' then execamt else 0 end ELSE 0 END) CP_Buy_Val_TK_TN,
               sum( CASE WHEN substr(od.custodycd,4,1) = 'F' THEN case when bors='B' then execqtty else 0 end ELSE 0 END) CP_Buy_Qty_TK_NN,
               sum( CASE WHEN substr(od.custodycd,4,1) <> 'F' THEN case when bors='B' then execqtty else 0 end ELSE 0 END) CP_Buy_Qty_TK_TN,
               sum( CASE WHEN substr(od.custodycd,4,1) = 'F' THEN case when bors='S' then execamt else 0 end ELSE 0 END) CP_SELL_Val_TK_NN,
               sum( CASE WHEN substr(od.custodycd,4,1) <> 'F' THEN case when bors='S' then execamt else 0 end ELSE 0 END) CP_SELL_Val_TK_TN,
               sum( CASE WHEN substr(od.custodycd,4,1) = 'F' THEN case when bors='S' then execqtty else 0 end ELSE 0 END) CP_SELL_Qty_TK_NN,
               sum( CASE WHEN substr(od.custodycd,4,1) <> 'F' THEN case when bors='S' then execqtty else 0 end ELSE 0 END) CP_SELL_Qty_TK_TN
        from (
                select CASE WHEN SB.SECTYPE IN ('001','002') THEN 'I'
                    WHEN SB.SECTYPE IN ('003','006') THEN 'II'
                    WHEN SB.SECTYPE IN ('008') THEN 'III'
                    ELSE 'IV' END SECTYPE, od.*
                from (
                    select orderid orgorderid, txdate , CUSTODYCD,codeid,symbol, exectype bors, execprice, execqtty, execprice * execqtty/1000000 execamt
                    from iodhist where deltd <> 'Y' and TXDATE BETWEEN V_FROMDATE AND V_TODATE
                    union all
                    select orderid orgorderid, txdate, CUSTODYCD, codeid,symbol, exectype bors, execprice,execqtty,  execprice * execqtty/1000000 execamt
                    from iod where deltd <> 'Y' and TXDATE BETWEEN V_FROMDATE AND V_TODATE
                ) od, sbsecurities sb
                where OD.CODEID = SB.CODEID
            ) od
        WHERE TXDATE BETWEEN V_FROMDATE AND V_TODATE
            GROUP BY SECTYPE
        ) A,
        (
        SELECT SECTYPE,
               sum( CASE WHEN substr(od.custodycd,4,1) = 'F' THEN case when bors='B' then execamt else 0 end ELSE 0 END) CP_Buy_Val_NN,
               sum( CASE WHEN substr(od.custodycd,4,1) <> 'F' THEN case when bors='B' then execamt else 0 end ELSE 0 END) CP_Buy_Val_TN,
               sum( CASE WHEN substr(od.custodycd,4,1) = 'F' THEN case when bors='B' then execqtty else 0 end ELSE 0 END) CP_Buy_Qty_NN,
               sum( CASE WHEN substr(od.custodycd,4,1) <> 'F' THEN case when bors='B' then execqtty else 0 end ELSE 0 END) CP_Buy_Qty_TN,
               sum( CASE WHEN substr(od.custodycd,4,1) = 'F' THEN case when bors='S' then execamt else 0 end ELSE 0 END) CP_SELL_Val_NN,
               sum( CASE WHEN substr(od.custodycd,4,1) <> 'F' THEN case when bors='S' then execamt else 0 end ELSE 0 END) CP_SELL_Val_TN,
               sum( CASE WHEN substr(od.custodycd,4,1) = 'F' THEN case when bors='S' then execqtty else 0 end ELSE 0 END) CP_SELL_Qty_NN,
               sum( CASE WHEN substr(od.custodycd,4,1) <> 'F' THEN case when bors='S' then execqtty else 0 end ELSE 0 END) CP_SELL_Qty_TN
        from (
                 select CASE WHEN SB.SECTYPE IN ('001','002') THEN 'I'
                    WHEN SB.SECTYPE IN ('003','006') THEN 'II'
                    WHEN SB.SECTYPE IN ('008') THEN 'III'
                    ELSE 'IV' END SECTYPE, od.*
                from (
                    select orderid orgorderid, txdate , CUSTODYCD,codeid,symbol, exectype bors, execprice, execqtty, execprice * execqtty/1000000 execamt
                    from iodhist where deltd <> 'Y' and TXDATE < V_TODATE
                    union all
                    select orderid orgorderid, txdate, CUSTODYCD, codeid,symbol, exectype bors, execprice,execqtty,  execprice * execqtty/1000000 execamt
                    from iod where deltd <> 'Y' and TXDATE < V_TODATE
                ) od, sbsecurities sb  where OD.CODEID = SB.CODEID
            ) od
        WHERE
            od.TXDATE < V_TODATE
            GROUP BY SECTYPE
        ) B
        WHERE A.SECTYPE = B.SECTYPE
    )
    UNION ALL
    SELECT  'I' SECTYPE,
      0 CP_Buy_Val_DK_NN, 0 CP_Buy_Val_DK_TN, 0 CP_Buy_Qty_DK_NN, 0 CP_Buy_Qty_DK_TN, 0 CP_SELL_Val_DK_NN, 0 CP_SELL_Val_DK_TN,
      0 CP_SELL_Qty_DK_NN, 0 CP_SELL_Qty_DK_TN,
      0 CP_Buy_Val_TK_NN, 0 CP_Buy_Val_TK_TN, 0 CP_Buy_Qty_TK_NN, 0 CP_Buy_Qty_TK_TN, 0 CP_SELL_Val_TK_NN, 0 CP_SELL_Val_TK_TN,
      0 CP_SELL_Qty_TK_NN, 0 CP_SELL_Qty_TK_TN,
      0 CP_Buy_Val_CK_NN, 0 CP_Buy_Val_CK_TN,
      0 CP_Buy_Qty_CK_NN, 0 CP_Buy_Qty_CK_TN,
      0 CP_SELL_Val_CK_NN, 0 CP_SELL_Val_CK_TN,
      0 CP_SELL_Qty_CK_NN, 0 CP_SELL_Qty_CK_TN
    FROM DUAL
    UNION ALL
    SELECT  'II' SECTYPE,
           0 CP_Buy_Val_DK_NN, 0 CP_Buy_Val_DK_TN, 0 CP_Buy_Qty_DK_NN, 0 CP_Buy_Qty_DK_TN, 0 CP_SELL_Val_DK_NN, 0 CP_SELL_Val_DK_TN,
           0 CP_SELL_Qty_DK_NN, 0 CP_SELL_Qty_DK_TN,
           0 CP_Buy_Val_TK_NN, 0 CP_Buy_Val_TK_TN, 0 CP_Buy_Qty_TK_NN, 0 CP_Buy_Qty_TK_TN, 0 CP_SELL_Val_TK_NN, 0 CP_SELL_Val_TK_TN,
           0 CP_SELL_Qty_TK_NN, 0 CP_SELL_Qty_TK_TN,
           0 CP_Buy_Val_CK_NN, 0 CP_Buy_Val_CK_TN,
           0 CP_Buy_Qty_CK_NN, 0 CP_Buy_Qty_CK_TN,
           0 CP_SELL_Val_CK_NN, 0 CP_SELL_Val_CK_TN,
           0 CP_SELL_Qty_CK_NN, 0 CP_SELL_Qty_CK_TN
    FROM DUAL
    UNION ALL
    SELECT  'III' SECTYPE,
           0 CP_Buy_Val_DK_NN, 0 CP_Buy_Val_DK_TN, 0 CP_Buy_Qty_DK_NN, 0 CP_Buy_Qty_DK_TN, 0 CP_SELL_Val_DK_NN, 0 CP_SELL_Val_DK_TN,
           0 CP_SELL_Qty_DK_NN, 0 CP_SELL_Qty_DK_TN,
           0 CP_Buy_Val_TK_NN, 0 CP_Buy_Val_TK_TN, 0 CP_Buy_Qty_TK_NN, 0 CP_Buy_Qty_TK_TN, 0 CP_SELL_Val_TK_NN, 0 CP_SELL_Val_TK_TN,
           0 CP_SELL_Qty_TK_NN, 0 CP_SELL_Qty_TK_TN,
           0 CP_Buy_Val_CK_NN, 0 CP_Buy_Val_CK_TN,
           0 CP_Buy_Qty_CK_NN, 0 CP_Buy_Qty_CK_TN,
           0 CP_SELL_Val_CK_NN, 0 CP_SELL_Val_CK_TN,
           0 CP_SELL_Qty_CK_NN, 0 CP_SELL_Qty_CK_TN
    FROM DUAL
    UNION ALL
    SELECT  'IV' SECTYPE,
           0 CP_Buy_Val_DK_NN, 0 CP_Buy_Val_DK_TN, 0 CP_Buy_Qty_DK_NN, 0 CP_Buy_Qty_DK_TN, 0 CP_SELL_Val_DK_NN, 0 CP_SELL_Val_DK_TN,
           0 CP_SELL_Qty_DK_NN, 0 CP_SELL_Qty_DK_TN,
           0 CP_Buy_Val_TK_NN, 0 CP_Buy_Val_TK_TN, 0 CP_Buy_Qty_TK_NN, 0 CP_Buy_Qty_TK_TN, 0 CP_SELL_Val_TK_NN, 0 CP_SELL_Val_TK_TN,
           0 CP_SELL_Qty_TK_NN, 0 CP_SELL_Qty_TK_TN,
           0 CP_Buy_Val_CK_NN, 0 CP_Buy_Val_CK_TN,
           0 CP_Buy_Qty_CK_NN, 0 CP_Buy_Qty_CK_TN,
           0 CP_SELL_Val_CK_NN, 0 CP_SELL_Val_CK_TN,
           0 CP_SELL_Qty_CK_NN, 0 CP_SELL_Qty_CK_TN
    FROM DUAL
)A

GROUP BY A.SECTYPE
ORDER BY A.SECTYPE
;
EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/
