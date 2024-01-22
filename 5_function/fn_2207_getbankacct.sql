SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_2207_getbankacct( pv_CUSTODYCD IN VARCHAR2, pv_bankacctno in varchar2)
    RETURN VARCHAR2 IS
    v_result varchar2(2000);
    v_count number;
    v_custodycd varchar2(20);
BEGIN
    v_custodycd:=replace(pv_CUSTODYCD,'.');
    select count(*) into v_count from cfmast cf where custodycd = trim(upper(v_custodycd));
    if v_count = 0 then
        RETURN pv_bankacctno;
    end if;

    select count(*) into v_count from vw_cfmast_ddmast_active cf
    where ccycd = 'VND' and filtercd =  trim(upper(v_custodycd)) and upper(trim(REFCASAACCT))=trim(upper(pv_bankacctno));
    if v_count > 0 then
        RETURN pv_bankacctno;
    end if;

    select REFCASAACCT into v_result
    from (
        select * from vw_cfmast_ddmast_active
        where ccycd = 'VND' and filtercd = trim(upper(v_custodycd))
        order by isdefault desc
    ) where rownum <= 1;
    RETURN nvl(v_Result,pv_bankacctno);

EXCEPTION
   WHEN OTHERS THEN
    RETURN pv_bankacctno;
END;
/
