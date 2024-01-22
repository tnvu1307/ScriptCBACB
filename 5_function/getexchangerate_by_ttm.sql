SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getexchangerate_by_ttm( pv_CCYCD IN VARCHAR2)
    RETURN NUMBER IS

    v_exchangerate number ;
BEGIN
    select vnd into v_exchangerate from EXCHANGERATE
    where currency =pv_CCYCD and autoid =(select max(autoid) from EXCHANGERATE where currency =pv_CCYCD and rtype = 'TTM' );


    RETURN v_exchangerate;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
