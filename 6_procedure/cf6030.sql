SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6030 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2, /*Ngay tao bao cao*/
   PV_CUSTODYCD           IN       VARCHAR2 /*So TK Luu ky */
   )
IS
    -- Bank confirmation - PHAN SECURITY
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- LAMGK    22-10-2019           created
    V_STROPTION    VARCHAR2 (5);
    V_STRBRID      VARCHAR2 (4);

    v_CurrDate     date;
    v_Report_Date  date;
    v_CustodyCD    varchar2(20);

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

    if (PV_CUSTODYCD = 'ALL' or PV_CUSTODYCD is null) then
      v_CustodyCD := '%';
    else
      v_CustodyCD := PV_CUSTODYCD;
    end if;

    v_Report_Date  :=  TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

OPEN PV_REFCURSOR FOR
     SELECT CF.CUSTID
         , FULLNAME -- TEN KHACH HANG
         , CF.CIFID --SO CIFID
         , CF.COUNTRY
         , NVL(DD_SSTA.REFCASAACCT,' ') SSTA_ACCOUNT
         , NVL(DD_IICA.REFCASAACCT,' ') IICA_ACCOUNT --SO TAI KHOAN LOAI IICA (check lai yeu cau voi Diem)
         , NVL(DD_DDA.REFCASAACCT,' ') DDA_ACCOUNT --SO TAI KHOAN LOAI DDA (check lai yeu cau voi Diem)
         , NVL(DD_DDA.CCYCD, 'SGD') DDA_ACCOUNT_CCY
        -- , CF.CFCLSDATE ACCT_CLOSING_DATE --NGAY DONG TAI KHOAN (check lai yeu cau voi Diem)
         ,v_Report_Date ACCT_CLOSING_DATE --NGAY DONG TAI KHOAN
     FROM (select distinct cf.custid,cf.FULLNAME,cf.COUNTRY,cf.CIFID,CF.CUSTODYCD from cfmast cf, afmast af,
     (select * from ddmast where status='C') dd
where cf.custid=af.custid and  cf.custid=dd.custid
and af.status='C'
order by cf.custid) CF
         LEFT JOIN (SELECT * FROM DDMAST WHERE ACCOUNTTYPE = 'IICA') DD_IICA ON NVL(DD_IICA.CUSTID, 'UNKNOWN') = NVL(CF.CUSTID, 'UNKNOWN')
         LEFT JOIN (SELECT * FROM DDMAST WHERE ACCOUNTTYPE = 'DDA') DD_DDA ON NVL(DD_DDA.CUSTID, 'UNKNOWN') = NVL(CF.CUSTID, 'UNKNOWN')
         LEFT JOIN (SELECT * FROM DDMAST WHERE ACCOUNTTYPE = 'SSTA') DD_SSTA ON NVL(DD_SSTA.CUSTID, 'UNKNOWN') = NVL(CF.CUSTID, 'UNKNOWN')
     WHERE CF.CUSTODYCD LIKE v_CustodyCD;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6030: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
