SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getdate  (busdate IN DATE)
  RETURN  DATE IS

   getdate  DATE;

BEGIN
    
    
 SELECT B.SBDATE INTO getdate FROM
(
SELECT ROWNUM ROWN , A.* FROM
(SELECT * FROM SBCLDR WHERE CLDRTYPE='001' AND HOLIDAY='N' AND SBDATE < busdate  ORDER BY SBDATE DESC)A
)B
WHERE B.ROWN =3;

 RETURN getdate;
EXCEPTION
   WHEN OTHERS THEN
    RETURN SYSDATE;
END;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/
