SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_tax_calc_1906(pv_amount NUMBER, pv_boautoid varchar2) RETURN  NUMBER IS
   v_pitrate  number;
   v_pitratemethod varchar2(5);
   v_vat    varchar2(2);
   v_tax number;
   v_country varchar2(3);
BEGIN
   select ca.pitrate,ca.pitratemethod,cf.vat,cf.country
   into v_pitrate,v_pitratemethod,v_vat,v_country
    from bondcaschd bo, cfmast cf, camast ca
    where bo.custodycd = cf.custodycd
    and bo.camastid = ca.camastid
    and bo.autoid = pv_boautoid;
    if v_vat = 'N' then
        v_tax := 0;
    else
        if (v_pitratemethod = 'IS' and v_country <> '234') or v_pitratemethod = 'SC' then
            v_tax := v_pitrate * pv_amount/100;
        else
            v_tax := 0;
        end if;
    end if;
   return v_tax;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
/
