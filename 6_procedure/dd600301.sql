SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd600301(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /*Ma AMC */
   PV_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   P_CLIENTGR             IN       VARCHAR2  /*Loai KH 1,2,3,ALL */
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- du.phan    23-10-2019           created

    v_FromDate          date;
    v_ToDate            date;
    V_AMC           VARCHAR2(20);
    V_CUSTODYCD     VARCHAR2(20);
    V_AMT_A             NUMBER;
    V_AMT_B             NUMBER;
    V_AMT_C             NUMBER;

    v_varvalue           varchar2(10);
BEGIN
     ----
     IF UPPER(P_AMCCODE) = 'ALL' THEN
        V_AMC := '%';
     ELSE
        V_AMC:= UPPER(P_AMCCODE);
     END IF;
     ----
     V_CUSTODYCD:= REPLACE(PV_CUSTODYCD,'.','');
     IF UPPER(V_CUSTODYCD) = 'ALL' THEN
        V_CUSTODYCD := '%';
     ELSE
        V_CUSTODYCD:= UPPER(V_CUSTODYCD);
     END IF;

    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    SELECT VARVALUE INTO V_VARVALUE FROM SYSVAR WHERE VARNAME = 'DEALINGCUSTODYCD';

--------------------------------------------------------------------------------
/*
with tpmSedByACCTNO as (
    Select sd.acctno,  sum(sd.qtty) QTTY, sum (sd.amt) AMT
    from (SELECT DISTINCT acctno,QTTY,AMT,txdate,DAYS FROM sedepobal_report) sd, semast se, cfmast cf,(select * from famembers where roles ='AMC')fa
    where sd.acctno = se.acctno
            and se.custid= cf. custid
            and cf.custatcom ='Y'
            and cf.amcid = fa.autoid(+)
            and cf.custodycd like V_CUSTODYCD
            and nvl(fa.shortname,'%') like V_AMC
            and sd.txdate >=v_FromDate and sd.txdate<=v_ToDate
            AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
    Group by sd.acctno
),tmpSED_A as (
    Select cf.cifid, cf.fullname, decode(cf.IDTYPE,'009',decode(substr(cf.custodycd,0,4),v_varvalue,'P','F'),decode(substr(cf.custodycd,0,4),v_varvalue,'P','D')) cfType, sb.sectype, sed.acctno, sed.qtty, sed.amt
    from tpmSedByACCTNO sed
    inner join semast se on se.acctno = sed.acctno
    inner join afmast af on se.afacctno = af.ACCTNO
    inner join cfmast cf on af.custid= cf.custid
        AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                  WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                  WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                  WHEN P_CLIENTGR = 'ALL' THEN 1
                  ELSE 0 END) = 1
    inner join SBSECURITIES sb on se.codeid=sb.codeid
    where sb.sectype in ('001','002','011','008') --CP,CCQ, CW DAM BAO
        and sb.tradeplace in ('001','002','005','010','003','006')--TriBui 03/07/2020 San HOSE,HNX,UPCOM,BOND
        and (case when sb.tradeplace <> '003' then 1
                when sb.tradeplace = '003' and sb.ISSEDEPOFEE='Y' THEN 1
                else 0 end)=1
        and sb.DEPOSITORY='001' --Thoai.tran SHBVNEX-1270 SHBVNEX-1268 020004: Custody place = "Depository center"
),tmpSED_B as (
    Select cf.cifid, cf.fullname, decode(cf.IDTYPE,'009',decode(substr(cf.custodycd,0,4),v_varvalue,'P','F'),decode(substr(cf.custodycd,0,4),v_varvalue,'P','D')) cfType, sb.sectype, sed.acctno, sed.qtty, sed.amt
    from tpmSedByACCTNO sed
    inner join semast se on se.acctno = sed.acctno
    inner join afmast af on se.afacctno = af.ACCTNO
    inner join cfmast cf on af.custid= cf.custid
        AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
    inner join SBSECURITIES sb on se.codeid=sb.codeid
    where sb.sectype in ('003','006') --TRAI PHIEU
        and sb.tradeplace in ('001','002','005','010','003','006')--TriBui 03/07/2020 San HOSE,HNX,UPCOM,BOND
        and (case when sb.tradeplace <> '003' then 1
                when sb.tradeplace = '003' and sb.ISSEDEPOFEE='Y' THEN 1
                else 0 end)=1
        and sb.DEPOSITORY='001' --Thoai.tran SHBVNEX-1270 SHBVNEX-1268 020004: Custody place = "Depository center"
),tmpSED_C as (
    Select cf.cifid, cf.fullname, decode(cf.IDTYPE,'009',decode(substr(cf.custodycd,0,4),v_varvalue,'P','F'),decode(substr(cf.custodycd,0,4),v_varvalue,'P','D')) cfType, sb.sectype, sed.acctno, sed.qtty, sed.amt
    from tpmSedByACCTNO sed
    inner join semast se on se.acctno = sed.acctno
    inner join afmast af on se.afacctno = af.ACCTNO
    inner join cfmast cf on af.custid= cf.custid
        AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                  WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                  WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                  WHEN P_CLIENTGR = 'ALL' THEN 1
                  ELSE 0 END) = 1
    inner join SBSECURITIES sb on se.codeid=sb.codeid
    where sb.sectype in ('012') --TINH PHIEU
        and sb.tradeplace in ('001','002','005','010','003','006')--TriBui 03/07/2020 San HOSE,HNX,UPCOM,BOND
        and (case when sb.tradeplace <> '003' then 1
                when sb.tradeplace = '003' and sb.ISSEDEPOFEE='Y' THEN 1
                else 0 end)=1
        and sb.DEPOSITORY='001' --Thoai.tran SHBVNEX-1270 SHBVNEX-1268 020004: Custody place = "Depository center"
),tmpFeeVSD as (
    Select cifid,fullname, cfType,  qtty qttyA, 0 qttyB, 0 qttyC, amt,'A'sec
    from tmpSED_A
    union all
    Select cifid,fullname, cfType, 0 qttyA, qtty qttyB, 0 qttyC, amt, 'B'sec
    from tmpSED_B
    union all
    Select cifid,fullname, cfType, 0 qttyA, 0 qttyB, qtty qttyC, amt, 'C'sec
    from tmpSED_C
)
select         max(a),max(b),max(nvl(c,0))
               INTO V_AMT_A,V_AMT_B,V_AMT_C
from
(
        select
                sec,
                case when sec='A' then amt else 0 end a,
                case when sec='B' then amt else 0 end b,
                case when sec='C' then amt else 0 end c,
        from
        (
            select sec, sum(amt) amt
            from tmpFeeVSD
            group by sec
        )
);
*/
OPEN PV_REFCURSOR FOR
WITH TPMSEDBYACCTNO AS (
        SELECT SD.ACCTNO, SD.TXDATE, SUM(SD.QTTY) QTTY, SUM(SD.AMT) AMT
        FROM (
            SELECT DISTINCT ACCTNO, QTTY, AMT, TXDATE, DAYS
            FROM SEDEPOBAL_REPORT
        ) SD
        WHERE SD.TXDATE >= V_FROMDATE
        AND SD.TXDATE <= V_TODATE
        AND QTTY > 0
        AND AMT > 0
        GROUP BY SD.ACCTNO, SD.TXDATE
    ),
    TMPSED_A as (
        SELECT SED.QTTY, SED.AMT, SED.TXDATE,
            DECODE(CF.IDTYPE,'009',DECODE(SUBSTR(CF.CUSTODYCD,0,4),V_VARVALUE,'P','F'),DECODE(SUBSTR(CF.CUSTODYCD,0,4),V_VARVALUE,'P','D')) CFTYPE
        FROM TPMSEDBYACCTNO SED
        INNER JOIN SEMAST SE ON SE.ACCTNO = SED.ACCTNO
        INNER JOIN CFMAST CF ON SE.CUSTID = CF.CUSTID
            AND NVL(CF.CUSTODYCD,'%') LIKE V_CUSTODYCD
            AND CF.CUSTATCOM = 'Y'
            AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                  WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                  WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                  WHEN P_CLIENTGR = 'ALL' THEN 1
                  ELSE 0 END) = 1
        INNER JOIN SBSECURITIES SB ON SE.CODEID = SB.CODEID
            AND SB.SECTYPE IN ('001','002','011','008') --CP,CCQ, CW DAM BAO
            AND SB.TRADEPLACE IN ('001','002','005','010','003','006')
            AND (CASE WHEN SB.TRADEPLACE <> '003' THEN 1
                  WHEN SB.TRADEPLACE = '003' AND SB.ISSEDEPOFEE = 'Y' THEN 1
                  ELSE 0 END) = 1
            AND SB.DEPOSITORY = '001' --Thoai.tran SHBVNEX-1270 SHBVNEX-1268 020004: Custody place = "Depository center"
        LEFT JOIN FAMEMBERS FA ON FA.AUTOID = CF.AMCID AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
    ),
    TMPSED_B as (
        SELECT SED.QTTY, SED.AMT, SED.TXDATE,
            DECODE(CF.IDTYPE,'009',DECODE(SUBSTR(CF.CUSTODYCD,0,4),V_VARVALUE,'P','F'),DECODE(SUBSTR(CF.CUSTODYCD,0,4),V_VARVALUE,'P','D')) CFTYPE
        FROM TPMSEDBYACCTNO SED
        INNER JOIN SEMAST SE ON SE.ACCTNO = SED.ACCTNO
        INNER JOIN AFMAST AF ON SE.AFACCTNO = AF.ACCTNO
        INNER JOIN CFMAST CF ON AF.CUSTID = CF.CUSTID
            AND NVL(CF.CUSTODYCD,'%') LIKE V_CUSTODYCD
            AND CF.CUSTATCOM = 'Y'
            AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
        INNER JOIN SBSECURITIES SB ON SE.CODEID = SB.CODEID
            AND SB.SECTYPE IN ('003','006') --TRAI PHIEU
            AND SB.TRADEPLACE IN ('001','002','005','010','003','006','099')
            AND (CASE WHEN SB.TRADEPLACE <> '003' THEN 1
                      WHEN SB.TRADEPLACE = '003' AND SB.ISSEDEPOFEE = 'Y' THEN 1
                      ELSE 0 END) = 1
            AND SB.DEPOSITORY = '001' --Thoai.tran SHBVNEX-1270 SHBVNEX-1268 020004: Custody place = "Depository center"
        LEFT JOIN FAMEMBERS FA ON FA.AUTOID = CF.AMCID AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
    ),
    TMPSED_C as (
        SELECT SED.QTTY, SED.AMT, SED.TXDATE,
            DECODE(CF.IDTYPE,'009',DECODE(SUBSTR(CF.CUSTODYCD,0,4),V_VARVALUE,'P','F'),DECODE(SUBSTR(CF.CUSTODYCD,0,4),V_VARVALUE,'P','D')) CFTYPE
        FROM TPMSEDBYACCTNO SED
        INNER JOIN SEMAST SE ON SE.ACCTNO = SED.ACCTNO
        INNER JOIN AFMAST AF ON SE.AFACCTNO = AF.ACCTNO
        INNER JOIN CFMAST CF ON AF.CUSTID = CF.CUSTID
            AND NVL(CF.CUSTODYCD,'%') LIKE V_CUSTODYCD
            AND CF.CUSTATCOM = 'Y'
            AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
        INNER JOIN SBSECURITIES SB ON SE.CODEID = SB.CODEID
            AND SB.SECTYPE IN ('012') --TINH PHIEU
            AND SB.TRADEPLACE IN ('001','002','005','010','003','006')
            AND (CASE WHEN SB.TRADEPLACE <> '003' THEN 1
                  WHEN SB.TRADEPLACE = '003' AND SB.ISSEDEPOFEE = 'Y' THEN 1
                  ELSE 0 END) = 1
            AND SB.DEPOSITORY = '001' --THOAI.TRAN SHBVNEX-1270 SHBVNEX-1268 020004: Custody place = "Depository center"
        LEFT JOIN FAMEMBERS FA ON FA.AUTOID = CF.AMCID AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
    ),
    TMPFEEVSD as (
        SELECT CFTYPE,  QTTY QTTYA, 0 QTTYB, 0 QTTYC, AMT, 'A' SEC, TXDATE
        FROM TMPSED_A
        UNION ALL
        SELECT CFTYPE, 0 QTTYA, QTTY QTTYB, 0 QTTYC, AMT, 'B' SEC, TXDATE
        FROM TMPSED_B
        UNION ALL
        SELECT CFTYPE, 0 QTTYA, 0 QTTYB, QTTY QTTYC, AMT, 'C' SEC, TXDATE
        FROM TMPSED_C
    ),
    TMPGROUPFEEVSD as (
        SELECT CFTYPE,
            SUM(NVL(QTTYA,0)) QTTYA,
            SUM(NVL(QTTYB,0)) QTTYB,
            SUM(NVL(QTTYC,0)) QTTYC,
            SUM(DECODE(SEC,'A',AMT,0)) AMTA,
            SUM(DECODE(SEC,'B',AMT,0)) AMTB,
            SUM(DECODE(SEC,'C',AMT,0)) AMTC
        FROM TMPFEEVSD
        GROUP BY CFTYPE
    ),
    TMPNAMEOFACCOUNT as (
        Select 'Domestic investors'  NAMEOFACCOUNT, 'D' CFTYPE, 1 LSTODR from dual
        union all
        Select 'Foreign investors' NAMEOFACCOUNT, 'F' CFTYPE, 2 LSTODR from dual
        union all
        Select 'Proprietary trading'  NAMEOFACCOUNT, 'P' CFTYPE, 3 LSTODR  from dual
    )
    SELECT  NFA.NAMEOFACCOUNT,
        NVL(FEE.QTTYA,0) QTTYA,
        NVL(FEE.QTTYB,0) QTTYB,
        NVL(FEE.QTTYC,0) QTTYC,
        ROUND(NVL(FEE.AMTA,0),2) AMTA,
        ROUND(NVL(FEE.AMTB,0),2) AMTB,
        ROUND(NVL(FEE.AMTC,0),2) AMTC,
        '' NOTE
    FROM TMPNAMEOFACCOUNT NFA
    LEFT JOIN TMPGROUPFEEVSD FEE ON FEE.CFTYPE=NFA.CFTYPE
    ORDER BY LSTODR;

EXCEPTION WHEN OTHERS THEN
    plog.error ('DD600301: ' || SQLERRM || dbms_utility.format_error_backtrace);
    Return;
End;
/
