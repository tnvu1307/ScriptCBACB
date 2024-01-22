SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_OD_LastQTTYInDay(p_porderid IN varchar2)
  RETURN VARCHAR2 IS
    v_Result VARCHAR2(200);
    l_reforderid varchar2(20);
    l_porderid varchar2(200);
BEGIN
/*
Truyen vao oderid cua cua 1 lenh
Ham nay tra ve KL dat/sua lenh cuoi cung trong ngay
*/
    v_Result:=0;
    select quantity into v_Result
    from (
        select orgacctno, quantity 
        from fomast
        where substr(fn_od_parentsoderid(orgacctno),-16,16)=p_porderid
        order by orgacctno desc
    )
    where ROWNUM<=1;

    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN null;
END;
 
 
 
 
/
