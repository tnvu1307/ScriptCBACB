SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SMS_TOKEN
(USERNAME, TOKEN)
AS 
SELECT USERNAME , TOKENID  TOKEN
FROM userlogin WHERE TOKENID IS NOT NULL 
ORDER BY USERNAME
/
