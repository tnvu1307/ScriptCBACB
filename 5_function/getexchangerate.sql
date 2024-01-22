SET DEFINE OFF;
CREATE OR REPLACE FUNCTION Getexchangerate( pv_CCYCD IN VARCHAR2)
    RETURN NUMBER IS

    v_exchangerate number ;
BEGIN
    select vnd into v_exchangerate from EXCHANGERATE
    where currency =pv_CCYCD and autoid =(select max(autoid) from EXCHANGERATE where currency =pv_CCYCD and rtype = 'TTS' );


    RETURN v_exchangerate;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
