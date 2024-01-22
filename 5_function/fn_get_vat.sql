SET DEFINE OFF;
CREATE OR REPLACE function FN_GET_VAT(P_SALEVALUE VARCHAR2)
return NUMBER
is
v_salevalue  number;
begin
  select VARVALUE into v_salevalue from sysvar where VARNAME='INCOMETAX';
  return v_salevalue * P_SALEVALUE;
EXCEPTION
  WHEN OTHERS THEN
  RETURN 0;
end FN_GET_VAT;

/
