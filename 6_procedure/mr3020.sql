SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE mr3020 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   VSD     IN       VARCHAR2
)
IS
--Bien ban ban giao VSD (Luu ky)
--created by dinhnb at 22/04/2014
--edited by longnh at September,11,2014

   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_SYMBOL        varchar2 (20);
   V_DATE          date;
   V_CURRDATE      date;
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_BORS  VARCHAR2 (50);

   v_CustodyCD varchar2(20);
   VF_DATE DATE;
   VT_DATE DATE;
    VF_WDATE         DATE;
    VT_WDATE         DATE;
    V_VSD        VARCHAR2(50);
    V_TERMCD DATE;
    V_TERMCD11 DATE ;

BEGIN

   V_VSD := VSD;


   -- V_TERMCD := TO_CHAR(add_months('01/'||SUBSTR(TERMCD,0,2)||'/'||SUBSTR(TERMCD,3,4),0),'MM/RRRR');
   --V_TERMCD11 := TO_CHAR(add_months('01/'||SUBSTR(TERMCD,0,2)||'/'||SUBSTR(TERMCD,3,4),-1),'MM/RRRR');

   --V_TERMCD :=ADD_MONTHS(TO_DATE(SUBSTR(TERMCD,0,2)||'/'||SUBSTR(TERMCD,3,4),'MM/YYYY'),0);
   --V_TERMCD11 :=LAST_DAY(TO_DATE(SUBSTR(TERMCD,0,2)||'/'||SUBSTR(TERMCD,3,4),'MM/YYYY'));
   V_TERMCD :=TO_DATE(F_DATE,'DD/MM/YYYY');
   V_TERMCD11 :=TO_DATE(T_DATE,'DD/MM/YYYY');





OPEN PV_REFCURSOR
FOR

SELECT
        A.CODEID, SYMBOL,
        TO_CHAR(V_TERMCD,'dd/mm/yyyy') term,V_VSD VSD,
        DECODE(DK,'Y',SYMBOL,'-') AA,
        CASE when dk = 'Y' AND CK = 'N' THEN SYMBOL
             ELSE '-'
        END BB,
        CASE WHEN DK = 'N' AND CK = 'Y'  THEN SYMBOL
             ELSE '-'
        END CC,--TTK,
        DECODE(CK,'Y',SYMBOL,'-') DD--CK

FROM sbsecurities sb left join
        (
            SELECT CODEID, nvl(max(ISMARGINALLOW),'N') DK,BACKUPDT dkdt
            FROM
            (
                SELECT CODEID, TO_DATE(TO_CHAR(LAST_DAY(getcurrdate)+1)||':23:59:59','DD/MM/RRRR:HH24:MI:SS') BACKUPDT, ISMARGINALLOW FROM securities_risk
                UNION ALL
                SELECT CODEID,  TO_DATE(BACKUPDT,'DD/MM/RRRR:HH24:MI:SS') BACKUPDT, ISMARGINALLOW FROM securities_riskHIST
            ) A
            WHERE (CODEID,A.BACKUPDT) IN (
                                            SELECT CODEID,  MIN(B.BACKUPDT)
                                            FROM
                                            (
                                                SELECT CODEID, TO_DATE(TO_CHAR(LAST_DAY(getcurrdate)+1)||':23:59:59','DD/MM/RRRR:HH24:MI:SS') BACKUPDT, ISMARGINALLOW FROM securities_risk
                                                UNION ALL
                                                SELECT CODEID,  TO_DATE(BACKUPDT,'DD/MM/RRRR:HH24:MI:SS') BACKUPDT, ISMARGINALLOW FROM securities_riskHIST
                                            ) B
                                            WHERE TO_DATE(B.BACKUPDT,'DD/MM/YYYY') >= TO_DATE(V_TERMCD,'DD/MM/YYYY')
                                            GROUP BY CODEID
                                        )
            GROUP BY CODEID,BACKUPDT
        )A on sb.codeid = a.codeid
        left join
        (
            SELECT CODEID,nvl(max(ISMARGINALLOW),'N') CK,BACKUPDT ckdt
            FROM
            (
                SELECT CODEID, TO_DATE(TO_CHAR(LAST_DAY(getcurrdate)+1)||':23:59:59','DD/MM/RRRR:HH24:MI:SS') BACKUPDT, ISMARGINALLOW FROM securities_risk
                UNION ALL
                SELECT CODEID,  TO_DATE(BACKUPDT,'DD/MM/RRRR:HH24:MI:SS') BACKUPDT, ISMARGINALLOW FROM securities_riskHIST
            ) A
            WHERE (CODEID,A.BACKUPDT) IN (
                                            SELECT CODEID,  MIN(B.BACKUPDT)
                                            FROM
                                            (
                                                SELECT CODEID, TO_DATE(TO_CHAR(LAST_DAY(getcurrdate)+1)||':23:59:59','DD/MM/RRRR:HH24:MI:SS') BACKUPDT, ISMARGINALLOW FROM securities_risk
                                                UNION ALL
                                                SELECT CODEID,  TO_DATE(BACKUPDT,'DD/MM/RRRR:HH24:MI:SS') BACKUPDT, ISMARGINALLOW FROM securities_riskHIST
                                            ) B
                                            WHERE TO_DATE(B.BACKUPDT,'DD/MM/YYYY') >= TO_DATE(V_TERMCD11,'DD/MM/YYYY')+1
                                            GROUP BY CODEID
                                         )
            GROUP BY CODEID,BACKUPDT
        )B on sb.codeid = b.codeid

WHERE
SB.TRADEPLACE = V_VSD
and
(DK='Y' OR CK='Y')

order by symbol
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
 
 
/
