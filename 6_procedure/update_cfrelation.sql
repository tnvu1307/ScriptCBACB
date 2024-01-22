SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE update_cfrelation
(
    V_CUSTID varchar2, V_SIGNATURE varchar2, V_ACDATE varchar2, V_AUTOID NUMBER,
    v_FULLNAME varchar2, v_ADDRESS varchar2, v_TELEPHONE varchar2, v_LICENSENO varchar2,
    v_LNPLACE varchar2, v_LNIDDATE varchar2, v_RETYPE varchar2, v_RECUSTID varchar2,
    v_ACTIVES varchar2, v_DESCRIPTION varchar2, v_HOLDING varchar2,v_EMAIL varchar2,v_TITLECFRELATION varchar2
) IS
 LONGLITERAL VARCHAR2(32767);
    BEGIN
        LONGLITERAL:=V_SIGNATURE;

        UPDATE CFRELATION SET CUSTID = V_CUSTID,  SIGNATURE = LONGLITERAL, ACDATE = TO_DATE(V_ACDATE,'DD/MM/RRRR'),
           FULLNAME = v_FULLNAME, ADDRESS = v_ADDRESS, TELEPHONE = v_TELEPHONE, LICENSENO = v_LICENSENO,
           LNPLACE = v_LNPLACE, LNIDDATE = TO_DATE(v_LNIDDATE,'DD/MM/RRRR'),  RETYPE = v_RETYPE, RECUSTID = v_RECUSTID,
           DESCRIPTION = v_DESCRIPTION,HOLDING=v_HOLDING,EMAIL=v_EMAIL, TITLECFRELATION= v_TITLECFRELATION
        WHERE AUTOID = V_AUTOID;

exception
      when others then
        plog.error('update_cfrelation.' || sqlerrm || dbms_utility.format_error_backtrace);
    END ;
/
