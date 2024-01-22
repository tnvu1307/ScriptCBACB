SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca6001(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2,
   P_GCBCODE              IN       VARCHAR2,
   P_AMCCODE              IN       VARCHAR2,
   P_CIFID                IN       VARCHAR2, /*Ma KH tai ngan hang */
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- du.phan    23-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_InDate            date;
    v_CurrDate          date;
    v_issuedate         date;
    v_expdate           date;
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
    v_IDCODE           varchar2(200);
    v_OFFICE           varchar2(200);
    v_REFNAME          varchar2(200);
    v_shvstc           varchar2(200);
    v_shvcustodycd     varchar2(200);
    v_shvcifid         varchar2(200);

    v_tltitle          varchar2(200);
    v_tlfullname       varchar2(200);
    V_CIFID            varchar2(200);
    V_GCBCODE          varchar2(20);
    V_AMCCODE          varchar2(20);
    v_TXNUM             VARCHAR2(10);
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
     IF P_GCBCODE = 'ALL' THEN
        V_GCBCODE := '%';
     ELSE V_GCBCODE := P_GCBCODE;
     END IF;

     IF P_AMCCODE = 'ALL' THEN
        V_AMCCODE := '%';
     ELSE V_AMCCODE := P_AMCCODE;
     END IF;

    v_InDate  := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    if P_CIFID ='ALL' then
        V_CIFID:='%';
    else
        V_CIFID:=P_CIFID;
    end if;
    v_TXNUM         :=     PV_TXNUM;

OPEN PV_REFCURSOR FOR
    /*with tmpGCB as (
        Select autoid gcbid, shortname, fullname from famembers
        where roles='GCB'
    )
    Select v_FromDate ReportingDate,
            cf.Fullname ClientName,
            cf.cifid ClientAccount
    from cfmast cf
    inner join tmpGCB gcb on gcb.gcbid = cf.gcbid
    where  gcb.shortname=P_GCBCODE
    and  cifid like V_CIFID;*/
    Select v_InDate ReportingDate,
            '' ClientName,
            '' ClientAccount,
            v_TXNUM TXNUM
    from dual;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CA6001: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
