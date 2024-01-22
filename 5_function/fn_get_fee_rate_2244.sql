SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GET_FEE_RATE_2244( PV_TRTYPE IN VARCHAR2, PV_TYPE IN VARCHAR2, PV_FEERATE IN NUMBER, PV_FEECD IN VARCHAR2)
    RETURN NUMBER IS
-- Purpose: TI LE Phi giao dich 2244
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       -------------------------------------------
-- LONGNH   24/11/2014     Created
    V_RESULT NUMBER;
    V_STRTYPE VARCHAR2(30);
    PV_STRTRTYPE  VARCHAR2(30);
    V_FEERATE VARCHAR2(30);
	V_FEECD VARCHAR2(30);
BEGIN
V_STRTYPE:= REPLACE( PV_TYPE,'''','');
PV_STRTRTYPE:= REPLACE( PV_TRTYPE,'''','');
V_FEECD:= REPLACE( PV_FEECD,'''','');
V_RESULT := 0;
IF V_STRTYPE ='002' AND PV_STRTRTYPE='011' then

--longnh PHS_P1_se0005 : chi tinh phi chuyen nhuong cho loai chung khoan la   ko thong san va loai chuyen khoan 011
	if PV_FEERATE =0 then
        V_RESULT := 0.4;
    else
	    V_RESULT :=PV_FEERATE;
	end if;
        --V_RESULT := 1;

END IF;

IF PV_STRTRTYPE='016' THEN
    SELECT FEERATE INTO V_FEERATE FROM  FEEMASTER WHERE FEECD LIKE  '%'||V_FEECD||'%';
    V_RESULT := V_FEERATE;
END IF;




RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
 
 
/
