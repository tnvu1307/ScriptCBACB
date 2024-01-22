SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_lockaccount(p_txmsg in tx.msg_rectype, p_err_code in out varchar2)
is
    l_listacctno varchar2 (1000);
    l_count number;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
    l_listacctno:='|';
    for rec in (
        select  distinct map.acfld, map.apptype
        from appmap map, apptx tx, tltx
        where map.apptxcd= tx.txcd and map.apptype = tx.apptype
        and fldtype ='N' and  map.tltxcd =p_txmsg.tltxcd
        and map.tltxcd = tltx.tltxcd and nvl(chksingle,'N') ='Y'

    )
    loop
        --PLOG.ERROR('pr_lockaccount. l_listacctno='||l_listacctno  ||p_txmsg.txfields(rec.acfld).value || rec.apptype||', apptype='||rec.apptype);
        if instr(l_listacctno,'|' || p_txmsg.txfields(rec.acfld).value || rec.apptype || '|') =0 then
            insert into accupdate (acctno,updatetype,createdate)
            values (p_txmsg.txfields(rec.acfld).value, rec.apptype, SYSTIMESTAMP);
        end if;
        l_listacctno:= l_listacctno  ||  p_txmsg.txfields(rec.acfld).value || rec.apptype || '|';

        p_err_code:=0;
    end loop;

    -- check k cho duyet trung
    IF NVL(P_TXMSG.OVRRQD,'$X$') = '$X$' OR LENGTH(P_TXMSG.OVRRQD) = 0 OR (INSTR(P_TXMSG.OVRRQD, ERRNUMS.C_OFFID_REQUIRED) > 0 AND LENGTH(P_TXMSG.OFFID) > 0) OR (LENGTH(REPLACE(P_TXMSG.OVRRQD, ERRNUMS.C_OFFID_REQUIRED, '')) > 0 AND LENGTH(P_TXMSG.CHKID) > 0)  THEN
        IF P_TXMSG.TXSTATUS = TXSTATUSNUMS.C_TXPENDING THEN
            SELECT COUNT(1) INTO L_COUNT
            FROM accupdate
            WHERE acctno = P_TXMSG.TXNUM || TO_CHAR(TO_DATE(P_TXMSG.TXDATE, 'DD/MM/RRRR'),'RRRRMMDD');

            IF L_COUNT > 0 THEN
                p_err_code := '-100079';
            ELSE
                INSERT INTO ACCUPDATE (ACCTNO, UPDATETYPE, CREATEDATE)
                VALUES (P_TXMSG.TXNUM || TO_CHAR(TO_DATE(P_TXMSG.TXDATE, 'DD/MM/RRRR'),'RRRRMMDD'), P_TXMSG.TLTXCD, SYSTIMESTAMP);
            END IF;
        END IF;
    END IF;
    COMMIT;
exception when others then
    ROLLBACK;
    plog.error (SQLERRM || dbms_utility.format_error_backtrace);
end;
/
