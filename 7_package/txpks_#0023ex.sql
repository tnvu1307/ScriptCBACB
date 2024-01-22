SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#0023ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0023EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      02/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#0023ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_templateid       CONSTANT CHAR(2) := '02';
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
   v_LCBID VARCHAR2 (60);
   v_GCBID VARCHAR2 (60);
   v_AMCID VARCHAR2 (60);
   v_email VARCHAR2 (100);
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
    --l_RowCount      varchar2();
    --v_RowCount      varchar2(100);
    v_str1          clob;
    v_str2          clob;
    v_str3          clob;
    v_str4          clob;
    v_str5          clob;
    v_str6          clob;
    v_str7          clob;
    v_str8          clob;
    v_str9          clob;
    v_str10         clob;
    v_substr1       clob;
    v_substr2       clob;
    v_substr3       clob;
    v_substr4       clob;
    v_substr5       clob;
    v_substr6       clob;
    v_substr7       clob;
    v_substr8       clob;
    v_substr9       clob;
    v_substr10      clob;
    v_strRowchar    clob;
    l_group1        clob;
    l_group2        clob;
    l_group3        clob;
    l_group4        clob;
    l_group5        clob;
    l_group         clob;
    l_group6        clob;
    l_group7        clob;
    l_group8        clob;
    l_group9        clob;
    l_group10       clob;
    l_title1        clob;
    l_title2        clob;
    l_title3        clob;
    l_title4        clob;
    l_title5        clob;
    l_title         clob;
    l_title6        clob;
    l_title7        clob;
    l_title8        clob;
    l_title9        clob;
    l_title10       clob;
    v_DDINTO        clob;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_email:=upper(p_txmsg.txfields('02').value);
    IF p_txmsg.deltd <> 'Y' THEN -- Reversal transaction
            IF v_email ='200E' THEN
                /*
                SELECT KQ.CIFID,  KQ.IICAACTNO,KQ.DDAACTNO,KQ.IICAOPNDATE,KQ.DDAOPNDATE,
                       KQ.CUSTODYCD, KQ.TRADINGCODE, KQ.TRUSTEEID, KQ.OPNDATE, KQ.p_name,KQ.TRADINGCODEDT
                    into v_CIFID , v_ACCTNOIICA , v_AATNODDA , v_OPNDATEIICA , v_OPNDATEDDA ,v_custodycd ,
                         v_tradingcode , v_TRUSTEEID , v_OPENCIFID,v_p_name, v_tradingcodedt
                FROM
                (
                    SELECT CF.CIFID, CF.TRADINGCODEDT, CF.CUSTODYCD, CF.TRADINGCODE, CF.TRUSTEEID, CF.OPNDATE,
                            MAX(CASE WHEN ACCOUNTTYPE='DDA' THEN DD.REFCASAACCT ELSE '' END) DDAACTNO,
                            MAX(CASE WHEN ACCOUNTTYPE='DDA' THEN DD.OPNDATE ELSE SYSDATE-36000 END) DDAOPNDATE,
                            MAX(CASE WHEN ACCOUNTTYPE='IICA' THEN DD.REFCASAACCT ELSE '' END) IICAACTNO,
                            MAX(CASE WHEN ACCOUNTTYPE='IICA' THEN DD.OPNDATE ELSE SYSDATE-36000 END) IICAOPNDATE,
                            MAX(CASE WHEN CF.TRUSTEEID =0 THEN REPLACE(FA.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.GCBID =0 THEN REPLACE(FA2.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.TRUSTEEID =0 and CF.GCBID =0 THEN CF.FULLNAME
                                     ELSE FA.SHORTNAME||' - '||FA2.SHORTNAME||' - '||CF.FULLNAME  END) P_NAME
                    FROM CFMAST CF, DDMAST DD, FAMEMBERS FA, FAMEMBERS FA2
                    WHERE CF.CUSTID=DD.CUSTID AND DD.ACCOUNTTYPE IN ('IICA','DDA')
                    AND DD.STATUS = 'A' AND CF.CUSTODYCD LIKE p_txmsg.txfields('88').value
                    AND CF.GCBID=FA.AUTOID(+)  AND FA.STATUS(+)='A'
                    AND CF.TRUSTEEID = FA2.AUTOID(+)  AND FA2.STATUS(+) ='A'
                    GROUP BY CF.CIFID, CF.AMCID, CF.CUSTODYCD, CF.GCBID, CF.TRUSTEEID, CF.OPNDATE,CF.TRADINGCODEDT,CF.TRADINGCODE
                ) KQ;

                l_datasource:='select ''' || v_CIFID || ''' p_secaccountno, ''' ||
                            v_ACCTNOIICA || ''' p_iicaaccountno, ''' ||
                            v_AATNODDA || ''' p_ddaaccountno, ''' ||
                            v_OPNDATEIICA || ''' p_iicadate, ''' ||
                            v_OPNDATEDDA || ''' p_ddadate, ''' ||
                            v_tradingcode || ''' p_tradingcode, ''' ||
                            v_tradingcodedt || ''' p_tradingdate, ''' ||
                            v_OPENCIFID || ''' p_opndate, ''' ||
                            v_OPENCIFID || ''' p_Secdate, ''' ||
                            v_p_name || ''' p_fundname, ''' ||
                            v_custodycd || ''' p_custodycd from dual';
                */
                -- Lay thong tin TK
                SELECT KQ.CIFID, KQ.CUSTODYCD, KQ.TRADINGCODE, KQ.TRUSTEEID, KQ.OPNDATE, KQ.p_name,KQ.TRADINGCODEDT
                    into v_CIFID , v_custodycd , v_tradingcode , v_TRUSTEEID , v_OPENCIFID,v_p_name, v_tradingcodedt
                FROM
                (
                    SELECT CF.CIFID, CF.TRADINGCODEDT, CF.CUSTODYCD, CF.TRADINGCODE, CF.TRUSTEEID, CF.OPNDATE,
                            MAX(CASE WHEN CF.TRUSTEEID =0 THEN REPLACE(FA.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.GCBID =0 THEN REPLACE(FA2.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.TRUSTEEID =0 and CF.GCBID =0 THEN CF.FULLNAME
                                     ELSE FA.SHORTNAME||' - '||FA2.SHORTNAME||' - '||CF.FULLNAME  END) P_NAME
                    FROM CFMAST CF, FAMEMBERS FA, FAMEMBERS FA2
                    WHERE CF.CUSTODYCD LIKE p_txmsg.txfields('88').value
                    AND CF.GCBID=FA.AUTOID(+)  AND FA.STATUS(+)='A'
                    AND CF.TRUSTEEID = FA2.AUTOID(+)  AND FA2.STATUS(+) ='A'
                    GROUP BY CF.CIFID, CF.AMCID, CF.CUSTODYCD, CF.GCBID, CF.TRUSTEEID, CF.OPNDATE,CF.TRADINGCODEDT,CF.TRADINGCODE
                ) KQ;

                -- Lay thong TK tien
                Begin
                    Select LISTAGG(DD_INFO, '<br/>') WITHIN GROUP (ORDER BY custodycd) into v_DDINTO
                    from
                    (
                        Select custodycd,
                            '- ' || accounttype || ' account No. <span class="boldcss">' || refcasaacct || ' </span> dated <span class="boldcss">' || to_char(OPNDATE,'DD/MM/RRRR') || '</span>' DD_INFO
                        from DDMAST
                        where STATUS = 'A' /*AND ACCOUNTTYPE IN ('IICA','DDA')*/ and CUSTODYCD LIKE p_txmsg.txfields('88').value
                        order by ACCOUNTTYPE desc
                    )
                    group by custodycd;
                EXCEPTION
                WHEN OTHERS
                   THEN v_DDINTO := '';
                End;


                l_datasource:='select ''' || v_CIFID || ''' p_secaccountno, ''' ||
                            v_DDINTO || ''' p_ddinto, ''' ||
                            v_tradingcode || ''' p_tradingcode, ''' ||
                            v_tradingcodedt || ''' p_tradingdate, ''' ||
                            v_OPENCIFID || ''' p_opndate, ''' ||
                            v_OPENCIFID || ''' p_Secdate, ''' ||
                            v_p_name || ''' p_fundname, ''' ||
                            v_custodycd || ''' p_custodycd from dual';


            ELSIF v_email='203E' THEN
                /*
                SELECT KQ.CIFID,  KQ.IICAACTNO,KQ.DDAACTNO,KQ.IICAOPNDATE,KQ.DDAOPNDATE,
                       KQ.CUSTODYCD, KQ.TRADINGCODE, KQ.TRUSTEEID, KQ.OPNDATE, KQ.p_name,KQ.TRADINGCODEDT
                    into v_CIFID , v_ACCTNOIICA , v_AATNODDA , v_OPNDATEIICA , v_OPNDATEDDA ,v_custodycd ,
                         v_tradingcode , v_TRUSTEEID , v_OPENCIFID,v_p_name, v_tradingcodedt
                FROM
                (
                    SELECT CF.CIFID, CF.TRADINGCODEDT, CF.CUSTODYCD, CF.TRADINGCODE, CF.TRUSTEEID, CF.OPNDATE,
                            MAX(CASE WHEN ACCOUNTTYPE='DDA' THEN DD.REFCASAACCT ELSE '' END) DDAACTNO,
                            MAX(CASE WHEN ACCOUNTTYPE='DDA' THEN DD.OPNDATE ELSE SYSDATE-36000 END) DDAOPNDATE,
                            MAX(CASE WHEN ACCOUNTTYPE='IICA' THEN DD.REFCASAACCT ELSE '' END) IICAACTNO,
                            MAX(CASE WHEN ACCOUNTTYPE='IICA' THEN DD.OPNDATE ELSE SYSDATE-36000 END) IICAOPNDATE,
                            MAX(CASE WHEN CF.TRUSTEEID =0 THEN REPLACE(FA.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.GCBID =0 THEN REPLACE(FA2.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.TRUSTEEID =0 and CF.GCBID =0 THEN CF.FULLNAME
                                     ELSE FA.SHORTNAME||' - '||FA2.SHORTNAME||' - '||CF.FULLNAME  END) P_NAME
                    FROM CFMAST CF, DDMAST DD, FAMEMBERS FA, FAMEMBERS FA2
                    WHERE CF.CUSTID=DD.CUSTID AND DD.ACCOUNTTYPE IN ('IICA','DDA')
                    AND DD.STATUS = 'A' AND CF.CUSTODYCD LIKE p_txmsg.txfields('88').value
                    AND CF.GCBID=FA.AUTOID(+)  AND FA.STATUS(+)='A'
                    AND CF.TRUSTEEID = FA2.AUTOID(+)  AND FA2.STATUS(+) ='A'
                    GROUP BY CF.CIFID, CF.AMCID, CF.CUSTODYCD, CF.GCBID, CF.TRUSTEEID, CF.OPNDATE,CF.TRADINGCODEDT,CF.TRADINGCODE
                ) KQ;

                l_datasource:='select ''' || v_CIFID || ''' p_sec_accountno, ''' ||
                            v_ACCTNOIICA || ''' p_iica_accountno, ''' ||
                            v_AATNODDA || ''' p_dda_accountno, ''' ||
                            v_OPNDATEIICA || ''' p_iica_date, ''' ||
                            v_OPNDATEDDA || ''' p_dda_date, ''' ||
                            v_tradingcode || ''' p_tradingcode, ''' ||
                            v_tradingcodedt || ''' p_tradingdate, ''' ||
                            v_OPENCIFID || ''' p_opndate, ''' ||
                            v_OPENCIFID || ''' p_sec_date, ''' ||
                            v_p_name || ''' p_fundname, ''' ||
                            v_custodycd || ''' p_custodycd from dual';
                */
                SELECT KQ.CIFID,
                       KQ.CUSTODYCD, KQ.TRADINGCODE, KQ.TRUSTEEID, KQ.OPNDATE, KQ.p_name,KQ.TRADINGCODEDT
                    into v_CIFID , v_custodycd ,
                         v_tradingcode , v_TRUSTEEID , v_OPENCIFID,v_p_name, v_tradingcodedt
                FROM
                (
                    SELECT CF.CIFID, CF.TRADINGCODEDT, CF.CUSTODYCD, CF.TRADINGCODE, CF.TRUSTEEID, CF.OPNDATE,
                            MAX(CASE WHEN CF.TRUSTEEID =0 THEN REPLACE(FA.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.GCBID =0 THEN REPLACE(FA2.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.TRUSTEEID =0 and CF.GCBID =0 THEN CF.FULLNAME
                                     ELSE FA.SHORTNAME||' - '||FA2.SHORTNAME||' - '||CF.FULLNAME  END) P_NAME
                    FROM CFMAST CF, FAMEMBERS FA, FAMEMBERS FA2
                    WHERE CF.CUSTODYCD LIKE p_txmsg.txfields('88').value
                    AND CF.GCBID=FA.AUTOID(+)  AND FA.STATUS(+)='A'
                    AND CF.TRUSTEEID = FA2.AUTOID(+)  AND FA2.STATUS(+) ='A'
                    GROUP BY CF.CIFID, CF.AMCID, CF.CUSTODYCD, CF.GCBID, CF.TRUSTEEID, CF.OPNDATE,CF.TRADINGCODEDT,CF.TRADINGCODE
                ) KQ;

                -- Lay thong TK tien
                Begin
                    Select LISTAGG(DD_INFO, '<br/>') WITHIN GROUP (ORDER BY custodycd) into v_DDINTO
                    from
                    (
                        Select custodycd,
                            '- ' || accounttype || ' account No. <span class="boldcss">' || refcasaacct || ' </span> dated <span class="boldcss">' || to_char(OPNDATE,'DD/MM/RRRR') || '</span>' DD_INFO
                        from DDMAST
                        where STATUS = 'A' /*and ACCOUNTTYPE IN ('IICA','DDA')*/ and CUSTODYCD LIKE p_txmsg.txfields('88').value
                        order by ACCOUNTTYPE desc
                    )
                    group by custodycd;
                EXCEPTION
                WHEN OTHERS
                   THEN v_DDINTO := '';
                End;


                l_datasource:='select ''' || v_CIFID || ''' p_sec_accountno, ''' ||
                            v_DDINTO || ''' p_ddinto, ''' ||
                            v_tradingcode || ''' p_tradingcode, ''' ||
                            v_tradingcodedt || ''' p_tradingdate, ''' ||
                            v_OPENCIFID || ''' p_opndate, ''' ||
                            v_OPENCIFID || ''' p_sec_date, ''' ||
                            v_p_name || ''' p_fundname, ''' ||
                            v_custodycd || ''' p_custodycd from dual';

            ELSIF v_email='204E' THEN

                SELECT KQ.CUSTODYCD, KQ.TRADINGCODE, KQ.OPNDATE, KQ.FULLNAME,KQ.TRADINGCODEDT
                    into v_custodycd , v_tradingcode  , v_OPENCIFID,v_p_name, v_tradingcodedt
                FROM CFMAST KQ WHERE KQ.CUSTODYCD LIKE p_txmsg.txfields('88').value;

                l_datasource:='select '''|| v_tradingcode || ''' p_tradingcode, ''' ||
                            v_tradingcodedt || ''' p_tradingdate, ''' ||
                            v_OPENCIFID || ''' p_opndate, ''' ||
                            v_p_name || ''' p_name, ''' ||
                            v_custodycd || ''' p_custodycd from dual';

        /*    ELSIF v_email='207E' THEN

                SELECT KQ.CIFID,  KQ.IICAACTNO,KQ.DDAACTNO,KQ.IICAOPNDATE,KQ.DDAOPNDATE,KQ.CFCLSDATE,
                       KQ.CUSTODYCD, KQ.TRADINGCODE, KQ.TRUSTEEID, KQ.OPNDATE, KQ.p_name,KQ.TRADINGCODEDT
                    into v_CIFID , v_ACCTNOIICA , v_AATNODDA , v_OPNDATEIICA , v_OPNDATEDDA , v_closedate,v_custodycd ,
                         v_tradingcode , v_TRUSTEEID , v_OPENCIFID,v_p_name, v_tradingcodedt
                FROM
                (
                    SELECT CF.CIFID, CF.TRADINGCODEDT, CF.CUSTODYCD, CF.TRADINGCODE, CF.TRUSTEEID, CF.OPNDATE,CF.CFCLSDATE,
                            MAX(CASE WHEN ACCOUNTTYPE='DDA' THEN DD.REFCASAACCT ELSE '' END) DDAACTNO,
                            MAX(CASE WHEN ACCOUNTTYPE='DDA' THEN DD.OPNDATE ELSE SYSDATE-36000 END) DDAOPNDATE,
                            MAX(CASE WHEN ACCOUNTTYPE='IICA' THEN DD.REFCASAACCT ELSE '' END) IICAACTNO,
                            MAX(CASE WHEN ACCOUNTTYPE='IICA' THEN DD.OPNDATE ELSE SYSDATE-36000 END) IICAOPNDATE,
                            MAX(CASE WHEN CF.TRUSTEEID =0 THEN REPLACE(FA.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.GCBID =0 THEN REPLACE(FA2.SHORTNAME,'-',NULL)||CF.FULLNAME
                                     WHEN CF.TRUSTEEID =0 and CF.GCBID =0 THEN CF.FULLNAME
                                     ELSE FA.SHORTNAME||' - '||FA2.SHORTNAME||' - '||CF.FULLNAME  END) P_NAME
                    FROM CFMAST CF, DDMAST DD, FAMEMBERS FA, FAMEMBERS FA2
                    WHERE CF.CUSTID=DD.CUSTID AND DD.ACCOUNTTYPE IN ('IICA','DDA')
                    AND DD.STATUS = 'A' AND CF.CUSTODYCD LIKE p_txmsg.txfields('88').value
                    AND CF.GCBID=FA.AUTOID(+)  AND FA.STATUS='A'
                    AND CF.TRUSTEEID = FA2.AUTOID(+)  AND FA2.STATUS ='A'
                    AND CF.STATUS='C'
                    GROUP BY CF.CIFID, CF.AMCID, CF.CUSTODYCD, CF.GCBID, CF.TRUSTEEID, CF.OPNDATE,CF.TRADINGCODEDT,CF.TRADINGCODE,CF.CFCLSDATE
                ) KQ;

                l_datasource:='select ''' || v_CIFID || ''' p_sec_accountno, ''' ||
                            v_ACCTNOIICA || ''' p_iica_accountno, ''' ||
                            v_AATNODDA || ''' p_dda_accountno, ''' ||
                            v_OPNDATEIICA || ''' p_iica_date, ''' ||
                            v_OPNDATEDDA || ''' p_dda_date, ''' ||
                            v_tradingcode || ''' p_tradingcode, ''' ||
                            v_tradingcodedt || ''' p_tradingdate, ''' ||
                            v_OPENCIFID || ''' p_opndate, ''' ||
                            v_closedate || ''' p_closedate, ''' ||
                            v_p_name || ''' p_fundname, ''' ||
                            v_custodycd || ''' p_custodycd from dual';*/

            ELSIF v_email='202E' THEN

                l_title1 := '<td><span>No</span></td>';
                l_title2 := '<td><span>I/O</span></td>' ;
                l_title3 := '<td><span>Our BIC</span></td>';
                l_title4 := '<td><span>Their BIC</span></td>';
                l_title5 := '<td><span>MT type</span></td>';
                l_title6 := '<td><span>REF</span></td>';
                l_title7 := '<td><span>Related REF</span></td>';
                l_title8 := '<td><span>Created Date</span></td>';
                l_title9 := '<td><span>Related content</span></td>';
                l_title10 := '<td><span>Remark</span></td>';
                l_title  := '<tr>'||l_title1 || l_title2 || l_title3 || l_title4 || l_title5|| l_title6 || l_title7 || l_title8 || l_title9 ||l_title10||'</tr>';

                FOR i IN (

                            SELECT ROWNUM STT, A1.CDCONTENT IO, 'SHBKVNVXCUS' OUTBIC, CF.SWIFTCODE THEIRBIC,
                               CRB.MSGCODE MTTYPE, CRB.REFTXNUM REF, CRB.CBREQKEY RLREF, CRB.CREATEDATE CREATEDATE,
                               '' RLCONTENT, '' REMARK
                            FROM CRBLOG CRB,CFMAST CF, ALLCODE A1
                                WHERE   CRB.MSGTYPE (+)= 'ST'
                                    AND CF.CIFID = CRB.CIFID (+)
                                    AND CF.CUSTODYCD LIKE p_txmsg.txfields('88').value
                                    AND A1.CDNAME = 'MTTYPE' AND A1.CDTYPE = 'CF' AND A1.CDVAL  = CRB.IORO
                            ORDER BY STT

                ) LOOP
                            v_str1 :=  (i.STT) || v_strRowchar;
                            v_str2 :=  (i.IO) || v_strRowchar;
                            v_str3 :=  (i.OUTBIC) || v_strRowchar;
                            v_str4 :=  (i.THEIRBIC) || v_strRowchar;
                            v_str5 :=  (i.MTTYPE) || v_strRowchar;
                            v_str6 :=  (i.REF) || v_strRowchar;
                            v_str7 :=  (i.RLREF) || v_strRowchar;
                            v_str8 :=  (i.CREATEDATE) || v_strRowchar;
                            v_str9 :=  (i.RLCONTENT) || v_strRowchar;
                            v_str10 :=  (i.REMARK) || v_strRowchar;

                        v_substr1 := v_str1;
                        v_substr2 := v_str2;
                        v_substr3 := v_str3;
                        v_substr4 := v_str4;
                        v_substr5 := v_str5;
                        v_substr6 := v_str6;
                        v_substr7 := v_str7;
                        v_substr8 := v_str8;
                        v_substr9 := v_str9;
                        v_substr10 := v_str10;
                        --v_RowCount  := nvl(upper(v_substr1,1),0);

                        l_group1 := '';
                        l_group2 := '';
                        l_group3 := '';
                        l_group4 := '';
                        l_group5 := '';
                        l_group6 := '';
                        l_group7 := '';
                        l_group8 := '';
                        l_group9 := '';
                        l_group10 := '';

                    l_group1 := '<td><b>'||v_substr1||'</b></td>';

                    l_group2 := '<td><p align="right">'||nvl(v_substr2,'0')||'</p></p></td>';

                    l_group3 := '<td><p align="right">'||nvl(v_substr3,'0')||'</p></p></td>';

                    l_group4 := '<td><p align="right">'||nvl(v_substr4,'0')||'</p></p></td>';

                    l_group5 := '<td><p align="right">'||nvl(v_substr5,'0')||'</p></p></td>';

                    l_group6 := '<td><p align="right">'||nvl(v_substr6,'0')||'</p></p></td>';

                    l_group7 := '<td><p align="right">'||nvl(v_substr7,'0')||'</p></p></td>';

                    l_group8 := '<td><p align="right">'||nvl(v_substr8,'0')||'</p></p></td>';

                    l_group9 := '<td><p align="right">'||nvl(v_substr9,'0')||'</p></p></td>';

                    l_group10 := '<td><p align="right">'||nvl(v_substr10,'0')||'</p></p></td>';

                    l_group  :=l_group|| '<tr>'||l_group1 || l_group2 || l_group3 || l_group4 || l_group5|| l_group6 || l_group7 || l_group8 || l_group9||l_group10||'</tr>';



                END LOOP;
                l_datasource:= 'select ''' || l_title ||l_group || ''' varvalue from dual';
            ELSIF v_email='206E' THEN

                l_title1 := '<td><span>Fund name</span></td>';
                l_title2 := '<td><span>Trading code</span></td>' ;
                l_title3 := '<td><span>CIFID</span></td>';
                l_title  := '<tr>'||l_title1 || l_title2 || l_title3 ||'</tr>';

                FOR i IN (

                            SELECT CF.FULLNAME , CF.TRADINGCODE, CF.CIFID
                            FROM CFMAST CF
                                WHERE CF.CUSTODYCD LIKE p_txmsg.txfields('88').value
                ) LOOP
                            v_str1 :=  (i.FULLNAME) || v_strRowchar;
                            v_str2 :=  (i.TRADINGCODE) || v_strRowchar;
                            v_str3 :=  (i.CIFID) || v_strRowchar;

                        v_substr1 := v_str1;
                        v_substr2 := v_str2;
                        v_substr3 := v_str3;

                        l_group1 := '';
                        l_group2 := '';
                        l_group3 := '';

                    l_group1 := '<td><b>'||v_substr1||'</b></td>';

                    l_group2 := '<td><p align="right">'||nvl(v_substr2,'0')||'</p></p></td>';

                    l_group3 := '<td><p align="right">'||nvl(v_substr3,'0')||'</p></p></td>';

                    l_group  :=l_group|| '<tr>'||l_group1 || l_group2 || l_group3 || '</tr>';



                END LOOP;
                l_datasource:= 'select '''||to_date(getcurrdate,'DD/MM/YYYY')|| ''' p_txdate, ''' || l_title ||l_group || ''' varvalue from dual';
            /*
            ELSE
                l_datasource:='select ''' || v_CIFID || ''' p_Sec_accountNo, ''' ||
                            v_ACCTNOIICA || ''' p_IICA_accountNo, ''' ||
                            v_AATNODDA || ''' p_DDA_accountNo, ''' ||
                            v_OPNDATEIICA || ''' p_IICA_date, ''' ||
                            v_OPNDATEDDA || ''' p_DDA_date, ''' ||
                            v_LCBID || ''' LCBID, ''' ||
                            v_GCBID || ''' GCBID, ''' ||
                            v_AMCID || ''' AMCID, ''' ||
                            v_TRUSTEEID || ''' TRUSTEEID, ''' ||
                            v_OPENCIFID || ''' p_Sec_date, ''' ||
                            v_LCBID || ''' custodycode from dual';
            */
            END IF;
        If l_datasource is not null then
            nmpks_ems.pr_sendInternalEmail(l_datasource, v_email, p_txmsg.txfields('88').value);
        End if;

        -- Thoai.tran 28/04/2021
        -- Send mail EM16 17 18 (+ version english)
        pr_ltvcal(v_email);
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
         plog.init ('TXPKS_#0023EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0023EX;
/
