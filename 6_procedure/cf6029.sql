SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6029 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2, /*Ngay */
   P_BRKID              IN       VARCHAR2, /*AMC */
   P_SIGNUSER           IN      VARCHAR2 /*Nguoi ky*/
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
    v_Signature_en    varchar2(200);
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

    /*if (P_AMCID = 'ALL' or P_AMCID is null) then
        v_AMCID := '%';
    else
        v_AMCID := P_AMCID;
    end if;*/

    Begin
        SELECT CDCONTENT, EN_CDCONTENT into v_Signature,  v_Signature_en from allcode where cdname ='POSOFSIGN' and cdval =P_SIGNUSER and cdtype='CF';
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



    v_FromDate  :=     TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    /*v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    */

OPEN PV_REFCURSOR FOR
    Select fa.fullname,
           fa.englishname,
           fa.contractno, -- So hop dong
           fa.valdate,
           -- Thong tin nguoi dai dien 1
           DECODE(P_SIGNUSER,'002', v_1REFNAME,v_2REFNAME) REFNAME,
           DECODE(P_SIGNUSER,'002', v_1OFFICE,v_2OFFICE) OFFICE,
           DECODE(P_SIGNUSER,'002', v_1IDCODE,v_2IDCODE) IDCODE,
           v_Signature SignFunc,
           v_Signature_en en_SignFunc,
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
    from famembers fa
    where roles = 'BRK' and fa.shortname like P_BRKID;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('cf6029: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
