SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE INSERT_CFSIGNMEMO(V_CUSTID varchar2, V_SIGNATURE varchar2, V_VALDATE varchar2, V_EXPDATE varchar2,V_AUTOID NUMBER,V_DESC varchar2) IS
v_custtype varchar2(1);
    BEGIN

        select custtype into v_custtype from cfmast where custid=v_custid;
        if v_custtype = 'I' then
            update CFSIGN set EXPDATE = getcurrdate where custid=v_custid;
        end if;

        INSERT INTO CFSIGNMEMO (AUTOID, CUSTID, SIGNATURE, VALDATE, EXPDATE, DESCRIPTION) VALUES
            (V_AUTOID, V_CUSTID, V_SIGNATURE, TO_DATE(V_VALDATE,'DD/MM/RRRR'), TO_DATE(V_EXPDATE,'DD/MM/RRRR'), V_DESC);
    END ;

 
 
 
 
 
/
