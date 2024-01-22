SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_ClearDataOfControl(pv_ISTRFBUY In VARCHAR2, pv_DPLNTYPE in VARCHAR2) RETURN VARCHAR2
IS
    v_Result  VARCHAR2(20);
    v_CompanySourceID VARCHAR2(20);
BEGIN


    If pv_ISTRFBUY ='Y' then
        v_Result := pv_DPLNTYPE;
    Else
        v_Result :='';
    End If;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
