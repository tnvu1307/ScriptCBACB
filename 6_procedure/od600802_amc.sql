SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od600802_amc(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,

   I_DATE                 IN       VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2,
   P_AMCCODE              IN       VARCHAR2, /*AMC */
   PV_GCB                 IN       VARCHAR2 /*GCM */
   )
IS

    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_INDATE          DATE;
    V_NEXTINDATE        DATE;
    V_CURRDATE          DATE;
    V_CUSTODYCD         VARCHAR(20);
    V_AMC               VARCHAR(200);
    V_GCB               VARCHAR(200);
   BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
      ------------------------------------
     IF (PV_GCB = 'ALL') THEN
        V_GCB := '%';
     ELSE
        V_GCB:= PV_GCB;
     END IF;
     ------------------------------------
     IF (P_AMCCODE = 'ALL') THEN
        V_AMC := '%';
     ELSE
        V_AMC:= P_AMCCODE;
     END IF;
     ------------------------------------
     V_CUSTODYCD := UPPER(REPLACE(PV_CUSTODYCD,'.',''));
     IF (V_CUSTODYCD = 'ALL') THEN
        V_CUSTODYCD := '%';
     ELSE
        V_CUSTODYCD:= V_CUSTODYCD;
     END IF;
     ------------------------------------
     SELECT MIN(SBDATE) INTO V_NEXTINDATE
     FROM SBCLDR
     WHERE CLDRTYPE ='000' AND HOLIDAY='N'
        AND SBDATE > V_INDATE;
     ------------------------------------
    V_INDATE   :=     TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_CURRDATE    :=     GETCURRDATE;

OPEN PV_REFCURSOR FOR
SELECT CF.FULLNAME FUNDNAME, CF.CIFID, CF.CUSTID
        ,SUBSTR(DD.REFCASAACCT,0,3) || '-' || SUBSTR(DD.REFCASAACCT,4,3) || '-' || SUBSTR(DD.REFCASAACCT,7,LENGTH(DD.REFCASAACCT)) REFCASAACCT
        ,DD.CCYCD,
        NVL(TR2.INCOMING,0) INCOMING,
        NVL(TR2.OUTGOING,0) OUTGOING,
        DD.BALANCE + DD.HOLDBALANCE - NVL(TR1.CI_TOTAL_MOVE_FRDT_AMT,0) OCB,
        (DD.BALANCE + DD.HOLDBALANCE - NVL(TR1.CI_TOTAL_MOVE_FRDT_AMT,0)) + (NVL(TR2.INCOMING,0) - NVL(TR2.OUTGOING,0)) CCB,
        (DD.BALANCE - NVL(TR1.CI_TOTAL_MOVE_FRDT_AMT,0)) + (NVL(TR2.INCOMING,0) - NVL(TR2.OUTGOING,0)) ACB
FROM
(
    SELECT * FROM DDMAST WHERE STATUS NOT IN ('C')
) DD,
(
    SELECT CF.*
    FROM CFMAST CF
    INNER JOIN (SELECT * FROM EMAILREPORT WHERE DELTD <> 'Y' AND REGISTTYPE = 'AMC') E ON E.CUSTID = CF.CUSTID
    LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES = 'AMC') FA ON CF.AMCID = FA.AUTOID
    LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES = 'GCB') FA1 ON CF.GCBID = FA1.AUTOID
    WHERE CF.STATUS NOT IN ('C')
    AND CF.CUSTATCOM = 'Y'
    AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
    AND NVL(FA1.SHORTNAME,'%') LIKE V_GCB
    AND CF.CUSTODYCD LIKE V_CUSTODYCD
) CF,
(
    SELECT TR.CUSTID, TR.DDACCTNO,
    SUM(CASE WHEN TR.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) CI_TOTAL_MOVE_FRDT_AMT
    FROM
    (
        SELECT LOG.TXTYPE, LOG.NAMT, NVL(LOG.BUSDATE, LOG.TXDATE) BKDATE, CF.CUSTODYCD, CF.CUSTID, LOG.ACCTNO DDACCTNO, LOG.FIELD
        FROM DDMAST DD, VW_DDTRAN_GEN LOG, AFMAST AF, CFMAST CF, VW_TLLOG_ALL TL1,
        (SELECT EN_TXDESC, TLTXCD, TXDESC CDCONTENT, EN_TXDESC EN_CDCONTENT FROM TLTX) TLTX
        WHERE DD.ACCTNO = LOG.ACCTNO
        AND AF.ACCTNO = DD.AFACCTNO
        AND AF.CUSTID = CF.CUSTID
        AND LOG.TLTXCD = TLTX.TLTXCD
        AND LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
        AND LOG.FIELD = 'BALANCE'
        AND LOG.TXTYPE IN ('D','C')
        AND LOG.DELTD = 'N'
        AND LOG.NAMT <> 0
        AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
        AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
        AND TL1.TLTXCD NOT IN ('1296')
        AND NOT EXISTS (
            SELECT 1 FROM VW_TLLOG_ALL TL2
            WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
            AND TL2.TXDATE = TL1.TXDATE
            AND TL2.REFTXNUM = TL1.TXNUM
        )
    ) TR
    WHERE TR.BKDATE >= V_INDATE
    GROUP BY TR.CUSTID, TR.DDACCTNO
) TR1,
(
    SELECT TR.CUSTID, TR.DDACCTNO,
    SUM(CASE WHEN TXTYPE ='C' THEN NAMT ELSE 0 END) INCOMING, SUM(CASE WHEN TXTYPE ='D' THEN NAMT ELSE 0 END) OUTGOING
    FROM
    (
        SELECT LOG.TXTYPE, LOG.NAMT, NVL(LOG.BUSDATE, LOG.TXDATE) BKDATE, CF.CUSTODYCD, CF.CUSTID, LOG.ACCTNO DDACCTNO, LOG.FIELD
        FROM DDMAST DD, VW_DDTRAN_GEN LOG, AFMAST AF, CFMAST CF, VW_TLLOG_ALL TL1,
        (SELECT EN_TXDESC, TLTXCD, TXDESC CDCONTENT, EN_TXDESC EN_CDCONTENT FROM TLTX) TLTX
        WHERE DD.ACCTNO = LOG.ACCTNO
        AND AF.ACCTNO = DD.AFACCTNO
        AND AF.CUSTID = CF.CUSTID
        AND LOG.TLTXCD = TLTX.TLTXCD
        AND LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
        AND LOG.FIELD = 'BALANCE'
        AND LOG.TXTYPE IN ('D','C')
        AND LOG.DELTD = 'N'
        AND LOG.NAMT <> 0
        AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
        AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
        AND TL1.TLTXCD NOT IN ('1296')
        AND NOT EXISTS (
            SELECT 1 FROM VW_TLLOG_ALL TL2
            WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
            AND TL2.TXDATE = TL1.TXDATE
            AND TL2.REFTXNUM = TL1.TXNUM
        )
    ) TR
    WHERE TR.BKDATE = V_INDATE
    GROUP BY TR.CUSTID, TR.DDACCTNO
) TR2
WHERE CF.CUSTID = DD.CUSTID
AND DD.CUSTID = TR1.CUSTID(+) AND DD.ACCTNO = TR1.DDACCTNO(+)
AND DD.CUSTID = TR2.CUSTID(+) AND DD.ACCTNO = TR2.DDACCTNO(+)

UNION ALL
------------------------
SELECT NULL FUNDNAME, NULL CIFID, NULL CUSTID, NULL REFCASAACCT, NULL CCYCD,
        0 INCOMING,
        0 OUTGOING,
        0 OCB,
        0 CCB,
        0 ACB
FROM DUAL
WHERE NOT EXISTS(
    SELECT 1
    FROM
    (
        SELECT * FROM DDMAST WHERE STATUS NOT IN ('C')
    ) DD,
    (
        SELECT CF.*
        FROM CFMAST CF
        INNER JOIN (SELECT * FROM EMAILREPORT WHERE DELTD <> 'Y' AND REGISTTYPE = 'AMC') E ON E.CUSTID = CF.CUSTID
        LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES = 'AMC') FA ON CF.AMCID = FA.AUTOID
        LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES = 'GCB') FA1 ON CF.GCBID = FA1.AUTOID
        WHERE CF.STATUS NOT IN ('C')
        AND CF.CUSTATCOM = 'Y'
        AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
        AND NVL(FA1.SHORTNAME,'%') LIKE V_GCB
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
    ) CF
    WHERE CF.CUSTID = DD.CUSTID
);

EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('od600802_GCB: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
