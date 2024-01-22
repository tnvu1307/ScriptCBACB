SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_unlockaccount(p_txmsg in tx.msg_rectype)
is
PRAGMA AUTONOMOUS_TRANSACTION;
begin
    for rec in (
        select  distinct map.acfld, map.apptype
        from appmap map, apptx tx
        where map.apptxcd= tx.txcd and map.apptype = tx.apptype
        and fldtype ='N' and  tltxcd =p_txmsg.tltxcd
    )
    loop
        delete from accupdate where acctno= p_txmsg.txfields(rec.acfld).value and updatetype = rec.apptype;
    end loop;
    -- xoa check k cho duyet trung
    DELETE FROM ACCUPDATE WHERE ACCTNO = P_TXMSG.TXNUM || TO_CHAR(TO_DATE(P_TXMSG.TXDATE, 'DD/MM/RRRR'),'RRRRMMDD');

    COMMIT;
exception when others then
    ROLLBACK;
    plog.error (SQLERRM || dbms_utility.format_error_backtrace);
end;
/
