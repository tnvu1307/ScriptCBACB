SET DEFINE OFF;
CREATE OR REPLACE FUNCTION calc_import_etf (p_arrautoid varchar2, p_fldname varchar2, p_place varchar2)
return NUMBER is
  l_return NUMBER := 0;
  v_quantity number;
  v_value    number;
  v_difference number;
  v_tradingfee number;
  v_tax        number;
begin
  --func tinh QUANTITY,VALUE,DIFFERENCE,TRADINGFEE,TAX cho import ETF
  l_return:=0;
  IF p_place = 'BACK' THEN -- ETFRESULT_TEMP

    SELECT SUM(QUANTITY), SUM(VALUE), SUM(DIFFERENCE),SUM(TRADINGFEE),SUM(TAX)
    INTO   v_quantity,v_value,v_difference,v_tradingfee,v_tax
    FROM
      (SELECT MAX(T.QUANTITY) QUANTITY, MAX(T.VALUE) VALUE, MAX(T.DIFFERENCE) DIFFERENCE,
             MAX(T.TRADINGFEE) TRADINGFEE, MAX(T.TAX) TAX
      FROM ETFRESULT_TEMP T WHERE T.AUTOID in (select autoid from (select regexp_substr(p_arrautoid, '[^#]+', 1, level) as autoid from dual
             connect by regexp_substr(p_arrautoid, '[^#]+', 1, level) is not null))
      GROUP BY T.FILEID,T.FUNDCODEID,T.TRADINGID,T.AP,T.QUANTITY,T.REFID)
    WHERE 0=0;

    IF p_fldname = 'QUANTITY' THEN
      l_return:= v_quantity;
    ELSIF p_fldname = 'VALUE' THEN
      l_return:= v_value;
    ELSIF p_fldname = 'DIFFERENCE' THEN
      l_return:= v_difference;
    ELSIF p_fldname = 'TRADINGFEE' THEN
      l_return:= v_tradingfee;
    ELSIF p_fldname = 'TAX' THEN
      l_return:= v_tax;
    ELSE
       l_return:=0;
    END IF;
  ELSE --ETFRESULT_TEMP4WEB
    SELECT SUM(QUANTITY), SUM(VALUE), SUM(DIFFERENCE),SUM(TRADINGFEE),SUM(TAX)
    INTO   v_quantity,v_value,v_difference,v_tradingfee,v_tax
    FROM
      (SELECT MAX(T.QUANTITY) QUANTITY, MAX(T.VALUE) VALUE, MAX(T.DIFFERENCE) DIFFERENCE,
             MAX(T.TRADINGFEE) TRADINGFEE, MAX(T.TAX) TAX
      FROM ETFRESULT_TEMP4WEB T WHERE INSTR(p_arrautoid,to_char(T.AUTOID))>0
           --AND T.FILEID = '22467'
      GROUP BY T.FILEID,T.FUNDCODEID,T.TRADINGID,T.AP,T.QUANTITY,T.REFID)
    WHERE 0=0;

    IF p_fldname = 'QUANTITY' THEN
      l_return:= v_quantity;
    ELSIF p_fldname = 'VALUE' THEN
      l_return:= v_value;
    ELSIF p_fldname = 'DIFFERENCE' THEN
      l_return:= v_difference;
    ELSIF p_fldname = 'TRADINGFEE' THEN
      l_return:= v_tradingfee;
    ELSIF p_fldname = 'TAX' THEN
      l_return:= v_tax;
    ELSE
       l_return:=0;
    END IF;
  END IF;
  RETURN l_return;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
end CALC_IMPORT_ETF;
/
