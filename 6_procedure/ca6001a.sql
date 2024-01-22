SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca6001a(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2,
   P_AMCCODE              IN       VARCHAR2

   )
IS
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
     IF P_AMCCODE = 'ALL' THEN
        V_AMCCODE := '%';
     ELSE V_AMCCODE := P_AMCCODE;
     END IF;

    v_InDate  := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
OPEN PV_REFCURSOR FOR
    Select v_InDate ReportingDate,
            '' ClientName,
            '' ClientAccount
    from dual;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CA6001A: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
