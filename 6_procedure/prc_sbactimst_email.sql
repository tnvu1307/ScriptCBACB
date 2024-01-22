SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_sbactimst_email
IS
    pkgctx   plog.log_ctx;
    logrow   tlogdebug%ROWTYPE;
    v_reminddateoff date;
    v_type_REMINDDATEOFF varchar2(10);
    v_repeaddate date;
    v_currdate date;
    v_holiday varchar2(10);
    v_time_send varchar2(20);
    p_data_source varchar2(4000);
    v_title VARCHAR2(250);
    v_txdate VARCHAR2(250);
    v_priority varchar2(250);
    v_note varchar2(4000);
    l_email varchar2(4000);
    v_txtime TIMESTAMP;
    v_txtime_begin varchar2(100);
    v_txtime_end varchar2(100);
    v_ACTIMSTTYP varchar2(250);
    v_remindtime varchar2(100);
    v_EMAILBOND_EXDATE varchar2(10);
    v_EMAILBOND_RECORDDATE varchar2(10);
    V_COUNT NUMBER;
    v_email_date timestamp;
BEGIN
    v_currdate := getcurrdate;
    V_TXTIME := SYSTIMESTAMP;
    V_TXTIME_BEGIN := TO_CHAR(SYSTIMESTAMP - (1/1440), 'HH:MI:SS AM');
    V_TXTIME_END := TO_CHAR(SYSTIMESTAMP + (1/1440), 'HH:MI:SS AM');
    ----- Thoai.tran 01/06/2022
    -- Bo sung them EM99/ EM98
    --PLOG.ERROR('Send mail');
    v_EMAILBOND_EXDATE := 'SUCCESS';
    BEGIN
         SELECT TO_DATE(TO_CHAR(SYSDATE,'DD/MM/RRRR')||' '||varvalue,'DD/MM/RRRR HH24:MI:SS') varvalue into v_email_date
         FROM SYSVAR
        WHERE GRNAME='SYSTEM' AND VARNAME IN ('EMAILBOND_EXDATE');
    EXCEPTION WHEN OTHERS THEN
        v_email_date:= null;
        v_EMAILBOND_EXDATE := '-1';
    END;

    SELECT LPAD(varvalue,2,'0') into v_EMAILBOND_RECORDDATE FROM SYSVAR
    WHERE GRNAME='SYSTEM' AND VARNAME IN ('EMAILBOND_RECORDDATE');
    select COUNT(*) INTO V_COUNT from CAREMINDER_LOG where nvl(status,'P')='P'
    AND ((EXDATE >= v_currdate AND TEMPEM ='EM98') OR (EXDATE = v_currdate AND TEMPEM ='EM99'));
    IF  V_COUNT > 0 and v_EMAILBOND_EXDATE <> '-1' THEN
                for rec in(select a.* from CAREMINDER_LOG a where nvl(a.status,'P')='P'
                AND ((EXDATE >= v_currdate AND TEMPEM ='EM98') OR (EXDATE = v_currdate AND TEMPEM ='EM99'))
                and symbol in (select sb.symbol from (
                        SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,SE.AFACCTNO,
                            SUM(CASE WHEN SE.TLTXCD IN ('2232') THEN SE.QTTY
                                     WHEN SE.TLTXCD IN ('2233') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                        FROM SEMORTAGE SE
                        WHERE SE.DELTD <> 'Y'
                        AND SE.STATUS IN ('C')
                        AND SE.ISSUESID IS NOT NULL
                        GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
                        UNION ALL
                        SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,SE.AFACCTNO,
                            SUM(CASE WHEN SE.TLTXCD IN ('1900') THEN SE.QTTY
                                     WHEN SE.TLTXCD IN ('1901') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                        FROM SEMORTAGE SE
                        WHERE SE.DELTD <> 'Y'
                        AND SE.STATUS IN ('C')
                        AND SE.ISSUESID IS NOT NULL
                        GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
                        UNION ALL
                        SELECT BL.CODEID, BL.ISSUESID,BL.AFACCTNO, 0 QTTY,
                            SUM(CASE WHEN BL.TLTXCD IN ('1909') THEN BL.AMT
                                     WHEN BL.TLTXCD IN ('1910') THEN -BL.AMT ELSE 0 END) AMT
                        FROM BLOCKAGE BL
                        WHERE BL.DELTD <> 'Y'
                        AND BL.ISSUESID IS NOT NULL
                        GROUP BY BL.CODEID,BL.ISSUESID,BL.AFACCTNO
                     ) MT --, sbsecurities sb where mt.qtty>0 and mt.codeid=sb.codeid --thangpv SHBVNEX-2797
                     JOIN SBSECURITIES SB ON MT.CODEID = SB.CODEID AND MT.QTTY > 0
                     AND INSTR((SELECT ',' || LISTAGG(REPLACE(TICKERLIST,' ',''), ',') WITHIN GROUP (ORDER BY TICKERLIST) ||',' FROM BONDTYPE), ',' || SB.SYMBOL || ',') > 0))
                loop
                    IF (v_email_date <= SYSTIMESTAMP AND REC.TEMPEM ='EM99') OR REC.TEMPEM ='EM98' THEN
                        l_email := rec.TEMPEM;
                        p_data_source :=  'select '''||REC.CAMASTID||''' p_camastid,''' ||
                                                    rec.symbol || ''' p_symbol, ''' ||
                                                    to_char(rec.reportdate,'dd/mm/rrrr') || ''' p_reportdate, ''' ||
                                                    to_char(rec.EXDATE,'dd/mm/rrrr') || ''' p_exdate, ''' ||
                                                    rec.status || ''' p_note  from dual ';
                        nmpks_ems.pr_sendInternalEmail(p_data_source, l_email ,'');
                        Update CAREMINDER_LOG set status ='A' where autoid = rec.autoid;
                    END IF;
                end loop;
    END IF;
    ------------------------------------------------------------------
    for r in (
                SELECT DT.* FROM
                (
                    SELECT AUTOID, SBACTIMST_AUTOID
                        ,(CASE WHEN REPEATDATE_NEXT IS NOT NULL AND REMINDDATE < REPEATDATE_NEXT THEN REPEATDATE_NEXT ELSE REMINDDATE END )REMINDDATE
                        , ENDREMINDDATE,REMINDTIME, REPEAT, NUMBERREMIND, STATUS,REPEATDATE_NEXT
                        , REPLACE(REPLACE(LPAD(REMINDTIME,11,0),'SA','AM'),'CH','PM') TIMECHECK
                    FROM SBACTIMST_EMAIL
                    WHERE STATUS = 'P'
                    AND ENDREMINDDATE >= V_CURRDATE
                    AND ((REMINDDATE = V_CURRDATE AND REPEATDATE_NEXT IS NULL) OR REPEATDATE_NEXT = V_CURRDATE)
                ) DT
                WHERE TO_DATE(DT.TIMECHECK, 'HH:MI:SS AM') >= TO_DATE(V_TXTIME_BEGIN, 'HH:MI:SS AM')
                AND TO_DATE(DT.TIMECHECK, 'HH:MI:SS AM') <= TO_DATE(V_TXTIME_END, 'HH:MI:SS AM')
             )
    loop
                --gui mail
               select SB.TITLE ,to_char(SB.DUEDT,'dd/MM/RRRR') ,A2.EN_CDCONTENT ,SB.notes,sb.email,A3.EN_CDCONTENT
                    into v_title,v_txdate,v_priority,v_note,l_email,v_ACTIMSTTYP
                    FROM SBACTIMST SB,(SELECT *FROM ALLCODE WHERE CDNAME = 'SBACTIMST_PRIORITY') A2,
                                        (select *From allcode where cdname = 'ACTIMSTTYP') A3
                        WHERE   SB.priority = A2.CDVAL
                            and sb.autoid = r.sbactimst_autoid
                            AND SB.actimsttyp = A3.CDVAL;
                p_data_source :=  'select '''||v_title||''' p_title,''' ||
                                        v_txdate || ''' p_txdate, ''' ||
                                        v_priority || ''' p_priority, ''' ||
                                        v_ACTIMSTTYP || ''' p_actimsttyp, ''' ||
                                        v_note || ''' p_note  from dual '
                            ;

                nmpks_ems.InsertEmailLog(l_email, 'EMRM' ,p_data_source ,'0001');
                IF r.repeat in ('1','2','5') then
                    update SBACTIMST_EMAIL
                    set status = 'C'
                    where autoid = r.autoid;
                end if;
                --xu ly neu co lap lai theo rule
                    -- allcode SBACTIMST_REMINDDATEOFF
                select REMINDDATEOFF into v_type_REMINDDATEOFF from SBACTIMST where autoid = r.sbactimst_autoid;

                if v_type_REMINDDATEOFF = '1' then  --lay ngay lam viec lien truoc
                    if r.repeat = '4' then  --Remind every A weeks -- allcode SBACTIMST_REPEAT
                        v_repeaddate := GETWORKINGDATEPREV(r.reminddate + (7 * r.numberremind));
                        if v_repeaddate <= r.endreminddate then
                            update SBACTIMST_EMAIL
                            set REPEATDATE_NEXT = v_repeaddate, status ='P'
                            where autoid = r.autoid;
                        end if;
                    elsif r.repeat = '6' then   --Remind every A days -- allcode SBACTIMST_REPEAT
                        v_repeaddate := GETWORKINGDATEPREV(r.reminddate + r.numberremind);
                        if v_repeaddate <= r.endreminddate then
                            update SBACTIMST_EMAIL
                            set REPEATDATE_NEXT = v_repeaddate, status ='P'
                            where autoid = r.autoid;
                        end if;
                    elsif r.repeat = '3' then   --Remind weekly -- allcode SBACTIMST_REPEAT
                        v_repeaddate := GETWORKINGDATEPREV(r.reminddate + 7);
                        if v_repeaddate <= r.endreminddate then
                            update SBACTIMST_EMAIL
                            set REPEATDATE_NEXT = v_repeaddate, status ='P'
                            where autoid = r.autoid;
                        end if;
                    end if;
                elsif  v_type_REMINDDATEOFF = '2' then  --lay ngay lam viec lien sau
                    if r.repeat = '4' then  --Remind every A weeks -- allcode SBACTIMST_REPEAT
                        v_repeaddate := GETWORKINGDATENEXT(r.reminddate + (7 * r.numberremind));
                        if v_repeaddate <= r.endreminddate then
                            update SBACTIMST_EMAIL
                            set REPEATDATE_NEXT = v_repeaddate, status ='P'
                            where autoid = r.autoid;
                        end if;
                    elsif r.repeat = '6' then   --Remind every A days -- allcode SBACTIMST_REPEAT
                        v_repeaddate := GETWORKINGDATENEXT(r.reminddate + r.numberremind);
                        if v_repeaddate <= r.endreminddate then
                            update SBACTIMST_EMAIL
                            set REPEATDATE_NEXT = v_repeaddate, status ='P'
                            where autoid = r.autoid;
                        end if;
                    elsif r.repeat = '3' then   --Remind weekly -- allcode SBACTIMST_REPEAT
                        v_repeaddate := GETWORKINGDATENEXT(r.reminddate + 7);
                        if v_repeaddate <= r.endreminddate then
                            update SBACTIMST_EMAIL
                            set REPEATDATE_NEXT = v_repeaddate, status ='P'
                            where autoid = r.autoid;
                        end if;
                    end if;
                end if;
    end loop;
    commit;
    plog.setendsection(pkgctx, 'prc_SBACTIMST_EMAIL');
EXCEPTION
  WHEN others THEN
    rollback;
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'prc_SBACTIMST_EMAIL');
    RAISE errnums.E_SYSTEM_ERROR;
END;
/
