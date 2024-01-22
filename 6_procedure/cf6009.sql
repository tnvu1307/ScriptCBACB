SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6009 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCID           IN       VARCHAR2, /*AMC */
   P_Signature           IN      VARCHAR2 /*Nguoi ky*/
   )
as
    -- Giay dang ky ma so giao dich
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- truongld    18-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate     date;
    v_ToDate       date;
    v_CurrDate     date;
    v_AMCID        varchar2(20);
    v_Signature    varchar2(200);
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

    if (P_AMCID = 'ALL' or P_AMCID is null) then
        v_AMCID := '%';
    else
        v_AMCID := P_AMCID;
    end if;

   /* Begin
        SELECT EN_CDCONTENT into v_Signature from allcode where cdname ='POSOFSIGN' and cdval =P_Signature and cdtype='CF';
    EXCEPTION
      WHEN OTHERS
       THEN v_Signature := '';
    End;*/

    Begin
        SELECT fullname into v_Signature from cfauth where autoid=P_Signature;
    EXCEPTION
      WHEN OTHERS
       THEN v_Signature := '';
    End;

    Select max(case when  varname='BRADDRESS' then varvalue else '' end),
           max(case when  varname='BRADDRESS_EN' then varvalue else '' end),
           max(case when  varname='HEADOFFICE' then varvalue else '' end),
           max(case when  varname='HEADOFFICE_EN' then varvalue else '' end),
           max(case when  varname='EMAIL' then varvalue else '' end),
           max(case when  varname='PHONE' then varvalue else '' end),
           max(case when  varname='FAX' then varvalue else '' end)
       into v_BRADDRESS,v_BRADDRESS_EN,v_HEADOFFICE,v_HEADOFFICE_EN,v_EMAIL,v_PHONE,v_FAX
    from sysvar WHERE varname IN ('BRADDRESS','BRADDRESS_EN','HEADOFFICE','HEADOFFICE_EN','EMAIL','PHONE','FAX');

    Select max(case when  varname='1IDCODE' then varvalue else '' end),
           max(case when  varname='1OFFICE' then varvalue else '' end),
           max(case when  varname='1REFNAME' then varvalue else '' end),
           max(case when  varname='2IDCODE' then varvalue else '' end),
           max(case when  varname='2OFFICE' then varvalue else '' end),
           max(case when  varname='2REFNAME' then varvalue else '' end),
           max(case when  varname='BUSSINESSID' then varvalue else '' end)
        into v_1IDCODE, v_1OFFICE, v_1REFNAME, v_2IDCODE, v_2OFFICE, v_2REFNAME, v_BUSSINESSID
    from sysvar WHERE varname IN ('1IDCODE','1OFFICE','1REFNAME','2IDCODE','2OFFICE','2REFNAME','BUSSINESSID');


    /*
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    */

OPEN PV_REFCURSOR FOR
    Select distinct -- nam.ly 23-10-2019 14:43:00
           cf.fullname, -- Ho ten KH
           cf.tradingcode,  -- Ma so GD'
		   fa.fullname amcname,
           a1.en_cdcontent country, -- Quoc gia
           cf.idcode, -- So DKSH
           cf.custodycd, -- So TK giao dich
           dd.refcasaacct FIICAccount, -- So TK dau tu gian tiep
           cf.CIFID SECAccount, -- So TK chung khoan, Tam thoi lay so CIF sau nay lay them Ten day du cua noi luu ky.
           '' Relationship,
           'A' AffiliatedForm,
           v_Signature  Signature,
           --cfu.valdate, -- Ngay hieu luc UQ.
           -- Thong tin nguoi dai dien 1
           v_1REFNAME REFNAME1,
           v_1OFFICE OFFICE1,
           v_1IDCODE IDCODE1,
           -- Thong tin nguoi dai dien 2
           v_2REFNAME REFNAME2,
           v_2OFFICE OFFICE2,
           v_2IDCODE IDCODE2,
           -- Thong tin HSV
           v_HEADOFFICE HEADOFFICE,
           v_HEADOFFICE_EN HEADOFFICE_EN,
           v_BUSSINESSID BUSSINESSID,
           --
           v_BRADDRESS BRADDRESS,
           v_BRADDRESS_EN BRADDRESS_EN,
           v_EMAIL EMAIL,
           v_PHONE PHONE,
           v_FAX FAX
    from cfmast cf,/* cfauth cfu,*/ ddmast dd, famembers fa, allcode a1
    where --cf.custid = cfu.cfcustid and
            dd.custid = cf.custid
        and dd.status = 'A'
        and cf.amcid = fa.autoid
        and fa.shortname like v_AMCID
        and cf.country = a1.cdval and a1.cdname ='COUNTRY' AND A1.CDTYPE='CF'
        and cf.status='A'
        and dd.accounttype ='IICA'
        and cf.custodycd not like 'OTC%'
    ORDER BY cf.fullname, dd.refcasaacct;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('cf6009: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
