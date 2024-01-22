SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE OD6010 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   PV_SYMBOL              IN       VARCHAR2, /*Ma chung khoan*/
   PV_CUSTODYCD           IN       VARCHAR2  /*So TK Luu ky */

   )
IS
    -- Bao cao thong ke danh muc luu ky cua nha dau tu nuoc ngoai
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY      24-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
    v_FromDate           date;
    v_ToDate             date;
    v_TLIdChecker      varchar2(50);
    v_TLIdOfficer      varchar2(50);
BEGIN
    V_STROPTION := OPT;
    if V_STROPTION = 'A' then
        V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        V_STRBRID := substr(BRID,1,2) || '__' ;
    else
        V_STRBRID:= BRID;
    end if;

    v_FromDate      :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate        :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    v_CustodyCD := REPLACE(PV_CUSTODYCD,'.','');

OPEN PV_REFCURSOR FOR
        select -- Thong tin HSV
           mst.CUSTODYCD,
           mst.FULLNAME, --Ten KH
           mst.ISSFULLNAME, --Ten CTY CK
           mst.TXDATE, --Ngay GD
           mst.SECNAME, --Ten CK
           mst.SYMBOL, --Ma CK
           SUM(mst.ENDQTTY) ENDQTTY--SLCK
    from
    (
        select tr.custodycd CUSTODYCD,
               cf.fullname FULLNAME, --Ten khach hang, dua vao CUSTODYCD
               --fa.fullname SECNAME, --Ten CT CK
               sb1.issfullname ISSFULLNAME, --Ten CTY chung khoan, dua vao symbol
               tr.txdate TXDATE, --Ngay giao dich
               sb.issfullname SECNAME, --Ten chung khoan
               sb.symbol SYMBOL, --Ma chung khoan
               se.trade - nvl(tr.namt,0) ENDQTTY -- KL CK cuoi ngay from date
        from cfmast cf, semast se, --famembers fa,
            (
                select  sb.codeid,
                       sb.symbol,
                       iss.fullname issfullname -- Ten TCPH
                from issuers iss, sbsecurities sb, allcode a1
                where iss.issuerid = sb.issuerid
                      and sb.tradeplace = a1.cdval and a1.cdname='EXCHANGES'
            )sb,
            (
                select  sb.codeid,
                       sb.symbol,
                       iss.fullname issfullname -- Ten TCPH
                from issuers iss, sbsecurities sb, allcode a1
                where iss.issuerid = sb.issuerid
                      and sb.tradeplace = a1.cdval and a1.cdname='EXCHANGES'
            )sb1,
            -- Phat sinh tu from date
            (
                select custodycd, acctno, symbol, sum(case when  txtype='C' then namt else -namt end) namt, txdate
                from vw_setran_gen
                where txdate between v_FromDate and v_ToDate
                      and field in ('TRADE')
                group by custodycd, acctno, symbol, txdate
            )tr
        where cf.custid = se.custid
              and se.codeid = sb.codeid
              and se.acctno = tr.acctno (+)
              --and cf.amcid = fa.autoid
              and cf.custodycd = tr.custodycd
              and sb1.symbol = PV_SYMBOL
              and cf.custodycd = v_CustodyCD
              and sb.symbol = PV_SYMBOL
    )mst
    group by mst.CUSTODYCD, mst.FULLNAME, mst.ISSFULLNAME, mst.TXDATE, mst.SECNAME, mst.SYMBOL ,mst.TXDATE
    order by mst.TXDATE ASC;

EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('OD6010 ERROR');
   
      RETURN;
END;
/
