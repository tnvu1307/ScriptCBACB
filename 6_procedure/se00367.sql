SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se00367 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2
)
IS

-- RP NAME : YEU CAU CHUYEN KHOAN CHUNG KHOAN TAT TOAN TAI KHOAN
-- PERSON --------------DATE---------------------COMMENTS
-- THANHNM            17/07/2012                 CREATE
-- SE00311: report main
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_TYPE  VARCHAR2(10);
   V_CURRDATE DATE;
   V_FLAG NUMBER(2,0);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);
BEGIN
-- GET REPORT'S PARAMETERS
    V_STROPTION := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;
    -----------------
    V_CUSTODYCD := UPPER( PV_CUSTODYCD);
    -----------------
    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
    FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';
    -----------------
    IF  (V_CUSTODYCD <> 'ALL')
    THEN
         V_CUSTODYCD := V_CUSTODYCD;
    ELSE
         V_CUSTODYCD := '%';
    END IF;

-- GET REPORT'S DATA
    OPEN PV_REFCURSOR
    FOR
    SELECT * FROM (
       SELECT  DT.CUSTODYCD,
               DT.FULLNAME,
               DT.ÐKSH,
               DT.NGAY_CAP,
               DT.REPORTDATE,
               DT.SYMBOL,
               DT.CA_TYLE,
               DT.REPORT_QTTY,
               NVL(DT.QTTY,0)QTTY,
            (CASE WHEN  NVL(SB.TRADEPLACE,'') = '010' AND SB.SECTYPE IN ('003','006','222','333','444') THEN 'BOND'
                  ELSE
                      (CASE WHEN SB.TRADEPLACE='002' THEN 'HNX'
                            WHEN SB.TRADEPLACE='001' THEN 'HOSE'
                            WHEN SB.TRADEPLACE='005' THEN 'UPCOM'
                            WHEN SB.TRADEPLACE='003' THEN 'OTC'
                            WHEN SB.TRADEPLACE='009' THEN 'DCCNY'
                            ELSE 'UPCOM' END) END
            ) SAN_GD,
            ROW_NUMBER() OVER(ORDER BY CUSTODYCD) AS NO,
            RECUSTODYCD
            --//-------------------------------------------------//--
        FROM (
       SELECT
            MAX(CF.CUSTODYCD) CUSTODYCD,
            MAX(CF.FULLNAME) FULLNAME,
            MAX(TE.RECUSTODYCD) RECUSTODYCD,
            MAX(CASE WHEN SUBSTR(CF.CUSTODYCD,4,1) ='F' THEN TRADINGCODE ELSE IDCODE END) ÐKSH,
            TO_CHAR(MAX(CASE WHEN SUBSTR(CF.CUSTODYCD,4,1) ='F' THEN TRADINGCODEDT ELSE IDDATE END),'DD/MM/RRRR') NGAY_CAP,
            TO_CHAR(CA.REPORTDATE,'DD/MM/RRRR') REPORTDATE,
            MAX(REPLACE(SB.SYMBOL,'_WFT',''))  SYMBOL,
            MAX(DECODE(CA.CATYPE,'014', CA.RIGHTOFFRATE,'021',CA.SPLITRATE,'006',CA.DEVIDENTSHARES,'011',CA.DEVIDENTSHARES,
                '005',CA.DEVIDENTSHARES,'010', CA.DEVIDENTRATE||'%','023',CA.EXRATE,'017',CA.EXRATE, '1/1')) CA_TYLE,
            MAX (CAS.TRADE)  REPORT_QTTY, NVL(SUM(CAS.CUTPBALANCE),0) CUTPBALANCE,
            NVL(SUM(CAS.QTTY + cas.cutqtty + cas.sendqtty),0)  QTTY,
            NVL(SUM(CAS.CUTAQTTY),0) CUTAQTTY,
            NVL(SUM(CAS.AMT + cas.cutamt + cas.sendamt ),0)   AMT,
             0 CP_LE, 0 RIGHT_QTTY, 0 CK_MUA, ' ' NOTE
        FROM CASCHD  CAS, CAMAST CA, VW_CFMAST_M CF,AFMAST AF, SBSECURITIES SB,
            -----------------------------MAP LAY SO TK NHAN-----------------------------------------
             (              SELECT  CUSTODYCD,RECUSTODYCD
                            FROM (
                                       SELECT    CF.CUSTODYCD,
                                                OU.RECUSTODYCD
                                        FROM SESENDOUT OU,CFMAST CF,AFMAST AF,SBSECURITIES SB,SBSECURITIES SB2,
                                            (SELECT * FROM ALLCODE WHERE CDTYPE = 'SE' AND CDNAME = 'TRTYPE')A1
                                        WHERE OU.DELTD <> 'Y'
                                        AND CF.CUSTID = AF.CUSTID
                                        AND SUBSTR(OU.ACCTNO,1,10) = AF.ACCTNO
                                        AND OU.CODEID = SB.CODEID
                                        AND OU.TRTYPE=A1.CDVAL(+)
                                        AND OU.TXDATE BETWEEN TO_DATE (F_DATE,'DD/MM/RRRR') AND TO_DATE (T_DATE,'DD/MM/RRRR')
                                        AND OU.DELTD <>'Y'
                                        AND NVL(SB.refcodeid,SB.codeid) = SB2.CODEID
                                        AND CF.CUSTODYCD like V_CUSTODYCD
                                        AND TRADE /*+ CAQTTY*/ + STRADE /*+ SCAQTTY*/ + CTRADE /*+ CCAQTTY*/+BLOCKED + SBLOCKED + CBLOCKED > 0

                                 UNION ALL ----------------------------------------------------------------

                                        SELECT  TL.CUSTODYCD,
                                                TL.RECUSTODYCD
                                        FROM   (
                                                    SELECT   TL.TXDATE,TL.TXNUM,
                                                         MAX(SUBSTR (MSGACCT, 0, 10)) ACCTNO,
                                                         MAX(NVL(SB.REFCODEID,SB.CODEID))CODEID,
                                                         MAX(DECODE(FLD.FLDCD,'13',CVALUE,NULL)) CUSTODYCD,
                                                         MAX(DECODE(FLD.FLDCD,'28',CVALUE,NULL)) RECUSTODYCD
                                                       FROM   VW_TLLOG_ALL TL,SBSECURITIES SB, VW_SETRAN_ALL SE,
                                                               VW_TLLOGFLD_ALL FLD
                                                           WHERE   TL.TLTXCD = '2247'  AND TL.DELTD = 'N'
                                                           AND SE.TXNUM=TL.TXNUM AND SE.TXDATE=TL.TXDATE
                                                           AND FLD.TXNUM=TL.TXNUM AND FLD.TXDATE=TL.TXDATE
                                                           AND SE.TXCD='0040'
                                                           AND SE.NAMT<>0
                                                           AND SUBSTR(MSGACCT, 11, 6)=SB.CODEID
                                                           AND TL.TXDATE BETWEEN TO_DATE (F_DATE,'DD/MM/RRRR') AND TO_DATE (T_DATE,'DD/MM/RRRR')
                                                           GROUP BY TL.TXNUM,TL.TXDATE
                                                 UNION ALL
                                                   SELECT   TL.TXDATE,TL.TXNUM,
                                                         MAX(SUBSTR (MSGACCT, 0, 10)) ACCTNO,
                                                         MAX(NVL(SB.REFCODEID,SB.CODEID))CODEID,
                                                         MAX(DECODE(FLD.FLDCD,'13',CVALUE,NULL)) CUSTODYCD,
                                                         MAX(DECODE(FLD.FLDCD,'28',CVALUE,NULL)) RECUSTODYCD
                                                        FROM   VW_TLLOG_ALL TL,SBSECURITIES SB, VW_SETRAN_ALL SE,
                                                               VW_TLLOGFLD_ALL FLD
                                                           WHERE   TL.TLTXCD = '2247'  AND TL.DELTD = 'N'
                                                           AND SE.TXNUM=TL.TXNUM AND SE.TXDATE=TL.TXDATE
                                                           AND FLD.TXNUM=TL.TXNUM AND FLD.TXDATE=TL.TXDATE
                                                           AND SE.TXCD='0044'
                                                           AND SE.NAMT<>0
                                                           AND SUBSTR(MSGACCT, 11, 6)=SB.CODEID
                                                           AND TL.TXDATE BETWEEN TO_DATE (F_DATE,'DD/MM/RRRR') AND TO_DATE (T_DATE,'DD/MM/RRRR')
                                                           GROUP BY TL.TXNUM,TL.TXDATE
                                                   ) TL,
                                                 AFMAST AF, CFMAST CF, SBSECURITIES SB,SBSECURITIES SB2, SECURITIES_INFO SE
                                         WHERE  TL.ACCTNO = AF.ACCTNO
                                                 AND AF.CUSTID = CF.CUSTID
                                                 --AND AF.ACTYPE NOT IN ('0000')
                                                 AND SE.CODEID = SB.CODEID
                                                 AND TL.CODEID = SB.CODEID
                                                 AND NVL(SB.REFCODEID,SB.CODEID) = SB2.CODEID
                                                 AND SB.TRADEPLACE IN ('001', '002', '005')
                                                 AND CF.CUSTODYCD LIKE V_CUSTODYCD
                            ) A GROUP BY  CUSTODYCD,RECUSTODYCD
             )TE
            ----------------------------------------------------------------------
        WHERE CF.CUSTODYCD_ORG LIKE V_CUSTODYCD AND CF.CUSTID = AF.CUSTID
            AND CAS.AFACCTNO = AF.ACCTNO AND CA.CAMASTID = CAS.CAMASTID
            AND CA.CATYPE IN ('017','023')
            AND CAS.CODEID = SB.CODEID
            AND CAS.STATUS ='O'
            AND CF.CUSTODYCD_ORG = TE.CUSTODYCD(+)
        GROUP BY CA.CAMASTID,CA.REPORTDATE  ) DT, SBSECURITIES SB WHERE DT.SYMBOL = SB.SYMBOL
 UNION ALL
           SELECT
               NULL CUSTODYCD,
               NULL FULLNAME,
               NULL ÐKSH,
               NULL NGAY_CAP,
               NULL REPORTDATE,
               NULL SYMBOL,
               NULL CA_TYLE,
               NULL REPORT_QTTY,
               NULL QTTY,
               NULL SAN_GD,
               NULL NO,
               NULL SOTK_CHUYEN
           FROM DUAL
) ORDER BY CUSTODYCD
;
EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('SE00367 ERROR');
   PLOG.ERROR('SE00367: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
