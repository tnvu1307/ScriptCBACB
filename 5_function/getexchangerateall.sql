SET DEFINE OFF;
CREATE OR REPLACE FUNCTION GetexchangerateAll (p_rtype     VARCHAR2,
                                               p_currency  VARCHAR2,
                                               p_itype     VARCHAR2,
                                               p_tradedate VARCHAR2)
    RETURN NUMBER IS
    v_exchangerate number := 1;
BEGIN
  SELECT vnd INTO v_exchangerate
  FROM vw_exchangerate_all
  WHERE autoid = (SELECT MAX(autoid) FROM vw_exchangerate_all
                 WHERE RTYPE = p_rtype AND currency = p_currency
                 AND itype = p_itype AND tradedate = TO_DATE(p_tradedate, 'dd/mm/rrrr'));

  RETURN v_exchangerate;
EXCEPTION
   WHEN OTHERS THEN
    RETURN v_exchangerate;
END;
/
