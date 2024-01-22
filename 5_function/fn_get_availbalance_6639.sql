SET DEFINE OFF;
CREATE OR REPLACE function FN_GET_AVAILBALANCE_6639(PV_ACCTNO varchar2) return  NUMBER is
  v_result number(20,4);
begin
  BEGIN
  select to_number(ci.balance) into v_result  FROM ddmast ci
  where ci.acctno = PV_ACCTNO;
  EXCEPTION WHEN OTHERS THEN
    v_result:= 0;
  END;
  RETURN v_result;
END FN_GET_AVAILBALANCE_6639;
/
