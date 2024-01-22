SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0103 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   P_CUSTODY          IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2,
   I_BRID           IN       VARCHAR2,
   RECUSTODYCD      IN       VARCHAR2,
   PV_PROBRKMSTTYPE  IN       VARCHAR2

)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LONG     2014-11-27  Chi tiet bieu phi? dac biet tr?tung khach hang
-- ---------   ------  -------------------------------------------

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);
   V_CUSTODYCD        VARCHAR2 (10);

   V_AFACCTNO         VARCHAR2 (10);
   V_BRID             VARCHAR2 (4);
   V_RECUSTODYCD      VARCHAR2 (10);
   V_PROBRKMSTTYPE    VARCHAR2 (2);
   V_FDATE            DATE;
   V_TDATE            DATE;
   v_curr date;
BEGIN

   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF P_CUSTODY = 'ALL' THEN
        V_CUSTODYCD := '%';
   ELSE
        V_CUSTODYCD := P_CUSTODY;
   END IF;

   IF PV_AFACCTNO = 'ALL' THEN
        V_AFACCTNO := '%';
   ELSE
        V_AFACCTNO := PV_AFACCTNO;
   END IF;

   IF I_BRID = 'ALL' THEN
        V_BRID := '%';
   ELSE
        V_BRID := I_BRID;
   END IF;

   IF RECUSTODYCD = 'ALL' THEN
        V_RECUSTODYCD := '%';
   ELSE
        V_RECUSTODYCD := RECUSTODYCD;
   END IF;

   IF PV_PROBRKMSTTYPE = 'ALL' THEN
        V_PROBRKMSTTYPE := '%';
   ELSE
        V_PROBRKMSTTYPE := PV_PROBRKMSTTYPE;
   END IF;

   v_curr:=getcurrdate;
   --V_FDATE:=to_date(F_DATE,'DD/MM/RRRR');
   --V_TDATE:=to_date(T_DATE,'DD/MM/RRRR');



      OPEN PV_REFCURSOR
       FOR
        SELECT
               BR.BRNAME BRNAME,
               nvl(RE.CUSTID,'') RECUSTID,
               nvl(RE.FULLNAME,'') REFULLNAME,
               CF1.CUSTODYCD,
               CF.AFACCTNO,
               CF1.FULLNAME FULLNAME,
               ODFEERATE,
               ODVALDATE,
               ODEXPDATE,
               ADFEERATE,
               ADVALDATE,
               ADEXPDATE,
               LNFEERATE,
               LNVALDATE,
               LNEXPDATE
        FROM (
            SELECT KAF.AFACCTNO,
            MAX(CASE WHEN probrkmsttype = 'OD' THEN FEERATE END) ODFEERATE,
            MAX(CASE WHEN probrkmsttype = 'OD' THEN VALDATE END) ODVALDATE,
            MAX(CASE WHEN probrkmsttype = 'OD' THEN EXPDATE END) ODEXPDATE,

            MAX(CASE WHEN probrkmsttype = 'AD' THEN FEERATE END) ADFEERATE,
            MAX(CASE WHEN probrkmsttype = 'AD' THEN VALDATE END) ADVALDATE,
            MAX(CASE WHEN probrkmsttype = 'AD' THEN EXPDATE END) ADEXPDATE,

            MAX(CASE WHEN probrkmsttype = 'LN' THEN FEERATE END) LNFEERATE,
            MAX(CASE WHEN probrkmsttype = 'LN' THEN VALDATE END) LNVALDATE,
            MAX(CASE WHEN probrkmsttype = 'LN' THEN EXPDATE END) LNEXPDATE

            FROM ODPROBRKMST MST, ODPROBRKAF KAF
            WHERE MST.AUTOID = KAF.REFAUTOID
            AND probrkmsttype IN ('OD','AD','LN')
            AND probrkmsttype LIKE V_PROBRKMSTTYPE
            AND MST.STATUS = 'A'
            AND MST.EXPDATE >= v_curr
            AND MST.VALDATE <= v_curr
            GROUP BY AFACCTNO
            ) CF,
             CFMAST CF1, AFMAST AF,
             (
                select ra.afacctno, ra.custid,cf.fullname, ra.brid
                from
                (
                    select ra.afacctno, max(rc.custid) custid,max(rc.brid) brid
                    from reaflnk ra, recflnk rc
                    where ra.status <> 'P' and rc.status <> 'P' and ra.status='A' and rc.status='A'
                        and rc.effdate <= v_curr and rc.expdate > v_curr
                        and ra.frdate <= v_curr and nvl(ra.clstxdate,ra.todate) > v_curr
                        and SUBSTR(ra.reacctno,1,10) = rc.custid
                    group by ra.afacctno
                ) ra, cfmast cf
                where ra.custid=cf.custid
             ) RE, brgrp br
        WHERE --FN_GETCAREBYBROKER(AF.CUSTID,GETCURRDATE)  = RE.CUSTID(+)
        AF.CUSTID = RE.AFACCTNO(+)
        AND BR.BRID = NVL(RE.BRID,CF1.BRID)
        AND CF.AFACCTNO = AF.ACCTNO
        AND AF.CUSTID = CF1.CUSTID
        AND CF1.STATUS <> 'C'
        and CF1.CUSTODYCD LIKE V_CUSTODYCD
        AND AF.ACCTNO  LIKE V_AFACCTNO
        AND BR.BRID LIKE V_BRID
        AND NVL(RE.CUSTID,'1') LIKE V_RECUSTODYCD

       ;
 EXCEPTION
   WHEN OTHERS
   THEN
    --insert into temp_bug(text) values('CF0001');commit;
      RETURN;
END;                                                              -- PROCEDURE
 
 
/
