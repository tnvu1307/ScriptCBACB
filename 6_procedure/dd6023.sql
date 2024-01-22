SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd6023(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   PV_CUSTODYCD              IN       VARCHAR2
   )
IS
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
--
    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_issuedate         date;
    v_expdate           date;
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
    v_IDCODE           varchar2(200);
    v_OFFICE           varchar2(200);
    v_REFNAME          varchar2(200);
    v_shvstc           varchar2(200);
    v_shvcustodycd     varchar2(200);
    v_shvcifid         varchar2(200);
--
    v_tltitle          varchar2(200);
    v_tlfullname       varchar2(200);
    v_ExchangeRate     number;
    v_AMCCODE          varchar2(20);
    V_CIFID            varchar2(200);
BEGIN
     V_STROPTION := OPT;
     v_CurrDate   := getcurrdate;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;
------------------------------------RIT-----------------------------------------
    v_CustodyCD:=Replace(PV_CUSTODYCD,'.','');
--------------------------------------------------------------------------------
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    BEGIN
        SELECT EA.VND INTO V_EXCHANGERATE
        FROM EXCHANGERATE_ORTHER EA,
        (
            SELECT CURRENCY, MAX(TRADEDATE) TRADEDATE
            FROM EXCHANGERATE_ORTHER
            WHERE TRADEDATE <= v_ToDate
            AND CURRENCY = 'USD'
            GROUP BY CURRENCY
        )EB
        WHERE EA.CURRENCY = EB.CURRENCY AND EA.TRADEDATE = EB.TRADEDATE;
    EXCEPTION
    WHEN OTHERS THEN
        V_EXCHANGERATE := 1;
        plog.error ('DD6023: '||'TY GIA USD/VND NGAY '||v_FromDate||' KHONG TON TAI!!!');
    END;

------------------------------------------------------------------------------------------------------------------------------------
    OPEN PV_REFCURSOR FOR
    SELECT  distinct 'from '||to_char(v_FromDate,'dd/MM/rrrr') FROMDATE,
            'to '||to_char(v_ToDate,'dd/MM/rrrr') TODATE,
            V_EXCHANGERATE  EXCHANGERATE,
            CF.FULLNAME,
            CF.CIFID CUSTID,
            CF.CUSTODYCD
    FROM (
    select CUSTODYCD, AFACCTNO, SYMBOL,CODEID, BUSDATE,TLTXCD,TXDESC,TXTYPE,REFCASAACCT,CCYCD,
                    CASE WHEN TYPE='CK' THEN CASE WHEN TXTYPE ='C' then QTTY ELSE 0 END ELSE 0 END C_QTTY,
                    CASE WHEN TYPE='CK' THEN CASE WHEN TXTYPE ='C' then NAMT ELSE 0 END ELSE 0 END C_NAMT,
                    CASE WHEN TYPE='CK' THEN CASE WHEN TXTYPE ='C' then 0 ELSE QTTY END ELSE 0 END D_QTTY,
                    CASE WHEN TYPE='CK' THEN CASE WHEN TXTYPE ='C' then 0 ELSE NAMT END ELSE 0 END D_NAMT,
                    CASE WHEN TYPE='DD' THEN CASE WHEN TXTYPE ='C' then NAMT ELSE 0 END ELSE 0 END C_DDNAMT,
                    CASE WHEN TYPE='DD' THEN CASE WHEN TXTYPE ='C' then 0 ELSE NAMT END ELSE 0 END D_DDNAMT,
                    0 TOTAL_VND,
                    0 TOTAL_USD,
                    V_EXCHANGERATE EXCHANGERATE
                    from (
                     select A.*,B.NAMT,'CK' TYPE from (
                    SELECT DISTINCT CUSTODYCD, AFACCTNO,'' REFCASAACCT,'' CCYCD,
                    SYMBOL,CODEID, BUSDATE,TLTXCD,TXDESC,TXTYPE,NAMT QTTY
                     FROM VW_SETRAN_GEN
                     WHERE BUSDATE > v_FromDate AND BUSDATE <= v_ToDate AND
                     FIELD IN ('HOLD','NETTING','BLOCKED','TRADE','WITHDRAW','BLOCKWITHDRAW','MORTAGE')
                     and custodycd=v_CustodyCD
                     )A
                     left join (SELECT * FROM VW_SETRAN_GEN B where  FIELD IN ('DCRAMT'))B
                     ON A.AFACCTNO=B.AFACCTNO and A.CODEID=B.CODEID
                     and A.BUSDATE=B.BUSDATE AND A.TLTXCD=B.TLTXCD AND A.TXTYPE=B.TXTYPE
                     union all
                      --BANG TEMP TR
                         SELECT distinct TR.CUSTODYCD,DD.AFACCTNO,DD.REFCASAACCT,DD.CCYCD,
                         '' SYMBOL,'' CODEID,TR.BUSDATE,TR.TLTXCD,
                         TR.TXDESC,TR.TXTYPE,0 QTTY,NAMT,'DD' TYPE
                         FROM VW_DDTRAN_GEN TR,ddmast dd
                         WHERE TR.FIELD IN ('BALANCE') AND BUSDATE > v_FromDate AND BUSDATE <= v_ToDate
                         and TR.acctno=DD.ACCTNO
                         and dd.custodycd=v_CustodyCD
                         ) ORDER BY BUSDATE
        )A, CFMAST CF,AFMAST AF,DDMAST DD WHERE A.CUSTODYCD=CF.CUSTODYCD AND CF.CUSTID=AF.CUSTID AND DD.AFACCTNO=AF.ACCTNO;
EXCEPTION
WHEN OTHERS THEN
    PLOG.ERROR ('DD6023: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN;

END;
/
