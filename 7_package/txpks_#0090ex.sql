SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#0090EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0090EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      25/06/2012     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#0090ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custid           CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_username         CONSTANT CHAR(2) := '05';
   c_loginpwd         CONSTANT CHAR(2) := '10';
   c_ismaster         CONSTANT CHAR(2) := '14';
   c_authtype         CONSTANT CHAR(2) := '11';
   c_tradingpwd       CONSTANT CHAR(2) := '12';
   c_days             CONSTANT CHAR(2) := '13';
   c_email            CONSTANT CHAR(2) := '06';
   c_tokenid          CONSTANT CHAR(2) := '15';
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
    l_custid varchar2(20);
    l_custodycd varchar2(20);
    l_username varchar2(100);
    l_username_old varchar2(100);
    l_cfstatus varchar2(10);
    l_afstatus varchar2(10);
    l_tradeonline varchar2(10);
    l_rightcount varchar2(10);
    l_currdate varchar2(10);
    l_count number(20,0);
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');


   l_custid := p_txmsg.txfields(c_custid).value;
   l_username := upper(p_txmsg.txfields(c_username).value);
   l_custodycd := upper(p_txmsg.txfields(c_custodycd).value);

   SELECT VARVALUE INTO l_currdate FROM SYSVAR WHERE VARNAME='CURRDATE';

   --Kiem tra xem user nay da cap cho thang nao khac chua
   SELECT NVL(COUNT(*),0) INTO l_count FROM CFMAST WHERE USERNAME=l_username AND CUSTID<>l_custid;
   IF l_count>0 THEN
    BEGIN
        p_err_code := errnums.C_CF_USERNAME_DUPLICATE;
        RETURN errnums.C_BIZ_RULE_INVALID;
    END;
   END IF;
   --Kiem tra trang thai thong tin khach hang (CF) la hoat dong
   BEGIN
        SELECT STATUS INTO l_cfstatus FROM CFMAST WHERE CUSTID=l_custid;
   EXCEPTION WHEN NO_DATA_FOUND THEN
        p_err_code := errnums.C_CF_CUSTOM_NOTFOUND;
        RETURN errnums.C_BIZ_RULE_INVALID;
   END;

   plog.debug (pkgctx, 'cf status : ' || l_cfstatus);

   IF l_cfstatus <> 'A' THEN
        BEGIN
            p_err_code := errnums.C_CF_CFMAST_STAT_NOTVALID;
            RETURN errnums.C_BIZ_RULE_INVALID;
        END;
   END IF;
   --Kiem tra trang thai tieu khoan khach hang (AF) la hoat dong, truong TRADEONLINE cua AFMAST = Y
   --Co quyen con hieu luc trong bang OTRIGHT
   l_count:=3;

   BEGIN
        FOR rec IN (
            SELECT CF.STATUS,CF.TRADEONLINE,NVL(OT.CFCUSTID,'N/A') OTAFACCTNO
            FROM CFMAST CF, (
               SELECT OT.CFCUSTID,OT.AUTHCUSTID FROM OTRIGHT OT,(
                    SELECT CFCUSTID,COUNT(AUTHCUSTID) CNT FROM OTRIGHTDTL
                    WHERE AUTHCUSTID=l_custid
                    AND DELTD='N' AND OTRIGHT<>'NNNN'
                    GROUP BY CFCUSTID
               ) OTL
               WHERE OT.CFCUSTID=OTL.CFCUSTID
               AND OT.VALDATE<=TO_DATE(l_currdate,'DD/MM/RRRR')
               AND OT.EXPDATE>=TO_DATE(l_currdate,'DD/MM/RRRR')
               AND OT.AUTHCUSTID=l_custid AND DELTD='N'
               GROUP BY OT.AUTHCUSTID,OT.CFCUSTID
            ) OT
            WHERE CF.CUSTID=OT.CFCUSTID(+) AND CF.TRADEONLINE='Y' AND CF.CUSTID=l_custid
        ) LOOP
            BEGIN
                plog.debug (pkgctx, 'afstatus : ' || rec.STATUS || ' , tradeonline : ' || rec.TRADEONLINE || ' , otacctno : ' || rec.OTAFACCTNO);

                IF rec.STATUS <> 'A' THEN
                    l_count:=1;
                ELSIF rec.TRADEONLINE <> 'Y' THEN
                    l_count:=2;
                ELSIF rec.OTAFACCTNO = 'N/A' THEN
                    l_count:=3;
                ELSE
                    l_count:=0;
                END IF;

                IF l_count=0 THEN
                    EXIT;
                END IF;
            END;
        END LOOP;
   END;

   IF l_count=1 THEN
        p_err_code:=errnums.C_CF_AFMAST_STATUS_INVALIDE;
        RETURN errnums.C_BIZ_RULE_INVALID;
   ELSIF l_count=2 THEN
        p_err_code:=errnums.C_CF_AFMAST_NOTSIGNONLINE;
        RETURN errnums.C_BIZ_RULE_INVALID;
   ELSIF l_count=3 THEN
        p_err_code:=errnums.C_CF_ONLINENOTHAVERIGHT;
        RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;

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
    l_custid varchar2(10);
    l_username varchar2(50);
    l_userpass varchar2(50);
    l_authtype varchar2(10);
    l_tradingpass varchar2(50);
    l_days varchar2(10);
    l_email varchar2(250);
    l_ismaster varchar2(10);
    l_tokenid varchar2(100);
    l_oldusername varchar2(50);
    l_fullname varchar2(250);
    l_custodycode varchar2(50);
    l_templateid varchar2(50);
    l_datasourcesql varchar2(400);
    l_count number(20,0);
    l_type varchar2(10);
    l_newpin varchar2(50);
    l_typetrade varchar2(1000);
    l_mobilesms varchar2(100);
    l_typesms varchar2(50);
    l_datasourcesqlsms varchar2(2000);
    l_multilang         varchar2(5);
    l_LANGUAGE_TYPE     varchar2(5);
    l_afacctno          varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');

    l_count:=0;

    l_custid := p_txmsg.txfields(c_custid).value;
    l_username := upper(p_txmsg.txfields(c_username).value);
    l_userpass := p_txmsg.txfields(c_loginpwd).value;
    l_tradingpass := p_txmsg.txfields(c_tradingpwd).value;
    l_days := p_txmsg.txfields(c_days).value;
    l_authtype := p_txmsg.txfields(c_authtype).value;
    l_email := p_txmsg.txfields(c_email).value;
    l_ismaster := p_txmsg.txfields(c_ismaster).value;
    l_tokenid := p_txmsg.txfields(c_tokenid).value;

    BEGIN




        SELECT USERNAME, FULLNAME, CUSTODYCD
        INTO l_oldusername,l_fullname,l_custodycode
        FROM CFMAST WHERE CUSTID = l_custid;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        p_err_code:=errnums.C_CF_CUSTOM_NOTFOUND;
        return errnums.C_CF_CUSTOM_NOTFOUND;
    END;

    select max(acctno) into l_afacctno from afmast af where af.custid = l_custid;

    /*IF l_username<>l_oldusername THEN
        BEGIN
            DELETE FROM USERLOGIN WHERE USERNAME = l_username;
        END;
    END IF;*/

    SELECT NVL(COUNT(*),0) INTO l_count FROM USERLOGIN WHERE USERNAME=l_username AND status='A';
    select authtype into l_type from USERLOGIN WHERE USERNAME=l_username  AND status='A';

    begin
       select mobilesms into l_mobilesms from VW_CFMAST_SMS where custodycd= l_username;
    exception
    when others then
         l_mobilesms := '';
    end ;

     BEGIN
      SELECT nvl( typesms,'GAPIT') INTO l_typesms FROM smsmap WHERE prmobile = substr(l_mobilesms,1,3);

       exception
        when others then
      l_typesms:='GAPIT';
    END ;

    BEGIN
      SELECT (case when (SUBSTR(cf.custodycd,4,1) = 'F' and nvl(t.multilang,'N')='Y') then 'EN' else '' end) INTO l_LANGUAGE_TYPE
      FROM cfmast cf, templates t WHERE cf.custid = l_custid and t.code = '101E';

       exception
        when others then
      l_LANGUAGE_TYPE:='';
    END ;

      if l_type = '1' then
        begin
         l_templateid:='101E';
       --  select substr(sys_guid(),0,10) into l_newpin from dual;
         l_newpin:=  l_tradingpass;
         l_typetrade :='Mat khau dat lenh moi cua quy khach la:';
         --
         UPDATE USERLOGIN SET ISRESET = 'Y', ISMASTER = l_ismaster,
            TOKENID = l_tokenid, LASTCHANGED=SYSDATE, NUMBEROFDAY=l_days, LOGINPWD=GENENCRYPTPASSWORD(UPPER(l_userpass)),AUTHTYPE=l_type,TRADINGPWD=GENENCRYPTPASSWORD(UPPER(l_newpin))
            WHERE UPPER(USERNAME)=l_username;

         --28/12/2015, TruongLD Add, xu ly cho truong hop cfmast.USERNAME=null
         update cfmast
            set USERNAME = l_username
         where upper(custodycd) = upper(l_custodycode) and USERNAME is null;
         --End TruonglD
         --
          l_datasourcesql:='select ''' || l_username || ''' username, ''' || substr(l_username,5,10) || ''' loginnum, ''' || l_userpass || ''' loginpwd, ''' || l_newpin || ''' tradingpwd, ''' || l_typetrade || ''' typetrade, ''' ||
          l_fullname || ''' fullname, '''' numberserial, ''' ||l_custodycode || ''' custodycode from dual';

          INSERT INTO emaillog (autoid, email, templateid, datasource, status, createtime, txdate,afacctno,LANGUAGE_TYPE)
          VALUES(seq_emaillog.nextval,l_email,l_templateid,l_datasourcesql,'A', SYSDATE, getcurrdate,l_afacctno,l_LANGUAGE_TYPE);

          --nhan tin sms
          if substr(l_username,4,1)= 'F' THEN
                l_datasourcesqlsms := 'PHS-NOTICE: Account ' || l_username || '. Log-in password: ' || l_userpass || ' , ordering password: ' ||
                l_tradingpass || '. Please change password after first log-in.';
          else
                l_datasourcesqlsms := 'PHS-TB: TK ' || l_username || '. Mat khau dang nhap: ' || l_userpass || ' , mat khau giao dich: ' ||
                l_tradingpass || '. Quy khach vui long thay doi mat khau ngay sau khi dang nhap thanh cong.';
          end if;

          INSERT INTO emaillog (autoid, email, templateid, datasource, status, createtime,TYPESMS, txdate,afacctno,LANGUAGE_TYPE)
          VALUES(seq_emaillog.nextval,l_mobilesms,'101S',l_datasourcesqlsms,'A', SYSDATE, l_typesms, getcurrdate,l_afacctno,l_LANGUAGE_TYPE);
          --  plog.error(pkgctx, 'TXPKS_#0090EX: ' || l_datasourcesqlsms);
        end;
      /*else
      IF l_count>0 THEN
        BEGIN
            l_templateid:='213B';
            UPDATE USERLOGIN SET ISRESET = 'Y', ISMASTER = l_ismaster,
            TOKENID = l_tokenid, LASTCHANGED=SYSDATE, NUMBEROFDAY=l_days, LOGINPWD=GENENCRYPTPASSWORD(UPPER(l_userpass))--,AUTHTYPE=l_authtype,TRADINGPWD=GENENCRYPTPASSWORD(UPPER(l_tradingpass))
            WHERE UPPER(USERNAME)=l_username;


        END;
      ELSE
        BEGIN
            l_templateid:='213A';

            INSERT INTO USERLOGIN (USERNAME, LOGINPWD--, AUTHTYPE, TRADINGPWD
            , STATUS, LASTLOGIN, LOGINSTATUS, LASTCHANGED, NUMBEROFDAY, ISMASTER, ISRESET
            --, TOKENID
            )
            SELECT l_username,GENENCRYPTPASSWORD(UPPER(l_userpass)),
            --l_authtype,GENENCRYPTPASSWORD(UPPER(l_tradingpass)),
            'A',SYSDATE,'O',SYSDATE,l_days,l_ismaster,'Y'--,l_tokenid
            FROM DUAL;

            UPDATE CFMAST SET USERNAME =l_username WHERE CUSTID = l_custid;
        END;
        end if;

      --update otright set AUTHTYPE=l_authtype,serialtoken = l_tokenid where cfcustid =l_custid;
      l_datasourcesql:='select ''' || l_username || ''' username, ''' || l_userpass || ''' loginpwd, ''' || --l_tradingpass || ''' tradingpwd, ''' ||
      l_fullname || ''' fullname, ''' || l_custodycode || ''' custodycode from dual';

      INSERT INTO emaillog (autoid, email, templateid, datasource, status, createtime)
      VALUES(seq_emaillog.nextval,l_email,l_templateid,l_datasourcesql,'A', SYSDATE);

      INSERT INTO emaillog (autoid, email, templateid, datasource, status, createtime,TYPESMS)
      VALUES(seq_emaillog.nextval,l_mobilesms,'304B',l_datasourcesql,'A', SYSDATE,L_TYPESMS);*/

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
         plog.init ('TXPKS_#0090EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0090EX;
/
