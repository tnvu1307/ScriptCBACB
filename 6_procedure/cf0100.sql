SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0100 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
)
IS
-- ---------   ------  -------------------------------------------
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (40);
    V_INBRID       VARCHAR2 (4);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- insert into temp_bug(text) values('CF0001');commit;
   V_STROPTION := OPT;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE if(V_STROPTION = 'B') then
          select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;

OPEN PV_REFCURSOR FOR
    SELECT CASE WHEN SUBSTR(cf.custodycd,4,1) IN ('C','B','A') THEN 1
            WHEN SUBSTR(cf.custodycd,4,1) IN ('F','E') THEN 2 END  custtype,
        SUM (CASE WHEN cf.custtype IN ('B','','') THEN nvl((sc.paidfeeamt+sc.paidvatamt),0) ELSE 0 END) fee_TC,
        SUM (CASE WHEN cf.custtype IN ('I','','') THEN nvl((sc.paidfeeamt+sc.paidvatamt),0) ELSE 0 END) fee_CN
    FROM cfmast cf, afmast af, VW_SMSFEESCHD_ALL sc
    WHERE cf.custid = af.custid
        AND af.acctno = sc.afacctno
        AND nvl(sc.paidtxdate,sc.txdate) BETWEEN TO_DATE(F_DATE,'DD/MM/RRRR') AND TO_DATE(T_DATE,'DD/MM/RRRR')
        AND (af.brid LIKE V_STRBRID OR INSTR(V_STRBRID,af.brid) <> 0)
    GROUP BY SUBSTR(cf.custodycd,4,1)
;
EXCEPTION
   WHEN OTHERS THEN
   RETURN;
END;                                                              -- PROCEDURE
 
 
 
 
/
