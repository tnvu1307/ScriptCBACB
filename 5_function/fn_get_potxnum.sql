SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_potxnum RETURN VARCHAR2 is
    l_potxnum VARCHAR2(10);
begin
    -- Lay thong tin bang ke
    SELECT NVL(MAX(ODR)+1,1) into l_potxnum
    FROM (
            SELECT ROWNUM ODR, INVACCT
            FROM (SELECT TXNUM INVACCT FROM POMAST WHERE BRID = '0001' ORDER BY TXNUM)
         );

    SELECT '0001' || LPAD (l_potxnum, 6, '0')
        INTO l_potxnum
    FROM DUAL;

    RETURN l_potxnum;
end;
 
 
 
 
/
