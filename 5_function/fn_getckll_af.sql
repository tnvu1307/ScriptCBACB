SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getckll_af (pv_afacctno IN VARCHAR2, pv_codeid IN VARCHAR2)
RETURN NUMBER
iS
    v_result NUMBER(20);
    l_seacctno VARCHAR2(20);
    l_AVLSEWITHDRAW number(20);
    l_tradelot number(20,4);
BEGIN
    /*SELECT  SUM(mod(se.trade,sec.tradelot))
                INTO v_result
        FROM semast se, afmast af, securities_info sec
            WHERE se.afacctno = af.acctno  AND se.codeid = sec.codeid
                    AND af.acctno = pv_afacctno  AND se.codeid = pv_codeid;*/

    SELECT max(tradelot), mod(sum(greatest(se.trade - NVL (b.secureamt, 0) + NVL(b.sereceiving,0),0)),max(tradelot))
                INTO l_tradelot,v_result
        FROM semast se, afmast af, securities_info sec,
            v_getsellorderinfo b
            WHERE se.afacctno = af.acctno
                AND se.acctno = b.seacctno(+)
                AND se.codeid = sec.codeid AND af.acctno = pv_afacctno
                AND se.codeid = pv_codeid;


    --26/09/2017 TruongLD Add theo yeu cau cua PHS, khi ban CK lo le --> phai dam bao ty le an toan
    l_seacctno := pv_afacctno || pv_codeid;
    l_AVLSEWITHDRAW := getavlsewithdraw(l_seacctno);

    --l_AVLSEWITHDRAW := mod(l_SEWITHDRAWcheck_arr(0).AVLSEWITHDRAW, l_tradelot);

    v_result :=  LEAST(l_AVLSEWITHDRAW, v_result);
    --End TruongLD

    RETURN v_result;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
 
 
/
