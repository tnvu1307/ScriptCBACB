SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6037_5 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2, /*den ngay */
   P_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   P_AUTH                IN         VARCHAR2 /* Ng dc uy quyen*/
   )
IS
    -- Giay dang ky ma so giao dich
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- truongld    18-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate     date;
    v_ToDate       date;
    v_CurrDate     date;
    v_strCurrDate  varchar2(20);
    v_CustodyCD    varchar2(20);
BEGIN

   V_STROPTION := OPT;

   v_CurrDate   := getcurrdate;
   select to_char (v_CurrDate, 'DD Mon YYYY') into v_strCurrDate from dual;

    if v_stroption = 'A' then
        v_strbrid := '%';
    elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
    else
        v_strbrid:=brid;
    end if;


    v_CustodyCD := REPLACE(P_CUSTODYCD,'.','');

    /*
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    */

OPEN PV_REFCURSOR FOR

    select cf.custodycd, --so tk luu ky
        cf.fullname, -- ten kh
        cf.tradingcode, -- MSGD
        cf.tradingcodedt, --ngay mo STC
        dd.refcasaacct FIICAccount, -- IICA
        cf.cifid SECAccount, -- so tk ck
        au.fullname,-- ten nguoi nhan dc uy quyen
        au.licenseno, --cmnd ng nhan dc uy quyen
        au.telephone, -- sdt cua ng nhan dc uy quyen
        v_strCurrDate VALUEDATE
    from cfmast cf, ddmast dd, cfauth au
    where dd.custid = cf.custid
    and dd.accounttype='IICA'
    and cf.custid = au.cfcustid
    and au.licenseno = P_AUTH
    and cf.custodycd = v_CustodyCD;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6037_5: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
