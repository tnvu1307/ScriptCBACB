SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_process_auto_batch
IS
    pkgctx   plog.log_ctx;
    logrow   tlogdebug%ROWTYPE;
    l_ISSUERID varchar2(20);
    l_CODEID varchar2(6);
    l_CODEIDWFT varchar2(6);
    v_currdate varchar2(100);
    p_err_code varchar2(250);
    p_lastRun varchar2(250);
    v_list_email varchar2(4000);
    l_subject varchar2(500);
    l_seq varchar2(50);
    l_datasource varchar2(32000);
BEGIN
    plog.setbeginsection(pkgctx, 'Auto batch PROCEDURE:prc_process_auto_batch');
    select varvalue into v_currdate From sysvar where varname = 'CURRDATE';
    select varvalue into v_list_email from sysvar where varname ='EMAIL_BATCH_AUTO';
    --SELECT  subject into  l_subject  FROM templates WHERE code = '999E';
    INSERT INTO SBBATCHSTS
        SELECT TO_DATE(v_currdate,'dd/MM/RRRR') BCHDATE, BCHMDL, ' ' BCHSTS, '' CMPLTIME, ROWPERPAGE,0
            FROM SBBATCHCTL
                WHERE STATUS = 'Y' AND UPPER(RUNAT) <> 'EOY' AND UPPER(RUNAT) <> 'EOM' Order by BCHSQN ;

    for r in
    (
        SELECT DISTINCT B.*,A.BCHSUCPAGE,A.BCHDATE FROM SBBATCHSTS A, SBBATCHCTL B WHERE A.BCHMDL = B.BCHMDL AND A.BCHSTS = ' ' AND B.STATUS = 'Y' /* and b.action= 'BF'*/ ORDER BY B.BCHSQN
    )
    loop
        begin

            txpks_batch.pr_batch(r.apptype,r.bchmdl,p_err_code ,p_lastRun);

        exception when others then
            plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
            plog.setendsection (pkgctx, 'Auto batch: prc_process_auto_batch');
            return;
        end;
        if P_ERR_CODE <> systemnums.C_SUCCESS then
            l_subject:= 'CB system auto bacth';
            l_datasource := 'CB system auto bacth error '||r.bchmdl ||' : ' ||r.bchtitle ||'. System date is ' || to_char(getcurrdate,'DD/MM/RRRR');
            for rec in(
                select regexp_substr(v_list_email, '[^#,]+', 1, level) dtl from dual
                    connect by regexp_substr(v_list_email, '[^#,]+', 1, level) is not null)
            loop
                l_seq := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');

                INSERT INTO emaillog    (autoid,templateid,email,fullname,emailcontent,createtime,reqid,subject,status)
                VALUES(seq_emaillog.NEXTVAL,'999E',rec.dtl,rec.dtl,l_datasource,SYSTIMESTAMP,l_seq,l_subject,'N');
            end loop;
            return;
        end if;
    end loop;

    Commit;
    plog.setendsection(pkgctx, 'Auto batch PROCEDURE:prc_process_auto_batch');
EXCEPTION
  WHEN others THEN
    rollback;
    plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'Auto batch PROCEDURE:prc_process_auto_batch');
    RAISE errnums.E_SYSTEM_ERROR;
END;
/
