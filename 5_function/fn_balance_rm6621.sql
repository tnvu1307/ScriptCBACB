SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_balance_rm6621(PV_REFCASAACCT IN VARCHAR2)
    RETURN NUMBER IS
     L_RESULT  NUMBER;
   BEGIN 
   BEGIN
          SELECT DD.BALANCE INTO L_RESULT
            FROM DDMAST DD 
            WHERE DD.ACCTNO=PV_REFCASAACCT; 
    RETURN L_RESULT;
    END;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
