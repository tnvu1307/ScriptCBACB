SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0101 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   P_CUSTODYCD        IN       VARCHAR2

)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LONG     2014-11-21  BAO CAO UY QUYEN HET HAN
-- ---------   ------  -------------------------------------------

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);
   V_CUSTODYCD        VARCHAR2 (10);
BEGIN

   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (P_CUSTODYCD <> '') OR (P_CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD := P_CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%%';
   END IF;
      OPEN PV_REFCURSOR
       FOR
            select CF.CUSTODYCD,  CF.FULLNAME, CF.EMAIL,
                case when CF.IDEXPIRED BETWEEN TO_DATE(F_DATE,'DD/MM/YYYY') AND TO_DATE(T_DATE,'DD/MM/YYYY') then
                CF.IDCODE
                else '' end LICENSENO,
                case when CF.IDEXPIRED BETWEEN TO_DATE(F_DATE,'DD/MM/YYYY') AND TO_DATE(T_DATE,'DD/MM/YYYY') then
                CF.IDEXPIRED
                else null end lnidexpdate,
                case when CFA.EXPDATE BETWEEN TO_DATE(F_DATE,'DD/MM/YYYY') AND TO_DATE(T_DATE,'DD/MM/YYYY')
                then
                REVERSE(SUBSTR(REVERSE(
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,1,1) ='Y' THEN 'I,'END)||
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,2,1) ='Y' THEN 'II,'END)||
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,3,1) ='Y' THEN 'III,'END)||
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,4,1) ='Y' THEN 'IV,'END)||
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,5,1) ='Y' THEN 'V,'END)||
                --( CASE WHEN SUBSTR(CFA.LINKAUTH,6,1) ='Y' THEN 'VI,'END)AUT6,
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,7,1) ='Y' THEN 'VI,'END)||
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,8,1) ='Y' THEN 'VII,'END)||
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,9,1) ='Y' THEN 'VIII,'END)||
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,10,1) ='Y' THEN 'IX,'END)||
                ( CASE WHEN SUBSTR(CFA.LINKAUTH,11,1) ='Y' THEN 'X,'END)
                ),2))
                else ''
                end LINKAUTH,
                /*SUBSTR(linkauth,1,1) CFAU1,
                SUBSTR(linkauth,2,1) CFAU2,
                SUBSTR(linkauth,3,1) CFAU3,
                SUBSTR(linkauth,4,1) CFAU4,
                SUBSTR(linkauth,5,1) CFAU5,
                SUBSTR(linkauth,6,1) CFAU6,
                SUBSTR(linkauth,7,1) CFAU7,
                SUBSTR(linkauth,8,1) CFAU8,
                SUBSTR(linkauth,9,1) CFAU9,
                SUBSTR(linkauth,10,1) CFAU10,
                SUBSTR(linkauth,11,1) CFAU11,*/
                case when CFA.EXPDATE BETWEEN TO_DATE(F_DATE,'DD/MM/YYYY') AND TO_DATE(T_DATE,'DD/MM/YYYY')
                then
                CFA.EXPDATE
                else null end EXPDATE,
                re.brname brname

            from
                cfauth CFA, CFMAST CF,vw_reinfo re
            WHERE CFA.cfcustid = CF.CUSTID
            AND fn_getcarebybroker(cf.custid,TO_DATE(T_DATE,'DD/MM/YYYY')) = re.custid(+)
            AND CF.CUSTODYCD like V_CUSTODYCD
            AND (CFA.EXPDATE BETWEEN TO_DATE(F_DATE,'DD/MM/YYYY') AND TO_DATE(T_DATE,'DD/MM/YYYY')
                OR CF.IDEXPIRED BETWEEN TO_DATE(F_DATE,'DD/MM/YYYY') AND TO_DATE(T_DATE,'DD/MM/YYYY')
                )


                ;
 EXCEPTION
   WHEN OTHERS
   THEN
    --insert into temp_bug(text) values('CF0001');commit;
      RETURN;
END;                                                              -- PROCEDURE
 
 
 
/
