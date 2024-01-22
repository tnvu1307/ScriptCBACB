SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_qtty_1405(P_CPHYSAGREEID VARCHAR2, P_CRQTTY NUMBER,P_QTTY NUMBER) RETURN NUMBER IS
  V_RESULT NUMBER;
  qt_docstranfer number;
  v_count number;
BEGIN
    qt_docstranfer:= 0;
    select count(*) into v_count from docstransfer where crphysagreeid =P_CPHYSAGREEID and status ='OPN';
    if v_count >0 then
        select (case when status = 'OPN' then nvl(sum(qtty),0) else 0 end) into qt_docstranfer from docstransfer where  crphysagreeid =P_CPHYSAGREEID and status ='OPN' group by status;
    end if;
  IF (P_CPHYSAGREEID IS NULL AND P_QTTY <= 0) THEN
     V_RESULT := -1;
  ELSIF (P_CPHYSAGREEID IS NOT NULL AND P_QTTY > P_CRQTTY - qt_docstranfer) THEN
     V_RESULT := -1;
  ELSE
     V_RESULT := 0;
  END IF;
  RETURN(V_RESULT);
END FN_CHECK_QTTY_1405;
/
