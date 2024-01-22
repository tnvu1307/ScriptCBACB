SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6043 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2, /*den ngay */
   P_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   P_BRKID                IN         VARCHAR2 /* Ng dc uy quyen*/
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
        cf.cifid SECAccount, -- so tk ck
        v_strCurrDate VALUEDATE,
        fa.fullname,
        fa.englishname,
        fa.address,
        fa.bankacctno,
        fa.bankname,
        fa.shortname

    from cfmast cf,famembers fa
    where fa.shortname like P_BRKID
    and roles = 'BRK'
    and cf.custodycd = v_CustodyCD;


EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6043: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
