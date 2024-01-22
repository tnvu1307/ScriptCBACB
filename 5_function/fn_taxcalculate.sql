SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_taxcalculate(p_amt number, p_tltx varchar2)
return varchar2
is
v_feemfeecd varchar2(20);
v_vatrate number;
v_ccycd varchar2(10);
begin
  SELECT FEECD INTO v_feemfeecd   FROM feemap WHERE  tltxcd =p_tltx;
  SELECT VATRATE, CCYCD INTO v_vatrate, v_ccycd from FEEMASTER where FEECD=v_feemfeecd;
  return v_vatrate*p_amt || '_' || v_ccycd;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
end;
/
