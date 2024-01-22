SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1403ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1403EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/05/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1403ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_id               CONSTANT CHAR(2) := '02';
   c_type             CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '09';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_setqtty          CONSTANT CHAR(2) := '55';
   c_qtty             CONSTANT CHAR(2) := '13';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

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
    V_NETTING           NUMBER;
    V_ACCTNO            VARCHAR2(30);
    V_CRQTTY            NUMBER;
    V_APQTTY            NUMBER;
    V_WAPQTTY        NUMBER;
    V_WCRQTTY        NUMBER;
    V_TLTXCD            VARCHAR2(4);
    V_APPENDIX          NUMBER;
    V_CRPHYSAGREEID     VARCHAR2(10);
    V_REF_CRPHYSAGREEID VARCHAR2(30);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        --
        V_TLTXCD        := p_txmsg.txfields(c_type).value;--1400: PHU LUC - 1407: HOP DONG
        V_APPENDIX      := TO_NUMBER(p_txmsg.txfields(c_id).value);
        V_CRPHYSAGREEID := p_txmsg.txfields(c_id).value;
        --LAY MA HOP DONG VA SO LUONG TREN PHU LUC
        BEGIN
             SELECT AP.CRPHYSAGREEID, AP.AQTTY
             INTO V_REF_CRPHYSAGREEID, V_APQTTY
             FROM APPENDIX AP
             WHERE AP.AUTOID = V_APPENDIX;
             EXCEPTION WHEN OTHERS THEN V_REF_CRPHYSAGREEID := NULL;
                                        V_APQTTY := 0;
        END;
        --LAY TK BAN VA SO LUONG TREN HOP DONG
        BEGIN
             SELECT CR.ACCTNO||CR.CODEID, CR.QTTY
             INTO V_ACCTNO, V_CRQTTY
             FROM CRPHYSAGREE CR
             WHERE CR.CRPHYSAGREEID = DECODE(V_TLTXCD,'1400',V_REF_CRPHYSAGREEID,'1407',V_CRPHYSAGREEID,NULL);
             EXCEPTION WHEN OTHERS THEN V_ACCTNO := NULL;
                                        V_CRQTTY := 0;
        END;
        --
        BEGIN
             SELECT SE.NETTING
             INTO V_NETTING
             FROM SEMAST SE
             WHERE SE.ACCTNO = V_ACCTNO;
             EXCEPTION WHEN OTHERS THEN V_NETTING := 0;
        END;
        --
        BEGIN
             SELECT NVL(SUM(CRL.QTTY),0)
             INTO V_WAPQTTY
             FROM CRPHYSAGREE_LOG CRL
             WHERE CRL.TYPE = 'W'
                   AND CRL.DELTD <> 'Y'
                   AND CRL.APPENDIXID = V_APPENDIX
             GROUP BY CRL.APPENDIXID;
             EXCEPTION WHEN OTHERS THEN V_WAPQTTY := 0;
        END;
        --
        BEGIN
             SELECT NVL(SUM(CRL.QTTY),0)
             INTO V_WCRQTTY
             FROM CRPHYSAGREE_LOG CRL
             WHERE CRL.TYPE = 'W'
                   AND CRL.DELTD <> 'Y'
                   AND CRL.CRPHYSAGREEID = DECODE(V_TLTXCD,'1400',V_REF_CRPHYSAGREEID,'1407',V_CRPHYSAGREEID,NULL)
             GROUP BY CRL.CRPHYSAGREEID;
             EXCEPTION WHEN OTHERS THEN V_WCRQTTY := 0;
        END;
        --
        IF  p_txmsg.txfields(c_qtty).value > V_NETTING
            OR (V_TLTXCD ='1400' AND p_txmsg.txfields(c_qtty).value > (V_APQTTY - V_WAPQTTY)) --SL CAT > SL TREN PHU LUC - SL DA CAT
            OR (V_TLTXCD ='1407' AND p_txmsg.txfields(c_qtty).value > (V_CRQTTY - V_WCRQTTY))--SL CAT > SL TREN HOP DONG - SL DA CAT
        THEN
            p_err_code:= -911004;
            
            plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
            Return errnums.C_BIZ_RULE_INVALID;
        END IF;

    END IF;
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
    V_ACCTNO            VARCHAR2(30);
    V_SUMQTTY           NUMBER;
    V_QTTY              NUMBER;
    V_CRPHYSAGREEID     VARCHAR2(10);
    V_ACCTNO_BUY        VARCHAR2(30);
    V_APPENDIX          NUMBER;
    V_REF_CRPHYSAGREEID VARCHAR2(30);
    V_TLTXCD            VARCHAR2(4);
    V_CUSTID            VARCHAR2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    BEGIN
        SELECT CF.CUSTID INTO V_CUSTID FROM CFMAST CF WHERE CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
    END;
    --
    V_TLTXCD        := p_txmsg.txfields(c_type).value;--1400: PHU LUC - 1407: HOP DONG
    V_APPENDIX      := TO_NUMBER(p_txmsg.txfields(c_id).value);
    V_CRPHYSAGREEID := p_txmsg.txfields(c_id).value;
    --LAY MA HOP DONG & SO LUONG TREN PHU LUC
    BEGIN
         SELECT AP.CRPHYSAGREEID
         INTO V_REF_CRPHYSAGREEID
         FROM APPENDIX AP
         WHERE AP.AUTOID = V_APPENDIX;
         EXCEPTION WHEN OTHERS THEN V_REF_CRPHYSAGREEID := NULL;
                                    V_QTTY := 0;
    END;
    --LAY TK BAN VA SO LUONG TREN HOP DONG
    BEGIN
         SELECT CR.ACCTNO||CR.CODEID, CR.QTTY
         INTO V_ACCTNO, V_QTTY
         FROM CRPHYSAGREE CR
         WHERE CR.CRPHYSAGREEID = DECODE(V_TLTXCD,'1400',V_REF_CRPHYSAGREEID,'1407',V_CRPHYSAGREEID,NULL);
         EXCEPTION WHEN OTHERS THEN V_ACCTNO := NULL;
    END;
    ---------------------------------------------------------------------------------------------------------------------
    IF p_txmsg.deltd <> 'Y' THEN
        INSERT INTO SETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
        VALUES (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), V_ACCTNO, '0020', p_txmsg.txfields(c_qtty).value, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), null);

        UPDATE SEMAST SE
        SET SE.NETTING = SE.NETTING - p_txmsg.txfields(c_qtty).value
        WHERE SE.ACCTNO = V_ACCTNO;

       --trung.luu: 02-07-2020 log lai de len view physical
       --bao.nguyen: 25-07-2022 SHBVNEX-2730
       insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,CUSTODYCD,typedoc,symbol, CUSTID)
       values (p_txmsg.txdate, p_txmsg.txnum,'CP',DECODE(V_TLTXCD,'1400',V_APPENDIX,'1407',NULL,NULL) , DECODE(V_TLTXCD,'1400',V_REF_CRPHYSAGREEID,'1407',V_CRPHYSAGREEID,NULL) ,
                NULL, NULL, p_txmsg.txfields(c_setqtty).value, p_txmsg.txfields(c_qtty).value, 'A', 'N',p_txmsg.txfields(c_desc).value,null,p_txmsg.tltxcd,null,p_txmsg.txfields('09').value,V_TLTXCD,p_txmsg.txfields('04').value, V_CUSTID);

       --LUU THONG TIN CAT PHYSICAL
       INSERT INTO CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID,
                                    AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
       VALUES (p_txmsg.txdate, p_txmsg.txnum, 'W', DECODE(V_TLTXCD,'1400',V_APPENDIX,'1407',NULL,NULL), DECODE(V_TLTXCD,'1400',V_REF_CRPHYSAGREEID,'1407',V_CRPHYSAGREEID,NULL),
               NULL, NULL, p_txmsg.txfields(c_setqtty).value, p_txmsg.txfields(c_qtty).value, 'A', 'N', p_txmsg.txfields(c_desc).value);
       --LAY TONG SO LUONG PHYSICAL DA CAT THEO HOP DONG
       BEGIN
             SELECT SUM(CRL.QTTY)
             INTO V_SUMQTTY
             FROM CRPHYSAGREE_LOG CRL
             WHERE CRL.TYPE = 'W'
                   AND CRL.DELTD <> 'Y'
                   AND CRL.CRPHYSAGREEID = DECODE(V_TLTXCD,'1400',V_REF_CRPHYSAGREEID,'1407',V_CRPHYSAGREEID,NULL);
             EXCEPTION WHEN OTHERS THEN V_SUMQTTY := 0;
       END;
       --NEU TONG SL CAT PHYSICAL THEO HOP DONG = SO LUONG TREN HOP DONG -> CAP NHAT "DA CAT PHYSICAL"
       IF V_SUMQTTY = V_QTTY THEN
          UPDATE CRPHYSAGREE CR
          SET CR.BALANCESTATUS = 'W'
          WHERE CR.CRPHYSAGREEID = DECODE(V_TLTXCD,'1400',V_REF_CRPHYSAGREEID,'1407',V_CRPHYSAGREEID,NULL);
       END IF;
       --BEGIN OF NAM.LY 14/01/2020
       BEGIN
            SELECT AF.ACCTNO || AP.CODEID
            INTO V_ACCTNO_BUY
            FROM APPENDIX AP JOIN CRPHYSAGREE_SELL_LOG CR ON AP.CRPHYSAGREEID = CR.CRPHYSAGREEID AND AP.AUTOID = CR.APPENDIXID
                             JOIN CFMAST CF ON CF.CUSTODYCD = CR.BUYCUSTODYCD
                             JOIN AFMAST AF ON AF.CUSTID = CF.CUSTID
            WHERE AP.AUTOID = DECODE(V_TLTXCD,'1400',V_APPENDIX,'1407',NULL,NULL);
            EXCEPTION WHEN OTHERS THEN V_ACCTNO_BUY := NULL;
       END;
       --
       IF (V_ACCTNO_BUY IS NOT NULL) THEN
           UPDATE SEMAST SE
           SET
                SE.RECEIVING = SE.RECEIVING - p_txmsg.txfields(c_qtty).value,
                SE.TRADE = SE.TRADE + p_txmsg.txfields(c_qtty).value
           WHERE SE.ACCTNO = V_ACCTNO_BUY;
           --
           INSERT INTO SETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
                  VALUES (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), V_ACCTNO_BUY, '0015', p_txmsg.txfields(c_qtty).value, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), null);
           INSERT INTO SETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
                  VALUES (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), V_ACCTNO_BUY, '0012', p_txmsg.txfields(c_qtty).value, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), null);
       END IF;
       --END OF NAM.LY 14/01/2020
    ELSE
        UPDATE SETRAN SET DELTD = 'Y' WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);

        UPDATE SEMAST SE
        SET SE.NETTING = SE.NETTING + p_txmsg.txfields(c_qtty).value
        WHERE SE.ACCTNO = V_ACCTNO;

        UPDATE CRPHYSAGREE_LOG_ALL SET DELTD = 'Y' WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);

        UPDATE CRPHYSAGREE_LOG SET DELTD = 'Y' WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);

        BEGIN
             SELECT SUM(CRL.QTTY)
             INTO V_SUMQTTY
             FROM CRPHYSAGREE_LOG CRL
             WHERE CRL.TYPE = 'W'
                   AND CRL.DELTD <> 'Y'
                   AND CRL.CRPHYSAGREEID = DECODE(V_TLTXCD,'1400',V_REF_CRPHYSAGREEID,'1407',V_CRPHYSAGREEID,NULL);
             EXCEPTION WHEN OTHERS THEN V_SUMQTTY := 0;
       END;
       --NEU TONG SL CAT PHYSICAL THEO HOP DONG = SO LUONG TREN HOP DONG -> CAP NHAT "DA CAT PHYSICAL"
       IF V_SUMQTTY = V_QTTY THEN
          UPDATE CRPHYSAGREE CR
          SET CR.BALANCESTATUS = 'P'
          WHERE CR.CRPHYSAGREEID = DECODE(V_TLTXCD,'1400',V_REF_CRPHYSAGREEID,'1407',V_CRPHYSAGREEID,NULL);
       END IF;
       --BEGIN OF NAM.LY 14/01/2020
       BEGIN
            SELECT AF.ACCTNO || AP.CODEID
            INTO V_ACCTNO_BUY
            FROM APPENDIX AP JOIN CRPHYSAGREE_SELL_LOG CR ON AP.CRPHYSAGREEID = CR.CRPHYSAGREEID AND AP.AUTOID = CR.APPENDIXID
                             JOIN CFMAST CF ON CF.CUSTODYCD = CR.BUYCUSTODYCD
                             JOIN AFMAST AF ON AF.CUSTID = CF.CUSTID
            WHERE AP.AUTOID = DECODE(V_TLTXCD,'1400',V_APPENDIX,'1407',NULL,NULL);
            EXCEPTION WHEN OTHERS THEN V_ACCTNO_BUY := NULL;
       END;
       --
       IF (V_ACCTNO_BUY IS NOT NULL) THEN
           UPDATE SEMAST SE
           SET
                SE.RECEIVING = SE.RECEIVING + p_txmsg.txfields(c_qtty).value,
                SE.TRADE = SE.TRADE - p_txmsg.txfields(c_qtty).value
           WHERE SE.ACCTNO = V_ACCTNO_BUY;
       END IF;
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
         plog.init ('TXPKS_#1403EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1403EX;
/
