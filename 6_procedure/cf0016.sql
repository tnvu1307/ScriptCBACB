SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0016 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   BRGID          IN       VARCHAR2,
   REFNAME        IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- THUNT   2019-10-28 EDITED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRAFACCTNO     VARCHAR2 (16);
   V_STRBRGID           VARCHAR2 (10);
   V_STRREFNAME         VARCHAR2 (20);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (60);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   /*V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;*/

    V_STROPTION := upper(OPT);
   V_INBRID := BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;
   -- GET REPORT'S PARAMETERS

  IF (BRGID  <> 'ALL')
   THEN
      V_STRBRGID  := BRGID;
   ELSE
      V_STRBRGID := '%%';
   END IF;

    IF (REFNAME  <> 'ALL')
   THEN
      V_STRREFNAME  := REFNAME;
   ELSE
      V_STRREFNAME := '%%';
   END IF;

   -- END OF GETTING REPORT'S PARAMETERS

   -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        FOR
        SELECT DISTINCT
         REVERSE(SUBSTR(REVERSE(
         AUT1||AUT2||AUT3||AUT4||AUT5||AUT7||AUT8||AUT9||AUT15||AUT14||AUT12||AUT13||AUT16
         ),2))
           LINKAUTH,FULLNAME ,CUSTODYCD  ,IDCODE ,ADDRESS ,FULLNAMEAUTH ,LICENSENO ,VALDATE ,EXPDATE,ADDRESSAUT,
           custtype, country, description
   FROM(
        SELECT
         /*(CASE WHEN CF.AUT4='4'or CF.AUT5='5' then 'I' end) AUTH1,
         (CASE WHEN CF.AUT3='3' then 'II' end) AUTH2,
         (CASE WHEN CF.AUT9='9' then 'III' end) AUTH3,
         (CASE WHEN CF.AUT10='10' then 'IV' end)AUTH4,
         (CASE WHEN CF.AUT11='11' then 'V' end) AUTH5,
         (CASE WHEN CF.AUT1='1'and CF.AUT2='2' and CF.AUT1='1'and CF.AUT3='3'
               and CF.AUT4='4'and CF.AUT5='5' and CF.AUT6='6'and CF.AUT7='7'
               and CF.AUT8='8'and CF.AUT9='9' and CF.AUT10='10'and CF.AUT11='11'
               then 'VI' end) AUTH6,
         (CASE WHEN CF.AUT1='1'or CF.AUT2='2' or CF.AUT6='6' then '' end) AUTH7,*/
         AUT1,AUT2,AUT3,AUT4,AUT5,AUT7,AUT8,AUT9,AUT15,AUT14,AUT12,AUT13,AUT16,
               CF.FULLNAME ,CF.CUSTODYCD  ,CF.IDCODE ,CF.ADDRESS ,
               CF.FULLNAMEAUTH  FULLNAMEAUTH ,CF.LICENSENO ,CF.VALDATE ,CF.EXPDATE, CF.ADDRESSAUT,
               cf.custtype, cf.country,cf.description
        FROM ( SELECT
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,1,1) ='Y' THEN 'I,'END)AUT1, --XEM
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,2,1) ='Y' THEN 'II,'END)AUT2, -- BAO CAO
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,3,1) ='Y' THEN 'III,'END)AUT3,-- GUI/RUT/CHUYEN TIEN
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,4,1) ='Y' THEN 'IV,'END)AUT4, -- MUA
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,5,1) ='Y' THEN 'V,'END)AUT5, -- BAN
                 --( CASE WHEN SUBSTR(CFA.LINKAUTH,6,1) ='Y' THEN 'VI,'END)AUT6,
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,7,1) ='Y' THEN 'VI,'END)AUT7, -- CHUYEN KHOAN CK
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,8,1) ='Y' THEN 'VII,'END)AUT8, -- DANG KY QUYEN MUA
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,9,1) ='Y' THEN 'VIII,'END)AUT9,-- GUI/ RUT CK
                -- ( CASE WHEN SUBSTR(CFA.LINKAUTH,10,1) ='Y' THEN 'IX,'END)AUT10,
                -- ( CASE WHEN SUBSTR(CFA.LINKAUTH,11,1) ='Y' THEN 'X,'END)AUT11,
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,12,1) ='Y' THEN 'XI,'END)AUT12, --STC
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,13,1) ='Y' THEN 'XII,'END)AUT13, --FX
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,14,1) ='Y' THEN 'X,'END)AUT14, --CAM CO/ GIAI TOA
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,15,1) ='Y' THEN 'IX,'END)AUT15, --PHONG TOA/ GIA TOA
                 ( CASE WHEN SUBSTR(CFA.LINKAUTH,16,1) ='Y' THEN 'XIII,'END)AUT16, -- CONG BO THONG TIN
             CF1.FULLNAME ,AF.ACCTNO ,CF1.CUSTODYCD  ,CF1.IDCODE ,CF1.IDDATE , CF1.ADDRESS,
                   case when cfa.custid is null then CFA.FULLNAME else cf2.fullname end FULLNAMEAUTH,
                   case when cfa.custid is null then cfa.LICENSENO else cf2.idcode end LICENSENO,
                   CFA.VALDATE ,case when CFA.AUTHLIMIT='N' then to_char(CFA.EXPDATE,'dd/MM/rrrr') else 'VH' end EXPDATE,
                   case when cfa.custid is null then cfa.ADDRESS else cf2.address end ADDRESSAUT,
                cf1.custtype, cf1.country,cfa.description
             FROM CFMAST CF1, afmast af, CFAUTH CFA, CFMAST CF2,(
                select ra.afacctno, rc.custid, rc.brid
                from reaflnk ra, recflnk rc
                where ra.status='A' and rc.status='A'
                    and substr(ra.reacctno,1,10)=rc.custid
                group by ra.afacctno, rc.custid, rc.brid
             ) re
             WHERE  CF1.CUSTID = CFA.CFCUSTID and cf1.custid = af.custid
             AND CFA.CUSTID = CF2.CUSTID(+)
             And CF1.CUSTID = RE.AFACCTNO(+)
             AND nvl(re.brid,cf1.brid) LIKE  V_STRBRGID
             AND CFA.VALDATE <=TO_DATE(T_DATE ,'DD/MM/YYYY')
             AND CFA.VALDATE >=TO_DATE(F_DATE ,'DD/MM/YYYY')
             AND AF.custid like V_STRREFNAME
             --AND (nvl(re.brid,cf1.brid) LIKE V_STRBRID or instr(V_STRBRID,nvl(re.brid,cf1.brid)) <> 0 )
             ORDER BY CF1.SHORTNAME
             )
             CF)
             ;

 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/
