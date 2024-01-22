SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF6006 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2, /*den ngay */
   P_CUSTODYCD           IN       VARCHAR2 /*So TK Luu ky */
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
    v_CustodyCD    varchar2(20);
    v_HEADOFFICE    varchar2(200);
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

    v_CustodyCD := REPLACE(P_CUSTODYCD,'.','');
    select varvalue into v_HEADOFFICE from sysvar where varname='HEADOFFICE';

    /*
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    */

OPEN PV_REFCURSOR FOR
    select cf.custodycd, -- so tk luu ky
           cf.fullname, -- ten kh
           cf.idcode, -- so cmnd/giay phep kd
           cf.iddate, -- ngay cap/ngay thanh lap
           cf.address,
           cf.TRADINGCODE,
           cf.TRADINGCODEDT,
           a1.cdcontent country, -- quoc gia
           v_HEADOFFICE HEADOFFICE, -- Ngan hang shinhan VN
           fa.shortname, -- Ten viet tat cua CTy CK
           fa.fullname secname, -- ten cty CK
           v_HEADOFFICE UQ_HEADOFFICE, -- Thong tin UQ
           fa.CEONAME, -- Ten CEO
           fa.email fa_email, -- Email
           fa.telephone fa_telephone -- So DT
    from cfmast cf, allcode a1,famembers fa
    where cf.country = a1.cdval and A1.cdname ='COUNTRY' AND A1.cdtype='CF'
        and cf.amcid = fa.autoid (+)
        and cf.custodycd = v_CustodyCD;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6006: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
