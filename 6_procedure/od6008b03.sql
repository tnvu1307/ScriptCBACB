SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od6008b03(
       PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
       OPT                    IN       VARCHAR2,
       BRID                   IN       VARCHAR2,

       I_DATE                 IN       VARCHAR2,
       PV_MCUSTODYCD           IN       VARCHAR2,
       PV_CUSTODYCD           IN       VARCHAR2,
       P_AMCCODE              IN       VARCHAR2, /*AMC */
       PV_GCB                 IN       VARCHAR2 /*GCM */
       )
    IS

        V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
        V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

        V_INDATE          DATE;
        V_CURRDATE          DATE;
        V_CUSTODYCD         VARCHAR(20);
        V_AMC               VARCHAR(200);
        V_GCB               VARCHAR(200);
        V_COUNT NUMBER;
        V_MCUSTODYCD         VARCHAR(20);
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

         V_MCUSTODYCD := UPPER(REPLACE(PV_MCUSTODYCD,'.',''));

        IF (V_MCUSTODYCD = 'ALL') THEN
            V_MCUSTODYCD := '%';
        ELSE
            V_MCUSTODYCD:= V_MCUSTODYCD;
        END IF;
         ------------------------------------
        V_INDATE   :=     TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
        V_CURRDATE    :=     GETCURRDATE;
        -------------------------------------

        OPEN PV_REFCURSOR FOR
        SELECT MST.*
        FROM
        (
            SELECT SUBSTR(DD.REFCASAACCT,0,3) || '-' || SUBSTR(DD.REFCASAACCT,4,3) || '-' || SUBSTR(DD.REFCASAACCT,7,LENGTH(DD.REFCASAACCT)) REFCASAACCT, DD.CCYCD, TR.TXDESC TRAN,
                   NVL(TR.CI_CREDIT_AMT,0) INCOMING, NVL(TR.CI_DEBIT_AMT,0) OUTGOING, CF.FULLNAME, TR.FULLNAME_ISS, TR.SYMBOL, CF.CUSTID
                   ,CF.MCUSTODYCD, CF.MFULLNAME
            FROM DDMAST DD,
            (
                SELECT CF.*, CF1.FULLNAME MFULLNAME
                FROM CFMAST CF
                LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES = 'AMC') FA ON CF.AMCID = FA.AUTOID
                LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES = 'GCB') FA1 ON CF.GCBID = FA1.AUTOID
                LEFT JOIN (SELECT * FROM CFMAST WHERE NVL(CUSTODYCD,'%') LIKE V_MCUSTODYCD) CF1 ON CF.MCUSTODYCD = CF1.CUSTODYCD
                WHERE CF.STATUS NOT IN ('C')
                AND CF.CUSTATCOM = 'Y'
                AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
                AND NVL(FA1.SHORTNAME,'%') LIKE V_GCB
                AND NVL(CF.MCUSTODYCD,'%') LIKE V_MCUSTODYCD
                AND NVL(CF.CUSTODYCD,'%') LIKE V_CUSTODYCD
            ) CF,
            (
                SELECT TCI.CUSTID, TCI.CUSTODYCD, TCI.DDACCTNO, TCI.AUTOID, TCI.BKDATE, TCI.TXNUM, TCI.TLTXCD,
                       (CASE WHEN TCI.TLTXCD = '3350' THEN TCI.TXDESC ELSE NVL(TCI.TRDESC, TCI.TXDESC) END) TXDESC,
                       (CASE WHEN TCI.TXTYPE = 'C' THEN TCI.NAMT ELSE 0 END) CI_CREDIT_AMT,
                       (CASE WHEN TCI.TXTYPE = 'D' THEN TCI.NAMT ELSE 0 END) CI_DEBIT_AMT,
                       TSE.FULLNAME_ISS, TSE.SYMBOL
                FROM
                (
                    SELECT CF.CUSTID, CF.CUSTODYCD, LOG.ACCTNO DDACCTNO, LOG.AUTOID, NVL(LOG.BUSDATE, LOG.TXDATE) BKDATE,
                           LOG.TXNUM, TL1.TLTXCD, LOG.TRDESC, LOG.TXTYPE, LOG.NAMT,
                           REPLACE(NVL(NVL(TL1.TXDESC ,LOG.TXDESC),TLTX.EN_CDCONTENT), 'BLACKLIST - ', '') TXDESC
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
                ) TCI,
                (
                    SELECT ISS.FULLNAME FULLNAME_ISS, SB.SYMBOL, SETR.CUSTODYCD, SETR.CUSTID, SETR.TXNUM, NVL(SETR.BUSDATE, SETR.TXDATE) BKDATE
                    FROM ISSUERS ISS, SEMAST SE, SBSECURITIES SB, VW_SETRAN_GEN SETR
                    WHERE ISS.ISSUERID = SB.ISSUERID
                    AND SB.CODEID = SE.CODEID
                    AND SE.ACCTNO = SETR.ACCTNO
                    AND SETR.TLTXCD NOT IN ('6697','6690')
                    GROUP BY ISS.FULLNAME, SB.SYMBOL, SETR.CUSTODYCD, SETR.CUSTID, SETR.TXNUM, NVL(SETR.BUSDATE, SETR.TXDATE)
                ) TSE
                WHERE TCI.BKDATE = V_INDATE
                AND TCI.CUSTID = TSE.CUSTID(+) AND TCI.TXNUM = TSE.TXNUM(+) AND TCI.BKDATE = TSE.BKDATE(+)
            ) TR
            WHERE CF.CUSTID = DD.CUSTID
            AND DD.CUSTID = TR.CUSTID
            AND DD.ACCTNO = TR.DDACCTNO
            ORDER BY TR.BKDATE, TR.AUTOID, TR.TXNUM
        ) MST
        UNION ALL

        SELECT NULL REFCASAACCT, NULL CCYCD, NULL TRAN, 0 INCOMING, 0 OUTGOING, NULL FULLNAME, NULL FULLNAME_ISS, NULL SYMBOL, NULL CUSTID
        ,NULL MCUSTODYCD, NULL MFULLNAME
        FROM DUAL
        WHERE NOT EXISTS(
            SELECT 1
            FROM DDMAST DD,
            (
                SELECT CF.*, CF1.FULLNAME MFULLNAME
                FROM CFMAST CF
                LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES = 'AMC') FA ON CF.AMCID = FA.AUTOID
                LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES = 'GCB') FA1 ON CF.GCBID = FA1.AUTOID
                LEFT JOIN (SELECT * FROM CFMAST WHERE NVL(CUSTODYCD,'%') LIKE V_MCUSTODYCD) CF1 ON CF.MCUSTODYCD = CF1.CUSTODYCD
                WHERE CF.STATUS NOT IN ('C')
                AND CF.CUSTATCOM = 'Y'
                AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
                AND NVL(FA1.SHORTNAME,'%') LIKE V_GCB
                AND NVL(CF.MCUSTODYCD,'%') LIKE V_MCUSTODYCD
                AND NVL(CF.CUSTODYCD,'%') LIKE V_CUSTODYCD
            ) CF,
            (
                SELECT TCI.CUSTID, TCI.CUSTODYCD, TCI.DDACCTNO, TCI.AUTOID, TCI.BKDATE, TCI.TXNUM, TCI.TLTXCD,
                       (CASE WHEN TCI.TLTXCD = '3350' THEN TCI.TXDESC ELSE NVL(TCI.TRDESC, TCI.TXDESC) END) TXDESC,
                       (CASE WHEN TCI.TXTYPE = 'C' THEN TCI.NAMT ELSE 0 END) CI_CREDIT_AMT,
                       (CASE WHEN TCI.TXTYPE = 'D' THEN TCI.NAMT ELSE 0 END) CI_DEBIT_AMT,
                       TSE.FULLNAME_ISS, TSE.SYMBOL
                FROM
                (
                    SELECT CF.CUSTID, CF.CUSTODYCD, LOG.ACCTNO DDACCTNO, LOG.AUTOID, NVL(LOG.BUSDATE, LOG.TXDATE) BKDATE,
                           LOG.TXNUM, TL1.TLTXCD, LOG.TRDESC, LOG.TXTYPE, LOG.NAMT,
                           REPLACE(NVL(NVL(TL1.TXDESC ,LOG.TXDESC),TLTX.EN_CDCONTENT), 'BLACKLIST - ', '') TXDESC
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
                ) TCI,
                (
                    SELECT ISS.FULLNAME FULLNAME_ISS, SB.SYMBOL, SETR.CUSTODYCD, SETR.CUSTID, SETR.TXNUM, NVL(SETR.BUSDATE, SETR.TXDATE) BKDATE
                    FROM ISSUERS ISS, SEMAST SE, SBSECURITIES SB, VW_SETRAN_GEN SETR
                    WHERE ISS.ISSUERID = SB.ISSUERID
                    AND SB.CODEID = SE.CODEID
                    AND SE.ACCTNO = SETR.ACCTNO
                    AND SETR.TLTXCD NOT IN ('6697','6690')
                    GROUP BY ISS.FULLNAME, SB.SYMBOL, SETR.CUSTODYCD, SETR.CUSTID, SETR.TXNUM, NVL(SETR.BUSDATE, SETR.TXDATE)
                ) TSE
                WHERE TCI.BKDATE = V_INDATE
                AND TCI.CUSTID = TSE.CUSTID(+) AND TCI.TXNUM = TSE.TXNUM(+) AND TCI.BKDATE = TSE.BKDATE(+)
            ) TR
            WHERE CF.CUSTID = DD.CUSTID
            AND DD.CUSTID = TR.CUSTID
            AND DD.ACCTNO = TR.DDACCTNO
        );

    EXCEPTION
      WHEN OTHERS
       THEN
          PLOG.ERROR ('OD600803: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
          RETURN;
    END;
/
