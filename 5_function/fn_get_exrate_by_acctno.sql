SET DEFINE OFF;
CREATE OR REPLACE function fn_get_exrate_by_acctno (p_drAcctno in varchar2,
                                              p_crAcctno  in varchar2,
                                              p_fxtype    in varchar) return number is
  l_exchangeRate NUMBER := 1;
  l_ccycd        VARCHAR2(100);
BEGIN
  SELECT ccycd INTO l_ccycd FROM ddmast WHERE acctno = p_drAcctno;
  IF nvl(l_ccycd, 'VND') = 'VND' THEN
    SELECT ccycd INTO l_ccycd FROM ddmast WHERE acctno = p_crAcctno;
  END IF;

  IF nvl(l_ccycd, 'VND') <> 'VND' THEN
    SELECT e.vnd INTO l_exchangeRate
    FROM exchangerate e
    WHERE e.tradedate = getcurrdate AND e.currency = l_ccycd
    AND e.rtype = p_fxtype AND e.itype = 'SHV';
  END IF;
  RETURN l_exchangeRate;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 1;
END;
/
