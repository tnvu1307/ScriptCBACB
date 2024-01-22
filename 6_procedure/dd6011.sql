SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE DD6011(
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AMC           IN       VARCHAR2,
   PV_GCB           IN       VARCHAR2
)
IS
   V_BRID           VARCHAR2(4);
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);           -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);
   V_CUSTODYCD      VARCHAR2(20);
   V_AMC            VARCHAR2(20);
   V_GCB            VARCHAR2(20);
   V_CURRENT        VARCHAR2(20);
   V_CURRENTCHAR    VARCHAR2(100);
BEGIN
   V_STROPTION := UPPER(OPT);
   V_INBRID := BRID;
----
   IF(V_STROPTION = 'A') THEN
        V_STRBRID := '%';
   ELSE
        IF(V_STROPTION = 'B') THEN
            SELECT BR.MAPID INTO V_STRBRID FROM BRGRP BR WHERE  BR.BRID = V_INBRID;
        ELSE
            V_STRBRID := BRID;
        END IF;
   END IF;
----
   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
        V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD  := '%';
   END IF;
----
   IF  (PV_AMC <> 'ALL')
   THEN
        V_AMC := PV_AMC;
   ELSE
        V_AMC  := '%';
   END IF;
----
   IF  (PV_GCB <> 'ALL')
   THEN
        V_GCB := PV_GCB;
   ELSE
        V_GCB  := '%';
   END IF;
   V_CURRENT := TO_CHAR(GETCURRDATE,'MM/RRRR');
   V_CURRENTCHAR := TO_CHAR(GETCURRDATE, 'fmMonth RRRR');
   OPEN PV_REFCURSOR FOR
        SELECT CF.CIFID, FEE.CUSTODYCD, CF.FULLNAME, SUM(FEE.TRANFEE) TRANFEE, SUM(FEE.SEDEPOFEE) SEDEPOFEE, V_CURRENT BILLMONTH, V_CURRENTCHAR BILLMONTHCHAR
        FROM
        (SELECT A.CUSTODYCD, FN_GET_FEEAMT(A.CUSTODYCD, SUM(A.ASSET), SUM(A.SEBAL),1) SEDEPOFEE, 0 TRANFEE ,NULL CUSTID
             FROM VW_SEDEPO_DAILY A
             GROUP BY A.CUSTODYCD
         UNION ALL
         SELECT CF.CUSTODYCD, 0 SEDEPOFEE, FN_GET_FEEAMT(CF.CUSTODYCD, SUM(FE.AMOUNT), COUNT(*),2) TRANFEE, CF.CUSTID
             FROM
             ( SELECT * FROM FEETRANREPAIR FE
               WHERE FE.DELTD <> 'Y'
               AND ((FE.EXECTYPE IN ('NB', 'NS') AND TO_CHAR(FE.CLEARDATE, 'MM/RRRR') = V_CURRENT)
               OR (FE.EXECTYPE NOT IN ('NB', 'NS') AND TO_CHAR(FE.TXDATE, 'MM/RRRR') = V_CURRENT))
             ) FE
             , CFMAST CF
             WHERE FE.CUSTID = CF.CUSTID
             GROUP BY CF.CUSTODYCD, CF.CUSTID
        ) FEE, CFMAST CF
        WHERE FEE.CUSTODYCD = CF.CUSTODYCD
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND CF.AMCID LIKE V_AMC
        AND CF.GCBID LIKE V_GCB
        GROUP BY CF.CIFID, FEE.CUSTODYCD, CF.FULLNAME
     ;
END DD6011;
/
