SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE update_signature(V_AUTOID NUMBER,V_SIGNATURE VARCHAR2, V_VALDATE VARCHAR2, V_EXPDATE VARCHAR2,v_DESCRIPTION VARCHAR2 )IS
    LONGLITERAL VARCHAR2(32767);

    BEGIN
       LONGLITERAL:=V_SIGNATURE;
       UPDATE CFSIGN
       SET SIGNATURE=LONGLITERAL, VALDATE = TO_DATE(V_VALDATE,'DD/MM/YYYY'),
           EXPDATE = TO_DATE(V_EXPDATE,'DD/MM/YYYY'),DESCRIPTION = v_DESCRIPTION
       WHERE AUTOID=V_AUTOID;

    END ;
 
 
 
 
 
 
 
 
 
 
 
 
/
