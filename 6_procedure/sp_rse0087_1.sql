SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE SP_RSE0087_1 (str_data in clob, P_ERR_CODE  OUT VARCHAR2)
IS
v_tlid  varchar2(100);
v_busdate  varchar2(100);
v_compare_date  varchar2(100);
v_txtime  varchar2(100);
v_number  varchar2(100);
v_custodycd_bo  varchar2(100);
v_symbol_bo  varchar2(100);
v_desc  varchar2(100);
v_qtty_bo  varchar2(100);
v_custodycd_vsd  varchar2(100);
v_symbol_vsd  varchar2(100);
v_null  varchar2(100);
v_qtty_vsd  varchar2(100);
v_null_2  varchar2(100);
BEGIN
    
    FOR R IN (
         SELECT REGEXP_SUBSTR(str_data, '[^#,]+', 1, LEVEL) tmp
         FROM dual CONNECT BY REGEXP_SUBSTR(str_data, '[^#,]+', 1, LEVEL) is NOT NULL
                 )
         LOOP


            /*SELECT SUBSTR( R.tmp,0,INSTR (R.tmp,'|') -1 ),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|') +1,INSTR (R.tmp,'|',1,2) -  INSTR (R.tmp,'|',1,1)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,2) +1,INSTR (R.tmp,'|',1,3) -  INSTR (R.tmp,'|',1,2)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,3) +1,INSTR (R.tmp,'|',1,4) -  INSTR (R.tmp,'|',1,3)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,4) +1,INSTR (R.tmp,'|',1,5) -  INSTR (R.tmp,'|',1,4)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,5) +1,INSTR (R.tmp,'|',1,6) -  INSTR (R.tmp,'|',1,5)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,6) +1,INSTR (R.tmp,'|',1,7) -  INSTR (R.tmp,'|',1,6)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,7) +1,INSTR (R.tmp,'|',1,8) -  INSTR (R.tmp,'|',1,7)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,8) +1,INSTR (R.tmp,'|',1,9) -  INSTR (R.tmp,'|',1,8)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,9) +1,INSTR (R.tmp,'|',1,10) -  INSTR (R.tmp,'|',1,9)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,10) +1,INSTR (R.tmp,'|',1,11) -  INSTR (R.tmp,'|',1,10)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,11) +1,INSTR (R.tmp,'|',1,12) -  INSTR (R.tmp,'|',1,11)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,12) +1,INSTR (R.tmp,'|',1,13) -  INSTR (R.tmp,'|',1,12)-1),
                   SUBSTR( R.tmp,INSTR (R.tmp,'|',1,13) +1)
             INTO v_tlid,v_busdate,v_compare_date,v_txtime,v_number,v_custodycd_bo,v_symbol_bo,v_desc,v_qtty_bo,v_custodycd_vsd,v_symbol_vsd,v_null,v_qtty_vsd,v_null_2
             FROM dual;*/
             P_ERR_CODE:=0;
         END LOOP;
     
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
      RAISE ERRNUMS.E_SYSTEM_ERROR;
END;
/
