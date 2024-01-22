SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getexchangeamt( pv_DDACCTNO IN VARCHAR2,pv_AMT IN NUMBER,pv_EXCHANGERATE IN NUMBER)
    RETURN NUMBER IS
     N_RESULT NUMBER;
     fx_type varchar2(100);

BEGIN
    N_RESULT := 0;
    select ccycd into fx_type from ddmast  where ACCTNO = pv_DDACCTNO;

    IF fx_type = 'VND' THEN
        N_RESULT := round(pv_AMT / pv_EXCHANGERATE,2);
    ELSE
        N_RESULT := round(pv_AMT * pv_EXCHANGERATE);
    END IF;



    RETURN N_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN N_RESULT;
END;
/
