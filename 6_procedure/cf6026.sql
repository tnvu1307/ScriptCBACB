SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6026(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   P_CUSTODYCD            IN       VARCHAR2, /*So TK Luu ky */
   P_CONTRACT             IN       VARCHAR2, /*So hop dong*/
   P_CFAUTH               IN       VARCHAR2, /*Nguoi nhan */
   P_SIGNTYPE             IN       VARCHAR2 /*Nguoi ky */
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- thoai.tran    06-11-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_CustodyCD         varchar2(20);
    v_IDCODE           varchar2(200);
    v_OFFICE           varchar2(200);
    v_REFNAME          varchar2(200);
    v_tllicenseno      varchar2(200);
    v_tlfullname       varchar2(200);
    v_tlcmp            varchar2(200);

BEGIN
     V_STROPTION := OPT;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;
     v_CustodyCD := REPLACE(P_CUSTODYCD,'.','');

    If P_SIGNTYPE = '002' then
        Select max(case when  varname='1IDCODE' then varvalue else '' end),
           max(case when  varname='1OFFICE' then varvalue else '' end),
           max(case when  varname='1REFNAME' then varvalue else '' end)
            into v_IDCODE, v_OFFICE, v_REFNAME
        from sysvar WHERE varname IN ('1IDCODE','1OFFICE','1REFNAME');
    Else
        Select
           max(case when  varname='2IDCODE' then varvalue else '' end),
           max(case when  varname='2OFFICE' then varvalue else '' end),
           max(case when  varname='2REFNAME' then varvalue else '' end)
            into v_IDCODE, v_OFFICE, v_REFNAME
        from sysvar WHERE varname IN ('2IDCODE','2OFFICE','2REFNAME');
    End If;
-- lay thong tin nguoi uy quyen
    begin
        select  max(nvl(fullname,'')) ,-- ten nguoi nhan dc uy quyen
        max(nvl(licenseno,''))         --comany cua nguoi duoc uy quyen -- check lai voi chi Diem
        into  v_tlfullname,v_tllicenseno
        from cfauth
        where custid= P_CFAUTH;
    EXCEPTION
        WHEN OTHERS  THEN
            v_tlfullname := 'a';
            v_tllicenseno:= 'a';
            v_tlcmp :='a';
    End;

OPEN PV_REFCURSOR FOR

    select v_IDCODE Sign_idcode, v_OFFICE Sign_office, v_REFNAME Sign_refname,v_tlfullname tlfullname,v_tllicenseno tllicenseno,v_tlcmp tlcmp,
    mst.*, utils.fnc_number2work(mst.totalvalue,'Vietnam Dong') Strqttyvalue
    from
    (
         select cf.fullname fundname,
        iss.fullname bondsissuers,
        (case when cf.country ='234' then substr(cf.custodycd,5,6) else cf.tradingcode end) trandingcode,
        cf.custodycd custodycd,
        cf.cifid cifid,
        dd.refcasaacct IICAnumber,
        cp.Codeid bondcode,
       sb.issuedate issuedate,
        sb.expdate maturitydate,
		CASE WHEN sum(NVL(doc.qtty,0)) = 0 THEN CP.QTTY ELSE sum(NVL(doc.qtty,0)) END totalqtty,
        CASE WHEN sum(NVL(doc.qtty,0)) = 0 THEN SUM(CP.QTTY*sb.parvalue) ELSE sum(NVL(doc.qtty,0)*sb.parvalue) END totalvalue
        from  crphysagree cp, issuers iss, cfmast cf,ddmast dd,SBSECURITIES sb,(SELECT A.* FROM DOCSTRANSFER A,(SELECT DISTINCT A.CRPHYSAGREEID
        FROM CRPHYSAGREE_LOG_ALL A, CRPHYSAGREE B
        WHERE A.TLTXCD='1405') MST
        WHERE A.CRPHYSAGREEID =MST.CRPHYSAGREEID (+))DOC
        where cp.issuerid=iss.issuerid
        and cp.codeid = sb.codeid
        and doc.CRPHYSAGREEID (+)=cp.CRPHYSAGREEID
        and cf.custodycd=dd.custodycd
        and cf.custodycd=cp.custodycd
        and dd.accounttype='IICA'
        and dd.isdefault ='Y'
        and dd.status <> 'C'
        and cf.custodycd like v_CustodyCD
        and cp.crphysagreeid = P_CONTRACT
        group by cf.fullname,iss.fullname,cf.custodycd, cf.cifid,dd.refcasaacct,cp.Codeid,sb.issuedate,
        sb.expdate,cf.country,cf.tradingcode,cp.qtty
    )mst;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6026: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
