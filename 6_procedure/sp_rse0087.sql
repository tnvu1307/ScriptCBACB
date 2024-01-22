SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_rse0087 (str_data in clob,filename varchar2, P_ERR_CODE  OUT VARCHAR2)
IS
v_tlid  varchar2(100);
v_busdate  varchar2(100);
v_compare_date  varchar2(100);
v_txtime  varchar2(100);
v_status_compare  varchar2(100);
v_custodycd_sy  varchar2(100);
v_symbol_sy  varchar2(100);
v_desc  varchar2(100);
v_custodycd_vsd  varchar2(100);
v_symbol_vsd  varchar2(100);
v_null  varchar2(100);
v_qtty_sy   varchar2(100);
v_qtty_vsd   varchar2(100);
v_null_2  varchar2(100);
v_fullname varchar2(200);
v_seq number;
v_makerid varchar2(100);
V_GLOBALID varchar2(100);
V_CURRDATE date;
l_count_sy number;
l_count_vsd number;
BEGIN
    V_SEQ := SEQ_LOG_SE0087.NEXTVAL;
    V_CURRDATE := GETCURRDATE;

    FOR R IN (
         SELECT to_char(REGEXP_SUBSTR(str_data, '[^#,]+', 1, level)) tmp
         FROM dual CONNECT BY to_char(REGEXP_SUBSTR(str_data, '[^#,]+', 1, level)) is NOT NULL
    )
         LOOP

            SELECT trim(SUBSTR( R.tmp,0,INSTR (R.tmp,'|') -1 )),--v_tlid
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|') +1,INSTR (R.tmp,'|',1,2) -  INSTR (R.tmp,'|',1,1)-1)),--v_busdate
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,2) +1,INSTR (R.tmp,'|',1,3) -  INSTR (R.tmp,'|',1,2)-1)),--v_compare_date
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,3) +1,INSTR (R.tmp,'|',1,4) -  INSTR (R.tmp,'|',1,3)-1)),--v_txtime
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,4) +1,INSTR (R.tmp,'|',1,5) -  INSTR (R.tmp,'|',1,4)-1)),--v_status_compare
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,5) +1,INSTR (R.tmp,'|',1,6) -  INSTR (R.tmp,'|',1,5)-1)),--v_custodycd_sy
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,6) +1,INSTR (R.tmp,'|',1,7) -  INSTR (R.tmp,'|',1,6)-1)),--v_symbol_sy
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,7) +1,INSTR (R.tmp,'|',1,8) -  INSTR (R.tmp,'|',1,7)-1)),--v_desc
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,8) +1,INSTR (R.tmp,'|',1,9) -  INSTR (R.tmp,'|',1,8)-1)),--v_qtty_sy
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,9) +1,INSTR (R.tmp,'|',1,10) -  INSTR (R.tmp,'|',1,9)-1)),--v_custodycd_vsd
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,10) +1,INSTR (R.tmp,'|',1,11) -  INSTR (R.tmp,'|',1,10)-1)),--v_symbol_vsd
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,11) +1,INSTR (R.tmp,'|',1,12) -  INSTR (R.tmp,'|',1,11)-1)),--v_null
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,12) +1,INSTR (R.tmp,'|',1,13) -  INSTR (R.tmp,'|',1,12)-1)),--v_qtty_vsd
                   trim(SUBSTR( R.tmp,INSTR (R.tmp,'|',1,13) +1))--v_null_2
             INTO v_tlid,v_busdate,v_compare_date,v_txtime,v_status_compare,v_custodycd_sy,v_symbol_sy,v_desc,v_qtty_sy,v_custodycd_vsd,v_symbol_vsd,v_null,v_qtty_vsd,v_null_2
             FROM dual;
            IF NVL(V_TLID,'xxx') <> 'xxx' THEN
                begin
                    select fullname into v_fullname from cfmast where custodycd = nvl(v_custodycd_sy,v_custodycd_vsd);
                    select tlfullname into v_makerid from tlprofiles where tlid = v_tlid;
                exception when NO_DATA_FOUND
                    then
                    v_fullname := '';
                    v_makerid  :='';
                end;

                SELECT COUNT(1) INTO L_COUNT_SY
                FROM LOG_SE0087
                WHERE AUTOID = V_SEQ
                AND SY_CUSTODYCD = NVL(V_CUSTODYCD_SY, V_CUSTODYCD_VSD)
                AND SY_SYMBOL = NVL(V_SYMBOL_SY, V_SYMBOL_VSD)
                AND ACCOUNTTYPE = NVL(V_DESC, V_NULL);

                IF L_COUNT_SY = 0 THEN
                    INSERT INTO LOG_SE0087 (AUTOID, FILENAME, TLID, BUSDATE, COMPARE_DATE, TXTIME, DELTD, ACCOUNTTYPE, SY_CUSTODYCD, SY_SYMBOL, SY_QTTY, VSD_CUSTODYCD, VSD_SYMBOL, VSD_QTTY, FULLNAME, MAKERID)
                    VALUES (V_SEQ,FILENAME,V_TLID,V_BUSDATE,V_COMPARE_DATE,V_TXTIME,'N',NVL(V_DESC, V_NULL),V_CUSTODYCD_SY,V_SYMBOL_SY,V_QTTY_SY,V_CUSTODYCD_VSD,V_SYMBOL_VSD,V_QTTY_VSD,V_FULLNAME,V_MAKERID);
                ELSE
                    SELECT COUNT(1) INTO L_COUNT_VSD
                    FROM LOG_SE0087
                    WHERE AUTOID = V_SEQ
                    AND SY_CUSTODYCD = V_CUSTODYCD_VSD
                    AND SY_SYMBOL = V_SYMBOL_VSD
                    AND ACCOUNTTYPE = NVL(V_DESC, V_NULL);

                    IF L_COUNT_VSD > 0 THEN
                        UPDATE LOG_SE0087 SET VSD_CUSTODYCD = V_CUSTODYCD_VSD, VSD_SYMBOL = V_SYMBOL_VSD, VSD_QTTY = V_QTTY_VSD
                        WHERE AUTOID = V_SEQ
                        AND SY_CUSTODYCD = V_CUSTODYCD_VSD
                        AND SY_SYMBOL = V_SYMBOL_VSD
                        AND ACCOUNTTYPE = NVL(V_DESC, V_NULL);
                    ELSE
                        INSERT INTO LOG_SE0087 (AUTOID, FILENAME, TLID, BUSDATE, COMPARE_DATE, TXTIME, DELTD, ACCOUNTTYPE, SY_CUSTODYCD, SY_SYMBOL, SY_QTTY, VSD_CUSTODYCD, VSD_SYMBOL, VSD_QTTY, FULLNAME, MAKERID)
                        VALUES (V_SEQ,FILENAME,V_TLID,V_BUSDATE,V_COMPARE_DATE,V_TXTIME,'N',NVL(V_DESC, V_NULL),V_CUSTODYCD_SY,V_SYMBOL_SY,V_QTTY_SY,V_CUSTODYCD_VSD,V_SYMBOL_VSD,V_QTTY_VSD,V_FULLNAME,V_MAKERID);
                    END IF;
                END IF;
            END IF;
         END LOOP;

         SELECT 'CB.' || TO_CHAR(V_CURRDATE,'YYYYMMDD') || '.' || STANDARD_HASH(V_SEQ, 'MD5') INTO V_GLOBALID FROM DUAL;

         INSERT INTO LOG_NOTIFY_CBFA(GLOBALID, AUTOID, OBJNAME, KEYNAME, KEYVALUE, ACTION, TXNUM, TXDATE, TLTXCD, LOGTIME, BUSDATE)
         VALUES (V_GLOBALID, SEQ_LOG_NOTIFY_CBFA.NEXTVAL, 'RSE0087', 'AUTOID', V_SEQ, 'ADD', '', V_CURRDATE, '', SYSDATE, V_CURRDATE);

         COMMIT;
         P_ERR_CODE:=0;
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
      RAISE ERRNUMS.E_SYSTEM_ERROR;
END;
/
