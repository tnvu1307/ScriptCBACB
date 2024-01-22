SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_sync_fiin (V_TYPE IN VARCHAR2,V_FR_DATE VARCHAR2,V_TO_DATE VARCHAR2, P_ERR_CODE  OUT VARCHAR2)
IS
    START_DATE NUMBER;
    END_DATE NUMBER;
    PV_TODATE DATE;
    P_DATE DATE;
    P_FRDATE DATE;
    P_TODATE DATE;
    P_CURRDATE DATE;
BEGIN
   

    P_FRDATE := TO_DATE(V_FR_DATE, 'DD/MM/RRRR HH24:MI:SS');
    P_TODATE := TO_DATE(V_TO_DATE, 'DD/MM/RRRR HH24:MI:SS');
    P_CURRDATE := GETCURRDATE;

    START_DATE := TO_NUMBER(TO_CHAR(P_FRDATE, 'J'));
    END_DATE := TO_NUMBER(TO_CHAR(P_TODATE, 'J'));

    if v_type = 'STOCK_INFO' then
       -- prc_syn_from_finn();
       plog.error('PRC_SYN_STOCKPRICE_FROM_FINN_HIST_BYDATE: ');
    elsif v_type = 'STOCK_PRICE' then
        if to_date(to_char(to_date(v_fr_date,'dd/MM/RRRR HH24:MI:SS')),'DD/MM/RRRR')  = getcurrdate and to_date(to_char(to_date(v_to_date,'dd/MM/RRRR HH24:MI:SS')),'DD/MM/RRRR')  = getcurrdate then
            --PRC_SYN_STOCKPRICE_FROM_FINN();
            plog.error('PRC_SYN_STOCKPRICE_FROM_FINN_HIST_BYDATE: ');
        else
            for i in start_date..end_date loop
                pv_todate := to_date(to_char(to_date(i, 'j'), 'DD/MM/RRRR'),'dd/MM/RRRR');
                plog.error('PRC_SYN_STOCKPRICE_FROM_FINN_HIST_BYDATE: ');
                PRC_SYN_STOCKPRICE_FROM_FINN_HIST_BYDATE (pv_todate);
                plog.error('sp_getmrktprice_from_finn: ');
                sp_getmrktprice_from_finn (pv_todate);
            end loop;
        end if;
    ELSIF V_TYPE = 'LTVCAL' THEN
        IF P_FRDATE = P_CURRDATE AND P_TODATE = P_CURRDATE THEN
            DELETE FROM MANUAL_CAL_JOB WHERE CTYPE = 'LTVCAL' AND TXDATE = P_CURRDATE;
            INSERT INTO MANUAL_CAL_JOB(AUTOID, TXDATE, CTYPE, STATUS, MSG, CREATEDT, ENDDT)
            VALUES (SEQ_MANUAL_CAL_JOB.NEXTVAL, P_CURRDATE, 'LTVCAL', 'P', '', SYSTIMESTAMP, NULL);
        ELSE
            FOR I IN START_DATE..END_DATE LOOP
                P_DATE := TO_DATE(TO_CHAR(TO_DATE(I, 'J'), 'DD/MM/RRRR'),'DD/MM/RRRR');
                DELETE FROM MANUAL_CAL_JOB WHERE CTYPE = 'LTVCAL' AND TXDATE = P_DATE;
                INSERT INTO MANUAL_CAL_JOB(AUTOID, TXDATE, CTYPE, STATUS, MSG, CREATEDT, ENDDT)
                VALUES (SEQ_MANUAL_CAL_JOB.NEXTVAL, P_DATE, 'LTVCAL', 'P', '', SYSTIMESTAMP, NULL);
            END LOOP;
        END IF;
    END IF;
    P_ERR_CODE:=0;
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
      RAISE ERRNUMS.E_SYSTEM_ERROR;
END;
/
