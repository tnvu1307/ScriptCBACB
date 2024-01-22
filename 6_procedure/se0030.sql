SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0030 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PLSENT         IN       VARCHAR2
       )
IS

-- RP NAME : YEU CAU CHUYEN KHOAN CHUNG KHOAN -- GIAO DICH LO LE LAY THEO GD 8815
-- PERSON : QUYET.KIEU
-- DATE : 11/02/2011
-- COMMENTS : CREATE NEW
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_TYPE  VARCHAR2(10);

   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);
   V_COUNT NUMBER;

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
   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;

/*
   IF  (LOWER(PV_TYPE) = 'tat toan')

   THEN
         V_TYPE := '2247' ;
   ELSE
         V_TYPE := '8815' ;
   END IF;
*/

   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%';
   END IF;

    --CHECK DA LAM 8815 CHUA

    /*select count(*) into  V_COUNT from vw_tllog_all where txdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
         AND txdate <= TO_DATE (T_DATE,'DD/MM/YYYY')
         and tltxcd='8815'
         and cfcustodycd like V_CUSTODYCD
         and  substr(msgacct,1,10) like V_STRAFACCTNO;


-- GET REPORT'S DATA


/*IF V_COUNT=0 THEN
    OPEN PV_REFCURSOR
    FOR
        SELECT * FROM dual  where dummy='EMPTY';

ELSE*/
    OPEN PV_REFCURSOR
    FOR

     SELECT PLSENT  PL_SENT,
        (CASE WHEN SB.TRADEPLACE='002' THEN 'HNX'
              WHEN SB.TRADEPLACE='001' THEN 'HOSE'
              WHEN SB.TRADEPLACE='005' THEN 'UPCOM'
              WHEN SB.TRADEPLACE='010' THEN 'BOND'
              ELSE ''
         END) ORDERID,
         NVL(SB.SYMBOL,'') CODEID,
         NVL(SB.PARVALUE ,'') MENH_GIA,
         SUM(NVL(TL.MSGAMT,'')) SL_LOLE,
         CF.CUSTODYCD  AFACCTNO,
         V_INBRID BRID,
         CF.FULLNAME,
         CF1.FULLNAME RECEIVER_NAME,
         CASE WHEN CF1.CUSTODYCD IN ('SHVACA4669') THEN 'SHVA000001' ELSE CF1.CUSTODYCD END CUSTODYCD
      FROM   (
             SELECT A.TXDATE,
                    A.TXNUM,
                    A.CUST_ID,
                    SUBSTR(A.MSGACCT,1,10) ACCTNO,
                    SUBSTR(A.MSGACCT,11,6) CODEID,
                    A.MSGACCT,
                    A.MSGAMT
             FROM (
                    SELECT TO_DATE(N_DATE,'DDMMRRRR') N_DATE,
                           CUST_ID,
                           N_NUM,
                           TLTXCD,
                           MSGACCT,
                           MSGAMT,
                           COUNT(*) N,
                           MAX(TXDATE) TXDATE,
                           MAX(TXNUM) TXNUM
                    FROM (
                          SELECT TL.AUTOID, TL.TXNUM, TL.TXDATE, TL.TXTIME , TL.TLTXCD, TL.MSGACCT ,TL.MSGAMT,
                                 MAX(CASE WHEN FLD.FLDCD = '04' THEN FLD.CVALUE ELSE '0' END) N_DATE,
                                 MAX(CASE WHEN FLD.FLDCD = '05' THEN FLD.CVALUE ELSE '0' END) N_NUM,
                                 MAX(DECODE(FLD.FLDCD,'07',FLD.CVALUE,NULL)) CUST_ID
                          FROM VW_TLLOG_ALL TL, VW_TLLOGFLD_ALL FLD, SBSECURITIES SB
                          WHERE TLTXCD IN ('8815') AND
                                DELTD <> 'Y' AND
                                FLD.TXDATE = TL.TXDATE AND
                                FLD.TXNUM = TL.TXNUM AND
                                FLD.FLDCD IN ('04','05','07')
                          GROUP BY TL.AUTOID, TL.TXNUM, TL.TXDATE, TL.TXTIME , TL.TLTXCD, TL.MSGACCT, TL.MSGAMT
                          ORDER BY TXDATE, TXNUM, TXTIME
                         )
                    GROUP BY N_DATE, N_NUM, TLTXCD, MSGACCT, MSGAMT, CUST_ID
                    ) A
                    LEFT JOIN (
                                SELECT TO_DATE(N_DATE,'DDMMRRRR') N_DATE,
                                       CUST_ID,
                                       N_NUM,
                                       TLTXCD,
                                       MSGACCT,
                                       MSGAMT,
                                       COUNT(*) N,
                                       MAX(TXDATE) TXDATE,
                                       MAX(TXNUM) TXNUM
                                FROM (
                                        SELECT TL.AUTOID, TL.TXNUM, TL.TXDATE, TL.TXTIME , TL.TLTXCD, TL.MSGACCT ,TL.MSGAMT,
                                              MAX(CASE WHEN FLD.FLDCD = '04' THEN FLD.CVALUE ELSE '0' END) N_DATE,
                                              MAX(CASE WHEN FLD.FLDCD = '05' THEN FLD.CVALUE ELSE '0' END) N_NUM,
                                              MAX(DECODE(FLD.FLDCD,'07',FLD.CVALUE,NULL)) CUST_ID
                                        FROM VW_TLLOG_ALL TL, VW_TLLOGFLD_ALL FLD
                                        WHERE TLTXCD IN ('8816') AND
                                              DELTD <> 'Y' AND
                                              FLD.TXDATE = TL.TXDATE AND
                                              FLD.TXNUM = TL.TXNUM AND
                                              FLD.FLDCD IN ('04','05','07')
                                        GROUP BY TL.AUTOID, TL.TXNUM, TL.TXDATE, TL.TXTIME , TL.TLTXCD, TL.MSGACCT, TL.MSGAMT
                                        ORDER BY TXDATE, TXNUM, TXTIME
                                     )
                                GROUP BY N_DATE, N_NUM, TLTXCD, MSGACCT, MSGAMT, CUST_ID
                              ) B ON A.N_DATE = B.N_DATE AND A.N_NUM = B.N_NUM
                    WHERE A.N > NVL(B.N,0)
             ) TL,
             AFMAST AF,
             CFMAST CF,
             CFMAST CF1,
             SBSECURITIES SB,
             SECURITIES_INFO SE
     WHERE TL.ACCTNO = AF.ACCTNO
             AND AF.CUSTID = CF.CUSTID
             AND SE.CODEID = SB.CODEID
             AND TL.CODEID = SB.CODEID
             AND TL.TXDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
             AND TL.TXDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
             AND SB.TRADEPLACE IN ('001', '002', '005')
             AND CF.CUSTODYCD LIKE V_CUSTODYCD
             AND TL.ACCTNO LIKE V_STRAFACCTNO
             AND (AF.BRID LIKE V_STRBRID OR INSTR(V_STRBRID,AF.BRID) <> 0 )
             AND CF1.CUSTID = TL.CUST_ID
    GROUP BY (CASE WHEN SB.TRADEPLACE='002' THEN 'HNX'
             WHEN SB.TRADEPLACE='001' THEN 'HOSE'
             WHEN SB.TRADEPLACE='005' THEN 'UPCOM'
             WHEN SB.TRADEPLACE='010' THEN 'BOND'
             ELSE ''END) ,
             CF.FULLNAME,
             CF.CUSTODYCD,
             NVL(SB.SYMBOL,''),
             NVL(SB.PARVALUE ,''),
             CF1.FULLNAME,
             CASE WHEN CF1.CUSTODYCD IN ('SHVACA4669') THEN 'SHVA000001' ELSE CF1.CUSTODYCD END;


EXCEPTION

   WHEN OTHERS
   THEN
      RETURN;

END;
/
