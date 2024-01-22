SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_billingmonth(p_date VARCHAR2)
return VARCHAR2
is
begin
  return SUBSTR(p_date,4,10);
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
end;
/
