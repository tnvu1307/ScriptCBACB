SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se00361 (
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
-- Lay du lieu tu GD2244
-- ---------   ------  -------------------------------------------
   V_CUSTODYCD VARCHAR2 (15);
   V_CURRDATE DATE;
   V_STRFULLNAME  VARCHAR2(200);
   V_STR_TVLK_CODE  VARCHAR2(10);
   V_STR_TVLK_NAME  VARCHAR2(200);
   V_STR_CUSTODYCD_NHAN  VARCHAR2(10);
   CUR            PKG_REPORT.REF_CURSOR;

   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);
   v_totalcaqtty number;
   v_BRNAME VARCHAR2 (200);

   v_FRDATE date;
   v_TODATE date;

BEGIN
-- GET REPORT'S PARAMETERS
    V_STROPTION := upper(OPT);
    V_INBRID := BRID;
   -----------------------------------------------------
    IF(V_STROPTION = 'A') THEN
        V_STRBRID := '%%';
    ELSE
        IF(V_STROPTION = 'B') THEN
            SELECT BR.MAPID INTO V_STRBRID FROM BRGRP BR WHERE  BR.BRID = V_INBRID;
        ELSE
            V_STRBRID := V_INBRID;
        END IF;
    END IF;
   -----------------------------------------------------
    V_CUSTODYCD := REPLACE( PV_CUSTODYCD,'.','');
    V_STR_TVLK_NAME :=' ';
    V_STR_TVLK_CODE :=' ';
    V_STRFULLNAME :=' ';
   -----------------------------------------------------
   IF  (V_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := V_CUSTODYCD;
   ELSE
         V_CUSTODYCD := '%';
   END IF;
   -----------------------------------------------------
   SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
   FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';
   -----------------------------------------------------
   Select max(case when  varname='BRNAME' then varvalue else '' end) into v_BRNAME
   from sysvar WHERE varname IN ('BRNAME');
   -----------------------------------------------------
   v_FRDATE := TO_DATE (F_DATE  ,'DD/MM/YYYY');
   v_TODATE := TO_DATE (T_DATE  ,'DD/MM/YYYY');

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR

SELECT  CF1.FULLNAME||LPAD(' ',DENSE_RANK() OVER(ORDER BY CF1.CUSTODYCD||A.RECUSTODYCD)-1,' ') FULLNAME,
            CF1.CUSTODYCD||LPAD(' ',DENSE_RANK() OVER(ORDER BY CF1.CUSTODYCD||A.RECUSTODYCD)-1,' ') CUSTODYCD,
            A.SYMBOL,
            CF1.IDCODE||LPAD(' ',DENSE_RANK() OVER(ORDER BY CF1.CUSTODYCD||A.RECUSTODYCD)-1,' ') ÐKSH,
            CF1.IDDATE||LPAD(' ',DENSE_RANK() OVER(ORDER BY CF1.CUSTODYCD||A.RECUSTODYCD)-1,' ') NGAY_CAP,
            A.RECUSTODYCD||LPAD(' ',DENSE_RANK() OVER(ORDER BY CF1.CUSTODYCD||A.RECUSTODYCD)-1,' ') RECUSTODYCD,
            A.RECUSTNAME RECUSTNAME,
            QTTY,
            CAQTTY,
            LOAI_CK,
            SAN_GD,
            DENSE_RANK() OVER(ORDER BY CF1.CUSTODYCD||A.RECUSTODYCD) AS NO
FROM (
    SELECT
            --FULLNAME||LPAD(' ',DENSE_RANK() OVER(ORDER BY CUSTODYCD||RECUSTODYCD)-1,' ') FULLNAME,
            --CUSTODYCD||LPAD(' ',DENSE_RANK() OVER(ORDER BY CUSTODYCD||RECUSTODYCD)-1,' ') CUSTODYCD,
            SYMBOL,CUSTODYCD,RECUSTODYCD,
            --IDCODE||LPAD(' ',DENSE_RANK() OVER(ORDER BY CUSTODYCD||RECUSTODYCD)-1,' ') ÐKSH,
            --IDDATE||LPAD(' ',DENSE_RANK() OVER(ORDER BY CUSTODYCD||RECUSTODYCD)-1,' ') NGAY_CAP,
            --RECUSTODYCD||LPAD(' ',DENSE_RANK() OVER(ORDER BY CUSTODYCD||RECUSTODYCD)-1,' ') RECUSTODYCD,
            RECUSTNAME,
            SUM(TRADE)+SUM(BLOCKED) QTTY,
            SUM(CAQTTY) CAQTTY,
            LOAI_CK,
            SAN_GD,
            DENSE_RANK() OVER(ORDER BY CUSTODYCD||RECUSTODYCD) AS NO
    FROM(
            SELECT  CF.FULLNAME ,
                    CF.CUSTODYCD,
                    SB2.SYMBOL SYMBOL,
                    (CASE WHEN SUBSTR(NVL(CF.CUSTODYCD ,''),4,1)='F' THEN  CF.TRADINGCODE ELSE TO_CHAR(NVL(CF.IDCODE,'')) END) IDCODE,
                    TO_CHAR(CASE WHEN SUBSTR(NVL(CF.CUSTODYCD ,''),4,1)='F' THEN  CF.TRADINGCODEDT ELSE TO_DATE(NVL(CF.IDDATE,'')) END,'DD/MM/RRRR') IDDATE,
                    OU.RECUSTODYCD,
                    OU.RECUSTNAME,
                    TRADE + STRADE  + CTRADE  TRADE,
                    BLOCKED + SBLOCKED + CBLOCKED BLOCKED,
                    CAQTTY + SCAQTTY + CCAQTTY CAQTTY,
                   CASE WHEN SB.REFCODEID IS NULL THEN  '(1)' ELSE '(7)'END LOAI_CK,
                (CASE WHEN  NVL(SB2.TRADEPLACE,'') = '010' AND SB2.SECTYPE IN ('003','006','222','333','444') THEN 'BOND'
                      ELSE
                          (CASE
                                WHEN SB2.TRADEPLACE='002' THEN 'HNX'
                                WHEN SB2.TRADEPLACE='001' THEN 'HOSE'
                                WHEN SB2.TRADEPLACE='005' THEN 'UPCOM'
                                WHEN SB2.TRADEPLACE='003' THEN 'OTC'
                                WHEN SB2.TRADEPLACE='009' THEN 'DCCNY'
                                ELSE 'UPCOM' END)
                          END
                ) SAN_GD
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

            SELECT
                CF.FULLNAME FULLNAME,
                CF.CUSTODYCD CUSTODYCD,
                SB.SYMBOL,
                (CASE WHEN SUBSTR(NVL(CF.CUSTODYCD ,''),4,1)='F' THEN  CF.TRADINGCODE ELSE TO_CHAR(NVL(CF.IDCODE,'')) END) IDCODE,
                TO_CHAR(CASE WHEN SUBSTR(NVL(CF.CUSTODYCD ,''),4,1)='F' THEN  CF.TRADINGCODEDT ELSE TO_DATE(NVL(CF.IDDATE,'')) END,'DD/MM/RRRR') IDDATE,
                NVL(TL.SO_TKLK_NHAN,'') RECUSTODYCD,
                NVL(TL.TEN_NGUOI_NHAN,'') RECUSTNAME,
                NVL(TL.MSGAMT,0) TRADE,
                0 BLOCKED,
                NVL(TL.QTTY_CA,0) CAQTTY,
                NVL(TL.TYPE,NULL) LOAI_CK,
                (CASE WHEN  NVL(SB2.TRADEPLACE,'') = '010' AND SB2.SECTYPE IN ('003','006','222','333','444') THEN 'BOND'
                      ELSE
                          (CASE
                                WHEN SB2.TRADEPLACE='002' THEN 'HNX'
                                WHEN SB2.TRADEPLACE='001' THEN 'HOSE'
                                WHEN SB2.TRADEPLACE='005' THEN 'UPCOM'
                                WHEN SB2.TRADEPLACE='003' THEN 'OTC'
                                WHEN SB2.TRADEPLACE='009' THEN 'DCCNY'
                                ELSE 'UPCOM' END)
                          END
                ) SAN_GD
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
                     AFMAST AF, CFMAST CF, SBSECURITIES SB,SBSECURITIES SB2, SECURITIES_INFO SE, DEPOSIT_MEMBER MB
             WHERE  TL.ACCTNO = AF.ACCTNO
                     AND AF.CUSTID = CF.CUSTID
                     --AND AF.ACTYPE NOT IN ('0000')
                     AND SE.CODEID = SB.CODEID
                     AND TL.CODEID = SB.CODEID
                     AND NVL(SB.REFCODEID,SB.CODEID) = SB2.CODEID
                     AND SB.TRADEPLACE IN ('001', '002', '005')
                     AND CF.CUSTODYCD LIKE V_CUSTODYCD
                     AND TL.MA_TVLK_NHAN = MB.DEPOSITID(+)

    )
    GROUP BY CUSTODYCD,SYMBOL,RECUSTODYCD,RECUSTNAME,LOAI_CK,SAN_GD

)A,VW_CFMAST_M CF1--,VW_CFMAST_M CF2
WHERE A.CUSTODYCD=CF1.custodycd_org
--AND A.RECUSTODYCD= CF2.custodycd_org (+)
ORDER BY CF1.CUSTODYCD
    ;
EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('SE00361 ERROR');
   PLOG.ERROR('SE00361: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
