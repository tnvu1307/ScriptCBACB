SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_demo_exec_cop_action (p_camastid varchar2, p_type varchar2)
IS
p_txmsg               tx.msg_rectype;
v_dtCURRDATE date;
v_count number;
v_numcmt number;
i number;
BEGIN
    select count(1) into v_count from caexec_temp;
    if v_count=0 then
        --001.Tao du lieu temp de thuc hien

        UPDATE CAMAST SET STATUS='X',LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) WHERE CAMASTID=p_camastid;

        delete from caexec_temp where camastid =p_camastid;
        commit;

        insert into caexec_temp (TLAUTOID,txnum,autoid, balance, camastid, afacctno, catype, codeid,
               excodeid, qtty, amt, aqtty, aamt, symbol, status,
               seacctno, exseacctno, parvalue, exparvalue, reportdate,
               actiondate, postingdate, description, taskcd, dutyamt,
               fullname, idcode, custodycd,custid,TRADEPLACE, SECTYPE)
        SELECT seq_tllog.NEXTVAL,systemnums.C_BATCH_PREFIXED
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0') txnum, CA.AUTOID, CA.BALANCE, ca.CAMASTID, CA.AFACCTNO,CAMAST.CATYPE, CA.CODEID,
                CA.EXCODEID, CA.QTTY, ROUND(CA.AMT) AMT, ROUND(CA.AQTTY) AQTTY,ROUND(CA.AAMT) AAMT, SYM.SYMBOL, CA.STATUS,
                CASE WHEN camast.catype = '017' THEN CA.AFACCTNO || CA.EXCODEID ELSE CA.AFACCTNO || CA.CODEID END SEACCTNO,
                CASE WHEN camast.catype = '017' THEN CA.AFACCTNO || CA.CODEID else CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END) end EXSEACCTNO,
                SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE, CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE ,CAMAST.ACTIONDATE  POSTINGDATE,
                      (CASE WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='010'
                            THEN to_char( 'Cash dividend, '||SYM.SYMBOL ||', exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', yield ' ||camast.DEVIDENTRATE ||'%, '|| cf.fullname )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C') in('C','P') AND CAMAST.catype ='010'
                            THEN to_char( 'Co tuc bang tien, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.DEVIDENTRATE ||'%, '|| cf.fullname )
                      WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='011'
                            THEN to_char( 'Dividend in kind, '||SYM.SYMBOL ||' , exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ratio ' ||camast.DEVIDENTSHARES ||', '|| cf.fullname )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C') in('C','P') AND CAMAST.catype ='011'
                            THEN to_char( 'Co tuc bang co phieu, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.DEVIDENTSHARES ||', '|| cf.fullname )
                      WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='014'
                            THEN  to_char('Secondary offer shares, '||SYM.SYMBOL ||', Exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ratio ' ||camast.RIGHTOFFRATE ||', '|| cf.fullname  )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C')  in('C','P') AND CAMAST.catype ='014'
                            THEN  to_char('Co phieu mua them, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.RIGHTOFFRATE ||', '|| cf.fullname  )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C')  in('C','P') AND CAMAST.catype ='021'
                            THEN  to_char('Co phieu thuong, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.DEVIDENTSHARES ||', '|| cf.fullname  )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C')  = 'F' AND CAMAST.catype ='021'
                            THEN  to_char('Bonus share, '||SYM.SYMBOL ||', exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', Rate ' ||camast.DEVIDENTSHARES ||', '|| cf.fullname  )
                      WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='012'  THEN  to_char('Stock split, '||SYM.SYMBOL ||', exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ratio ' ||camast.SPLITRATE ||', '|| cf.fullname  )
                      WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='013'  THEN  to_char('Stock merge, '||SYM.SYMBOL ||', exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ratio ' ||camast.SPLITRATE ||', '|| cf.fullname  )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C')  in ('C','P') AND CAMAST.catype ='013'  THEN  to_char('Gop co phieu, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.SPLITRATE ||', '|| cf.fullname  )
                      else  camast.description END)description, camast.taskcd,
                      (CASE WHEN cf.VAT='Y' THEN SYS.VARVALUE*CA.AMT/100 ELSE 0 END) DUTYAMT, CF.FULLNAME, CF.IDCODE, CF.CUSTODYCD, cf.custid, SYM.TRADEPLACE, SYM.SECTYPE
                FROM caschd CA,
                    SBSECURITIES SYM, SBSECURITIES EXSYM, CAMAST, AFMAST AF , CFMAST CF , AFTYPE TYP, SYSVAR SYS
                WHERE CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID = SYM.CODEID
                and camast.camastid =p_camastid
                AND CAMAST.EXCODEID = EXSYM.CODEID
                AND CA.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
                AND CA.DELTD ='N' AND CA.STATUS ='S' and CAMAST.STATUS ='X' AND CA.ISCI ='N' AND CA.ISSE='N'
                AND AF.ACTYPE = TYP.ACTYPE AND SYS.GRNAME='SYSTEM' AND SYS.VARNAME='CADUTY';
        commit;

        --002.Thuc hien quyen dua tren du lieu temp
        SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_dtCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
        p_txmsg.msgtype:='T';
        p_txmsg.local:='N';
        p_txmsg.tlid        := systemnums.c_system_userid;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO p_txmsg.wsname, p_txmsg.ipaddress
        FROM DUAL;
        p_txmsg.off_line    := 'N';
        p_txmsg.deltd       := txnums.c_deltd_txnormal;
        p_txmsg.txstatus    := txstatusnums.c_txcompleted;
        p_txmsg.msgsts      := '0';
        p_txmsg.ovrsts      := '0';
        p_txmsg.batchname   := 'CAEXECBF';
        p_txmsg.txdate:=v_dtCURRDATE;
        p_txmsg.busdate:=v_dtCURRDATE;
        p_txmsg.tltxcd:='3379';

        INSERT /*+ append */ INTO tllogall(autoid, txnum, txdate, txtime, brid, tlid,offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line, deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts, ovrsts, batchname, msgamt,msgacct, chktime, offtime)
        select
               REC.TLAUTOID,
               rec.txnum,--p_txmsg.txnum,
               TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),--p_txmsg.txtime,
               substr(rec.AFACCTNO,1,4),--p_txmsg.brid,
               p_txmsg.tlid,
               p_txmsg.offid,
               p_txmsg.ovrrqd,
               p_txmsg.chid,
               p_txmsg.chkid,
               p_txmsg.tltxcd,
               p_txmsg.ibt,
               p_txmsg.brid2,
               p_txmsg.tlid2,
               p_txmsg.ccyusage,
               p_txmsg.off_line,
               p_txmsg.deltd,
               TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
               rec.DESCRIPTION,--NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
               p_txmsg.ipaddress,
               p_txmsg.wsname,
               p_txmsg.txstatus,
               p_txmsg.msgsts,
               p_txmsg.ovrsts,
               p_txmsg.batchname,
               rec.AMT,--p_txmsg.txfields('10').value ,
               rec.AFACCTNO,--p_txmsg.txfields('03').value ,
               decode(p_txmsg.chktime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),p_txmsg.chktime),
               decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),p_txmsg.offtime)
        from caexec_temp rec where camastid =p_camastid;
        commit;

        INSERT /*+ append */ INTO DDTRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0012',ROUND(rec.AMT-rec.DUTYAMT,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where camastid =p_camastid and rec.AMT>0;
        commit;
        INSERT /*+ append */ INTO DDtran_gen (CUSTODYCD,CUSTID,
                                         TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                                         TXTIME,BRID,TLID,OFFID,CHID,DFACCTNO,OLD_DFACCTNO,TXTYPE,FIELD,TLLOG_AUTOID,TXDESC)
        select        REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0012',ROUND(rec.AMT-rec.DUTYAMT,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
                      TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,'' dfacctno,'' old_dfacctno,'C', 'BALANCE' ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where camastid =p_camastid and rec.amt>0;
        COMMIT;

        INSERT INTO SETRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.SEACCTNO,'0012',ROUND(rec.QTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where camastid =p_camastid and  rec.QTTY>0;
        commit;
        INSERT INTO setran_gen (CUSTODYCD,CUSTID,
                            TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                            TXTIME,BRID,TLID,OFFID,CHID,AFACCTNO,SYMBOL,
                            SECTYPE,TRADEPLACE,TXTYPE,FIELD,CODEID,TLLOG_AUTOID,TXDESC)
        select REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.SEACCTNO,'0012',ROUND(rec.QTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
            TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,REC.afacctno, REC.symbol,
            REC.sectype, REC.tradeplace, 'C', 'TRADE', REC.codeid ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where camastid =p_camastid and  rec.QTTY>0;
        commit;

        INSERT INTO SETRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.EXSEACCTNO,'0040',ROUND(rec.AQTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where camastid =p_camastid and  rec.AQTTY>0;
        commit;
        INSERT INTO setran_gen (CUSTODYCD,CUSTID,
                            TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                            TXTIME,BRID,TLID,OFFID,CHID,AFACCTNO,SYMBOL,
                            SECTYPE,TRADEPLACE,TXTYPE,FIELD,CODEID,TLLOG_AUTOID,TXDESC)
        select REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.EXSEACCTNO,'0040',ROUND(rec.AQTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
            TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,REC.afacctno, REC.symbol,
            REC.sectype, REC.tradeplace, 'D', 'TRADE', REC.codeid ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where camastid =p_camastid and  rec.AQTTY>0;
        commit;

        v_numcmt:=0;
        for rec in (select * from caexec_temp)
        loop
            v_numcmt:=v_numcmt+1;
            UPDATE SEMAST
             SET
               TRADE = TRADE - (ROUND(rec.AQTTY,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec.EXSEACCTNO and rec.aqtty>0;


          /*UPDATE CIMAST
             SET
               BALANCE = BALANCE + (ROUND(rec.AMT-rec.DUTYAMT,0)),
               LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               RECEIVING = RECEIVING - (ROUND(rec.AMT,0)),
               CRAMT = CRAMT + (ROUND(rec.AMT-rec.DUTYAMT,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec.AFACCTNO and ROUND(rec.AMT,0)>0;*/
            UPDATE DDMAST
             SET
               BALANCE = BALANCE + (ROUND(rec.AMT-rec.DUTYAMT,0)),
               --LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec.AFACCTNO and ROUND(rec.AMT,0)>0;


          /*UPDATE CAMAST
             SET
               LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), LAST_CHANGE = SYSTIMESTAMP
            WHERE CAMASTID=rec.CAMASTID;*/


          /*UPDATE SEMAST
             SET
               TRADE = TRADE + (ROUND(rec.QTTY,0)),
               RECEIVING = RECEIVING - (ROUND(rec.QTTY,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec.SEACCTNO and rec.QTTY>0;*/
            UPDATE SEMAST
             SET
               TRADE = TRADE + (ROUND(rec.QTTY,0)),
               LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec.SEACCTNO and rec.QTTY>0;

            if v_numcmt>=1000 then
                i:=i+1;
                commit;
                v_numcmt:=0;
            end if;
        end loop;

        UPDATE CASCHD SET STATUS='C' WHERE autoid in (select autoid from caexec_temp);

        --UPDATE CAMAST SET STATUS='C',LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) WHERE CAMASTID in (select camastid from caexec_temp);
        UPDATE CAMAST SET STATUS='C',LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) WHERE CAMASTID=p_camastid;

        insert into camasthist select * from camast where CAMASTID in (select camastid from caexec_temp) and status ='C';
        commit;
        delete from camast where CAMASTID in (select camastid from caexec_temp) and status ='C';
        commit;

        insert into caschdhist select * from caschd where autoid in (select autoid from caexec_temp) and status ='C';
        commit;
        delete from caschd where autoid in (select autoid from caexec_temp) and status ='C';
        commit;

        delete from caexec_temp where camastid =p_camastid;

        commit;
    end if;
end;
/
