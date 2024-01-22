SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getbalrightoff (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALDEFOVD NUMBER(20,2);
    l_cimastcheck_arr txpks_check.ddmastcheck_arrtype;
BEGIN
     l_CIMASTcheck_arr := txpks_check.fn_DDMASTcheck(p_afacctno,'CIMAST','ACCTNO');
     --02/12/2015, TruongLD Add de dong bo voi rule check khi thuc hien GD
     --l_BALDEFOVD := least(greatest(l_CIMASTcheck_arr(0).pp,l_CIMASTcheck_arr(0).balance+ l_CIMASTcheck_arr(0).avladvance),l_CIMASTcheck_arr(0).balance + l_CIMASTcheck_arr(0).bamt+ l_CIMASTcheck_arr(0).avladvance);
     l_BALDEFOVD := l_CIMASTcheck_arr(0).Balance;
     --End TruongLD
RETURN l_BALDEFOVD;
EXCEPTION WHEN others THEN
    --
    return 0;
END;
/
