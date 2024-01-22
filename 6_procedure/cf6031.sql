SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6031 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --PV_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   --PV_REPORT_DT    IN VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2 /*den ngay */ /*Ngay tao bao cao*/
   )
IS
    -- Bank confirmation - PHAN SECURITY
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- LAMGK    22-10-2019           created
    V_STROPTION    VARCHAR2 (5);
    V_STRBRID      VARCHAR2 (4);

    --v_CustodyCD    varchar2(20);
    v_CurrDate     date;
    --v_Report_Date date;
    v_FromDate     date;
    v_ToDate       date;
    v_HEADOFFICE_EN     varchar2(200);
    v_BRADDRESS_EN      varchar2(200);
    v_PHONE             varchar2(200);
    v_FAX               varchar2(200);
BEGIN

    V_STROPTION := OPT;
    v_CurrDate   := getcurrdate;

    --v_Report_Date  :=  TO_DATE(PV_REPORT_DT, SYSTEMNUMS.C_DATE_FORMAT);

    if v_stroption = 'A' then
        v_strbrid := '%';
    elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
    else
        v_strbrid:=brid;
    end if;

    --v_CustodyCD := REPLACE(PV_CUSTODYCD,'.','');
    --SYSTEMNUMS.C_DATE_FORMAT
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    Select
           max(case when  varname='BRADDRESS_EN' then varvalue else '' end),
           max(case when  varname='HEADOFFICE_EN' then varvalue else '' end),
           max(case when  varname='PHONE' then varvalue else '' end),
           max(case when  varname='FAX' then varvalue else '' end)
    into v_BRADDRESS_EN,v_HEADOFFICE_EN,v_PHONE,v_FAX
    from sysvar WHERE varname IN ('BRADDRESS_EN','HEADOFFICE_EN','PHONE','FAX');

OPEN PV_REFCURSOR FOR
     select fa.autoid, fa.shortname, fa.fullname,
            fa.autoid || fa.shortname objname,
            fa.roles,
            log.maker_dt, -- Ngay Thay doi
            log.approve_dt, -- Ngay duyet
            log.maker_id, -- User thay doi
            mk.tlfullname mkname, --
            log.approve_id, -- User duyet
            app.tlfullname appname, --
            fld.caption fieldname, -- Truong thay doi
            log.from_value, -- Gia tri cu
            log.to_value, -- Gia tri moi,
            log.action_flag, -- Hanh dong: Add: Them moi, Edit: Chinh sua.
            log.mod_num,
            v_HEADOFFICE_EN HEADOFFICE_EN,
            v_BRADDRESS_EN BRADDRESS_EN,
            v_PHONE PHONE,
            v_FAX FAX

        from maintain_log log, famembers fa, tlprofiles mk, tlprofiles app,
            (
                select * from fldmaster where objname ='FA.FAMEMBERS'
            )fld
        where table_name='FAMEMBERS'
        and  record_key like '%' || fa.autoid || '%'
        and fld.defname = log.column_name
        and log.maker_id = mk.tlid
        and log.approve_id = app.tlid (+)
        and log.maker_dt BETWEEN v_FromDate and v_ToDate
        order by autoid, mod_num desc
;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6031: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
