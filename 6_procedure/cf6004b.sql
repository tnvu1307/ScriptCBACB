SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF6004B (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2, /*den ngay */
   PV_CUSTODYCD           IN       VARCHAR2 /*So TK Luu ky */
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
    v_HEADOFFICE   varchar2(500);
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

    v_CustodyCD := REPLACE(PV_CUSTODYCD,'.','');

    /*
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    */

OPEN PV_REFCURSOR FOR
    select cf.custodycd, -- so tk luu ky
           cf.fullname , -- ten kh
           case when cf.country <> '234' then cf.tradingcodedt else cf.opndate end tradingcodedt,
           cf.autoid_gcb,
           cf.shortname_trustee,
           cf.autoid_trustee,
           cf.shortname_trustee,
           case
                when cf.shortname_gcb=cf.shortname_trustee and cf.shortname_gcb is not null then cf.shortname_gcb ||'-'|| cf.fullname
                when cf.shortname_gcb is null and cf.shortname_trustee is not null then cf.shortname_trustee ||'-'||cf.fullname
                when cf.shortname_gcb is not null and cf.shortname_trustee is null then cf.shortname_gcb ||'-'||cf.fullname
                when cf.shortname_gcb is null and cf.shortname_trustee is null then cf.fullname
                else cf.shortname_gcb ||'-'|| cf.shortname_trustee||'-'|| cf.fullname
           end customername,
		   cf.idcode idcode, -- So DKSH
           cf.iddate,   -- Ngay cap
           cf.idplace, -- Noi cap
           cf.idtype,   -- Loai
           cf.bankataddress as address,  -- Dia chi
           cf.phone, -- So DT
           cf.mobile, -- So DT
           cf.email, -- Email
           cf.cifid CIFNo,
           (CASE WHEN dd.accounttype='DDA' THEN 'Tài khoản thanh toán ('||DD.CCYCD||')' 
		   WHEN dd.accounttype='SSTA' THEN 'Tài khoản thanh toán dành cho Lưu ký chứng khoán' 
           WHEN dd.accounttype='ESCROW' THEN 'Tài khoản ký quỹ ('||DD.CCYCD||')'
           else a1.cdcontent END)AccountType,
           (CASE WHEN dd.accounttype='IICA' THEN 'Indirect Investment Capital Account For Custody' 
           WHEN dd.accounttype='DDA' THEN 'Demand Deposit Account ('||DD.CCYCD||') For Custody'
           WHEN dd.accounttype='SSTA' THEN 'Settlement Securities Trading Account For Custody' 
           WHEN dd.accounttype='ESCROW' THEN 'Escrow ('||DD.CCYCD||') For Custody'
           ELSE a1.en_cdcontent END) En_AccountType,
           dd.refcasaacct refbankacct, -- So TK NH
           dd.opndate opndate  --> Ngay mo (Chua biet lay dau, tam  thoi lay theo cfmast)
    from    (
                select cf.*,fa.autoid autoid_gcb,fa.shortname shortname_gcb,fa1.autoid autoid_trustee,fa1.shortname shortname_trustee,fa1.taxcode_trustee
                from cfmast cf,
                        ( select autoid,shortname,fullname,roles from famembers where roles ='GCB')  fa,
                        ( select autoid,shortname,fullname,roles,taxcode as taxcode_trustee from famembers where roles ='TRU')  fa1
                where   --cf.gcbid='141'-- and cf.trusteeid='26'
                           cf.gcbid=fa.autoid (+)
                        and cf.trusteeid=fa1.autoid (+)
            )cf,
          ddmast dd, allcode a1
    where cf.custid = dd.custid-- and cf.gcbid='141' and cf.trusteeid='26'
          and a1.cdname ='ACCOUNTTYPE' and a1.cdtype='DD' and a1.cdval = dd.AccountType
          --and dd.accounttype in ('IICA','DDA')
          and cf.custodycd = v_CustodyCD;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6004: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
