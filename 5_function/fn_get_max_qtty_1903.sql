SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GET_MAX_QTTY_1903(P_CUSTODYCD VARCHAR2, P_BONDCODE VARCHAR2)
RETURN NUMBER
IS
V_TRADE NUMBER;
BEGIN

    SELECT BO.TRADE INTO V_TRADE FROM BONDSEMAST BO WHERE BO.CUSTODYCD = P_CUSTODYCD AND BO.BONDCODE = P_BONDCODE;
    RETURN(V_TRADE);
EXCEPTION WHEN OTHERS THEN
    RETURN(0);
END FN_GET_MAX_QTTY_1903;
/
