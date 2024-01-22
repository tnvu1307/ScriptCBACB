SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se00360 (
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
-- TRIBUI            17/07/2012                 CREATE
-- SE00360: report main
-- ---------   ------  -------------------------------------------
   V_CUSTODYCD VARCHAR2 (15);
   V_CURRDATE DATE;
   V_STRFULLNAME  VARCHAR2(200);
   V_STR_TVLK_CODE  VARCHAR2(10);
   V_STR_TVLK_NAME  VARCHAR2(200);
   V_STR_CUSTODYCD_NHAN  VARCHAR2(10);
   V_HEADOFFICEE VARCHAR2(200);
   CUR            PKG_REPORT.REF_CURSOR;

   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);
   v_totalcaqtty number;

   v_FRDATE date;
   v_TODATE date;
   V_MA_TVLK_NHAN VARCHAR2(200);
   V_TEN_TVLK_NHAN VARCHAR2(200);
   V_SO_TKLK_NHAN VARCHAR2(200);

BEGIN
-- GET REPORT'S PARAMETERS
  V_STROPTION := upper(OPT);
  V_INBRID := BRID;

    IF(V_STROPTION = 'A') THEN
        V_STRBRID := '%%';
    ELSE
        IF(V_STROPTION = 'B') THEN
            SELECT BR.MAPID INTO V_STRBRID FROM BRGRP BR WHERE  BR.BRID = V_INBRID;
        ELSE
            V_STRBRID := V_INBRID;
        END IF;
    END IF;

    V_CUSTODYCD := REPLACE( PV_CUSTODYCD,'.','');
    V_STR_TVLK_NAME :=' ';
    V_STR_TVLK_CODE :=' ';
    V_STRFULLNAME :=' ';

   IF  (V_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := V_CUSTODYCD;
   ELSE
         V_CUSTODYCD := '%';
   END IF;

    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
    FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';
    --
    SELECT VARVALUE INTO V_HEADOFFICEE
    FROM SYSVAR WHERE VARNAME = 'HEADOFFICE' AND GRNAME = 'SYSTEM';

    v_FRDATE := TO_DATE (F_DATE  ,'DD/MM/YYYY');
    v_TODATE := TO_DATE (T_DATE  ,'DD/MM/YYYY');
    -------------------------GET TVLK NHAN----------
    BEGIN
    SELECT  MA_TVLK_NHAN,TEN_TVLK_NHAN,SO_TKLK_NHAN
    INTO  V_MA_TVLK_NHAN,V_TEN_TVLK_NHAN,V_SO_TKLK_NHAN
    FROM (
               SELECT    MEM.DEPOSITID MA_TVLK_NHAN
                        ,MEM.FULLNAME TEN_TVLK_NHAN
                        ,'012.'||MEM.DEPOSITID SO_TKLK_NHAN
                FROM SESENDOUT OU,CFMAST CF,AFMAST AF,SBSECURITIES SB,SBSECURITIES SB2,DEPOSIT_MEMBER MEM,
                    (SELECT * FROM ALLCODE WHERE CDTYPE = 'SE' AND CDNAME = 'TRTYPE')A1
                WHERE OU.DELTD <> 'Y'
                AND CF.CUSTID = AF.CUSTID
                AND SUBSTR(OU.ACCTNO,1,10) = AF.ACCTNO
                AND OU.CODEID = SB.CODEID
                AND OU.TRTYPE=A1.CDVAL(+)
                AND OU.TXDATE BETWEEN v_FRDATE AND v_TODATE
                AND OU.DELTD <>'Y'
                AND NVL(SB.refcodeid,SB.codeid) = SB2.CODEID
                AND OU.outward = MEM.depositid (+)
                AND CF.CUSTODYCD like V_CUSTODYCD
                AND TRADE /*+ CAQTTY*/ + STRADE /*+ SCAQTTY*/ + CTRADE /*+ CCAQTTY*/+BLOCKED + SBLOCKED + CBLOCKED > 0

         UNION ALL ----------------------------------------------------------------

                SELECT  MEM.DEPOSITID MA_TVLK_NHAN
                        ,MEM.FULLNAME TEN_TVLK_NHAN
                        ,'012.'||MEM.DEPOSITID SO_TKLK_NHAN
                FROM   (
                            SELECT   TL.TXDATE,TL.TXNUM,
                                 MAX(SUBSTR (MSGACCT, 0, 10)) ACCTNO,
                                 MAX(NVL(SB.REFCODEID,SB.CODEID))CODEID,
                                 MAX(CASE WHEN SB.REFCODEID IS NULL THEN '(1)' ELSE '(7)' END) TYPE,
                                 MAX(SE.NAMT) MSGAMT,
                                 MAX(DECODE(FLD.FLDCD,'15',FLD.NVALUE,NULL)) QTTY_CA,
                                 MAX(DECODE(FLD.FLDCD,'27',CVALUE,NULL)) MA_TVLK_NHAN,
                                 MAX(DECODE(FLD.FLDCD,'28',CVALUE,NULL)) SO_TKLK_NHAN,
                                 MAX(DECODE(FLD.FLDCD,'29',CVALUE,NULL)) TEN_NGUOI_NHAN
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
                                 MAX (CASE WHEN SB.REFCODEID IS NULL THEN '(2)' ELSE '(8)' END) TYPE,
                                 MAX(SE.NAMT) MSGAMT,
                                 MAX(DECODE(FLD.FLDCD,'15',FLD.NVALUE,NULL)) QTTY_CA,
                                 MAX(DECODE(FLD.FLDCD,'27',CVALUE,NULL)) MA_TVLK_NHAN,
                                 MAX(DECODE(FLD.FLDCD,'28',CVALUE,NULL)) SO_TKLK_NHAN,
                                 MAX(DECODE(FLD.FLDCD,'29',CVALUE,NULL)) TEN_NGUOI_NHAN
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
                         AFMAST AF, CFMAST CF, SBSECURITIES SB,SBSECURITIES SB2, SECURITIES_INFO SE, DEPOSIT_MEMBER MEM
                 WHERE  TL.ACCTNO = AF.ACCTNO
                         AND AF.CUSTID = CF.CUSTID
                         --AND AF.ACTYPE NOT IN ('0000')
                         AND SE.CODEID = SB.CODEID
                         AND TL.CODEID = SB.CODEID
                         AND NVL(SB.REFCODEID,SB.CODEID) = SB2.CODEID
                         AND SB.TRADEPLACE IN ('001', '002', '005')
                         AND CF.CUSTODYCD LIKE V_CUSTODYCD
                         AND TL.MA_TVLK_NHAN = MEM.DEPOSITID(+)
    ) A GROUP BY  MA_TVLK_NHAN,TEN_TVLK_NHAN,SO_TKLK_NHAN ;
    EXCEPTION WHEN OTHERS
       THEN  V_MA_TVLK_NHAN:='ALL';V_TEN_TVLK_NHAN:='ALL';V_SO_TKLK_NHAN:='ALL';
    END;
-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
     SELECT V_HEADOFFICEE TEN_TVLK_CHUYEN,
            V_TEN_TVLK_NHAN TEN_TVLK_NHAN,
            V_MA_TVLK_NHAN MA_TVLK_NHAN,
            V_SO_TKLK_NHAN SO_TKLK_NHAN,
            V_CURRDATE CURDATE
     FROM DUAL;
EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('SE00360 ERROR');
   PLOG.ERROR('SE00360: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
