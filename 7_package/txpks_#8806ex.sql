SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8806ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8806EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/08/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8806ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '20';
   c_registtype       CONSTANT CHAR(2) := '04';
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
p_data_source varchar2(4000);
l_email varchar2(4000);
type stringarray is table of varchar2(100) ;
l_colname stringarray;
l_colval stringarray;
pv_refcursor            pkg_report.ref_cursor;
l_20 varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        
        
        
        
        BEGIN
            l_20 := TO_CHAR(TO_DATE(p_txmsg.txfields('20').value,'DD/MM/RRRR'),'RRRR_MM_DD');
        EXCEPTION WHEN OTHERS THEN
            l_20 := p_txmsg.txfields('20').value;
        END;
        if p_txmsg.txfields('04').value = 'GCB' then
            if p_txmsg.txfields('14').value = 'ALL' then --TRUNG.LUU 24-05-2021 SHBVNEX-1838
                FOR R_A IN (
                    SELECT FA.SHORTNAME
                    FROM EMAILREPORT E,CFMAST CF, FAMEMBERS FA
                    WHERE E.DELTD <> 'Y'
                    AND E.REGISTTYPE = 'GCB'
                    AND E.CUSTID = CF.CUSTID
                    AND CF.GCBID = FA.AUTOID
                    AND CF.MAILPOSITION = 'Y'  --TRUNG.LUU: SHBVNEX-1839 25-05-2021
                    AND CF.STATUS <> 'C'
                    AND FA.ROLES = 'GCB'
                    AND FA.STATUS <> 'C'
                    GROUP BY FA.SHORTNAME
                )
                LOOP
                    FOR R IN (
                        WITH T AS(
                            SELECT FA.SHORTNAME, FA.AUTOID, LISTAGG(E.EMAIL, ',') WITHIN GROUP (ORDER BY FA.AUTOID) EMAIL
                            FROM EMAILREPORT E,CFMAST CF, FAMEMBERS FA
                            WHERE E.DELTD <> 'Y'
                            AND E.REGISTTYPE = 'GCB'
                            AND E.CUSTID = CF.CUSTID
                            AND CF.GCBID = FA.AUTOID
                            AND CF.MAILPOSITION = 'Y'  --TRUNG.LUU: SHBVNEX-1839 25-05-2021
                            AND CF.STATUS <> 'C'
                            AND FA.ROLES = 'GCB'
                            AND FA.STATUS <> 'C'
                            AND FA.SHORTNAME = R_A.SHORTNAME
                            GROUP BY FA.SHORTNAME, FA.AUTOID
                        )
                        SELECT DISTINCT T.SHORTNAME, T.AUTOID, TRIM(REGEXP_SUBSTR(T.EMAIL,'[^,]+',1,LEVEL)) EMAIL
                        FROM T
                        CONNECT BY INSTR(T.EMAIL ,',',1,LEVEL -1) > 0
                    )
                    LOOP
                        p_data_source :=  'select  ''' ||p_txmsg.txfields('20').value|| '''I_DATE,''' || l_20 || ''' p_txdate, ''ALL'' PV_CUSTODYCD,''ALL'' P_AMCCODE,'''||r.shortname ||''' PV_GCB from dual';
                        nmpks_ems.InsertEmailLog(r.email, '206E1' ,p_data_source ,r.autoid);
                    END LOOP;
                END LOOP;
            else
                FOR R IN (
                    WITH T AS(
                        SELECT FA.SHORTNAME, FA.AUTOID, LISTAGG(E.EMAIL, ',') WITHIN GROUP (ORDER BY FA.AUTOID) EMAIL
                        FROM EMAILREPORT E, CFMAST CF, FAMEMBERS FA
                        WHERE E.DELTD <> 'Y'
                        AND E.REGISTTYPE = 'GCB'
                        AND E.CUSTID = CF.CUSTID
                        AND CF.GCBID = FA.AUTOID
                        AND CF.MAILPOSITION = 'Y'  --TRUNG.LUU: SHBVNEX-1839 25-05-2021
                        AND CF.STATUS <> 'C'
                        AND FA.ROLES = 'GCB'
                        AND FA.STATUS <> 'C'
                        AND FA.SHORTNAME = P_TXMSG.TXFIELDS('14').VALUE
                        GROUP BY FA.SHORTNAME, FA.AUTOID
                    )
                    SELECT DISTINCT T.SHORTNAME, T.AUTOID, TRIM(REGEXP_SUBSTR(T.EMAIL,'[^,]+',1,LEVEL)) EMAIL
                    FROM T
                    CONNECT BY INSTR(T.EMAIL ,',',1,LEVEL -1) > 0
                )
                LOOP
                    p_data_source :=  'select  ''' ||p_txmsg.txfields('20').value|| '''I_DATE,''' || l_20 || ''' p_txdate, ''ALL'' PV_CUSTODYCD,''ALL'' P_AMCCODE,'''||r.shortname ||''' PV_GCB from dual';
                    nmpks_ems.InsertEmailLog(r.email, '206E1' ,p_data_source ,r.autoid);
                END LOOP;
            end if;
        elsif p_txmsg.txfields('04').value = 'AMC' then
            IF p_txmsg.txfields('13').value = 'ALL' then --TRUNG.LUU 24-05-2021 SHBVNEX-1838
                FOR R_A IN (
                    SELECT FA.SHORTNAME
                    FROM EMAILREPORT E, CFMAST CF, FAMEMBERS FA
                    WHERE E.DELTD <> 'Y'
                    AND E.REGISTTYPE = 'AMC'
                    AND E.CUSTID = CF.CUSTID
                    AND CF.AMCID = FA.AUTOID
                    AND CF.MAILPOSITION = 'Y'
                    AND CF.STATUS <> 'C'
                    AND FA.ROLES = 'AMC'
                    AND FA.STATUS <> 'C'
                    GROUP BY FA.SHORTNAME
                )
                LOOP
                    FOR R IN (
                        WITH T AS(
                            SELECT FA.SHORTNAME, FA.AUTOID, LISTAGG(E.EMAIL, ',') WITHIN GROUP (ORDER BY FA.AUTOID) EMAIL
                            FROM EMAILREPORT E, CFMAST CF, FAMEMBERS FA
                            WHERE E.DELTD <> 'Y'
                            AND E.REGISTTYPE = 'AMC'
                            AND E.CUSTID = CF.CUSTID
                            AND CF.AMCID = FA.AUTOID
                            AND CF.MAILPOSITION = 'Y'
                            AND CF.STATUS <> 'C'
                            AND FA.ROLES = 'AMC'
                            AND FA.STATUS <> 'C'
                            AND FA.SHORTNAME = R_A.SHORTNAME
                            GROUP BY FA.SHORTNAME, FA.AUTOID
                        )
                        SELECT DISTINCT T.SHORTNAME, T.AUTOID, TRIM(REGEXP_SUBSTR(T.EMAIL,'[^,]+',1,LEVEL)) EMAIL
                        FROM T
                        CONNECT BY INSTR(T.EMAIL ,',',1,LEVEL -1) > 0
                    )
                    LOOP
                        p_data_source :=  'select  ''' ||p_txmsg.txfields('20').value|| '''I_DATE,''' || l_20 || ''' p_txdate, ''ALL'' PV_CUSTODYCD,'''||r.shortname ||''' P_AMCCODE,''ALL'' PV_GCB from dual';
                        nmpks_ems.InsertEmailLog(r.email, '206E2' ,p_data_source ,r.autoid);
                    END LOOP;
                END LOOP;
            ELSE
                FOR R IN (
                    WITH T AS(
                        SELECT FA.SHORTNAME, FA.AUTOID, LISTAGG(E.EMAIL, ',') WITHIN GROUP (ORDER BY FA.AUTOID) EMAIL
                        FROM EMAILREPORT E, CFMAST CF, FAMEMBERS FA
                        WHERE E.DELTD <> 'Y'
                        AND E.REGISTTYPE = 'AMC'
                        AND E.CUSTID = CF.CUSTID
                        AND CF.AMCID = FA.AUTOID
                        AND CF.MAILPOSITION = 'Y'  --TRUNG.LUU: SHBVNEX-1839 25-05-2021
                        AND CF.STATUS <> 'C'
                        AND FA.ROLES = 'AMC'
                        AND FA.STATUS <> 'C'
                        AND FA.SHORTNAME = P_TXMSG.TXFIELDS('13').VALUE
                        GROUP BY FA.SHORTNAME, FA.AUTOID

                    )
                    SELECT DISTINCT T.SHORTNAME, T.AUTOID, TRIM(REGEXP_SUBSTR(T.EMAIL,'[^,]+',1,LEVEL)) EMAIL
                    FROM T
                    CONNECT BY INSTR(T.EMAIL ,',',1,LEVEL -1) > 0
                )
                LOOP
                    p_data_source :=  'select  ''' ||p_txmsg.txfields('20').value|| '''I_DATE,''' || l_20 || ''' p_txdate, ''ALL'' PV_CUSTODYCD,'''||r.shortname ||''' P_AMCCODE,''ALL'' PV_GCB from dual';
                    nmpks_ems.InsertEmailLog(r.email, '206E2' ,p_data_source ,r.autoid);
                END LOOP;
            END IF;
        elsif p_txmsg.txfields('04').value = 'CUS' then
            IF p_txmsg.txfields('15').value = 'ALL' then --TRUNG.LUU 24-05-2021 SHBVNEX-1838
                fOR R IN (
                    SELECT E.EMAIL, CF.CUSTODYCD
                    FROM CFMAST CF, (SELECT *FROM EMAILREPORT WHERE DELTD <>'Y') E
                    WHERE CF.CUSTID = E.CUSTID
                    AND E.REGISTTYPE = 'CUS'
                    AND CF.STATUS <> 'C' AND CF.MAILPOSITION = 'Y'
                ) --TRUNG.LUU: SHBVNEX-1839 25-05-2021
                LOOP
                    p_data_source :=  'select  ''' ||p_txmsg.txfields('20').value|| '''I_DATE,''' || l_20 || ''' p_txdate, '''||r.custodycd ||''' PV_CUSTODYCD,''ALL'' P_AMCCODE,''ALL'' PV_GCB from dual';
                    nmpks_ems.InsertEmailLog(r.email, '206E3' ,p_data_source ,r.custodycd);
                END LOOP;
            ELSE
                FOR R IN (
                    SELECT E.EMAIL, CF.CUSTODYCD
                    FROM CFMAST CF, (SELECT *FROM EMAILREPORT WHERE DELTD <>'Y') E
                    WHERE CF.CUSTID = E.CUSTID
                    AND E.REGISTTYPE = 'CUS'
                    AND CF.STATUS <> 'C'
                    AND CF.MAILPOSITION = 'Y'  --TRUNG.LUU: SHBVNEX-1839 25-05-2021
                    AND CF.CUSTODYCD = P_TXMSG.TXFIELDS('15').VALUE
                )
                LOOP
                    p_data_source :=  'select  ''' ||p_txmsg.txfields('20').value|| '''I_DATE,''' || l_20 || ''' p_txdate, '''||r.custodycd ||''' PV_CUSTODYCD,''ALL'' P_AMCCODE,''ALL'' PV_GCB from dual';
                    nmpks_ems.InsertEmailLog(r.email, '206E3' ,p_data_source ,r.custodycd);
                END LOOP;
            END IF;
        end if;
    end if;
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
         plog.init ('TXPKS_#8806EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8806EX;
/
