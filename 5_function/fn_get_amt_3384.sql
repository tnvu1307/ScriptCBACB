SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_amt_3384 (P_CAMASTID VARCHAR2, P_BALANCE NUMBER, P_EXPRICE NUMBER) RETURN NUMBER
IS
    V_QTTY NUMBER;
    V_RIGHTOFFRATE VARCHAR(50);
    V_ROUNDMETHOD number;
    L_LEFT_RIGHTOFFRATE VARCHAR2(30);
    L_RIGHT_RIGHTOFFRATE VARCHAR2(30);
BEGIN
    SELECT RIGHTOFFRATE, ROUNDMETHOD INTO V_RIGHTOFFRATE, V_ROUNDMETHOD FROM CAMAST WHERE CAMASTID = P_CAMASTID AND DELTD='N' AND ROWNUM = 1;

    SELECT SUBSTR(V_RIGHTOFFRATE,1,INSTR(V_RIGHTOFFRATE,'/')-1),
           SUBSTR(V_RIGHTOFFRATE,INSTR(V_RIGHTOFFRATE,'/') + 1,LENGTH(V_RIGHTOFFRATE))
    INTO L_LEFT_RIGHTOFFRATE, L_RIGHT_RIGHTOFFRATE
    FROM DUAL;

    V_QTTY := FN_ROUND_AMTQTTY(P_BALANCE * L_RIGHT_RIGHTOFFRATE / L_LEFT_RIGHTOFFRATE, V_ROUNDMETHOD, 0);

    RETURN V_QTTY * P_EXPRICE;
EXCEPTION WHEN OTHERS THEN
       RETURN 0;
END;
/
