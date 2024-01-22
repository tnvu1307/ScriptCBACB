SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf8009 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2
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
   V_STRBRID          VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_STRREFNAME       VARCHAR2 (50);
BEGIN
-- insert into temp_bug(text) values('CF0001');commit;
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

   IF (CUSTODYCD <> 'ALL')
   THEN
      V_STRREFNAME:= CUSTODYCD;
   ELSE
      V_STRREFNAME := '%';
   END IF;

   -- END OF GETTING REPORT'S PARAMETERS
   -- GET REPORT'S DATA
--   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
--   THEN
      OPEN PV_REFCURSOR
       FOR
          SELECT C.CUSTID, c.custodycd, c.shortname, c.Fullname, c.Dateofbirth, c.idtype, c.idcode, c.idplace, c.address, c.phone, c.sex,
                 c.province, c.country
          FROM CFMAST C
          WHERE c.custodycd LIKE V_STRREFNAME;

 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;

 
 
/
