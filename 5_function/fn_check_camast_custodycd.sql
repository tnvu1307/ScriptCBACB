SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_CHECK_CAMAST_CUSTODYCD
(
pv_CAMASTID IN Varchar2,
pv_CUSTODYCD IN Varchar2,
pv_AFACCTNO IN Varchar2
) RETURN  number IS
v_count number;
BEGIN
    select count(*) into v_count
    from v_ca3383 Where custodycd=pv_CUSTODYCD
        and afacctno=pv_AFACCTNO and replace(camastid,'.')=replace(pv_CAMASTID,'.');

    IF v_count=0 and substr(pv_CUSTODYCD,0,3)='SHV' THEN
        return -1;
    END IF;

    return 0;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
