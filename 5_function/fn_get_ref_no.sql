SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_ref_no (p_drAcctno in varchar2,
                                              p_crAcctno  in varchar2,
                                              p_fxtype    in varchar) return varchar2 is
  l_ref_no  varchar2(250);
  l_ccycd        VARCHAR2(100);
BEGIN
  SELECT ccycd INTO l_ccycd FROM ddmast WHERE acctno = p_drAcctno;
  IF nvl(l_ccycd, 'VND') = 'VND' THEN
    SELECT ccycd INTO l_ccycd FROM ddmast WHERE acctno = p_crAcctno;
  END IF;

  IF nvl(l_ccycd, 'VND') <> 'VND' and p_fxtype ='QUO' THEN
    SELECT note INTO l_ref_no
    FROM exchangerate e
    WHERE e.tradedate = getcurrdate AND e.currency = l_ccycd
    AND e.rtype = p_fxtype AND e.itype = 'SHV';
  else
    l_ref_no :='';
  END IF;
  RETURN l_ref_no;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;
/
