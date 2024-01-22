SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   ACTYPE         IN       VARCHAR2,
   INCOMERANGE    IN       VARCHAR2,
   EDUCATION      IN       VARCHAR2,
   SECTOR         IN       VARCHAR2,
   AFTYPE         IN       VARCHAR2,
   CAREBY         IN       VARCHAR2,
   PLACE          IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   PV_AFTYPE      IN       VARCHAR2,
   PV_TRADETYPE      IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- Hien.vu
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (60);              -- USED WHEN V_NUMOPTION > 0
   V_ACTYPE           VARCHAR2 (16);
   V_BRID            VARCHAR2 (4);
   V_STRINCOMERANGE   VARCHAR2 (50);
   V_STREDUCATION     VARCHAR2 (50);
   V_STRSECTOR        VARCHAR2 (50);
   V_STRAFTYPE        VARCHAR2 (50);
   V_STRCAREBY        VARCHAR2 (50);
   V_STRPLACE         VARCHAR2 (50);
   V_STRREFNAME       VARCHAR2 (50);
   v_text             varchar2(1000);
   L_STRAFTYPE        varchar2(20);
   V_TRADETYPE       varchar2(20);
   V_CHECK       varchar2(20);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- insert into temp_bug(text) values('CF0001');commit;
   V_STROPTION := OPT;
   V_BRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_BRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

   -- GET REPORT'S PARAMETERS
   IF (ACTYPE <> 'ALL')
   THEN
      V_ACTYPE := ACTYPE;
   ELSE
      V_ACTYPE := '%%';
   END IF;

   IF (INCOMERANGE <> 'ALL')
   THEN
      V_STRINCOMERANGE := INCOMERANGE;
   ELSE
      V_STRINCOMERANGE := '%%';
   END IF;

   IF (EDUCATION <> 'ALL')
   THEN
      V_STREDUCATION := EDUCATION;
   ELSE
      V_STREDUCATION := '%%';
   END IF;


   IF (CUSTODYCD <> 'ALL')
   THEN
      V_STRREFNAME:= CUSTODYCD;
   ELSE
      V_STRREFNAME := '%%';
   END IF;

   IF (SECTOR <> 'ALL')
   THEN
      V_STRSECTOR := SECTOR;
   ELSE
      V_STRSECTOR := '%%';
   END IF;

   IF (AFTYPE <> 'ALL')
   THEN
      V_STRAFTYPE := AFTYPE;
   ELSE
      V_STRAFTYPE := '%%';
   END IF;

   IF (CAREBY <> 'ALL')
   THEN
      V_STRCAREBY := CAREBY;
   ELSE
      V_STRCAREBY := '%%';
   END IF;
   IF (UPPER(PLACE) <> 'ALL')
   THEN
      V_STRPLACE := PLACE;
   ELSE
      V_STRPLACE := '%%';
   END IF;


    IF (PV_AFTYPE IS NULL OR UPPER(PV_AFTYPE) = 'ALL')
   THEN
      L_STRAFTYPE := '%';
   ELSE
      L_STRAFTYPE := PV_AFTYPE;
   END IF;

       IF (PV_TRADETYPE IS NULL OR UPPER(PV_TRADETYPE) = 'ALL')
   THEN
      V_TRADETYPE := '%';
   ELSE
      V_TRADETYPE := PV_AFTYPE;
   END IF;

--LAY RA COI TK NAY CO GD HAY K ?
    /*SELECT CASE WHEN COUNT(*) > 0 THEN '1' ELSE '0' END AAA INTO V_CHECK
    FROM vw_odmast_all OD,cfmast cf
    WHERE OD.CUSTID=CF.custid
    AND CF.CUSTODYCD LIKE V_STRREFNAME;
*/

   -- END OF GETTING REPORT'S PARAMETERS
   -- GET REPORT'S DATA
--   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
--   THEN
      OPEN PV_REFCURSOR
       FOR
          SELECT   OPNDATE, FULLNAME,DATEOFBIRTH,IDCODE,ADDRESS,IDPLACE,CUSTID, ACCTNO,
                   ACTYPE,BRID,CAREBY, CUSTTYPE, CUSTODYCD,IDDATE
                   ,COUNTRY,AFTYPE, nvl(REFNAME,'') REFNAME, mnemonic, brname
            FROM (

                  SELECT   AF.OPNDATE OPNDATE, CF.FULLNAME FULLNAME,
                   CF.DATEOFBIRTH DATEOFBIRTH,CF.IDCODE IDCODE,
                   CF.ADDRESS ADDRESS,CF.IDPLACE IDPLACE,CF.IDDATE IDDATE,
                   CF.CUSTID CUSTID, AF.ACCTNO ACCTNO,
                   AF.ACTYPE ACTYPE,CF.BRID BRID,CF.CAREBY CAREBY,
                   CF.CUSTTYPE CUSTTYPE,CF.CUSTODYCD CUSTODYCD,
                   CTRY.CDCONTENT COUNTRY,ATYPE.CDCONTENT AFTYPE , cf.REFNAME, AFT.mnemonic, br.brname
                   FROM     CFMAST CF, AFMAST AF,
                            ALLCODE CTRY, ALLCODE ATYPE, AFTYPE AFT,
                            (
                            SELECT AFACCTNO,
                            COUNT(*) DEM
                            FROM vw_odmast_all OD
                            WHERE OD.TXDATE BETWEEN  TO_DATE (F_DATE, 'DD/MM/YYYY') AND TO_DATE (T_DATE, 'DD/MM/YYYY')
                            GROUP BY OD.AFACCTNO
                            )OD,(
                                select raf.afacctno, max(rcf.custid) recustid, max(rcf.brid) rebrid
                                from reaflnk raf, recflnk rcf
                                where raf.status='A' and rcf.status='A'
                                    and substr(raf.reacctno,1,10)=rcf.custid
                                group by raf.afacctno
                            ) re, brgrp br
                   WHERE    AF.CUSTID = CF.CUSTID
                   AND      ATYPE.CDTYPE='CF'
                   AND      ATYPE.CDNAME='CUSTTYPE'
                   AND      CF.custtype = ATYPE.CDVAL
                   AND      CTRY.CDTYPE='CF'
                   AND      CTRY.CDNAME='COUNTRY'
                   AND      CF.COUNTRY=CTRY.CDVAL
                   AND      AF.status not in ('P','R','E')
                   AND      CF.Status ='A'
                   AND      OD.AFACCTNO(+) = AF.ACCTNO
                   AND      re.afacctno(+) = AF.custid
                   AND      br.brid = nvl(re.rebrid, cf.brid)
                   AND      AF.OPNDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                   AND      AF.OPNDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                   AND AF.ACTYPE = AFT.ACTYPE
                   AND AFT.mnemonic LIKE L_STRAFTYPE
                   --and      nvl(CF.refname,'-') like V_STRREFNAME
                   AND      CF.Custodycd   LIKE  V_STRREFNAME
                   AND      AF.ACTYPE      LIKE  V_ACTYPE
                   AND      CF.INCOMERANGE LIKE  V_STRINCOMERANGE
                   AND      CF.EDUCATION   LIKE  V_STREDUCATION
                   AND      CF.SECTOR      LIKE  V_STRSECTOR
                   AND      AF.aftype      LIKE  V_STRAFTYPE
                   AND      CF.CAREBY      LIKE  V_STRCAREBY
                --   AND      (INSTR(V_STRBRID, SUBSTR(CF.CUSTID,1,4))>0 or V_STRBRID = SUBSTR(CF.CUSTID,1,4) )
                   ---AND      SUBSTR(AF.acctno,1,4)  LIKE  V_STRPLACE
                   AND      br.brid  LIKE  V_STRPLACE
                   AND      CASE WHEN PV_TRADETYPE = 'ALL' THEN 1
                                 WHEN PV_TRADETYPE = '001' AND NVL(OD.DEM,0) >0 THEN 1
                                 WHEN PV_TRADETYPE = '002' AND NVL(OD.DEM,0) = 0 THEN 1
                            END = 1

                   ORDER BY AF.OPNDATE , AF.CUSTID
                   );
 EXCEPTION
   WHEN OTHERS
   THEN
    --insert into temp_bug(text) values('CF0001');commit;
      RETURN;
END;                                                              -- PROCEDURE
 
 
/
