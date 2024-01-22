SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_batch
 /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **

     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  Fsser      09-JUNE-2009   dbms_output.put_line(''); Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
 IS
  PROCEDURE pr_batch(p_apptype varchar2, p_bchmdl varchar,p_err_code  OUT varchar2,p_lastRun OUT VARCHAR2);
  PROCEDURE pr_apExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_baExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_odExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_saExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_ddExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_caExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_ODSettlementReceiveMoney(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2, p_isBOND IN VARCHAR2);
  PROCEDURE pr_DDAutoTransfer        (p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_auto_541_543        (p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_ODSettlementReceiveSec(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_ODSettlementtransferMoney(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_ODSettlementtransferFeeBroker(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_ODSettlementtransferSec(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_OrderCleanUp(p_err_code  OUT varchar2);
  PROCEDURE pr_OrderFinish(p_err_code  OUT varchar2);
  PROCEDURE pr_OrderBackUp(p_err_code  OUT varchar2);
  FUNCTION fn_SettlementOrder(p_txmsg in tx.msg_rectype,p_err_code out varchar2) RETURN NUMBER;
  PROCEDURE pr_SABackupData(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SABeforeBatch(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SABeforeBatchBF(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SAAfterBatch(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SAAfterBatchBF(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SAChangeWorkingDate(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SAGeneralWorking(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_EODAutoSendEmail(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_BODAutoSendEmail(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SendPositionReport(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_ODFee(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_CIPayFeeDepositDebit(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_CICalcFeeDeposit(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_CIPayFeeDepositSeBo(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_HoldDebitDate3384(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_LTVCal(p_bchmdl varchar,p_err_code  OUT varchar2);
  PROCEDURE pr_SEDepo(p_bchmdl varchar,p_err_code  OUT varchar2);
  PROCEDURE pr_feetranr(p_bchmdl varchar,p_err_code  OUT varchar2);
  PROCEDURE pr_BAFeeRemind(p_bchmdl varchar,p_err_code  OUT varchar2);
  PROCEDURE pr_MinimumFee(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_AutoCallCompleteCA (p_bchmdl    VARCHAR2, p_err_code   OUT VARCHAR2);
  PROCEDURE pr_ApFeeWD(p_bchmdl varchar,p_err_code  OUT varchar2);
  PROCEDURE pr_SYN2FA(p_err_code  OUT varchar2);
  PROCEDURE pr_SASendSwift(p_bchmdl VARCHAR2, p_err_code  OUT varchar2);
  PROCEDURE PR_SABACKUPDATASTP(P_ERR_CODE  OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_batch IS
  pkgctx plog.log_ctx;
  logrow tlogdebug%ROWTYPE;
-------------------------------------pr_batch--------------------------------------------
  PROCEDURE pr_batch(p_apptype varchar2, p_bchmdl varchar,p_err_code  OUT varchar2,p_lastRun OUT VARCHAR2)
  IS
    l_count NUMBER(10,0);
    l_CurrExecRow  NUMBER(10,0);
    l_RowPerPage NUMBER(10,0);
    l_action varchar2(50);
    l_CurrRow  NUMBER(10,0);
    l_FromRow   varchar2(20);
    l_ToRow   varchar2(20);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_batch');
    p_lastRun:='Y';
    --Lay ra trang se thuc hien tiep
    begin
        SELECT B.ROWPERPAGE,A.BCHSUCPAGE,B.ACTION
        Into l_RowPerPage,l_CurrExecRow, l_action
        FROM SBBATCHSTS A, SBBATCHCTL B
        WHERE A.BCHMDL = B.BCHMDL AND A.BCHSTS = ' ' AND A.BCHMDL=p_bchmdl ORDER BY B.BCHSQN;
    exception
    when others then
        p_err_code := errnums.C_SYSTEM_ERROR;
        return;
    end;
    IF l_RowPerPage>0 THEN
        l_CurrRow:=l_CurrExecRow + l_RowPerPage;
        l_FromRow:=l_CurrExecRow;
        l_ToRow:=l_CurrExecRow + l_RowPerPage-1;

        plog.debug(pkgctx,'Begin Run batch for ' || p_bchmdl || 'from row ' || l_FromRow || ' to row ' || l_ToRow);
    ELSE
        l_FromRow:=0;
        l_ToRow:=9000000000;
        plog.debug(pkgctx,'Begin Run batch for ' || p_bchmdl);
    END IF;

    --kIEM TRA XEM HOST CO O TRANG THAI ACTIVE HAY KHONG
    /*SELECT count(*) INTO l_count
    FROM SYSVAR
    WHERE GRNAME='SYSTEM'
    AND VARNAME='HOSTATUS'
    AND VARVALUE= systemnums.C_OPERATION_INACTIVE;
    IF l_count = 0 and l_action <> 'BF' THEN
        p_err_code:= errnums.C_HOST_OPERATION_STILL_ACTIVE;
        RETURN;
    END IF;*/
    
    if p_apptype='OD' then
        pr_odExecuteRouter (p_bchmdl ,p_err_code,l_FromRow,l_ToRow,p_lastRun);
    ELSIF P_APPTYPE = 'SA' THEN
      PR_SAEXECUTEROUTER(p_bchmdl,
                         p_err_code,
                         l_FromRow,
                         l_ToRow,
                         p_lastRun);
    ELSIF P_APPTYPE = 'CA' THEN
      PR_CAEXECUTEROUTER(p_bchmdl,
                         p_err_code,
                         l_FromRow,
                         l_ToRow,
                         p_lastRun);
    ELSIF P_APPTYPE = 'BA' THEN
      PR_BAEXECUTEROUTER(p_bchmdl,
                         p_err_code,
                         l_FromRow,
                         l_ToRow,
                         p_lastRun);
    ELSIF P_APPTYPE = 'DD' THEN
      PR_DDEXECUTEROUTER(p_bchmdl,
                         p_err_code,
                         l_FromRow,
                         l_ToRow,
                         p_lastRun);
    ELSIF P_APPTYPE = 'AP' THEN
      PR_APEXECUTEROUTER(p_bchmdl,
                         p_err_code,
                         l_FromRow,
                         l_ToRow,
                         p_lastRun);
    end if;



    if p_err_code <> 0 then
        return;
    end if;
    if l_RowPerPage<=0 Then
        plog.Debug(pkgctx,'End Run batch for ' || p_bchmdl);
        UPDATE SBBATCHSTS SET BCHSTS = 'Y', CMPLTIME = SYSDATE,BCHSUCPAGE=-1 WHERE UPPER(BCHMDL) = p_bchmdl AND BCHDATE=(SELECT MAX(BCHDATE) FROM SBBATCHSTS);
    else
        If p_lastRun='Y' Then
            plog.Debug(pkgctx,'End Run batch for ' || p_bchmdl || 'from row ' || l_FromRow || ' to last row');
            UPDATE SBBATCHSTS SET BCHSTS = 'Y', CMPLTIME = SYSDATE,BCHSUCPAGE=l_CurrRow WHERE UPPER(BCHMDL) = p_bchmdl AND BCHDATE=(SELECT MAX(BCHDATE) FROM SBBATCHSTS);
        Else
            plog.Debug(pkgctx,'End Run batch for ' || p_bchmdl || 'from row ' || l_FromRow || ' to row ' || l_ToRow);
            UPDATE SBBATCHSTS SET BCHSUCPAGE=l_CurrRow WHERE UPPER(BCHMDL) = p_bchmdl AND BCHDATE=(SELECT MAX(BCHDATE) FROM SBBATCHSTS);
        End If;
    end if;
    plog.setendsection(pkgctx, 'pr_batch');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_batch');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_batch;
-------------------------------------pr_apExecuteRouter--------------------------------------------
  PROCEDURE pr_apExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
    l_RCVSECTIME varchar2(2);
    l_RCVCASHTIME varchar2(2);
    l_CLEARDAY varchar2(1);
    l_CHGBCHORDERSTARTDATE date;
    l_FINISHEDCHGBCHORDERSTARTDATE date;

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_apExecuteRouter');
    p_lastRun:='Y';

    if p_bchmdl = 'APFEEWD'  then
       txpks_batch.pr_ApFeeWD(p_bchmdl ,p_err_code);
    end if;
    plog.setendsection(pkgctx, 'pr_apExecuteRouter');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_apExecuteRouter');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_apExecuteRouter;
-------------------------------------pr_baExecuteRouter--------------------------------------------
  PROCEDURE pr_baExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
    l_RCVSECTIME varchar2(2);
    l_RCVCASHTIME varchar2(2);
    l_CLEARDAY varchar2(1);
    l_CHGBCHORDERSTARTDATE date;
    l_FINISHEDCHGBCHORDERSTARTDATE date;

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_baExecuteRouter');
    p_lastRun:='Y';

    if p_bchmdl = 'LTVCAL'  then
       txpks_batch.pr_LTVCal(p_bchmdl ,p_err_code);
    elsif p_bchmdl = 'SEDEPO'  then
        txpks_batch.pr_SEDepo(p_bchmdl ,p_err_code);
    elsif p_bchmdl = 'FEETRANR'  then
        txpks_batch.pr_feetranr(p_bchmdl ,p_err_code);
    elsif p_bchmdl = 'ODFEE'  then
        txpks_batch.pr_ODFee(p_bchmdl, p_err_code, p_FromRow,p_ToRow , p_lastRun );
    elsif p_bchmdl = 'FEERM'  then
        txpks_batch.pr_BAFeeRemind(p_bchmdl, p_err_code);
    elsif p_bchmdl = 'MINFEE'  then
        txpks_batch.pr_MinimumFee(p_err_code);
    elsif p_bchmdl = 'MTXN'  then
        txpks_batch.pr_auto_541_543(p_bchmdl ,p_err_code,p_FromRow ,p_ToRow , p_lastRun);
    end if;
    plog.setendsection(pkgctx, 'pr_odExecuteRouter');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_baExecuteRouter');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_baExecuteRouter;
-------------------------------------pr_odExecuteRouter--------------------------------------------
  PROCEDURE pr_odExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
    --/*T11/2015 TTBT T+2 Begin*/
    l_RCVSECTIME varchar2(2);
    l_RCVCASHTIME varchar2(2);
    l_CLEARDAY varchar2(1);
    l_CHGBCHORDERSTARTDATE date;
    l_FINISHEDCHGBCHORDERSTARTDATE date;
    --/*T11/2015 TTBT T+2 End*/

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_odExecuteRouter');
    p_lastRun:='Y';

    if p_bchmdl = 'ODRCVM'  then --Nh? ti? ba?n
        txpks_batch.pr_ODSettlementReceiveMoney(p_bchmdl ,p_err_code,p_FromRow ,p_ToRow , p_lastRun,'N');
    elsif p_bchmdl = 'ODRCVS' then --Nh? chu?ng khoa?n mua
        txpks_batch.pr_ODSettlementReceiveSec(p_bchmdl ,p_err_code,p_FromRow ,p_ToRow , p_lastRun);
    elsif p_bchmdl='ODTRFM' then --Ca?t ti? mua
        txpks_batch.pr_ODSettlementtransferMoney(p_bchmdl ,p_err_code,p_FromRow ,p_ToRow , p_lastRun);
    elsif p_bchmdl='ODTRFS' then --Ca?t chu?ng khoa?n ba?n
        txpks_batch.pr_ODSettlementtransferSec(p_bchmdl ,p_err_code,p_FromRow ,p_ToRow , p_lastRun);
     elsif p_bchmdl='ODFEEBR' then --Chuy?n ti?n ph??TK nh?n Broker fee
        txpks_batch.pr_ODSettlementtransferFeeBroker(p_bchmdl ,p_err_code,p_FromRow ,p_ToRow , p_lastRun);
    elsif p_bchmdl ='ODCLN' then
        txpks_batch.pr_OrderCleanUp(p_err_code);
    elsif p_bchmdl='ODFSH' then
        txpks_batch.pr_OrderFinish(p_err_code);
    elsif p_bchmdl='ODBAK' then
        txpks_batch.pr_OrderBackUp(p_err_code);
    end if;

    plog.setendsection(pkgctx, 'pr_odExecuteRouter');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_odExecuteRouter');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_odExecuteRouter;

  PROCEDURE pr_ddExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_ddExecuteRouter');
    p_lastRun:='Y';
    

    if p_bchmdl ='DDFEEDEPOSITSE' then
        txpks_batch.pr_CICalcFeeDeposit(p_bchmdl ,p_err_code,p_FromRow ,p_ToRow , p_lastRun);
    elsif p_bchmdl = 'DDAUTOTRANSFER' then --Chuy?n Ti?n T? ?ng N?i B? 1 Quy
        txpks_batch.pr_DDAutoTransfer(p_bchmdl ,p_err_code,p_FromRow ,p_ToRow , p_lastRun);
    end if;

    plog.setendsection(pkgctx, 'pr_ddExecuteRouter');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_ddExecuteRouter');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ddExecuteRouter;

  PROCEDURE pr_caExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_caExecuteRouter');
    p_lastRun:='Y';
    if p_bchmdl ='HOLDEBITDATE'  then
        txpks_batch.pr_HoldDebitDate3384(p_bchmdl ,p_err_code,p_FromRow ,p_ToRow , p_lastRun);
    ELSIF p_bchmdl = 'CACOMPLETE' THEN
      txpks_batch.pr_AutoCallCompleteCA(p_bchmdl, p_err_code);

    end if;
    plog.setendsection(pkgctx, 'pr_caExecuteRouter');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_caExecuteRouter');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_caExecuteRouter;

  -------------------------------------pr_saExecuteRouter--------------------------------------------
  PROCEDURE pr_saExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_saExecuteRouter');
    p_lastRun:='Y';
    if p_bchmdl ='SABKDT' then
        txpks_batch.pr_SABackupData(p_err_code);
    elsif p_bchmdl ='SABFB' then
        txpks_batch.pr_SABeforeBatch(p_err_code);
    elsif p_bchmdl ='SABFBBF' then --batch giua ngay
        txpks_batch.pr_SAAfterBatchBF(p_err_code);
    elsif p_bchmdl ='SAAFB' then
        txpks_batch.pr_SAAfterBatch(p_err_code);
    elsif p_bchmdl ='SAAFBBF' then--batch giua ngay
        txpks_batch.pr_SAAfterBatchBF(p_err_code);
    elsif p_bchmdl ='SACWD' then
        txpks_batch.pr_SAChangeWorkingDate(p_err_code);
    elsif p_bchmdl ='SAGNWK' then
        txpks_batch.pr_SAGeneralWorking(p_err_code);
    elsif p_bchmdl ='EODSENDEMAIL' then
        txpks_batch.pr_EODAutoSendEmail(p_err_code);
    elsif p_bchmdl ='BODSENDEMAIL' then
        txpks_batch.pr_BODAutoSendEmail(p_err_code);
    elsif p_bchmdl ='POSITIONMAIL' then
        txpks_batch.pr_SendPositionReport(p_err_code);
    elsif p_bchmdl ='FEEBKAUTO' then
        cspks_ciproc.Pr_FeebookingResultAuto(p_bchmdl,p_err_code,p_FromRow,p_ToRow,p_lastRun);
    elsif p_bchmdl ='SYNCBFA' then
        txpks_batch.pr_SYN2FA(p_err_code);
    elsif p_bchmdl ='SASENDSWIFT' then
        txpks_batch.pr_SASendSwift(p_bchmdl, p_err_code);
    end if;
    plog.setendsection(pkgctx, 'pr_saExecuteRouter');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_saExecuteRouter');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_saExecuteRouter;

  ---------------------------------pr_SABackupData------------------------------------------------
  PROCEDURE pr_SABackupData(P_ERR_CODE OUT VARCHAR2) IS
    V_NEXTDATE   VARCHAR2(10);
    V_CURRDATE   VARCHAR2(10);
    V_STRFRTABLE VARCHAR2(100);
    V_STRTOTABLE VARCHAR2(100);
    V_STRSQL     VARCHAR2(2000);
    V_SQL1       VARCHAR2(1000);
    V_SQL2       VARCHAR2(1000);
    V_ERR        VARCHAR2(200);
    V_COUNT      NUMBER(10);
    v_strPRRDATE varchar2(100);

  BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'pr_SABackupData');
    V_NEXTDATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'NEXTDATE');
    V_CURRDATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'CURRDATE');
 v_strPRRDATE := cspks_system.fn_get_sysvar('SYSTEM', 'PREVDATE');

    --Gen du lieu cuoi ngay cho phan he CI
    INSERT INTO DDTRAN_GEN
      (AUTOID,
       CUSTODYCD,
       CUSTID,
       TXNUM,
       TXDATE,
       ACCTNO,
       TXCD,
       NAMT,
       CAMT,
       REF,
       DELTD,
       ACCTREF,
       TLTXCD,
       BUSDATE,
       TXDESC,
       TXTIME,
       BRID,
       TLID,
       OFFID,
       CHID,
       TXTYPE,
       FIELD,
       TLLOG_AUTOID,
       TRDESC,
       COREBANK)
      SELECT CI.AUTOID,
             AF.CUSTODYCD,
             AF.CUSTID,
             CI.TXNUM,
             CI.TXDATE,
             CI.ACCTNO,
             CI.TXCD,
             CI.NAMT,
             CI.CAMT,
             CI.REF,
             NVL(CI.DELTD, 'N') DELTD,
             CI.ACCTREF,
             TL.TLTXCD,
             TL.BUSDATE,
             CASE
               WHEN TL.TLID = '6868' THEN
                TRIM(TL.TXDESC) || ' (Online)'
               ELSE
                TL.TXDESC
             END TXDESC,
             TL.TXTIME,
             TL.BRID,
             TL.TLID,
             TL.OFFID,
             TL.CHID,
             APP.TXTYPE,
             APP.FIELD,
             TL.AUTOID,
             CASE
               WHEN CI.TRDESC IS NOT NULL THEN
                (CASE
                  WHEN TL.TLID = '6868' THEN
                   TRIM(CI.TRDESC) || ' (Online)'
                  ELSE
                   CI.TRDESC
                END)
               ELSE
                CI.TRDESC
             END TRDESC,
             AF.COREBANK
        FROM DDTRAN CI,
             TLLOG TL,
             DDMAST AF,
             APPTX APP
       WHERE CI.TXDATE = TL.TXDATE
         AND CI.TXNUM = TL.TXNUM
         AND CI.ACCTNO = AF.ACCTNO
         AND CI.TXCD = APP.TXCD
         AND APP.APPTYPE = 'DD'
         AND APP.TXTYPE IN ('D', 'C')
         AND TL.DELTD <> 'Y'
         AND CI.NAMT <> 0;
    COMMIT;

    
    -- Gen data giao dich phan he SE
    INSERT INTO SETRAN_GEN
      (AUTOID,
       CUSTODYCD,
       CUSTID,
       TXNUM,
       TXDATE,
       ACCTNO,
       TXCD,
       NAMT,
       CAMT,
       REF,
       DELTD,
       ACCTREF,
       TLTXCD,
       BUSDATE,
       TXDESC,
       TXTIME,
       BRID,
       TLID,
       OFFID,
       CHID,
       AFACCTNO,
       SYMBOL,
       SECTYPE,
       TRADEPLACE,
       TXTYPE,
       FIELD,
       CODEID,
       TLLOG_AUTOID,
       TRDESC,
       SEOFFTIME,
       SETXSTATUS)
      SELECT TR.AUTOID,
             CF.CUSTODYCD,
             CF.CUSTID,
             TR.TXNUM,
             TR.TXDATE,
             TR.ACCTNO,
             TR.TXCD,
             TR.NAMT,
             TR.CAMT,
             TR.REF,
             TR.DELTD,
             TR.ACCTREF,
             TL.TLTXCD,
             TL.BUSDATE,
             CASE
               WHEN TL.TLID = '6868' THEN
                TRIM(TL.TXDESC) || ' (Online)'
               ELSE
                TL.TXDESC
             END TXDESC,
             TL.TXTIME,
             TL.BRID,
             TL.TLID,
             TL.OFFID,
             TL.CHID,
             SE.AFACCTNO,
             SB.SYMBOL,
             SB.SECTYPE,
             SB.TRADEPLACE,
             AP.TXTYPE,
             AP.FIELD,
             SB.CODEID,
             TL.AUTOID,
             CASE
               WHEN TR.TRDESC IS NOT NULL THEN
                (CASE
                  WHEN TL.TLID = '6868' THEN
                   TRIM(TR.TRDESC) || ' (Online)'
                  ELSE
                   TR.TRDESC
                END)
               ELSE
                TR.TRDESC
             END TRDESC,
             TL.OFFTIME,
             TL.TXSTATUS
        FROM SETRAN       TR,
             TLLOG        TL,
             SBSECURITIES SB,
             SEMAST       SE,
             CFMAST       CF,
             APPTX        AP
       WHERE TR.TXDATE = TL.TXDATE
         AND TR.TXNUM = TL.TXNUM
         AND TR.ACCTNO = SE.ACCTNO
         AND SB.CODEID = SE.CODEID
         AND SE.CUSTID = CF.CUSTID
         AND TR.TXCD = AP.TXCD
         AND AP.APPTYPE = 'SE'
         AND AP.TXTYPE IN ('D', 'C')
         AND TL.DELTD <> 'Y'
         AND TR.NAMT <> 0;
    COMMIT;

    
    INSERT INTO SETRAN_GENDELT
      (AUTOID,
       CUSTODYCD,
       CUSTID,
       TXNUM,
       TXDATE,
       ACCTNO,
       TXCD,
       NAMT,
       CAMT,
       REF,
       DELTD,
       ACCTREF,
       TLTXCD,
       BUSDATE,
       TXDESC,
       TXTIME,
       BRID,
       TLID,
       OFFID,
       CHID,
       AFACCTNO,
       SYMBOL,
       SECTYPE,
       TRADEPLACE,
       TXTYPE,
       FIELD,
       CODEID,
       TLLOG_AUTOID,
       TRDESC,
       SEOFFTIME,
       SETXSTATUS)
      SELECT TR.AUTOID,
             CF.CUSTODYCD,
             CF.CUSTID,
             TR.TXNUM,
             TR.TXDATE,
             TR.ACCTNO,
             TR.TXCD,
             TR.NAMT,
             TR.CAMT,
             TR.REF,
             TR.DELTD,
             TR.ACCTREF,
             TL.TLTXCD,
             TL.BUSDATE,
             CASE
               WHEN TL.TLID = '6868' THEN
                TRIM(TL.TXDESC) || ' (Online)'
               ELSE
                TL.TXDESC
             END TXDESC,
             TL.TXTIME,
             TL.BRID,
             TL.TLID,
             TL.OFFID,
             TL.CHID,
             SE.AFACCTNO,
             SB.SYMBOL,
             SB.SECTYPE,
             SB.TRADEPLACE,
             AP.TXTYPE,
             AP.FIELD,
             SB.CODEID,
             TL.AUTOID,
             CASE
               WHEN TR.TRDESC IS NOT NULL THEN
                (CASE
                  WHEN TL.TLID = '6868' THEN
                   TRIM(TR.TRDESC) || ' (Online)'
                  ELSE
                   TR.TRDESC
                END)
               ELSE
                TR.TRDESC
             END TRDESC,
             TL.OFFTIME,
             TL.TXSTATUS
        FROM SETRAN       TR,
             TLLOG        TL,
             SBSECURITIES SB,
             SEMAST       SE,
             CFMAST       CF,
             APPTX        AP
       WHERE TR.TXDATE = TL.TXDATE
         AND TR.TXNUM = TL.TXNUM
         AND TR.ACCTNO = SE.ACCTNO
         AND SB.CODEID = SE.CODEID
         AND SE.CUSTID = CF.CUSTID
         AND TR.TXCD = AP.TXCD
         AND AP.APPTYPE = 'SE'
         AND AP.TXTYPE IN ('D', 'C')
         AND TL.DELTD = 'Y'
         AND TR.NAMT <> 0;

    COMMIT;
    --'Xoa cac bang __TRAN cua cac phan he nghiep vu
    FOR REC IN (SELECT FRTABLE, TOTABLE FROM TBLBACKUP WHERE TYPBK = 'T') LOOP
      V_STRFRTABLE := REC.FRTABLE;
      V_STRTOTABLE := REC.TOTABLE;
      V_STRSQL := 'INSERT INTO ' || V_STRTOTABLE || ' SELECT DTL.* FROM ' ||
                          V_STRFRTABLE ||
                          ' DTL, TLLOG, TLTX
                         WHERE TLLOG.TLTXCD=TLTX.TLTXCD AND TRIM(TLTX.BACKUP)=''Y''' || CASE
                            WHEN V_STRFRTABLE IN ('SETRAN',
                                                  'ODTRAN',
                                                  'CATRAN',
                                                  'AFTRAN',
                                                  'DDTRAN',
                                                  'CLTRAN',
                                                  'LNTRAN',
                                                  'DFTRAN',
                                                  'SETRAN') THEN
                             ' AND DTL.NAMT<>0 '
                            ELSE
                             ' '
                          END ||
                          'AND TLLOG.TXNUM=DTL.TXNUM AND TLLOG.TXDATE=DTL.TXDATE AND TRIM(TLLOG.TXSTATUS) IN (''1'',''3'',''7'',''4'')';

            
            EXECUTE IMMEDIATE V_STRSQL;
            INSERT INTO LOG_ERR (ID, DATE_LOG, POSITION, TEXT)
            VALUES (SEQ_LOG_ERR.NEXTVAL, SYSDATE, ' BACKUPDATA ', V_STRSQL);
            COMMIT;
            V_STRSQL := ' truncate table ' || V_STRFRTABLE;
            EXECUTE IMMEDIATE V_STRSQL;
    END LOOP;

    --TRUNG.LUU: 01-07-2020
    --Xoa bang FEETRANDETAIL
    INSERT INTO FEETRANDETAILHIST SELECT DTL.* FROM FEETRAN FE,FEETRANDETAIL DTL WHERE FE.STATUS = 'S' AND FE.AUTOID = DTL.REFID;
    DELETE FEETRANDETAIL WHERE REFID IN (SELECT AUTOID FROM FEETRAN WHERE STATUS = 'S');

    --Xoa bang FEETRAN
    INSERT INTO FEETRANA
    SELECT FE.*
    FROM FEETRAN FE
    WHERE FE.STATUS ='S' ;
    COMMIT;

    DELETE FEETRAN FE WHERE FE.STATUS ='S';
    COMMIT;

    --trung.luu : 22-07-2020 backup ddmast,semast
    insert into semast_hist(histdate, actype, acctno, codeid, afacctno, opndate, clsdate,
       lastdate, status, pstatus, irtied, ircd, costprice,
       trade, mortage, margin, netting, standing, withdraw,
       deposit, loan, blocked, receiving, transfer,
       prevqtty, dcrqtty, dcramt, depofeeacr, repo, pending,
       tbaldepo, custid, costdt, secured, iccfcd, iccftied,
       tbaldt, senddeposit, sendpending, ddroutqtty,
       ddroutamt, dtoclose, sdtoclose, qtty_transfer,
       last_change, dealintpaid, wtrade, grpordamt, emkqtty,
       blockwithdraw, blockdtoclose, receivingod, extranfer,
       blocktranfer, roomchk, shareholdersid, oldshareholdersid,
       hold, temp)
    select getcurrdate histdate, a.actype, a.acctno, a.codeid, a.afacctno, a.opndate, a.clsdate,
       a.lastdate, a.status, a.pstatus, a.irtied, a.ircd, a.costprice,
       a.trade, a.mortage, a.margin, a.netting, a.standing, a.withdraw,
       a.deposit, a.loan, a.blocked, a.receiving, a.transfer,
       a.prevqtty, a.dcrqtty, a.dcramt, a.depofeeacr, a.repo, a.pending,
       a.tbaldepo, a.custid, a.costdt, a.secured, a.iccfcd, a.iccftied,
       a.tbaldt, a.senddeposit, a.sendpending, a.ddroutqtty,
       a.ddroutamt, a.dtoclose, a.sdtoclose, a.qtty_transfer,
       a.last_change, a.dealintpaid, a.wtrade, a.grpordamt, a.emkqtty,
       a.blockwithdraw, a.blockdtoclose, a.receivingod, a.extranfer,
       a.blocktranfer, a.roomchk, a.shareholdersid, a.oldshareholdersid,
       a.hold,a.temp
    FROM semast a;
    commit;

    insert into ddmast_hist (histdate, autoid, actype, custid, afacctno, custodycd, acctno,
    ccycd, refcasaacct, balance, acramt, adramt, mcramt, mdramt, holdbalance, blockamt, receiving, netting,
    status, pstatus, opndate, clsdate, lastchange, last_change, pendinghold, pendingunhold, bankbalance,
    bankholdbalance, isdefault, depofeeacr, depofeeamt, depolastdt, corebank, accounttype, inqbankreqid, branchdate,
    autotransfer)
    select getcurrdate histdate, a.autoid, a.actype, a.custid, a.afacctno, a.custodycd, a.acctno,
       a.ccycd, a.refcasaacct, a.balance, a.acramt, a.adramt, a.mcramt,
       a.mdramt, a.holdbalance, a.blockamt, a.receiving, a.netting,
       a.status, a.pstatus, a.opndate, a.clsdate, a.lastchange,
       a.last_change, a.pendinghold, a.pendingunhold, a.bankbalance,
       a.bankholdbalance, a.isdefault, a.depofeeacr, a.depofeeamt,
       a.depolastdt, a.corebank, a.accounttype, a.inqbankreqid, a.branchdate,
       a.autotransfer
    FROM ddmast a ;
    commit;

    
    --'Sao luu du lieu bang TLLOG, TLLOGFLD Cho cac giao dich xoa
    INSERT INTO tllogdel
      SELECT TLLOG.*
        FROM TLLOG, TLTX
       WHERE TLLOG.TLTXCD = TLTX.TLTXCD
         AND TLTX.BACKUP = 'Y'
         AND TLLOG.TXSTATUS NOT IN ( '3','1','7','4') ;


    COMMIT;
    INSERT INTO tllogflddel
          SELECT DTL.*
        FROM TLLOGFLD DTL, TLLOG, TLTX
       WHERE TLLOG.TLTXCD = TLTX.TLTXCD
         AND TLTX.BACKUP = 'Y'
         AND TLLOG.TXNUM = DTL.TXNUM
         AND TLLOG.TXDATE = DTL.TXDATE
         AND TLLOG.TXSTATUS NOT IN ( '3','1','7','4') ;
    COMMIT;

    INSERT INTO TLLOGALL
    SELECT TLLOG.*
    FROM TLLOG, TLTX
    WHERE TLLOG.TLTXCD = TLTX.TLTXCD
        AND TLTX.BACKUP = 'Y'
          --and (tllog.tltxcd <> '1713' or (tllog.tltxcd = '1713' and txdate =to_date(v_strPRRDATE,systemnums.c_date_format)))
        --AND (TLLOG.TXSTATUS = '3' OR TLLOG.TXSTATUS = '1' OR TLLOG.TXSTATUS = '7' OR TLLOG.TXSTATUS = '4')
        ;
    COMMIT;

    INSERT INTO TLLOGFLDALL
      SELECT DTL.*
        FROM TLLOGFLD DTL, TLLOG, TLTX
       WHERE TLLOG.TLTXCD = TLTX.TLTXCD
         AND TLTX.BACKUP = 'Y'
         AND TLLOG.TXNUM = DTL.TXNUM
         AND TLLOG.TXDATE = DTL.TXDATE
        --and (tllog.tltxcd <> '1713' or (tllog.tltxcd = '1713' and tllog.txdate =to_date(v_strPRRDATE,systemnums.c_date_format)))
         --AND (TLLOG.TXSTATUS = '3' OR TLLOG.TXSTATUS = '1' OR TLLOG.TXSTATUS = '7' OR TLLOG.TXSTATUS = '4')
         ;
    COMMIT;

    
    --'Xoa bnag TLLOG vai?? TLLOGFLD hien tai
    if V_COUNT <> 0 then
        delete from tllog where TLTXCD not in ('1713');
        update tllog set txnum =  '76' || substr(txnum,3,10) , txdate = to_date(V_NEXTDATE,'dd/mm/rrrr')
        where TLTXCD in ('1713');
    else
        /*V_STRSQL := 'truncate table TLLOGFLD';
        EXECUTE IMMEDIATE V_STRSQL;
        V_STRSQL := 'truncate table TLLOG';
        EXECUTE IMMEDIATE V_STRSQL;*/

        --delete from tllogfld fld where txnum  in (select txnum from tllog where tllog.tltxcd <> '1713' or (tllog.tltxcd = '1713' and tllog.txdate =to_date(v_strPRRDATE,systemnums.c_date_format)));
        --delete from tllog where tllog.tltxcd <> '1713' or (tllog.tltxcd = '1713' and tllog.txdate =to_date(v_strPRRDATE,systemnums.c_date_format));

        delete from tllogfld where txnum in (SELECT TLLOG.TXNUM
                                            FROM TLLOG, TLTX
                                            WHERE TLLOG.TLTXCD = TLTX.TLTXCD
                                            AND TLTX.BACKUP = 'Y'
                                            --and (tllog.tltxcd <> '1713' or (tllog.tltxcd = '1713' and txdate =to_date(v_strPRRDATE,systemnums.c_date_format)))
                                            --AND (TLLOG.TXSTATUS = '3' OR TLLOG.TXSTATUS = '1' OR TLLOG.TXSTATUS = '7' OR TLLOG.TXSTATUS = '4')
        );
        delete from tllog where txnum in (SELECT TLLOG.TXNUM
                                            FROM TLLOG, TLTX
                                            WHERE TLLOG.TLTXCD = TLTX.TLTXCD
                                            AND TLTX.BACKUP = 'Y'
                                            --and (tllog.tltxcd <> '1713' or (tllog.tltxcd = '1713' and txdate =to_date(v_strPRRDATE,systemnums.c_date_format)))
                                            --AND (TLLOG.TXSTATUS = '3' OR TLLOG.TXSTATUS = '1' OR TLLOG.TXSTATUS = '7' OR TLLOG.TXSTATUS = '4')
        );

    end if;

    /*V_STRSQL := 'truncate table TLLOGFLD';
    EXECUTE IMMEDIATE V_STRSQL;*/

    --'Xoa cac bang khong phai bang giao dich, can backup
    FOR REC IN (SELECT FRTABLE, TOTABLE FROM TBLBACKUP WHERE TYPBK = 'N') LOOP
      V_STRFRTABLE := REC.FRTABLE;
      V_STRTOTABLE := REC.TOTABLE;
      --Sao luu __HIST
      V_STRSQL := 'INSERT INTO ' || V_STRTOTABLE || ' SELECT * FROM ' ||
                  V_STRFRTABLE;
      EXECUTE IMMEDIATE V_STRSQL;

      INSERT INTO LOG_ERR
        (ID, DATE_LOG, POSITION, TEXT)
      VALUES
        (SEQ_LOG_ERR.NEXTVAL, SYSDATE, ' BACKUPDATA ', V_STRSQL);

      COMMIT;
      V_STRSQL := 'TRUNCATE TABLE ' || V_STRFRTABLE;
      EXECUTE IMMEDIATE V_STRSQL;
    END LOOP;

    
    --'Xoa cac bang khong phai bang giao dich, khong backup
    FOR REC IN (SELECT FRTABLE, TOTABLE FROM TBLBACKUP WHERE TYPBK = 'D') LOOP
      V_STRFRTABLE := REC.FRTABLE;
      --'Xoa bang __TRONGNGAY
      V_STRSQL := 'TRUNCATE TABLE ' || V_STRFRTABLE;
      EXECUTE IMMEDIATE V_STRSQL;
      INSERT INTO LOG_ERR
        (ID, DATE_LOG, POSITION, TEXT)
      VALUES
        (SEQ_LOG_ERR.NEXTVAL, SYSDATE, ' BACKUPDATA ', V_STRSQL);

      COMMIT;
    END LOOP;

    
    --backup stdfmap
    INSERT INTO STDFMAPHIST
      SELECT *
        FROM STDFMAP
       WHERE NOT EXISTS
       (SELECT 1 FROM STSCHD WHERE STDFMAP.STSCHDID = STSCHD.AUTOID);

    DELETE STDFMAP
     WHERE NOT EXISTS
     (SELECT 1 FROM STSCHD WHERE STDFMAP.STSCHDID = STSCHD.AUTOID);

    --TRUNG.LUU
    --backkup crbtxreq (request qua bank , C,R,E     --> rieng C hold and UNHOLD = 'N')
    INSERT INTO CRBTXREQHIST
    SELECT * FROM CRBTXREQ WHERE STATUS IN ('R','E','C') AND OBJNAME <> '6690' AND REQCODE NOT IN ('INQACCT');
    --DOI VOI GD 6690 PHAI UNHOLD XONG MOI BACKUP
    INSERT INTO CRBTXREQHIST
    SELECT *FROM CRBTXREQ WHERE STATUS = 'C' AND UNHOLD = 'Y' AND OBJNAME = '6690';

    DELETE FROM CRBTXREQ WHERE STATUS IN ('R','E','C') AND OBJNAME <> '6690' AND REQCODE NOT IN ('INQACCT');
    DELETE FROM CRBTXREQ WHERE STATUS = 'C' AND UNHOLD = 'Y' AND OBJNAME = '6690';

    --backup  crbbankrequestdtl bank detail tra ve
    INSERT INTO crbbankrequestdtlHIST
    SELECT *from crbbankrequestdtl where reqid in(  select AUTOID from crbbankrequest WHERE isconfirmed = 'Y' and (errordesc NOT like '%Got error at CBPlus%' OR errordesc IS NULL));
    DELETE from crbbankrequestdtl where reqid in(  select AUTOID from crbbankrequest WHERE isconfirmed = 'Y' and (errordesc NOT like '%Got error at CBPlus%' OR errordesc IS NULL));
    --backup  crbbankrequest bank tra ve(chua lai : ISCONFIRMED =N, ERRORDESC like '%CBPlus error%')
    INSERT INTO crbbankrequesthist
    select *from crbbankrequest WHERE isconfirmed = 'Y' and (errordesc NOT like '%Got error at CBPlus%' OR errordesc IS NULL);
    DELETE from crbbankrequest WHERE isconfirmed = 'Y' and (errordesc NOT like '%Got error at CBPlus%' OR errordesc IS NULL);
    --backup swiftmsgmaplogdtl --incomming msg
    INSERT INTO swiftmsgmaplogdtlhist
    select *from swiftmsgmaplogdtl where msgid in (select msgid from swiftmsgmaplog where status = 'C' and cfnstatus <> 'P') and TRUNC(createdate) <= getprevdate(getcurrdate,3);
    DELETE from swiftmsgmaplogdtl where msgid in (select msgid from swiftmsgmaplog where status = 'C' and cfnstatus <> 'P') and TRUNC(createdate) <= getprevdate(getcurrdate,3);
    --backup swiftmsgmaplog --incomming msg
    INSERT INTO swiftmsgmaplogHIST
    select * from swiftmsgmaplog where status = 'C' and cfnstatus <> 'P' and TRUNC(createdate) <= getprevdate(getcurrdate,3);
    DELETE from swiftmsgmaplog where status = 'C' and cfnstatus <> 'P' and TRUNC(createdate) <= getprevdate(getcurrdate,3);

    --backup buf_dd_member
    insert into buf_dd_member_hist
    select *from buf_dd_member;
    delete from buf_dd_member;

    --backup buf_se_member
    insert into buf_se_member_hist
        select *from buf_se_member;
    delete from buf_se_member;

    --Kiem tra tao sequence moi
    FOR REC IN (SELECT FRTABLE, TOTABLE FROM TBLBACKUP WHERE TYPBK = 'S') LOOP
      V_STRFRTABLE := REC.FRTABLE;
      SELECT COUNT(*)
        INTO V_COUNT
        FROM USER_SEQUENCES
       WHERE SEQUENCE_NAME = V_STRFRTABLE;
      IF V_COUNT > 0 THEN
        INSERT INTO LOG_ERR
          (ID, DATE_LOG, POSITION, TEXT)
        VALUES
          (SEQ_LOG_ERR.NEXTVAL,
           SYSDATE,
           ' BACKUPDATA ',
           'Begin reset seq_' || V_STRFRTABLE);
        COMMIT;
        RESET_SEQUENCE(SEQ_NAME => V_STRFRTABLE, STARTVALUE => 1);
        COMMIT;
      ELSE

        V_SQL2 := 'CREATE SEQUENCE ' || V_STRFRTABLE || '
                  INCREMENT BY 1
                  START WITH 1
                  MINVALUE 1
                  MAXVALUE 999999999999999999999999999
                  NOCYCLE
                  NOORDER
                  NOCACHE';
        INSERT INTO LOG_ERR
          (ID, DATE_LOG, POSITION, TEXT)
        VALUES
          (SEQ_LOG_ERR.NEXTVAL, SYSDATE, ' BACKUPDATA ', V_SQL2);
        COMMIT;
        EXECUTE IMMEDIATE V_SQL2;
      END IF;
      COMMIT;
    END LOOP;
    -- sequence dac biet
    BEGIN
        SELECT COUNT(*)
        INTO V_COUNT
        FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'SEQ_REFNO_DOCSTRANSFER';

        IF V_COUNT > 0 THEN
            IF TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR') <> TO_CHAR(TO_DATE(V_NEXTDATE,'DD/MM/RRRR'),'RRRR') THEN
                RESET_SEQUENCE(SEQ_NAME => 'SEQ_REFNO_DOCSTRANSFER', STARTVALUE => 1);
                COMMIT;
            END IF;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX, SQLERRM);
        
    END;
     

    INSERT INTO LOG_ERR
      (ID, DATE_LOG, POSITION, TEXT)
    VALUES
      (SEQ_LOG_ERR.NEXTVAL, SYSDATE, ' BACKUPDATA ', V_SQL2);
    COMMIT;

    INSERT INTO TLLOG4DRALL
      SELECT * FROM TLLOG4DR WHERE TXSTATUS IN ('5', '8');
    V_STRSQL := 'truncate table tllog4dr';
    EXECUTE IMMEDIATE V_STRSQL;
    COMMIT;
--THUNT-12/03/2020: XU LY BATCH CHO FEE
    INSERT INTO FEE_BOOKING_RESULTHIST
        SELECT*FROM FEE_BOOKING_RESULT WHERE STATUS <> 'P';
    DELETE FROM FEE_BOOKING_RESULT WHERE STATUS <> 'P';
    COMMIT;
--THUNT-18/03/2020: XU LY BATCH CASCHDDTL, CAMASTDTL
    INSERT INTO CASCHDDTLHIST
        SELECT*FROM CASCHDDTL WHERE STATUS IN ('C','D');
    DELETE FROM CASCHDDTL WHERE STATUS IN ('C','D');
    COMMIT;

    INSERT INTO CAMASTDTLHIST
        SELECT*FROM CAMASTDTL WHERE STATUS IN ('J');
    DELETE FROM CAMASTDTL WHERE STATUS IN ('C','D');
    COMMIT;

--THUNT-29/02/2020:KHONG XU LY DOI VOI CAC MAIL CHO GUI
    --trung.luu:07-04-2020 khong backup trang thai O,P
    INSERT INTO EMAILLOGHIST
    SELECT * FROM EMAILLOG
    WHERE STATUS NOT IN('A','O','P','N') AND TEMPLATEID NOT IN ('0222');
    DELETE EMAILLOG WHERE STATUS NOT IN( 'A','O','P','N') AND TEMPLATEID NOT IN ('0222');

    INSERT INTO EMAILLOGHIST
    SELECT * FROM EMAILLOG WHERE TEMPLATEID = '0222'
    AND STATUS <> 'A'
    AND TO_DATE(TO_CHAR(CREATETIME, 'dd/mm/RRRR'), 'dd/mm/RRRR') = GET_T_DATE(GETCURRDATE, 2);

    DELETE EMAILLOG
    WHERE TEMPLATEID = '0222'
    AND STATUS <> 'A'
    AND TO_DATE(TO_CHAR(CREATETIME, 'dd/mm/RRRR'), 'dd/mm/RRRR') = GET_T_DATE(GETCURRDATE, 2);
    COMMIT;

    insert into securities_info_hist
    (AUTOID,CODEID,SYMBOL, HISTDATE,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,
        ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,
        CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,
        TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,
        ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,
        MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,
        ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,
        ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30,ISSUED_SHARES_QTTY,OLDCIRCULATINGQTTY,NEWCIRCULATINGQTTY,FOREIGNROOM,LTVRATE)
    select AUTOID,CODEID,SYMBOL,to_date(V_CURRDATE,'DD/MM/RRRR') HISTDATE,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,
        ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,
        CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,
        TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,
        ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,
        MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,
        ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,
        ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30,ISSUED_SHARES_QTTY,OLDCIRCULATINGQTTY,NEWCIRCULATINGQTTY,FOREIGNROOM,LTVRATE
    From securities_info;

    -- log hist TBL_2260
    INSERT INTO TBL_2260_LOG
    SELECT CQ.*, CU.CUSTODYCD, NVL(CU.BALANCE, 0) BALANCE, CU.FULLNAME, SY.HISTDATE,
        NVL(SE.CLOSEPRICE, 0) CLOSEPRICE, MTB.PRICEADD,
        (CQ.QTTY * NVL(SE.CLOSEPRICE, 0) + AMTADD) MBALANCE,
        (-(CQ.QTTY * NVL(SE.CLOSEPRICE, 0) + AMTADD) + NVL(CU.BALANCE, 0)) DIFBALANCE
    FROM SECURITIES_INFO SE, TBL_2260 MTB,
    (
        SELECT GETCURRDATE HISTDATE FROM DUAL
    ) SY,
    (
        SELECT TB.REFAUTOID, TB.SYMBOL, TB.STATUS, MIN(TB.TXDATE) TXDATE, SUM(QTTY) QTTY, SUM(QTTYADD) QTTYADD, SUM((QTTYADD - QTTY) * PRICEADD) AMTADD, MAX(AUTOID) MAUTOID
        FROM TBL_2260 TB
        WHERE TB.DELTD = 'N'
        AND NOT EXISTS (
            SELECT LOG.REFAUTOID FROM TBL_2260_LOG LOG WHERE LOG.STATUS = 'C' AND LOG.REFAUTOID = TB.REFAUTOID
        )
        GROUP BY TB.REFAUTOID, TB.STATUS, TB.SYMBOL
    ) CQ,
    (
        SELECT TB.REFAUTOID, TB.CUSTODYCD, CF.FULLNAME,
            SUM(CASE WHEN TB.TRANTYPE = 'C' THEN TB.BALANCE ELSE -TB.BALANCE END) BALANCE
        FROM TBL_2261 TB, CFMAST CF
        WHERE TB.DELTD = 'N'
        AND TB.CUSTODYCD = CF.CUSTODYCD
        GROUP BY TB.REFAUTOID, TB.CUSTODYCD, CF.FULLNAME
    ) CU
    WHERE CQ.MAUTOID = MTB.AUTOID
    AND CQ.REFAUTOID = CU.REFAUTOID(+)
    AND CQ.SYMBOL = SE.SYMBOL(+);

    
    PLOG.SETENDSECTION(PKGCTX, 'pr_SABackupData');
  EXCEPTION
    WHEN OTHERS THEN
      P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
      PLOG.ERROR(PKGCTX, SQLERRM);
      
      PLOG.SETENDSECTION(PKGCTX, 'pr_SABackupData');
      RAISE ERRNUMS.E_SYSTEM_ERROR;
  END PR_SABACKUPDATA;

  ---------------------------------pr_SABeforeBatch------------------------------------------------
  PROCEDURE pr_SABeforeBatch(p_err_code  OUT varchar2)
  IS
    v_nextdate varchar2(10);
    v_currdate varchar2(10);
    v_dblTAXRATE number;
    l_err_param varchar2(300);
    l_count NUMBER(20);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_SABeforeBatch');
    p_err_code:=0;
    v_currdate:= cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');

      SELECT count(*) into l_count
      FROM TLLOG WHERE DELTD <> 'Y' AND TXSTATUS IN ('4','7','3') ;
       IF l_count <> 0 then
         P_ERR_CODE:='-100148';
         RETURN;
         PLOG.SETENDSECTION(PKGCTX, 'pr_SABEGINBATCH');
       ELSE
       
       --trung.luu: 07-04-2020 tu dong dong cua hoi so va chi nhanh

         UPDATE BRGRP SET STATUS='C';

         UPDATE SYSVAR
           SET VARVALUE = '0'
         WHERE GRNAME = 'SYSTEM'
           AND VARNAME = 'HOSTATUS';


       END IF;


    plog.setendsection(pkgctx, 'pr_SABeforeBatch');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM  || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SABeforeBatch');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SABeforeBatch;

  ---------------------------------pr_SABeforeBatch------------------------------------------------
  PROCEDURE pr_SABeforeBatchBF(p_err_code  OUT varchar2)
  IS
    v_nextdate varchar2(10);
    v_currdate varchar2(10);
    v_dblTAXRATE number;
    l_err_param varchar2(300);
    l_count NUMBER(20);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_SABeforeBatchBF');
    p_err_code:=0;
    v_currdate:= cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');

      /*SELECT count(*) into l_count
      FROM TLLOG WHERE DELTD <> 'Y' AND TXSTATUS IN ('4','7','3') ;
       IF l_count <> 0 then
         P_ERR_CODE:='-100148';
         RETURN;
         PLOG.SETENDSECTION(PKGCTX, 'pr_SABeforeBatchBF');
       ELSE*/
       --trung.luu: 07-04-2020 tu dong dong cua hoi so va chi nhanh

         UPDATE BRGRP SET STATUS='C';

         UPDATE SYSVAR
           SET VARVALUE = '0'
         WHERE GRNAME = 'SYSTEM'
           AND VARNAME = 'HOSTATUS';


      -- END IF;


    plog.setendsection(pkgctx, 'pr_SABeforeBatchBF');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM  || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SABeforeBatchBF');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SABeforeBatchBF;

  ---------------------------------pr_SAAfterBatch------------------------------------------------
  PROCEDURE pr_SAAfterBatch(p_err_code  OUT varchar2)
  IS
    v_nextdate varchar2(10);
    v_currdate date;
    l_maxdebtqttyrate number(20,4);
    l_maxdebtse number(20,0);
    l_iratio number(20,4);
    v_prinused number;
    V_FIRSTDAY DATE;
    l_UnHoldRealTime varchar2(3);
    l_prevDate VARCHAR2(10);
    v_sysvar varchar(10);
    n_amount number;
    WDRTYPE varchar2(10);
    v_MAX_NUMBER_VALUE number;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_SAAfterBatch');

    v_currdate  := getcurrdate;
    --trung.luu: 07-04-2020 tu dong mo cua hoi so,chi nhanh
    UPDATE SYSVAR
       SET VARVALUE = '1'
     WHERE GRNAME = 'SYSTEM'
       AND VARNAME = 'HOSTATUS';

    UPDATE BRGRP SET STATUS='A';

    l_prevDate := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'PREVDATE');
    IF trunc(TO_DATE(v_currdate, systemnums.C_DATE_FORMAT), 'MM') <> trunc(TO_DATE(l_prevDate, systemnums.C_DATE_FORMAT), 'MM') THEN
      nmpks_ems.pr_GenTemplateEM09;

    END IF;



    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_SAAfterBatch');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SAAfterBatch');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SAAfterBatch;

  ---------------------------------pr_SAAfterBatchBF------------------------------------------------
  PROCEDURE pr_SAAfterBatchBF(p_err_code  OUT varchar2)
  IS
    v_nextdate varchar2(10);
    v_currdate date;
    l_maxdebtqttyrate number(20,4);
    l_maxdebtse number(20,0);
    l_iratio number(20,4);
    v_prinused number;
    V_FIRSTDAY DATE;
    l_UnHoldRealTime varchar2(3);
    l_prevDate VARCHAR2(10);
    v_sysvar varchar(10);
    n_amount number;
    WDRTYPE varchar2(10);
    v_MAX_NUMBER_VALUE number;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_SAAfterBatchBF');

    v_currdate  := getcurrdate;
    --trung.luu: 07-04-2020 tu dong mo cua hoi so,chi nhanh
    UPDATE SYSVAR
       SET VARVALUE = '1'
     WHERE GRNAME = 'SYSTEM'
       AND VARNAME = 'HOSTATUS';

    UPDATE BRGRP SET STATUS='A';

    l_prevDate := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'PREVDATE');
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_SAAfterBatchBF');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SAAfterBatchBF');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SAAfterBatchBF;

  ---------------------------------pr_SAChangeWorkingDate------------------------------------------------
  PROCEDURE pr_SAChangeWorkingDate(P_ERR_CODE OUT VARCHAR2) IS
    V_NEXTDATE    VARCHAR2(20);
    V_CURRDATE    VARCHAR2(20);
    V_PREVDATE    VARCHAR2(20);
    V_DUEDATE     VARCHAR2(20);
    V_INTNUM      NUMBER;
    V_INTBKNUM    NUMBER;
    V_INTNEXTNUM  NUMBER;
    V_STRLAST_DAY VARCHAR2(20);
     v_advclearday NUMBER;
    V_TOTALFEE   NUMBER(20,4);
    V_REPAIRFEE  NUMBER(20,4);
    V_FEECD      VARCHAR2(5);
    V_FEERATE    NUMBER(20,4);
    V_CCYCD      VARCHAR2(20);
    V_DESC    VARCHAR2(500);
    v_sysvar varchar(10);
    n_amount number;
    WDRTYPE varchar2(10);
    v_MAX_NUMBER_VALUE number;
    --v_prinused number;
  BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'pr_SAChangeWorkingDate');
    V_NEXTDATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'NEXTDATE');
    V_CURRDATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'CURRDATE');

    IF TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'RRRR') <>
       TO_CHAR(TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT), 'RRRR') THEN
      UPDATE SBCLDR
         SET SBEOY = 'Y', SBEOQ = 'Y', SBEOM = 'Y'
       WHERE CLDRTYPE = '000'
         AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    ELSIF TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM') <>
          TO_CHAR(TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM') AND
          MOD(TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM'),
              3) = 0 THEN
      UPDATE SBCLDR
         SET SBEOQ = 'Y', SBEOM = 'Y'
       WHERE CLDRTYPE = '000'
         AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    ELSIF TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM') <>
          TO_CHAR(TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM') THEN
      UPDATE SBCLDR
         SET SBEOM = 'Y'
       WHERE CLDRTYPE = '000'
         AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    ELSIF TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'IW') <>
          TO_CHAR(TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT), 'IW') THEN
      UPDATE SBCLDR
         SET SBEOW = 'Y'
       WHERE CLDRTYPE = '000'
         AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    END IF;
    --CAP NHAT CAC LOAI HINH ODTYPE DEN HAN SU DUNG
    UPDATE ODTYPE
       SET STATUS = 'Y'
     WHERE STATUS = 'N'
       AND TO_DATE(VALDATE, SYSTEMNUMS.C_DATE_FORMAT) >=
           TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT);

    --CAP NHAT CAC LOAI HINH ODTYPE HET HAN SU DUNG
    UPDATE ODTYPE
       SET STATUS = 'N'
     WHERE STATUS = 'Y'
       AND TO_DATE(EXPDATE, SYSTEMNUMS.C_DATE_FORMAT) <=
           TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT);

    -- Gen Report Month
    IF TO_CHAR(TO_DATE(V_CURRDATE, systemnums.C_DATE_FORMAT), 'MM') <> TO_CHAR(TO_DATE(V_NEXTDATE, systemnums.C_DATE_FORMAT), 'MM') THEN
      fopks_report.pr_autoExecRptAuto('M');
    END IF;
    --TungNT added, backup du lieu va reset seq phan he RM
    BEGIN
      CSPKS_RMPROC.PR_CHANGEWORKINGDATE(P_ERR_CODE);
    EXCEPTION
      WHEN OTHERS THEN
        PLOG.DEBUG(PKGCTX, 'Backup RM failed!');
        PLOG.ERROR(PKGCTX, SQLERRM);
    END;
    --End
   
    --PhuongHT add_ log Rtt truoc khi doi ngay
    --CSPKS_LOGPROC.PR_LOG_MARGINRATE_LOG('AF-END');
    -- end of PhuongHT add
    --Ngay lam viec truoc
    V_PREVDATE := V_CURRDATE;
    BEGIN
      SELECT TO_CHAR(MIN(SBDATE), 'DD/MM/RRRR')
        INTO V_CURRDATE
        FROM SBCLDR
       WHERE CLDRTYPE = '000'
         AND HOLIDAY = 'N'
         AND SBDATE > TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    EXCEPTION
      WHEN OTHERS THEN
        PLOG.DEBUG(PKGCTX,
                   'l_lngErrCode: ' || ERRNUMS.C_SA_CALENDAR_MISSING);
        P_ERR_CODE := ERRNUMS.C_SA_CALENDAR_MISSING;
        RETURN;
    END;

    --Ngay lam viec tiep theo
    BEGIN
      SELECT TO_CHAR(MIN(SBDATE), 'DD/MM/RRRR')
        INTO V_NEXTDATE
        FROM SBCLDR
       WHERE CLDRTYPE = '000'
         AND HOLIDAY = 'N'
         AND SBDATE > TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    EXCEPTION
      WHEN OTHERS THEN
        PLOG.DEBUG(PKGCTX,
                   'l_lngErrCode: ' || ERRNUMS.C_SA_CALENDAR_MISSING);
        P_ERR_CODE := ERRNUMS.C_SA_CALENDAR_MISSING;
        RETURN;
    END;

    --Ngay lam viec tiep theo
    BEGIN
      SELECT TO_CHAR(MAX(SBDATE), 'DD/MM/RRRR')
        INTO V_DUEDATE
        FROM SBCLDR
       WHERE CLDRTYPE = '000'
         AND HOLIDAY = 'N'
         AND SBDATE < TO_DATE(V_PREVDATE, SYSTEMNUMS.C_DATE_FORMAT);
    EXCEPTION
      WHEN OTHERS THEN
        PLOG.DEBUG(PKGCTX,
                   'l_lngErrCode: ' || ERRNUMS.C_SA_CALENDAR_MISSING);
        P_ERR_CODE := ERRNUMS.C_SA_CALENDAR_MISSING;
        RETURN;
    END;
    --Dat lai thong tin bang SYSVAR
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'DUEDATE', V_DUEDATE);
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'PREVDATE', V_PREVDATE);
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'CURRDATE', V_CURRDATE);
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'BUSDATE', V_CURRDATE);
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'NEXTDATE', V_NEXTDATE);
    --Cap nhat lai tin trong SBCLDR
    UPDATE SBCLDR
       SET SBBUSDAY = 'N'
     WHERE CLDRTYPE = '000'
       AND SBDATE = TO_DATE(V_PREVDATE, SYSTEMNUMS.C_DATE_FORMAT);
    UPDATE SBCLDR
       SET SBBUSDAY = 'Y'
     WHERE CLDRTYPE = '000'
       AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);




    --trung.luu dau ngay cap nhat lai so du 2000000000000 cho tai khoan tu doanh
        --lay sysvar tai khoan tu doanh

    select varvalue into v_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';
    select to_number(varvalue) into v_MAX_NUMBER_VALUE from sysvar where varname = 'MAX_NUMBER_VALUE';
    for r in (select dd.custodycd,dd.acctno,dd.balance from cfmast cf, ddmast dd
                    where   instr(cf.custodycd,v_sysvar) > 0
                        and cf.custodycd = dd.custodycd
                        and dd.status <> 'C'
                        and dd.isdefault = 'Y'
                )
    loop
        -- ddmast balance > n_balance_TD =>goi 023 giam tien
        -- ddmast balance < n_balance_TD =>goi 022 giam tien
        if r.balance > v_MAX_NUMBER_VALUE then
            WDRTYPE := '023';
            n_amount := r.balance - v_MAX_NUMBER_VALUE;
            pck_bankapi.c_d_balance(r.custodycd,r.acctno,WDRTYPE,n_amount,'0001',p_err_code);
        else
            WDRTYPE := '022';
            n_amount := v_MAX_NUMBER_VALUE - r.balance;
            pck_bankapi.c_d_balance(r.custodycd,r.acctno,WDRTYPE,n_amount,'0001',p_err_code);
        end if;
    end loop;

commit;
    --Xu ly dang ky goi chinh sach
    --cspks_cfproc.pr_AutoChangePolicy(P_ERR_CODE);
    --End Xu ly dang ky goi chinh sach

    P_ERR_CODE := 0;
    PLOG.SETENDSECTION(PKGCTX, 'pr_SAChangeWorkingDate');
  EXCEPTION
    WHEN OTHERS THEN
      P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
      PLOG.ERROR(PKGCTX, SQLERRM || dbms_utility.format_error_backtrace);
      PLOG.SETENDSECTION(PKGCTX, 'pr_SAChangeWorkingDate');
      RAISE ERRNUMS.E_SYSTEM_ERROR;
  END PR_SACHANGEWORKINGDATE;

  ---------------------------------pr_SAGeneralWorking------------------------------------------------
  PROCEDURE pr_SAGeneralWorking(p_err_code  OUT varchar2)
  IS
    v_currdate      date;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_SAGeneralWorking');

    v_currdate := getcurrdate;

    sp_generate_gl(v_currdate);
    Commit;
/*thunt-27/02/2020:CB tu dong quet danh sach nam giu de phat hien new holding cua event*/
    begin
        for rec in
        (
            select ca.camastid from camast ca where ca.status='N' and ca.deltd='N' and /*ca.actiondate <= v_currdate or*/ v_currdate <= ca.reportdate
        )loop
            begin
                ca_autocall3312(rec.camastid);
                ca_autocall3322(rec.camastid,null); --NAMLY 27/03/2020 SHBVNEX-761
            exception
              when others
               then
                    rollback;
                    plog.error (pkgctx, 'camastid:' || rec.camastid || '.' || sqlerrm || dbms_utility.format_error_backtrace);
                    continue;
            end;
            commit;
        end loop;
    end;

    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_SAGeneralWorking');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SAGeneralWorking');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SAGeneralWorking;

  ---------------------------------pr_EODAutoSendEmail------------------------------------------------
  PROCEDURE pr_EODAutoSendEmail(p_err_code  OUT varchar2)
  IS
    v_prevdate5 date;
    v_currdate date;
    v_prevdate2 date;

    v_strFRTABLE   varchar2(100);
    v_strTOTABLE   varchar2(100);
    v_strSQL       varchar2(2000);
    v_Sql1 varchar2(1000);
    v_Sql2 varchar2(1000);
    v_err          varchar2(200);
    v_count number(10);
    l_strDesc varchar2(200);
    v_curacctno varchar2(20);
    v_accleader varchar2(20);
    v_camastid varchar2(30);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_EODAutoSendEmail');

    v_currdate := getcurrdate();
    v_prevdate5 := getnextbusinessdate(v_currdate,5);
    v_prevdate2 := getnextbusinessdate(v_currdate,2);
    NMPKS_EMS.pr_GenTemplate202E(v_currdate,v_currdate);--SEND EMAIL: SWIFT SUMMARY
    NMPKS_EMS.pr_GenTemplate206E(v_currdate);--SEND MAIL : POSITION REPORT
    NMPKS_EMS.pr_GenTemplate201E;--SEND MAIL : 4% email notification

     --locpt add tu dong gen swift nhac nho khi den ngay
     GEN_REMIND_SWIFT564_014_023();
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_EODAutoSendEmail');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_EODAutoSendEmail');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_EODAutoSendEmail;

  ---------------------------------pr_BODAutoSendEmail------------------------------------------------
  PROCEDURE pr_BODAutoSendEmail(p_err_code  OUT varchar2)
  IS
    v_currdate date;
    v_count number;
  BEGIN
/*================================================================================*/
--EDIT      TIME             DESC
--thunt     09/04/2020       send mail chaser
/*================================================================================*/
    plog.setbeginsection(pkgctx, 'pr_BODAutoSendEmail');
    v_currdate := getcurrdate();
    sendmailreminder(v_currdate);
    --Thoai.tran 02/06/2022 Send mail EM99 EM98
    /*INSERT INTO CAREMINDER_LOG (camastid,symbol,reportdate,exdate,capturedate,tempem,status,autoid)
    SELECT CA.CAMASTID, SB.SYMBOL, CA.REPORTDATE,GETPREVDATE(CA.REPORTDATE,1) EXDATE,
    TO_CHAR(SYSDATE,'DD/MM/RRRR') CAPTUREDATE,'EM99','P',seq_careminder_log.NEXTVAL
    FROM CAMAST CA,SBSECURITIES SB
    WHERE CA.CODEID=SB.CODEID and GETPREVDATE(CA.REPORTDATE,1) = v_currdate;*/
    --trung.luu: 14-05-2021 log de gui mail 010017
    -- Trung.luu: 14-05-2021 jira  SHBVNEX-1964    khong not trang thai nen lay het cac remind co reminddate = currdate.
    for r in (
                select * from sbactimst sb where   sb.reminddate = v_currdate  and sb.email is not null and sb.repeat not in('5','2')
             )
    loop
        select count(*) into v_count from SBACTIMST_EMAIL where sbactimst_autoid = r.autoid and status = 'P' and reminddate = r.reminddate;
        if v_count = 0 then
            insert into SBACTIMST_EMAIL
               (autoid, sbactimst_autoid, reminddate, endreminddate,remindtime, repeat, numberremind, status,repeatdate_next)
            values
               (seq_SBACTIMST_EMAIL.nextval,r.autoid,r.reminddate,r.endreminddate,r.remindtime,r.repeat,r.numberremind,'P', v_currdate)
            ;
        end if;
    end loop;

    for r in (
                select * from sbactimst sb
                    where   sbstatus not in('C','D','F')
                        and sb.email is not null
                        and sb.repeat  in('5','2')  --2   Remind monthly     --5   Remind daily
             )
    loop
        if r.repeat = '5' then
            insert into SBACTIMST_EMAIL
               (autoid, sbactimst_autoid, reminddate, endreminddate,remindtime, repeat, numberremind, status,repeatdate_next)
            values
               (seq_SBACTIMST_EMAIL.nextval,r.autoid,v_currdate,r.endreminddate,r.remindtime,r.repeat,r.numberremind,'P', v_currdate)
            ;
        elsif r.repeat = '2' then
            if add_months(r.reminddate,1) = v_currdate then
                insert into SBACTIMST_EMAIL
                   (autoid, sbactimst_autoid, reminddate, endreminddate,remindtime, repeat, numberremind, status,repeatdate_next)
                values
                   (seq_SBACTIMST_EMAIL.nextval,r.autoid,v_currdate,r.endreminddate,r.remindtime,r.repeat,r.numberremind,'P', v_currdate)
                ;
            end if;
        end if;
    end loop;

    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_BODAutoSendEmail');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_BODAutoSendEmail');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_BODAutoSendEmail;



  ---------------------------------pr_BODAutoSendEmail------------------------------------------------
  PROCEDURE pr_SendPositionReport(p_err_code  OUT varchar2) --TRUNG.LUU: 25-05-2021 SHBVNEX-1839
  IS
    v_currdate date;
    v_count number;
    l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strTXDATEDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      v_dblProfit number(20,0);
      v_dblLoss number(20,0);
      v_dblAVLRCVAMT  number(20,0);
      v_dblVATRATE number(20,0);
      l_err_param varchar2(300);
      l_MaxRow number(20,0);
      v_COMPANYCD VARCHAR2(10);
      V_TEST VARCHAR2(100);
  BEGIN
/*================================================================================*/
/*================================================================================*/
        plog.setbeginsection(pkgctx, 'pr_SendPositionReport');
        v_strTXDATEDATE := TO_CHAR(getprevworkingdate(getcurrdate()),'DD/MM/RRRR');
        v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');


        SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8806';

        SELECT varvalue
        INTO v_strCURRDATE
        FROM sysvar
        WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := systemnums.c_system_userid;
        l_txmsg.brid        := systemnums.C_BATCH_BRID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'BATCH';
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate      := to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      := '8806';
        for r in ( SELECT *FROM VW_SEND_POSITION_REPORT_BATCH   )
        LOOP
            --Set txnum
            SELECT systemnums.C_BATCH_PREFIXED
                             || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                      INTO l_txmsg.txnum
                      FROM DUAL;
            --15    Trading Account   C
             l_txmsg.txfields ('15').defname   := 'PCUSTODYCD';
             l_txmsg.txfields ('15').TYPE      := 'C';
             l_txmsg.txfields ('15').value      := 'ALL';
            --14    GCB   C
             l_txmsg.txfields ('14').defname   := 'GCB';
             l_txmsg.txfields ('14').TYPE      := 'C';
             l_txmsg.txfields ('14').value      := 'ALL';
            --13    AMC   C
             l_txmsg.txfields ('13').defname   := 'AMC';
             l_txmsg.txfields ('13').TYPE      := 'C';
             l_txmsg.txfields ('13').value      := 'ALL';
            --30    Di?n gi?i   C
             l_txmsg.txfields ('30').defname   := 'DESC';
             l_txmsg.txfields ('30').TYPE      := 'C';
             l_txmsg.txfields ('30').value      := v_strEN_Desc;
            --04    Loa?i dang ky? gu?i   C
             l_txmsg.txfields ('04').defname   := 'REGISTTYPE';
             l_txmsg.txfields ('04').TYPE      := 'C';
             l_txmsg.txfields ('04').value      := r.REGISTTYPE;
            --20    Ng?y giao d?ch   D
             l_txmsg.txfields ('20').defname   := 'TXDATE';
             l_txmsg.txfields ('20').TYPE      := 'D';
             l_txmsg.txfields ('20').value      := v_strTXDATEDATE;
            p_err_code:=0;

            IF  txpks_#8806.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
                plog.error (pkgctx,'got error 8820: '|| p_err_code);
                ROLLBACK;
            else
                p_err_code:=systemnums.c_success;
            end if ;
        END LOOP;


    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_SendPositionReport');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SendPositionReport');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SendPositionReport;


  -----------------------------------pr_CIPayFeeDepositSeBo------------------------------------------------
  PROCEDURE pr_CIPayFeeDepositDebit(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc     varchar2(1000);
      v_strEN_Desc  varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param   varchar2(300);
      l_MaxRow      NUMBER(20,0);
      v_strDay      varchar2(2);
      l_cimastcheck_arr txpks_check.ddmastcheck_arrtype;
      l_baldefovd apprules.field%TYPE;
      l_feeamt      number(20,4);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_CIPayFeeDepositDebit');

   -- SELECT COUNT(*) MAXROW into l_MaxRow FROM  AFMAST;
/*    IF l_MaxRow>p_ToRow THEN
        p_lastRun:='N';
    ELSE
        p_lastRun:='Y';
    END IF;*/
    p_lastRun:='Y';

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='1201';
     SELECT varvalue INTO v_strCURRDATE
     FROM sysvar
     WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate      :=  to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate     :=  to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd      :=  '1201';
    plog.debug(pkgctx, 'Begin loop');



    -- xet xem co khoan phi luu ky nao den han
    for rec IN (SELECT * FROM
                (
                     SELECT DD.AFACCTNO, DD.ACCTNO, TXNUM, TXDATE , SUM(NMLAMT)-SUM(PAIDAMT) AVL
                     FROM CIFEESCHD SC, DDMAST DD
                     WHERE DELTD<>'Y' AND FEETYPE='FEEDR'
                        AND SC.AFACCTNO = DD.AFACCTNO AND DD.ISDEFAULT ='Y'
                     GROUP BY DD.ACCTNO,TXNUM,TXDATE
                ) mst
                     WHERE avl>0 ORDER BY acctno
               )Loop

                l_CIMASTcheck_arr := txpks_check.fn_ddMASTcheck(rec.ACCTNO,'CIMAST','ACCTNO');
                l_BALDEFOVD := to_number(l_CIMASTcheck_arr(0).balance);
                select case when to_number(l_BALDEFOVD) <= 0 then 0
                           when (to_number(l_BALDEFOVD) >= rec.AVL  )then rec.AVL
                            else 0 end into l_feeamt from dual;

                       if  l_feeamt > 0 then
                        plog.debug(pkgctx, 'Loop for account:' || rec.acctno || ' ngay' || v_strCURRDATE);
                        SELECT systemnums.C_BATCH_PREFIXED
                                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                                          INTO l_txmsg.txnum
                                          FROM DUAL;
                                l_txmsg.brid        := substr(rec.ACCTNO,1,4);

                                --Set cac field giao dich
                                --03  ACCTNO      C
                                l_txmsg.txfields ('03').defname   := 'ACCTNO';
                                l_txmsg.txfields ('03').TYPE      := 'C';
                                l_txmsg.txfields ('03').VALUE     := rec.acctno;
                                --10  INTAMT      N
                                l_txmsg.txfields ('10').defname   := 'FEEAMT';
                                l_txmsg.txfields ('10').TYPE      := 'N';
                                l_txmsg.txfields ('10').VALUE     := l_feeamt;

                                --30    DESC        C
                                l_txmsg.txfields ('30').defname   := 'DESC';
                                l_txmsg.txfields ('30').TYPE      := 'C';
                                l_txmsg.txfields ('30').VALUE     := v_strEN_Desc;

                                BEGIN
                                    IF txpks_#1201.fn_batchtxprocess (l_txmsg,
                                                                     p_err_code,
                                                                     l_err_param
                                       ) <> systemnums.c_success
                                    THEN
                                       plog.debug (pkgctx,
                                                              'got error 1182: ' || p_err_code
                                       );
                                       ROLLBACK;
                                       RETURN;
                                    END IF;
                                END;

                                --</ Cap nhat l?i tran thai -- dat thu phi LK
                              UPDATE CIFEESCHD SET PAIDAMT=NMLAMT, PAIDTXNUM=l_txmsg.txnum, paidtxdate=l_txmsg.txdate
                              WHERE DELTD<>'Y' AND AFACCTNO=rec.acctno AND txDATE=rec.TxDATE AND txnum = rec.txnum AND FEETYPE='FEEDR';
                                --/>
                     end if;




        end loop;


    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_CIPayFeeDepositDebit');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_CIPayFeeDepositDebit');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_CIPayFeeDepositDebit');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_CIPayFeeDepositDebit;


  -- -----------------------------------pr_CICalcFeeDeposit------------------------------------------------
  PROCEDURE pr_CICalcFeeDeposit(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
      v_CURRDATE date;
      v_NEXTDATE date;
      l_icrate number(10,4);
      l_numday number;
      l_isRate number;
      l_currmonth VARCHAR2(10);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_CICalcFeeDeposit');
    p_err_code:=0;
    --Cap nhat lai issedepofee cua ma _WFT = issedepofee cua ma goc
    for rec in
    (
        select codeid, symbol, issedepofee from sbsecurities sb where refcodeid is null
    )
    loop
        update sbsecurities
        set issedepofee = rec.issedepofee
        where refcodeid = rec.codeid;
    end loop;

    SP_PROCESS_CIFEESCHD_COMMON;

    -- Thoai.tran 15/10/2021
    -- Them cho Report
    sp_process_sedepobal_report;

    plog.setendsection(pkgctx, 'pr_CICalcFeeDeposit');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_CICalcFeeDeposit');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_CICalcFeeDeposit');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_CICalcFeeDeposit;

  -----------------------------------pr_CIPayFeeDepositSeBo------------------------------------------------
  PROCEDURE pr_CIPayFeeDepositSeBo(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc     varchar2(1000);
      v_strEN_Desc  varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param   varchar2(300);
      l_MaxRow      NUMBER(20,0);
      v_strDay      varchar2(2);
      l_cimastcheck_arr txpks_check.ddmastcheck_arrtype;
      l_baldefovd apprules.field%TYPE;
      l_feeamt      number(20,4);
      l_isRate      number;
      v_currmonth   varchar2(6);
      v_nextmonth   varchar2(6);
      v_afacctno_temp   VARCHAR2(20);
      v_ftodate         VARCHAR2(20);
      v_DOMtemp         VARCHAR2(5); -- Ngay thu phi
      v_EOMtemp         VARCHAR2(5); -- Loai thu phi
      v_dateEOMtemp     DATE; -- Datetime thu phi
      l_feepayamt      number(20,4);
      v_strDescTemp varchar2(1000);
      v_EOMtemp2    DATE; --Ngay cuoi thang
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_CIPayFeeDepositSeBo');
    l_isRate := 0;

   -- SELECT COUNT(*) MAXROW into l_MaxRow FROM  AFMAST;
/*    IF l_MaxRow>p_ToRow THEN
        p_lastRun:='N';
    ELSE
        p_lastRun:='Y';
    END IF;*/
    p_lastRun:='Y';
    SELECT VARVALUE INTO  v_DOMtemp
    FROM SYSVAR
    WHERE VARNAME IN ('DAYFEEDEPOSIT');

    SELECT VARVALUE INTO  v_EOMtemp
    FROM SYSVAR
    WHERE VARNAME IN ('EOMFEEDEPOSIT');
    --END SONLT 20140423 Them loai thu phi, ngay bat ky hoac cuoi thang
    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='1202';
     SELECT varvalue INTO v_strCURRDATE
     FROM sysvar
     WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

     SELECT varvalue INTO v_strNEXTDATE
     FROM sysvar
     WHERE grname = 'SYSTEM' AND varname = 'NEXTDATE';
     v_EOMtemp2 := ADD_MONTHS(TRUNC(to_date(v_strCURRDATE,'DD/MM/RRRR'), 'MM'), 1) -1;--Lay ngay cuoi thang
     IF to_number(v_DOMtemp) > to_number(to_char(v_EOMtemp2,'DD')) THEN
        v_DOMtemp := to_char(v_EOMtemp2,'DD');
     END IF;
    --START SONLT 20140426
    IF  v_EOMtemp = 'Y' THEN
    -- lay ra ngay cuoi cung cua thang
        --SELECT ADD_MONTHS(TRUNC(to_date(v_strCURRDATE,'DD/MM/RRRR'), 'MM'), 1) -1 INTO v_dateEOMtemp FROM DUAL;
        v_dateEOMtemp := v_EOMtemp2;
    ELSE
    -- lay ra ngay thu phi luu ky

        SELECT TO_DATE(v_DOMtemp || '/'||TO_CHAR(to_date(v_strCURRDATE,'DD/MM/RRRR'),'MM/RRRR'),'DD/MM/RRRR') INTO v_dateEOMtemp FROM DUAL;
    END IF;
    -- Xu ly truong hop ngay thu phi luu ky la ngay nghi
    SELECT GET_SYS_PREWORKINGDATE(v_dateEOMtemp) INTO v_dateEOMtemp FROM DUAL;
    --END   SONLT 20140426
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate      :=  to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate     :=  to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd      :=  '1202';

    v_afacctno_temp:='0';

    l_feepayamt := 0;
    -- xet xem co khoan phi luu ky nao den han
    for rec IN (SELECT *
                FROM  (
                        SELECT MST.TXNUM,DD.ACCTNO, MST.TODATE,MST.AFACCTNO,
                            MST.NMLAMT-MST.PAIDAMT-MST.FLOATAMT AVL, MST.PAIDAMT+MST.FLOATAMT PAID
                        FROM CIFEESCHD MST, DDMAST DD
                        WHERE MST.DELTD<>'Y' AND MST.FEETYPE='VSDDEP'  --GROUP BY TODATE
                            AND MST.AFACCTNO = DD.AFACCTNO AND DD.ISDEFAULT ='Y'
                      ) mst
                WHERE avl>(select to_number(varvalue) from sysvar where GRNAME='SYSTEM' and varname ='MINVSDFEEPAID')
                    AND (TO_DATE(v_dateEOMtemp,'DD/MM/RRRR') = TO_DATE(v_strCURRDATE,'DD/MM/RRRR'))
                     ORDER BY acctno,todate
        )
    loop
    -- neu tk co du tien moi thu
    l_CIMASTcheck_arr := txpks_check.fn_ddMASTcheck(rec.ACCTNO,'CIMAST','ACCTNO');
    l_BALDEFOVD := to_number(l_CIMASTcheck_arr(0).balance);

    select GREATEST(LEAST(TO_NUMBER(l_BALDEFOVD),TO_NUMBER(rec.AVL)),0) into l_feeamt from dual;

    --SONLT sua dien giai thu phi 1 phan.
    IF (to_number(l_BALDEFOVD) < rec.AVL) OR rec.PAID > 0 THEN
        v_strDescTemp := v_strEN_Desc || ' ' ||to_char( rec.TODATE,'MM/RRRR') || ' ' || '(one part)';
    ELSE
        v_strDescTemp := v_strEN_Desc || ' ' ||to_char( rec.TODATE,'MM/RRRR');
    END IF;
    -- lay ra truong to_Date theo format de len bao cao
    SELECT to_Char(rec.todate,'MM/RRRR') INTO v_ftodate FROM dual;
     --Chi tinh thu phi voi nhung tai khoan nao co phi.
        if  l_feeamt > 0 then
            plog.debug(pkgctx, 'Loop for account:' || rec.acctno || ' ngay' || v_strCURRDATE);
            SELECT systemnums.C_BATCH_PREFIXED
                                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                              INTO l_txmsg.txnum
                              FROM DUAL;

            l_txmsg.brid        := substr(rec.ACCTNO,1,4);
            --Set cac field giao dich
            --03  ACCTNO      C
            l_txmsg.txfields ('03').defname   := 'ACCTNO';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE     := rec.acctno;
            --10  INTAMT      N
            l_txmsg.txfields ('10').defname   := 'FEEAMT';
            l_txmsg.txfields ('10').TYPE      := 'N';
            l_txmsg.txfields ('10').VALUE     := l_feeamt;
               --07  FTODATE      N
            l_txmsg.txfields ('07').defname   := 'FTODATE';
            l_txmsg.txfields ('07').TYPE      := 'C';
            l_txmsg.txfields ('07').VALUE     := v_ftodate;
            --30    DESC        C
            l_txmsg.txfields ('30').defname   := 'DESC';
            l_txmsg.txfields ('30').TYPE      := 'C';
            l_txmsg.txfields ('30').VALUE     := v_strDescTemp;

            BEGIN
                IF txpks_#1202.fn_batchtxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                                          'got error 1182: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN;
                ELSE
                    --</ Cap nhat l?i tran thai -- dat thu phi LK
                    UPDATE CIFEESCHD
                    SET PAIDAMT=PAIDAMT+l_feeamt,--NMLAMT,
                    PAIDTXNUM=l_txmsg.txnum, paidtxdate=l_txmsg.txdate
                    WHERE DELTD<>'Y' AND AFACCTNO=rec.acctno AND TODATE=rec.TODATE AND TXNUM = REC.TXNUM AND  FEETYPE='VSDDEP' ;
                    l_feepayamt := l_feepayamt+l_feeamt;
                    --/>
                END IF;
            END;
        END if;
    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_CIPayFeeDepositSeBo');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_CIPayFeeDepositSeBo');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_CIPayFeeDepositSeBo');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_CIPayFeeDepositSeBo;

  -----------------------------------pr_HoldDebitDate3384------------------------------------------------
  PROCEDURE pr_HoldDebitDate3384(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
    L_txnum varchar2(50);
    L_currdate date;
    l_errmsg varchar2(2000);
    v_strCurrDate VARCHAR2(10);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_HoldDebitDate3384');
    p_lastRun:='Y';
    p_err_code:=0;
    v_strCurrDate := cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
    L_currdate := TO_DATE(getnextdate(v_strCurrDate), systemnums.C_DATE_FORMAT);
    for rec in
    (
        select mst.camastid, mst.trfacctno,mst.msgstatus, sum(amt) amt
        from caregister mst, camast ca
        where mst.camastid=ca.camastid
        and MST.msgstatus='H' and CA.debitdate = L_currdate and MST.reqtxnum is null
        group by mst.camastid, mst.trfacctno, mst.msgstatus
    ) loop
        If rec.msgstatus ='H' then

            L_txnum:=fn_gen_reqkey();

            pck_bankapi.Bank_holdbalance(rec.trfacctno,'','','',rec.amt,'HOLD3384',L_txnum,
            'Automatic hold Customers money to buy the rights to register events','0000',p_err_code);

            IF p_err_code <> systemnums.c_success THEN
               begin
                   select en_errdesc INTO l_errmsg from deferror where errnum= trim(p_err_code);
               EXCEPTION
                  WHEN OTHERS
                   THEN
                  l_errmsg:= '-1 System error';
               end;
               update caregister set msgstatus='E', errcode=p_err_code, reqtxnum=L_txnum,errmsg=l_errmsg
               where camastid=rec.camastid and trfacctno=rec.trfacctno
               AND msgstatus='H';
            ELSE
               update caregister set msgstatus='A', errcode=p_err_code, reqtxnum=L_txnum
               where camastid=rec.camastid and trfacctno=rec.trfacctno
               AND msgstatus='H';
            END IF;
        End If;

    end loop;
    -- gen Email EM23
    --trung.luu: 01-02-2021 bo gui EM23 gi?m anh Vu
    --nmpks_ems.pr_GenTemplateEM23(L_currdate);
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_HoldDebitDate3384');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_HoldDebitDate3384');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_HoldDebitDate3384');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_HoldDebitDate3384;

    PROCEDURE pr_ODFee(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
    IS
        V_EOMDATE DATE;
        V_GETCURRENT DATE;
    BEGIN
        plog.setbeginsection(pkgctx, 'pr_ODFee');
        p_err_code:=0;

        V_GETCURRENT := GETCURRDATE;

        SELECT MAX(SB.SBDATE) INTO V_EOMDATE
        FROM SBCLDR SB
        WHERE SB.CLDRTYPE = '000' AND SB.HOLIDAY = 'N'
        AND TO_CHAR(SB.SBDATE,'MM/RRRR') = TO_CHAR(V_GETCURRENT,'MM/RRRR');

        ---- Cuoi thang thuc hien tinh phi luu ky
        IF V_EOMDATE = V_GETCURRENT THEN
            CSPKS_FEECALCNEW.PRC_ORDER(V_EOMDATE, NULL, P_ERR_CODE);
        END IF;

        plog.setendsection(pkgctx, 'pr_ODFee');
    EXCEPTION WHEN OTHERS THEN
        plog.debug (pkgctx,'got error on fee order');
        --ROLLBACK;
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'pr_ODFee');
        RAISE errnums.E_SYSTEM_ERROR;
    END pr_ODFee;

FUNCTION fn_SettlementOrder(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_afacctno varchar2(30);
v_codeid varchar2(30);
v_status varchar2(30);
v_duetype varchar2(30);
v_orderid varchar2(30);
v_dblCostprice number(20,0);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_SettlementOrder');
    plog.debug (pkgctx, '<<BEGIN OF fn_SettlementOrder');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

                Update stschd set STATUS='C' where STATUS='N' AND AUTOID=p_txmsg.txfields('01').value;

    plog.debug (pkgctx, '<<END OF fn_SettlementOrder');
    plog.setendsection (pkgctx, 'fn_SettlementOrder');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_SettlementOrder');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_SettlementOrder;

---------------------------------pr_DDAutoTransfer------------------------------------------------
  PROCEDURE pr_DDAutoTransfer(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      v_dblProfit number(20,0);
      v_dblLoss number(20,0);
      v_dblAVLRCVAMT  number(20,0);
      v_dblVATRATE number(20,0);
      l_err_param varchar2(300);
      l_MaxRow number(20,0);
      v_COMPANYCD VARCHAR2(10);
      V_TEST VARCHAR2(100);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_DDAutoTransfer');

    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');


    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='6620';
     SELECT varvalue
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    l_txmsg.brid        := systemnums.C_BATCH_BRID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
    l_txmsg.txdate      := to_date(getcurrdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(getpdate_prev(getcurrdate,1),systemnums.c_date_format); --trung.luu : SHBVNEX-1721 15-03-2021
    l_txmsg.tltxcd      := '6620';

    for rec in -- tai khoan nhan
    (
        SELECT DD.CUSTODYCD,DD.REFCASAACCT,DD.ACCTNO DDACCTNO,DD.BALANCE,DD.CCYCD,CF.FULLNAME
            FROM DDMAST DD, CFMAST CF
            WHERE DD.STATUS <> 'C'
                AND DD.ISDEFAULT = 'Y'
                AND DD.CUSTODYCD = CF.CUSTODYCD
                AND CF.SUPEBANK = 'Y'
            GROUP BY DD.CUSTODYCD,DD.REFCASAACCT,DD.ACCTNO,DD.BALANCE,DD.CCYCD,CF.FULLNAME
    )
    loop
        for rec1 in -- tai khoan chuyen
        (
            SELECT DD.CUSTODYCD,DD.CUSTID ACCTNO,DD.REFCASAACCT,DD.ACCTNO DDACCTNO,DD.BALANCE,CF.CIFID,(DD.BALANCE + DD.HOLDBALANCE+DD.PENDINGHOLD+DD.PENDINGUNHOLD)TOTAL
                FROM DDMAST DD,CFMAST CF
                WHERE DD.STATUS <> 'C'
                    AND DD.AUTOTRANSFER = 'Y'
                    AND DD.ISDEFAULT <> 'Y'
                    AND DD.CCYCD = REC.CCYCD
                    AND DD.CUSTODYCD = CF.CUSTODYCD
                    AND DD.BALANCE > 0
                    AND DD.CUSTODYCD = REC.CUSTODYCD
        )
        loop

                --Set txnum
            SELECT systemnums.C_BATCH_PREFIXED
                             || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                      INTO l_txmsg.txnum
                      FROM DUAL;
            
            --Set cac field giao dich
            ------REQTXNUM
            l_txmsg.txfields ('95').defname   := 'REQTXNUM';
            l_txmsg.txfields ('95').TYPE      := 'C';
            l_txmsg.txfields ('95').VALUE      := '';
            ------REQCODE
            l_txmsg.txfields ('94').defname   := 'REQCODE';
            l_txmsg.txfields ('94').TYPE      := 'C';
            l_txmsg.txfields ('94').VALUE      := 'AUTOTRANSFER';
            ------AFACCTNO
            l_txmsg.txfields ('20').defname   := 'TXDATE';
            l_txmsg.txfields ('20').TYPE      := 'D';
            l_txmsg.txfields ('20').VALUE      := getcurrdate;
            ------DDACCTNO
            l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
            l_txmsg.txfields ('88').TYPE      := 'C';
            l_txmsg.txfields ('88').VALUE      := rec1.CUSTODYCD;
            ------ACCTNO
            l_txmsg.txfields ('03').defname   := 'ACCTNO';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE      := rec1.ACCTNO;
            ------DESACCTNO
            l_txmsg.txfields ('06').defname   := 'DESACCTNO';
            l_txmsg.txfields ('06').TYPE      := 'C';
            l_txmsg.txfields ('06').VALUE      := rec1.DDACCTNO;
            ------CIFID
            l_txmsg.txfields ('87').defname   := 'CIFID';
            l_txmsg.txfields ('87').TYPE      := 'C';
            l_txmsg.txfields ('87').VALUE      := rec1.CIFID;
            ------CASTBAL
            l_txmsg.txfields ('89').defname   := 'CASTBAL';
            l_txmsg.txfields ('89').TYPE      := 'N';
            l_txmsg.txfields ('89').VALUE      := rec1.TOTAL;
            ------REFCASAACCT
            l_txmsg.txfields ('93').defname   := 'REFCASAACCT';
            l_txmsg.txfields ('93').TYPE      := 'C';
            l_txmsg.txfields ('93').VALUE      := rec1.REFCASAACCT;
            ------BANKBALANCE
            l_txmsg.txfields ('14').defname   := 'BANKBALANCE';
            l_txmsg.txfields ('14').TYPE      := 'N';
            l_txmsg.txfields ('14').VALUE      := rec1.BALANCE;
            ------CUSTODYCD_NHAN
            l_txmsg.txfields ('44').defname   := 'CUSTODYCD_NHAN';
            l_txmsg.txfields ('44').TYPE      := 'C';
            l_txmsg.txfields ('44').VALUE      := rec.CUSTODYCD;
            ------BENEFACCT
            l_txmsg.txfields ('81').defname   := 'BENEFACCT';
            l_txmsg.txfields ('81').TYPE      := 'C';
            l_txmsg.txfields ('81').VALUE      := rec.DDACCTNO;
            ------BENEFBANK
            l_txmsg.txfields ('80').defname   := 'BENEFBANK';
            l_txmsg.txfields ('80').TYPE      := 'C';
            l_txmsg.txfields ('80').VALUE      := rec.FULLNAME;
            ------AMT
            l_txmsg.txfields ('10').defname   := 'AMT';
            l_txmsg.txfields ('10').TYPE      := 'N';
            l_txmsg.txfields ('10').VALUE      := rec1.BALANCE;
            ------CONTRACT
            l_txmsg.txfields ('31').defname   := 'CONTRACT';
            l_txmsg.txfields ('31').TYPE      := 'C';
            l_txmsg.txfields ('31').VALUE      := '';
            ------DESC
            l_txmsg.txfields ('30').defname   := 'DESC';
            l_txmsg.txfields ('30').TYPE      := 'C';
            l_txmsg.txfields ('30').VALUE      := v_strEN_Desc;


            p_err_code:=0;
            IF  txpks_#6620.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
                plog.error (pkgctx,'got error 6620: '|| p_err_code);
                ROLLBACK;
            else
                p_err_code:=systemnums.c_success;
            end if ;
        end loop;
    end loop;
    plog.setendsection(pkgctx, 'pr_DDAutoTransfer');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error transfer');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_DDAutoTransfer');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_DDAutoTransfer;

---------------------------------pr_DDAutoTransfer------------------------------------------------
  PROCEDURE pr_auto_541_543(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
      L_TXMSG               TX.MSG_RECTYPE;
      V_STRCURRDATE VARCHAR2(20);
      V_STRPREVDATE VARCHAR2(20);
      V_STRNEXTDATE VARCHAR2(20);
      V_STRDESC VARCHAR2(1000);
      V_STREN_DESC VARCHAR2(1000);
      V_BLNVIETNAMESE BOOLEAN;
      V_DBLPROFIT NUMBER(20,0);
      V_DBLLOSS NUMBER(20,0);
      V_DBLAVLRCVAMT  NUMBER(20,0);
      V_DBLVATRATE NUMBER(20,0);
      L_ERR_PARAM VARCHAR2(300);
      L_MAXROW NUMBER(20,0);
      V_COMPANYCD VARCHAR2(10);
      V_TEST VARCHAR2(100);
      V_DESC VARCHAR2(250);
      L_COUNT NUMBER;
      V_CURRDATE DATE;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_auto_541_543');

    V_CURRDATE := GETCURRDATE;
    v_COMPANYCD := cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='6620';
     SELECT varvalue
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    l_txmsg.brid        := systemnums.C_BATCH_BRID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
    l_txmsg.txdate      := to_date(V_CURRDATE,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(V_CURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd      := '1710';
    select txdesc into v_desc from tltx where tltxcd = '1710';
    for rec in -- tai khoan nhan
    (
        SELECT DISTINCT S.MSGID REQUESTID, MTTYPE, V.CDCONTENT DESCS, OD.CUSTODYCD, SENDERBICCODE, S.CFNSTATUS,
               OD.AUTOID, CM.ORDERID
        FROM
        (SELECT * FROM SWIFTMSGMAPLOG WHERE MTTYPE IN ('541','543') AND CFNSTATUS = 'P') S,
        (SELECT VSDMT, DESCRIPTION CDCONTENT, EN_DESCRIPTION EN_CDCONTENT FROM  VSDTRFCODE WHERE BANKCODE = 'CBP') V,
        (
            SELECT * FROM ODMASTCUST WHERE DELTD <> 'Y' AND VIA = 'W'
        ) OD,
        (
            SELECT C.BROKER_CODE , C.SEC_ID, C.CUSTODYCD, C.TRANS_TYPE, C.TRADE_DATE, C.SETTLE_DATE, C.QUANTITY, C.ORDERID, C.ISODMAST
            FROM ODMASTCMP C
            WHERE C.DELTD = 'N'
            AND C.ISODMAST = 'Y'
        ) CM
        WHERE S.MSGID = OD.FILEID

        AND OD.BROKER_CODE = CM.BROKER_CODE(+)
        AND OD.SEC_ID = CM.SEC_ID(+)
        AND OD.CUSTODYCD = CM.CUSTODYCD(+)
        AND OD.TRANS_TYPE = CM.TRANS_TYPE(+)
        AND OD.TRADE_DATE  = CM.TRADE_DATE(+)
        AND OD.SETTLE_DATE = CM.SETTLE_DATE(+)
        AND OD.QUANTITY = CM.QUANTITY(+)

        AND S.MTTYPE = V.VSDMT(+)
        AND (CASE WHEN CM.ISODMAST IS NULL THEN OD.ISODMAST ELSE CM.ISODMAST END) = 'Y'
        AND TO_DATE(TO_CHAR(S.CREATEDATE,'DD/MM/RRRR'),'DD/MM/RRRR') <= V_CURRDATE
    )
    loop
        SELECT COUNT(1) INTO L_COUNT FROM SWIFTMSGMAPLOG WHERE MSGID = REC.REQUESTID AND CFNSTATUS <> 'P';
        IF L_COUNT > 0 THEN
            CONTINUE;
        END IF;

         --Set txnum
        SELECT systemnums.C_HT_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
               --Set cac field giao dich
        ------REQTXNUM
        l_txmsg.txfields ('01').defname   := 'REQUESTID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE      := rec.REQUESTID;
        ------REQCODE
        l_txmsg.txfields ('02').defname   := 'MTTYPE';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE      := rec.MTTYPE;
        ------REQCODE
        l_txmsg.txfields ('03').defname   := 'DESCS';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE      := rec.DESCS;
        ------REQCODE
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE      := rec.CUSTODYCD;
        ------REQCODE
        l_txmsg.txfields ('05').defname   := 'RBICCODE';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE      := rec.SENDERBICCODE;
        ------REQCODE
        l_txmsg.txfields ('04').defname   := 'CFNSTATUS';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE      := rec.CFNSTATUS;
        ------REQCODE
        l_txmsg.txfields ('10').defname   := 'NEWSTATUS';
        l_txmsg.txfields ('10').TYPE      := 'C';
        l_txmsg.txfields ('10').VALUE      := 'C'; -- C xac nhan
        --TXNUM
        l_txmsg.txfields ('29').defname   := 'TXNUM';
        l_txmsg.txfields ('29').TYPE      := 'C';
        l_txmsg.txfields ('29').VALUE      := '';
        ------REQCODE
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE      := v_desc;
        ------REQCODE
        l_txmsg.txfields ('31').defname   := 'SI';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').VALUE      := 'N';
        ------REQCODE
        l_txmsg.txfields ('32').defname   := 'EFFDATE';
        l_txmsg.txfields ('32').TYPE      := 'C';
        l_txmsg.txfields ('32').VALUE      := '';
        ------REQCODE
        l_txmsg.txfields ('33').defname   := 'EXPDATE';
        l_txmsg.txfields ('33').TYPE      := 'C';
        l_txmsg.txfields ('33').VALUE      := '';
        ------REQCODE
        l_txmsg.txfields ('34').defname   := 'NOTE';
        l_txmsg.txfields ('34').TYPE      := 'C';
        l_txmsg.txfields ('34').VALUE      := 'Batch Auto Confirm';
        p_err_code:=0;
        IF  txpks_#1710.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
            plog.error (pkgctx,'got error 1710: '|| p_err_code);
            ROLLBACK;
        end if ;
    end loop;

    BEGIN
        --update lenh vao sau nguon sinh lenh 1 nguon
        --nguon BROKER
        FOR REC_CM IN
        (
            SELECT OD.*, NVL(CF.MCUSTODYCD, OD.CUSTODYCD) MCUSTODYCD, CU.AUTOID CUAUTOID, VS.AUTOID VSAUTOID
            FROM ODMASTCMP OD, CFMAST CF,
            (SELECT * FROM ODMASTCUST WHERE DELTD = 'N' AND TRIM(ISODMAST) = 'N' AND TO_DATE(SETTLE_DATE,'DD/MM/RRRR') <= V_CURRDATE) CU,
            (SELECT * FROM ODMASTVSD WHERE DELTD = 'N' AND TRIM(ISODMAST) = 'N' AND TO_DATE(SETTLE_DATE,'DD/MM/RRRR') <= V_CURRDATE) VS
            WHERE OD.CUSTODYCD = CF.CUSTODYCD(+)
            AND TRIM(OD.ISODMAST) = 'Y'
            AND OD.DELTD = 'N'
            AND OD.ORDERID IS NOT NULL

            AND OD.SEC_ID = CU.SEC_ID(+)
            AND OD.CUSTODYCD = CU.CUSTODYCD(+)
            AND OD.TRANS_TYPE = CU.TRANS_TYPE(+)
            AND OD.TRADE_DATE = CU.TRADE_DATE(+)
            AND OD.SETTLE_DATE = CU.SETTLE_DATE(+)
            AND OD.BROKER_CODE = CU.BROKER_CODE(+)
            AND OD.QUANTITY = CU.QUANTITY(+)

            AND OD.SEC_ID = VS.SEC_ID(+)
            AND NVL(CF.CUSTODYCD, OD.CUSTODYCD) = VS.CUSTODYCD(+)
            AND OD.TRANS_TYPE = VS.TRANS_TYPE(+)
            AND OD.TRADE_DATE = VS.TRADE_DATE(+)
            AND OD.SETTLE_DATE = VS.SETTLE_DATE(+)
            AND OD.BROKER_CODE = VS.BROKER_CODE(+)
            AND OD.QUANTITY = VS.QUANTITY(+)

            AND (CU.AUTOID IS NOT NULL OR VS.AUTOID IS NOT NULL)
        )
        LOOP
            IF NVL(REC_CM.CUAUTOID, 0) > 0 THEN
                UPDATE ODMASTCUST
                SET ISODMAST = 'Y', VERSION = REC_CM.VERSION, ORDERID = REC_CM.ORDERID
                WHERE TRANS_TYPE = REC_CM.TRANS_TYPE
                AND TRADE_DATE = REC_CM.TRADE_DATE
                AND SETTLE_DATE = REC_CM.SETTLE_DATE
                AND QUANTITY  = REC_CM.QUANTITY
                AND SEC_ID = REC_CM.SEC_ID
                AND CUSTODYCD = REC_CM.CUSTODYCD
                AND BROKER_CODE = REC_CM.BROKER_CODE
                AND DELTD = 'N';
            END IF;

            IF NVL(REC_CM.VSAUTOID, 0) > 0 THEN
                UPDATE ODMASTVSD
                SET ISODMAST = 'Y', VERSION = REC_CM.VERSION, ORDERID = REC_CM.ORDERID
                WHERE TRANS_TYPE = REC_CM.TRANS_TYPE
                AND TRADE_DATE = REC_CM.TRADE_DATE
                AND SETTLE_DATE = REC_CM.SETTLE_DATE
                AND QUANTITY  = REC_CM.QUANTITY
                AND SEC_ID = REC_CM.SEC_ID
                AND CUSTODYCD = REC_CM.MCUSTODYCD
                AND BROKER_CODE = REC_CM.BROKER_CODE
                AND DELTD = 'N';
            END IF;
        END LOOP;

        --nguon CLIENT
        FOR REC_CU IN
        (
            SELECT OD.*, NVL(CF.MCUSTODYCD, OD.CUSTODYCD) MCUSTODYCD, CM.AUTOID CMAUTOID, VS.AUTOID VSAUTOID
            FROM ODMASTCUST OD, CFMAST CF,
            (SELECT * FROM ODMASTCMP WHERE DELTD = 'N' AND TRIM(ISODMAST) = 'N' AND TO_DATE(SETTLE_DATE,'DD/MM/RRRR') <= V_CURRDATE) CM,
            (SELECT * FROM ODMASTVSD WHERE DELTD = 'N' AND TRIM(ISODMAST) = 'N' AND TO_DATE(SETTLE_DATE,'DD/MM/RRRR') <= V_CURRDATE) VS
            WHERE OD.CUSTODYCD = CF.CUSTODYCD(+)
            AND TRIM(OD.ISODMAST) = 'Y'
            AND OD.DELTD = 'N'
            AND OD.ORDERID IS NOT NULL
            AND TO_DATE(OD.SETTLE_DATE,'DD/MM/RRRR') <= V_CURRDATE

            AND OD.SEC_ID = CM.SEC_ID(+)
            AND OD.CUSTODYCD = CM.CUSTODYCD(+)
            AND OD.TRANS_TYPE = CM.TRANS_TYPE(+)
            AND OD.TRADE_DATE = CM.TRADE_DATE(+)
            AND OD.SETTLE_DATE = CM.SETTLE_DATE(+)
            AND OD.BROKER_CODE = CM.BROKER_CODE(+)
            AND OD.QUANTITY = CM.QUANTITY(+)

            AND OD.SEC_ID = VS.SEC_ID(+)
            AND NVL(CF.CUSTODYCD, OD.CUSTODYCD) = VS.CUSTODYCD(+)
            AND OD.TRANS_TYPE = VS.TRANS_TYPE(+)
            AND OD.TRADE_DATE = VS.TRADE_DATE(+)
            AND OD.SETTLE_DATE = VS.SETTLE_DATE(+)
            AND OD.BROKER_CODE = VS.BROKER_CODE(+)
            AND OD.QUANTITY = VS.QUANTITY(+)

            AND (CM.AUTOID IS NOT NULL OR VS.AUTOID IS NOT NULL)
        )
        LOOP
            IF NVL(REC_CU.CMAUTOID, 0) > 0 THEN
                UPDATE ODMASTCMP
                SET ISODMAST = 'Y', VERSION = REC_CU.VERSION, ORDERID = REC_CU.ORDERID
                WHERE TRANS_TYPE = REC_CU.TRANS_TYPE
                AND TRADE_DATE = REC_CU.TRADE_DATE
                AND SETTLE_DATE = REC_CU.SETTLE_DATE
                AND QUANTITY  = REC_CU.QUANTITY
                AND SEC_ID = REC_CU.SEC_ID
                AND CUSTODYCD = REC_CU.CUSTODYCD
                AND BROKER_CODE = REC_CU.BROKER_CODE
                AND DELTD = 'N';
            END IF;

            IF NVL(REC_CU.VSAUTOID, 0) > 0 THEN
                UPDATE ODMASTVSD
                SET ISODMAST = 'Y', VERSION = REC_CU.VERSION, ORDERID = REC_CU.ORDERID
                WHERE TRANS_TYPE = REC_CU.TRANS_TYPE
                AND TRADE_DATE = REC_CU.TRADE_DATE
                AND SETTLE_DATE = REC_CU.SETTLE_DATE
                AND QUANTITY  = REC_CU.QUANTITY
                AND SEC_ID = REC_CU.SEC_ID
                AND CUSTODYCD = REC_CU.MCUSTODYCD
                AND BROKER_CODE = REC_CU.BROKER_CODE
                AND DELTD = 'N';
            END IF;
        END LOOP;
    END;

    p_err_code:=systemnums.c_success;
    plog.setendsection(pkgctx, 'pr_auto_541_543');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error transfer');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_auto_541_543');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_auto_541_543;

---------------------------------pr_ODSettlementReceiveMoney------------------------------------------------
  PROCEDURE pr_ODSettlementReceiveMoney(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2, p_isBOND in VARCHAR2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      v_dblProfit number(20,0);
      v_dblLoss number(20,0);
      v_dblAVLRCVAMT  number(20,0);
      v_dblVATRATE number(20,0);
      l_err_param varchar2(300);
      l_MaxRow number(20,0);
      v_COMPANYCD VARCHAR2(10);
      V_TEST VARCHAR2(100);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_ODSettlementReceiveMoney');

    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');


    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8820';
     SELECT varvalue
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    l_txmsg.brid        := systemnums.C_BATCH_BRID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
    l_txmsg.txdate      := to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd      := '8820';

    for rec in
    (
        SELECT MST.AUTOID, MST.ORDERID,  MST.AFACCTNO,  MST.AFACCTNO || MST.CODEID SEACCTNO , MST.CODEID ,MST.QTTY, MST.AMT, MST.FEEAMT,MST.CLEARDATE SETTLEMENT,FA.SHORTNAME BROKER,
            DD.REFCASAACCT,A1.CDCONTENT TYPEORDER,MST.VAT TAXAMT,CF.FULLNAME,CF.CIFID,
            MST.CUSTODYCD, MST.SYMBOL,MST.DDACCTNO,A1.CDVAL,'DD'TYPE,
            ('SETTLE-SELL - '||MST.ORDERID ||' - '||MST.symbol || ' - ' ||MST.QTTY) desct
            FROM (SELECT * FROM (SELECT A.*, ROWNUM ID FROM STSCHD A)/* WHERE ID BETWEEN P_FROMROW AND P_TOROW*/) MST,ODMAST OD,FAMEMBERS FA,DDMAST DD,ALLCODE A1,CFMAST CF,
            (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE') CRD,sbsecurities sb,
            (select varvalue  from sysvar where varname = 'DEALINGCUSTODYCD')sys
            WHERE  MST.DUETYPE IN('RM') AND
                    MST.STATUS='P' AND MST.DELTD<>'Y'
            AND TO_DATE(MST.CLEARDATE,'DD/MM/RRRR') = TO_DATE(CRD.VARVALUE,'DD/MM/RRRR')
            AND MST.ORDERID = OD.ORDERID
            AND FA.AUTOID = OD.MEMBER
            AND DD.ACCTNO = MST.DDACCTNO
            AND A1.CDNAME = 'EXECTYPE' AND A1.CDTYPE = 'OD' AND A1.CDVAL = OD.EXECTYPE
            AND OD.EXECTYPE IN ('NS')
            AND OD.ISPAYMENT <> 'Y'
            and mst.codeid = sb.codeid
            and sb.bondtype <> '001'
            AND MST.CUSTODYCD = CF.CUSTODYCD
            and SUBSTR(OD.custodycd,0,4) not like sys.varvalue

    )
    loop
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        --Set cac field giao dich
        ------AUTOID
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'N';
        l_txmsg.txfields ('01').VALUE      := rec.AUTOID;
        ------CODEID
        l_txmsg.txfields ('02').defname   := 'CODEID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE      := rec.CODEID;
        ------AFACCTNO
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE      := rec.AFACCTNO;
        ------DDACCTNO
        l_txmsg.txfields ('04').defname   := 'DDACCTNO';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE      := rec.DDACCTNO;
        ------SEACCTNO
        l_txmsg.txfields ('05').defname   := 'SEACCTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE      := rec.SEACCTNO;
        ------ORGORDERID
        l_txmsg.txfields ('06').defname   := 'ORGORDERID';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE      := rec.ORDERID;
        ------SYMBOL
        l_txmsg.txfields ('07').defname   := 'SYMBOL';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE      := rec.SYMBOL;
        ------QTTY
        l_txmsg.txfields ('09').defname   := 'QTTY';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE      := rec.QTTY;
        ------AMT
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE      := rec.AMT;
        ------FEE
        l_txmsg.txfields ('11').defname   := 'FEE';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE      := rec.FEEAMT;
        ------VAT
        l_txmsg.txfields ('27').defname   := 'VAT';
        l_txmsg.txfields ('27').TYPE      := 'N';
        l_txmsg.txfields ('27').VALUE      := rec.TAXAMT;
        ------SETTLE
        l_txmsg.txfields ('23').defname   := 'SETTLEMENT';
        l_txmsg.txfields ('23').TYPE      := 'D';
        l_txmsg.txfields ('23').VALUE      := rec.SETTLEMENT;
        ------BROKER
        l_txmsg.txfields ('24').defname   := 'BROKER';
        l_txmsg.txfields ('24').TYPE      := 'C';
        l_txmsg.txfields ('24').VALUE      := rec.BROKER;
        ------REFCASAACCT
        l_txmsg.txfields ('25').defname   := 'REFCASAACCT';
        l_txmsg.txfields ('25').TYPE      := 'C';
        l_txmsg.txfields ('25').VALUE      := rec.REFCASAACCT;
        ------TYPEORDER
        l_txmsg.txfields ('26').defname   := 'TYPEORDER';
        l_txmsg.txfields ('26').TYPE      := 'C';
        l_txmsg.txfields ('26').VALUE      := rec.TYPEORDER;
        ------TYPEORDER CDVAL
        l_txmsg.txfields ('28').defname   := 'CDVAL';
        l_txmsg.txfields ('28').TYPE      := 'C';
        l_txmsg.txfields ('28').VALUE      := rec.CDVAL;
        ------TYPE
        l_txmsg.txfields ('31').defname   := 'CDVAL';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').VALUE      := rec.TYPE;
        ------DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE      := rec.desct;

        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE      := rec.CUSTODYCD;

        l_txmsg.txfields ('90').defname   := 'FULLNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').VALUE      := rec.FULLNAME;

        l_txmsg.txfields ('91').defname   := 'CIFID';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').VALUE      := rec.CIFID;
        p_err_code:=0;

        IF  txpks_#8820.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
            plog.error (pkgctx,'got error 8820: '|| p_err_code);
            ROLLBACK;
        else
            p_err_code:=systemnums.c_success;
        end if ;
    end loop;
    plog.setendsection(pkgctx, 'pr_ODSettlementReceiveMoney');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on receive money');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_ODSettlementReceiveMoney');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ODSettlementReceiveMoney;


---------------------------------pr_ODSettlementtransferMoney------------------------------------------------
  PROCEDURE pr_ODSettlementtransferMoney(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
      l_txmsg tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param varchar2(300);
      l_MaxRow NUMBER(20,0);
      v_COMPANYCD VARCHAR2(10);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_ODSettlementtransferMoney');


    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');



    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8818';
     SELECT varvalue
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    l_txmsg.brid        := systemnums.C_BATCH_BRID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8818';
    -- Thuc hien 8818 can theo CLEARDATE
    for rec in
    (
        SELECT CRD.VARVALUE,MST.AUTOID, MST.ORDERID,  MST.AFACCTNO,  MST.AFACCTNO || MST.CODEID SEACCTNO , MST.CODEID ,MST.QTTY, MST.AMT, NVL(MST.FEEAMT, 0) FEEAMT,MST.CLEARDATE SETTLEMENT,FA.SHORTNAME BROKER,
            DD.REFCASAACCT,A1.CDCONTENT TYPEORDER,NVL(MST.VAT, 0) TAXAMT,CF.FULLNAME,CF.CIFID,
            MST.CUSTODYCD, MST.SYMBOL,MST.DDACCTNO,A1.CDVAL,a2.CDCONTENT ISHOLD,a2.cdval ISHOLD_TEXT,
            ('SETTLE-BUY - '||MST.ORDERID ||' - '||MST.symbol || ' - ' ||MST.QTTY) desct
            FROM (SELECT * FROM (SELECT A.*, ROWNUM ID FROM STSCHD A)/* WHERE ID BETWEEN P_FROMROW AND P_TOROW*/) MST,ODMAST OD,FAMEMBERS FA,DDMAST DD,ALLCODE A1,CFMAST CF,
            (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE') CRD,sbsecurities sb,allcode a2,
            (select varvalue  from sysvar where varname = 'DEALINGCUSTODYCD')sys
            WHERE  MST.DUETYPE IN('SM') AND
                    MST.STATUS='P' AND MST.DELTD<>'Y'
            AND TO_DATE(MST.CLEARDATE,'DD/MM/RRRR') = TO_DATE(CRD.VARVALUE,'DD/MM/RRRR')
            AND MST.ORDERID = OD.ORDERID
            AND FA.AUTOID = OD.MEMBER
            AND DD.ACCTNO = MST.DDACCTNO
            AND A1.CDNAME = 'EXECTYPE' AND A1.CDTYPE = 'OD' AND A1.CDVAL = OD.EXECTYPE
            AND OD.EXECTYPE IN ('NB')
            and MST.CODEID = sb.codeid
            and sb.bondtype <> '001'
            AND OD.ISPAYMENT ='N'
            AND OD.custodycd = CF.custodycd
            and a2.cdtype = 'OD' and a2.cdname = 'ISHOLDOD' and a2.cdval = od.ishold
            and SUBSTR(od.custodycd,0,4) not like sys.varvalue
    )
    loop

        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        --Set cac field giao dich
        ------AUTOID
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'N';
        l_txmsg.txfields ('01').VALUE      := rec.AUTOID;
        ------CODEID
        l_txmsg.txfields ('02').defname   := 'CODEID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE      := rec.CODEID;
        ------CUSTODYCD
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE      := rec.CUSTODYCD;
        ------FULLNAME
        l_txmsg.txfields ('90').defname   := 'FULLNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').VALUE      := rec.FULLNAME;
        ------isunhold
        l_txmsg.txfields ('33').defname   := 'ISUNHOLD';
        l_txmsg.txfields ('33').TYPE      := 'C';
        l_txmsg.txfields ('90').VALUE      := 'Y';
        ------CIFID
        l_txmsg.txfields ('91').defname   := 'CIFID';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').VALUE      := rec.CIFID;
        ------AFACCTNO
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE      := rec.AFACCTNO;
        ------DDACCTNO
        l_txmsg.txfields ('04').defname   := 'DDACCTNO';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE      := rec.DDACCTNO;
        ------SEACCTNO
        l_txmsg.txfields ('05').defname   := 'SEACCTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE      := rec.SEACCTNO;
        ------ORGORDERID
        l_txmsg.txfields ('06').defname   := 'ORGORDERID';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE      := rec.ORDERID;
        ------SYMBOL
        l_txmsg.txfields ('07').defname   := 'SYMBOL';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE      := rec.SYMBOL;
        ------QTTY
        l_txmsg.txfields ('09').defname   := 'QTTY';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE      := rec.QTTY;
        ------AMT
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE      := rec.AMT;
        ------FEE
        l_txmsg.txfields ('11').defname   := 'FEE';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE      := rec.FEEAMT;
        ------TAXAMT
        l_txmsg.txfields ('27').defname   := 'TAXAMT';
        l_txmsg.txfields ('27').TYPE      := 'N';
        l_txmsg.txfields ('27').VALUE      := rec.TAXAMT;
        ------SETTLEMENT
        l_txmsg.txfields ('23').defname   := 'SETTLEMENT';
        l_txmsg.txfields ('23').TYPE      := 'D';
        l_txmsg.txfields ('23').VALUE      := rec.SETTLEMENT;
        ------BROKER
        l_txmsg.txfields ('24').defname   := 'BROKER';
        l_txmsg.txfields ('24').TYPE      := 'C';
        l_txmsg.txfields ('24').VALUE      := rec.BROKER;
        ------REFCASAACCT
        l_txmsg.txfields ('25').defname   := 'REFCASAACCT';
        l_txmsg.txfields ('25').TYPE      := 'C';
        l_txmsg.txfields ('25').VALUE      := rec.REFCASAACCT;
        ------TYPEORDER
        l_txmsg.txfields ('26').defname   := 'TYPEORDER';
        l_txmsg.txfields ('26').TYPE      := 'C';
        l_txmsg.txfields ('26').VALUE      := rec.TYPEORDER;
        ------TYPEORDER CDVAL
        l_txmsg.txfields ('28').defname   := 'CDVAL';
        l_txmsg.txfields ('28').TYPE      := 'C';
        l_txmsg.txfields ('28').VALUE      := rec.CDVAL;
        ------DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE      := REC.DESCT;
        p_err_code:=0;
        IF  txpks_#8818.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
            plog.error (pkgctx,'got error 8818: '|| l_err_param);
            ROLLBACK;
        else
            p_err_code:=systemnums.c_success;
            plog.error('Giao dich 8818 thanh cong: '||l_txmsg.txnum);
        end if ;
    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_ODSettlementtransferMoney');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on transfer money');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_ODSettlementtransferMoney');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ODSettlementtransferMoney;

---------------------------------pr_ODSettlementtransferFeeBroker------------------------------------------------
  PROCEDURE pr_ODSettlementtransferFeeBroker(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
      l_txmsg tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param varchar2(300);
      l_MaxRow NUMBER(20,0);
      v_COMPANYCD VARCHAR2(10);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_ODSettlementtransferFeeBroker');


    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8801';
     SELECT varvalue
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    l_txmsg.brid        := systemnums.C_BATCH_BRID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8801';
    -- Thuc hien 8801 can theo CLEARDATE
    for rec in
    (
        select * from
        (
        SELECT MAX(TXDATE)TXDATE,MAX(CLEARDATE)CLEARDATE,MAX(BROKER)BROKER,'' BROKERNAME,'' BANKACCBROKER,'' BANKNAMEBROKER,'' BRANKBANK,SUM(FEE) FEE,SUM(TAX) TAX,(SUM(FEE) + SUM(TAX)) TOTAL
        FROM (
             select FA.SHORTNAME BROKER,FA.FULLNAME BROKERNAME,FA.BANKACCTNO BANKACCBROKER,FA.BANKNAME BANKNAMEBROKER,FA.BRANCHNAME BRANKBANK,
               (FE.FEEAMT - nvl(fe.paidfeeamt,0))FEE,
               (FE.VAT  -nvl(fe.paidvat,0)) TAX,
               FE.CLEARDATE,FE.TXDATE
              from vw_stschd_all fe,
              famembers fa,odmast od,CFMAST CF,(select varvalue  from sysvar where varname = 'DEALINGCUSTODYCD')sys
              where fa.autoid = od.member
              and od.orderid = FE.orderid
              and od.ODTYPE in('ODT','ODG')
              AND FE.CUSTODYCD = CF.custodycd
              and SUBSTR(CF.custodycd,0,4) not like sys.varvalue
              and fe.DUETYPE IN ('SM','RM') and fe.DELTD = 'N'
              AND CF.feedaily <> 'N'
              and fe.fvstatus = 'P'
              and greatest(fe.feeamt-nvl(fe.paidfeeamt,0),0) + greatest(fe.vat-nvl(fe.paidvat,0),0) <> 0
              and to_char(fe.cleardate,'dd/MM/RRRR') = to_char(getcurrdate,'dd/MM/RRRR')
              order by cleardate
            )
            group by cleardate
        ) where    to_char(cleardate,'dd/MM/RRRR') = to_char(getcurrdate,'dd/MM/RRRR')
    )
    loop
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        --Set cac field giao dich
        ------AUTOID
        l_txmsg.txfields ('02').defname   := 'BROKER';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE      := rec.BROKER;
        ------CODEID
        l_txmsg.txfields ('03').defname   := 'BROKERNAME';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE      := rec.BROKERNAME;
        ------CUSTODYCD
        l_txmsg.txfields ('05').defname   := 'BANKACCBROKER';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE      := rec.BANKACCBROKER;
        ------AFACCTNO
        l_txmsg.txfields ('06').defname   := 'BANKNAMEBROKER';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE      := rec.BANKNAMEBROKER;
        ------DDACCTNO
        l_txmsg.txfields ('07').defname   := 'BRANKBANK';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE      := rec.BRANKBANK;
        ------FEE
        l_txmsg.txfields ('10').defname   := 'FEE';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE      := rec.FEE;
        ------TAX
        l_txmsg.txfields ('11').defname   := 'TAX';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE      := rec.TAX;
        ------TOTAL
        l_txmsg.txfields ('12').defname   := 'TOTAL';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE      := rec.TOTAL;
        ------DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE      := utf8nums.c_const_TLTX_TXDESC_8801;
        p_err_code:=0;
        IF  txpks_#8801.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
            plog.error (pkgctx,'got error 8801: '|| l_err_param);
            ROLLBACK;
        else
            p_err_code:=systemnums.c_success;
            plog.error('Giao dich 8801 thanh cong: '||l_txmsg.txnum);
        end if ;
    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_ODSettlementtransferFeeBroker');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on transfer money fee broker');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_ODSettlementtransferFeeBroker');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ODSettlementtransferFeeBroker;


---------------------------------pr_ODSettlementtransferSec------------------------------------------------
  PROCEDURE pr_ODSettlementtransferSec(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param varchar2(300);
      l_MaxRow NUMBER(20,0);
      v_COMPANYCD VARCHAR2(10);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_ODSettlementtransferSec');

    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8848';
     SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    l_txmsg.brid        := systemnums.C_BATCH_BRID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8848';
    for rec in
    (
           SELECT MST.AUTOID, MST.ORDERID,  MST.AFACCTNO,  MST.AFACCTNO || MST.CODEID SEACCTNO , MST.CODEID ,MST.QTTY, MST.AMT, MST.FEEAMT,MST.CLEARDATE SETTLEMENT,FA.SHORTNAME BROKER,
            DD.REFCASAACCT,A1.CDCONTENT TYPEORDER,MST.VAT TAXAMT,CF.FULLNAME,CF.CIFID,
            MST.CUSTODYCD, MST.SYMBOL,MST.DDACCTNO,A1.CDVAL,'SE'TYPE
            FROM (SELECT * FROM (SELECT A.*, ROWNUM ID FROM STSCHD A)/* WHERE ID BETWEEN P_FROMROW AND P_TOROW*/) MST,ODMAST OD,FAMEMBERS FA,DDMAST DD,ALLCODE A1,CFMAST CF,
            (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE') CRD,sbsecurities sb
            WHERE  MST.DUETYPE IN('SS') AND
                    MST.STATUS='P' AND MST.DELTD<>'Y'
            AND TO_DATE(MST.CLEARDATE,'DD/MM/RRRR') = TO_DATE(CRD.VARVALUE,'DD/MM/RRRR')
            AND MST.ORDERID = OD.ORDERID
            AND FA.AUTOID = OD.MEMBER
            AND DD.ACCTNO = MST.DDACCTNO
            AND A1.CDNAME = 'EXECTYPE' AND A1.CDTYPE = 'OD' AND A1.CDVAL = OD.EXECTYPE
            AND OD.EXECTYPE IN ('NS')
            AND OD.custodycd = CF.CUSTODYCD
            and mst.codeid = sb.codeid
            and sb.bondtype <> '001'
    )
    loop
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
          --Set cac field giao dich
          ------AUTOID
          l_txmsg.txfields ('01').defname   := 'AUTOID';
          l_txmsg.txfields ('01').TYPE      := 'N';
          l_txmsg.txfields ('01').VALUE      := rec.AUTOID;
          ------CODEID
          l_txmsg.txfields ('02').defname   := 'CODEID';
          l_txmsg.txfields ('02').TYPE      := 'C';
          l_txmsg.txfields ('02').VALUE      := rec.CODEID;
          ------CUSTODYCD
          l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
          l_txmsg.txfields ('88').TYPE      := 'C';
          l_txmsg.txfields ('88').VALUE      := rec.CUSTODYCD;
          ------FULLNAME
            l_txmsg.txfields ('90').defname   := 'FULLNAME';
            l_txmsg.txfields ('90').TYPE      := 'C';
            l_txmsg.txfields ('90').VALUE      := rec.FULLNAME;
            ------CIFID
            l_txmsg.txfields ('91').defname   := 'CIFID';
            l_txmsg.txfields ('91').TYPE      := 'C';
            l_txmsg.txfields ('91').VALUE      := rec.CIFID;
          ------AFACCTNO
          l_txmsg.txfields ('03').defname   := 'AFACCTNO';
          l_txmsg.txfields ('03').TYPE      := 'C';
          l_txmsg.txfields ('03').VALUE      := rec.AFACCTNO;
          ------DDACCTNO
          l_txmsg.txfields ('04').defname   := 'DDACCTNO';
          l_txmsg.txfields ('04').TYPE      := 'C';
          l_txmsg.txfields ('04').VALUE      := rec.DDACCTNO;
          ------SEACCTNO
          l_txmsg.txfields ('05').defname   := 'SEACCTNO';
          l_txmsg.txfields ('05').TYPE      := 'C';
          l_txmsg.txfields ('05').VALUE      := rec.SEACCTNO;
          ------ORGORDERID
          l_txmsg.txfields ('06').defname   := 'ORGORDERID';
          l_txmsg.txfields ('06').TYPE      := 'C';
          l_txmsg.txfields ('06').VALUE      := rec.ORDERID;
          ------SYMBOL
          l_txmsg.txfields ('07').defname   := 'SYMBOL';
          l_txmsg.txfields ('07').TYPE      := 'C';
          l_txmsg.txfields ('07').VALUE      := rec.SYMBOL;
          ------QTTY
          l_txmsg.txfields ('09').defname   := 'QTTY';
          l_txmsg.txfields ('09').TYPE      := 'N';
          l_txmsg.txfields ('09').VALUE      := rec.QTTY;
          ------AMT
          l_txmsg.txfields ('10').defname   := 'AMT';
          l_txmsg.txfields ('10').TYPE      := 'N';
          l_txmsg.txfields ('10').VALUE      := rec.AMT;
          ------TAXAMT
          l_txmsg.txfields ('27').defname   := 'TAXAMT';
          l_txmsg.txfields ('27').TYPE      := 'N';
          l_txmsg.txfields ('27').VALUE      := rec.TAXAMT;
          ------FEE
          l_txmsg.txfields ('11').defname   := 'FEE';
          l_txmsg.txfields ('11').TYPE      := 'N';
          l_txmsg.txfields ('11').VALUE      := rec.FEEAMT;
          ------SETTLEMENT
          l_txmsg.txfields ('23').defname   := 'SETTLEMENT';
          l_txmsg.txfields ('23').TYPE      := 'D';
          l_txmsg.txfields ('23').VALUE      := rec.SETTLEMENT;
          ------BROKER
          l_txmsg.txfields ('24').defname   := 'BROKER';
          l_txmsg.txfields ('24').TYPE      := 'C';
          l_txmsg.txfields ('24').VALUE      := rec.BROKER;
          ------REFCASAACCT
          l_txmsg.txfields ('25').defname   := 'REFCASAACCT';
          l_txmsg.txfields ('25').TYPE      := 'C';
          l_txmsg.txfields ('25').VALUE      := rec.REFCASAACCT;
          ------TYPEORDER
          l_txmsg.txfields ('26').defname   := 'TYPEORDER';
          l_txmsg.txfields ('26').TYPE      := 'C';
          l_txmsg.txfields ('26').VALUE      := rec.TYPEORDER;
          ------TYPEORDER CDVAL
          l_txmsg.txfields ('28').defname   := 'CDVAL';
          l_txmsg.txfields ('28').TYPE      := 'C';
          l_txmsg.txfields ('28').VALUE      := rec.CDVAL;
          ------TYPE
          l_txmsg.txfields ('31').defname   := 'TYPE';
          l_txmsg.txfields ('31').TYPE      := 'C';
          l_txmsg.txfields ('31').VALUE      := rec.TYPE;
          ------DESC
          l_txmsg.txfields ('30').defname   := 'DESC';
          l_txmsg.txfields ('30').TYPE      := 'C';
          l_txmsg.txfields ('30').VALUE      := utf8nums.c_const_TLTX_TXDESC_8848;
        p_err_code:=0;
        IF  txpks_#8848.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
            plog.error (pkgctx,'got error 8848: '|| l_err_param);
            ROLLBACK;
        else
            p_err_code:=systemnums.c_success;
            plog.error('Giao dich 8848 thanh cong: '||l_txmsg.txnum);
        end if ;
    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_ODSettlementtransferSec');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on transfer securities');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_ODSettlementtransferSec');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ODSettlementtransferSec;


---------------------------------pr_ODSettlementReceiveMoney------------------------------------------------
  PROCEDURE pr_ODSettlementReceiveSec(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param varchar2(300);
      l_MaxRow NUMBER(20,0);
      v_COMPANYCD VARCHAR2(10);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_ODSettlementReceiveSec');

    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');
    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8819';
     SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    l_txmsg.brid        := systemnums.C_BATCH_BRID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8819';
    for rec in
    (
       SELECT MST.AUTOID, MST.ORDERID,  MST.AFACCTNO,  MST.AFACCTNO || MST.CODEID SEACCTNO , MST.CODEID ,MST.QTTY, MST.AMT, MST.FEEAMT,MST.CLEARDATE SETTLEMENT,FA.SHORTNAME BROKER,
            DD.REFCASAACCT,A1.CDCONTENT TYPEORDER,MST.VAT TAXAMT,CF.FULLNAME,CF.CIFID,
            MST.CUSTODYCD, MST.SYMBOL,MST.DDACCTNO,A1.CDVAL
            FROM (SELECT * FROM (SELECT A.*, ROWNUM ID FROM STSCHD A)/* WHERE ID BETWEEN P_FROMROW AND P_TOROW*/) MST,ODMAST OD,FAMEMBERS FA,DDMAST DD,ALLCODE A1,CFMAST CF,
            (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE') CRD,sbsecurities sb
            WHERE  MST.DUETYPE IN('RS') AND
                    MST.STATUS='P' AND MST.DELTD<>'Y'
            AND TO_DATE(MST.CLEARDATE,'DD/MM/RRRR') = TO_DATE(CRD.VARVALUE,'DD/MM/RRRR')
            AND MST.ORDERID = OD.ORDERID
            AND FA.AUTOID = OD.MEMBER
            AND DD.ACCTNO = MST.DDACCTNO
            AND OD.CUSTODYCD = CF.CUSTODYCD
            AND A1.CDNAME = 'EXECTYPE' AND A1.CDTYPE = 'OD' AND A1.CDVAL = OD.EXECTYPE
            AND OD.EXECTYPE IN ('NB')
            and mst.codeid = sb.codeid
            and sb.bondtype <> '001'
    )
    loop
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        --Xac dinh xem nha day tu trong nuoc hay nuoc ngoai
        IF rec.custodycd='F' then
            v_blnVietnamese:= false;
        else
            v_blnVietnamese:= true;
        end if;
        --Set cac field giao dich
        ------AUTOID
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'N';
        l_txmsg.txfields ('01').VALUE      := rec.AUTOID;
        ------CODEID
        l_txmsg.txfields ('02').defname   := 'CODEID';
        l_txmsg.txfields ('02').TYPE      := 'N';
        l_txmsg.txfields ('02').VALUE      := rec.CODEID;
        ------CUSTODYCD
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE      := rec.CUSTODYCD;
        ------FULLNAME
        l_txmsg.txfields ('90').defname   := 'FULLNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').VALUE      := rec.FULLNAME;
        ------CIFID
        l_txmsg.txfields ('91').defname   := 'CIFID';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').VALUE      := rec.CIFID;
        ------AFACCTNO
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE      := rec.AFACCTNO;
        ------DDACCTNO
        l_txmsg.txfields ('04').defname   := 'DDACCTNO';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE      := rec.DDACCTNO;
        ------SEACCTNO
        l_txmsg.txfields ('05').defname   := 'SEACCTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE      := rec.SEACCTNO;
        ------ORGORDERID
        l_txmsg.txfields ('06').defname   := 'ORGORDERID';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE      := rec.ORDERID;
        ------SYMBOL
        l_txmsg.txfields ('07').defname   := 'SYMBOL';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE      := rec.SYMBOL;
        ------QTTY
        l_txmsg.txfields ('09').defname   := 'QTTY';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE      := rec.QTTY;
        ------AMT
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE      := rec.AMT;
        ------FEE
        l_txmsg.txfields ('11').defname   := 'FEE';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE      := rec.FEEAMT;
        ------TAXAMT
        l_txmsg.txfields ('27').defname   := 'TAXAMT';
        l_txmsg.txfields ('27').TYPE      := 'N';
        l_txmsg.txfields ('27').VALUE      := rec.TAXAMT;
        ------SETTLEMENT
        l_txmsg.txfields ('23').defname   := 'SETTLEMENT';
        l_txmsg.txfields ('23').TYPE      := 'D';
        l_txmsg.txfields ('23').VALUE      := rec.SETTLEMENT;
        ------BROKER
        l_txmsg.txfields ('24').defname   := 'BROKER';
        l_txmsg.txfields ('24').TYPE      := 'C';
        l_txmsg.txfields ('24').VALUE      := rec.BROKER;
        ------REFCASAACCT
        l_txmsg.txfields ('25').defname   := 'REFCASAACCT';
        l_txmsg.txfields ('25').TYPE      := 'C';
        l_txmsg.txfields ('25').VALUE      := rec.REFCASAACCT;
        ------TYPEORDER
        l_txmsg.txfields ('26').defname   := 'TYPEORDER';
        l_txmsg.txfields ('26').TYPE      := 'C';
        l_txmsg.txfields ('26').VALUE      := rec.TYPEORDER;
        ------TYPEORDER CDVAL
        l_txmsg.txfields ('28').defname   := 'CDVAL';
        l_txmsg.txfields ('28').TYPE      := 'C';
        l_txmsg.txfields ('28').VALUE      := rec.CDVAL;
        ------DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE      := UTF8NUMS.c_const_TLTX_TXDESC_8868;
        p_err_code:=0;
        IF  txpks_#8819.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
            plog.error (pkgctx,'got error 8819: '|| l_err_param);
            ROLLBACK;
        else
            p_err_code:=systemnums.c_success;
            plog.error('Giao dich 8819 thanh cong: '||l_txmsg.txnum);
        end if ;
    end loop;
    plog.setendsection(pkgctx, 'pr_ODSettlementReceiveSec');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on receive securities');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_ODSettlementReceiveSec');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ODSettlementReceiveSec;

---------------------------------pr_OrderCleanUp------------------------------------------------
  PROCEDURE pr_OrderCleanUp(p_err_code  OUT varchar2)
  IS
        v_strCURRDATE DATE;
  BEGIN
   plog.setbeginsection(pkgctx, 'pr_OrderCleanUp');
    FOR REC IN
        (SELECT MST.ORDERID FROM ODMAST MST,SBSECURITIES SB  WHERE MST.REMAINQTTY>0 AND MST.ORSTATUS IN ('1','2','4','8','9')
            AND MST.CODEID=SB.CODEID AND SB.TRADEPLACE IN ('001','002','005')
            AND MST.EXECTYPE NOT IN ('AS', 'AB', 'CS', 'CB')
        )
    LOOP
    --CAP NHAT LAI TRANG THAI CHO CAC LENH CON DU.
        UPDATE ODMAST SET ORSTATUS='1', REMAINQTTY=0
        where orderid=rec.orderid;
    END LOOP;

    -- End;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_OrderCleanUp');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_OrderCleanUp');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_OrderCleanUp;

  ---------------------------------pr_OrderFinish------------------------------------------------
  PROCEDURE pr_OrderFinish(p_err_code  OUT varchar2)
  IS
      indate varchar2(20);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_OrderFinish');
    select varvalue into indate from sysvar where grname ='SYSTEM' and varname ='CURRDATE';
    update odmast set orstatus=nvl(
    (select odstatus from
        (SELECT ORDERID,
            (CASE WHEN (REMAINQTTY = 0 AND (SELECT COUNT (ORDERID) FROM STSCHD WHERE STSCHD.ORDERID = ORDERID AND STSCHD.STATUS <> 'C' AND STSCHD.DELTD<>'Y') = 0
                                       AND (SELECT COUNT (ORDERID) FROM STSCHD WHERE STSCHD.ORDERID = ORDERID AND STSCHD.DELTD<>'Y') > 0)THEN '7'
                  WHEN ((EXECQTTY > 0 AND EXECQTTY <= ORDERQTTY)
                                       AND (SELECT COUNT (ORDERID) FROM STSCHD WHERE STSCHD.ORDERID = ORDERID) > 0)THEN '4'
                  ELSE '5' END) ODSTATUS
        FROM ODMAST
        WHERE ORSTATUS <> '5' AND ORSTATUS <> '7' and ORSTATUS <> '3'
             OR (REMAINQTTY = 0 AND (SELECT COUNT (ORDERID) FROM STSCHD WHERE STSCHD.ORDERID = ORDERID AND STSCHD.STATUS <> 'C' AND STSCHD.DELTD<>'Y') =0)
    ) A
    where a.orderid=odmast.orderid),odmast.orstatus
  );
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_OrderFinish');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_OrderFinish');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_OrderFinish;

  ---------------------------------pr_OrderBackUp------------------------------------------------
  PROCEDURE pr_OrderBackUp(p_err_code  OUT varchar2)
  IS
      indate varchar2(20);
      PREVDATE varchar2(20);
      v_currdate    date;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_OrderBackUp');
    select varvalue into PREVDATE from sysvar where grname ='SYSTEM' and varname ='PREVDATE';
    select varvalue into indate from sysvar where grname ='SYSTEM' and varname ='CURRDATE';
    v_currdate := getcurrdate;
    --Sao luu vao odmasthist
    INSERT INTO ODMASTHIST SELECT * FROM ODMAST WHERE ORDERID IN
           (SELECT OD.ORDERID FROM
           (SELECT * FROM ODMAST OD
           WHERE /*(ORDERQTTY=EXECQTTY) AND*/ ORSTATUS IN ('3','5','7') AND ispayment = 'Y' --TRUNG.LUU: 01-04-2021 SHBVNEX-2011 CHUA THANH TOAN THI TREO LAI, KHONG BACKUP
                -- THENN THEM DE CHECK LENH LOI GD CHUA HOAN TAT THI KO CHUYEN XUONG HIST
               -- AND (CASE WHEN OD.ERROD = 'Y' AND od.errsts IN ('A','E','G') THEN 0 ELSE 1 END) = 1
                --AND (CASE WHEN OD.FERROD = 'Y' AND od.errsts IN ('N') THEN 0 ELSE 1 END) = 1
           ) OD
           LEFT JOIN
           (SELECT * FROM STSCHD WHERE STATUS='N' AND DELTD = 'N') SCHD
           ON OD.ORDERID=SCHD.ORDERID
           GROUP BY OD.ORDERID
           HAVING COUNT(SCHD.ORDERID)=0);
    --Sao luu cac lich thanh toan da xoa
    INSERT INTO STSCHDHIST
    SELECT * FROM STSCHD
    WHERE DELTD='Y'
        AND ORDERID NOT IN (SELECT ORDERID FROM ODMAST OD
           --WHERE OD.errod = 'Y' AND OD.errsts <> 'C'
           );
    --Sao luu cac lich thanh toan da thanh toan het
    INSERT INTO STSCHDHIST SELECT * FROM STSCHD WHERE ORDERID IN
           (SELECT OD.ORDERID FROM
           (SELECT * FROM ODMAST OD
           WHERE /*(ORDERQTTY=EXECQTTY) AND*/ ORSTATUS IN ('3','5','7') AND ispayment = 'Y' --TRUNG.LUU: 01-04-2021 SHBVNEX-2011 CHUA THANH TOAN THI TREO LAI, KHONG BACKUP
                -- THENN THEM DE CHECK LENH LOI GD CHUA HOAN TAT THI KO CHUYEN XUONG HIST
                --AND (CASE WHEN OD.ERROD = 'Y' AND od.errsts IN ('A','E','G') THEN 0 ELSE 1 END) = 1
                --AND (CASE WHEN OD.FERROD = 'Y' AND od.errsts IN ('N') THEN 0 ELSE 1 END) = 1
           ) OD
           LEFT JOIN
           (SELECT * FROM STSCHD WHERE STATUS='N' AND DELTD = 'N') SCHD
           ON OD.ORDERID=SCHD.ORDERID
           GROUP BY OD.ORDERID HAVING COUNT(SCHD.ORDERID)=0);
    --Xoa cac lich thanh toan da bi xoa
    DELETE FROM STSCHD
    WHERE DELTD='Y'
        AND ORDERID NOT IN (SELECT ORDERID FROM ODMAST OD);
    --Xoa cac lich thanh toan da thanh toan xong
    DELETE FROM STSCHD WHERE ORDERID IN
           (SELECT OD.ORDERID FROM
           (SELECT * FROM ODMAST OD
           WHERE /*(ORDERQTTY=EXECQTTY) AND*/ ORSTATUS IN ('3','5','7') AND ispayment = 'Y' --TRUNG.LUU: 01-04-2021 SHBVNEX-2011 CHUA THANH TOAN THI TREO LAI, KHONG BACKUP
                -- THENN THEM DE CHECK LENH LOI GD CHUA HOAN TAT THI KO CHUYEN XUONG HIST
                --AND (CASE WHEN OD.ERROD = 'Y' AND od.errsts IN ('A','E','G') THEN 0 ELSE 1 END) = 1
                --AND (CASE WHEN OD.FERROD = 'Y' AND od.errsts IN ('N') THEN 0 ELSE 1 END) = 1
           ) OD
           LEFT JOIN
           (SELECT * FROM STSCHD WHERE STATUS='N' AND DELTD = 'N') SCHD
           ON OD.ORDERID=SCHD.ORDERID
           GROUP BY OD.ORDERID HAVING COUNT(SCHD.ORDERID)=0);
    --Xoa cac lenh da duoc backup
    DELETE FROM ODMAST WHERE ORDERID IN
           (SELECT OD.ORDERID FROM
           (SELECT * FROM ODMAST OD
           WHERE /*(ORDERQTTY=EXECQTTY) AND*/ ORSTATUS IN ('3','5','7') AND ispayment = 'Y' --TRUNG.LUU: 01-04-2021 SHBVNEX-2011 CHUA THANH TOAN THI TREO LAI, KHONG BACKUP
                -- THENN THEM DE CHECK LENH LOI GD CHUA HOAN TAT THI KO CHUYEN XUONG HIST
                --AND (CASE WHEN OD.ERROD = 'Y' AND od.errsts IN ('A','E','G') THEN 0 ELSE 1 END) = 1
                --AND (CASE WHEN OD.FERROD = 'Y' AND od.errsts IN ('N') THEN 0 ELSE 1 END) = 1
           ) OD
           LEFT JOIN
           (SELECT * FROM STSCHD WHERE STATUS='N' AND DELTD = 'N') SCHD
           ON OD.ORDERID=SCHD.ORDERID
           GROUP BY OD.ORDERID HAVING COUNT(SCHD.ORDERID)=0);
    --Dong bo thong tin khop lenh GTC tu ODMAST ve FOMAST
    for rec in
    (
        select fo.acctno, sum(od.EXECQTTY) EXECQTTY,sum(od.EXECAMT) EXECAMT
            from (select * from odmast union select * from odmasthist where txdate > to_date('20/01/2014','DD/MM/RRRR')) od, fomast fo
            where od.foacctno = fo.acctno and od.deltd <> 'Y'
            group by fo.acctno

    )
    loop
        UPDATE FOMAST SET
            EXECQTTY=rec.EXECQTTY,
            EXECAMT=rec.EXECAMT
        WHERE acctno=rec.acctno;
    end loop;
    --Cap nhat trang thai cho lenh GTC truoc khi backup

    update fomast set
        status =(case when EXECAMT>0 then 'C'
                      else 'E' end)
    WHERE EXPDATE<TO_DATE(indate,'DD/MM/YYYY') OR DELTD='Y' OR REMAINQTTY=0;

    --Ngay 24/03/2017 CW NamTv cap nhat trang thai Huy lenh GTC khi ma chung khoan het han
    update fomast set status = 'C'
        where fn_check_cwsecurities(symbol) <> 0
          AND TIMETYPE='G'
          AND STATUS NOT IN ('C','E');

    --'Back up FOMAST--> FOMASTHIST
    INSERT INTO FOMASTHIST SELECT * FROM FOMAST
        WHERE EXPDATE<TO_DATE(indate,'DD/MM/YYYY') OR DELTD='Y' OR REMAINQTTY=0 OR STATUS='C'; --Day xuong hist trang thai la C
    DELETE FROM FOMAST
        WHERE EXPDATE<TO_DATE(indate,'DD/MM/YYYY') OR DELTD='Y' OR REMAINQTTY=0 OR STATUS='C'; --Xoa trang thai la C

    /*
    --'Back up FOMAST--> FOMASTHIST
    INSERT INTO FOMASTHIST SELECT * FROM FOMAST
        WHERE EXPDATE<TO_DATE(indate,'DD/MM/YYYY') OR DELTD='Y' OR REMAINQTTY=0;
    DELETE FROM FOMAST
        WHERE EXPDATE<TO_DATE(indate,'DD/MM/YYYY') OR DELTD='Y' OR REMAINQTTY=0;
    */
    --End Ngay 24/03/2017 CW NamTv
    UPDATE FOMAST SET STATUS='P'
        WHERE REMAINQTTY>0 AND DELTD <>'Y';
    INSERT INTO FOMASTLOGALL
        SELECT * FROM FOMASTLOG;
    DELETE FROM FOMASTLOG;

/*    ---Sao luu cac lenh co ngay thanh toan la ngay hien tai vao bang FEETRANREPAIR
    INSERT INTO FEETRANREPAIR
    SELECT OD.TXDATE, OD.TXNUM, OD.ORDERID, OD.EXECTYPE, OD.SYMBOL, OD.CLEARDATE, OD.EXECQTTY QTTY, OD.EXECAMT AMOUNT, 0 FEEAMT,
           0 REPAIRAMT, OD.CUSTID, OD.AFACCTNO, 'P' STATUS, 'N' DELTD, OD.TLID MAKERID, OD.TLID CHECKERID
    FROM VW_ODMAST_ALL OD
    WHERE OD.DELTD <> 'Y'
    AND OD.CLEARDATE = v_currdate;*/

    COMMIT;

    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_OrderBackUp');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_OrderBackUp');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_OrderBackUp;

  PROCEDURE pr_LTVCal(p_bchmdl varchar,p_err_code  OUT varchar2)
  IS
    l_count                     NUMBER(10,0);
    l_valueofissue              NUMBER(20,4); --tong gia tri phat hanh cua dot phat hanh
    l_ltv                       NUMBER(20,4);
    l_price                     NUMBER(20,4);
    l_date                      date;
    l_symbol                    varchar2(100);
    l_actype                    varchar2(10);
    l_sectype                   varchar2(10);
    l_valmethod                 varchar2(10);
    --
    l_next_scheduler_LTV        DATE;
    l_nextdate                  DATE;
    l_months                    NUMBER;
    c_max_ltv_template_EM17     CHAR(6) := 'EM17EN';
    c_warning_ltv_template_EM16 CHAR(6) := 'EM16EN';
    c_schd_ltv_template_EM18    CHAR(6) := 'EM18EN';
    --NAM.LY
    l_check                     NUMBER := 0;
    l_typerate                  VARCHAR2(3);  --loai nguyen tac dinh gia tai san dam bao
    l_type_pledged              VARCHAR2(15); --Loai tai san cam co
    l_sec_val_price             NUMBER(20,4); --Gia tri dinh gia cua chung khoan
    l_t_percent                 NUMBER(20,4); --T% cua tien gui/tien mat
    l_sec_qtty                  NUMBER;       --so luong chung khoan
    l_cash_amt                  NUMBER(20,4); --menh gia cua tien mat
    l_total_sec_amt             NUMBER(20,4); --tong gia tri cua tai sai cam co la chung khoan
    l_total_cashdepo_amt        NUMBER(20,4); --tong gia tri cua tien gui/tien mat
    l_yparam                    NUMBER;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_LTVCal');
    l_date:= to_date(getcurrdate);
    l_nextdate := TO_DATE(cspks_system.fn_get_sysvar('SYSTEM','NEXTDATE'), systemnums.C_DATE_FORMAT);

    --NAM.LY: 07/01/2020 THAY DOI RULE TINH LTV DO KHONG CON TINH THEO BONDCODE => TINH THEO ISSUESCODE(MA DOT PHAT HANH)
    /*   for rec in
        (
        SELECT sb.CODEID, sb.SYMBOL, sb.issuerid, sb.valueofissue, iss.fullname,  sb.typerate,
                sb.maxltvrate, sb.warningltvrate, sb.issuedate
        FROM SBSECURITIES sb, ISSUERS iss--, cfmast cf
             WHERE SECTYPE IN ('003', '006', '222')
             AND ROLEOFSHV IN ('002', '003', '004')
             AND sb.CONTRACTNO IS NOT NULL
             AND iss.issuerid = sb.issuerid
             AND sb.typerate IN ('002','003')
             )
    loop
      l_valueofissue := to_number(rec.valueofissue);
      l_amount := 0;
      FOR r in (
          SELECT SE.AFACCTNO afacctno, SE.ACCTNO acctno, CF.FULLNAME CUSTNAME, CF.CUSTODYCD, SB.SYMBOL,
                 SB.PARVALUE, mt.qtty qtty, SB.CODEID,
                 ba.issuerid, iss.Fullname ISSUERNAME, mt.bondcode, ba.symbol bondsymbol
                 from (
                     select se.acctno, se.afacctno, se.bondcode,
                            sum(case when se.tltxcd in ('2232') then se.qtty
                                     when se.tltxcd in ('2253') then -se.qtty else 0 end) qtty
                     from semortage se
                     where se.status IN ('C')
                     and se.bondcode is not null
                     group by se.acctno, se.afacctno,se.bondcode
                     UNION ALL
                     select se.acctno, se.afacctno, se.bondcode,
                            sum(case when se.tltxcd in ('1900') then se.qtty
                                     when se.tltxcd in ('1901') then -se.qtty else 0 end) qtty
                     from semortage se
                     where se.status IN ('C')
                     and se.bondcode is not null
                     group by se.acctno, se.afacctno,se.bondcode) mt,
                 semast se, sbsecurities sb, afmast af, cfmast cf, issuer_member iss, sbsecurities ba
                 WHERE mt.acctno = se.acctno and se.mortage > 0 and se.codeid = sb.codeid
                       and se.afacctno = af.acctno and af.custid = cf.custid and mt.qtty > 0
                       and iss.custid = cf.custid
                       and ba.codeid = mt.bondcode
                       and iss.issuerid = ba.issuerid
                       and mt.bondcode = rec.codeid)
      LOOP
        l_qtty := r.qtty;

        SELECT r.SYMBOL, bo.ACTYPE, bo.SECTYPE, bo.VALMETHOD into l_symbol, l_actype, l_sectype, l_valmethod
        FROM bondtype bo
        WHERE instr(bo.tickerlist, r.SYMBOL) > 0 and bo.BONDCODE = r.BONDCODE;

        l_price := nvl(fn_get_mortage_price(l_symbol, l_actype, l_sectype, l_valmethod),0);

        insert into BONDINFO (BONDCODE, TXDATE, BONDACTYPE, BONDPRICE, CODEID, VBMA, REUTERS, INTERPOLATION, SYMBOL, NOTE,PRICETYPE)
        values (r.bondcode, l_date,l_actype, l_price, r.codeid, null, null, null, l_symbol, null,l_valmethod);

        l_amount := l_amount + (l_qtty * l_price);
      END LOOP;
      IF NVL(l_amount, 0) <= 0 THEN
        CONTINUE;
      END IF;
      l_ltv := round(l_valueofissue*100/l_amount,4);

      UPDATE SECURITIES_INFO se set se.LTVRATE = l_ltv
      WHERE se.codeid = rec.codeid;
      */

     --NAM.LY: 07/01/2020 THAY DOI RULE TINH LTV DO KHONG CON TINH THEO BONDCODE => TINH THEO ISSUESCODE(MA DOT PHAT HANH)
     --==============================BEGIN OF [NAM.LY 09/01/2020]--------------------------------------------------------
        --LAY DANH SACH CAC DOT PHAT HANH
        FOR rec IN
        (
            SELECT ISS.AUTOID ISSUESID, ISS.ISSUECODE,ISS.ISSUERID, ISR.FULLNAME, ISS.ISSUEDATE,
               ISS.VALUEOFISSUE, ISS.LTVRATE, ISS.TYPERATE, ISS.MAXLTVRATE, ISS.WARNINGLTVRATE
            FROM ISSUES ISS, ISSUERS ISR
            WHERE ISR.ISSUERID = ISS.ISSUERID
         )
        LOOP
        l_valueofissue       := to_number(rec.VALUEOFISSUE);
        l_total_sec_amt      := 0;
        l_total_cashdepo_amt := 0;
        l_typerate           := rec.TYPERATE;
        --LAY THONG TIN TRAI PHIEU PHAT HANH VA CHUNG KHOAN/TIEN GUI/TIEN MAT CAM CO CUA DOT PHAT HANH
        FOR r IN (
                    SELECT ISS.AUTOID ISSUESID, SB.SYMBOL, SB.PARVALUE,
                           SB.CODEID, SB.SECTYPE, A1.CDCONTENT SECTYPE_NAME,
                           SUM(MT.QTTY) QTTY,
                           (CASE WHEN SB.SECTYPE IN ('014') THEN SUM(MT.AMT)
                                 WHEN SB.SECTYPE IN ('009','013') THEN SUM(MT.QTTY)*SB.PARVALUE
                                 ELSE 0
                            END) AMT,
                           (CASE WHEN SB.SECTYPE IN ('014') THEN 'CASH'
                                 WHEN SB.SECTYPE IN ('013') THEN 'CD'
                                 WHEN SB.SECTYPE IN ('009') THEN 'TERM_DEPOSIT'
                                 WHEN SB.SECTYPE IN ('003','006') THEN 'BOND'
                                 WHEN SB.SECTYPE IN ('001','008','011') THEN 'SHARE'
                            END) TYPE_PLEDGED,
                           ISS.ISSUECODE, SB.ISSUEDATE
                    FROM (
                            SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,
                                SUM(CASE WHEN SE.TLTXCD IN ('2232') THEN SE.QTTY
                                         WHEN SE.TLTXCD IN ('2233') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                            FROM SEMORTAGE SE
                            WHERE     SE.STATUS IN ('C')
                                  AND SE.DELTD <> 'Y'
                                  AND SE.ISSUESID IS NOT NULL
                            GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
                            UNION ALL
                            SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,
                                SUM(CASE WHEN SE.TLTXCD IN ('1900') THEN SE.QTTY
                                         WHEN SE.TLTXCD IN ('1901') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                            FROM SEMORTAGE SE
                            WHERE     SE.STATUS IN ('C')
                                  AND SE.DELTD <> 'Y'
                                  AND SE.ISSUESID IS NOT NULL
                            GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
                            UNION ALL
                            SELECT BL.CODEID, BL.ISSUESID, 0 QTTY,
                                SUM(CASE WHEN BL.TLTXCD IN ('1909') THEN BL.AMT
                                         WHEN BL.TLTXCD IN ('1910') THEN -BL.AMT ELSE 0 END) AMT
                            FROM BLOCKAGE BL
                            WHERE     BL.DELTD <> 'Y'
                                  AND BL.ISSUESID IS NOT NULL
                            GROUP BY BL.CODEID,BL.ISSUESID
                         ) MT
                    JOIN SBSECURITIES SB ON MT.CODEID = SB.CODEID
                    JOIN ISSUES ISS ON MT.ISSUESID = ISS.AUTOID
                    JOIN ALLCODE A1 ON A1.CDVAL = SB.SECTYPE AND CDNAME ='SECTYPE' AND CDTYPE ='SA'
                    JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
                    WHERE NOT (MT.QTTY = 0 AND MT.AMT = 0)
                          AND MT.ISSUESID = REC.ISSUESID
                    GROUP BY ISS.AUTOID, SB.SYMBOL, SB.PARVALUE, SB.CODEID, SB.SECTYPE, A1.CDCONTENT, ISS.ISSUECODE, SB.ISSUEDATE
                )
        LOOP
        l_sec_qtty     := r.QTTY;
        l_cash_amt     := r.AMT;
        l_type_pledged := r.TYPE_PLEDGED;
        --LAY THONG TIN CUA CHUNG KHOAN CAM CO VA TRAI PHIEU PHAT HANH DE TINH DINH GIA TSDB
        BEGIN
            SELECT SYMBOL, ACTYPE, SECTYPE, VALMETHOD, COUNT(1)
            INTO l_symbol, l_actype, l_sectype, l_valmethod, l_check
            FROM (
                    SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) SYMBOL, BO.ACTYPE, BO.SECTYPE, BO.VALMETHOD
                    FROM BONDTYPE BO
                    WHERE BO.ISSUESID = r.ISSUESID
                    CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
                 )
            WHERE SYMBOL = r.SYMBOL
            GROUP BY SYMBOL, ACTYPE, SECTYPE, VALMETHOD;
            EXCEPTION
                WHEN OTHERS THEN l_sec_val_price := 0;
                                 l_t_percent     := 0;
        END;
        --TINH GIA TSDB (MH 111701)
        IF l_check <> 0 THEN
            BEGIN
                IF l_sectype <> '555' THEN --co phieu & trai phieu
                    l_sec_val_price := NVL(fn_get_mortage_price(l_symbol, l_actype, l_sectype, l_valmethod),0);

                    DELETE FROM BONDINFO WHERE ISSUESID = r.ISSUESID AND TXDATE = l_date and CODEID = r.CODEID;
                    INSERT INTO BONDINFO (ISSUESID, TXDATE, BONDACTYPE, BONDPRICE, CODEID, VBMA, REUTERS, INTERPOLATION, SYMBOL, NOTE, PRICETYPE)
                    VALUES (r.ISSUESID, l_date, l_actype, l_sec_val_price, r.CODEID, NULL, NULL, NULL, l_symbol, NULL, l_valmethod);
                ELSE --tien
                    l_t_percent     := NVL(fn_get_mortage_price(l_symbol, l_actype, l_sectype, l_valmethod),0);

                    DELETE FROM BONDINFO WHERE ISSUESID = r.ISSUESID AND TXDATE = l_date and CODEID = r.CODEID;
                    INSERT INTO BONDINFO (ISSUESID, TXDATE, BONDACTYPE, TPERCENT, CODEID, VBMA, REUTERS, INTERPOLATION, SYMBOL, NOTE, PRICETYPE)
                    VALUES (r.ISSUESID, l_date, l_actype, l_t_percent, r.CODEID, NULL, NULL, NULL, l_symbol, NULL, l_valmethod);
                END IF;
                IF l_sectype = '111' THEN
                    --begin SHBVNEX-2335
                    IF FN_CHECK_NO_TRANSACTION(l_symbol, l_actype, l_sectype, l_valmethod, l_yparam) = TRUE THEN
                        NMPKS_EMS.PR_SENDINTERNALEMAIL('SELECT ''' || l_symbol || ''' p_symbol, ''' || TO_CHAR(r.ISSUEDATE,'DD/MM/RRRR') || ''' p_issuedate, ''' || TO_CHAR(l_date, 'DD/MM/RRRR') || ''' p_currdate, ''' || l_yparam || ''' p_yparam FROM DUAL', 'EM46', '','N');
                    END IF;
                    --end SHBVNEX-2335
                END IF;
            END;
            l_check := 0;
        END IF;
        --TINH TONG TS CUA CHUNG KHOAN CAM CO
        IF (l_type_pledged = 'SHARE' OR l_type_pledged = 'BOND') THEN
            l_total_sec_amt := l_total_sec_amt + (l_sec_qtty * l_sec_val_price);
        ELSIF (l_type_pledged = 'CASH' OR l_type_pledged = 'CD' OR l_type_pledged = 'TERM_DEPOSIT') THEN
            l_total_cashdepo_amt := l_total_cashdepo_amt + (l_cash_amt*(l_t_percent/100));
        END IF;
        END LOOP;
        --
        
        IF (NVL(l_total_sec_amt, 0) <= 0 OR NVL(l_valueofissue - l_total_cashdepo_amt, 0) <= 0) THEN
            DELETE FROM ISSUES_HIST WHERE HISTDATE=l_date AND AUTOID=REC.ISSUESID;

            INSERT INTO ISSUES_HIST (HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, LTVRATE)
            SELECT l_date HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, LTVRATE
            FROM ISSUES
            WHERE AUTOID=REC.ISSUESID;

            CONTINUE;
        END IF;
        --TINH LTVRATE
        IF l_typerate ='002' THEN --LTV
            l_ltv := ROUND(((l_valueofissue - l_total_cashdepo_amt)/l_total_sec_amt)*100,2);
        ELSIF l_typerate ='003' THEN --CCR
            l_ltv := ROUND((l_total_sec_amt/(l_valueofissue - l_total_cashdepo_amt))*100,2);
        END IF;
        --CAP NHAT LTV VAO BANG ISSUES
        UPDATE ISSUES SET LTVRATE = l_ltv
        WHERE AUTOID = REC.ISSUESID;
        --LUU LOG
        DELETE FROM ISSUES_HIST WHERE HISTDATE=l_date AND AUTOID=REC.ISSUESID;
        INSERT INTO ISSUES_HIST (HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, LTVRATE)
            SELECT l_date HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, LTVRATE
            FROM ISSUES
            WHERE AUTOID=REC.ISSUESID;
        -- check and genTemplateWarningLTV
        l_months := MONTHS_BETWEEN(l_date, rec.ISSUEDATE);
        
        -- TriBui 31/07/2020 edit time sent email EM18
        IF mod(l_months,3) = 0 AND l_months > 0  THEN
            l_next_scheduler_LTV := l_date;
        ELSE
            l_next_scheduler_LTV := TO_DATE(NULL);
        END IF;
        -- End TriBui 31/07/2020 edit time sent email EM18
        
        
        IF rec.typerate = '002' AND NVL(l_ltv, 0) > 0 THEN -- LTV
        IF l_ltv > NVL(rec.maxltvrate, -0) THEN
          nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                              l_nextdate,
                                              l_ltv,
                                              rec.maxltvrate,
                                              c_max_ltv_template_EM17,
                                              utf8nums.c_EMAIL_EM17_MAX_LTV);
        ELSIF l_ltv > NVL(rec.warningltvrate, -0) AND l_ltv <= NVL(rec.maxltvrate, -0) THEN
          nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                              l_nextdate,
                                              l_ltv,
                                              rec.maxltvrate,
                                              c_warning_ltv_template_EM16,
                                              utf8nums.c_EMAIL_EM16_WARNING_LTV);
        END IF;
        IF l_next_scheduler_LTV = l_date  THEN
          nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                              l_nextdate,
                                              l_ltv,
                                              rec.maxltvrate,
                                              c_schd_ltv_template_EM18,
                                              utf8nums.c_EMAIL_EM18_SCHD_LTV);
        END IF;

      ELSIF rec.typerate = '003' AND NVL(l_ltv, 0) > 0 THEN -- CCR
        IF l_ltv < rec.maxltvrate AND rec.maxltvrate > 0 THEN
          nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                              l_nextdate,
                                              l_ltv,
                                              ROUND(1/rec.maxltvrate, 4),
                                              c_max_ltv_template_EM17,
                                              utf8nums.c_EMAIL_EM17_MAX_LTV);
        END IF;
/*      --TriBui 03/08/2020 CCR khong gui mail EM16.EM18
        IF l_ltv < rec.warningltvrate AND l_ltv >= rec.maxltvrate
             AND rec.maxltvrate > 0 AND rec.warningltvrate > 0 THEN
          nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                              l_nextdate,
                                              l_ltv,
                                              ROUND(1/rec.warningltvrate, 4),
                                              c_warning_ltv_template_EM16,
                                              utf8nums.c_EMAIL_EM16_WARNING_LTV);
        END IF;

        IF l_next_scheduler_LTV = l_date THEN
          nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                              l_nextdate,
                                              l_ltv,
                                              ROUND(1/rec.maxltvrate, 4),
                                              c_schd_ltv_template_EM18,
                                              utf8nums.c_EMAIL_EM18_SCHD_LTV);
        END IF;
*/
      END IF;
    --==============================END OF [NAM.LY 09/01/2020]--------------------------------------------------------
    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_LTVCal');
    EXCEPTION
    WHEN OTHERS
    THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_LTVCal');
      RAISE errnums.E_SYSTEM_ERROR;
    END pr_LTVCal;

    PROCEDURE pr_SEDepo(p_bchmdl varchar,p_err_code  OUT varchar2)
    IS
        V_GETCURRENT DATE;
        V_EOMDATE DATE;
    BEGIN
        plog.setbeginsection(pkgctx, 'pr_SEDepo');
        p_err_code := 0;

        --trung.luu : 31-07-2020 SHBVNEX-968
        INSERT INTO SEDEPO_DAILY (TRADEDATE,CUSTODYCD,AFACCTNO,ACCTNO,SECTYPE,SETYPE,CODEID,TRADEPLACE,TRDPLACE,SEBAL,PRICE,ASSET,ASSET_VND,ASSET_USD,EX_RATED,EX_RATE_USD,CCYCD)
        SELECT TO_DATE(GETCURRDATE,'DD/MM/RRRR') TRADEDATE,CUSTODYCD,AFACCTNO,ACCTNO,SECTYPE,SETYPE,CODEID,TRADEPLACE,TRDPLACE,SEBAL,PRICE,ASSET,ASSET_VND,ASSET_USD,EX_RATED,EX_RATE_USD,CCYCD
        FROM VW_SEDEPO_DAILY;

        V_GETCURRENT := GETCURRDATE;

        SELECT MAX(SB.SBDATE) INTO V_EOMDATE
        FROM SBCLDR SB
        WHERE SB.CLDRTYPE = '000' AND SB.HOLIDAY = 'N'
        AND TO_CHAR(SB.SBDATE,'MM/RRRR') = TO_CHAR(V_GETCURRENT,'MM/RRRR');

        ---- Cuoi thang thuc hien tinh phi luu ky
        IF V_EOMDATE = V_GETCURRENT THEN
            CSPKS_FEECALCNEW.PRC_SEDEPO(V_EOMDATE, NULL, P_ERR_CODE);
        END IF;
        plog.setendsection(pkgctx, 'pr_SEDepo');
    EXCEPTION WHEN OTHERS THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'pr_SEDepo');
        RAISE errnums.E_SYSTEM_ERROR;
    END pr_SEDepo;

 PROCEDURE pr_feetranr(p_bchmdl varchar,p_err_code  OUT varchar2)
  IS
    v_getcurrent date;
    l_sysvar varchar2(100);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_feetranr');
    v_getcurrent := getcurrdate;

      --trung.luu: 06-01-2021 SHBVNEX-19688 b? t?nh ph? cho TK t? doanh
     SELECT varvalue into l_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';

    --thunt-28/02/2020: Sao luu cac lenh co ngay thanh toan la ngay hien tai vao bang FEETRANREPAIR
    INSERT INTO FEETRANREPAIR
    SELECT OD.TXDATE, OD.TXNUM, OD.ORDERID, OD.EXECTYPE, OD.SYMBOL, OD.CLEARDATE, OD.EXECQTTY QTTY, OD.EXECAMT AMOUNT, 0 FEEAMT,
           0 REPAIRAMT, OD.CUSTID, OD.AFACCTNO, 'P' STATUS, 'N' DELTD, OD.TLID MAKERID, OD.TLID CHECKERID,'' FEETYPES
    FROM VW_ODMAST_ALL OD, CFMAST CF
    WHERE OD.DELTD <> 'Y' AND OD.ODTYPE in ('ODT','ODG')
    AND CF.CUSTODYCD=OD.CUSTODYCD
    and substr(CF.CUSTODYCD,0,4) <> l_sysvar
    AND CF.SUPEBANK='N'
    AND CF.BONDAGENT <> 'Y'  --trung.luu: 08/06/2020 SHBVNEX-1073 Kh?ti?nh d?vo?i kha?ch ha`ng Bondagent = Yes
    AND OD.CLEARDATE = v_getcurrent;
    COMMIT;
    plog.setendsection(pkgctx, 'pr_feetranr');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_feetranr');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_feetranr;

 PROCEDURE pr_BAFeeRemind(p_bchmdl varchar,p_err_code  OUT varchar2)
  IS
    v_date date;
    v_currdate date;
    v_contractdate date;
    v_autoid number;
    v_title varchar2(200);
    v_entitle varchar2(200);
    v_assign varchar2(20);
    v_assign_name varchar2(20);
    ----
    v_crtitle varchar2(200);
    v_crassign varchar2(20);
    v_crassign_name varchar2(20);
    v_note varchar2(500);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_BAFeeRemind');
    v_currdate:= getcurrdate;
    select getprevworkingdate(getprevworkingdate(getprevworkingdate(v_currdate))) into v_date from dual;
    begin
        select varvalue into v_assign_name from sysvar where varname = 'REMINDID' and grname = 'DEFINED';
        select tlid into v_assign from tlprofiles where tlname = v_assign_name;
    exception when others then v_assign := '0001';
    end;
    for rec in
        (SELECT sb.CODEID, sb.SYMBOL, sb.issuerid, sb.valueofissue,sb.contractdate,iss.fullname--, cf.custid, cf.custodycd
        FROM SBSECURITIES sb, ISSUERS iss--, cfmast cf
             WHERE SECTYPE IN ('003', '006', '222')
             AND ROLEOFSHV IN ('002', '003', '004')
             AND sb.CONTRACTNO IS NOT NULL
             AND iss.issuerid = sb.issuerid
             --AND iss.custid = cf.custid
             AND sb.payfeetype = '003')
    loop
      IF to_char(v_date,'DD/MM') = to_char(rec.contractdate,'DD/MM') then
        select max(autoid) + 1 into v_autoid from SBACTIMST;
        v_title := 'Ghi nhan phi dai ly ' || rec.symbol || '_' || rec.contractdate;
        v_entitle := 'Record Bond agent fee ' || rec.symbol || '_' || rec.contractdate;
        insert into SBACTIMST (AUTOID, ACTIMSTTYP, PRIORITY, STATUS, RESOLUTION, COMPONENT, LABELS, TITLE, TITLE_EN, NOTES, REFCODE, TXNUM, TXDATE, DELTD, CREATEDT, UPDATEDT, RESOLVEDT, DUEDT, PSTATUS, SBSTATUS, ASSIGNID, RESTRID, TRADING_ACCOUNT, FREQUENCY)
        values (v_autoid, 'I', 'H', 'P', null, 'B', null, v_title, v_entitle, null, null, null, v_currdate, 'N', v_currdate, v_currdate, v_currdate, v_currdate, null, 'O', v_assign, 0, /*rec.custodycd*/NULL, 'AN');
      END IF;
    end loop;
     ---REMIND giu ho tai san
   begin
        select varvalue into v_crassign_name from sysvar where varname = 'RMPHYSICALID' and grname = 'DEFINED';
        select tlid into v_crassign from tlprofiles where tlname = v_crassign_name;
    exception when others then v_crassign := '0001';
    end;
    for rec in
        (SELECT CR.CUSTODYCD, CRLOG.Netamt
        FROM CRPHYSAGREE_SELL_LOG CRLOG, CRPHYSAGREE CR, CFMAST CF
             WHERE CRLOG.Selldate = v_currdate
             AND CRLOG.STATUS = 'P'
             AND CRLOG.CRPHYSAGREEID = cr.crphysagreeid
             AND CR.custodycd = CF.custodycd
             AND CF.bondagent <> 'Y' --trung.luu: 08/06/2020 SHBVNEX-1073 Kh?ti?nh d?vo?i kha?ch ha`ng Bondagent = Yes
        )
    loop
        v_crtitle := 'Check receipt of money from selling physical';
        v_note := 'Check receipt of money from selling physical/Amount: '|| rec.Netamt;
        insert into SBACTIMST (AUTOID, ACTIMSTTYP, PRIORITY, STATUS, RESOLUTION, COMPONENT, LABELS, TITLE, TITLE_EN, NOTES, REFCODE, TXNUM, TXDATE, DELTD, CREATEDT, UPDATEDT, RESOLVEDT, DUEDT, PSTATUS, SBSTATUS, ASSIGNID, RESTRID, TRADING_ACCOUNT, FREQUENCY)
        values (SEQ_SBACTIMST.Nextval, 'I', 'H', 'O', null, 'T', null, v_crtitle, v_crtitle, v_note, null, null, v_currdate, 'N', v_currdate, v_currdate, v_currdate, v_currdate, null, 'O', v_assign, null, rec.CUSTODYCD, 'AN');
    end loop;

    --trung.luu :23-07-2020 insert nhac view bondagent
    
    PR_INSERT_TASKBONDAGENT();
    
    /*insert into TASKBONDAGENT(autoid,type,task,deadline,status,symbol,ISSUEDATE)
    select seq_TASKBONDAGENT.nextval,a1.cdcontent type,a2.cdcontent task, to_date(deadline,'dd/MM/RRRR'),'O',v.symbol,v.ISSUEDATE
        From vw_bond_agent v,
                (select *from allcode where cdtype ='BA' AND CDNAME ='BONDAGENTTYPE')a1,
                (select *from allcode where cdtype ='BA' AND CDNAME ='BONDAGENTTASK') a2
        where   v.type =a1.cdval(+)
            and v.task = a2.cdval(+)
    ;
    commit;*/
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_SEDepo');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_BAFeeRemind');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_BAFeeRemind;

    PROCEDURE pr_MinimumFee(P_ERR_CODE OUT VARCHAR2)
    IS
        V_GETCURRENT DATE;
        V_EOMDATE DATE;
    BEGIN
        plog.setbeginsection(pkgctx, 'pr_MinimumFee');
        p_err_code:=0;
        V_GETCURRENT := GETCURRDATE;

        SELECT MAX(SB.SBDATE) INTO V_EOMDATE
        FROM SBCLDR SB
        WHERE SB.CLDRTYPE = '000' AND SB.HOLIDAY = 'N'
        AND TO_CHAR(SB.SBDATE,'MM/RRRR') = TO_CHAR(V_GETCURRENT,'MM/RRRR');

        ---- Cuoi thang thuc hien tinh phi luu ky
        IF V_EOMDATE = V_GETCURRENT THEN
            CSPKS_FEECALCNEW.PRC_MINIMUM(V_EOMDATE, NULL, P_ERR_CODE);
        END IF;

        plog.setendsection(pkgctx, 'pr_MinimumFee');
    EXCEPTION WHEN OTHERS THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'pr_MinimumFee');
        RAISE errnums.E_SYSTEM_ERROR;
    END pr_MinimumFee;

PROCEDURE pr_AutoCallCompleteCA (p_bchmdl    VARCHAR2,
                                p_err_code   OUT VARCHAR2)
IS
--l_tltxcd         tltx.tltxcd%TYPE := '3388';
l_txmsg          tx.msg_rectype;
v_strDesc        tltx.txdesc%TYPE;
v_strEN_Desc     tltx.en_txdesc%TYPE;
v_strCURRDATE    VARCHAR2(10);
l_err_param      VARCHAR2(2000);
l_tltxcd tltx.tltxcd%TYPE := '3375';
v_currdate      date;
BEGIN
  plog.setBeginSection (pkgctx, 'pr_AutoCallCompleteCA');
  --v_strCURRDATE := cspks_system.fn_get_sysvar('SYSTEM', 'SYSTEM');
  p_err_code := systemnums.C_SUCCESS;

--thunt-06/04/2020: SHBVNEX-748
/*
  SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM TLTX WHERE TLTXCD = l_tltxcd;
  SELECT varvalue INTO v_strCURRDATE
  FROM sysvar
  WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

  l_txmsg.msgtype:='T';
  l_txmsg.local:='N';
  l_txmsg.tlid        := systemnums.c_system_userid;
  plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
  SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO l_txmsg.wsname, l_txmsg.ipaddress
  FROM DUAL;
  l_txmsg.off_line    := 'N';
  l_txmsg.deltd       := txnums.c_deltd_txnormal;
  l_txmsg.txstatus    := txstatusnums.c_txcompleted;
  l_txmsg.msgsts      := '0';
  l_txmsg.ovrsts      := '0';
  l_txmsg.batchname   := p_bchmdl;
  l_txmsg.txdate      :=  to_date(v_strCURRDATE,systemnums.c_date_format);
  l_txmsg.busdate     :=  to_date(v_strCURRDATE,systemnums.c_date_format);
  l_txmsg.tltxcd      :=  l_tltxcd;
  l_txmsg.brid        := systemnums.C_BATCH_BRID;
  plog.debug(pkgctx, 'Begin loop');

  for rec IN (
    SELECT ca.camastid, sym.symbol symbol_org, tosym.symbol symbol, a1.en_cdcontent catype, ca.reportdate,  ca.actiondate,
           (CASE WHEN ca.EXRATE IS NOT NULL THEN ca.EXRATE
                 WHEN ca.RIGHTOFFRATE IS NOT NULL THEN ca.RIGHTOFFRATE
                 WHEN ca.DEVIDENTRATE IS NOT NULL THEN ca.DEVIDENTRATE
                 WHEN ca.SPLITRATE IS NOT NULL THEN ca.SPLITRATE
                 WHEN ca.INTERESTRATE IS NOT NULL THEN INTERESTRATE
                 WHEN ca.DEVIDENTSHARES IS NOT NULL THEN DEVIDENTSHARES
                 ELSE '0' END) RATE,
           a2.en_cdcontent status
    FROM camast ca, sbsecurities sym, sbsecurities tosym,
         (select * FROM allcode WHERE cdname = 'CATYPE' AND cdtype = 'CA') a1,
         (select * FROM allcode WHERE cdname = 'CASTATUS' AND cdtype = 'CA') a2
    WHERE (CASE WHEN ca.catype IN ('010', '015', '016', '027', '024', '021', '011', '017', '020', '014', '023', '033')
                          AND ca.status IN ('J','B') THEN 1
                WHEN ca.catype IN ('005', '028', '006') AND ca.status IN ('I', 'B') THEN 1
                WHEN ca.catype IN ('029', '031', '032', '003', '030', '019') AND ca.status IN ('A','B') THEN 1
                ELSE 0 END) = 1
    AND ca.codeid = sym.codeid(+) AND ca.tocodeid = tosym.codeid(+)
    AND ca.catype = a1.cdval AND ca.status = a2.cdval
  )Loop
      SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
      INTO l_txmsg.txnum
      FROM DUAL;

      --Set cac field giao dich
      --03  CAMASTID
      l_txmsg.txfields ('03').defname   := 'CAMASTID';
      l_txmsg.txfields ('03').TYPE      := 'C';
      l_txmsg.txfields ('03').VALUE     := rec.CAMASTID;
      --71  SYMBOL_ORG
      l_txmsg.txfields ('71').defname   := 'SYMBOL_ORG';
      l_txmsg.txfields ('71').TYPE      := 'C';
      l_txmsg.txfields ('71').VALUE     := rec.SYMBOL_ORG;
      --04  SYMBOL
      l_txmsg.txfields ('04').defname   := 'SYMBOL';
      l_txmsg.txfields ('04').TYPE      := 'C';
      l_txmsg.txfields ('04').VALUE     := rec.SYMBOL;
      --05  CATYPE
      l_txmsg.txfields ('05').defname   := 'CATYPE';
      l_txmsg.txfields ('05').TYPE      := 'C';
      l_txmsg.txfields ('05').VALUE     := rec.CATYPE;
      --06  REPORTDATE
      l_txmsg.txfields ('06').defname   := 'REPORTDATE';
      l_txmsg.txfields ('06').TYPE      := 'C';
      l_txmsg.txfields ('06').VALUE     := TO_CHAR(rec.REPORTDATE, systemnums.C_DATE_FORMAT);
      --07  ACTIONDATE
      l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
      l_txmsg.txfields ('07').TYPE      := 'C';
      l_txmsg.txfields ('07').VALUE     := TO_CHAR(rec.ACTIONDATE, systemnums.C_DATE_FORMAT);
      --10  RATE
      l_txmsg.txfields ('10').defname   := 'RATE';
      l_txmsg.txfields ('10').TYPE      := 'C';
      l_txmsg.txfields ('10').VALUE     := rec.RATE;
      --20  STATUS
      l_txmsg.txfields ('20').defname   := 'STATUS';
      l_txmsg.txfields ('20').TYPE      := 'C';
      l_txmsg.txfields ('20').VALUE     := rec.STATUS;
      --30  DESC
      l_txmsg.txfields ('30').defname   := 'DESC';
      l_txmsg.txfields ('30').TYPE      := 'C';
      l_txmsg.txfields ('30').VALUE     := v_strEN_Desc;

      BEGIN
          IF txpks_#3388.fn_batchtxprocess (l_txmsg,
                                           p_err_code,
                                           l_err_param) <> systemnums.c_success
          THEN
             plog.error (pkgctx, 'got error 3388: ' || p_err_code);
             ROLLBACK;
             plog.setEndSection (pkgctx, 'pr_AutoCallCompleteCA');
             RETURN;
          END IF;
      END;
  end loop;*/

  begin
        for rec in
        (
            select ca.camastid from camast ca where ca.status='N' and ca.deltd='N' and  to_date(getcurrdate,'DD/MM/RRRR') = getnextworkingdate(ca.reportdate)
        )loop
            begin
                ca_autocall3375(rec.camastid);
            exception
              when others
               then
                    rollback;
                    plog.error (pkgctx, 'camastid:' || rec.camastid || '.' || sqlerrm || dbms_utility.format_error_backtrace);
                    continue;
            end;
            commit;
        end loop;
    end;

  plog.setEndSection (pkgctx, 'pr_AutoCallCompleteCA');
EXCEPTION
  WHEN OTHERS THEN
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setEndSection (pkgctx, 'pr_AutoCallCompleteCA');
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_ApFeeWD(p_bchmdl varchar,p_err_code  OUT varchar2)
IS
V_GETCURRENT DATE;
V_FEEAMT     NUMBER(20,4);
V_TAXAMT     NUMBER(20,4);
V_TAXRATE    NUMBER(20,4);
V_CCYCD      VARCHAR2(20);
V_AUTOID    NUMBER;
V_CUSTODYCD  VARCHAR2(50);
V_FEECODE    VARCHAR2(20);
V_FEECD      VARCHAR2(20);
V_REFCODE    VARCHAR2(20);
V_SUBTYPE    VARCHAR2(20);
V_CODEID     VARCHAR2(10);
V_SUBTYPE_NM VARCHAR2(1000);
V_STATUS     VARCHAR2(3);
V_SYMBOL     VARCHAR2(100);
v_sysvar    varchar2(10);
v_Result number(20,4);
BEGIN
V_GETCURRENT := GETCURRDATE;
V_REFCODE    := 'OTHER';
V_SUBTYPE    := '015';
plog.setbeginsection(pkgctx, 'pr_ApFeeWD');
--GET SUBTYPE NAME
BEGIN
    SELECT EN_CDCONTENT
    INTO V_SUBTYPE_NM
    FROM ALLCODE
    WHERE CDNAME = V_REFCODE AND CDVAL = V_SUBTYPE AND CDTYPE = 'SA';
    EXCEPTION WHEN OTHERS THEN V_SUBTYPE_NM := NULL;
END;
SELECT varvalue into v_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';
--==========================================================================
--THU PHI NHAP KHO (GD 1405), CHI TINH 1 LAN PHI NEU THUC HIEN NHIEU GD 1405

FOR rec IN
(
    SELECT DOC.*
    FROM (
            SELECT DISTINCT CUSTODYCD, CODEID, SYMBOL, 'OPN' STATUS
            FROM DOCSTRANSFER
            WHERE DELTD <> 'Y'
                  AND STATUS = 'CLS'
                  AND OPNTXDATE = v_getcurrent
            UNION ALL
            SELECT DISTINCT CUSTODYCD, CODEID, SYMBOL, 'CLS' STATUS
            FROM DOCSTRANSFER
            WHERE DELTD <> 'Y'
                  AND STATUS = 'CLS'
                  AND CLSTXDATE = v_getcurrent
            UNION
            SELECT DISTINCT CUSTODYCD, CODEID, SYMBOL, STATUS
            FROM DOCSTRANSFER
            WHERE DELTD <> 'Y'
                  AND STATUS = 'OPN'
                  AND OPNTXDATE = v_getcurrent
          ) DOC, CFMAST CF
      WHERE DOC.CUSTODYCD = CF.CUSTODYCD
            AND CF.SUPEBANK <> 'Y'
            --trung.luu: 08/06/2020 SHBVNEX-1073 Kh?ti?nh d?vo?i kha?ch ha`ng Bondagent = Yes
            and cf.bondagent <>'Y'
            --trung.luu: 08/06/2020 SHBVNEX-1158 b? t? ph?ho TK t? doanh
            and substr(CF.CUSTODYCD,0,4) <> v_sysvar
)
LOOP
    ---------LOOP_CASE: NEU NHAP KHO (OPN) THI LOOP 1 LAN INSERT VAO FEETRAN CHO NHAP KHO
    ---------LOOP_CASE: NEU RUT KHO (CLS) THI LOOP 2 LAN INSERT VAO FEETRAN CHO NHAP KHO VA RUT KHO (VI CA 2 GD XY TREN 1 DONG)
    V_CUSTODYCD := rec.CUSTODYCD;
    V_FEEAMT    := cspks_feecalc.fn_get_feeamt_without_tier(V_CUSTODYCD,V_REFCODE,V_SUBTYPE,V_TAXRATE,V_CCYCD,V_FEECODE,V_FEECD);
    --trung.luu:  21-09-2020  SHBVNEX-1569
        --V_TAXAMT    := ROUND((V_FEEAMT*V_TAXRATE)/100,4);
    IF v_feecd IS NOT NULL OR v_feecd <> '' THEN
        v_Result := cspks_feecalc.fn_tax_calc ( V_CUSTODYCD, V_FEEAMT,v_ccycd,v_feecd,4/*pv_round in number*/,V_TAXAMT,V_TAXRATE);
    END IF;
    --trung.luu:  21-09-2020  SHBVNEX-1569
    V_AUTOID    := SEQ_FEETRAN.NEXTVAL;
    V_CODEID    := rec.CODEID;
    V_STATUS    := rec.STATUS;
    V_SYMBOL    := rec.SYMBOL;
    
   
    --Ghi nhan phi rut nhap kho
    INSERT INTO FEETRAN (TXDATE,TXNUM,DELTD,FEECD,GLACCTNO,TXAMT,FEEAMT,FEERATE,VATRATE,VATAMT,AUTOID,TRDESC,CCYCD,ORDERID,TYPE,DEDUCTEDPLACE,STATUS,PAIDDATE,PSTATUS,SUBTYPE,FEETYPES,CUSTODYCD,PAUTOID,FEECODE)
    VALUES (
             TO_DATE(V_GETCURRENT,SYSTEMNUMS.C_DATE_FORMAT),--TXDATE -------DATE(7)
             'DOCSTRANSFER',--TXNUM -------VARCHAR2(20)
             'N',--DELTD -------VARCHAR2(2)
             V_FEECD,--FEECD -------VARCHAR2(5)
             NULL,--GLACCTNO -------VARCHAR2(30)
             0,--TXAMT -------NUMBER(22)
             V_FEEAMT,--FEEAMT -------NUMBER(22)
             0,--FEERATE -------NUMBER(22)
             V_TAXRATE,--VATRATE -------NUMBER(22)
             V_TAXAMT,--VATAMT -------NUMBER(22)
             V_AUTOID,--AUTOID -------NUMBER(22)
             V_SUBTYPE_NM||' dated '||TO_CHAR(V_GETCURRENT,'DD Mon RRRR')||' ('||V_SYMBOL||DECODE(V_STATUS,'OPN',' deposited)','CLS',' withdrawn)'),--TRDESC -------VARCHAR2(1000) --Sub-type name + "dated" + txdate;
             V_CCYCD,--CCYCD -------VARCHAR2(10)
             V_CODEID,--ORDERID -------VARCHAR2(20)
             'F',--TYPE -------VARCHAR2(10)
             NULL,--DEDUCTEDPLACE -------VARCHAR2(50)
             'N',--STATUS -------VARCHAR2(10)
             NULL,--PAIDDATE -------DATE(7)
             NULL,--PSTATUS -------VARCHAR2(200)
             V_SUBTYPE,--SUBTYPE -------VARCHAR2(200)
             V_REFCODE,--FEETYPES -------VARCHAR2(200)
             V_CUSTODYCD,--CUSTODYCD -------VARCHAR2(20)
             NULL ,--PAUTOID -------NUMBER(22)
             V_FEECODE--FEECODE -------VARCHAR2(10)
           );
           V_CUSTODYCD := NULL;
           V_FEEAMT    := 0;
           V_TAXRATE   := 0;
           V_CCYCD     := NULL;
           V_FEECODE   := NULL;
           V_FEECD     := NULL;
           V_AUTOID    := 0;
           V_CODEID    := NULL;
END LOOP;
--==========================================================================
p_err_code:=0;
plog.setendsection(pkgctx, 'pr_ApFeeWD');
EXCEPTION
WHEN OTHERS
THEN
  p_err_code := errnums.C_SYSTEM_ERROR;
  plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
  plog.setendsection (pkgctx, 'pr_ApFeeWD');
  RAISE errnums.E_SYSTEM_ERROR;
END pr_ApFeeWD;

PROCEDURE pr_SYN2FA(p_err_code  OUT varchar2)
  IS
    V_CURRDATE date;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_SYN2FA');
    V_CURRDATE := getcurrdate;
    /*insert into log_notify_cbfa(autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd)
          values
            (seq_log_notify_cbfa.nextval,'DDMAST','ACCTNO',null,null,null,V_CURRDATE,null);
    insert into log_notify_cbfa(autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd)
          values
            (seq_log_notify_cbfa.nextval,'SEMAST','ACCTNO',null,null,null,V_CURRDATE,null);*/
    insert into log_notify_cbfa(autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,busdate)
          values
            (seq_log_notify_cbfa.nextval,'DDSEMAST_BATCH','ACCTNO',null,null,null,V_CURRDATE,null,V_CURRDATE);
    insert into log_notify_cbfa(autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,busdate)
          values
            (seq_log_notify_cbfa.nextval,'CAALLOCATE_SWITH','AUTOID',null,null,null,V_CURRDATE,null,V_CURRDATE);
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_SYN2FA');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SYN2FA');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SYN2FA;

PROCEDURE pr_SASendSwift(p_bchmdl VARCHAR2, p_err_code  OUT varchar2)
IS
l_txmsg   tx.msg_rectype;
l_tltxcd  VARCHAR2(4) := '1713';
v_strCURRDATE VARCHAR2(10);
v_strDesc     VARCHAR2(1000);
v_strEN_Desc  VARCHAR2(1000);
l_err_param   VARCHAR2(2000);
BEGIN
  plog.setBeginSection(pkgctx, 'pr_SASendSwift');

    INSERT INTO TLLOGALL
    SELECT TLLOG.*
    FROM TLLOG, TLTX
    WHERE TLLOG.TLTXCD = TLTX.TLTXCD
    AND TLTX.BACKUP = 'Y'
    AND tllog.tltxcd = '1713'
    AND (TLLOG.TXSTATUS = '3' OR TLLOG.TXSTATUS = '1' OR TLLOG.TXSTATUS = '7' OR TLLOG.TXSTATUS = '4');

    COMMIT;

    INSERT INTO TLLOGFLDALL
    SELECT DTL.*
    FROM TLLOGFLD DTL, TLLOG, TLTX
    WHERE TLLOG.TLTXCD = TLTX.TLTXCD
    AND TLTX.BACKUP = 'Y'
    AND TLLOG.TXNUM = DTL.TXNUM
    AND TLLOG.TXDATE = DTL.TXDATE
    and tllog.tltxcd = '1713'
    AND (TLLOG.TXSTATUS = '3' OR TLLOG.TXSTATUS = '1' OR TLLOG.TXSTATUS = '7' OR TLLOG.TXSTATUS = '4');

    COMMIT;

    DELETE FROM TLLOGFLD FLD WHERE TXNUM  IN (SELECT TXNUM FROM TLLOG WHERE TLLOG.TLTXCD = '1713');
    DELETE FROM TLLOG WHERE TLLOG.TLTXCD = '1713' ;

    COMMIT;


    v_strCURRDATE := cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE');
    p_err_code := systemnums.C_SUCCESS;

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM TLTX WHERE TLTXCD = l_tltxcd;

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate      := to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd      := l_tltxcd;
    l_txmsg.brid        := systemnums.C_BATCH_BRID;
    plog.debug(pkgctx, 'Begin loop');

  FOR rec IN (
        SELECT CF.*, TRF.VSDMT, TRF.EN_DESCRIPTION MTDESC,
               (CASE WHEN NVL(CF.MT535NU,'N') = 'Y' AND TRF.TRFCODE = '535.STMT.HOLD' THEN '535.STMT.HOLD.NU'
                     WHEN NVL(CF.MT535NU,'N') = 'N' AND TRF.TRFCODE = '535.STMT.HOLD' THEN '535.STMT.HOLD'
                     ELSE TRF.TRFCODE END) TRFCODE
        FROM CFMAST CF, VSDTRFCODE TRF
        WHERE CF.STATUS = 'A'
        AND CF.SWIFTCODE IS NOT NULL
        AND CF.SENDSWIFT = 'Y'
        AND TRF.TLTXCD = '1713'
        AND TRF.TRFCODE IN ('940.CST.STMT.MSG', '950.STMT.MSG', '535.STMT.HOLD')
        AND (CUSTODYCD, VSDMT) NOT IN (
            SELECT CFCUSTODYCD, MSGAMT
            FROM TLLOG
            WHERE TLTXCD = L_TLTXCD
            AND TXSTATUS = TXSTATUSNUMS.C_TXCOMPLETED
            AND TLID = SYSTEMNUMS.C_SYSTEM_USERID
            AND TXDATE =  TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT)
        )
        ORDER BY CF.CUSTODYCD, TRF.VSDMT
    ) LOOP

    SELECT systemnums.C_HT_PREFIXED
        || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
    INTO l_txmsg.txnum
    FROM DUAL;

    --88    CUSTODYCD
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE     := rec.custodycd;

    --06    MTTYPE
    l_txmsg.txfields ('06').defname   := 'MTTYPE';
    l_txmsg.txfields ('06').TYPE      := 'C';
    l_txmsg.txfields ('06').VALUE     := rec.trfcode;

    --07    VSDMT
    l_txmsg.txfields ('07').defname   := 'MTTYPE';
    l_txmsg.txfields ('07').TYPE      := 'C';
    l_txmsg.txfields ('07').VALUE     := rec.vsdmt;

    --20    DATE
    l_txmsg.txfields ('20').defname   := 'DATE';
    l_txmsg.txfields ('20').TYPE      := 'C';
    l_txmsg.txfields ('20').VALUE     := v_strCURRDATE;

    --30    DESC
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := v_strEN_Desc || '/' || rec.mtdesc;

    BEGIN
        IF txpks_#1713.fn_batchtxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param) <> systemnums.c_success
        THEN
           plog.error (pkgctx, 'got error 1713: ' || p_err_code);
           ROLLBACK;
           plog.setEndSection (pkgctx, 'pr_AutoCallCompleteCA');
           RAISE errnums.E_SYSTEM_ERROR;
        END IF;
    END;

  END LOOP;
  plog.setEndSection(pkgctx, 'pr_SASendSwift');
EXCEPTION
  when OTHERS THEN
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'pr_SASendSwift');
    RAISE errnums.E_SYSTEM_ERROR;
END;


    PROCEDURE PR_SABACKUPDATASTP(P_ERR_CODE  OUT VARCHAR2)
    IS

    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PR_SABACKUPDATASTP');
        INSERT INTO   VSD_CSVCONTENT_LOGHIST  SELECT * FROM VSD_CSVCONTENT_LOG;
        DELETE FROM  VSD_CSVCONTENT_LOG;

        --INSERT INTO   VSD_MT508_INF_HIST  SELECT * FROM VSD_MT508_INF;
        --DELETE FROM VSD_MT508_INF;

        --INSERT INTO   VSD_MT564_INF_HIST  SELECT * FROM VSD_MT564_INF WHERE MSGSTATUS <> 'P';
        --DELETE FROM VSD_MT564_INF WHERE MSGSTATUS <> 'P';

        --INSERT INTO   VSD_MT598_INF_HIST  SELECT * FROM VSD_MT598_INF;
        --DELETE FROM VSD_MT598_INF;

        INSERT INTO VSD_PROCESS_LOGHIST  SELECT * FROM VSD_PROCESS_LOG;
        DELETE FROM VSD_PROCESS_LOG;

        INSERT INTO VSDMSGLOG_HIST  SELECT * FROM VSDMSGLOG;
        DELETE FROM VSDMSGLOG;

        INSERT INTO VSDTXREQHIST
        SELECT * FROM VSDTXREQ WHERE MSGSTATUS NOT IN('P','S','A') AND BANKCODE = 'VSD';

        DELETE FROM VSDTXREQ WHERE MSGSTATUS NOT IN('P','S','A') AND BANKCODE = 'VSD';

        INSERT INTO VSDTXREQDTLHIST  SELECT * FROM VSDTXREQDTL
        WHERE REQID NOT IN (
            SELECT REQID FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A') AND BANKCODE = 'VSD'
        );

        DELETE FROM VSDTXREQDTL
            WHERE REQID NOT IN (
            SELECT REQID FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A') AND BANKCODE = 'VSD'
        );

        INSERT INTO VSDTRFLOGHIST
        SELECT * FROM VSDTRFLOG
        WHERE STATUS NOT IN ('P','A')
        AND NVL(REFERENCEID,'----') NOT IN (SELECT TO_CHAR(REQID) FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A') AND BANKCODE = 'VSD');

        DELETE FROM VSDTRFLOG
        WHERE STATUS NOT IN ('P','A')
        AND NVL(REFERENCEID,'----') NOT IN (SELECT TO_CHAR(REQID) FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A') AND BANKCODE = 'VSD');

        INSERT INTO VSDTRFLOGDTLHIST
        SELECT * FROM VSDTRFLOGDTL
        WHERE REFAUTOID NOT IN (
            SELECT AUTOID FROM VSDTRFLOG
            WHERE STATUS  IN ('P','A')
            OR NVL(REFERENCEID,'----') IN (SELECT TO_CHAR(REQID) FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A') AND BANKCODE = 'VSD')
        );

        DELETE FROM VSDTRFLOGDTL
        WHERE REFAUTOID NOT IN (
            SELECT AUTOID FROM VSDTRFLOG
            WHERE STATUS IN ('P','A')
            OR NVL(REFERENCEID,'----') IN (SELECT TO_CHAR(REQID) FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A') AND BANKCODE = 'VSD')
        );

        INSERT INTO VSD_PARCONTENT_LOG_HIST SELECT * FROM VSD_PARCONTENT_LOG;
        DELETE FROM VSD_PARCONTENT_LOG;

        INSERT INTO VSDMSGFROMFLEX_HIST SELECT * FROM VSDMSGFROMFLEX;
        DELETE FROM VSDMSGFROMFLEX;

        INSERT INTO REPORTMTLOG_HIST SELECT * FROM REPORTMTLOG;
        DELETE FROM REPORTMTLOG;

        P_ERR_CODE := 0;
        PLOG.SETENDSECTION(PKGCTX, 'PR_SABACKUPDATASTP');

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        
        PLOG.SETENDSECTION (PKGCTX, 'PR_SABACKUPDATASTP');
        RAISE ERRNUMS.E_SYSTEM_ERROR;
    END PR_SABACKUPDATASTP;

BEGIN
  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;

  pkgctx := plog.init('TXPKS_BATCH',
                      plevel => logrow.loglevel,
                      plogtable => (logrow.log4table = 'Y'),
                      palert => (logrow.log4alert = 'Y'),
                      ptrace => (logrow.log4trace = 'Y'));
END TXPKS_BATCH;
/
