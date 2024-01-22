SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE insert_cfauth
(
    V_CUSTID varchar2, V_SIGNATURE varchar2, V_VALDATE varchar2, V_EXPDATE varchar2,V_AUTOID NUMBER,
    v_LINKAUTH varchar2, v_FULLNAME varchar2, v_ADDRESS varchar2, v_TELEPHONE varchar2, v_LICENSENO varchar2,
    v_BANKNAME varchar2, v_LNPLACE varchar2, v_LNIDDATE varchar2,v_EMAIL varchar2
) IS

    BEGIN
        INSERT INTO CFAUTH (AUTOID, CFCUSTID, SIGNATURE, VALDATE, EXPDATE,
            LINKAUTH,FULLNAME,ADDRESS,TELEPHONE,LICENSENO,DELTD,BANKNAME,LNPLACE,LNIDDATE,EMAIL) VALUES
        (V_AUTOID, V_CUSTID, V_SIGNATURE, TO_DATE(V_VALDATE,'DD/MM/RRRR'), TO_DATE(V_EXPDATE,'DD/MM/RRRR'),
        v_LINKAUTH, v_FULLNAME, v_ADDRESS, v_TELEPHONE, v_LICENSENO,'N', v_BANKNAME, v_LNPLACE, TO_DATE(v_LNIDDATE,'DD/MM/RRRR'),v_EMAIL);

    END ;
/
