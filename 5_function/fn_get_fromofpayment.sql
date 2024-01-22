SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GET_FROMOFPAYMENT(pv_CAMASTID In VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(250);

BEGIN
   SELECT al.CDCONTENT INTO v_Result FROM camast ca , allcode al 
   WHERE ca.camastid= pv_CAMASTID 
   and ca.catype='023' AND deltd='N'
   and ca.formofpayment=al.cdval
   and al.CDNAME='FORMOFPAYMENT' AND al.CDTYPE='CA' 
   ORDER BY al.CDVAL;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
