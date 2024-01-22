SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_amtvat(pv_camastid IN VARCHAR2,pv_custodycd IN VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(50);
    v_amt number;
    l_EXERCISERATIO   number;
    l_catype          varchar2(20);
    l_codeid varchar2(10);
    l_camastid varchar2(50);
    l_custid varchar2(50);
    l_vat varchar2(1);
    l_pitratemethod varchar2(50);
    l_PITRATE number;
    l_INTAMT number;
    l_balance number;
    l_EXPRICE number;
    l_AMTDTL number;
    l_AMT number;
BEGIN
/*============================================================*/
    select catype,codeid into l_catype,l_codeid from camast where camastid = pv_CAMASTID;
    select  to_number(SUBSTR(EXERCISERATIO,0,INSTR(EXERCISERATIO,'/') - 1))/to_number(SUBSTR(EXERCISERATIO,INSTR(EXERCISERATIO,'/')+1,LENGTH(EXERCISERATIO)))  into l_EXERCISERATIO
    from sbsecurities
    where codeid = l_codeid;
    select cf.vat,af.acctno into l_vat,l_custid From cfmast cf, afmast af where cf.custid=af.custid and  custodycd=pv_custodycd;
    select amt into l_AMT from caschd where camastid=pv_camastid and afacctno=l_custid;

    if l_vat='Y' then
       v_Result:= l_AMT;
    end if;

RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
