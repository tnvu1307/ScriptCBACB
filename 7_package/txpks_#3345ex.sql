SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3345ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3345EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      21/02/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3345ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_iscancel         CONSTANT CHAR(2) := '10';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_codeid           CONSTANT CHAR(2) := '06';
   c_symbol_org       CONSTANT CHAR(2) := '71';
   c_catype           CONSTANT CHAR(2) := '05';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_converted        CONSTANT CHAR(2) := '09';
   c_qtty             CONSTANT CHAR(2) := '08';
   c_cashamt          CONSTANT CHAR(2) := '12';
   c_contents         CONSTANT CHAR(2) := '13';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_status varchar2(1);
l_catype varchar2(4);
V_COUNT NUMBER;
V_ISCANCEL varchar2(20);
V_CAMASTID varchar2(20);
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    if p_txmsg.deltd<>'Y' then
        SELECT STATUS, catype INTO l_STATUS, l_catype
        FROM CAMAST
        WHERE CAMASTID = p_txmsg.txfields('03').value;
        -- 18/05/2015 TruongLD them su kien :027 giai the to chuc phat hanh
        if l_catype in ('023','020','017','027') then
            IF NOT(INSTR('IGH',l_STATUS) > 0) THEN
                p_err_code := '-300013';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        else
            IF NOT(INSTR('IGH',l_STATUS) > 0) THEN
                p_err_code := '-300013';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        end if;

        V_ISCANCEL := P_TXMSG.TXFIELDS ('10').VALUE;
        V_CAMASTID := P_TXMSG.TXFIELDS('03').VALUE;

        SELECT COUNT(1) INTO V_COUNT
        FROM (
            SELECT DT.AUTOID, DT.BALANCE, DT.CAMASTID, DT.AFACCTNO, DT.CATYPE, DT.CODEID, DT.EXCODEID, DT.SYMBOL, DT.PITRATE, DT.TOCODEID, DT.STATUS,
                   DT.SEACCTNO, DT.EXSEACCTNO, DT.PARVALUE, DT.EXPARVALUE, DT.REPORTDATE, DT.ACTIONDATE, DT.POSTINGDATE, DT.DESCRIPTION,
                   DT.TASKCD, DT.DUTYAMT, DT.FULLNAME, DT.IDCODE, DT.CUSTODYCD, DT.PRICEACCOUNTING, DT.CATYPEVALUE, DT.COSTPRICE, DT.ISCDCROUTAMT,
                   DT.AMT, DT.AAMT, DT.QTTY,
                   (CASE WHEN CA.FORMOFPAYMENT = '001' THEN NVL(TR.QTTY,0) ELSE DT.AQTTY END) AQTTY
            FROM (
                SELECT AUTOID, BALANCE, REPLACE(CAMASTID,'.','') CAMASTID, AFACCTNO, CATYPE, CODEID, EXCODEID,
                    (CASE WHEN CATYPEVALUE IN ('023','020','017') THEN (CASE WHEN V_ISCANCEL = 'N' THEN QTTY ELSE 0 END) ELSE QTTY END) QTTY,
                    (CASE WHEN CATYPEVALUE IN ('023','020','017') THEN (CASE WHEN V_ISCANCEL = 'N' THEN AMT ELSE 0 END) ELSE AMT END) AMT,
                    (CASE WHEN CATYPEVALUE IN ('023','020','017') THEN (CASE WHEN V_ISCANCEL = 'Y' THEN AQTTY ELSE 0 END) ELSE AQTTY END) AQTTY,
                    (CASE WHEN CATYPEVALUE IN ('023','020','017') THEN (CASE WHEN V_ISCANCEL = 'Y' THEN AAMT ELSE 0 END) ELSE AAMT END) AAMT,
                    SYMBOL, PITRATE, TOCODEID, STATUS, SEACCTNO, EXSEACCTNO, PARVALUE,
                    EXPARVALUE, REPORTDATE, ACTIONDATE, POSTINGDATE, DESCRIPTION, TASKCD, DUTYAMT,
                    FULLNAME, IDCODE, CUSTODYCD, PRICEACCOUNTING, CATYPEVALUE,COSTPRICE,ISCDCROUTAMT
                FROM V_CA3351
                WHERE REPLACE(CAMASTID,'.','') = V_CAMASTID
                AND (CASE WHEN CATYPEVALUE IN ('023','020','017') THEN 'N' ELSE ISSE END) <> 'Y'

                UNION ALL

                SELECT AUTOID, BALANCE, REPLACE(CAMASTID,'.','') CAMASTID, AFACCTNO, CATYPE, CODEID, EXCODEID,
                    (CASE WHEN CATYPEVALUE IN ('16','33') THEN (CASE WHEN 'N' = 'N' THEN QTTY ELSE 0 END) ELSE QTTY END) QTTY,
                    (CASE WHEN CATYPEVALUE IN ('16','33') THEN (CASE WHEN 'N' = 'N' THEN AMT ELSE 0 END) ELSE AMT END) AMT,
                    (CASE WHEN CATYPEVALUE IN ('16','33') THEN (CASE WHEN 'N' = 'Y' THEN AQTTY ELSE 0 END) ELSE AQTTY END) AQTTY,
                    (CASE WHEN CATYPEVALUE IN ('16','33') THEN (CASE WHEN 'N' = 'Y' THEN AAMT ELSE 0 END) ELSE AAMT END) AAMT,
                    SYMBOL, PITRATE, TOCODEID, STATUS, SEACCTNO, EXSEACCTNO, PARVALUE,
                    EXPARVALUE, REPORTDATE, ACTIONDATE, POSTINGDATE, DESCRIPTION, TASKCD, DUTYAMT,
                    FULLNAME, IDCODE, CUSTODYCD, PRICEACCOUNTING, CATYPEVALUE,COSTPRICE,ISCDCROUTAMT
                FROM (
                    SELECT CA.AUTOID, CA.BALANCE, SUBSTR(CA.CAMASTID,1,4) || '.' || SUBSTR(CA.CAMASTID,5,6) || '.' || SUBSTR(CA.CAMASTID,11,6) CAMASTID, CA.AFACCTNO,A0.CDCONTENT CATYPE, TOSYM.CODEID, CA.EXCODEID, CA.QTTY, ROUND(CA.AMT) AMT,
                        ROUND(CASE WHEN CAMAST.CATYPE IN ('016','033') THEN NVL(SE.TRADE,0) ELSE 0 END ) AQTTY, ROUND(CA.DFQTTY) DFQTTY,
                        ROUND(CA.AAMT) AAMT, TOSYM.SYMBOL,ISWFT,PITRATESE PITRATE,CASE WHEN NVL(CAMAST.ISWFT,'N')='Y' THEN (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID=NVL(CAMAST.TOCODEID,CAMAST.CODEID))  ELSE TOCODEID END TOCODEID , A1.CDCONTENT STATUS,
                        CA.AFACCTNO ||(CASE WHEN CAMAST.ISWFT='Y' THEN (CASE WHEN NVL(CAMAST.TOCODEID,'A') = 'A' THEN (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYM.CODEID) ELSE  (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYMTO.CODEID) END  )
                        ELSE (CASE WHEN NVL(CAMAST.TOCODEID,'A') = 'A' THEN CAMAST.CODEID ELSE CAMAST.TOCODEID END ) END)  SEACCTNO,CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END) EXSEACCTNO,
                        SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE, CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE ,CAMAST.ACTIONDATE  POSTINGDATE,
                        CAMAST.DESCRIPTION, CAMAST.TASKCD,
                        (CASE WHEN CF.VAT='Y' THEN SYS.VARVALUE*CA.AMT/100 ELSE 0 END) DUTYAMT, CF.FULLNAME, CF.IDCODE, CF.CUSTODYCD
                        ,DECODE(PRICEACCOUNTING,0,EXSYM.PARVALUE,PRICEACCOUNTING) PRICEACCOUNTING, A0.CDVAL CATYPEVALUE,
                        (CASE WHEN CAMAST.CATYPE IN ('016','033') THEN (SELECT ROUND( COSTPRICE * ROUND(CA.AQTTY)/ GREATEST(CA.QTTY,1),4)   FROM SEMAST WHERE ACCTNO= (CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END)))
                        ELSE 0 END)  COSTPRICE, (CASE WHEN  CAMAST.CATYPE IN ('016','033') THEN 1 ELSE 0 END ) ISCDCROUTAMT,
                        CA.ISSE, CAMAST.ISINCODE
                    FROM CASCHD CA, SBSECURITIES SYM, SBSECURITIES SYMTO, SBSECURITIES EXSYM, ALLCODE A0, ALLCODE A1, CAMAST, AFMAST AF , CFMAST CF , AFTYPE TYP, SYSVAR SYS, SEMAST SE, SBSECURITIES TOSYM
                    WHERE A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAMAST.CATYPE
                    AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
                    AND CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID=SYM.CODEID AND SYMTO.CODEID=(CASE WHEN NVL(CAMAST.TOCODEID,'A') <> 'A' THEN CAMAST.TOCODEID ELSE CAMAST.CODEID END)
                    AND CA.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
                    AND CA.DELTD ='N' AND CA.STATUS IN ('S','G','H','J','I') AND CAMAST.STATUS IN ('S','I','G','H','J')
                    AND (CA.TRADE > 0 )
                    AND AF.ACTYPE = TYP.ACTYPE AND SYS.GRNAME='SYSTEM' AND SYS.VARNAME='CADUTY'
                    AND EXSYM.CODEID = (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END)
                    AND CA.AFACCTNO||CA.CODEID=SE.ACCTNO(+)
                    AND NVL(CAMAST.TOCODEID,CAMAST.CODEID)=TOSYM.CODEID
                )
                WHERE REPLACE(CAMASTID,'.','') = V_CAMASTID
                AND (CASE WHEN CATYPEVALUE IN ('16','33') THEN 'N' ELSE ISSE END) <> 'Y'
                AND CATYPEVALUE IN ('016','033')
            ) DT
            JOIN CAMAST CA ON DT.CAMASTID = CA.CAMASTID
            LEFT JOIN (
                SELECT CS.AUTOID, TRUNC(NVL(TO_NUMBER(SUBSTR(CA.EXRATE,0,INSTR(CA.EXRATE,'/') - 1)),'1') / NVL(TO_NUMBER(SUBSTR(CA.EXRATE,INSTR(CA.EXRATE,'/') + 1,LENGTH(CA.EXRATE))),1) * TR.QTTY,CA.CIROUNDTYPE) QTTY
                FROM CASCHD CS, CAMAST CA,
                (
                    SELECT ACCTNO AUTOID, SUM(NAMT) QTTY FROM (
                        SELECT * FROM CATRAN
                        UNION ALL
                        SELECT * FROM CATRANA
                    ) TRAN
                    WHERE TRAN.TLTXCD = '3327' AND TRAN.DELTD <> 'Y' AND TRAN.TXCD = '0058'
                    GROUP BY TRAN.ACCTNO
                ) TR
                WHERE CS.AUTOID = TR.AUTOID
                AND CS.CAMASTID = CA.CAMASTID
            ) TR ON DT.AUTOID = TR.AUTOID
        ) TMP, SEMAST SE
        WHERE TMP.EXSEACCTNO = SE.ACCTNO
        AND TMP.AQTTY > SE.TRADE;

        IF V_COUNT > 0 THEN
            p_err_code := '-300008';
            plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

    end if;
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
    l_err_param varchar2(500);
    v_countCI number;
    v_countSE number;
    l_count NUMBER;
    l_catype VARCHAR2(3);
    l_codeid VARCHAR2(6);
    l_data_source varchar2(4000);
    l_countmail number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    SELECT ca.catype,
           ca.codeid
    INTO l_Catype ,l_codeid from camast ca
    WHERE camastid = p_txmsg.txfields('03').value;
    if p_txmsg.deltd<>'Y' then

        cspks_caproc.pr_3351_Exec_Sec_CA(p_txmsg,p_err_code);

        if p_err_code <> systemnums.C_SUCCESS THEN
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        if p_txmsg.txfields('10').value = 'Y' then
            update CAMAST set camast.cancelstatus = p_txmsg.txfields('10').value
            where CAMASTID=p_txmsg.txfields('03').value;
        end if;

        SELECT count(1) into v_countCI FROM CASCHD
        WHERE  CAMASTID=p_txmsg.txfields('03').value  AND DELTD ='N' AND amt > 0 AND ISCI='N' AND isexec='Y';

        SELECT count(1) into v_countSE FROM CASCHD
        WHERE  CAMASTID=p_txmsg.txfields('03').value  AND DELTD ='N' AND qtty> 0 AND ISSE='N' AND isexec='Y';

        if(v_countCI = 0 AND v_countSE = 0) THEN
            UPDATE CAMAST SET STATUS = (case when instr(cspks_caproc.c_convert_catype,l_catype) > 0 and cancelstatus ='Y' then 'J'
                                             when instr(cspks_caproc.c_convert_catype,l_catype) > 0 and cancelstatus ='N' then 'H'
                                            else 'J' end)
            WHERE CAMASTID=p_txmsg.txfields('03').value;
        Elsif (v_countCI > 0 AND v_countSE = 0) THEN
            UPDATE CAMAST SET STATUS ='H'
            WHERE CAMASTID=p_txmsg.txfields('03').value;
        END IF;

         IF(L_CATYPE  in ('027')) THEN
             FOR rec IN (SELECT se.acctno,se.trade
                         FROM semast se
                         WHERE codeid= l_codeid AND trade >0
                         AND afacctno NOT IN
                               (SELECT afacctno from caschd WHERE deltd='N' AND camastid=p_txmsg.txfields('03').value)
                         )
             LOOP
                SELECT COUNT(1)
                    into l_count
                FROM SEMAST
                WHERE mortage + standing + blocked + emkqtty > 0
                    AND ACCTNO = REC.ACCTNO;

                  if l_count >0 then
                          p_err_code := '-300007'; -- Pre-defined in DEFERROR table
                          plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                          RETURN errnums.C_BIZ_RULE_INVALID;
                  end if;
               INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
               VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.acctno,'0011',rec.trade,NULL,p_txmsg.txfields ('03').value,p_txmsg.deltd,NULL,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

               UPDATE semast SET trade=0 WHERE acctno=rec.acctno;

             END LOOP;
         END IF;

    --Send mail
    -- ThoaiTran 12/09/2019
    -----------------------------------SEND MAIL---------------------------------------------

    select count(*) into l_countmail
    from camast ca,caschd cas
        where ca.camastid=cas.camastid and ca.camastid like p_txmsg.txfields('03').value and ca.catype not in ('010','015','027','005','028','022','003','029','031','032','006','023');
    if l_countmail <> 0
        then
            sendmailall(p_txmsg.txfields('03').value,'3345');
    end if;

    ----------------------------------------------------------------------------------------
    END IF;
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
         plog.init ('TXPKS_#3345EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3345EX;
/
