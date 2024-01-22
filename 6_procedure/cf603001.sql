SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf603001 (
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
 WITH CF_INF AS (
    select distinct cf.custid,cf.FULLNAME,cf.COUNTRY,cf.CIFID,CF.CUSTODYCD from cfmast cf, afmast af,
    (select * from ddmast where status='C') dd
    where cf.custid=af.custid and  cf.custid=dd.custid and af.status='C'
    and CF.CUSTODYCD LIKE v_CustodyCD
    )
    -------------------------------------------------------------
         SELECT * FROM (
     SELECT (CASE WHEN CF.COUNTRY <> '234' THEN 'Indirect Investment Captial Account (VND):' ELSE '' END )  DDTYPE
            ,(CASE WHEN CF.COUNTRY <> '234' THEN NVL(DD_IICA.REFCASAACCT,' ') ELSE '' END ) ACCOUNT
            , '0' ODR
     FROM CF_INF CF,(SELECT * FROM DDMAST WHERE ACCOUNTTYPE = 'IICA') DD_IICA
     WHERE  CF.CUSTID = DD_IICA.CUSTID
     union all
     SELECT  (CASE WHEN CF.COUNTRY <> '234' THEN 'Demand Deposit Account ('||NVL(DD_DDA.CCYCD, 'SGD')||')'  ELSE '' END ) DDTYPE
     ,(CASE WHEN CF.COUNTRY <> '234' THEN NVL(DD_DDA.REFCASAACCT,' ') ELSE '' END ) ACCOUNT ,'2' ODR
     FROM CF_INF CF,(SELECT * FROM DDMAST WHERE ACCOUNTTYPE = 'DDA') DD_DDA
     WHERE  CF.CUSTID=DD_DDA.CUSTID
     union all
     SELECT (CASE WHEN CF.COUNTRY ='234' THEN 'Settlement Securities Trading Account (VND):' ELSE '' END )  DDTYPE
     ,(CASE WHEN CF.COUNTRY ='234' THEN NVL(DD_SSTA.REFCASAACCT,' ') ELSE '' END )ACCOUNT, '1' ODR
     FROM CF_INF CF,(SELECT * FROM DDMAST WHERE ACCOUNTTYPE = 'SSTA') DD_SSTA
     WHERE  CF.CUSTID=DD_SSTA.CUSTID
     union all
     SELECT 'ESCROW'  DDTYPE
     ,NVL(DD_ESCROW.REFCASAACCT,' ') ACCOUNT, '3' ODR
     FROM CF_INF CF,(SELECT * FROM DDMAST WHERE ACCOUNTTYPE = 'ESCROW') DD_ESCROW
     WHERE  CF.CUSTID=DD_ESCROW.CUSTID
     )WHERE DDTYPE IS NOT NULL ORDER BY ODR
     ;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF603001: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
