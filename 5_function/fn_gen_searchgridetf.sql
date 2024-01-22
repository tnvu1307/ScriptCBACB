SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_searchgridetf(pv_strdt In VARCHAR2,pv_id number)
    RETURN VARCHAR2 IS
 v_Result varchar2(1000)  ;
BEGIN

IF pv_id =0 THEN

SELECT sb.symbol INTO v_Result
    FROM dual ,sbsecurities sb
    where sb.codeid = SUBSTR( pv_strdt,0,INSTR (pv_strdt,'|') -1);

ELSIF pv_id =1THEN


SELECT  SUBSTR( pv_strdt,INSTR (pv_strdt,'|') +1 ,INSTR (pv_strdt,'|',1,2) -INSTR (pv_strdt,'|',1,1)-1  ) INTO v_Result
FROM dual ;


ELSIF pv_id =2 THEN

SELECT  SUBSTR( pv_strdt,INSTR (pv_strdt,'|',1,2) +1,INSTR (pv_strdt,'|',1,3) -  INSTR (pv_strdt,'|',1,2)-1) INTO v_Result
FROM dual ;

ELSIF pv_id =3 THEN
SELECT  SUBSTR( pv_strdt,INSTR (pv_strdt,'|',1,3) +1,INSTR (pv_strdt,'|',1,4) -  INSTR (pv_strdt,'|',1,3)-1) INTO v_Result
from dual;


ELSIF pv_id =4 THEN
SELECT  SUBSTR( pv_strdt,INSTR (pv_strdt,'|',1,4) +1,INSTR (pv_strdt,'|',1,5) -  INSTR (pv_strdt,'|',1,4)-1) INTO v_Result
from dual;

ELSIF pv_id =5 THEN
SELECT  SUBSTR( pv_strdt,INSTR (pv_strdt,'|',1,5) +1,INSTR (pv_strdt,'|',1,6) -  INSTR (pv_strdt,'|',1,5)-1) INTO v_Result
from dual;

ELSIF pv_id =6 THEN
v_Result:=  SUBSTR( pv_strdt,INSTR (pv_strdt,'|',1,6) +1 );


END IF;

RETURN v_Result;


EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
