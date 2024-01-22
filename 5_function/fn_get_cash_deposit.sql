SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GET_CASH_DEPOSIT(
  pv_symbol IN varchar2,
  pv_actype IN varchar2,
  pv_sectype IN varchar2,
  pv_valmethod IN varchar2)
  RETURN number IS
  v_Result number(18,5);
  v_Xparam number;
BEGIN
    SELECT XPARAM INTO v_Result
    FROM BONDTYPE
    WHERE INSTR(TICKERLIST, pv_symbol) > 0 AND
          ACTYPE = pv_actype AND
          SECTYPE = pv_sectype AND
          VALMETHOD = pv_valmethod;
  RETURN v_Result;
  EXCEPTION
  WHEN OTHERS THEN RETURN 0;
END;
/
