SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_CHECK_ESCROW_IICA( pv_custodycd IN VARCHAR2, pv_iica in varchar2)

--Ham check neu NDT nuoc ngoai bat buoc phai nhap IICA
--Neu co tra ve True, neu ko tra ve False
    RETURN varchar2 IS
    l_country varchar2(20);
    v_result varchar2(10);
BEGIN
    --v_codeid := nvl(substr(pv_codeid,2,LENGTH(pv_codeid)-1),'--ALL--');
    select max(cf.country) into l_country from cfmast cf where custodycd = trim(replace(upper(pv_custodycd),'.',''));
    if nvl(l_country,'234') <> '234' and length(pv_iica)=0 then
        v_result := 'False';
    else
        v_result := 'True';
    end if;
    
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 'False';
END;
/
