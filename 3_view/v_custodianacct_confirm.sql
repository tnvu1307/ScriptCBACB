SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CUSTODIANACCT_CONFIRM
(AUTOID, CUSTODYCD, ACTYP, SYMBOL, NOTES, 
 CREATEDBY, TXDATE, TXNUM, DES_ACTYP, DES_STATUS, 
 STATUS)
AS 
SELECT AUTOID, CUSTODYCD, ACTYP, SYMBOL, NOTES, CREATEDBY, TXDATE, TXNUM,
A0.CDCONTENT DES_ACTYP, A1.CDCONTENT DES_STATUS, STATUS
FROM CUSTODIANACCT MST, ALLCODE A0, ALLCODE A1
WHERE A0.CDTYPE='SA' AND A0.CDNAME='3RDACTYP' AND A0.CDVAL=MST.ACTYP
AND A1.CDTYPE='SA' AND A1.CDNAME='3RDSTATUS' AND A1.CDVAL=MST.STATUS
/
