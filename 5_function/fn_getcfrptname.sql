SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getcfrptname( p_afacctno IN VARCHAR2)
    RETURN varchar2 IS
    l_reportname varchar2(100);
BEGIN
    select max(case when cf.custtype = 'I' and cf.country = '234' then 'CFAF01|CFAF11'
            when cf.custtype = 'B' and cf.country = '234' then 'CFAF02|CFAF12'
            when cf.custtype = 'I' and cf.country <> '234' then 'CFAF03|CFAF13'
            when cf.custtype = 'B' and cf.country <> '234' then 'CFAF04|CFAF14'
            else '' end)
           into l_reportname
    from cfmast cf
    where cf.custid = p_afacctno;

    RETURN l_reportname;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;

 
 
 
 
 
 
 
 
 
 
/
