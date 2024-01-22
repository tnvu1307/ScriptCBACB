SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_ccycd(PV_FEEINPUT IN VARCHAR2,  PV_FEENAME IN VARCHAR2,PV_CCYCD VARCHAR2)
RETURN varchar2
IS
  V_RESULT varchar2(250);
BEGIN

    V_RESULT:='VND';
    IF PV_FEEINPUT = '001' THEN
        V_RESULT := PV_CCYCD;
    end if;
    IF PV_FEEINPUT = '002' THEN
        SELECT CCYCD INTO V_RESULT  fROM FEEMASTER WHERE FEECD  = PV_FEENAME;
    END IF;

    RETURN V_RESULT;
    EXCEPTION WHEN OTHERS THEN RETURN 'VND';
END;
/
