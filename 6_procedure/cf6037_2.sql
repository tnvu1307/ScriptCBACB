SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6037_2 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2, /*den ngay */
   P_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   PV_SYMBOL                IN       VARCHAR2,/* Ma trai phieu*/
   P_AUTH                IN         VARCHAR2 /* Ng dc uy quyen*/
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
    V_SYMBOL       varchar2(20);
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


    v_CustodyCD := REPLACE(P_CUSTODYCD,'.','');

   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := UPPER(REPLACE(trim(PV_SYMBOL),' ','_'));
   ELSE
      V_SYMBOL := '%';
   END IF;

    /*
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    */

OPEN PV_REFCURSOR FOR

    select cf.custodycd, --so tk luu ky
        cf.fullname, -- ten kh
        cf.tradingcode, -- MSGD
        dd.refcasaacct FIICAccount, -- IICA
        cf.cifid SECAccount, -- so tk ck
        iss.fullname fullnamebond , --TCPH ma bond code
        sb.symbol, -- ma trai phieu
        doc.refno, -- ma chung chi
        crp.no, -- so hop dong
        sb.issuedate, --
        sb.expdate,
        sb.parvalue,
        doc.qtty,
        sb.parvalue * doc.qtty amount,
        to_char(to_date(doc.clsdate,'dd/mm/rrrr'),'dd Mon rrrr') clsdate, --ngay nhap kho chung chi
        nvl(au.fullname,'') fullnameau,-- ten nguoi nhan dc uy quyen
        nvl(au.licenseno,'') licenseno, --cmnd ng nhan dc uy quyen
        nvl(au.telephone,'' ) telephone-- sdt cua ng nhan dc uy quyen
    from cfmast cf, ddmast dd , issuers iss, sbsecurities sb, docstransfer doc, CRPHYSAGREE crp,
        (select * from cfauth where custid= p_auth or licenseno = p_auth) au
    where cf.custid = dd.custid
    and sb.issuerid = iss.issuerid
    and sb.codeid = crp.codeid
    and doc.crphysagreeid = crp.crphysagreeid
    and cf.custid = au.cfcustid (+)
    and sb.SYMBOL LIKE V_SYMBOL
    and dd.accounttype='IICA' and dd.status <> 'C'
    and cf.custodycd = v_CustodyCD;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6037_2: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
