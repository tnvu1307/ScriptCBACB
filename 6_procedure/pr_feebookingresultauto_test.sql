SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE Pr_FeebookingResultAuto_test(p_txdate date)
IS
V_TXDATE DATE;
V_LASTMONTH DATE;
V_FIRSTMONTH DATE;
l_txmsg tx.msg_rectype;
p_batchname varchar2(20);
l_err_param   varchar2(1000);
l_FromRow   varchar2(20);
l_ToRow   varchar2(20);
l_MaxRow NUMBER(20,0);
V_MONTHDATE DATE;
p_err_code varchar2(100);
pkgctx varchar2(1000);
BEGIN

    FOR REC IN
        (
            SELECT MST.FEECODE,MST.TXDATE POSTDATE, TO_CHAR(MST.TXDATE,'MM/YYYY') BILLINGMONTH, MST.TXNUM, MST.FEETYPES FEETYPE,MST.SUBTYPE,
                MST.CUSTODYCD,CF.CIFID PROFOLIOCD,CF.FULLNAME CUSTNAME,MST.FEEAMT,MST.CCYCD, SUBSTR(MST.TRDESC,1,200) DESCRIPTION
            FROM (select * from VW_FEETRAN_ALL) MST, CFMAST CF
            WHERE MST.STATUS = 'N'
            AND MST.DELTD <> 'Y'
            AND MST.CUSTODYCD=CF.CUSTODYCD(+)
            and cf.bondagent <> 'Y' --trung.luu: 08/06/2020 SHBVNEX-1073 Kh?ng ti?nh d??i vo?i kha?ch ha`ng Bondagent = Yes
            AND MST.FEETYPES NOT IN ('SETRAN','ASSETMNG','BONDMNG','PAYAGENCY','BONDOTHER')
            AND MST.TXDATE = p_txdate
        ) loop

                    l_txmsg.tltxcd := '1296';
                    l_txmsg.msgtype := 'T';
                    l_txmsg.local   := 'N';
                    l_txmsg.tlid    := systemnums.c_system_userid;
                    select sys_context('USERENV', 'HOST'),
                         sys_context('USERENV', 'IP_ADDRESS', 15)
                    into l_txmsg.wsname, l_txmsg.ipaddress
                    from dual;
                    l_txmsg.off_line  := 'N';
                    l_txmsg.deltd     := txnums.c_deltd_txnormal;
                    l_txmsg.txstatus  := txstatusnums.c_txcompleted;
                    l_txmsg.msgsts    := '0';
                    l_txmsg.ovrsts    := '0';
                    l_txmsg.batchname := 'TEST';
                    l_txmsg.busdate   := getcurrdate;
                    l_txmsg.txdate    := getcurrdate;
                    select systemnums.c_batch_prefixed || lpad(seq_batchtxnum.nextval, 8, '0')
                    into l_txmsg.txnum
                    from dual;
                    select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
                    --trung.luu: 29-03-2021 log lai khi auto booking phi qua aither
                    insert into auto_fee_booking_batch_log(autoid, feetran_txdate, feetran_txnum, txnum_1296, busdate_1296, custodycd, feecode, batch_date)
                    values(seq_auto_fee_booking_batch_log.NEXTVAL,rec.POSTDATE,rec.TXNUM,l_txmsg.txnum,V_TXDATE,rec.CUSTODYCD,rec.FEECODE,getcurrdate);

                    --20 POSTDATE
                         l_txmsg.txfields ('20').defname   := 'POSTDATE';
                         l_txmsg.txfields ('20').TYPE      := 'D';
                         l_txmsg.txfields ('20').value      := rec.POSTDATE;
                    --87 TXNUM
                         l_txmsg.txfields ('87').defname   := 'TXNUM';
                         l_txmsg.txfields ('87').TYPE      := 'C';
                         l_txmsg.txfields ('87').value      := rec.TXNUM;
                    --30 DESC
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := rec.DESCRIPTION;
                    --88 DESC
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                    --22 FEECODE
                         l_txmsg.txfields ('22').defname   := 'FEECODE';
                         l_txmsg.txfields ('22').TYPE      := 'C';
                         l_txmsg.txfields ('22').value      := rec.FEECODE;
                    begin
                      if txpks_#1296.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success then
                        rollback;
                        PLOG.ERROR('Sinh giao dich 1296 bi loi: ');
                        PLOG.ERROR('CUSTODYCD:'||rec.CUSTODYCD);
                        PLOG.ERROR('FEECODE:'||rec.FEECODE);
                        PLOG.ERROR('TXNUM:'||rec.TXNUM);
                      else
                        commit;
                      end if;
                    end;
        end loop;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (SQLERRM || dbms_utility.format_error_backtrace);
      RAISE errnums.E_SYSTEM_ERROR;
END;
/
