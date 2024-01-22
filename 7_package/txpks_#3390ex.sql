SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3390ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3390EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      01/10/2014     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_#3390ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_symbol_org       CONSTANT CHAR(2) := '71';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_taskcd           CONSTANT CHAR(2) := '08';
   c_codeid           CONSTANT CHAR(2) := '22';
   c_reportdate       CONSTANT CHAR(2) := '06';
   c_begindate        CONSTANT CHAR(2) := '02';
   c_duedate          CONSTANT CHAR(2) := '09';
   c_frdatetransfer   CONSTANT CHAR(2) := '18';
   c_todatetransfer   CONSTANT CHAR(2) := '15';
   c_actiondate       CONSTANT CHAR(2) := '21';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_canceldate       CONSTANT CHAR(2) := '26';
   c_receivedate      CONSTANT CHAR(2) := '27';
   c_exerate          CONSTANT CHAR(2) := '24';
   c_trade            CONSTANT CHAR(2) := '23';
   c_rate             CONSTANT CHAR(2) := '10';
   c_devidentvalue    CONSTANT CHAR(2) := '19';
   c_rightoffrate     CONSTANT CHAR(2) := '17';
   c_tvprice          CONSTANT CHAR(2) := '16';
   c_roprice          CONSTANT CHAR(2) := '14';
   c_status           CONSTANT CHAR(2) := '20';
   c_pitratemethod    CONSTANT CHAR(2) := '12';
   c_pitrate          CONSTANT CHAR(2) := '11';
   c_pitratese        CONSTANT CHAR(2) := '25';
   c_contents         CONSTANT CHAR(2) := '13';
   c_ischangestt      CONSTANT CHAR(2) := '80';
   c_desc             CONSTANT CHAR(2) := '30';
   c_trffee           CONSTANT CHAR(2) := '40';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   if c_catype in ('10','15','16') then
       p_err_code := '-300023'; -- 'chi thay doi TTNCN khi loai quyen la chia co tuc bang tien
       plog.setendsection (pkgctx, 'fn_txPreAppCheck');
       RETURN errnums.C_BIZ_RULE_INVALID;
   end if;
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

 l_strPITRATE number(20,4);
    l_strSTCRATE number(20,4);
    l_strPITRATEMETHOD VARCHAR2(10);
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/

    l_strPITRATE := to_number(p_txmsg.txfields('11').value);
    l_strSTCRATE := to_number(p_txmsg.txfields('25').value);
    l_strPITRATEMETHOD := p_txmsg.txfields('12').value;
    If (l_strPITRATE < 0 Or l_strPITRATE > 100) Then
        p_err_code := '-300032'; -- 'Muc thue nam trong 0 den 100
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    End If;

    If ((UPPER(l_strPITRATEMETHOD) = 'NO') And (l_strPITRATE <> 0 OR l_strSTCRATE <> 0)) Then
        p_err_code := '-300033'; -- 'chi thay doi TTNCN khi loai quyen la chia co tuc bang tien
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    End If;

   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

    l_Total_Transfer_Amt    NUMBER(25);
    l_Total_FeeUpdate       NUMBER(25);
    l_FeeRate               NUMBER(20,8);
    l_FeeAmt                NUMBER(20);
    l_FeeUpdate             NUMBER(20);
    l_camastid              VARCHAR2(20);
    l_Count                 Number;
    l_UpdCount              Number;
    l_Autoid_camastdtl      number;
    l_EXECRATE              number(20,4);
    l_TotalEXECRATE              number(20,4);
    l_CATYPE                VARCHAR2(10);
    l_canceldate            date;
    l_receivedate           date;

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    l_camastid  :=  p_txmsg.txfields('03').value;
    -- Tong so so tien phi
    l_FeeAmt    := to_number(p_txmsg.txfields('40').value);
    l_EXECRATE  := p_txmsg.txfields('38').value;
    l_CATYPE    := p_txmsg.txfields('05').value;
    l_UpdCount  := 1;
    l_canceldate := p_txmsg.txfields('26').value;
    l_receivedate   := p_txmsg.txfields('27').value;
    
    

    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction

        ---locpt 20141113----cap nhat trang thai cua caschd----------
        update caschd set status ='I' where camastid = l_camastid and status ='S';
        ---end locpt 20141112----------------------------------------

        If l_CATYPE = '010' Then
            Begin
                -- Revert lai phi chuyen khoan chung khoan --> CAMAST
                For rec in (
                    Select feeamt, camastid from camastdtl WHERE camastid = l_camastid and status ='P' and deltd <> 'Y'
                )Loop
                    Update camast SET trffeeamt = trffeeamt - REC.feeamt WHERE camastid = l_camastid;
                End Loop;

                -- Revert lai phi chuyen khoan chung khoan --> CAMAST
                For rec in (
                    Select * from caschddtl WHERE camastid = l_camastid and status ='P' and deltd <> 'Y'
                )Loop
                    Update caschd
                        set trffee = trffee - rec.feeamt
                    where camastid = l_camastid
                          and autoid =rec.autoid_caschd
                          and afacctno = rec.afacctno
                          and deltd <> 'Y'; --31/12/2015 Them deltd <> Y
                End Loop;
            End;

            -- Neu chua phan bo --> xoa di
            UPDATE camastdtl SET DELTD ='Y', status='D' WHERE camastid = l_camastid and status ='P';
            UPDATE caschddtl SET DELTD ='Y', status='D' WHERE camastid = l_camastid and status ='P';

            --TruongLD Add
            l_autoid_camastdtl := seq_camastdtl.nextval;
            INSERT into camastdtl(autoid, txnum, txdate, camastid, typerate, devidentrate, devidentvalue, execrate, feeamt, STATUS, deltd, lastdate)
            select l_autoid_camastdtl, p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), l_camastid, p_txmsg.txfields('33').value,
                   p_txmsg.txfields('36').value, p_txmsg.txfields('37').value, l_EXECRATE, l_FeeAmt,'P', 'N', sysdate
            From dual;

            INSERT into caschddtl(autoid, autoid_caschd, autoid_camastdtl, afacctno, camastid, amt, aamt, feeamt, STATUS, deltd, lastdate)
            Select seq_caschddtl.nextval, ca.autoid, l_autoid_camastdtl, ca.afacctno, l_camastid,
                    round(ca.amt * l_EXECRATE/100) amt, 0 aamt, 0 feeamt,'P', 'N', sysdate
            from caschd ca
            where CA.camastid = l_camastid and ca.deltd = 'N';

            -- Cap nhat lai ty le phan bo --> camast
            Begin
                Select Sum(execrate) into l_TotalEXECRATE From camastdtl where camastid = l_camastid and DELTD <> 'Y' and status <> 'D';
            EXCEPTION
            WHEN OTHERS
               THEN l_TotalEXECRATE := 0;
            End;

            Update camast set EXERATE = GREATEST(100 - l_TotalEXECRATE,0) where camastid = l_camastid;

            -- Neu khong nhap phi CK --> thoat luon
            If l_FeeAmt = 0 then
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN systemnums.C_SUCCESS;
            End If;

            Begin
                select Sum(Amt) AMT, Count(*) Cnt into l_Total_Transfer_Amt, l_Count
                from caschddtl
                where STATUS ='P' AND camastid = l_camastid and deltd <> 'Y';
            EXCEPTION
            WHEN OTHERS
               THEN
                    l_Count := 1;
                    l_Total_Transfer_Amt := 0;
            END;

            If l_Total_Transfer_Amt > 0 then
                l_FeeRate := Round(To_Number(l_FeeAmt/l_Total_Transfer_Amt),10);
            End If;

            
            

            Begin
                For rec in
                (
                    --Select * From caschd where camastid = l_camastid ORDER BY Amt asc
                    Select * From caschddtl where camastid = l_camastid and status ='P' and deltd <> 'Y' ORDER BY Amt asc
                )
                Loop

                    If l_Count > l_UpdCount Then
                        l_FeeUpdate := Round(rec.amt * l_FeeRate,0);
                    Else
                        l_FeeUpdate := l_FeeAmt;
                    End If;

                    l_FeeUpdate := LEAST(l_FeeUpdate, l_FeeAmt);
                    l_FeeAmt    := GREATEST(l_FeeAmt - l_FeeUpdate,0);


                    INSERT INTO CATRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0063',
                                    l_FeeUpdate,'C',p_txmsg.deltd, rec.autoid ,seq_CATRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
                    UPDATE CASCHD
                        SET TRFFEE = TRFFEE + l_FeeUpdate
                    where autoid = rec.autoid_caschd and AFACCTNO= rec.AFACCTNO and camastid = l_camastid and deltd <> 'Y'; --31/12/2015 Them deltd <> Y

                    -- Log thong tin phi chuyen khoan chi tiet cho tung dot phan bo
                    Update caschddtl
                        set feeamt = feeamt + l_FeeUpdate
                    where autoid = rec.autoid and AFACCTNO= rec.AFACCTNO and autoid_camastdtl = rec.autoid_camastdtl;

                    l_UpdCount := l_UpdCount + 1;

                End Loop;
            End;

            --End TruongLD
        End If;
        --Update CancelDate ReceiveDate => Type 020
        select count(*) into l_Count from camast where camastid=l_camastid ;
        If ( l_Count <> 0) then
            
           Update camast
           set canceldate = l_canceldate,
           receivedate =l_receivedate
           Where camastid=l_camastid;
        End if;
        If l_CATYPE <> '010' Then
            -- Neu khong nhap phi CK --> thoat luon
            If l_FeeAmt = 0 then
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN systemnums.C_SUCCESS;
            End If;

            Begin
                select Sum(Amt) AMT, Count(*) Cnt into l_Total_Transfer_Amt, l_Count
                from caschd
                where camastid = l_camastid and deltd <> 'Y';
            EXCEPTION
            WHEN OTHERS
               THEN
                    l_Count := 1;
                    l_Total_Transfer_Amt := 0;
            END;

            If l_Total_Transfer_Amt > 0 then
                l_FeeRate := Round(To_Number(l_FeeAmt/l_Total_Transfer_Amt),10);
            End If;

            Begin
                For rec in
                (
                    Select * From caschd
                    where camastid = l_camastid and deltd <> 'Y' --31/12/2015 Them deltd <> Y
                    ORDER BY Amt asc
                )
                Loop

                    If l_Count > l_UpdCount Then
                        l_FeeUpdate := Round(rec.amt * l_FeeRate,0);
                    Else
                        l_FeeUpdate := l_FeeAmt;
                    End If;

                    l_FeeUpdate := LEAST(l_FeeUpdate, l_FeeAmt);
                    l_FeeAmt    := GREATEST(l_FeeAmt - l_FeeUpdate,0);


                    INSERT INTO CATRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0063',
                                    l_FeeUpdate,'C',p_txmsg.deltd, rec.autoid ,seq_CATRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
                    UPDATE CASCHD
                        SET TRFFEE = TRFFEE + l_FeeUpdate
                    where autoid = rec.autoid and camastid = l_camastid and deltd <> 'Y'; --31/12/2015 Them deltd <> Y

                    l_UpdCount := l_UpdCount + 1;

                End Loop;
            End;

        End If;

    Else  -- Xu ly truong hop xoa GD
        Update camastdtl set deltd ='Y' where txnum = p_txmsg.txnum and txdate= TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);
        update catran set deltd ='Y' where txnum = p_txmsg.txnum and txdate= TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);

        Begin
            for rec_trf in
            (
                select acctno camastid, namt, ref, dtl.autoid autoid_camastdtl
                from catran tr, camastdtl dtl
                where tr.txnum = p_txmsg.txnum
                      and tr.txdate = TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT)
                      and dtl.txnum = p_txmsg.txnum
                      and dtl.txdate = TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT)
                      and tr.acctno = dtl.camastid
            )Loop
                update caschd
                    set trffee = trffee - rec_trf.namt, status ='S'
                where camastid = rec_trf.camastid and autoid = rec_trf.ref and deltd <> 'Y'; --31/12/2015 Them deltd <> Y

                Update caschddtl
                    set deltd ='Y'
                Where camastid = rec_trf.camastid  -- Ma su kien
                      and autoid_camastdtl = rec_trf.autoid_camastdtl
                      and autoid_caschd = rec_trf.ref; -- AutoID CASCHD
            End Loop;
        End;
    End If;

    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#3390EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3390EX;
/
