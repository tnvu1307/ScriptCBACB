SET DEFINE OFF;
CREATE OR REPLACE function fn_check_status(P_AUTOID number, P_TYPE number) return number is
  v_Result number;
  v_STATUS VARCHAR2(4);
begin
  SELECT STATUS INTO v_STATUS FROM VW_FEETRAN_ALL WHERE AUTOID = P_AUTOID;
      IF(P_TYPE = 1) THEN
          IF(v_STATUS <> 'Y') THEN 
              v_Result := 0; 
          ELSE v_Result := -1;
          END IF;
       ELSE IF(P_TYPE = 2) THEN
                IF(v_STATUS <> 'C') THEN 
                    v_Result := 0; 
                ELSE v_Result := -1;
                END IF;
            END IF;
       END IF;
  return(v_Result);
EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
end fn_check_status;

/
