SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE OD6031(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,

   I_DATE                 IN       VARCHAR2, /*NGAY BAO CAO */
   PV_CUSTODYCD              IN       VARCHAR2, /* TKLK */
   PV_AMC                IN       VARCHAR2, /*AMC */
   PV_GCB             IN       VARCHAR2 /*GCB */
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- TRI.BUI     07/07/2020           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
--
    V_IDATE            DATE;
    V_CURRDATE          DATE;
    V_CUSTODYCD         VARCHAR2(20);
    V_AMC            VARCHAR2(50);
    V_GCB          VARCHAR2(200);


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
     V_CURRDATE   := GETCURRDATE;
     V_IDATE  := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
     V_CUSTODYCD := REPLACE(PV_CUSTODYCD,'.','');
    ------------------------------------
    IF UPPER(V_CUSTODYCD)='ALL' THEN
        V_CUSTODYCD:='%';
    ELSE
    V_CUSTODYCD:=V_CUSTODYCD;
    END IF;
    ------------------------------------
    IF UPPER(PV_AMC)='ALL' THEN
        V_AMC:='%';
    ELSE
        V_AMC:=PV_AMC;
    END IF;
    ------------------------------------
    IF UPPER(PV_GCB) ='ALL' THEN
        V_GCB:='%';
    ELSE
        V_GCB:=PV_GCB;
    END IF;
    ------------------------------------------------------------------------------------------------------------------------------------

    OPEN PV_REFCURSOR FOR
        SELECT *
        FROM (
            SELECT
                   CF.FULLNAME
                 , CT.CURRENCY
                 , CT.BALANCE
                 , CT.LEDGER
                 , CASE
                        WHEN SUBSTR(REGEXP_REPLACE(CT.REFCASAACCT,'(...)','\1-'),LENGTH(REGEXP_REPLACE(CT.REFCASAACCT,'(...)','\1-')),1)='-' THEN
                             SUBSTR(REGEXP_REPLACE(CT.REFCASAACCT,'(...)','\1-'),1,LENGTH(REGEXP_REPLACE(CT.REFCASAACCT,'(...)','\1-'))-1)
                        ELSE REGEXP_REPLACE(CT.REFCASAACCT,'(...)','\1-')
                   END REFCASAACCT
                 , TO_CHAR(V_IDATE,'DD/MM/RRRR') AS DATETIME
            FROM (
                    SELECT TM.CUSTID
                         , TM.REFCASAACCT
                         , TM.ACCOUNTTYPE
                         , TM.CURRENCY
                         , NVL(TM.BALANCE,0) BALANCE
                         , NVL(TM.LEDGER,0) LEDGER
                    FROM
                        ( --BANG TEMP TIEN MAT
                           SELECT DD.CUSTID
                                , DD.ACCOUNTTYPE
                                , DD.CCYCD CURRENCY
                                , DD.REFCASAACCT
                                , CASE WHEN DD.CCYCD ='VND' THEN ROUND((DD.BALANCE - NVL(A_TR.A_NAMT,0))) ELSE ROUND((DD.BALANCE - NVL(A_TR.A_NAMT,0)) ,2)END BALANCE
                                , CASE WHEN DD.CCYCD ='VND' THEN ROUND((DD.BALANCE + DD.HOLDBALANCE +DD.PENDINGUNHOLD  - NVL(L_TR.L_NAMT,0))) ELSE ROUND((DD.BALANCE + DD.HOLDBALANCE - NVL(L_TR.L_NAMT,0)) ,2)END LEDGER
                           FROM DDMAST DD
                           LEFT JOIN (
                                    SELECT ACCTNO, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) A_NAMT
                                    FROM VW_DDTRAN_GEN
                                    WHERE FIELD IN ('BALANCE') AND BUSDATE > V_IDATE
                                    GROUP BY ACCTNO
                                     ) A_TR ON DD.ACCTNO = A_TR.ACCTNO
                           LEFT JOIN (
                                     SELECT ACCTNO, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) L_NAMT
                                     FROM VW_DDTRAN_GEN
                                     WHERE FIELD IN ('BALANCE','HOLDBALANCE','PENDINGUNHOLD') AND BUSDATE > V_IDATE
                                     GROUP BY ACCTNO
                                     ) L_TR ON DD.ACCTNO = L_TR.ACCTNO

                        ) TM
                    --WHERE TM.BALANCE <> 0 AND TM.LEDGER <>0
             ) CT
             JOIN CFMAST CF ON CF.CUSTID = CT.CUSTID
                            AND CF.STATUS <> 'C'
                            --AND CF.CUSTATCOM = 'Y' --LUU KY TAI SHINHAN
             LEFT JOIN (SELECT * FROM FAMEMBERS FA WHERE FA.ROLES = 'AMC')AMC ON AMC.AUTOID = CF.AMCID
             LEFT JOIN (SELECT * FROM FAMEMBERS FA WHERE FA.ROLES = 'GCB')GCB ON GCB.AUTOID = CF.GCBID
             WHERE CF.CUSTODYCD LIKE V_CUSTODYCD
                   AND NVL(AMC.SHORTNAME,'X') LIKE V_AMC
                   AND NVL(GCB.SHORTNAME,'X') LIKE V_GCB
            )
            ORDER BY FULLNAME,REFCASAACCT;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('OD6031: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;

End;
/
