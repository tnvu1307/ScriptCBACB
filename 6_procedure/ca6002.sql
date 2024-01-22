SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CA6002(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_CIFID                IN       VARCHAR2 /*Ma KH tai ngan hang */
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
    v_CIFID            varchar2(20);
    v_tltitle          varchar2(200);
    v_tlfullname       varchar2(200);
    v_ClientName        varchar2(200);
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
     if  P_CIFID='ALL' then
          v_CIFID:='%' ;
     else
         BEGIN
            select cf.Fullname ClientName
            into v_ClientName
            from cfmast cf
            where cifid = P_CIFID;
          EXCEPTION
            WHEN OTHERS THEN
            v_ClientName:='';
          END;
        end if;
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);



OPEN PV_REFCURSOR FOR
    Select TO_CHAR(v_FromDate,'dd/Mon/yyyy') ReportingFromDate,
            TO_CHAR(v_ToDate,'dd/Mon/yyyy') ReportingToDate,
            v_ClientName ClientName,
            P_CIFID PortfolioNo
    from dual;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CA6002: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
