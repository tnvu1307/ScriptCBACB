SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#0059ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0059EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      27/07/2017     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#0059ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_custid           CONSTANT CHAR(2) := '03';
   c_sendtovsd        CONSTANT CHAR(2) := '08';
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

   if not sapks_system.fn_CheckCloseCustodyAccount(p_txmsg.txfields('03').value) = systemnums.C_SUCCESS then
        p_err_code := '-200210'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    p_err_code := sapks_system.fn_CheckCloseCustodyCA(p_txmsg.txfields('03').value); -- Pre-defined in DEFERROR table
    if not p_err_code = systemnums.C_SUCCESS then
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
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
v_CIFID VARCHAR2 (60);
   v_ACCTNOIICA VARCHAR2 (60);
   v_AATNODDA VARCHAR2 (60);
   v_OPNDATEIICA VARCHAR2 (60);
   v_OPNDATEDDA VARCHAR2 (60);
   v_LCBID VARCHAR2 (60);
   v_GCBID VARCHAR2 (60);
   v_AMCID VARCHAR2 (60);
   v_TRUSTEEID VARCHAR2 (60);
   v_OPENCIFID VARCHAR2 (60);
   l_datasource varchar2(4000);
   l_acctno varchar2(20);
   l_email varchar2(2000);
   v_p_name varchar2(4000);
   v_custodycd varchar2(20);
   v_tradingcode varchar2(20);
   v_tradingcodedt varchar2(20);
   v_closedate varchar2(20);
   l_tempiica   varchar2(4000);
   l_tempdda   varchar2(4000);
   l_temssta    varchar2(4000);
   l_temescrow  varchar2(4000);
   l_tempstc   varchar2(4000);
   l_countddaccount number;
   l_afacctno       varchar2(200);
   L_CIFID      VARCHAR2 (60);
    L_STC       VARCHAR2 (60);
    L_OPNDATE   VARCHAR2 (60);
    L_TRADINGCODEDT VARCHAR2 (60);
    L_CFCLSDATE VARCHAR2 (60);
    L_NAME       VARCHAR2 (200);
    L_CUSTODYCD VARCHAR2 (60);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction

        IF  P_TXMSG.TXFIELDS('08').VALUE = 'N' THEN
            --TRUNG.LUU: 23-02-2021 SHBVNEX-2059 TRUONG 88 LA TAI KHOAN ME, LOOP UPDATE TAI KHOAN CON
            FOR R IN (SELECT *FROM CFMAST CF WHERE   INSTR((SELECT FN_GET_CUSTODYCD_FR_MOTHERFUND(P_TXMSG.TXFIELDS('88').VALUE) FROM DUAL),CF.CUSTODYCD) >0)
            LOOP
                UPDATE CFMAST
                SET NSDSTATUS = 'C', ACTIVESTS = 'N', PSTATUS = PSTATUS|| STATUS, STATUS = 'C', LAST_CHANGE = SYSTIMESTAMP
                WHERE CUSTID=R.CUSTID;
            END LOOP;

            UPDATE CFMAST
            SET NSDSTATUS = 'C', ACTIVESTS = 'N', PSTATUS = PSTATUS|| STATUS, STATUS = 'C', LAST_CHANGE = SYSTIMESTAMP
            WHERE CUSTID=P_TXMSG.TXFIELDS('03').VALUE;
        ELSE
            --TRUNG.LUU: 23-02-2021 SHBVNEX-2059 TRUONG 88 LA TAI KHOAN ME, LOOP UPDATE TAI KHOAN CON
            FOR R IN (SELECT *FROM CFMAST CF WHERE   INSTR((SELECT FN_GET_CUSTODYCD_FR_MOTHERFUND(P_TXMSG.TXFIELDS('88').VALUE) FROM DUAL),CF.CUSTODYCD) >0)
            LOOP
                UPDATE CFMAST
                SET NSDSTATUS = 'S', PSTATUS = PSTATUS|| STATUS, STATUS = 'N', LAST_CHANGE = SYSTIMESTAMP
                WHERE CUSTID=R.CUSTID;
            END LOOP;
            --UPDATE TAI KHOAN ME
            UPDATE CFMAST
            SET NSDSTATUS = 'S', PSTATUS = PSTATUS|| STATUS, STATUS = 'N', LAST_CHANGE = SYSTIMESTAMP
            WHERE CUSTID=P_TXMSG.TXFIELDS('03').VALUE;
        END IF;

      select count(*) into l_countddaccount from ddmast where CUSTID=p_txmsg.txfields('03').value and status <> 'C';
      select acctno into l_afacctno from afmast where CUSTID=p_txmsg.txfields('03').value;
      -- Send mail 207E   Email confirm account closing
          for rec in(
            SELECT CF.CUSTODYCD,
                CF.CIFID,
                to_char(CF.CFCLSDATE,'dd/MM/yyyy') CFCLSDATE,
                CF.COUNTRY,
                to_char(CF.OPNDATE,'dd/MM/yyyy') OPNDATE,to_char(CF.TRADINGCODEDT,'dd/MM/yyyy') TRADINGCODEDT,
               CASE WHEN CF.COUNTRY<>'234' THEN CF.TRADINGCODE ELSE '' END STC,
               CASE WHEN CF.COUNTRY<>'234' THEN to_char(CF.TRADINGCODEDT,'dd/MM/yyyy') ELSE '' END STCDATE,
               CF.FULLNAME,
                (CASE WHEN FA.SHORTNAME LIKE FA2.SHORTNAME AND  FA.SHORTNAME is not null THEN FA.SHORTNAME||' - '|| CF.FULLNAME
                 WHEN FA2.SHORTNAME IS null AND  FA.SHORTNAME is null THEN CF.FULLNAME
                WHEN FA2.SHORTNAME IS NULL THEN FA.SHORTNAME||' - '|| CF.FULLNAME
                 WHEN FA.SHORTNAME IS NULL THEN FA2.SHORTNAME||' - '|| CF.FULLNAME
              ELSE FA.SHORTNAME||' - '||FA2.SHORTNAME||' - '|| CF.FULLNAME END) NAME,
               /*CASE WHEN CF.COUNTRY<>'234' THEN DD1.REFCASAACCT ELSE '' END NO_IICA,
               CASE WHEN CF.COUNTRY<>'234' THEN to_char(DD1.OPNDATE,'dd/MM/yyyy')  ELSE '' END OPNDATE_IICA,
                CASE WHEN CF.COUNTRY<>'234' THEN  DD2.REFCASAACCT  ELSE '' END NO_DDA,
               CASE WHEN CF.COUNTRY<>'234' THEN to_char(DD2.OPNDATE,'dd/MM/yyyy')   ELSE '' END OPNDATE_DDA,
               CASE WHEN CF.COUNTRY<>'234' THEN '' ELSE DD3.REFCASAACCT END NO_SSTA,
               CASE WHEN CF.COUNTRY<>'234' THEN ''  ELSE to_char(DD3.OPNDATE,'dd/MM/yyyy') END OPNDATE_SSTA,
               CASE WHEN CF.COUNTRY<>'234' THEN DD4.REFCASAACCT ELSE '' END NO_ESCROW,
               CASE WHEN CF.COUNTRY<>'234' THEN to_char(DD4.OPNDATE,'dd/MM/yyyy')  ELSE '' END OPNDATE_ESCROW*/
               DD1.REFCASAACCT NO_IICA,
               to_char(DD1.OPNDATE,'dd/MM/yyyy') OPNDATE_IICA,
               DD2.REFCASAACCT NO_DDA,
               to_char(DD2.OPNDATE,'dd/MM/yyyy') OPNDATE_DDA,
               DD3.REFCASAACCT NO_SSTA,
               to_char(DD3.OPNDATE,'dd/MM/yyyy') OPNDATE_SSTA,
               DD4.REFCASAACCT NO_ESCROW,
               to_char(DD4.OPNDATE,'dd/MM/yyyy') OPNDATE_ESCROW
               FROM CFMAST  CF
               LEFT JOIN (
                SELECT FA.AUTOID,FA.SHORTNAME FROM FAMEMBERS FA WHERE FA.ROLES ='GCB'
               )FA ON CF.GCBID=FA.AUTOID
               LEFT JOIN (
               SELECT FA.AUTOID,FA.SHORTNAME FROM FAMEMBERS FA WHERE FA.ROLES ='TRU'
                ) FA2 ON CF.TRUSTEEID = FA2.AUTOID
                LEFT JOIN
                (
                    SELECT CUSTID,REFCASAACCT,OPNDATE FROM DDMAST WHERE ACCOUNTTYPE ='IICA'
                ) DD1 ON CF.CUSTID=DD1.CUSTID
                LEFT JOIN
                (
                    SELECT CUSTID,REFCASAACCT,OPNDATE FROM DDMAST WHERE ACCOUNTTYPE ='DDA'
                ) DD2 ON CF.CUSTID=DD2.CUSTID
                 LEFT JOIN
                (
                    SELECT CUSTID,REFCASAACCT,OPNDATE FROM DDMAST WHERE ACCOUNTTYPE ='SSTA'
                ) DD3 ON CF.CUSTID=DD3.CUSTID
                 LEFT JOIN
                (
                    SELECT CUSTID,REFCASAACCT,OPNDATE FROM DDMAST WHERE ACCOUNTTYPE ='ESCROW'
                ) DD4 ON CF.CUSTID=DD4.CUSTID
                WHERE  CF.CUSTODYCD=P_TXMSG.TXFIELDS('88').VALUE
                --and (CF.GCBID <> 0 OR CF.TRUSTEEID<>0)
                --AND CF.CFCLSDATE IS NOT NULL ;
        )loop
            L_CIFID:=REC.CIFID;
            L_STC:=REC.STC;
            L_OPNDATE:=REC.OPNDATE;
            L_TRADINGCODEDT:=REC.TRADINGCODEDT;
            L_CFCLSDATE:=REC.CFCLSDATE;
            L_NAME:=REC.NAME;
            L_CUSTODYCD:=REC.CUSTODYCD;
             if trim(rec.NO_IICA) ='' or rec.NO_IICA is null or instr(l_tempiica,trim(rec.NO_IICA))>0 then
                l_tempiica:=l_tempiica||'';
            else
                l_tempiica:=l_tempiica||'<div >- IICA account No. <span class="boldcss">'||REC.NO_IICA||'</span> dated <span class="boldcss">'||REC.OPNDATE_IICA||'</span></div>';
            end if;
            if trim(rec.NO_SSTA) ='' or rec.NO_SSTA is null or instr(l_temssta,trim(rec.NO_SSTA))>0 then
                l_temssta:=l_temssta||'';
            else
                l_temssta:=l_temssta||'<div >- SSTA account No. <span class="boldcss">'||REC.NO_SSTA||'</span> dated <span class="boldcss">'||REC.OPNDATE_SSTA||'</span></div>';
            end if;
            if trim(rec.NO_DDA) ='' or rec.NO_DDA is null or instr(l_tempdda,trim(rec.NO_DDA))>0 then
                l_tempdda:=l_tempdda||'';
            else
                l_tempdda:=l_tempdda||'<div>- DDA account No. <span class="boldcss">'||REC.NO_DDA||'</span> dated <span class="boldcss">'||REC.OPNDATE_DDA||'</span></div>';
            end if;
            if trim(rec.NO_ESCROW) ='' or rec.NO_ESCROW is null or instr(l_temescrow,trim(rec.NO_ESCROW))>0 then
                l_temescrow:=l_temescrow||'';
            else
                l_temescrow:=l_temescrow||'<div >- Escrow account No. <span class="boldcss">'||REC.NO_ESCROW||'</span> dated <span class="boldcss">'||REC.OPNDATE_ESCROW||'</span></div>';
            end if;
            if l_tempstc = '' or l_tempstc is null then
                if rec.country ='234' then
                    l_tempstc:='';
                else
                    l_tempstc:='<div>- STC: <span class="boldcss">'||REC.STC||'</span> dated <span class="boldcss">'||REC.STCDATE||'</span></div>';
                end if;
            end if;
        end loop;
            l_datasource:='select ''' || L_CIFID || ''' p_sec_accountno, ''' ||
                            l_temssta ||''' p_ssta, ''' ||
                            l_tempiica || ''' p_iica, ''' ||
                            l_tempdda || ''' p_dda, ''' ||
                            l_temescrow || ''' p_escrow, ''' ||
                            l_tempstc || ''' p_stc, ''' ||
                            L_STC || ''' p_tradingcode, ''' ||
                            L_OPNDATE || ''' p_sec_date, ''' ||
                            L_TRADINGCODEDT || ''' p_opndate, ''' ||
                            L_CFCLSDATE || ''' p_closedate, ''' ||
                            L_NAME || ''' p_fundname, ''' ||
                            L_CUSTODYCD || ''' p_custodycd from dual';
                If l_datasource is not null then
                    if l_countddaccount <> 0 then
                        nmpks_ems.pr_sendInternalEmail(l_datasource, '208E', l_afacctno);
                    else
                        nmpks_ems.pr_sendInternalEmail(l_datasource, '207E', l_afacctno);
                    end if;
                End if;
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
         plog.init ('TXPKS_#0059EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0059EX;
/
