SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_regexp_substr (
  p_string    VARCHAR2,
  p_delimiter CHAR DEFAULT ','
)
RETURN typ_str2tbl_nst PIPELINED
AS
  l_tmp VARCHAR2(32000) := p_string || p_delimiter;
  l_pos NUMBER;
BEGIN
  LOOP
    l_pos := INSTR( l_tmp, p_delimiter );
    EXIT WHEN NVL( l_pos, 0 ) = 0;
    PIPE ROW ( RTRIM( LTRIM( SUBSTR( l_tmp, 1, l_pos-1) ) ) );
    l_tmp := SUBSTR( l_tmp, l_pos+1 );
  END LOOP;
END fn_REGEXP_SUBSTR;
/
