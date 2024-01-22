SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_se_fee_2244( PV_TRTYPE IN VARCHAR2, PV_TYPE IN VARCHAR2, PV_QTTY IN VARCHAR2, PV_PARVALUE IN NUMBER, PV_FEERATE IN NUMBER, PV_FEECD IN VARCHAR2 )
    RETURN NUMBER IS
-- Purpose: Phi giao dich 2244
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       -------------------------------------------
-- NAMNT   09/09/2013     Created
    V_RESULT NUMBER;
    V_STRTYPE VARCHAR2(30);
    PV_STRTRTYPE  VARCHAR2(30);
    v_feerate NUMBER;
	V_FEEAMT NUMBER;
	V_FEECD VARCHAR2(30);
BEGIN
V_STRTYPE:= REPLACE( PV_TYPE,'''','');
PV_STRTRTYPE:= REPLACE( PV_TRTYPE,'''','');
V_FEECD:= REPLACE( PV_FEECD,'''','');
v_feerate := pv_feerate;

V_RESULT := 0;
IF V_STRTYPE ='002' AND PV_STRTRTYPE='011' then

    /*if PV_STRTRTYPE='002' THEN
        V_RESULT := PV_QTTY*PV_PARVALUE*0.1/100;
    end if;*/


--longnh PHS_P1_se0005 : chi tinh phi chuyen nhuong cho loai chung khoan la   ko thong san va loai chuyen khoan 011


        V_RESULT := PV_QTTY*PV_PARVALUE*v_feerate/100;
        --V_RESULT := 1;
end if;



/*ELSE
    if PV_STRTRTYPE='002' THEN
        V_RESULT := PV_QTTY*PV_PARVALUE*0.1/100;
    else
        V_RESULT := 0;
    end if;
*/


    /*if PV_STRTRTYPE='014' THEN

        V_RESULT := case when  PV_QTTY*0.5 < 500000 then  PV_QTTY*0.5 else 500000 end   ;
    end if;*/

	IF PV_STRTRTYPE='016'  THEN
		SELECT FEEAMT INTO V_FEEAMT from feemaster WHERE FEECD LIKE  '%'||V_FEECD||'%';

			V_RESULT := GREATEST(PV_QTTY*PV_PARVALUE*v_feerate/100,V_FEEAMT);


	END IF;


RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
 
 
/
