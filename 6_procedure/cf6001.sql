SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6001 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2, /*den ngay */
   PV_CUSTODYCD           IN       VARCHAR2 /*So TK Luu ky */
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
    v_HEADOFFICE    varchar2(200);
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
    v_CustodyCD := REPLACE(PV_CUSTODYCD,'.','');
    select varvalue into v_HEADOFFICE from sysvar where varname='HEADOFFICE';
    /*
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    */
OPEN PV_REFCURSOR FOR
 select custodycd,fullname,idcode,iddate,address,country,GCB,Trustee,amc_vn,amc_nn,HEADOFFICE,UQ_HEADOFFICE,CF_CONTACT,fa_email,cfc_phone,
        listagg(secname,'') within group(order by custodycd) secname, AmcVNAddress, AmcNNAddress/*, BrkAddress*/, TruAddress, GcbAddress
 from
 (
    select cf.custodycd, -- so tk luu ky
           cf.fullname, -- ten kh
           cf.idcode, -- so cmnd/giay phep kd
           cf.DATEOFBIRTH iddate, -- ngay cap/ngay thanh lap
           cf.address, -- dia chi
           a1.cdcontent country, -- quoc gia
           --------------------GCB----------------------------
           fa4.fullname GCB,
           --------------------trusteen----------------------------
           fa3.fullname Trustee,
           --------------------CTCK--------------------------------
           v_HEADOFFICE HEADOFFICE, -- Ngan hang shinhan VN
           fa2.shortname, -- Ten viet tat cua CTy CK
           fa2.fullname||' '||chr(10)||chr(13)|| fa2.address||' '||chr(10)||chr(13)||chr(10)||chr(13)  secname,
           --fa2.fullname secname, -- ten cty CK
           v_HEADOFFICE UQ_HEADOFFICE, -- Thong tin UQ
           --------------------AMC--------------------------------
           case when fa.nationality ='234' then fa.fullname  else null end amc_vn, -- ten amc vn
           case when fa.nationality ='234' then null else fa.fullname end amc_nn, -- ten amc vn
           cfc.person CF_CONTACT, -- Ten CEO
           fa.email fa_email, -- Email
           cfc.phone CFC_PHONE, -- So DT
           case when fa.nationality ='234' then fa.address else null end AmcVNAddress,
           case when fa.nationality ='234' then null else fa.address end AmcNNAddress,
           --fa2.address BrkAddress,
           fa3.address TruAddress,
           fa4.address GcbAddress
    from cfmast cf,(select min(autoid) autoid, custid from cfcontact group by custid)cfc1,cfcontact cfc,
        allcode a1,
        famembers fa,
        (SELECT * FROM famembers fa WHERE fa.roles ='LCB') fa1,
        fabrokerage fab,
        (SELECT * FROM famembers fa WHERE fa.roles ='BRK')fa2,
        (SELECT * FROM famembers fa WHERE fa.roles ='TRU')fa3,
        (SELECT * FROM famembers fa WHERE fa.roles ='GCB')fa4
    where cf.country = a1.cdval and A1.cdname ='COUNTRY' AND A1.cdtype='CF'
        and cf.amcid = fa.autoid (+)
        and cf.lcbid = fa1.autoid(+)
        and cf.custodycd = fab.custodycd (+)
        AND fab.brkid=fa2.autoid(+)
        and cf.trusteeid= fa3.autoid(+)
        and cf.gcbid= fa4.autoid(+)
        and cf.custid=cfc.custid (+)
		and cfc.autoid=cfc1.autoid (+)
        AND CF.CUSTODYCD=v_CustodyCD--'SHVFCB7777'
)
group by custodycd,fullname,idcode,iddate,address,country,GCB,Trustee,amc_vn,amc_nn,HEADOFFICE,UQ_HEADOFFICE,CF_CONTACT,fa_email,CFC_phone,AmcVNAddress, AmcNNAddress/*,BrkAddress*/, TruAddress, GcbAddress
;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6001: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
