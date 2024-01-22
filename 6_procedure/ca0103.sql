SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CA0103 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CACODE         IN       VARCHAR2
)
IS
--
--
--longnh 2014-11-27 giay bao dang ky quyen mua gui chi nhanh
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);



-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN

   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS




OPEN PV_REFCURSOR
    FOR
SELECT 	ISS.FULLNAME ISS_NAME,
		A.CDCONTENT TRADEPLACE,
		CA.SYMBOL,
		CA.REPORTDATE,
		CA.KHQDATE,
		CA.FRDATETRANSFER,
		CA.TODATETRANSFER,
		ca.BEGINDATE,
		ca.DUEDATE,
		replace(ca.rightoffrate,'/',' : ') rightoffrate,
		ca.ADVDESC,
		exprice
FROM V_CAMAST CA, sbsecurities SB,issuers ISS, ALLCODE A
WHERE CA.CODEID = SB.CODEID
AND SB.issuerid = ISS.issuerid
AND SB.TRADEPLACE = A.CDVAL
AND A.CDTYPE = 'SA' AND CDNAME = 'TRADEPLACE'
and typeid = '014'
AND CA.VALUE like CACODE

;


 EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
END;                                                              -- PROCEDURE
 
 
 
 
/
