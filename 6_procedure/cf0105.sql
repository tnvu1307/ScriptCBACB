SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0105 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2,
   PV_LANGUAGE      IN       VARCHAR2,
   I_BRID           IN       VARCHAR2
       )
IS

--
-- PURPOSE: BAO CAO IN HOP DONG MO TIEU KHOAN GIAO DICH KY QUY
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- THENN        05-APR-2012 CREATED
-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);
    V_CUSTBANK          varchar2(10);
    V_SVTYPE            VARCHAR2(5);
    V_IN_DATE           VARCHAR2(15);
    V_SIGNTYPE          VARCHAR2(10);
    V_BRID              VARCHAR2(4);


BEGIN
    -- GET REPORT'S PARAMETERS
    V_STROPTION := OPT;
    V_BRID := BRID;


     OPEN PV_REFCURSOR FOR

           SELECT PV_LANGUAGE LANGUAGE ,
            V_STROPTION OPT,
            CF.custid, CF.custodycd, AF.acctno, cf.fullname, to_char(cf.dateofbirth,'DD/mm/yyyy') dateofbirth,
            decode(cf.country,'234',cf.idcode,cf.tradingcode) idcode, to_char(decode(cf.country,'234',cf.iddate,cf.tradingcodedt),'dd/mm/yyyy') iddate,
            cf.idplace, cf.address, cf.email,
            CF.MOBILESMS phone, A.CDCONTENT COUNTRY,cf.mobile,
            cf.fax,
            AF.mrcrlimit mrlimit, af.mrirate, af.mrmrate, af.mrlrate, TO_CHAR(AF.opndate,'DD/MM/YYYY') opndate,
            nvl(cfr.fullname,'.........................') authfullname, '....................' authlicense,
            '....................' authdate,
            sys1.varvalue BVSCREP, sys2.varvalue BVSCREPPOSITION, sys3.varvalue BVSCREPAUTH,
            sys4.varvalue BVSADDRESS, sys5.varvalue BVSPHONE, sys6.varvalue BVSFAX
            , sys7.varvalue BVSTITLE , sys8.varvalue BVSCLIC, CF.mobile, AF.bankacctno, AF.bankname,
            nvl(cfct.person,'') cperson,nvl(cfct.address,'') caddress,nvl(cfct.phone,'') cphone, nvl(cfct.email,'') cemail,
            CF.CONTRACTNO CONTRACTNO, CF.OPNDATE OPNDATE,
            cf.taxcode,
            nvl(cfr.fullname,'.........................') cfrfullname

        FROM CFMAST CF, AFMAST AF, aftype aft, sysvar sys1, sysvar sys2, sysvar sys3
        , sysvar sys4, sysvar sys5, sysvar sys6,sysvar sys7,SYSVAR SYS8  , ALLCODE A,cfcontact cfct,
           (SELECT TRIM(custid) custid, trim(min(fullname)) fullname from cfrelation WHERE retype ='010' GROUP BY custid) cfr
        WHERE CF.custid = AF.custid
            and cfct.custid(+)=cf.custid
            AND af.actype = aft.actype
            AND cf.custid = cfr.custid (+)
            AND sys1.grname = 'DEFINED' AND sys1.VARNAME = decode ( I_BRID ,'0001', 'BVSCREP','HCMBVSCREP')
            AND sys2.grname = 'DEFINED' AND sys2.VARNAME = decode ( I_BRID ,'0001', 'BVSCREPPOSITION','HCMBVSCREPPOSITION')
            AND sys3.grname = 'DEFINED' AND sys3.VARNAME =  decode ( I_BRID ,'0001', 'BVSCREPAUTH','HCMBVSCREPAUTH')
            AND sys4.grname = 'DEFINED' AND sys4.VARNAME =  decode ( I_BRID ,'0001', 'HNBVSADDRESS','HCMBVSADDRESS')
            AND sys5.grname = 'DEFINED' AND sys5.VARNAME =  decode ( I_BRID ,'0001', 'HNBVSPHONE','HCMBVSPHONE')
            AND sys6.grname = 'DEFINED' AND sys6.VARNAME =  decode ( I_BRID ,'0001', 'HNBVSFAX','HCMBVSFAX')
            AND sys7.grname = 'DEFINED' AND sys7.VARNAME =  decode ( I_BRID ,'0001', 'HNBVSTITLE','HCMBVSTITLE')
            AND sys8.grname = 'DEFINED' AND sys8.VARNAME =  decode ( I_BRID ,'0001', 'HNBVSCLIC','HCMBVSCLIC')
            AND A.CDTYPE = 'CF' AND A.CDNAME = 'COUNTRY' AND A.CDVAL = CF.COUNTRY
            AND cf.custtype='B'
            AND CF.custodycd = PV_CUSTODYCD
            AND AF.acctno = PV_AFACCTNO;

        /*SELECT CF.custid, CF.custodycd, AF.acctno, cf.fullname, to_char(cf.dateofbirth,'DD/mm/yyyy') dateofbirth,
            decode(cf.country,'234',cf.idcode,cf.tradingcode) idcode, to_char(decode(cf.country,'234',cf.iddate,cf.tradingcodedt),'dd/mm/yyyy') iddate,
            cf.idplace, cf.address, cf.email, cf.phone, cf.fax,
            AF.mrcrlimit mrlimit, af.mrirate, af.mrmrate, af.mrlrate, TO_CHAR(AF.opndate,'DD/MM/YYYY') opndate,
            nvl(cfr.fullname,'.........................') authfullname, '....................' authlicense,
            '....................' authdate,
            sys1.varvalue BVSCREP, sys2.varvalue BVSCREPPOSITION, sys3.varvalue BVSCREPAUTH
        FROM CFMAST CF, AFMAST AF, aftype aft, mrtype mrt, sysvar sys1, sysvar sys2, sysvar sys3,
            (SELECT cfr.custid, cf.fullname
            FROM cfmast cf,
                (SELECT custid, trim(min(recustid)) recustid from cfrelation WHERE retype ='006' GROUP BY custid) cfr
            WHERE cf.custid = cfr.recustid) cfr
        WHERE CF.custid = AF.custid
            AND af.actype = aft.actype AND aft.mrtype = mrt.actype --AND mrt.mrtype IN ('S','T')
            AND cf.custid = cfr.custid (+)
            AND sys1.grname = 'DEFINED' AND sys1.VARNAME = 'BVSCREP'
            AND sys2.grname = 'DEFINED' AND sys2.VARNAME = 'BVSCREPPOSITION'
            AND sys3.grname = 'DEFINED' AND sys3.VARNAME = 'BVSCREPAUTH'
            AND CF.custodycd = PV_CUSTODYCD
            AND AF.acctno = PV_AFACCTNO;
            */

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
