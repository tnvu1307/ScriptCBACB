SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getfxtype( pv_DDACCTNO IN VARCHAR2,pv_DDACCTNO1 IN VARCHAR2,pv_FXTYPE IN VARCHAR2)
    RETURN varchar2 IS

    v_fx_type varchar2(100);
    fx_type varchar2(100);
    fx_type_1 varchar2(100);

BEGIN
    select ccycd into fx_type from ddmast  where ACCTNO = pv_DDACCTNO;
    select ccycd into fx_type_1 from ddmast  where ACCTNO = pv_DDACCTNO1;

    if fx_type = 'USD' and fx_type_1 = 'VND' then
        v_fx_type := 'TTB';
    end if;
    if fx_type = 'VND' and fx_type_1 = 'USD' then
        v_fx_type := 'TTS';
    end if;

    IF v_fx_type IS NULL AND pv_FXTYPE IS NOT NULL THEN
        v_fx_type := pv_FXTYPE;
    END IF;



    RETURN v_fx_type;
EXCEPTION
   WHEN OTHERS THEN
    RETURN pv_FXTYPE;
END;
/
