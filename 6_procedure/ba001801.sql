SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE BA001801(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   PV_ISSUERS             IN       VARCHAR2,
   PV_SYMBOL              IN       VARCHAR2,
   I_DATE                 IN       varchar2,
   PV_CUSTODYCD           IN       varchar2
   )
IS
    -- BA0018: Application for remittance
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- thoai.tran    20-11-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_paymentdate        date;
    v_CUSTODYCD    varchar(20);
    v_ticker        varchar(20);
    v_currdate      date;
    v_issname           varchar(20);
BEGIN
     V_STROPTION := OPT;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;
    v_CUSTODYCD := Replace(PV_CUSTODYCD,'.','');
    if(v_CUSTODYCD='ALL') then
        v_CUSTODYCD:='%';
    else
        v_CUSTODYCD:=v_CUSTODYCD;
    end if;
    v_ticker:=PV_SYMBOL;
    v_paymentdate  := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_issname:=PV_ISSUERS;
    v_currdate:=getcurrdate();

OPEN PV_REFCURSOR FOR
    select
       cf.fullname fundname
        from cfmast cf, bondsemast bse, sbsecurities sb,issuers iss,bondtypepay bt
        where cf.custodycd=bse.custodycd
            and iss.issuerid=sb.issuerid
            and bse.bondcode=sb.codeid
            and bse.bondcode=bt.bondcode
            and sb.symbol like  v_ticker
            and cf.custodycd like v_CUSTODYCD
            and bt.paymentdate = v_paymentdate  -- lay du lieu theo paymentdate (khi cung symbol/codeid khac date)
            and iss.issuerid like  v_issname;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('BA001801: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
