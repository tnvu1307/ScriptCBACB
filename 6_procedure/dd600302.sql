SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE DD600302(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2 /*den ngay */

   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- du.phan    23-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
    v_BRADDRESS         varchar2(200);
    v_BRADDRESS_EN      varchar2(200);
    v_HEADOFFICE        varchar2(200);
    v_HEADOFFICE_EN     varchar2(200);
    v_EMAIL             varchar2(200);
    v_PHONE             varchar2(200);
    v_FAX               varchar2(200);
    v_1IDCODE           varchar2(200);
    v_1OFFICE           varchar2(200);
    v_1REFNAME          varchar2(200);
    v_2IDCODE           varchar2(200);
    v_2OFFICE           varchar2(200);
    v_2REFNAME          varchar2(200);
    v_BUSSINESSID       varchar2(200);
    v_amcid             varchar2(20);
    v_amcFulname        varchar2(200);
    -- Ty le so huu co dong lon
    v_MAJORSHAREHOLDER  number(20,4);
    v_CLEARDAY          number;
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

    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);


OPEN PV_REFCURSOR FOR
    with tpmSedByACCTNO as (
    Select acctno, txdate, sum(qtty) QTTY, sum (amt) AMT
    from sedepobal_report
    where txdate >=v_FromDate and txdate<=v_ToDate
    Group by txdate,acctno
),tmpSED_A as (
    Select cf.cifid, cf.fullname, sb.sectype, sed.acctno,sed.txdate, sed.qtty, sed.amt, 'A' sed_Type
    from tpmSedByACCTNO sed
    inner join semast se on se.acctno = sed.acctno
    inner join afmast af on se.afacctno = af.ACCTNO
    inner join cfmast cf on af.custid= cf.custid
    inner join SBSECURITIES sb on se.codeid=sb.codeid
    where sb.sectype in ('001','002','011','008')
),tmpSED_B as (
    Select cf.cifid, cf.fullname, sb.sectype, sed.acctno,sed.txdate, sed.qtty, sed.amt, 'B' sed_Type
    from tpmSedByACCTNO sed
    inner join semast se on se.acctno = sed.acctno
    inner join afmast af on se.afacctno = af.ACCTNO
    inner join cfmast cf on af.custid= cf.custid
    inner join SBSECURITIES sb on se.codeid=sb.codeid
    where sb.sectype in ('003','006')
),tmpSED_C as (
    Select cf.cifid, cf.fullname, sb.sectype, sed.acctno,sed.txdate, sed.qtty, sed.amt, 'C' sed_Type
    from tpmSedByACCTNO sed
    inner join semast se on se.acctno = sed.acctno
    inner join afmast af on se.afacctno = af.ACCTNO
    inner join cfmast cf on af.custid= cf.custid
    inner join SBSECURITIES sb on se.codeid=sb.codeid
    where sb.sectype in ('012')
),tmpFeeVSD as (
    Select cifid,fullname, txdate, qtty qttyA, 0 qttyB, 0 qttyC, amt, '' Note,sed_Type
    from tmpSED_A
    union all
    Select cifid,fullname,txdate, 0 qttyA, qtty qttyB, 0 qttyC, amt, '' Note,sed_Type
    from tmpSED_B
    union all
    Select cifid,fullname,txdate, 0 qttyA, 0 qttyB, qtty qttyC, amt, '' Note,sed_Type
    from tmpSED_C
)
Select cifid, fullname,txdate,  sum(qttyA) qttyA, sum(qttyB) qttyB, sum(qttyC) qttyC, sum(amt) amt
from tmpFeeVSD
group by cifid,fullname, txdate
order by txdate ;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('DD600302: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
