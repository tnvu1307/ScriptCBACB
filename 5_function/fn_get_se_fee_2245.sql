SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_se_fee_2245( PV_TRTYPE IN VARCHAR2, PV_TYPE IN VARCHAR2, PV_QTTY IN VARCHAR2, PV_PARVALUE IN NUMBER,PV_FEERATE IN NUMBER)
    RETURN NUMBER IS
-- Purpose: Phi giao dich 2244
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       -------------------------------------------
-- NAMNT   09/09/2013     Created
    V_RESULT NUMBER;
    V_STRTYPE VARCHAR2(30);
    PV_STRTRTYPE  VARCHAR2(30);
BEGIN
V_STRTYPE:= REPLACE( PV_TYPE,'''','');
PV_STRTRTYPE:= REPLACE( PV_TRTYPE,'''','');
V_RESULT := 0;
IF V_STRTYPE ='002' THEN
--longnh PHS_P1_se0005 : chi tinh phi chuyen nhuong cho loai chung khoan la   ko thong san va loai chuyen khoan 011
    if PV_STRTRTYPE='011' or PV_STRTRTYPE='002'  then
        V_RESULT := PV_QTTY*PV_PARVALUE*PV_FEERATE/100;
    end if;

ELSE
V_RESULT := 0;

END IF ;



RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
 
 
/
