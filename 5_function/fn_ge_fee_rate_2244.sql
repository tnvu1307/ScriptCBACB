SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GE_FEE_RATE_2244( PV_TRTYPE IN VARCHAR2, PV_TYPE IN VARCHAR2, PV_FEERATE IN NUMBER)
    RETURN NUMBER IS
-- Purpose: Phi giao dich 2244
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       -------------------------------------------
-- LONGNH   23/11/2014     Created
    V_RESULT NUMBER;
    V_STRTYPE VARCHAR2(30);
    PV_STRTRTYPE  VARCHAR2(30);
    v_feerate NUMBER;
BEGIN
V_STRTYPE:= REPLACE( PV_TYPE,'''','');
PV_STRTRTYPE:= REPLACE( PV_TRTYPE,'''','');
v_feerate := pv_feerate;
V_RESULT := 0;
IF V_STRTYPE ='002' then

--longnh PHS_P1_se0005 : chi tinh phi chuyen nhuong cho loai chung khoan la   ko thong san va loai chuyen khoan 011
    if PV_STRTRTYPE='011' THEN

        V_RESULT := PV_FEERATE;
        --V_RESULT := 1;
    end if;
ELSE 
   V_RESULT := 0;
END IF;




RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
 
 
/
