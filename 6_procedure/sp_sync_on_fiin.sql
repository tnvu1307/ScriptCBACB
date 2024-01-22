SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_sync_on_fiin (v_type in varchar2,v_fr_date varchar2,v_to_date varchar2, P_ERR_CODE  OUT VARCHAR2)
IS
start_date number;
end_date number;
pv_todate date;
BEGIN
        

        if v_type = 'SYNC_PRICE_FIIN' then
            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetHoseStock',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetHnxStock',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetUpcomStock',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetHoseIndex',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetHnxIndex',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetUpcomIndex',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetCWStockPrice',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetHnxDerivative',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetCoveredWarrant',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetBond',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);

            INSERT INTO fiin.fiinreq  (reqid, apiname, frdate, todate, status, createdate,lastchange)
            VALUES(seq_fiinreq.nextval,'GetBondOutright',TO_TIMESTAMP(v_fr_date,'dd/MM/RRRR HH24:MI:SS'),TO_TIMESTAMP(v_to_date,'dd/MM/RRRR HH24:MI:SS'),'P',SYSTIMESTAMP,NULL);
        end if;
        P_ERR_CODE:=0;
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
      RAISE ERRNUMS.E_SYSTEM_ERROR;
END;
/
