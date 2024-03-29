SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_RM_GETBANKREF
(BANKCODE, ROOTCODE, BANKNAME, STATUS)
AS 
SELECT CRB.ROOTCODE BANKCODE,CRB.ROOTCODE,
DECODE(CRB.ROOTCODE,'BIDV','BIDV Bank','BVB','Bao Viet Bank','DAB','Dong A Bank','STB','Sacombank') BANKNAME
,CRB.STATUS
FROM (
    SELECT ROOTCODE,MAX(STATUS) STATUS FROM CRBDEFBANK GROUP BY ROOTCODE
) CRB
/
