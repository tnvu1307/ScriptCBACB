SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_defacctno_1720 (p_custid    VARCHAR2,

                                            p_ccycd    VARCHAR2
                                          ) return VARCHAR is
l_acctno    VARCHAR2(100);
l_ccycd     VARCHAR2(100);
l_condition varchar2(100);
begin
  IF  p_ccycd = 'VND' then -- TK ghi giam mua ngoai te = VND
       SELECT acctno INTO l_acctno FROM ddmast d
       WHERE custid = p_custid AND ccycd =p_ccycd
       AND d.refcasaacct IS NOT NULL AND d.status <> 'C' and d.isdefault='Y'
       AND rownum = 1 ;
  ELSE
       SELECT acctno INTO l_acctno FROM ddmast d
       WHERE custid = p_custid AND ccycd = p_ccycd
       AND d.refcasaacct IS NOT NULL AND d.status <> 'C'
       AND rownum = 1 ;
  END IF;



  RETURN l_acctno;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(SQLERRM || dbms_utility.format_error_backtrace);
    RETURN '';
END;
/
