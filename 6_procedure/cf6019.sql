SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6019 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2 /*den ngay */
   PV_CUSTODYCD                    IN       VARCHAR2
   )
IS
    -- Swift summary
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- trung.luu    29-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
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
    v_FromDate     date;
    v_ToDate       date;
    v_CurrDate     date;
    v_custodycd    varchar2(20);
    v_SHVBICCODE   varchar2(100);


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
    Select max(case when  varname='BRADDRESS' then varvalue else '' end),
           max(case when  varname='BRADDRESS_EN' then varvalue else '' end),
           max(case when  varname='HEADOFFICE' then varvalue else '' end),
           max(case when  varname='HEADOFFICE_EN' then varvalue else '' end),
           max(case when  varname='EMAIL' then varvalue else '' end),
           max(case when  varname='PHONE' then varvalue else '' end),
           max(case when  varname='FAX' then varvalue else '' end)
       into v_BRADDRESS,v_BRADDRESS_EN,v_HEADOFFICE,v_HEADOFFICE_EN,v_EMAIL,v_PHONE,v_FAX
    from sysvar WHERE varname IN ('BRADDRESS','BRADDRESS_EN','HEADOFFICE','HEADOFFICE_EN','EMAIL','PHONE','FAX');

    v_custodycd := upper(REPLACE(PV_CUSTODYCD,'.',''));


    IF (v_custodycd = 'ALL') THEN
        v_custodycd := '%';
     ELSE
        v_custodycd:= v_custodycd;
     END IF;

    /*v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);*/


OPEN PV_REFCURSOR FOR

    SELECT
        v_BRADDRESS BRADDRESS
        ,v_BRADDRESS_EN BRADDRESS_EN
        ,v_HEADOFFICE   HEADOFFICE
        ,v_HEADOFFICE_EN    HEADOFFICE_EN
        ,v_EMAIL    EMAIL
        ,v_PHONE    PHONE
        ,v_FAX  FAX
        ,CF.CUSTODYCD
        ,FA.FULLNAME AMCNAME
        ,FA.AUTOID
        ,CF.SHORTNAME SHORTNAME
        ,TO_CHAR(CF.TRADINGCODEDT,'DD/MM/YYYY') TRADINGCODEDT
        ,(CASE WHEN COUNTRY ='234' THEN SUBSTR(CF.CUSTODYCD,5,6) ELSE TRADINGCODE END) STC
        ,CF.CIFID CIFID
        ,GC.SHORTNAME || '-' || TR.SHORTNAME|| '-' || CF.FULLNAME ACNAME
        ,CF.CEO CEO
        ,A1.EN_CDCONTENT
        ,FA.SHORTNAME AS SHORTNAME_AMC
        ,D.ACCOUNTTYPE
        ,D.CCYCD
        ,D.REFCASAACCT
    FROM FAMEMBERS FA, CFMAST CF,
        (
            SELECT * FROM ALLCODE WHERE CDNAME = 'STATUS' AND CDTYPE = 'CF'
        )A1,
        (
            SELECT * FROM DDMAST WHERE STATUS = 'A' --AND ACCOUNTTYPE IN ('IICA','DDA')
        )D,
        (
            SELECT FA.SHORTNAME,CF.CUSTODYCD FROM FAMEMBERS FA, CFMAST CF WHERE FA.AUTOID = CF.GCBID
        )GC,
        (
            SELECT FA.SHORTNAME,CF.CUSTODYCD FROM FAMEMBERS FA, CFMAST CF WHERE FA.AUTOID = CF.TRUSTEEID
        )TR
    WHERE CF.AMCID = FA.AUTOID (+)
    AND CF.STATUS  = A1.CDVAL
    AND CF.CUSTODYCD = D.CUSTODYCD
    AND CF.CUSTODYCD = GC.CUSTODYCD (+)
    AND CF.CUSTODYCD = TR.CUSTODYCD (+)
    AND CF.CUSTODYCD LIKE V_CUSTODYCD
    ORDER BY FA.FULLNAME, D.ACCOUNTTYPE;

/*select
             v_BRADDRESS BRADDRESS
            ,v_BRADDRESS_EN BRADDRESS_EN
            ,v_HEADOFFICE   HEADOFFICE
            ,v_HEADOFFICE_EN    HEADOFFICE_EN
            ,v_EMAIL    EMAIL
            ,v_PHONE    PHONE
            ,v_FAX  FAX
            ,a1.AMCNAME
            ,a1.SHORTNAME
            ,a1.tradingcodedt
            ,a1.stc
            ,a1.cifid
            ,a1.acname
            ,a1.CEO
            ,a1.EN_CDCONTENT
            ,a2.IICA
            ,NVL(A2.CCYCD,'VND') AS CCYCD_IICA
            ,a3.DDA
            ,NVL(A3.CCYCD,'USD') AS CCYCD_DDA
from
(
    select cf.custodycd,fa.fullname AMCNAME
            ,cf.shortname SHORTNAME
            ,To_Char(cf.tradingcodedt,'dd/MM/yyyy') tradingcodedt
            ,(case when country ='234' then substr(cf.custodycd,5,6) else tradingcode end) STC
            ,cf.cifid CIFID
            ,gc.shortname || '-' || tr.shortname|| '-' || cf.fullname ACNAME
            ,cf.ceo CEO,A1.EN_CDCONTENT
            ,fa.shortname as shortname_amc
    from famembers fa, cfmast cf,
        (
            select * from allcode where cdname = 'STATUS' and cdtype = 'CF'
        )A1,
        (
            select * from ddmast where status = 'A' --and accounttype in ('IICA','DDA')
        )d,
        (
            select fa.shortname,cf.custodycd from famembers fa, cfmast cf where fa.autoid = cf.gcbid
        )gc,
        (
            select fa.shortname,cf.custodycd from famembers fa, cfmast cf where fa.autoid = cf.trusteeid
        )tr
    where cf.amcid = fa.autoid (+)
        and cf.status  = A1.cdval
        and cf.custodycd = d.custodycd
        and cf.custodycd = gc.custodycd (+)
        and cf.custodycd = tr.custodycd (+)
    group by cf.custodycd,fa.fullname,cf.shortname ,
    cf.tradingcodedt,cf.country,cf.tradingcode,cf.cifid,gc.shortname ,tr.shortname,cf.fullname,cf.ceo ,A1.EN_CDCONTENT,fa.shortname
    order by fa.fullname
)a1,
(select d.custodycd,ccycd,
        nvl(d.refcasaacct,'') IICA
    from ddmast d
    where d.status = 'A'
        and d.accounttype in ('IICA')
       -- and ccycd ='VND'
    group by  d.custodycd,ccycd,d.refcasaacct
)a2,
(select d.custodycd,ccycd,
         nvl(d.refcasaacct,'') DDA
    from ddmast d
    where d.status = 'A'
        and d.accounttype in ('DDA')
       -- and ccycd ='VND'
    group by  d.custodycd,ccycd,d.refcasaacct
)a3
where a1.custodycd=a2.custodycd (+)
    and  a1.custodycd=a3.custodycd (+)
    --and upper(a1.shortname_amc) like v_AMC
    and a1.custodycd like v_custodycd
;*/
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6019: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
