SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0106_1 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   I_DATE           IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2

       )
IS

--
-- PURPOSE: BAO CAO IN HOP DONG MO TIEU KHOAN GIAO DICH KY QUY
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS

-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);


BEGIN
    -- GET REPORT'S PARAMETERS
    V_STROPTION := OPT;
OPEN PV_REFCURSOR
   FOR
     select  upper(cf.fullname)   name,
                cf.dateofbirth Birthday,
                al.cdcontent nationality,
                cf.sex,
                case when cf.country = '234' then cf.idcode else cf.tradingcode end idcode,
                cf.iddate,
                cf.idplace,
                cf.idexpired,
                cf.mobilesms,
                cf.address,
                cf.email,
                cf.fax,
                cf.taxcode,

                cf.custodycd,
                CF.CUSTID,


                cfr.FULLNAME cfrfullname,
                cfa.valdate

        from    cfmast cf, allcode al,(select cfr.fullname,TRIM(cfr.CUSTID) CUSTID  from cfrelation cfr WHERE cfr.retype = '010') cfr,
                (SELECT CFcustid,valdate FROM cfauth CFA, CFMAST CF WHERE CFA.CUSTID = CF.CUSTID AND CUSTODYCD LIKE '022P%' ) CFA
        where   al.cdTYPE='CF' and al.cdname = 'COUNTRY'
        AND     CF.country = AL.CDVAL
        AND     CF.CUSTID = cfr.CUSTID(+)
        and     CF.CUSTTYPE = 'B'
        AND     CFA.CFCUSTID = CF.CUSTID
        AND     CF.CUSTODYCD = PV_CUSTODYCD



     ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
 
 
 
 
/
