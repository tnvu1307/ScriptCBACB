SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_filemaster
IS
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
     **  TienPQ      09-JUNE-2009    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
  PROCEDURE PR_PREV_AUTO_FILLER(p_tlid in varchar2,p_filecode in varchar2, p_fileid  OUT varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_AUTO_FILLER(p_tlid in varchar2,p_tableName in varchar2,p_filecode in varchar2, p_fileid  IN varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_AUTO_REJECT(p_tlid in varchar2,p_fileCode in varchar2,p_fileId in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_AUTO_UPDATE_AFPRO(p_tlid in varchar2,p_filecode in varchar2,p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_COMPARE_TRADING_RESULT(p_tlid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_ETFRESULT_TEMP(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2);

  PROCEDURE PR_FILE_TBLI071(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILE_TBLI077(P_TLID IN VARCHAR2, p_fileid in varchar2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2);

  PROCEDURE PR_FILE_TBLSE2245(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILE_VOTING(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILLTER_TBLI068(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_CHECK_I068(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILLTER_TBLI068_2(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_CHECK_I068_2(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILLTER_TBLI068_3(p_tlid in varchar2, p_fileid in varchar2,  p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_CHECK_I068_3(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILLTER_TBLI069(p_tlid in varchar2,p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_CHECK_I069(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILE_TBLI081(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLI082(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

PROCEDURE PR_FILE_CADTLIMP (p_tlid in varchar2,p_fileid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILLTER_TBLI069_4web(
      p_fileid in varchar2,
      p_action in varchar2,
      p_tlid in varchar2,
      p_err_code  OUT varchar2,
      p_err_message  OUT varchar2
      );

  PROCEDURE PR_FILLTER_TBLI070(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILLTER_TBLI081(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILLTER_TBLI071(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILLTER_VOTING(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_BLOCKPLACE(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_PAYMENTCASH(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2);
  PROCEDURE PR_PAYMENTCASH_TARD_ETFEX(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2);
  PROCEDURE PR_PAYMENTCASH_TAEX(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2);

  PROCEDURE PR_FILLTER_TBLSBSECURITIES(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLSBSECURITIES(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

  PROCEDURE PR_FILLTER_TBLI176(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_TBLI176(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILLTER_TBLI177(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_TBLI177(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_CHECK_I078(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_CHECK_R0061(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_PAYMENTCASH_R0061(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2);
  PROCEDURE PR_CHECK_I088(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_PROCNAME_I088(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2);
  PROCEDURE PR_CHECK_I083(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_PROCNAME_I083(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2);
  PROCEDURE PR_CHECK_I099(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_APR_I099(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY cspks_filemaster
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

PROCEDURE PR_PREV_AUTO_FILLER(p_tlid in varchar2,p_filecode in varchar2, p_fileid  OUT varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_autoid number;

BEGIN

    plog.setbeginsection(pkgctx, 'PR_PREV_AUTO_FILLER');

    SELECT seq_fileimport.NEXTVAL INTO  v_autoid FROM dual;

    p_fileid := to_char(v_autoid);

    commit;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection(pkgctx, 'PR_PREV_AUTO_FILLER');
exception
when others then
    rollback;
    p_err_code      := -100800; --File du lieu dau vao khong hop le
    p_err_message   := 'System error. Invalid file format';
    /*
    p_err_code      := 0;
    p_err_message   := 'Sucessfull!';
    */
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_PREV_AUTO_FILLER');
RETURN;
END PR_PREV_AUTO_FILLER;

PROCEDURE PR_AUTO_FILLER(p_tlid in varchar2,p_tableName in varchar2,p_filecode in varchar2, p_fileid  IN varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_autoid number;
l_txmsg       tx.msg_rectype;
l_sql_query VARCHAR2(1000);
v_fileid    VARCHAR2(1000);
v_currdate date;
l_strdesc     varchar2(400);
l_tltxcd      varchar2(4);
l_ovrrqd      varchar2(10);
l_procfillter varchar2(50);
l_VIA         varchar2(50);
l_count number;
BEGIN
    plog.setbeginsection(pkgctx, 'PR_AUTO_FILLER');

    if p_tableName='' then
        p_err_code := 0;
        p_err_message:= 'Sucessfull!';
        return;
    end if;

    SELECT count(*) INTO l_count
    FROM SYSVAR
    WHERE GRNAME='SYSTEM' AND VARNAME='HOSTATUS'  AND VARVALUE= systemnums.C_OPERATION_ACTIVE;
    IF l_count = 0 THEN
        p_err_code := errnums.C_HOST_OPERATION_ISINACTIVE;
        plog.setendsection (pkgctx, 'PR_AUTO_FILLER');
        RETURN ;
    END IF;
    v_fileid    := p_fileid;
    If p_tlid ='6868' then
        l_VIA := 'O';
    Else
        l_VIA := 'F'; --
    End If;
    --SELECT seq_fileimport.NEXTVAL INTO  v_fileid FROM dual;

    If p_filecode in ('I072') then
        l_sql_query:=' UPDATE ' || p_tableName  || '  SET VIA=''' || l_VIA || ''' ,  TLIDIMP =''' || LPAD(p_tlid, 4, '0') || ''', TXTIME = SYSTIMESTAMP, IMPSTATUS =''Y'', OVRSTATUS=''N'', AUTOID = seq_imp_temp.nextval where fileid = ''' || v_fileid || '''';
    Else
        l_sql_query:=' UPDATE ' || p_tableName  || '  SET TLIDIMP =''' || LPAD(p_tlid, 4, '0') || ''', TXTIME = SYSTIMESTAMP, IMPSTATUS =''Y'', OVRSTATUS=''N'', AUTOID = seq_imp_temp.nextval where fileid = ''' || v_fileid || '''';
    End If;

    execute immediate l_sql_query;

    select ovrrqd, filecode||': '||filename||'(File Id = '||p_fileid||')', procfillter into l_ovrrqd, l_strdesc, l_procfillter
    from filemaster where filecode = p_filecode;

    --Goi ham xu ly check validate
    if length(nvl(l_procfillter,'')) <> 0 then
        l_sql_query:=' BEGIN cspks_filemaster.'||l_procfillter||'(:p_tlid,:p_fileid, :p_err_code,:p_err_message); END;';
        execute immediate l_sql_query using     in p_tlid,
                                                in p_fileid,
                                                out p_err_code,
                                                out p_err_message ;

        
        if p_err_code <> systemnums.C_SUCCESS then
            plog.debug (pkgctx, '<<END OF PR_AUTO_FILLER');
            plog.setendsection (pkgctx, 'PR_AUTO_FILLER');
            return ;
        end if;
    end if;
    -- nap giao dich de xu ly
      v_currdate    := getcurrdate;
      l_tltxcd       := '8800';
      l_txmsg.tltxcd := l_tltxcd;

      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := p_tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      if l_ovrrqd = 'Y' then
        l_txmsg.txstatus  := txstatusnums.c_txpending;
      else
        l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      end if;
      l_txmsg.ovrrqd      := errnums.C_OFFID_REQUIRED;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := v_currdate;
      l_txmsg.txdate    := v_currdate;

      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      select brid into l_txmsg.brid from tlprofiles where tlid = p_tlid;

        select l_txmsg.brid || lpad(seq_batchtxnum.nextval, 6, '0')
        into l_txmsg.txnum
        from dual;

      --16    Loai file   C
         l_txmsg.txfields ('16').defname   := 'FILEIDCODE';
         l_txmsg.txfields ('16').TYPE      := 'C';
         l_txmsg.txfields ('16').value      := p_filecode;
    --15    Ma    C
         l_txmsg.txfields ('15').defname   := 'FILEID';
         l_txmsg.txfields ('15').TYPE      := 'C';
         l_txmsg.txfields ('15').value      := v_fileid;
    --30    Dien giai   C
         l_txmsg.txfields ('30').defname   := 'DES';
         l_txmsg.txfields ('30').TYPE      := 'C';
         l_txmsg.txfields ('30').value      := l_strdesc;
         --30    Dien giai   C
         l_txmsg.txfields ('99').defname   := 'USERNAME';
         l_txmsg.txfields ('99').TYPE      := 'C';
         l_txmsg.txfields ('99').value      := '';

        begin
            if txpks_#8800.fn_batchtxprocess(l_txmsg, p_err_code, p_err_message) <> systemnums.c_success then
                rollback;
                plog.setendsection(pkgctx, 'PR_AUTO_FILLER');
                return;
            end if;
        end;


    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection(pkgctx, 'PR_AUTO_FILLER');
exception
when others then
    rollback;
    p_err_code      := -100800; --File du lieu dau vao khong hop le
    p_err_message   := 'System error. Invalid file format';
    /*
    p_err_code      := 0;
    p_err_message   := 'Sucessfull!';
    */
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_AUTO_FILLER');
RETURN;
END PR_AUTO_FILLER;

PROCEDURE PR_AUTO_UPDATE_AFPRO(p_tlid in varchar2,p_filecode in varchar2,p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_autoid number;
l_sql_query VARCHAR2(1000);
p_tableName varchar2(200);
l_tableName_hist varchar2(200);

BEGIN
    plog.setbeginsection(pkgctx, 'PR_AUTO_UPDATE_AFPRO');
    if p_tableName='' then
        p_err_code := 0;
        p_err_message:= 'Sucessfull!';
        return;
    end if;

    select tableName, tablename_hist into p_tableName, l_tableName_hist from filemaster where fileCode = p_fileCode;

    l_sql_query:=' UPDATE ' || p_tableName  || '  SET TLIDOVR =''' || LPAD(p_tlid, 4, '0') || ''', TXTIME = SYSTIMESTAMP,  OVRSTATUS=''Y'' where nvl(OVRSTATUS,''N'') = ''N''  and fileid = '''||p_fileid||''' ';
    execute immediate l_sql_query;

    if length(nvl(l_tableName_hist,'')) > 0 then
        l_sql_query:=' insert into  '||l_tableName_hist||' select * from '||p_tableName ||' where fileid = '''||p_fileid||''' ';
        execute immediate l_sql_query;

        l_sql_query:=' delete from  '||p_tableName || ' where fileid = '''||p_fileid||''' ';
        execute immediate l_sql_query;

    end if;

    --commit;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';

    plog.setendsection(pkgctx, 'PR_AUTO_UPDATE_AFPRO');

exception
when others then
    --rollback;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_AUTO_FILLER');
RETURN;
END PR_AUTO_UPDATE_AFPRO;

PROCEDURE PR_AUTO_REJECT(p_tlid in varchar2,p_fileCode in varchar2,p_fileId in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
p_tableName varchar2(300);
l_tableName_hist    varchar2(300);
l_sql_query VARCHAR2(1000);

BEGIN
    plog.setbeginsection(pkgctx, 'PR_AUTO_REJECT');
    if p_tableName='' then
        p_err_code := 0;
        p_err_message:= 'Sucessfull!';
        return;
    end if;

    select tableName, tablename_hist into p_tableName, l_tableName_hist from filemaster where fileCode = p_fileCode;

    l_sql_query:=' UPDATE ' || p_tableName  || '  SET TLIDOVR =''' || LPAD(p_tlid, 4, '0') || ''', TXTIME = SYSTIMESTAMP,  OVRSTATUS=''R'' where nvl(OVRSTATUS,''N'') = ''N'' and fileid = '''||p_fileid||''' ';
    execute immediate l_sql_query;

    if length(nvl(l_tableName_hist,'')) > 0 then
        l_sql_query:=' insert into  '||l_tableName_hist||' select * from '||p_tableName|| ' where fileid = '''||p_fileid||''' ' ;
        execute immediate l_sql_query;
        --plog.error(pkgctx,'Insert : '||l_sql_query);

        l_sql_query:=' delete from  '||p_tableName || ' where fileid = '''||p_fileid||''' ';
        execute immediate l_sql_query;
        --plog.error(pkgctx,'Delete : '||l_sql_query);
    end if;

    --commit;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';

    plog.setendsection(pkgctx, 'PR_AUTO_REJECT');

exception
when others then
    --rollback;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_AUTO_REJECT');
RETURN;
END PR_AUTO_REJECT;

PROCEDURE PR_FILLTER_VOTING(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;

BEGIN
    plog.setbeginsection(pkgctx, 'PR_FILLTER_VOTING');
    --UPDATE AUTOID
    UPDATE VOTINGDETAIL_TEMP SET AUTOID=SEQ_VOTINGDETAIL_TEMP.NEXTVAL;
    --CHECK CUSTODYCD
    update VOTINGDETAIL_TEMP set DELTD = 'Y', ERRMSG = ERRMSG || 'So tai khoan khong ton tai hoac da dong! '
    where CUSTODYCD not in (select CUSTODYCD from CFMAST where STATUS <> 'C');
    --CHECK CAMASTID
    update VOTINGDETAIL_TEMP set DELTD = 'Y', ERRMSG = ERRMSG || 'Ma su kien khong ton tai! '
    where CAMASTID not in (select CAMASTID from CAMAST where DELTD <> 'Y');
    --CHECK CATYPE
    update VOTINGDETAIL_TEMP set DELTD = 'Y', ERRMSG = ERRMSG || 'Loai su kien khong dung! '
    where CAMASTID not in (select CAMASTID from CAMAST where CATYPE IN ('006','022','005') and DELTD <> 'Y');
    --CHECK CASTATUS
    update VOTINGDETAIL_TEMP set DELTD = 'Y', ERRMSG = ERRMSG || 'Trang thai su kien khong dung! '
    where CAMASTID not in (select MSGACCT from vw_tllog_all where TLTXCD = '3340' and DELTD <> 'Y');
    --So TKLK phai duoc huong SKQ
    for rec in (
      select * from VOTINGDETAIL_TEMP
    )LOOP
        select count(1) into v_count from CASCHD CA, AFMAST AF, CFMAST CF where CA.AFACCTNO=AF.ACCTNO and AF.CUSTID=CF.CUSTID and CA.DELTD <> 'Y' and CAMASTID=rec.CAMASTID and CUSTODYCD=rec.CUSTODYCD;
        if v_count = 0 then
            update VOTINGDETAIL_TEMP
                set DELTD = 'Y', ERRMSG = ERRMSG || 'So TK luu ky khong duoc huong SKQ! '
            where AUTOID = rec.AUTOID;
        end if;
    END LOOP;
    --CHECK VOTECODE
    for rec in (
      select * from VOTINGDETAIL_TEMP
    )LOOP
        select count(1) into v_count from CAVOTING where VOTECODE=rec.VOTECODE and CAMASTID=rec.CAMASTID;
        if v_count = 0 then
            update VOTINGDETAIL_TEMP
                set DELTD = 'Y', ERRMSG = ERRMSG || 'Noi dung vote khong dung! '
            where AUTOID = rec.AUTOID;
        end if;
    END LOOP;
    --CHECK OPINION
    update VOTINGDETAIL_TEMP set DELTD = 'Y', ERRMSG = ERRMSG || 'Y kien voting khong dung! '
    where OPINION not in ('Y','N','NG');
    --Neu co dong loi thi return,khong cho phep insert
    select count(*) into v_count from VOTINGDETAIL_TEMP where DELTD = 'Y';
    if v_count > 0 then
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
        return;
    end if;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';

    plog.setendsection(pkgctx, 'PR_FILLTER_VOTING');
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_VOTING');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_VOTING;

PROCEDURE PR_FILE_VOTING(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_err_param     varchar2(500);
v_strCURRDATE   varchar2(20);
L_txnum         VARCHAR2(20);
l_txmsg         tx.msg_rectype;
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILE_VOTING');
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
           INTO v_strCURRDATE
           FROM sysvar
           WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=l_txmsg.tlid;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.reftxnum    := L_txnum;
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='3348';
        FOR rec in (
                  select VO.*, CF.FULLNAME, 100 RATIO from VOTINGDETAIL_TEMP VO, CFMAST CF where VO.CUSTODYCD=CF.CUSTODYCD AND CF.STATUS <> 'C'
                   )
            loop
            SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
                  l_txmsg.txfields ('03').defname   := 'CAMASTID';
                  l_txmsg.txfields ('03').TYPE      := 'C';
                  l_txmsg.txfields ('03').value      :=  rec.CAMASTID;

                  l_txmsg.txfields ('06').defname   := 'VOTECODE';
                  l_txmsg.txfields ('06').value      := rec.VOTECODE;
                  l_txmsg.txfields ('06').TYPE      := 'C';

                  l_txmsg.txfields ('07').defname   := 'OPINION';
                  l_txmsg.txfields ('07').value      := rec.OPINION;
                  l_txmsg.txfields ('07').TYPE      := 'C';

                  l_txmsg.txfields ('31').defname   := 'RATIO';
                  l_txmsg.txfields ('31').value      := rec.RATIO;
                  l_txmsg.txfields ('31').TYPE      := 'C';

                  l_txmsg.txfields ('30').defname   := 'DESC';
                  l_txmsg.txfields ('30').TYPE      := 'C';
                  l_txmsg.txfields ('30').value      := rec.NOTE;

                  l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                  l_txmsg.txfields ('88').TYPE      := 'C';
                  l_txmsg.txfields ('88').value      := rec.CUSTODYCD;

                  l_txmsg.txfields ('90').defname   := 'FULLNAME';
                  l_txmsg.txfields ('90').TYPE      := 'C';
                  l_txmsg.txfields ('90').value      := rec.FULLNAME;
       BEGIN
          IF txpks_#3348.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param)
            <> systemnums.c_success THEN
             --ROLLBACK;
             RETURN;
          END IF;
       END;
    END LOOP;

    plog.setendsection(pkgctx, 'PR_FILE_VOTING');
    p_err_message := 'SYSTEM_SUCCESS';
    p_err_code := systemnums.C_SUCCESS;
exception
when others then
      plog.debug (pkgctx,'error immporting');
      --ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'PR_FILE_VOTING');
      RAISE errnums.E_SYSTEM_ERROR;
end PR_FILE_VOTING;


PROCEDURE PR_CHECK_I068(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly check trung tu file 1 cua Cty CK
*/
    v_count NUMBER;
    v_custodycd VARCHAR2(20);
    v_codeid varchar2(100);
    v_COMPANYCD varchar2(100);
    v_fileID varchar2(100);
    v_depositid varchar2(100);
    v_currdate date;
BEGIN

    plog.setbeginsection(pkgctx, 'PR_CHECK_I068');

    v_count:=0;
    v_codeid := '';
    v_fileID :=  p_fileid;

    Begin
        select varvalue into v_COMPANYCD from sysvar where varname='COMPANYCD' and grname='SYSTEM';
    exception
        when others then v_COMPANYCD := 'SHV';
    End;

    UPDATE ODMASTCMP_TEMP SET
    QUANTITY = IS_NUMBER(NVL(QUANTITY,'-')),
    PRICE = IS_NUMBER(NVL(PRICE,'-')),
    GROSS_AMOUNT = IS_NUMBER(NVL(GROSS_AMOUNT,'-')),
    COMMISSION_FEE = IS_NUMBER(NVL(COMMISSION_FEE,'-')),
    TAX = IS_NUMBER(NVL(TAX,'-')),
    NET_AMOUNT = IS_NUMBER(NVL(NET_AMOUNT,'-'))
    WHERE FILEID = V_FILEID;

    FOR REC IN
    (
        SELECT * FROM ODMASTCMP_TEMP WHERE fileid = v_fileID order by autoid desc
    )
    LOOP
        begin
            select depositmember into v_depositid from famembers where shortname = trim(rec.broker_code) and roles = 'BRK';

            update ODMASTCMP_TEMP set broker_code = v_depositid where fileid = v_fileID and AUTOID = REC.AUTOID;
        exception when NO_DATA_FOUND then
            UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Broker code invalid! ' WHERE FILEID = REC.FILEID AND AUTOID = REC.AUTOID;
            CONTINUE;
        end;

        --Check So TKLK
        IF rec.st_code IS NOT NULL THEN
            select count(custodycd) into v_count from CFMAST WHERE substr(custodycd,5,10) = trim(rec.st_code) AND STATUS <> 'C';
            IF v_count = 0 THEN
                UPDATE ODMASTCMP_TEMP SET deltd = 'Y', STATUS = 'E', errmsg = errmsg ||'Trading account does not belong to the Broker ! ' WHERE fileid = v_fileID AND AUTOID = REC.AUTOID;
            END IF;
        ELSE
            UPDATE ODMASTCMP_TEMP SET deltd = 'Y', STATUS = 'E', errmsg = errmsg ||'Trading account does not belong to the Broker ! ' WHERE fileid = v_fileID AND AUTOID = REC.AUTOID;
        END IF;

        --Check Ma CK
        IF rec.sec_id IS NOT NULL THEN
            select count(codeid) into v_count from sbsecurities WHERE symbol = trim(rec.sec_id);
            IF v_count = 0 THEN
                UPDATE ODMASTCMP_TEMP SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'Symbol not found! ' WHERE fileid = v_fileID and sec_id = trim(rec.sec_id);
            END IF;
        ELSE
            UPDATE ODMASTCMP_TEMP SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'Symbol invalid! ' WHERE fileid = v_fileID and sec_id = trim(rec.sec_id);
        END IF;

        SELECT COUNT(1) INTO V_COUNT
        FROM CFMAST CF, ODMASTCMP_TEMP OD
        WHERE SUBSTR(CF.CUSTODYCD,5) = OD.ST_CODE
        AND OD.AUTOID = REC.AUTOID
        AND CF.STATUS <> 'C';

        IF V_COUNT > 1 THEN
            UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Duplicate trading account in system! ' WHERE FILEID = REC.FILEID AND AUTOID = REC.AUTOID;
            CONTINUE;
        END IF;

        BEGIN
            SELECT CF.CUSTODYCD INTO V_CUSTODYCD
            FROM CFMAST CF, ODMASTCMP_TEMP OD
            WHERE SUBSTR(CF.CUSTODYCD,5) = OD.ST_CODE
            AND OD.AUTOID = REC.AUTOID
            AND CF.STATUS <> 'C';
        EXCEPTION WHEN OTHERS THEN
            V_CUSTODYCD := 'A';
            UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Do not import Broker not under moanagement! ' WHERE FILEID = REC.FILEID AND AUTOID = REC.AUTOID;
            CONTINUE;
        END;

        select count(*) into v_count
        from odmastcmp od
        where od.broker_code = v_depositid
        and od.custodycd = v_custodycd
        and od.trans_type = DECODE (trim(rec.trans_type),'RVP','NB','NS')
        and od.sec_id = rec.sec_id
        and od.trade_date = to_char(to_date(rec.trade_date,'DDMMRRRR'),'DD/MM/RRRR')
        and od.settle_date = to_char(to_date(rec.settle_date,'DDMMRRRR'),'DD/MM/RRRR')
        and NVL(od.deltd, 'N') <> 'Y';

        if v_count <> 0 then
            UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Duplicate in system! ' WHERE FILEID = REC.FILEID AND AUTOID = REC.AUTOID;
            CONTINUE;
        end if;

        select count(*) into v_count
        from odmastcmp_temp odt
        where trim(odt.broker_code) = trim(rec.broker_code)
        and trim(odt.st_code) = trim(rec.st_code)
        and trim(odt.trans_type) = trim(rec.trans_type)
        and trim(odt.trade_date) = trim(rec.trade_date)
        and trim(odt.settle_date) = trim(rec.settle_date)
        and trim(odt.sec_id) = trim(rec.sec_id)
        and NVL(odt.STATUS, 'P') <> 'E'
        and NVL(odt.deltd, 'N') <> 'Y'
        and odt.autoid <> rec.autoid
        and fileid = p_fileid;

        if v_count <> 0 then
            UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = 'Duplicate in file! ' WHERE FILEID = V_FILEID AND AUTOID = REC.AUTOID;
            CONTINUE;
        end if;
    END LOOP;

    UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = 'Trans type is invalid!' WHERE FILEID = V_FILEID AND TRANS_TYPE NOT IN ('RVP','DVP');

    UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Quantity is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(QUANTITY)) - FLOOR(ABS(TO_NUMBER(QUANTITY))) > 0;
    UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Price is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(PRICE)) - FLOOR(ABS(TO_NUMBER(PRICE))) > 0;
    UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Gross Amount is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(GROSS_AMOUNT)) - FLOOR(ABS(TO_NUMBER(GROSS_AMOUNT))) > 0;
    UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Commission Fee is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(COMMISSION_FEE)) - FLOOR(ABS(TO_NUMBER(COMMISSION_FEE))) > 0;
    UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Tax is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(TAX)) - FLOOR(ABS(TO_NUMBER(TAX))) > 0;
    UPDATE ODMASTCMP_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Net Amount is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(NET_AMOUNT)) - FLOOR(ABS(TO_NUMBER(NET_AMOUNT))) > 0;

    v_currdate := getcurrdate;
    UPDATE ODMASTCMP_TEMP SET ERRMSG = ERRMSG || 'Ngay Trade Date khac ngay thuc te vui long kiem tra lai! ' WHERE FILEID = V_FILEID AND TO_DATE(TRADE_DATE,'DDMMRRRR') <> v_currdate;

    SELECT COUNT(1) INTO V_COUNT FROM ODMASTCMP_TEMP WHERE FILEID = V_FILEID AND NVL(STATUS, 'P') = 'E';

    IF V_COUNT > 0 THEN
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'File data invalid!';
    END IF;
    plog.setendsection(pkgctx, 'PR_CHECK_I068');

exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_CHECK_I068;


PROCEDURE PR_CHECK_I068_2(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly check trung file 2 cua Cty CK
*/
    v_count NUMBER;
    v_custodycd VARCHAR2(20);
    v_codeid varchar2(100);
    v_fileID    varchar2(100);
    v_symbol varchar2(100);
    v_depositid varchar2(100);
    v_currdate date;
BEGIN

    plog.setbeginsection(pkgctx, 'PR_CHECK_I068_2');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';
    v_fileID := p_fileid;
    v_symbol := '';

    UPDATE ODMASTCMP_TEMP_2 SET
    TYPE = DECODE (TYPE,'S','NS','NB'),
    QUANTITY = IS_NUMBER(NVL(QUANTITY,'-')),
    PRICE = IS_NUMBER(NVL(PRICE,'-')),
    COMMISSION = IS_NUMBER(NVL(COMMISSION,'-')),
    TAX_ORDER_FEE = IS_NUMBER(NVL(TAX_ORDER_FEE,'-')),
    PRINCIPAL_AMOUNT = IS_NUMBER(NVL(PRINCIPAL_AMOUNT,'-')),
    NET_PROCEEDS = IS_NUMBER(NVL(NET_PROCEEDS,'-'))
    WHERE FILEID = V_FILEID;

    FOR REC IN
    (
        SELECT * FROM ODMASTCMP_TEMP_2 WHERE fileid = v_fileID order by autoid desc
    )
    LOOP

        IF rec.FUND_CODE IS NOT NULL THEN
            SELECT COUNT(1) INTO V_COUNT FROM CFMAST WHERE CUSTODYCD = TRIM(REC.FUND_CODE) AND STATUS <> 'C';
            IF v_count = 0 THEN
                UPDATE ODMASTCMP_TEMP_2 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'Broker invalid or Trading account does not belong to the Broker! ' WHERE fileid = v_fileID and autoid  = rec.autoid;
            END IF;
        ELSE
            UPDATE ODMASTCMP_TEMP_2 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'Broker invalid or Trading account does not belong to the Broker! ' WHERE fileid = v_fileID and autoid = rec.autoid;
        END IF;

        begin
            SELECT SYMBOL INTO V_SYMBOL FROM SBSECURITIES WHERE ISINCODE = TRIM(REC.ISIN_CODE) AND TRADEPLACE <> '006' AND ROWNUM = 1;

            UPDATE ODMASTCMP_TEMP_2 SET TICKER_CODE = V_SYMBOL WHERE fileid = v_fileID and AUTOID = REC.AUTOID;
        EXCEPTION WHEN OTHERS THEN
            v_symbol := TRIM(rec.TICKER_CODE);
        end;

        BEGIN
            SELECT DEPOSITMEMBER INTO V_DEPOSITID
            FROM FAMEMBERS
            WHERE SHORTNAME = TRIM(REC.BROKER)
            AND ROLES = 'BRK';

            UPDATE ODMASTCMP_TEMP_2 SET BROKER = V_DEPOSITID WHERE fileid = v_fileID and AUTOID = REC.AUTOID;
        EXCEPTION WHEN OTHERS THEN
            UPDATE ODMASTCMP_TEMP_2 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Broker code invalid! ' WHERE FILEID = REC.FILEID AND AUTOID = REC.AUTOID;
            CONTINUE;
        END;

        select count(*) into v_count
        from odmastcmp od
        where od.broker_code = v_depositid
        and od.custodycd = trim(rec.FUND_CODE)
        and od.trans_type = rec.type
        and od.sec_id = v_symbol
        and od.trade_date = TO_CHAR(to_date(rec.trade_date,'DD/MM/RRRR hh24:mi:ss'), 'DD/MM/RRRR')
        and od.settle_date = TO_CHAR(to_date(rec.original_settle_date,'DD/MM/RRRR hh24:mi:ss'), 'DD/MM/RRRR')
        and od.deltd <> 'Y';

        if v_count <> 0 then
            UPDATE ODMASTCMP_TEMP_2 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || ' duplicate in system! ' WHERE fileid = v_fileID and autoid = rec.autoid;
        end if;

        select count(*) into v_count
        from ODMASTCMP_TEMP_2 od
        where od.broker = rec.broker
        and od.FUND_CODE = trim(rec.FUND_CODE)
        and od.type = rec.type
        and od.isin_code = rec.isin_code
        and NVL(od.STATUS, 'P') <> 'E'
        and NVL(od.deltd, 'N') <> 'Y'
        and TRUNC(to_date(od.trade_date,'DD/MM/RRRR hh24:mi:ss')) = TRUNC(to_date(rec.trade_date,'DD/MM/RRRR hh24:mi:ss'))
        and TRUNC(to_date(od.original_settle_date,'DD/MM/RRRR hh24:mi:ss')) = TRUNC(to_date(rec.original_settle_date,'DD/MM/RRRR hh24:mi:ss'))
        and od.autoid <> rec.autoid
        and od.fileid = p_fileid;

        if v_count <> 0 then
            UPDATE ODMASTCMP_TEMP_2 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || ' duplicate in file! ' WHERE fileid = v_fileID and autoid = rec.autoid;
        end if;
    END LOOP;

    UPDATE ODMASTCMP_TEMP_2 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Quantity is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(QUANTITY)) - FLOOR(ABS(TO_NUMBER(QUANTITY))) > 0;
    UPDATE ODMASTCMP_TEMP_2 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Price is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(PRICE)) - FLOOR(ABS(TO_NUMBER(PRICE))) > 0;
    UPDATE ODMASTCMP_TEMP_2 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Principal Amount is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(PRINCIPAL_AMOUNT)) - FLOOR(ABS(TO_NUMBER(PRINCIPAL_AMOUNT))) > 0;
    UPDATE ODMASTCMP_TEMP_2 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Commission is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(COMMISSION)) - FLOOR(ABS(TO_NUMBER(COMMISSION))) > 0;
    UPDATE ODMASTCMP_TEMP_2 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Tax - Other fee is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(TAX_ORDER_FEE)) - FLOOR(ABS(TO_NUMBER(TAX_ORDER_FEE))) > 0;
    UPDATE ODMASTCMP_TEMP_2 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Net Proceeds is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(NET_PROCEEDS)) - FLOOR(ABS(TO_NUMBER(NET_PROCEEDS))) > 0;

    v_currdate := getcurrdate;
    UPDATE ODMASTCMP_TEMP_2 SET ERRMSG = ERRMSG || 'Ngay Trade Date khac ngay thuc te vui long kiem tra lai! ' WHERE FILEID = V_FILEID AND TO_DATE(TRADE_DATE,'DD/MM/RRRR hh24:mi:ss') <> v_currdate;

    SELECT COUNT(1) INTO V_COUNT FROM ODMASTCMP_TEMP_2 WHERE FILEID = V_FILEID AND NVL(STATUS, 'P') = 'E';
    IF V_COUNT > 0 THEN
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'File data invalid!';
    END IF;

    plog.setendsection(pkgctx, 'PR_CHECK_I068_2');
exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_CHECK_I068_2');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_CHECK_I068_2;

PROCEDURE PR_CHECK_I068_3(p_tlid in varchar2, p_fileid in varchar2,  p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 3 cua Cty CK
*/
    v_count NUMBER;
    v_custodycd VARCHAR2(20);
    v_codeid varchar2(100);
    v_broker varchar2(20);
    v_fileID    varchar2(100);
    v_currdate date;
BEGIN
    plog.setbeginsection(pkgctx, 'PR_CHECK_I068_3');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';
    v_broker:= '011';
    v_fileID := p_fileid;


    UPDATE ODMASTCMP_TEMP_3 SET
    order_type = DECODE (order_type,'S','NS','NB'),
    broker = NVL(broker, '011'),
    QTY = IS_NUMBER(NVL(QTY,'-')),
    PRICE = IS_NUMBER(NVL(PRICE,'-')),
    AMOUNT = IS_NUMBER(NVL(AMOUNT,'-')),
    COMMISSION = IS_NUMBER(NVL(COMMISSION,'-')),
    PIT = IS_NUMBER(NVL(PIT,'-')),
    NET_SETTLEMENT_AMOUNT = IS_NUMBER(NVL(NET_SETTLEMENT_AMOUNT,'-'))
    WHERE FILEID = V_FILEID;

-- CHECK So TKLK
    FOR REC IN (
        SELECT * FROM ODMASTCMP_TEMP_3 WHERE fileid = v_fileID order by autoid desc
    )
    LOOP

        IF rec.CUSTODY_ID IS NOT NULL THEN
            select count(custodycd) into v_count from CFMAST WHERE CUSTODYCD = trim(rec.CUSTODY_ID) AND STATUS <> 'C';
            IF v_count = 0 THEN
                UPDATE ODMASTCMP_TEMP_3 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'Broker invalid or Trading account does not belong to the Broker! ' WHERE fileid = v_fileID and CUSTODY_ID = trim(rec.CUSTODY_ID);
            END IF;
        ELSE
            UPDATE ODMASTCMP_TEMP_3 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'Broker invalid or Trading account does not belong to the Broker! ' WHERE fileid = v_fileID and CUSTODY_ID = trim(rec.CUSTODY_ID);
        END IF;

        --Check Ma CK
        IF rec.STOCK_NAME IS NOT NULL THEN
            select count(codeid) into v_count from sbsecurities WHERE symbol = trim(rec.STOCK_NAME);
            IF v_count = 0 THEN
                UPDATE ODMASTCMP_TEMP_3 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'Symbol not found! ' WHERE fileid = v_fileID and autoid = rec.autoid;
            END IF;
        ELSE
            UPDATE ODMASTCMP_TEMP_3 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'Symbol invalid! ' WHERE fileid = v_fileID and autoid = rec.autoid;
        END IF;

        select count(*) into v_count
        from odmastcmp od
        where od.broker_code = v_broker
        and od.custodycd = trim(rec.CUSTODY_ID)
        and od.trans_type = rec.order_type
        and od.sec_id = trim(rec.stock_name)
        and od.trade_date = TO_CHAR(to_date(rec.trading_date,'DD/MM/RRRR hh24:mi:ss'), 'DD/MM/RRRR')
        and od.settle_date = TO_CHAR(to_date(rec.settlement_date,'DD/MM/RRRR hh24:mi:ss'), 'DD/MM/RRRR')
        and od.deltd <> 'Y';

        if v_count <> 0 then
            UPDATE ODMASTCMP_TEMP_3 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'duplicate in system! ' WHERE fileid = v_fileID and autoid = rec.autoid;
        end if;

        select count(*) into v_count
        from ODMASTCMP_TEMP_3 od
        where v_broker = v_broker
        and od.CUSTODY_ID = trim(rec.CUSTODY_ID)
        and od.order_type = rec.order_type
        and od.stock_name = trim(rec.stock_name)
        and TRUNC(to_date(od.trading_date,'DD/MM/RRRR hh24:mi:ss')) = TRUNC(to_date(rec.trading_date,'DD/MM/RRRR hh24:mi:ss'))
        and TRUNC(to_date(od.settlement_date,'DD/MM/RRRR hh24:mi:ss')) = TRUNC(to_date(rec.settlement_date,'DD/MM/RRRR hh24:mi:ss'))
        and NVL(od.STATUS, 'P') <> 'E'
        and NVL(od.deltd, 'N') <> 'Y'
        and od.autoid <> rec.autoid
        and od.fileid = p_fileid;

        if v_count <> 0 then
            UPDATE ODMASTCMP_TEMP_3 SET deltd = 'Y', STATUS = 'E', errmsg = errmsg || 'duplicate in file! ' WHERE fileid = v_fileID and autoid = rec.autoid;
        end if;
    END LOOP;

    UPDATE ODMASTCMP_TEMP_3 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Quantity is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(QTY)) - FLOOR(ABS(TO_NUMBER(QTY))) > 0;
    UPDATE ODMASTCMP_TEMP_3 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Price is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(PRICE)) - FLOOR(ABS(TO_NUMBER(PRICE))) > 0;
    UPDATE ODMASTCMP_TEMP_3 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Amount is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(AMOUNT)) - FLOOR(ABS(TO_NUMBER(AMOUNT))) > 0;
    UPDATE ODMASTCMP_TEMP_3 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Commission is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(COMMISSION)) - FLOOR(ABS(TO_NUMBER(COMMISSION))) > 0;
    UPDATE ODMASTCMP_TEMP_3 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'PIT is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(PIT)) - FLOOR(ABS(TO_NUMBER(PIT))) > 0;
    UPDATE ODMASTCMP_TEMP_3 SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Net Settlement Amount is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(NET_SETTLEMENT_AMOUNT)) - FLOOR(ABS(TO_NUMBER(NET_SETTLEMENT_AMOUNT))) > 0;

    v_currdate := getcurrdate;
    UPDATE ODMASTCMP_TEMP_3 SET ERRMSG = ERRMSG || 'Ngay Trade Date khac ngay thuc te vui long kiem tra lai! ' WHERE FILEID = V_FILEID AND TRUNC(TO_DATE(TRADING_DATE,'DD/MM/RRRR hh24:mi:ss')) <> TRUNC(v_currdate);

    SELECT COUNT(1) INTO V_COUNT FROM ODMASTCMP_TEMP_3 WHERE FILEID = V_FILEID AND NVL(STATUS, 'P') = 'E';
    IF V_COUNT > 0 THEN
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'File data invalid!';
    END IF;

    plog.setendsection(pkgctx, 'PR_CHECK_I068_3');
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_CHECK_I068_3');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_CHECK_I068_3;


PROCEDURE PR_FILLTER_TBLI068(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 1 cua Cty CK
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_COMPANYCD varchar2(100);
v_fileID varchar2(100);
v_depositid varchar2(100);
v_tlid varchar2(100);
l_VIA         varchar2(50);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI068');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';
    v_fileID :=  p_fileid;
    v_tlid := p_tlid;

    If p_tlid ='6868' then
        l_VIA := 'O';
    Else
        l_VIA := 'F'; --
    End If;
    /*
    begin
        PR_CHECK_I068(v_tlid, v_fileID, p_err_code, p_err_message);
    end;
    */
    UPDATE ODMASTCMP_TEMP SET TRANS_TYPE = DECODE (TRANS_TYPE,'RVP','NB','NS') WHERE FILEID = V_FILEID;
    update odmastcmp_temp set
        custodycd = (select custodycd from cfmast where substr(custodycd,5,10) = odmastcmp_temp.st_code ),
        st_code = (select custodycd from cfmast where  substr(custodycd,5,10) = odmastcmp_temp.st_code )
    where  fileid = v_fileID;
    --TruongLD add 21/01/2020, da sinh lenh vao odmast --> khong duoc xoa'
    --delete odmastcmp where isodmast <> 'Y' and broker_code in (select broker_code from odmastcmp_temp);
    --Trung.luu 23/03/2020: bo rule ghi de lenh import, khong update deltd
    --update odmastcmp set deltd ='Y' where isodmast <> 'Y' and broker_code in (select broker_code from odmastcmp_temp where fileid = v_fileID);
    --update odmastcmp_temp set isodmast = 'N';
    --insert into odmastcmp (select *from odmastcmp_temp where errmsg is null);
    insert into odmastcmp (BROKER_CODE,TRANS_TYPE,ST_CODE,CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,GROSS_AMOUNT,
                COMMISSION_FEE,TAX,NET_AMOUNT,DELTD,STATUS,ERRMSG,FILEID,TLIDIMP,ISCOMPARE,TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,ISODMAST,CITAD,IDENTITY,VIA)
    select BROKER_CODE,TRANS_TYPE,trim(ST_CODE),trim(CUSTODYCD),trim(SEC_ID),
                to_char(to_date(TRADE_DATE,'DDMMRRRR'),'DD/MM/RRRR') TRADE_DATE,
                to_char(to_date(SETTLE_DATE,'DDMMRRRR'),'DD/MM/RRRR') SETTLE_DATE,QUANTITY,PRICE,GROSS_AMOUNT,
                COMMISSION_FEE,TAX,NET_AMOUNT,'N' DELTD,STATUS,ERRMSG,
                v_fileID FILEID,TLIDIMP,ISCOMPARE,sysdate TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,'N' ISODMAST,CITAD,IDENTITY, l_VIA
    from odmastcmp_temp
    where fileid = v_fileID
    and NVL(STATUS, 'P') <> 'E';

    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI068');

exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI068;

PROCEDURE PR_CHECK_I069(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly check trung tu file 1 cua Cty CK
*/
    v_count NUMBER;
    v_COMPANYCD varchar2(100);
    v_fileID varchar2(100);
    v_currdate date;
    V_TRANSACTIONTYPE varchar2(100);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_CHECK_I069');

    v_count:=0;
    v_fileID :=  p_fileid;

    Begin
        select varvalue into v_COMPANYCD from sysvar where varname='COMPANYCD' and grname='SYSTEM';
    exception
        when others then v_COMPANYCD := 'SHV';
    End;

    UPDATE ODMASTCUST_TEMP SET
    QUANTITY = IS_NUMBER(NVL(QUANTITY,'-')),
    PRICE = IS_NUMBER(NVL(PRICE,'-')),
    GROSS_AMOUNT = IS_NUMBER(NVL(GROSS_AMOUNT,'-')),
    COMMISSION_FEE = IS_NUMBER(NVL(COMMISSION_FEE,'-')),
    TAX = IS_NUMBER(NVL(TAX,'-')),
    NET_AMOUNT = IS_NUMBER(NVL(NET_AMOUNT,'-'))
    WHERE FILEID = V_FILEID;

    FOR REC IN
    (
        SELECT * FROM ODMASTCUST_TEMP WHERE fileid = V_FILEID order by autoid desc
    )
    LOOP
        --Check So TKLK
        IF REC.ST_CODE IS NOT NULL THEN
            SELECT COUNT(CUSTODYCD) INTO V_COUNT FROM CFMAST WHERE CUSTODYCD = TRIM(REC.ST_CODE) AND STATUS <> 'C';
            IF v_count = 0 THEN
                UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Trading account does not belong to the Broker! ' WHERE FILEID = V_FILEID AND AUTOID = REC.AUTOID;
            END IF;
        END IF;

        --Check Ma CK
        IF REC.SEC_ID IS NOT NULL THEN
            SELECT COUNT(CODEID) INTO V_COUNT FROM SBSECURITIES WHERE SYMBOL = REC.SEC_ID;
            IF v_count = 0 THEN
              UPDATE ODMASTCUST_TEMP SET deltd = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Symbol not found! ' WHERE FILEID = V_FILEID AND AUTOID = REC.AUTOID;
            END IF;
        END IF;

        --Check TRANSACTIONTYPE
        IF REC.TRANSACTIONTYPE IS NOT NULL THEN
            BEGIN
                SELECT CDCONTENT
                INTO V_TRANSACTIONTYPE
                FROM ALLCODE
                WHERE CDNAME='TRANSACTIONTYPE' AND TRIM(UPPER(CDVAL)) = TRIM(UPPER(REC.TRANSACTIONTYPE));
            EXCEPTION WHEN NO_DATA_FOUND THEN
                V_TRANSACTIONTYPE := NULL;
            END;

            IF V_TRANSACTIONTYPE IS NULL THEN
                UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG =ERRMSG || 'TRANSACTIONTYPE invalid! ' WHERE FILEID = V_FILEID AND AUTOID = REC.AUTOID;
            end if;
        END IF;

        --Check CTCK
        IF REC.BROKER_CODE IS NOT NULL THEN
            SELECT COUNT(*) INTO V_COUNT
            FROM FABROKERAGE BR, FAMEMBERS M
            WHERE BR.BRKID = M.AUTOID
            AND (BR.CUSTODYCD = TRIM(REC.ST_CODE)  OR BR.CUSTODYCD = TRIM(REC.CUSTODYCD))
            AND M.SHORTNAME  = TRIM(REC.BROKER_CODE);

            IF v_count = 0 THEN
                UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Broker invalid or Trading account does not belong to the Broker! ' WHERE FILEID = V_FILEID AND AUTOID = REC.AUTOID;
            END IF;
        END IF;


    END LOOP;

    UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Symbol invalid! ' WHERE FILEID=V_FILEID AND SEC_ID IS NULL;
    UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Trans type invalid! ' WHERE FILEID = V_FILEID AND TRANS_TYPE NOT IN ('NB', 'NS');

    UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Quantity is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(QUANTITY)) - FLOOR(ABS(TO_NUMBER(QUANTITY))) > 0;
    UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Price is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(PRICE)) - FLOOR(ABS(TO_NUMBER(PRICE))) > 0;
    UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Gross Amount is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(GROSS_AMOUNT)) - FLOOR(ABS(TO_NUMBER(GROSS_AMOUNT))) > 0;
    UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Commission Fee is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(COMMISSION_FEE)) - FLOOR(ABS(TO_NUMBER(COMMISSION_FEE))) > 0;
    UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Tax is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(TAX)) - FLOOR(ABS(TO_NUMBER(TAX))) > 0;
    UPDATE ODMASTCUST_TEMP SET DELTD = 'Y', STATUS = 'E', ERRMSG = ERRMSG || 'Net Amount is invalid! ' WHERE FILEID = V_FILEID AND ABS(TO_NUMBER(NET_AMOUNT)) - FLOOR(ABS(TO_NUMBER(NET_AMOUNT))) > 0;

    SELECT COUNT(1) INTO V_COUNT FROM ODMASTCUST_TEMP WHERE FILEID = V_FILEID AND NVL(STATUS, 'P') = 'E';

    IF V_COUNT > 0 THEN
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'File data invalid!';
    END IF;
    plog.setendsection(pkgctx, 'PR_CHECK_I069');

exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_CHECK_I069;

PROCEDURE PR_FILLTER_TBLI069(p_tlid in varchar2,p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 1 cua khach hang
*/
    v_COMPANYCD varchar2(100);
    v_fileid varchar2(100);
    l_VIA varchar2(50);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI069');

    If p_tlid ='6868' then
        l_VIA := 'O';
    Else
        l_VIA := 'F'; --
    End If;

    v_fileid := p_fileid;

    Begin
        select varvalue into v_COMPANYCD from sysvar where varname='COMPANYCD' and grname='SYSTEM';
    exception
        when others then v_COMPANYCD := 'SHV';
    End;


    UPDATE ODMASTCUST_TEMP
    SET custodycd = (SELECT CUSTODYCD FROM CFMAST WHERE tradingcode = trim(ODMASTCUST_TEMP.st_code))
    WHERE fileid = v_fileid
    and INSTR(st_code, v_COMPANYCD) = 0;

    UPDATE ODMASTCUST_TEMP
    SET custodycd = st_code, st_code = ''
    WHERE fileid=v_fileid
    and INSTR (st_code, v_COMPANYCD )> 0;

    /*
    UPDATE  ODMASTCUST  SET  custodycd = (SELECT CUSTODYCD FROM CFMAST WHERE  tradingcode = ODMASTCUST.st_code)
    WHERE INSTR (st_code,'SHV')=0;

    UPDATE  odmastcust  SET  custodycd = st_code,st_code=''
    WHERE INSTR (st_code,'SHV')>0;
    */

    -- 21/01/2020, TruongLD add, neu da sinh vao ODMAST --> ko duoc xoa o day.
    /*update odmastcust set deltd ='Y'
    where isodmast <> 'Y' and via = l_VIA and
          exists (select custodycd from odmastcust_temp t where fileid=v_fileid and t.broker_code = broker_code);*/

    INSERT INTO ODMASTCUST(BROKER_CODE,TRANS_TYPE,ST_CODE,CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,
                            PRICE,GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,DELTD,STATUS,ERRMSG,FILEID,TLIDIMP,
                            ISCOMPARE,TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,ISODMAST,TRANSACTIONTYPE,AP,CITAD,IDENTITY, VIA,apacct,etfdate)
    SELECT fa.depositmember BROKER_CODE,od.TRANS_TYPE,trim(od.ST_CODE),trim(od.CUSTODYCD),trim(od.SEC_ID),
            to_char(to_date(od.TRADE_DATE,'DDMMRRRR'),'DD/MM/RRRR') TRADE_DATE,
            to_char(to_date(od.SETTLE_DATE,'DDMMRRRR'),'DD/MM/RRRR') SETTLE_DATE,
            od.QUANTITY,od.PRICE,od.GROSS_AMOUNT,
            od.COMMISSION_FEE,od.TAX,od.NET_AMOUNT,'N' DELTD,od.STATUS,od.ERRMSG, v_fileid FILEID, od.TLIDIMP, 'N' ISCOMPARE,sysdate TXTIME,od.IMPSTATUS,
            od.OVRSTATUS,od.AUTOID,od.ISODMAST,od.TRANSACTIONTYPE,od.AP,od.CITAD,od.IDENTITY, l_VIA VIA,od.apacct,fn_IsDate(od.etfdate)--to_date(od.etfdate,'DDMMRRRR')
    FROM ODMASTCUST_TEMP od, famembers fa
    WHERE od.fileid = v_fileid
    and NVL(od.STATUS, 'P') <> 'E'
    and fa.shortname = od.BROKER_CODE
    and fa.roles = 'BRK';

    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI069');
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI069');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI069;

PROCEDURE PR_FILLTER_TBLI081(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 1 cua VSD
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_exception EXCEPTION;
v_fileid VARCHAR2(100);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI081');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';

    v_fileid := p_fileid;

    FOR REC IN
    (SELECT * FROM ODMASTVSDGB_TEMP WHERE fileid = v_fileid order by autoid)
    LOOP
        UPDATE  ODMASTVSDGB_TEMP SET TRANS_TYPE= CASE WHEN  QUANTITYS >0 THEN 'NS' ELSE 'NB'  END ,QUANTITY =  NVL(QUANTITYB,0) + NVL(QUANTITYS,0) where autoid = rec.autoid;
        update ODMASTVSDGB_TEMP set broker_code  = LPAD(broker_code, 3, '00') where autoid = rec.autoid;
        update ODMASTVSDGB_TEMP set  settle_date =fn_get_nextdate_8864(trade_date,1) where autoid = rec.autoid;

    END LOOP;
     plog.setendsection(pkgctx, 'PR_FILLTER_TBLI081');

exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLER_TBLI081');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI081;


PROCEDURE PR_FILLTER_TBLI070(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 1 cua VSD
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_exception EXCEPTION;
v_fileid VARCHAR2(100);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI070');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';

    v_fileid := p_fileid;

    UPDATE  ODMASTVSD_TEMP SET TRANS_TYPE= CASE WHEN  QUANTITYS >0 THEN 'NS' ELSE 'NB'  END ,QUANTITY =  NVL(QUANTITYB,0) + NVL(QUANTITYS,0) where fileid = v_fileid;
    update ODMASTVSD_TEMP set broker_code  = LPAD(broker_code, 3, '00') where fileid = v_fileid;

-- CHECK So TKLK
    FOR REC IN
    (SELECT * FROM ODMASTVSD_TEMP WHERE fileid = v_fileid and errmsg IS NULL )
    LOOP
        --Check CTCK
        IF REC.broker_code IS NOT NULL THEN
            select COUNT(*) INTO v_count
                from FABROKERAGE BR,FAMEMBERS M
                where   BR.BRKID = M.AUTOID
                    and (BR.CUSTODYCD = trim(REC.ST_CODE) or BR.CUSTODYCD = trim(REC.custodycd))
                    AND M.depositmember  = REC.broker_code
            ;
            
            IF v_count = 0 THEN
                UPDATE ODMASTVSD_TEMP SET deltd='Y' , errmsg =errmsg||'Error: Trading account does not belong to the Broker !' WHERE fileid = v_fileid and CUSTODYCD = trim(rec.CUSTODYCD);
                p_err_code := '-901219';
                EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        END IF;
        --Check So TKLK
        IF rec.st_code IS NOT NULL THEN
            select count(custodycd) into v_count from CFMAST WHERE CUSTODYCD  = trim(rec.CUSTODYCD) AND STATUS <> 'C';
            IF v_count = 0 THEN
              UPDATE ODMASTVSD_TEMP SET deltd='Y' , errmsg =errmsg||'Error: Broker invalid or Trading account does not belong to the Broker !' WHERE fileid = v_fileid and CUSTODYCD = trim(rec.CUSTODYCD) or custodycd = trim(rec.st_code);
              p_err_code := '-901219';
              EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        END IF;

        --Check Ma CK
        IF rec.sec_id IS NOT NULL THEN
            select count(codeid) into v_count from sbsecurities WHERE symbol = trim(rec.sec_id);
            IF v_count = 0 THEN
              UPDATE ODMASTVSD_TEMP SET deltd='Y' , errmsg =errmsg||'Error: Symbol not found!' WHERE fileid = v_fileid and sec_id = trim(rec.sec_id);
              p_err_code := '-700093';
              EXIT;
            else
                --plog.error('CHECK ='||p_err_code);
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        ELSE
              UPDATE ODMASTVSD_TEMP SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE fileid = v_fileid and sec_id = trim(rec.sec_id);
              p_err_code := '-700093';
              EXIT;
        END IF;


    END LOOP;
    --trung.luu 24-02-2020 : bo rule ghi de khi insert trung lenh
    --update ODMASTVSD set DELTD='Y'  WHERE ISODMAST <> 'Y' and BROKER_CODE IN( SELECT BROKER_CODE FROM ODMASTVSD_TEMP where fileid = v_fileid);
    --DELETE ODMASTVSD WHERE ISODMAST <> 'Y' and BROKER_CODE IN(SELECT BROKER_CODE FROM ODMASTVSD_TEMP);
    INSERT INTO ODMASTVSD(BROKER_CODE,TRANS_TYPE,CUSTODYCD,ST_CODE,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,QUANTITYB, QUANTITYS,
                            DELTD,STATUS,ERRMSG,FILEID,TLIDIMP,ISCOMPARE,TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,ISODMAST,CITAD,IDENTITY,GROSSAMOUNT)
     SELECT trim( BROKER_CODE),TRANS_TYPE,trim(CUSTODYCD),trim(ST_CODE),trim(SEC_ID),
                            --to_date(TRADE_DATE,'DD/MM/RRRR') TRADE_DATE,
                            to_char(to_date(TRADE_DATE,'DD/MM/RRRR hh24:mi:ss'),'DD/MM/RRRR') TRADE_DATE,
                            fn_get_nextdate_8864(TO_DATE(TRADE_DATE,'DD/MM/RRRR hh24:mi:ss'),2) SETTLE_DATE,
                            QUANTITY,PRICE,QUANTITYB, QUANTITYS,
                            'N' DELTD,STATUS,ERRMSG, v_fileid FILEID,TLIDIMP,ISCOMPARE,sysdate TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,'N' ISODMAST,CITAD,IDENTITY,CASE WHEN TRANS_TYPE ='NB' THEN AMOUNTB ELSE AMOUNTS END
     FROM ODMASTVSD_TEMP WHERE fileid = v_fileid and errmsg IS NULL;

     plog.setendsection(pkgctx, 'PR_FILLTER_TBLI070');

exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI070');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI070;
PROCEDURE PR_FILE_TBLI081(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 1 cua VSD
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_exception EXCEPTION;
v_fileid VARCHAR2(100);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILE_TBLI081');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';

    v_fileid := p_fileid;


-- CHECK So TKLK
    FOR REC IN
    (SELECT * FROM ODMASTVSDGB_TEMP WHERE fileid = v_fileid order by autoid desc )
    LOOP
        --Check CTCK
        IF REC.broker_code IS NOT NULL THEN
            select COUNT(*) INTO v_count
                from FABROKERAGE BR,FAMEMBERS M
                where   BR.BRKID = M.AUTOID
                    and  BR.CUSTODYCD = trim(REC.custodycd)
                    AND M.depositmember  = REC.broker_code
            ;
            
            IF v_count = 0 THEN
                UPDATE ODMASTVSDGB_TEMP SET deltd='Y' , errmsg =errmsg||'Error: Trading account does not belong to the Broker !' WHERE autoid = rec.autoid and CUSTODYCD = trim(rec.CUSTODYCD);
                p_err_code := '-901219';
                EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        END IF;
        --Check So TKLK
        IF rec.CUSTODYCD IS NOT NULL THEN
            select count(custodycd) into v_count from CFMAST WHERE CUSTODYCD  = trim(rec.CUSTODYCD) AND STATUS <> 'C';
            IF v_count = 0 THEN
              UPDATE ODMASTVSDGB_TEMP SET deltd='Y' , errmsg =errmsg||'Error: Broker invalid or Trading account does not belong to the Broker !' WHERE autoid = rec.autoid and CUSTODYCD = trim(rec.CUSTODYCD) ;
              p_err_code := '-901219';
              EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        END IF;

        --Check Ma CK
        IF rec.sec_id IS NOT NULL THEN
            select count(codeid) into v_count from sbsecurities WHERE symbol = trim(rec.sec_id);
            IF v_count = 0 THEN
              UPDATE ODMASTVSDGB_TEMP SET deltd='Y' , errmsg =errmsg||'Error: Symbol not found!' WHERE autoid = rec.autoid and sec_id = trim(rec.sec_id);
              p_err_code := '-700093';
              EXIT;
            else
                --plog.error('CHECK ='||p_err_code);
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        ELSE
              UPDATE ODMASTVSDGB_TEMP SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid and sec_id = trim(rec.sec_id);
              p_err_code := '-700093';
              EXIT;
        END IF;


    END LOOP;

    INSERT INTO ODMASTVSD(BROKER_CODE,TRANS_TYPE,CUSTODYCD,ST_CODE,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,QUANTITYB, QUANTITYS,
                            DELTD,STATUS,ERRMSG,FILEID,TLIDIMP,ISCOMPARE,TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,ISODMAST,CITAD,IDENTITY,GROSSAMOUNT)
     SELECT trim( BROKER_CODE),TRANS_TYPE,trim(CUSTODYCD),trim(CUSTODYCD),trim(SEC_ID),
                            TRADE_DATE,
                            SETTLE_DATE,
                            QUANTITY,PRICE,QUANTITYB, QUANTITYS,
                            'N' DELTD,STATUS,ERRMSG, v_fileid FILEID,TLIDIMP,ISCOMPARE,sysdate TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,'N' ISODMAST,CITAD,IDENTITY,CASE WHEN TRANS_TYPE ='NB' THEN AMOUNTB ELSE AMOUNTS END
     FROM ODMASTVSDGB_TEMP WHERE fileid = v_fileid and errmsg IS NULL;

     plog.setendsection(pkgctx, 'PR_FILE_TBLI081');

exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILE_TBLI081');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLI081;


PROCEDURE PR_FILE_TBLI082(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 1 cua VSD
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_exception EXCEPTION;
v_fileid VARCHAR2(100);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILE_TBLI082');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';

    v_fileid := p_fileid;

    insert into CITADGBOND (sec_id,identity,bank,citad,deltd,status,errmsg,fileid,tlidimp,txtime,impstatus,ovrstatus,autoid)
    SELECT trim(sec_id),trim(identity),trim(bank),trim(citad),
           'N' DELTD,STATUS,ERRMSG, v_fileid FILEID,TLIDIMP,sysdate TXTIME,IMPSTATUS,OVRSTATUS,AUTOID
     FROM CITADGBOND_TEMP WHERE fileid = v_fileid and errmsg IS NULL;
    for rec in (select *from CITADGBOND_TEMP where fileid = v_fileid order by autoid desc)
    loop
        update odmast set citad = rec.citad where identity = rec.identity;
    end loop;



     plog.setendsection(pkgctx, 'PR_FILE_TBLI082');

exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILE_TBLI082');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLI082;

PROCEDURE PR_FILLTER_TBLI068_2(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 2 cua Cty CK
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_fileID    varchar2(100);
v_depositid varchar2(100);
v_tlid varchar2(100);
l_VIA varchar2(10);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI068_2');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';
    v_fileID := p_fileid;
    v_tlid:= p_tlid;
    If p_tlid ='6868' then
        l_VIA := 'O';
    Else
        l_VIA := 'F'; --
    End If;
    /*
    begin
        PR_CHECK_I068_2(v_tlid, v_fileID, p_err_code, p_err_message);
    end;
    */
    -- 21/01/2020, TruongLD add, da sinh lenh vao ODMAST --> ko duoc xoa odmastcmp
    --delete odmastcmp where isodmast <> 'Y' and broker_code in(select broker from odmastcmp_temp_2);
    --Trung.luu 23/03/2020: bo rule ghi de lenh import, khong update deltd
    --Update odmastcmp set deltd ='Y' where isodmast <> 'Y' and broker_code in(select broker from odmastcmp_temp_2 where fileid = v_fileID);
    insert into odmastcmp (BROKER_CODE,TRANS_TYPE,ST_CODE,CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,GROSS_AMOUNT,
                COMMISSION_FEE,TAX,NET_AMOUNT,DELTD,STATUS,ERRMSG,FILEID,TLIDIMP,ISCOMPARE,TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,ISODMAST,CITAD,IDENTITY,VIA)
    select trim(broker) BROKER_CODE,type TRANS_TYPE,trim(fund_code) ST_CODE,trim(fund_code) CUSTODYCD,trim(ticker_code) SEC_ID,
                --to_char(to_date(TRADE_DATE,'DD/MM/RRRR'),'DD/MM/RRRR') TRADE_DATE,
                to_char(to_date(TRADE_DATE,'DD/MM/RRRR hh24:mi:ss'),'DD/MM/RRRR') TRADE_DATE,
                to_char(to_date(original_settle_date,'DD/MM/RRRR hh24:mi:ss'),'DD/MM/RRRR') SETTLE_DATE,
                --to_char(to_date(original_settle_date,'DD/MM/RRRR'),'DD/MM/RRRR') SETTLE_DATE,
                QUANTITY,PRICE, principal_amount GROSS_AMOUNT,
                commission COMMISSION_FEE,tax_order_fee TAX,net_proceeds NET_AMOUNT,'N' DELTD,STATUS,ERRMSG,
                v_fileID FILEID,TLIDIMP,ISCOMPARE,sysdate TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,'N' ISODMAST,CITAD,IDENTITY,l_VIA
    from ODMASTCMP_TEMP_2
    where fileid = v_fileID
    and NVL(STATUS, 'P') <> 'E';

    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI068_2');
exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI068_2');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI068_2;

PROCEDURE PR_FILLTER_TBLI068_3(p_tlid in varchar2, p_fileid in varchar2,  p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 3 cua Cty CK
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_fileID    varchar2(100);
v_tlid varchar2(100);
BEGIN
    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI068_3');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';
    v_fileID := p_fileid;
    v_tlid:= p_tlid;
    /*
    begin
        PR_CHECK_I068_3(v_tlid , v_fileID, p_err_code  ,p_err_message );
    end;
    */
    --TruongLD add 21/01/2020, da sinh lenh vao odmast --> khong duoc xoa'
    --delete odmastcmp where isodmast <> 'Y' and broker_code in(select broker from odmastcmp_temp_3);
    --Trung.luu 23/03/2020: bo rule ghi de lenh import, khong update deltd
    --Update odmastcmp set deltd ='Y' where isodmast <> 'Y' and broker_code in(select broker from odmastcmp_temp_3 where fileid = v_fileID);
    --update ODMASTCMP_TEMP_3 set isodmast = 'N';
    insert into odmastcmp (BROKER_CODE,TRANS_TYPE,ST_CODE,CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,GROSS_AMOUNT,
                COMMISSION_FEE,TAX,NET_AMOUNT,DELTD,STATUS,ERRMSG,FILEID,TLIDIMP,ISCOMPARE,TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,ISODMAST,CITAD,IDENTITY)
    select trim(broker) broker_code,order_type trans_type,trim(custody_id) st_code,trim(custody_id) custodycd,trim(stock_name) sec_id,
                to_char(to_date(trading_date,'DD/MM/RRRR hh24:mi:ss'),'DD/MM/RRRR') TRADE_DATE,
                to_char(to_date(settlement_date,'DD/MM/RRRR hh24:mi:ss'),'DD/MM/RRRR') settle_date,
                qty quantity,price price, amount gross_amount,
                commission COMMISSION_FEE,pit TAX,net_settlement_amount NET_AMOUNT,'N' DELTD,STATUS,ERRMSG,
                v_fileID FILEID,
                TLIDIMP,ISCOMPARE,sysdate TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,'N' ISODMAST,CITAD,IDENTITY
    from odmastcmp_temp_3
    where fileid = v_fileID
    and NVL(STATUS, 'P') <> 'E';

    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI068_3');

exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI068_3');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI068_3;

PROCEDURE PR_COMPARE_TRADING_RESULT(p_tlid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
L_COUNT number;
L_orderid VARCHAR2(20);
l_prefix  VARCHAR2(20);
L_BrokerCount number;
L_ClientCount number;
L_VSDCount number;
L_note varchar2(250);
v_brokername varchar2(100);
v_count_client number;
v_count_broker number;
v_danhdau varchar2(5);
v_count_cp_client number;
v_count_cp_broker number;
v_count_cp_vsd number;
v_COMPANYCD varchar2(100);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_COMPARE_TRADING_RESULT');
        -- CLEAR DATA TABLEL RESULT
    --DELETE FROM COMPARE_TRADING_RESULT;
    Begin
        select varvalue into v_COMPANYCD from sysvar where varname='COMPANYCD' and grname='SYSTEM';
    exception
        when others then v_COMPANYCD := 'SHV';
    End;

    --
    Select NVL(Count(*),0) into L_BrokerCount from ODMASTCMP;
    Select NVL(Count(*),0) into L_ClientCount from ODMASTCUST;
    Select NVL(Count(*),0) into L_VSDCount from ODMASTVSD;

    select count(iscompare) into v_count_cp_client from ODMASTCUST where iscompare ='N' and deltd <> 'Y';
    select count(iscompare) into v_count_cp_broker from ODMASTCMP where iscompare ='N' and deltd <> 'Y';
    select count(iscompare) into v_count_cp_vsd from ODMASTVSD where iscompare ='N' and deltd <> 'Y';
    --plog.error('SL VSD ='||L_VSDCount||',SL BR ='||L_BrokerCount||', SL CL = '||L_ClientCount);
    --plog.error('CLIENT ONLY');
    --
--TH IMPORT CLIENT TRUOC VA MUON XEM DU LIEU DA GHI NHAN TRONG MAN HINH DOI CHIEU ( TRANG THAI CLIENT ONLY)
    IF L_ClientCount > 0 AND L_BrokerCount = 0 AND L_VSDCount = 0 THEN
          UPDATE odmastcust  SET  custodycd = (SELECT CUSTODYCD   FROM CFMAST WHERE  tradingcode = odmastcust.st_code )
          WHERE deltd <> 'Y' and INSTR (st_code,v_COMPANYCD)=0;
          UPDATE  odmastcust  SET  custodycd = st_code,st_code=''
          WHERE deltd <> 'Y' and INSTR (st_code,v_COMPANYCD)>0;

          FOR REC IN (
              SELECT broker_code, custodycd, sec_id ,st_code ,trans_type, --DECODE  (trans_type,'RVP','NB','NS') trans_type,
                      TO_DATE (trade_date,'DD/MM/YYYY') trade_date,
                      TO_DATE (settle_date,'DD/MM/YYYY') settle_date,quantity qtty_cust,price price_cust,broker_code member_cust, commission_fee fee_cust, tax tax_cust
                  FROM odmastcust
                  WHERE deltd <> 'Y' and iscompare <> 'Y' and custodycd is not null and errmsg is  null)
          LOOP
                    SELECT NVL(COUNT(*),0) INTO L_COUNT
                    FROM  compare_trading_result
                    WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                    and sec_id = REC.sec_id AND trade_date = REC.trade_date
                    AND price_cust = REC.price_cust AND QTTY_CUST = REC.qtty_cust
                    ;

                    If L_COUNT  = 0 then
                      --plog.error('CLIENT ONLY ='||REC.broker_code);
                      INSERT INTO compare_trading_result (MEMBER_CUST,CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CUST,QTTY_CUST,PRICE_CUST,FEE_CUST,TAX_CUST,LASTCHANGE, NOTE)
                      VALUES(REC.broker_code,REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.QTTY_CUST,REC.PRICE_CUST,REC.FEE_CUST,REC.TAX_CUST,sysdate,'CLIENT ONLY' );
                      update odmastcust
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                    end if;
                    v_danhdau := 'C';
          END LOOP ;
    END IF;
--TH IMPORT BROKER TRUOC VA MUON XEM DU LIEU DA GHI NHAN TRONG MAN HINH DOI CHIEU ( TRANG THAI BROKER ONLY)
    IF   L_BrokerCount > 0 AND L_ClientCount = 0 AND L_VSDCount = 0 THEN
        UPDATE  odmastcmp  SET  custodycd = (SELECT CUSTODYCD   FROM CFMAST WHERE  tradingcode = odmastcmp.st_code )
        WHERE deltd <> 'Y' and INSTR (st_code,v_COMPANYCD)=0;
        UPDATE  odmastcmp  SET  custodycd = st_code,st_code=''
        WHERE deltd <> 'Y' and INSTR (st_code,v_COMPANYCD)>0;

        FOR REC IN (
             SELECT custodycd, sec_id ,st_code ,trans_type, --DECODE  (trans_type,'RVP','NB','NS') trans_type,
                    TO_DATE (trade_date,'DDMMYYYY') trade_date,
                    TO_DATE (settle_date,'DDMMYYYY') settle_date,quantity qtty_cmp,price price_cmp,broker_code member_cmp, commission_fee fee_cmp, tax tax_cmp
                FROM odmastcmp
                WHERE deltd <> 'Y' AND ISCOMPARE <> 'Y' and custodycd is not null and errmsg is  null
        )
        LOOP
            SELECT NVL(COUNT(*),0) INTO L_COUNT
            FROM  compare_trading_result
            WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
            AND sec_id = REC.sec_id AND trade_date = REC.trade_date
            AND QTTY_CMP = REC.qtty_cmp AND price_cmp = REC.price_cmp;
            --plog.error('BROKER ONLY ='||L_COUNT);
            IF L_COUNT = 0 THEN
                INSERT INTO compare_trading_result (CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CMP,QTTY_CMP,PRICE_CMP,MEMBER_CMP,FEE_CMP,TAX_CMP,LASTCHANGE,NOTE)
                VALUES(REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.QTTY_CMP,REC.PRICE_CMP,REC.MEMBER_CMP,REC.FEE_CMP,REC.TAX_CMP,sysdate,'BROKER ONLY' );
                update odmastcmp
                        set iscompare = 'Y'
                         WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id AND trade_date = REC.trade_date;
            END IF;
            v_danhdau := 'B';
        END LOOP ;
    END IF;


--KHI IMPORT FILE TU CLIENT VA BROKER
        IF L_ClientCount > 0 AND L_BrokerCount > 0 AND (L_VSDCount = 0 or L_VSDCount > 0) THEN
   --Xu ly so lenh cong ty chung khoan
            --plog.error('Vao day roi ne');
                FOR REC IN (
                     SELECT custodycd, sec_id ,st_code ,trans_type, --DECODE  (trans_type,'RVP','NB','NS') trans_type,
                            TO_DATE (trade_date,'DD/MM/YYYY') trade_date,
                            TO_DATE (settle_date,'DD/MM/YYYY') settle_date,quantity qtty_cmp,price price_cmp,broker_code member_cmp, commission_fee fee_cmp, tax tax_cmp
                        FROM odmastcmp
                        WHERE deltd <> 'Y' AND ISCOMPARE <> 'Y' and custodycd is not null and errmsg is  null
                )
                LOOP
                    SELECT NVL(COUNT(*),0) INTO L_COUNT FROM  compare_trading_result
                    WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                    AND sec_id = REC.sec_id
                    AND trade_date = REC.trade_date --and  price_cmp=0 and qtty_cmp = 0
                    --and (REC.price_cmp= price_cmp and REC.qtty_cmp=qtty_cmp)
                    ;
                    IF L_COUNT = 0 THEN
                        INSERT INTO compare_trading_result (CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CMP,QTTY_CMP,PRICE_CMP,MEMBER_CMP,FEE_CMP,TAX_CMP,LASTCHANGE,NOTE)
                        VALUES(REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.QTTY_CMP,REC.PRICE_CMP,REC.MEMBER_CMP,REC.FEE_CMP,REC.TAX_CMP,sysdate,'BROKER ONLY' );
                        update odmastcmp
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                    ELSE
                        UPDATE compare_trading_result SET QTTY_CMP = REC.QTTY_CMP , PRICE_CMP = REC.PRICE_CMP ,
                        MEMBER_CMP= REC.MEMBER_CMP,FEE_CMP=REC.FEE_CMP,TAX_CMP=REC.TAX_CMP,lastchange =sysdate
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id --and  price_cmp=0 and qtty_cmp = 0
                        AND trade_date = REC.trade_date and rownum=1 ;

                        UPDATE compare_trading_result SET
                        note = case when FEE_CUST <> FEE_CMP then 'FEE mismatch between BROKER and CLIENT'
                                    when TAX_CUST <> TAX_CMP then 'TAX mismatch between BROKER and CLIENT'
                                    when SETTLE_DATE_CUST <> SETTLE_DATE_CMP then 'SETTLE DATE mismatch between BROKER and CLIENT'
                                     else 'Client matched, Broker matched' end
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id
                        AND trade_date = REC.trade_date
                        and (price_cust= REC.price_cmp and qtty_cust=REC.qtty_cmp)
                        and rownum=1  ;

                        update odmastcust
                            set iscompare = 'Y'
                                where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                    and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                    END IF;
                END LOOP ;
   --END Xu ly so lenh cong ty chung khoan
   --Xu ly so lenh khach hang
                FOR REC IN (
                    SELECT  custodycd, sec_id ,st_code ,trans_type, --DECODE  (trans_type,'RVP','NB','NS') trans_type,
                            TO_DATE (trade_date,'DD/MM/YYYY') trade_date,
                            TO_DATE (settle_date,'DD/MM/YYYY') settle_date,quantity qtty_cust,price price_cust,broker_code member_cust, commission_fee fee_cust, tax tax_cust
                        FROM odmastcust
                        WHERE deltd <> 'Y' AND ISCOMPARE <> 'Y' and custodycd is not null and errmsg is  null)
                LOOP
                    SELECT NVL(COUNT(*),0) INTO L_COUNT
                    FROM  compare_trading_result
                    WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                    AND sec_id = REC.sec_id  AND trade_date = REC.trade_date
                    --and price_cust=0 and qtty_cust = 0
                    --and (price_cmp= REC.price_cust and qtty_cmp=REC.qtty_cust)

                    ;

                    IF L_COUNT = 0 THEN
                        INSERT INTO compare_trading_result (CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CUST,QTTY_CUST,PRICE_CUST,MEMBER_CUST,FEE_CUST,TAX_CUST,LASTCHANGE, NOTE)
                        VALUES(REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.QTTY_CUST,REC.PRICE_CUST,REC.member_cust,REC.FEE_CUST,REC.TAX_CUST,sysdate,'CLIENT ONLY' );
                        update odmastcust
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                    ELSE
                        UPDATE compare_trading_result SET QTTY_CUST = REC.QTTY_CUST , PRICE_CUST = REC.PRICE_CUST ,
                        MEMBER_CUST= REC.member_cust,FEE_CUST = REC.FEE_CUST,TAX_CUST=REC.TAX_CUST,lastchange = sysdate, SETTLE_DATE_CUST=REC.SETTLE_DATE,note=''
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id
                        AND trade_date = REC.trade_date --and  price_cust=0 and qtty_cust = 0
                        and (price_cmp= REC.price_cust and qtty_cmp=REC.qtty_cust)
                        and rownum=1  ;

                        update odmastcust
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                        -- case rownum=1 cho truong hop nhieu deal cung gia cung khoi luong

                        UPDATE compare_trading_result SET
                        note = case when FEE_CUST <> FEE_CMP then 'FEE mismatch between BROKER and CLIENT'
                                    when TAX_CUST <> TAX_CMP then 'TAX mismatch between BROKER and CLIENT'
                                    when SETTLE_DATE_CUST <> SETTLE_DATE_CMP then 'SETTLE DATE mismatch between BROKER and CLIENT'
                                     else 'Client matched, Broker matched' end
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id
                        AND trade_date = REC.trade_date
                        and (price_cust= REC.price_cust and qtty_cust=REC.qtty_cust)
                        and rownum=1  ;
                    END IF;

                END LOOP;
                UPDATE compare_trading_result
                    SET STATUS ='T'
                        WHERE   QTTY_CMP=QTTY_CUST
                            AND AMT_CMP=AMT_CUST ;
                UPDATE compare_trading_result
                    SET STATUS = 'F'
                        WHERE NOTE IS NULL;
   --END Xu ly so lenh khach hang
        END IF;
--KHI IMPORT FILE TU BROKER VA VSD
        IF L_BrokerCount > 0 AND L_VSDCount > 0 AND L_ClientCount = 0 THEN
   --Xu ly so lenh cong ty chung khoan
            UPDATE  odmastcmp  SET  custodycd = (SELECT CUSTODYCD   FROM CFMAST WHERE  tradingcode = odmastcmp.st_code )
            WHERE deltd <> 'Y' and INSTR (st_code,v_COMPANYCD)=0;

            UPDATE  odmastcmp  SET  custodycd = st_code,st_code=''
            WHERE deltd <> 'Y' and INSTR (st_code,v_COMPANYCD)>0;


            FOR REC IN (
                 SELECT custodycd, sec_id ,st_code , trans_type,--DECODE  (trans_type,'RVP','NB','NS') trans_type,
                        TO_DATE (trade_date,'DD/MM/YYYY') trade_date,
                        TO_DATE (settle_date,'DD/MM/YYYY') settle_date,quantity qtty_cmp,price price_cmp,broker_code member_cmp, commission_fee fee_cmp, tax tax_cmp
                    FROM odmastcmp
                    WHERE deltd <> 'Y' AND ISCOMPARE <>'Y' and custodycd is not null
            )
            LOOP
                SELECT NVL(COUNT(*),0) INTO L_COUNT FROM  compare_trading_result
                WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                AND sec_id = REC.sec_id
                AND trade_date = REC.trade_date --and  price_cmp=0 and qtty_cmp = 0
                ;
                IF L_COUNT = 0 THEN
                    INSERT INTO compare_trading_result (CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CMP,QTTY_CMP,PRICE_CMP,MEMBER_CMP,FEE_CMP,TAX_CMP,LASTCHANGE,NOTE)
                    VALUES(REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.QTTY_CMP,REC.PRICE_CMP,REC.MEMBER_CMP,REC.FEE_CMP,REC.TAX_CMP,sysdate,'BROKER ONLY' );
                    update odmastcmp
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                ELSE
                    UPDATE compare_trading_result SET QTTY_CMP = REC.QTTY_CMP , PRICE_CMP = REC.PRICE_CMP ,
                    MEMBER_CMP= REC.MEMBER_CMP,FEE_CMP=REC.FEE_CMP,TAX_CMP=REC.TAX_CMP,lastchange =sysdate
                    WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                    AND sec_id = REC.sec_id and  price_cmp=0 and qtty_cmp = 0
                    AND trade_date = REC.trade_date and rownum=1 ;

                    update odmastcust
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                END IF;
            END LOOP ;
   --END Xu ly so lenh cong ty chung khoan
   --Xu ly so lenh vsd
              UPDATE  odmastvsd SET trans_type= CASE WHEN  quantitys >0 THEN 'NS' ELSE 'NB'  END ,quantity =  quantityb + quantitys;
              FOR REC IN (
                   /*SELECT o.custodycd, o.sec_id ,o.st_code , o.trans_type,
                          o.trade_date trade_date,  o.settle_date,o.quantity qtty_vsd,o.price price_vsd, m.shortname member_vsd
                      FROM odmastvsd o, deposit_member m
                      WHERE o.deltd <> 'Y' and m.depositid =o.broker_code*/
                      SELECT o.custodycd, o.sec_id ,o.st_code , o.trans_type,
                           o.trade_date trade_date,  o.settle_date,o.quantity qtty_vsd,o.price price_vsd, o.broker_code
                       FROM odmastvsd o
                       WHERE o.deltd <> 'Y'

                      )
              LOOP


                    /*v_brokername := '';
                    --lay ten CTCK
                    select NVL(m.shortname,'') into v_brokername
                        from deposit_member m
                            where m.depositid  = rec.broker_code;*/
                  SELECT NVL(COUNT(*),0) INTO L_COUNT FROM  compare_trading_result
                  WHERE (custodycd = REC.custodycd or CUSTODYCD = REC.st_code) AND trans_type = REC.trans_type
                  AND sec_id = REC.sec_id --and  price_vsd=0 and qtty_vsd = 0
                   --and (price_cmp= REC.price_vsd and qtty_cmp=REC.qtty_vsd)
                  AND trade_date = REC.trade_date ;


                  IF L_COUNT = 0 THEN
                      INSERT INTO compare_trading_result (CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CUST,MEMBER_VSD,QTTY_VSD,PRICE_VSD,LASTCHANGE,NOTE)
                      VALUES(REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.broker_code,REC.QTTY_VSD,REC.PRICE_VSD,sysdate ,'VSD ONLY');

                  ELSE
                      UPDATE compare_trading_result  SET QTTY_VSD = REC.QTTY_VSD,MEMBER_VSD =REC.broker_code , PRICE_VSD = REC.PRICE_VSD ,
                       lastchange = sysdate
                       WHERE (custodycd = REC.custodycd or CUSTODYCD = REC.st_code) AND trans_type = REC.trans_type
                       AND sec_id = REC.sec_id
                       and (price_cmp= REC.price_vsd and qtty_cmp=REC.qtty_vsd)
                       AND trade_date = REC.trade_date --and  price_vsd=0 and qtty_vsd = 0
                       and rownum=1  ;

                       -- case rownum=1 cho truong hop nhieu deal cung gia cung khoi luong

                       UPDATE compare_trading_result  SET
                        note = case when (MEMBER_VSD <> MEMBER_CMP ) then note||',BROKER mismatch VSD in Broker name'
                                  when (MEMBER_VSD <> MEMBER_CUST ) then  'CLIENT mismatch VSD in Broker name'
                                  when (QTTY_VSD <>  qtty_cmp ) then 'BROKER mismatch VSD in quantity '
                                  else 'Broker matched, VSD matched' end
                     WHERE (custodycd = REC.custodycd or CUSTODYCD = REC.st_code) AND trans_type = REC.trans_type
                     AND sec_id = REC.sec_id
                     and (price_vsd= REC.price_vsd and qtty_vsd=REC.qtty_vsd)
                     AND trade_date = REC.trade_date
                     and rownum=1  ;

                    update odmastcust
                        set iscompare = 'Y'
                            where (custodycd = REC.custodycd or CUSTODYCD = REC.st_code) AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;

                  END IF;
              END LOOP ;
              UPDATE compare_trading_result
                SET STATUS ='T'
                    WHERE   QTTY_VSD=QTTY_CMP
                        AND AMT_VSD = AMT_CMP;
              UPDATE compare_trading_result
                    SET STATUS = 'F'
                        WHERE NOTE IS NULL;
   --END Xu ly so lenh VSD
        END IF;
       SELECT COUNT(*) INTO L_note FROM compare_trading_result WHERE INSTR(NOTE, 'VSD matched') > 0;
--KHI IMPORT FILE TU CLIENT, BROKER VA VSD
        --TH VSD vao sau
      IF L_BrokerCount > 0 AND L_VSDCount > 0 AND L_ClientCount > 0THEN
      --Xu ly so lenh khach hang
                FOR REC IN (
                    SELECT  custodycd, sec_id ,st_code ,trans_type, --DECODE  (trans_type,'RVP','NB','NS') trans_type,
                            TO_DATE (trade_date,'DD/MM/YYYY') trade_date,
                            TO_DATE (settle_date,'DD/MM/YYYY') settle_date,quantity qtty_cust,price price_cust,broker_code member_cust, commission_fee fee_cust, tax tax_cust
                        FROM odmastcust
                        WHERE deltd <> 'Y' AND ISCOMPARE <> 'Y' and custodycd is not null and errmsg is  null)
                LOOP
                    SELECT NVL(COUNT(*),0) INTO L_COUNT
                    FROM  compare_trading_result
                    WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                    AND sec_id = REC.sec_id  AND trade_date = REC.trade_date
                    --and price_cust=0 and qtty_cust = 0
                    --and (price_cmp= REC.price_cust and qtty_cmp=REC.qtty_cust)

                    ;

                    IF L_COUNT = 0 THEN
                        INSERT INTO compare_trading_result (CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CUST,QTTY_CUST,PRICE_CUST,MEMBER_CUST,FEE_CUST,TAX_CUST,LASTCHANGE, NOTE)
                        VALUES(REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.QTTY_CUST,REC.PRICE_CUST,REC.member_cust,REC.FEE_CUST,REC.TAX_CUST,sysdate,'CLIENT ONLY' );
                        update odmastcust
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                    ELSE
                        UPDATE compare_trading_result SET QTTY_CUST = REC.QTTY_CUST , PRICE_CUST = REC.PRICE_CUST ,
                        MEMBER_CUST= REC.member_cust,FEE_CUST = REC.FEE_CUST,TAX_CUST=REC.TAX_CUST,lastchange = sysdate, SETTLE_DATE_CUST=REC.SETTLE_DATE,note=''
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id
                        AND trade_date = REC.trade_date --and  price_cust=0 and qtty_cust = 0
                        and (price_cmp= REC.price_cust and qtty_cmp=REC.qtty_cust)
                        and rownum=1  ;

                        update odmastcust
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                        -- case rownum=1 cho truong hop nhieu deal cung gia cung khoi luong

                        UPDATE compare_trading_result SET
                        note = case when FEE_CUST <> FEE_CMP then 'FEE mismatch between BROKER and CLIENT'
                                    when TAX_CUST <> TAX_CMP then 'TAX mismatch between BROKER and CLIENT'
                                    when SETTLE_DATE_CUST <> SETTLE_DATE_CMP then 'SETTLE DATE mismatch between BROKER and CLIENT'
                                     else 'Client matched, Broker matched' end
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id
                        AND trade_date = REC.trade_date
                        and (price_cust= REC.price_cust and qtty_cust=REC.qtty_cust)
                        and rownum=1  ;
                    END IF;

                END LOOP;
                UPDATE compare_trading_result
                    SET STATUS ='T'
                        WHERE   QTTY_CMP=QTTY_CUST
                            AND AMT_CMP=AMT_CUST ;
                UPDATE compare_trading_result
                    SET STATUS = 'F'
                        WHERE NOTE IS NULL;
   --END Xu ly so lenh khach hang
   --Xu ly so lenh cong ty chung khoan
            --plog.error('Vao day roi ne');
                FOR REC IN (
                     SELECT custodycd, sec_id ,st_code ,trans_type, --DECODE  (trans_type,'RVP','NB','NS') trans_type,
                            TO_DATE (trade_date,'DD/MM/YYYY') trade_date,
                            TO_DATE (settle_date,'DD/MM/YYYY') settle_date,quantity qtty_cmp,price price_cmp,broker_code member_cmp, commission_fee fee_cmp, tax tax_cmp
                        FROM odmastcmp
                        WHERE deltd <> 'Y' AND ISCOMPARE <> 'Y' and custodycd is not null and errmsg is  null
                )
                LOOP
                    SELECT NVL(COUNT(*),0) INTO L_COUNT FROM  compare_trading_result
                    WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                    AND sec_id = REC.sec_id
                    AND trade_date = REC.trade_date --and  price_cmp=0 and qtty_cmp = 0
                    --and (REC.price_cmp= price_cmp and REC.qtty_cmp=qtty_cmp)
                    ;
                    IF L_COUNT = 0 THEN
                        INSERT INTO compare_trading_result (CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CMP,QTTY_CMP,PRICE_CMP,MEMBER_CMP,FEE_CMP,TAX_CMP,LASTCHANGE,NOTE)
                        VALUES(REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.QTTY_CMP,REC.PRICE_CMP,REC.MEMBER_CMP,REC.FEE_CMP,REC.TAX_CMP,sysdate,'BROKER ONLY' );
                        update odmastcmp
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                    ELSE
                        UPDATE compare_trading_result SET QTTY_CMP = REC.QTTY_CMP , PRICE_CMP = REC.PRICE_CMP ,
                        MEMBER_CMP= REC.MEMBER_CMP,FEE_CMP=REC.FEE_CMP,TAX_CMP=REC.TAX_CMP,lastchange =sysdate
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id --and  price_cmp=0 and qtty_cmp = 0
                        AND trade_date = REC.trade_date and rownum=1 ;

                        UPDATE compare_trading_result SET
                        note = case when FEE_CUST <> FEE_CMP then 'FEE mismatch between BROKER and CLIENT'
                                    when TAX_CUST <> TAX_CMP then 'TAX mismatch between BROKER and CLIENT'
                                    when SETTLE_DATE_CUST <> SETTLE_DATE_CMP then 'SETTLE DATE mismatch between BROKER and CLIENT'
                                     else 'Client matched, Broker matched' end
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id
                        AND trade_date = REC.trade_date
                        and (price_cust= REC.price_cmp and qtty_cust=REC.qtty_cmp)
                        and rownum=1  ;

                        update odmastcust
                            set iscompare = 'Y'
                                where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                    and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                    END IF;
                END LOOP ;
   --END Xu ly so lenh cong ty chung khoan
   --Xu ly so lenh VSD
               --plog.error('VSD VAO SAU ROI');
               UPDATE  odmastvsd SET trans_type= CASE WHEN  quantitys >0 THEN 'NS' ELSE 'NB'  END ,quantity =  quantityb + quantitys WHERE quantity IS NULL;

               FOR REC IN (
                    SELECT o.custodycd, o.sec_id ,o.st_code , o.trans_type,
                           o.trade_date trade_date,  o.settle_date,o.quantity qtty_vsd,o.price price_vsd, o.broker_code
                       FROM odmastvsd o
                       WHERE o.deltd <> 'Y' and iscompare <> 'Y' )
               LOOP

                    /*v_brokername := '';
                    --lay ten CTCK
                    select NVL(m.shortname,'') into v_brokername
                        from deposit_member m
                            where m.depositid  = rec.broker_code;*/

                   --count trong bang ket qua doi chieu
                   SELECT NVL(COUNT(*),0) INTO L_COUNT FROM  compare_trading_result
                   WHERE (custodycd = REC.custodycd OR CUSTODYCD = REC.st_code) AND trans_type = REC.trans_type
                   AND sec_id = REC.sec_id
                   AND trade_date = REC.trade_date ;

                   
                   IF L_COUNT = 0 THEN
                       INSERT INTO compare_trading_result (CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CUST,MEMBER_VSD,QTTY_VSD,PRICE_VSD,LASTCHANGE,NOTE)
                    VALUES(REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.broker_code,REC.QTTY_VSD,REC.PRICE_VSD,sysdate ,'VSD ONLY');

                   ELSE
                       UPDATE compare_trading_result  SET QTTY_VSD = REC.QTTY_VSD,MEMBER_VSD =REC.broker_code , PRICE_VSD = REC.PRICE_VSD ,
                        lastchange = sysdate
                        WHERE (custodycd = REC.custodycd or CUSTODYCD = REC.st_code)  AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id
                        --and ((price_cmp= REC.price_vsd and qtty_cmp=REC.qtty_vsd)or (price_cust= REC.price_vsd and qtty_cust=REC.qtty_vsd))
                        AND trade_date = REC.trade_date-- and  price_vsd=0 and qtty_vsd = 0
                        and rownum=1  ;

                        -- case rownum=1 cho truong hop nhieu deal cung gia cung khoi luong

                        UPDATE compare_trading_result  SET
                       note = case when (MEMBER_VSD <> MEMBER_CMP and instr(note,'ONLY')=0) then note||',BROKER mismatch VSD in Broker name'
                                   when (MEMBER_VSD <> MEMBER_CUST and instr(note,'ONLY')>0) then  'CLIENT mismatch VSD in Broker name'
                                   when (QTTY_VSD <>  qtty_cmp ) then 'CLIENT and BROKER mismatch VSD in quantity '
                                   else 'Client matched, Broker matched, VSD matched' end
                      WHERE ( custodycd = REC.custodycd or CUSTODYCD = REC.st_code) AND trans_type = REC.trans_type
                      AND sec_id = REC.sec_id
                      --and (price_vsd= REC.price_vsd and qtty_vsd=REC.qtty_vsd)
                      AND trade_date = REC.trade_date
                      and rownum=1  ;


                      update odmastvsd
                        set iscompare = 'Y'
                            where (custodycd = REC.custodycd or CUSTODYCD = REC.st_code) AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;


                   END IF;
               END LOOP ;
               UPDATE compare_trading_result
                 SET STATUS ='T'
                     WHERE   QTTY_VSD=QTTY_CMP
                         AND QTTY_VSD=QTTY_CUST
                         AND AMT_VSD = AMT_CMP
                         AND AMT_VSD=AMT_CUST ;
               UPDATE compare_trading_result
                    SET STATUS = 'F'
                        WHERE NOTE IS NULL;

               --Loop trong bang compare neu nhu khop het thi clear data
               for C in (select NOTE from compare_trading_result)

               loop
                    IF INSTRC(C.NOTE,'Client matched, Broker matched, VSD matched') > 0 THEN
                        INSERT INTO ODMASTCMPHIST (SELECT * FROM ODMASTCMP where ISCOMPARE = 'N');
                        DELETE FROM ODMASTCMP where ISCOMPARE = 'N';

                        INSERT INTO ODMASTVSDHIST (SELECT * FROM ODMASTVSD where ISCOMPARE = 'N');
                        DELETE FROM ODMASTVSD where ISCOMPARE = 'N';

                        INSERT INTO ODMASTCUSTHIST (SELECT * FROM ODMASTCUST where ISCOMPARE = 'N');
                        DELETE FROM ODMASTCUST where ISCOMPARE = 'N';
                    END IF;
               end loop;


         --End xu ly so lenh vsd
    END IF;
    --TH Client vao sau
    IF L_BrokerCount > 0 AND L_VSDCount > 0 AND L_ClientCount > 0 AND L_note > 0 THEN
            
         --Xu ly so lenh khach hang
                UPDATE  odmastcust  SET  custodycd = (SELECT CUSTODYCD   FROM CFMAST WHERE  tradingcode = odmastcust.st_code )
                WHERE INSTR (st_code,'SHV')=0;
                UPDATE  odmastcust  SET  custodycd = st_code,st_code=''
                WHERE INSTR (st_code,'SHV')>0;

                FOR REC IN (
                    SELECT  custodycd, sec_id ,st_code , trans_type,
                            TO_DATE (trade_date,'DD/MM/YYYY') trade_date,
                            TO_DATE (settle_date,'DD/MM/YYYY') settle_date,quantity qtty_cust,price price_cust,broker_code member_cust, commission_fee fee_cust, tax tax_cust
                        FROM odmastcust
                        WHERE deltd <> 'Y' AND ISCOMPARE <> 'Y' and custodycd is not null)
                LOOP
                    SELECT NVL(COUNT(*),0) INTO L_COUNT
                    FROM  compare_trading_result
                    WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                    AND sec_id = REC.sec_id  AND trade_date = REC.trade_date
                    --and price_cust=0 and qtty_cust = 0
                    --and (price_cmp= REC.price_cust and qtty_cmp=REC.qtty_cust)
                    ;
                    --plog.error('count ='||L_COUNT||',Tax moi = '||REC.TAX_CUST);
                    IF L_COUNT = 0 THEN
                        INSERT INTO compare_trading_result (CUSTODYCD,ST_CODE,TRANS_TYPE,SEC_ID,TRADE_DATE,SETTLE_DATE_CUST,QTTY_CUST,PRICE_CUST,FEE_CUST,TAX_CUST,LASTCHANGE, NOTE)
                        VALUES(REC.custodycd ,REC.ST_CODE,REC.TRANS_TYPE,REC.SEC_ID,REC.TRADE_DATE,REC.SETTLE_DATE,REC.QTTY_CUST,REC.PRICE_CUST,REC.FEE_CUST,REC.TAX_CUST,sysdate,'CLIENT ONLY' );
                    ELSE
                        UPDATE compare_trading_result SET QTTY_CUST = REC.QTTY_CUST , PRICE_CUST = REC.PRICE_CUST ,
                        FEE_CUST = REC.FEE_CUST,TAX_CUST=REC.TAX_CUST,lastchange = sysdate, SETTLE_DATE_CUST=REC.SETTLE_DATE,note=''
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id
                        AND trade_date = REC.trade_date --and  price_cust=0 and qtty_cust = 0
                        --and (price_cmp= REC.price_cust and qtty_cmp=REC.qtty_cust)
                        and rownum=1  ;
                        -- case rownum=1 cho truong hop nhieu deal cung gia cung khoi luong

                        UPDATE compare_trading_result SET
                        note = case when FEE_CUST <> FEE_CMP then 'FEE mismatch between BROKER and CLIENT'
                                    when TAX_CUST <> TAX_CMP then 'TAX mismatch between BROKER and CLIENT'
                                    when SETTLE_DATE_CUST <> SETTLE_DATE_CMP then 'SETTLE DATE mismatch between BROKER and CLIENT'
                                     else 'Client matched, Broker matched, VSD matched' end
                        WHERE custodycd = REC.custodycd AND trans_type = REC.trans_type
                        AND sec_id = REC.sec_id
                        AND trade_date = REC.trade_date
                        and (price_cust= REC.price_cust and qtty_cust=REC.qtty_cust)
                        and rownum=1  ;
                        update odmastcust
                        set iscompare = 'Y'
                            where custodycd = REC.custodycd AND trans_type = REC.trans_type
                                and sec_id = REC.sec_id AND trade_date = REC.trade_date;
                    END IF;

                END LOOP ;
                UPDATE compare_trading_result
                    SET STATUS ='T'
                        WHERE   QTTY_CMP=QTTY_CUST
                            AND AMT_CMP=AMT_CUST ;
                UPDATE compare_trading_result
                    SET STATUS = 'F'
                        WHERE NOTE IS NULL;
                --Loop trong bang compare neu nhu khop het thi clear data
               for C in (select NOTE from compare_trading_result)

               loop
                    IF INSTRC(C.NOTE,'Client matched, Broker matched, VSD matched') > 0 THEN
                        INSERT INTO ODMASTCMPHIST (SELECT * FROM ODMASTCMP where ISCOMPARE = 'N');
                        DELETE FROM ODMASTCMP where ISCOMPARE = 'N';

                        INSERT INTO ODMASTVSDHIST (SELECT * FROM ODMASTVSD where ISCOMPARE = 'N');
                        DELETE FROM ODMASTVSD where ISCOMPARE = 'N';

                        INSERT INTO ODMASTCUSTHIST (SELECT * FROM ODMASTCUST where ISCOMPARE = 'N');
                        DELETE FROM ODMASTCUST where ISCOMPARE = 'N';
                    END IF;
               end loop;
        --END Xu ly so lenh khach hang
    END IF;

    UPDATE compare_trading_result SET STATUS ='F' WHERE STATUS IS NULL ;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';

    plog.setendsection(pkgctx, 'PR_COMPARE_TRADING_RESULT');

exception
when others then
    rollback;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
RETURN;
END PR_COMPARE_TRADING_RESULT;
PROCEDURE PR_FILLTER_TBLI071(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
L_CHECK NUMBER;
BEGIN
    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI071');
    --CHECK CUSTODYCD
    UPDATE TBLI071_TEMP SET DELTD = 'Y', ERRMSG = ERRMSG || 'So tai khoan khong ton tai hoac da dong! '
    WHERE FILEID = P_FILEID
    AND TRIM(CUSTODYCD) NOT IN (SELECT CUSTODYCD FROM CFMAST WHERE STATUS <> 'C');

    UPDATE TBLI071_TEMP SET DELTD = 'Y', ERRMSG = ERRMSG || 'Tai khoan khong luu ky tai cong ty! '
    WHERE FILEID = P_FILEID
    AND TRIM(CUSTODYCD) NOT IN (SELECT CUSTODYCD FROM CFMAST WHERE CUSTATCOM = 'N');
    --CHECK SYMBOL
    UPDATE TBLI071_TEMP SET DELTD = 'Y', ERRMSG = ERRMSG || 'Ma chung khoan khong dung! '
    WHERE FILEID = P_FILEID
    AND TRIM(SYMBOL) NOT IN (
        SELECT SEC.SYMBOL
        FROM SBSECURITIES SEC, SECURITIES_INFO SEINFO, ISSUERS ISS
        WHERE SEC.CODEID=SEINFO.CODEID
        AND SEC.ISSUERID= ISS.ISSUERID
        AND SEC.SECTYPE <> '004'
    );
    SELECT COUNT(1) INTO L_CHECK FROM (
        SELECT 1 FROM TBLI071_TEMP WHERE FILEID = P_FILEID GROUP BY TRIM(TXDATE)
    );
    IF L_CHECK > 1 THEN
        UPDATE TBLI071_TEMP SET DELTD = 'Y', ERRMSG = ERRMSG || 'Ngay dau vao khong hop le! ' WHERE FILEID = P_FILEID;
    END IF;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI071');
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI071');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI071;

PROCEDURE PR_FILE_TBLI071(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
    l_err_param     varchar2(500);
    v_strCURRDATE   varchar2(20);
    L_txnum         VARCHAR2(20);
    l_txmsg         tx.msg_rectype;
    L_CHECK         NUMBER;
    l_count         NUMBER;
BEGIN
    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI071');
    FOR RECTX IN (
        SELECT TXDATE FROM TBLI071_TEMP WHERE FILEID = P_FILEID AND NVL(DELTD,'N') <> 'Y' GROUP BY TXDATE
    )LOOP
        DELETE FROM SENOCUSTATCOM WHERE TXDATE = TO_DATE(RECTX.TXDATE,'DDMMRRRR');

        INSERT INTO SENOCUSTATCOM (ACTYPE, ACCTNO, CODEID, AFACCTNO, OPNDATE, LASTDATE, STATUS, CUSTID, TRADE, TXDATE)
        SELECT SE.ACTYPE, SE.ACCTNO, SE.CODEID, SE.AFACCTNO, SE.OPNDATE, SE.LASTDATE, SE.STATUS, SE.CUSTID, 0, TO_DATE(RECTX.TXDATE,'DDMMRRRR') TXDATE
        FROM SEMAST SE, CFMAST CF, AFMAST AF
        WHERE CF.CUSTID = AF.CUSTID
        AND AF.ACCTNO = SE.AFACCTNO
        AND CF.CUSTATCOM = 'N'
        AND CF.STATUS <> 'C';

        FOR REC IN (
            SELECT SB.CODEID, AF.ACCTNO, TMP.QTTY ,TMP.TXDATE, TMP.AUTOID, AFT.SETYPE, CF.CUSTID
            FROM TBLI071_TEMP TMP, CFMAST CF , SBSECURITIES SB, AFMAST AF, AFTYPE AFT
            WHERE TRIM(TMP.CUSTODYCD) = CF.CUSTODYCD
            AND TRIM(TMP.SYMBOL) = SB.SYMBOL
            AND CF.CUSTID = AF.CUSTID
            AND AF.ACTYPE = AFT.ACTYPE
            AND TMP.FILEID = p_fileid
            AND NVL(TMP.DELTD,'N') <> 'Y'
            AND CF.CUSTATCOM = 'N'
        )LOOP
            SELECT COUNT(1) INTO l_count FROM SEMAST WHERE ACCTNO = REC.ACCTNO || REC.CODEID;

            IF l_count = 0 THEN
                INSERT INTO SEMAST (ACTYPE,CUSTID,ACCTNO,CODEID,AFACCTNO,OPNDATE,LASTDATE,COSTDT,TBALDT,STATUS,IRTIED,IRCD,COSTPRICE,TRADE,MORTAGE,MARGIN,NETTING,STANDING,WITHDRAW,DEPOSIT,LOAN)
                VALUES(REC.SETYPE, REC.CUSTID, REC.ACCTNO || REC.CODEID, REC.CODEID, REC.ACCTNO,
                TO_DATE(RECTX.TXDATE,'DDMMRRRR'),TO_DATE(RECTX.TXDATE,'DDMMRRRR'),TO_DATE(RECTX.TXDATE,'DDMMRRRR'),TO_DATE(RECTX.TXDATE,'DDMMRRRR'),
                'A','Y','000', 0,0,0,0,0,0,0,0,0);

                INSERT INTO SENOCUSTATCOM (ACTYPE, ACCTNO, CODEID, AFACCTNO, OPNDATE, LASTDATE, STATUS, CUSTID, TRADE, TXDATE)
                SELECT SE.ACTYPE, SE.ACCTNO, SE.CODEID, SE.AFACCTNO, SE.OPNDATE, SE.LASTDATE, SE.STATUS, SE.CUSTID, 0, TO_DATE(RECTX.TXDATE,'DDMMRRRR') TXDATE
                FROM SEMAST SE
                WHERE SE.ACCTNO = REC.ACCTNO || REC.CODEID;
            END IF;

            UPDATE SENOCUSTATCOM SET TRADE = REC.QTTY WHERE ACCTNO = REC.ACCTNO || REC.CODEID AND TXDATE = TO_DATE(REC.TXDATE,'DDMMRRRR');

            UPDATE TBLI071_TEMP SET STATUS = 'A', DELTD = 'N', ERRMSG = ERRMSG || 'Success' WHERE AUTOID = REC.AUTOID;
        END LOOP;
    END LOOP;
    plog.setendsection(pkgctx, 'PR_FILE_TBLI071');
    p_err_message := 'SYSTEM_SUCCESS';
    p_err_code := systemnums.C_SUCCESS;
exception
when others then
      plog.debug (pkgctx,'error immporting');
      --ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'PR_FILE_TBLI071');
      RAISE errnums.E_SYSTEM_ERROR;
end PR_FILE_TBLI071;

PROCEDURE PR_FILE_TBLSE2245(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_codeid VARCHAR2(20);
BEGIN

v_codeid:= '';
v_count:=0;
--Cap nhat autoid
UPDATE tblse2245 SET autoid = seq_tblse2245.NEXTVAL;
-- CHECK MA CK
    FOR REC IN
    (SELECT * FROM TBLSE2245 )
    LOOP
    IF rec.symbol IS NOT NULL THEN
        select count(codeid) into v_count from sbsecurities WHERE symbol = rec.symbol;
        IF v_count = 0 THEN
          UPDATE TBLSE2245 SET deltd='Y' , errmsg =errmsg||'Error: Symbol not found!' WHERE autoid = rec.autoid;
          --RETURN;
        else
            SELECT codeid INTO v_codeid  FROM sbsecurities WHERE symbol = rec.symbol;

            IF length(v_codeid) > 0 THEN
        --Cap nhat codeid
                UPDATE tblse2245 SET codeid= v_codeid, acctno = afacctno || v_codeid  WHERE autoid = rec.autoid;
            ELSE
                UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
            END IF;

        END IF;
    ELSE
          UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
    END IF;
--Check so luu ky
IF rec.custodycd IS NOT NULL THEN
     SELECT count(custodycd) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd AND status <> 'C';
     IF v_count = 0 THEN
          UPDATE TBLSE2245 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check so tieu
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.afacctno AND status = 'A';
     IF v_count = 0 THEN
          UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check  tieu khoan co phai thuoc so Luu ky
     SELECT count(acctno) INTO v_count FROM afmast af, cfmast cf
     WHERE  af.custid = cf.custid
     AND cf.custodycd = rec.custodycd
     AND af.acctno = rec.afacctno;
     IF v_count = 0 THEN
          UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;

ELSE
        UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
END IF ;

IF rec.amt + rec.depoblock <= 0 THEN
    UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: Quantity invalid!' WHERE autoid = rec.autoid;
END IF;


END LOOP;


    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLSE2245;
--------------------------------------------IMPORT ETF--------------------------------------------------
PROCEDURE PR_ETFRESULT_TEMP(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2)
IS
    V_COUNT         NUMBER;
    L_ISERR         VARCHAR2(10);
    V_STRCURRDATE   VARCHAR2(20);
    V_MBID          VARCHAR2(10);
    V_SERCURITIES   VARCHAR2(50);
    V_SECQTTY       NUMBER;
    V_SECVALUE      NUMBER;
    V_FILEID        VARCHAR2(20);
    L_VIA           VARCHAR2(5);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_ETFRESULT_TEMP');
    V_COUNT := 0;
    -------------------------------

    V_FILEID := P_FILEID;

    -------------------------------
    L_ISERR := 'N';
    -------------------------------
    If P_TLID ='6868' then
        L_VIA := 'O';
    Else
        L_VIA := 'F';
    End If;
    -------------------------------
    BEGIN
        CSPKS_ODPROC.PR_AUTO_8894(V_FILEID,P_TLID,L_VIA,P_ERR_CODE => P_ERR_CODE);
        
        if(P_ERR_CODE<>SYSTEMNUMS.C_SUCCESS) then
            P_ERR_MESSAGE := CSPKS_SYSTEM.FN_GET_ERRMSG(P_ERR_CODE);
            --ROLLBACK;
            RETURN;
        end if;

    EXCEPTION
    WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX,
                   'LOI = ' || P_ERR_CODE || ' ERR ' || SQLERRM ||
                   ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        L_ISERR  := 'Y';
        --ROLLBACK;
    END ;
    -------------------------------
    IF L_ISERR = 'N' THEN
        UPDATE ETFRESULT_TEMP
        SET STATUS = 'C', ovrstatus ='Y', ERRMSG = 'Sucessfull' where fileid = V_FILEID;
        -------------------------------
        UPDATE FILEIMPORT T
        SET T.STATUS = 'A', T.LASTCHANGE = SYSDATE WHERE T.FILEID = V_FILEID;
        -------------------------------
        INSERT INTO ETFRESULT_TEMPHIST SELECT * FROM ETFRESULT_TEMP where fileid = V_FILEID;
        DELETE FROM ETFRESULT_TEMP where fileid = V_FILEID;
        P_ERR_CODE    := SYSTEMNUMS.C_SUCCESS;
        P_ERR_MESSAGE := 'Sucessfull!';
     ELSE
        P_ERR_CODE    := -100129; --LOI DUYET FILE
        P_ERR_MESSAGE := CSPKS_SYSTEM.FN_GET_ERRMSG(P_ERR_CODE);
        --ROLLBACK;
        UPDATE TLLOG SET TXSTATUS = '2', deltd = 'Y' ;--WHERE MSGACCT = P_FILEID;
        --COMMIT;
        RETURN;
     END IF;

EXCEPTION
     WHEN OTHERS THEN
        --ROLLBACK;
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'System error. Invalid file format';
        plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
        RETURN;
END PR_ETFRESULT_TEMP;


PROCEDURE PR_FILLTER_TBLI069_4web(
    p_fileid in varchar2,
    p_action in varchar2,
    p_tlid in varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    )
IS
/*
    Xu ly khi import lenh tu file 1 cua khach hang
    p_action :
        A: All, Check and Update
        C: Chi check
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_COMPANYCD varchar2(100);
v_listcustodycd varchar2(200);
v_role VARCHAR2(10);
v_countvalid NUMBER;
v_fileid VARCHAR2(20);
V_TRANSACTIONTYPE varchar2(100);

BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI069_4web');
    v_custodycd:= '';
    v_count:=0;
    v_codeid := '';
    v_fileid := p_fileid;
    Begin
        select varvalue into v_COMPANYCD from sysvar where varname='COMPANYCD' and grname='SYSTEM';
    exception
        when others then v_COMPANYCD := 'SHV';
    End;

    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;

    UPDATE ODMASTCUST_TEMP SET
    QUANTITY = IS_NUMBER(NVL(QUANTITY,'-')),
    PRICE = IS_NUMBER(NVL(PRICE,'-')),
    GROSS_AMOUNT = IS_NUMBER(NVL(GROSS_AMOUNT,'-')),
    COMMISSION_FEE = IS_NUMBER(NVL(COMMISSION_FEE,'-')),
    TAX = IS_NUMBER(NVL(TAX,'-')),
    NET_AMOUNT = IS_NUMBER(NVL(NET_AMOUNT,'-'))
    WHERE FILEID = V_FILEID;

-- CHECK So TKLK
   FOR REC IN
    (SELECT * FROM ODMASTCUST_TEMP  WHERE fileid=v_fileid and errmsg IS NULL )
    LOOP
        --Check So TKLK
        IF rec.st_code IS NOT NULL THEN

           IF v_role ='STC' then
                IF rec.st_code <> v_custodycd then
                   UPDATE ODMASTCUST_TEMP SET deltd='Y' , errmsg =errmsg||' Error: Do not import account trading not under management!' WHERE fileid=v_fileid and st_code = rec.st_code;
                   p_err_code := '-930019';
                   p_err_message:= 'Trading account invalid!';
                   EXIT;
                else
                   p_err_code := 0;
                   p_err_message:= 'Sucessfull!';
                END IF;
          ELSIF v_role ='GCB' OR v_role ='AMC' THEN
            select count(1) into v_countvalid from dual where rec.st_code in (
            SELECT trim(regexp_substr(v_listcustodycd, '[^;]+', 1, LEVEL)) str
            FROM dual
            CONNECT BY regexp_substr(v_listcustodycd , '[^;]+', 1, LEVEL) IS NOT NULL
            );
         IF v_countvalid = 0 then
         UPDATE ODMASTCUST_TEMP SET deltd='Y' , errmsg =errmsg||' Error: Do not import account trading not under management!' WHERE fileid=v_fileid and st_code = rec.st_code;
              p_err_code := '-930019';
              p_err_message:= 'Trading account invalid!';
              EXIT;
         else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
         END IF;
     END IF;

            select count(custodycd) into v_count from CFMAST WHERE CUSTODYCD  = rec.st_code AND STATUS <> 'C';
            IF v_count = 0 THEN
              UPDATE ODMASTCUST_TEMP SET deltd='Y' , errmsg =errmsg||' Error: Trading account does not belong to the Broker !' WHERE fileid=v_fileid and st_code = rec.st_code;
              p_err_code := '-901219';
              p_err_message:= 'Trading account invalid!';
              EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        END IF;

        --Check Ma CK
        IF rec.sec_id IS NOT NULL THEN
            select count(codeid) into v_count from sbsecurities WHERE symbol = rec.sec_id;
            IF v_count = 0 THEN
              UPDATE ODMASTCUST_TEMP SET deltd='Y' , errmsg =errmsg||'Error: Symbol not found!' WHERE fileid=v_fileid and sec_id = rec.sec_id;
              p_err_code := '-700093';
              p_err_message:= 'Symbol invalid!';
              EXIT;
            else
                --plog.error('CHECK ='||p_err_code);
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        ELSE
              UPDATE ODMASTCUST_TEMP SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE fileid=v_fileid and sec_id = rec.sec_id;
              p_err_code := '-700093';
              p_err_message:= 'Symbol invalid!';
              EXIT;
        END IF;
        --Check TRANSACTIONTYPE
        IF rec.transactiontype IS NOT NULL THEN

            BEGIN
                SELECT CDVAL
                INTO V_TRANSACTIONTYPE
                FROM ALLCODE
                WHERE CDNAME='TRANSACTIONTYPE' AND TRIM(UPPER(CDCONTENT)) = TRIM(UPPER(REC.TRANSACTIONTYPE));
            EXCEPTION WHEN NO_DATA_FOUND THEN V_TRANSACTIONTYPE:=NULL;
            END;

            UPDATE ODMASTCUST_TEMP SET TRANSACTIONTYPE=V_TRANSACTIONTYPE  WHERE FILEID=V_FILEID;

        END IF;
        --Check CTCK
        IF REC.broker_code IS NOT NULL THEN
            select COUNT(*) INTO v_count
                from FABROKERAGE BR,FAMEMBERS M
                where BR.BRKID = M.AUTOID
                    and (BR.CUSTODYCD = REC.st_code  or BR.CUSTODYCD = REC.custodycd)
                    AND M.depositmember  = REC.broker_code;

            IF v_count = 0 THEN
                UPDATE ODMASTCUST_TEMP SET deltd='Y' , errmsg =errmsg||'Error: Broker invalid or Trading account does not belong to the Broker !' WHERE fileid=v_fileid and st_code = rec.st_code;
                p_err_code := '-901219';
                p_err_message:= 'Broker invalid!';
                EXIT;
            ELSE
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        END IF;


        --Check type
        IF REC.trans_type IS NOT NULL THEN
            --plog.error('Loai lenh ='||REC.trans_type);
            IF REC.trans_type ='NB' OR REC.trans_type = 'NS' THEN
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            ELSE
                UPDATE ODMASTCUST_TEMP SET deltd='Y' , errmsg = errmsg||'Error: Trans type invalid!' WHERE fileid=v_fileid and st_code = rec.st_code;
                p_err_code := '-701419';
                p_err_message:= 'Trans type invalid!';
                EXIT;
            END IF;
        /*ELSE
            UPDATE ODMASTCUST SET deltd='Y' , errmsg =errmsg||'Error: Trans type invalid!' WHERE st_code = rec.st_code;
                p_err_code := '-701419';
                p_err_message:= 'Trans type invalid!';*/
        END IF;
    END LOOP;

    If p_action <> 'A' then
        /*
        p_err_code := 0;
        p_err_message:= 'Sucessfull!';
        plog.setendsection(pkgctx, 'PR_FILLTER_TBLI069_4web');
        */
        return;
    end If;

    UPDATE  ODMASTCUST_TEMP  SET  custodycd = (SELECT CUSTODYCD  FROM CFMAST WHERE  tradingcode = ODMASTCUST_TEMP.st_code )
    WHERE INSTR (st_code,v_COMPANYCD)=0 and fileid = p_fileid;

    UPDATE  ODMASTCUST_TEMP  SET  custodycd = st_code,st_code=''
    WHERE INSTR (st_code,v_COMPANYCD)>0 and fileid = p_fileid;

    /*
    UPDATE  ODMASTCUST  SET  custodycd = (SELECT CUSTODYCD FROM CFMAST WHERE  tradingcode = ODMASTCUST.st_code)
    WHERE INSTR (st_code,'SHV')=0;

    UPDATE  odmastcust  SET  custodycd = st_code,st_code=''
    WHERE INSTR (st_code,'SHV')>0;
    */

    -- 21/01/2020, TruongLD add, neu da sinh vao ODMAST --> ko duoc xoa o day.
    update odmastcust set deltd ='Y'
    where isodmast <> 'Y' and via ='O' and fileid = p_fileid
          and exists (select custodycd from odmastcust_temp t where t.broker_code = broker_code);

    INSERT INTO ODMASTCUST(BROKER_CODE,TRANS_TYPE,ST_CODE,CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,
                            PRICE,GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,DELTD,STATUS,ERRMSG,FILEID,TLIDIMP,
                            ISCOMPARE,TXTIME,IMPSTATUS,OVRSTATUS,AUTOID,ISODMAST,TRANSACTIONTYPE,AP,CITAD,IDENTITY, VIA)
    SELECT BROKER_CODE,TRANS_TYPE,ST_CODE,CUSTODYCD,SEC_ID,
            to_char(to_date(TRADE_DATE,'DD/MM/RRRR hh24:mi:ss'),'DD/MM/RRRR') TRADE_DATE,
            to_char(to_date(SETTLE_DATE,'DD/MM/RRRR hh24:mi:ss'),'DD/MM/RRRR') SETTLE_DATE,
            QUANTITY,PRICE,GROSS_AMOUNT,
            COMMISSION_FEE,TAX,NET_AMOUNT,'N' DELTD,STATUS,ERRMSG, p_fileid FILEID, TLIDIMP, 'N' ISCOMPARE,sysdate TXTIME,IMPSTATUS,
            OVRSTATUS,AUTOID,ISODMAST,TRANSACTIONTYPE,AP,CITAD,IDENTITY, 'O' VIA
    FROM ODMASTCUST_TEMP WHERE ERRMSG IS NULL and fileid = p_fileid;

    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI069_4web');
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI069_4web');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI069_4web;
--------------------------------------------IMPORT VBMA--------------------------------------------------
PROCEDURE PR_FILE_TBLI077(P_TLID IN VARCHAR2, p_fileid in varchar2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2)
IS
V_COUNT NUMBER;
V_CHKUP NUMBER;
V_FORMAT NUMBER;
V_DATE DATE;
BEGIN

V_COUNT:=0;
V_CHKUP:=0;
-------------------------------CHECK VALUE DATE-----------------------------
BEGIN
    SELECT  COUNT(*)
            INTO V_COUNT
    FROM TBLIMPBONDPRICING WHERE FILEID = P_FILEID;
END;
---------
BEGIN
    SELECT  SUM(F_DATE(TXDATE))-V_COUNT
            INTO V_FORMAT
    FROM TBLIMPBONDPRICING WHERE FILEID = P_FILEID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN  V_FORMAT:=NULL;
    WHEN OTHERS THEN  V_FORMAT:=0;
END;
---------

IF V_FORMAT <> 0 THEN --FORMAT MM/DD/YYYY
    BEGIN
      UPDATE TBLIMPBONDPRICING SET TXDATE =TO_CHAR(TO_DATE(TXDATE,'DD/MM/RRRR hh24:mi:ss'),'DD/MM/RRRR') WHERE FILEID = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
          P_ERR_CODE := '-910006';
          P_ERR_MESSAGE:= 'Invalid format date!';
          RETURN;
    END ;
END IF;
-------------------------------RECORD ROW-----------------------------
FOR REC IN
(SELECT * FROM TBLIMPBONDPRICING WHERE FILEID = P_FILEID)
LOOP
    -----------------------CHECK DUPLICATE----------------------------
    BEGIN
        SELECT COUNT(TXDATE)
        INTO V_CHKUP
        FROM BONDPRICING
        WHERE TXDATE =TO_DATE(REC.TXDATE,'DD/MM/RRRR hh24:mi:ss');--REC.TXDATE;--TO_DATE(REC.TXDATE,CASE WHEN V_FORMAT=1 THEN 'DD/MM/RRRR' ELSE 'MM/DD/RRRR' END );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN  V_CHKUP:=0;
    END;
    -----------------------DUPLICATE -> UPDATE----------------------------
    IF V_CHKUP > 0 THEN
        -------------------------BACKUP BEFORE UPDATE

        INSERT INTO BONDPRICING_HIST
        SELECT * FROM BONDPRICING WHERE TXDATE =TO_DATE(REC.TXDATE,'DD/MM/RRRR hh24:mi:ss');--REC.TXDATE;--TO_DATE(REC.TXDATE,CASE WHEN V_FORMAT=1 THEN 'DD/MM/RRRR' ELSE 'MM/DD/RRRR' END );
        -------------------------UPDATE DUPLICATE
        UPDATE BONDPRICING
        SET AUTOID=REC.AUTOID,
            Y1=REC.Y1,
            Y2=REC.Y2,
            Y3=REC.Y3,
            Y4=REC.Y4,
            Y5=REC.Y5,
            Y7=REC.Y7,
            Y10=REC.Y10,
            Y15=REC.Y15,
            Y20=REC.Y20,
            Y25=REC.Y25,
            Y30=REC.Y30,
            Y50=REC.Y50,
            STATUS='A',
            PSTATUS=NULL,
            FILEID=P_FILEID,
            TLIDIMP=REC.TLIDIMP,
            TLIDOVR=P_TLID,
            LASTCHANGE=systimestamp
        WHERE TXDATE = TO_DATE(REC.TXDATE,'DD/MM/RRRR hh24:mi:ss');
        -------------------------UPDATE TBLIMPBONDPRICING TABLE
        UPDATE TBLIMPBONDPRICING
        SET STATUS = 'C', ERRMSG = 'Sucessfull',TIMEAPR= systimestamp,TLIDOVR=P_TLID
        WHERE AUTOID=REC.AUTOID;
    ELSE-----------------------APPEND----------------------------
        INSERT INTO BONDPRICING(AUTOID,TXDATE,Y1,Y2,Y3,Y4,Y5,Y7,Y10,Y15,Y20,Y25,Y30,Y50,STATUS,PSTATUS,FILEID,TLIDIMP,TLIDOVR)
        VALUES(
            REC.AUTOID,
            TO_DATE(REC.TXDATE,'DD/MM/RRRR hh24:mi:ss'),
            REC.Y1,
            REC.Y2,
            REC.Y3,
            REC.Y4,
            REC.Y5,
            REC.Y7,
            REC.Y10,
            REC.Y15,
            REC.Y20,
            REC.Y25,
            REC.Y30,
            REC.Y50,
            'A',--STATUS
            NULL,--PSTATUS
            P_FILEID,--FILEID
            REC.TLIDIMP,--TLIDIMP
            P_TLID--TLIDOVR
            );
    END IF;

END LOOP;
    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';
EXCEPTION
WHEN OTHERS THEN
    --ROLLBACK;
    PLOG.ERROR ('PR_FILE_TBLI077 ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
    P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
RETURN;
END PR_FILE_TBLI077;

PROCEDURE PR_BLOCKPLACE(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_err_param     varchar2(500);
v_strCURRDATE   varchar2(20);
L_txnum         VARCHAR2(20);
l_txmsg         tx.msg_rectype;
BEGIN
    plog.setbeginsection(pkgctx, 'PR_BLOCKPLACE');

    update blockplace_temp set autoid = seq_blockplace.nextval where fileid = p_fileid ;

    delete from blockplace;

    FOR rec in (
                      select * from blockplace_temp where fileid = p_fileid and OVRSTATUS = 'N'
               ) loop

        insert into blockplace(AUTOID, BANKCODE, NAME, PLACEID)
            select rec.AUTOID, rec.BANKCODE, rec.NAME, rec.PLACEID
            from blockplace_temp
            where fileid = p_fileid and autoid = rec.autoid and OVRSTATUS = 'N';

        update blockplace_temp
        set OVRSTATUS = 'Y'
        where fileid = p_fileid and autoid = rec.autoid and OVRSTATUS = 'N';

    END LOOP;

    plog.setendsection(pkgctx, 'PR_BLOCKPLACE');
    p_err_message := 'SYSTEM_SUCCESS';
    p_err_code := systemnums.C_SUCCESS;
exception
when others then
      plog.debug (pkgctx,'error immporting');
      --ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'PR_BLOCKPLACE');
      RAISE errnums.E_SYSTEM_ERROR;
end PR_BLOCKPLACE;
--------------------------------------------IMPORT PAYMENTCASH--------------------------------------------------
PROCEDURE PR_PAYMENTCASH(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2)
IS
    V_COUNT         NUMBER;
    L_ISERR         VARCHAR2(10);
    V_STRCURRDATE   VARCHAR2(20);
    V_MBID          VARCHAR2(10);
    V_SERCURITIES   VARCHAR2(50);
    V_SECQTTY       NUMBER;
    V_SECVALUE      NUMBER;
    V_FILEID        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_PAYMENTCASH');
    V_COUNT := 0;
    -------------------------------

    V_FILEID := P_FILEID;

    -------------------------------
    L_ISERR := 'N';
    -------------------------------
    BEGIN
        CSPKS_RMPROC.PR_AUTO_6639(V_FILEID,P_TLID,P_ERR_CODE => P_ERR_CODE);
        
        if(P_ERR_CODE<>SYSTEMNUMS.C_SUCCESS) then
            P_ERR_MESSAGE := CSPKS_SYSTEM.FN_GET_ERRMSG(P_ERR_CODE);
            RETURN;
        end if;

    EXCEPTION
    WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX,
                   'LOI = ' || P_ERR_CODE || ' ERR ' || SQLERRM ||
                   ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        L_ISERR  := 'Y';

    END ;

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'System error. Invalid file format';
        plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
        RETURN;
END PR_PAYMENTCASH;
--------------------------------------------IMPORT PAYMENTINSTRUCTION_TARD_ETFEX--------------------------------------------------
PROCEDURE PR_PAYMENTCASH_TARD_ETFEX(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2)
IS
    V_COUNT         NUMBER;
    L_ISERR         VARCHAR2(10);
    V_STRCURRDATE   VARCHAR2(20);
    V_MBID          VARCHAR2(10);
    V_SERCURITIES   VARCHAR2(50);
    V_SECQTTY       NUMBER;
    V_SECVALUE      NUMBER;
    V_FILEID        VARCHAR2(20);

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_AUTO_6639_TARD_ETFEX');
    V_COUNT := 0;
    -------------------------------

    V_FILEID := P_FILEID;

    -------------------------------
    L_ISERR := 'N';
    -------------------------------
    BEGIN
        CSPKS_RMPROC.PR_AUTO_6639_TARD_ETFEX(V_FILEID,P_TLID,P_ERR_CODE => P_ERR_CODE);
        
        if(P_ERR_CODE<>SYSTEMNUMS.C_SUCCESS) then
            P_ERR_MESSAGE := CSPKS_SYSTEM.FN_GET_ERRMSG(P_ERR_CODE);
            RETURN;
        end if;

    EXCEPTION
    WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX,
                   'LOI = ' || P_ERR_CODE || ' ERR ' || SQLERRM ||
                   ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        L_ISERR  := 'Y';

    END ;

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'System error. Invalid file format';
        plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
        RETURN;
END PR_PAYMENTCASH_TARD_ETFEX;
--------------------------------------------IMPORT PAYMENTINSTRUCTION_TARD_ETFEX--------------------------------------------------
PROCEDURE PR_PAYMENTCASH_TAEX(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2)
IS
    V_COUNT         NUMBER;
    L_ISERR         VARCHAR2(10);
    V_STRCURRDATE   VARCHAR2(20);
    V_MBID          VARCHAR2(10);
    V_SERCURITIES   VARCHAR2(50);
    V_SECQTTY       NUMBER;
    V_SECVALUE      NUMBER;
    V_FILEID        VARCHAR2(20);

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_PAYMENTCASH_TAEX');
    V_COUNT := 0;
    -------------------------------

    V_FILEID := P_FILEID;

    -------------------------------
    L_ISERR := 'N';
    -------------------------------
    BEGIN
        CSPKS_RMPROC.PR_AUTO_6639_TAEX(V_FILEID,P_TLID,P_ERR_CODE => P_ERR_CODE);
        
        if(P_ERR_CODE<>SYSTEMNUMS.C_SUCCESS) then
            P_ERR_MESSAGE := CSPKS_SYSTEM.FN_GET_ERRMSG(P_ERR_CODE);
            RETURN;
        end if;

    EXCEPTION
    WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX,
                   'LOI = ' || P_ERR_CODE || ' ERR ' || SQLERRM ||
                   ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        L_ISERR  := 'Y';

    END ;

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'System error. Invalid file format';
        plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
        RETURN;
END PR_PAYMENTCASH_TAEX;
-------------------------------------------------------------------------------------------------

PROCEDURE  PR_FILE_CADTLIMP(p_tlid in varchar2,p_fileid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
  IS
  CAMASTID VARCHAR(30);

  l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param varchar2(300);
      l_MaxRow NUMBER(20,0);
      N NUMBER ;
V_DUEDATE        DATE;
V_BEGINDATE       DATE;
V_CAMASTID        varchar2(300);
V_SYMBOL          varchar2(300);
V_CATYPE         varchar2(300);
V_REPORTDATE       DATE;
V_ACTIONDATE      DATE;
V_CATYPEVAL       varchar2(300);
V_RATE           varchar2(300);
V_RIGHTOFFRATE    varchar2(300);
V_FRDATETRANSFER   DATE;
V_TODATETRANSFER   DATE;
V_ROPRICE          NUMBER;
V_TVPRICE        NUMBER;
V_STATUS          varchar2(300);
V_DESC            varchar2(300);
l_count          NUMBER;
l_strSETYPE      varchar2(300);
V_CURRDATE  DATE ;
V_FORMOFPAYMENT varchar2(300);
V_CODEID varchar2(300);
V_TOCODEID varchar2(300);
v_fileid varchar2(100);
  BEGIN

BEGIN
v_fileid := p_fileid;
update cadtlimp set camastid=trim(camastid),custodycd=trim(custodycd) where fileid = v_fileid;

FOR REC in (
/*SELECT  camast.camastid ,camast.codeid,cf.custodycd,af.acctno afacctno,CF.CUSTID,af.description
FROM cadtlimp ca,  camast, cfmast cf,afmast af
where  camast.camastid = ca.camastid and UPPER(ca.custodycd) = UPPER(af.description) and af.custid = cf.custid*/
SELECT  camast.camastid ,camast.codeid,cf.custodycd,af.acctno afacctno,CF.CUSTID
 FROM cadtlimp ca, afmast af, cfmast cf , camast
where ca.custodycd = cf.custodycd and af.custid = cf.custid
and camast.camastid = ca.camastid AND af.status <>'C' and ca.fileid = v_fileid
 )
loop

/*update cadtlimp set acctno = rec.afacctno||rec.codeid , codeid = rec.codeid,custid= rec.custid,afacctno = rec.afacctno,
custodycd = UPPER(rec.description)
where UPPER(custodycd) = UPPER(rec.description) and camastid = rec.camastid ;
*/
update cadtlimp set acctno = rec.afacctno||rec.codeid , afacctno = rec.afacctno, codeid = rec.codeid,custid= rec.custid
where custodycd = rec.custodycd and camastid = rec.camastid and fileid  =v_fileid ;

l_count:=0;
     SELECT count(1) into l_count FROM SEMAST WHERE ACCTNO=rec.afacctno||rec.codeid ;

        if l_count <=0 then
          --Neu khong co thi tu dong mo tai khoan
            select to_date(varvalue,'DD/MM/YYYY') INTO V_CURRDATE  from sysvar  where varname ='CURRDATE';
          SELECT TYP.SETYPE into l_strSETYPE FROM AFMAST AF, AFTYPE TYP WHERE AF.ACTYPE=TYP.ACTYPE AND AF.ACCTNO= rec.afacctno;
          INSERT INTO SEMAST (ACTYPE,CUSTID,ACCTNO,CODEID,AFACCTNO,
                            OPNDATE,LASTDATE,STATUS,IRTIED,IRCD,
                            COSTPRICE,TRADE,MORTAGE,MARGIN,NETTING,
                            STANDING,WITHDRAW,DEPOSIT,LOAN)
                      VALUES (l_strSETYPE, rec.custid, rec.afacctno||rec.codeid , rec.codeid , rec.afacctno ,
                    V_CURRDATE ,V_CURRDATE ,'A','Y','001',
                      0,0,0,0,0,0,0,0,0);
        end IF;

end loop;
END ;
--commit;
--


 SELECT CAMAST.CAMASTID  ,SYM.SYMBOL ,CAMAST.FORMOFPAYMENT,CAMAST.CODEID,CAMAST.TOCODEID,
 A1.CDCONTENT  ,REPORTDATE , DUEDATE ,ACTIONDATE ,BEGINDATE  ,  RIGHTOFFRATE ,CAMAST.DESCRIPTION , A2.CDCONTENT  ,
nvl( (case when CAMAST.CATYPE='014' then CAMAST.EXPRICE end),0) ROPRICE ,
nvl( (case when CAMAST.CATYPE='011' then CAMAST.EXPRICE end),0) TVPRICE ,
(CASE WHEN EXRATE IS NOT NULL THEN EXRATE ELSE (CASE WHEN RIGHTOFFRATE IS NOT NULL
       THEN RIGHTOFFRATE ELSE (CASE WHEN DEVIDENTRATE IS NOT NULL THEN DEVIDENTRATE  ELSE
       (CASE WHEN SPLITRATE IS NOT NULL THEN SPLITRATE ELSE (CASE WHEN INTERESTRATE IS NOT NULL
       THEN INTERESTRATE ELSE
       (CASE WHEN DEVIDENTSHARES IS NOT NULL THEN DEVIDENTSHARES ELSE '0' END)END)END)END) END)END) RATE ,
       CAMAST.CATYPE,FRDATETRANSFER
  INTO V_CAMASTID, V_SYMBOL,V_FORMOFPAYMENT,V_CODEID,V_TOCODEID,
       V_CATYPE, V_REPORTDATE, V_DUEDATE , V_ACTIONDATE , V_BEGINDATE , V_RIGHTOFFRATE , V_DESC
       , V_STATUS , V_ROPRICE, V_TVPRICE , V_RATE  , V_CATYPE , V_FRDATETRANSFER
 FROM  CAMAST, SBSECURITIES SYM, ALLCODE A1, ALLCODE A2, ALLCODE A3,
      (select sum(case when schd.isci= 'Y' then schd.amt else 0 end) amt,
         sum( case when schd.isse ='Y' then schd.qtty else 0 end) qtty,
         sum(mst.pitrate *
                       ( CASE WHEN
                              (CASE WHEN schd.pitratemethod='##' THEN mst.pitratemethod ELSE schd.pitratemethod END) ='SC'
                         THEN 1 ELSE 0 END)
                        *(case when schd.isci= 'Y' then (case when  mst.catype='016' then schd.intamt else schd.amt end)
                               else 0 end) /100
            )taxamt,
       sum(mst.pitrate
                         * ( CASE WHEN
                              (CASE WHEN schd.pitratemethod='##' THEN mst.pitratemethod ELSE schd.pitratemethod END) ='SC'
                         THEN 0 ELSE 1 END)
             *(case when schd.isci= 'Y' then (case when  mst.catype='016' then schd.intamt else schd.amt end)
                               else 0 end) /100
            )realtaxamt,
         schd.camastid
          from caschd schd,camast mst
          where schd.deltd='N'
          and mst.deltd='N'
          AND mst.camastid=schd.camastid
          group by schd.camastid) SCHD
 WHERE CAMAST.CODEID=SYM.CODEID AND A1.CDTYPE = 'CA'
 AND A1.CDNAME = 'CATYPE' AND A1.CDVAL=CATYPE
 and A3.CDTYPE='CA' AND A3.CDNAME='PITRATEMETHOD' AND CAMAST.PITRATEMETHOD =A3.CDVAL
 AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'CASTATUS'
 AND CAMAST.STATUS=A2.CDVAL AND CAMAST.DELTD ='N'
 and camast.camastid=schd.camastid(+)
 AND CAMAST.camastid  IN(SELECT MAX(CAMASTID) FROM cadtlimp where fileid = v_fileid);

 -----

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='3375';
     SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'TEST';
    l_txmsg.txdate:=v_strCURRDATE;
    l_txmsg.BUSDATE:=v_strCURRDATE;
    l_txmsg.tltxcd:='3325';


        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := '0001';
        --Xac dinh xem nha day tu trong nuoc hay nuoc ngoai



       --Set cac field giao dich
        --01   N   DUEDATE
        l_txmsg.txfields ('01').defname   := 'DUEDATE';
        l_txmsg.txfields ('01').TYPE      := 'D';
        l_txmsg.txfields ('01').VALUE     := V_DUEDATE ;
             --02   N   BEGINDATE
        l_txmsg.txfields ('02').defname   := 'BEGINDATE';
        l_txmsg.txfields ('02').TYPE      := 'D';
        l_txmsg.txfields ('02').VALUE     := V_BEGINDATE ;
            --03   N   CAMASTID
        l_txmsg.txfields ('03').defname   := 'CAMASTID';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := V_CAMASTID ;
            --04   N   SYMBOL
        l_txmsg.txfields ('04').defname   := 'SYMBOL';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := V_SYMBOL ;
            --05   N   CATYPE
        l_txmsg.txfields ('05').defname   := 'CATYPE';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := V_CATYPE ;
          --06   N   REPORTDATE
        l_txmsg.txfields ('06').defname   := 'REPORTDATE';
        l_txmsg.txfields ('06').TYPE      := 'D';
        l_txmsg.txfields ('06').VALUE     := V_REPORTDATE ;
            --07   N   ACTIONDATE
        l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
        l_txmsg.txfields ('07').TYPE      := 'D';
        l_txmsg.txfields ('07').VALUE     := V_ACTIONDATE ;
            --09   C   CATYPEVAL
        l_txmsg.txfields ('09').defname   := 'CATYPEVAL';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').VALUE     := V_CATYPEVAL ;
            --10   N   RATE
        l_txmsg.txfields ('10').defname   := 'RATE';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := V_RATE ;
           --11   N   RIGHTOFFRATE
        l_txmsg.txfields ('11').defname   := 'RIGHTOFFRATE';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := V_RIGHTOFFRATE ;
                    --12   N   FRDATETRANSFER
        l_txmsg.txfields ('12').defname   := 'FRDATETRANSFER';
        l_txmsg.txfields ('12').TYPE      := 'D';
        l_txmsg.txfields ('12').VALUE     := V_FRDATETRANSFER ;
                    --13   N   TODATETRANSFER
        l_txmsg.txfields ('13').defname   := 'TODATETRANSFER';
        l_txmsg.txfields ('13').TYPE      := 'D';
        l_txmsg.txfields ('13').VALUE     := V_TODATETRANSFER ;
             --14   N   ROPRICE
        l_txmsg.txfields ('14').defname   := 'ROPRICE';
        l_txmsg.txfields ('14').TYPE      := 'N';
        l_txmsg.txfields ('14').VALUE     := V_ROPRICE ;
             --15   N   TVPRICE
        l_txmsg.txfields ('15').defname   := 'TVPRICE';
        l_txmsg.txfields ('15').TYPE      := 'N';
        l_txmsg.txfields ('15').VALUE     := V_TVPRICE ;
                 --20   N   STATUS
        l_txmsg.txfields ('20').defname   := 'STATUS';
        l_txmsg.txfields ('20').TYPE      := 'C';
        l_txmsg.txfields ('20').VALUE     := V_STATUS ;
                 --30   N   DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := V_DESC ;

        l_txmsg.txfields ('08').defname   := 'FORMOFPAYMENT';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').VALUE     := V_FORMOFPAYMENT ;

        l_txmsg.txfields ('16').defname   := 'FILEID';
        l_txmsg.txfields ('16').TYPE      := 'C';
        l_txmsg.txfields ('16').VALUE     := v_fileid ;
/*
        l_txmsg.txfields ('23').defname   := 'TRADE';
        l_txmsg.txfields ('23').TYPE      := 'N';
        l_txmsg.txfields ('23').VALUE     := fn_getseamt_3375(V_CODEID,V_REPORTDATE) ;

        l_txmsg.txfields ('40').defname   := 'TOCODEID';
        l_txmsg.txfields ('40').TYPE      := 'C';
        l_txmsg.txfields ('40').VALUE     := V_TOCODEID ;*/


       BEGIN
          IF txpks_#3325.fn_batchtxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN

   

               ROLLBACK;
             update   cadtlimp set status = 'E' where fileid =v_fileid;
               RETURN;
            END IF;
        END;


    p_err_code:=0;

  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.error('Row:'||dbms_utility.format_error_backtrace);


      RAISE errnums.E_SYSTEM_ERROR;
  END PR_FILE_CADTLIMP;

PROCEDURE PR_FILLTER_TBLSBSECURITIES(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS

BEGIN
    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLSBSECURITIES');

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLSBSECURITIES');
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLSBSECURITIES');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLSBSECURITIES;

PROCEDURE PR_FILE_TBLSBSECURITIES(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
    l_ISSUERID VARCHAR2(20);
    l_CODEID VARCHAR2(6);
    l_CODEID_WFT VARCHAR2(6);
    l_CCYCD VARCHAR2(10);
    l_COUNT NUMBER;
    l_CODEIDWFT varchar2(6);
    l_CURRDATE DATE;
BEGIN
    plog.setbeginsection(pkgctx, 'PR_FILE_TBLSBSECURITIES');

    FOR REC IN (
        SELECT *
        FROM TBLSBSECURITIES
        WHERE FILEID = P_FILEID AND NVL(DELTD,'N') <> 'Y'
    ) LOOP

        SELECT COUNT(1) INTO l_COUNT FROM ISSUERS WHERE ISSUERID = NVL(REC.ISSUERID,'N/A');
        IF l_COUNT = 0 THEN
            SELECT LPAD(NVL(MAX(ISSUERID),0) + 1,10,'0') INTO L_ISSUERID FROM ISSUERS;

            INSERT INTO ISSUERS (ISSUERID,SHORTNAME,FULLNAME,EN_FULLNAME,OFFICENAME,ECONIMIC,BUSINESSTYPE, OPERATEPLACE, MARKETSIZE,STATUS)
            VALUES (L_ISSUERID,TRIM(REC.SHORTNAME),REC.EN_FULLNAME,REC.EN_FULLNAME,TRIM(REC.EN_FULLNAME),'002','001','SO KHDT','001','A');
        ELSE
            L_ISSUERID := REC.ISSUERID;
            UPDATE ISSUERS
            SET SHORTNAME = NVL(REC.SHORTNAME, SHORTNAME),
                EN_FULLNAME = NVL(REC.EN_FULLNAME, EN_FULLNAME)
            WHERE ISSUERID = L_ISSUERID;
        END IF;

        BEGIN
            SELECT CCYCD INTO l_CCYCD FROM SBCURRENCY WHERE UPPER(SHORTCD) = UPPER(REC.CCYCD);
        EXCEPTION WHEN OTHERS THEN
            l_CCYCD := '00';
        END;

        SELECT COUNT(1) INTO l_COUNT FROM SBSECURITIES WHERE UPPER(SYMBOL) = UPPER(REC.SYMBOL);

        IF l_COUNT = 0 THEN
            BEGIN
                SELECT LPAD((MAX(TO_NUMBER(T2.INVACCT)) + 1),6,'0') INTO L_CODEID
                FROM (
                    SELECT ROWNUM ODR, T1.INVACCT
                    FROM (
                        SELECT CODEID INVACCT FROM SBSECURITIES WHERE SUBSTR(CODEID, 1, 1) <> 9 ORDER BY CODEID
                    ) T1
                ) T2;

                L_CODEID := NVL(L_CODEID,LPAD(1,6,'0'));
            EXCEPTION
                WHEN OTHERS THEN
                    L_CODEID :=  LPAD(1,6,'0');
            END;

            INSERT INTO SBSECURITIES (ISSUERID,CODEID,SYMBOL,BONDNAME,SECTYPE,BONDTYPE,TRADEPLACE,DEPOSITORY,INTCOUPON,TYPETERM,TERM,PARVALUE,ISINCODE,MANAGEMENTTYPE,CCYCD,ISSUEDATE,MATURITYDATE,EXPDATE,ISSEDEPOFEE)
            VALUES (L_ISSUERID,L_CODEID,REC.SYMBOL,REC.FULLNAME,REC.SECTYPE,REC.BONDTYPE,REC.TRADEPLACE,REC.DEPOSITORY,TO_NUMBER(REC.INTCOUPON),UPPER(REC.TYPETERM),REC.TERM,REC.PARVALUE,REC.ISINCODE,UPPER(REC.MANAGEMENTTYPE),
                    l_CCYCD,TO_DATE(REC.ISSUEDATE,'RRRRMMDD'),TO_DATE(REC.MATURITYDATE,'RRRRMMDD'),TO_DATE(REC.MATURITYDATE,'RRRRMMDD'),REC.ISSEDEPOFEE);

            --syn to fa
            insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime)
            values ('CB.MAINTAIN_LOG.'|| REC.SYMBOL,seq_log_notify_cbfa.nextval,'SBSECURITIES','SYMBOL',REC.SYMBOL,'ADD',null,getcurrdate(),null,SYSDATE);

            SELECT LPAD(TO_NUMBER(L_CODEID) + 1, 6,'0') INTO l_CODEID_WFT FROM DUAL;

            INSERT INTO SBSECURITIES (ISSUERID,CODEID,REFCODEID,SYMBOL,BONDNAME,SECTYPE,BONDTYPE,TRADEPLACE,DEPOSITORY,INTCOUPON,TYPETERM,TERM,PARVALUE,ISINCODE,MANAGEMENTTYPE,CCYCD,ISSUEDATE,MATURITYDATE,EXPDATE)
            VALUES (L_ISSUERID,l_CODEID_WFT,L_CODEID,REC.SYMBOL||'_WFT',REC.FULLNAME,REC.SECTYPE,REC.BONDTYPE,REC.TRADEPLACE,REC.DEPOSITORY,TO_NUMBER(REC.INTCOUPON),UPPER(REC.TYPETERM),REC.TERM,REC.PARVALUE,REC.ISINCODE,UPPER(REC.MANAGEMENTTYPE),
                    l_CCYCD,TO_DATE(REC.ISSUEDATE,'RRRRMMDD'),TO_DATE(REC.MATURITYDATE,'RRRRMMDD'),TO_DATE(REC.MATURITYDATE,'RRRRMMDD'));
        ELSE
            SELECT CODEID INTO l_CODEID FROM SBSECURITIES WHERE UPPER(SYMBOL) = UPPER(REC.SYMBOL);

            UPDATE SBSECURITIES
            SET ISSUERID = L_ISSUERID,
                SECTYPE = NVL(REC.SECTYPE, SECTYPE),
                BONDNAME = NVL(REC.FULLNAME, BONDNAME),
                BONDTYPE = NVL(REC.BONDTYPE, BONDTYPE),
                TRADEPLACE = NVL(REC.TRADEPLACE, TRADEPLACE),
                DEPOSITORY = NVL(REC.DEPOSITORY, DEPOSITORY),
                INTCOUPON = TO_NUMBER(NVL(REC.INTCOUPON, INTCOUPON)),
                TYPETERM = NVL(UPPER(REC.TYPETERM), TYPETERM),
                TERM = NVL(REC.TERM, TERM),
                PARVALUE = NVL(REC.PARVALUE, PARVALUE),
                ISINCODE = NVL(REC.ISINCODE, ISINCODE),
                MANAGEMENTTYPE = NVL(UPPER(REC.MANAGEMENTTYPE), MANAGEMENTTYPE),
                ISSUEDATE = CASE WHEN REC.ISSUEDATE IS NULL THEN ISSUEDATE ELSE TO_DATE(REC.ISSUEDATE,'RRRRMMDD') END,
                MATURITYDATE = CASE WHEN REC.MATURITYDATE IS NULL THEN MATURITYDATE ELSE TO_DATE(REC.MATURITYDATE,'RRRRMMDD') END,
                EXPDATE = CASE WHEN REC.MATURITYDATE IS NULL THEN EXPDATE ELSE TO_DATE(REC.MATURITYDATE,'RRRRMMDD') END,
                CCYCD = l_CCYCD,
                ISSEDEPOFEE = REC.ISSEDEPOFEE
            WHERE CODEID = l_CODEID;

            SELECT COUNT(1) INTO l_COUNT FROM SBSECURITIES WHERE REFCODEID = l_CODEID;

            IF l_COUNT = 0 THEN
                SELECT LPAD(TO_NUMBER(L_CODEID) + 1, 6,'0') INTO l_CODEID_WFT FROM DUAL;

                INSERT INTO SBSECURITIES (ISSUERID,CODEID,REFCODEID,SYMBOL,BONDNAME,SECTYPE,BONDTYPE,TRADEPLACE,DEPOSITORY,INTCOUPON,TYPETERM,TERM,PARVALUE,ISINCODE,MANAGEMENTTYPE,CCYCD,ISSUEDATE,MATURITYDATE,EXPDATE)
                VALUES (L_ISSUERID,l_CODEID_WFT,L_CODEID,REC.SYMBOL||'_WFT',REC.FULLNAME,REC.SECTYPE,REC.BONDTYPE,REC.TRADEPLACE,REC.DEPOSITORY,TO_NUMBER(REC.INTCOUPON),UPPER(REC.TYPETERM),REC.TERM,REC.PARVALUE,REC.ISINCODE,UPPER(REC.MANAGEMENTTYPE),
                        l_CCYCD,TO_DATE(REC.ISSUEDATE,'RRRRMMDD'),TO_DATE(REC.MATURITYDATE,'RRRRMMDD'),TO_DATE(REC.MATURITYDATE,'RRRRMMDD'));
            ELSE
                SELECT CODEID INTO l_CODEID_WFT FROM SBSECURITIES WHERE REFCODEID = l_CODEID;

                UPDATE SBSECURITIES
                SET ISSUERID = L_ISSUERID,
                    SECTYPE = NVL(REC.SECTYPE, SECTYPE),
                    BONDNAME = NVL(REC.FULLNAME, BONDNAME),
                    BONDTYPE = NVL(REC.BONDTYPE, BONDTYPE),
                    TRADEPLACE = NVL(REC.TRADEPLACE, TRADEPLACE),
                    DEPOSITORY = NVL(REC.DEPOSITORY, DEPOSITORY),
                    INTCOUPON = TO_NUMBER(NVL(REC.INTCOUPON, INTCOUPON)),
                    TYPETERM = NVL(UPPER(REC.TYPETERM), TYPETERM),
                    TERM = NVL(REC.TERM, TERM),
                    PARVALUE = NVL(REC.PARVALUE, PARVALUE),
                    ISINCODE = NVL(REC.ISINCODE, ISINCODE),
                    MANAGEMENTTYPE = NVL(UPPER(REC.MANAGEMENTTYPE), MANAGEMENTTYPE),
                    ISSUEDATE = CASE WHEN REC.ISSUEDATE IS NULL THEN ISSUEDATE ELSE TO_DATE(REC.ISSUEDATE,'RRRRMMDD') END,
                    MATURITYDATE = CASE WHEN REC.MATURITYDATE IS NULL THEN MATURITYDATE ELSE TO_DATE(REC.MATURITYDATE,'RRRRMMDD') END,
                    EXPDATE = CASE WHEN REC.MATURITYDATE IS NULL THEN EXPDATE ELSE TO_DATE(REC.MATURITYDATE,'RRRRMMDD') END,
                    CCYCD = l_CCYCD
                WHERE CODEID = l_CODEID_WFT;
            END IF;
        END IF;

        l_CURRDATE := getcurrdate;

        DELETE FROM SECURITIES_INFO WHERE CODEID IN (L_CODEID, l_CODEID_WFT);

        IF REC.TRADEPLACE = '001' THEN
            INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30)
            VALUES(SEQ_SECURITIES_INFO.nextval,L_CODEID,trim(REC.SYMBOL),l_CURRDATE,1,1000,'N',1,l_CURRDATE,'001',1,1,l_CURRDATE,'001',0,0,0,0,0,0,0,0,1,'002',0,0,1,1,1,1,1,10,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

            INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30)
            VALUES(SEQ_SECURITIES_INFO.nextval,l_CODEID_WFT,trim(REC.SYMBOL)|| '_WFT',l_CURRDATE,1,1000,'N',1,l_CURRDATE,'001',1,1,l_CURRDATE,'001',0,0,0,0,0,0,0,0,1,'002',0,0,1,1,1,1,1,10,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        ELSE
            INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30)
            VALUES(SEQ_SECURITIES_INFO.nextval,l_CODEID,trim(REC.SYMBOL),l_CURRDATE,1,1000,'N',1,l_CURRDATE,'001',1,1,l_CURRDATE,'001',26800,0,0,0,0,26800,28676,24924,1,'002',0,0,1,1,1,1,1,100,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,167439,0,0,26800,26800,5167504,1000000,26800,2000000,0,26800,26800,26800,1000000,2000000,0,0);

            INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30)
            VALUES(SEQ_SECURITIES_INFO.nextval,l_CODEID_WFT,trim(REC.SYMBOL)|| '_WFT',l_CURRDATE,1,1000,'N',1,l_CURRDATE,'001',1,1,l_CURRDATE,'001',26800,0,0,0,0,26800,28676,24924,1,'002',0,0,1,1,1,1,1,100,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,167439,0,0,26800,26800,5167504,1000000,26800,2000000,0,26800,26800,26800,1000000,2000000,0,0);
        END IF;

    END LOOP;
    plog.setendsection(pkgctx, 'PR_FILE_TBLSBSECURITIES');
    p_err_message := 'SYSTEM_SUCCESS';
    p_err_code := systemnums.C_SUCCESS;
exception
when others then
      plog.debug (pkgctx,'error immporting');
      --ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx,'PR_FILE_TBLSBSECURITIES: ' || SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'PR_FILE_TBLSBSECURITIES');
      RAISE errnums.E_SYSTEM_ERROR;
end PR_FILE_TBLSBSECURITIES;

PROCEDURE PR_FILLTER_TBLI176(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 1 cua VSD
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_exception EXCEPTION;
v_fileid VARCHAR2(100);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI176');
    v_fileid := p_fileid;
    -- Check So du tai khoan tien
    FOR REC IN
    (SELECT * FROM tblimpi176  WHERE fileid=v_fileid and errmsg IS NULL )
    LOOP
        --Check So TKLK
        IF rec.CUSTODYCD IS NOT NULL THEN
            select count(custodycd) into v_count from CFMAST WHERE CUSTODYCD  = trim(rec.CUSTODYCD) AND STATUS <> 'C';
            IF v_count = 0 THEN
              UPDATE tblimpi176 SET deltd='Y' , errmsg =errmsg||' Error: Trading account does not belong to the Broker !'
              WHERE fileid=v_fileid and custodycd = trim(rec.custodycd);
              p_err_code := '-930112';
              p_err_message:= 'Trading account invalid!';
              EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        ELSE
          UPDATE tblimpi176 SET deltd='Y' , errmsg =errmsg||' Error: Custodycd is null or empty!'
              WHERE fileid=v_fileid and custodycd = trim(rec.custodycd);
              p_err_code := '-930112';
              p_err_message:= 'Custodycd is null or empty!';
              EXIT;
        END IF;

        --Check So tai khoan tien
        IF rec.ddaccount IS NOT NULL THEN
            select count(*) into v_count
            from DDMAST DD,CFMAST CF
            WHERE DD.refcasaacct  = trim(rec.ddaccount)
            AND CF.CUSTID=DD.AFACCTNO
            AND CF.CUSTODYCD=TRIM(rec.CUSTODYCD)
            AND CF.STATUS <> 'C';

            IF v_count = 0 THEN
              UPDATE tblimpi176 SET deltd='Y' , errmsg =errmsg||' Error: Account number invalid!'
              WHERE fileid=v_fileid and autoid = rec.autoid;
              p_err_code := '-930112';
              p_err_message:= 'Account number invalid!';
              EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        ELSE
          UPDATE tblimpi176 SET deltd='Y' , errmsg =errmsg||' Error: Account number is null or empty!'
              WHERE fileid=v_fileid and custodycd = trim(rec.custodycd);
              p_err_code := '-930112';
              p_err_message:= 'Account number is null or empty!';
              EXIT;
        END IF;

        --Check So du tai khoan tien
        IF rec.ddaccount >0 THEN
            select count(*) into v_count from DDMAST WHERE refcasaacct  = trim(rec.ddaccount) AND BALANCE >= rec.amount;
            IF v_count = 0 THEN
              UPDATE tblimpi176 SET deltd='Y' , errmsg =errmsg||' [-400005]: Not enough balance! '
              WHERE fileid=v_fileid and autoid = rec.autoid;
              p_err_code := '-930112';
              p_err_message:= 'Not enough balance!';
              EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        END IF;
        --Check CTCK
        IF REC.company IS NOT NULL THEN
            select COUNT(*) INTO v_count
                from FABROKERAGE BR,FAMEMBERS M
                where BR.BRKID = M.AUTOID
                    and BR.CUSTODYCD = trim(REC.custodycd)
                    AND M.shortname  = trim(REC.company)
                    and m.roles='BRK';

            IF v_count = 0 THEN
                UPDATE tblimpi176 SET deltd='Y' , errmsg =errmsg||'Error: Broker company is invalid or Trading account does not belong to the Boker !'
                WHERE fileid=v_fileid and autoid = rec.autoid;
                p_err_code := '-930112';
                p_err_message:= 'Broker company is invalid!';
                EXIT;
            ELSE
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;

            -- Check broker + telephone
            SELECT COUNT(*) INTO V_COUNT
                FROM FAMEMBERSEXTRA BR,FAMEMBERS M
                WHERE BR.MEMBERID = M.AUTOID
                    AND M.ROLES='BRK'
                    AND M.SHORTNAME  = TRIM(REC.COMPANY)
                    AND BR.EXTRACD='B' AND TRIM(EXTRAVAL) = TRIM(REC.BROKER);
            IF v_count = 0 THEN
                UPDATE tblimpi176 SET deltd='Y' , errmsg =errmsg||'Error: Broker is invalid!'
                WHERE fileid=v_fileid and autoid = rec.autoid;
                p_err_code := '-930112';
                p_err_message:= 'Broker is invalid!';
                EXIT;
            ELSE
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;

            SELECT COUNT(*) INTO V_COUNT
                FROM FAMEMBERSEXTRA BR,FAMEMBERS M
                WHERE BR.MEMBERID = M.AUTOID
                    AND M.ROLES='BRK'
                    AND M.SHORTNAME  = TRIM(REC.COMPANY)
                    AND BR.EXTRACD='I' AND TRIM(EXTRAVAL) = TRIM(REC.TELEPHONE);
            IF v_count = 0 THEN
                UPDATE tblimpi176 SET deltd='Y' , errmsg =errmsg||'Error: Telephone is invalid!'
                WHERE fileid=v_fileid and autoid = rec.autoid;
                p_err_code := '-930112';
                p_err_message:= 'Telephone is invalid!';
                EXIT;
            ELSE
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
         ELSE
          UPDATE tblimpi176 SET deltd='Y' , errmsg =errmsg||' Error: Broker company is null or empty!'
              WHERE fileid=v_fileid and custodycd = trim(rec.custodycd);
              p_err_code := '-901219';
              p_err_message:= 'Broker company is null or empty!';
              EXIT;
        END IF;
    END LOOP;

    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI176');

exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI176');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI176;

PROCEDURE PR_TBLI176(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*

*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_exception EXCEPTION;
v_fileid VARCHAR2(100);
v_ddacctno varchar2(100);
globalid_bank  varchar2(100);
L_txnum varchar2(100);
v_memberid varchar2(100);
l_iserr  VARCHAR2(10);
  v_status varchar2(1);
  v_deltd  varchar2(1);
  v_errmsg varchar2(200);
  v_brname   varchar2(200);
  v_brphone  varchar2(200);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_TBLI176');
    v_fileid := p_fileid;
    -- Check So du tai khoan tien
    FOR REC IN
    (SELECT * FROM tblimpi176  WHERE fileid=v_fileid and errmsg IS NULL and (status <> 'E' OR status IS NULL) )
    loop
        select autoid into v_memberid from FAMEMBERS where shortname = rec.company and roles='BRK';
        select acctno into v_ddacctno from ddmast where refcasaacct = rec.ddaccount;
        SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        select fn_getglobalid(getcurrdate,L_txnum) into globalid_bank from dual;
        select autoid into v_brname from famembersextra where memberid= v_memberid and extraval=rec.BROKER;
        select autoid into v_brphone from famembersextra where memberid= v_memberid and extraval=rec.TELEPHONE;
        begin
             --hold CK : pck_bankapi.se_hold
             --hold tien: pck_bankapi.Bank_holdbalance
            pck_bankapi.Bank_holdbalance(
                  v_ddacctno, -- tk ddmast (acctno)
                  v_memberid, -- ctck dat lenh
                  trim(v_brname), -- moi gioi dat lenh
                  TRIM(v_brphone), --- so dien thoai moi gioi dat lenh
                  rec.amount,  --- so tien
                  'BANKHOLDEDBYBROKER', --- code nghiep vu cua giao dich , select tu alcode
                  globalid_bank, --request key --> key duy nhat de truy vet giao dich goc
                  rec.description, -- dien giai
                  p_tlid, -- nguoi lap giao dich
                  P_ERR_CODE );

        end;
        if P_ERR_CODE <> systemnums.C_SUCCESS then
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            v_status:='E';
            v_deltd:='Y';
            v_errmsg:= p_err_code||':'||cspks_system.fn_get_errmsg(p_err_code);
            p_err_message:= p_err_message;
            l_iserr :='Y';
            ROLLBACK;
            Update tblimpi176 Set status=v_status,errmsg=v_errmsg, deltd =v_deltd Where autoid=rec.autoid;
            EXIT;
        else
            insert into hold_f8_by_import
                (custodycd,company, ddaccount, amount,broker,telephone, description,autoid, deltd, status, fileid)
                values
                (rec.custodycd,rec.company,rec.ddaccount,rec.amount,rec.broker,rec.telephone,rec.description,rec.autoid,rec.deltd,'C',rec.fileid)
                ;
        end if;
    end loop;
    -- update trang thai filereport
  IF l_iserr = 'Y' THEN
    IF p_err_code = systemnums.C_SUCCESS OR p_err_code IS NULL  THEN
         p_err_code    := -100129; --Loi duyet file
    END IF;
    p_err_message := cspks_system.fn_get_errmsg(p_err_code);
    ROLLBACK;
    UPDATE TLLOG SET TXSTATUS = '2', deltd = 'Y' WHERE MSGACCT = P_fileid;
    --COMMIT;
    RETURN;
  ELSE
    Update tblimpi176 Set status= 'C',ERRMSG = 'Thanh cong'  Where  fileid = v_fileid;
    Insert into tblimpi176_HIST select * from tblimpi176 where  fileid = v_fileid ;
    DELETE from tblimpi176  where   fileid = v_fileid;
    p_err_code    := systemnums.C_SUCCESS;
    p_err_message := 'Sucessfull!';
  end if;
    plog.setendsection(pkgctx, 'PR_TBLI176');

exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_TBLI176');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_TBLI176;

PROCEDURE PR_FILLTER_TBLI177(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 1 cua VSD
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_exception EXCEPTION;
v_fileid VARCHAR2(100);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_FILLTER_TBLI177');
    p_err_code    := systemnums.c_success;
    v_fileid := p_fileid;
    -- Check So du tai khoan tien
    FOR REC IN
    (SELECT * FROM tblimpi177  WHERE fileid=v_fileid and errmsg IS NULL )
    LOOP
        --Check So TKLK
        IF rec.CUSTODYCD IS NOT NULL OR LENGTH(rec.CUSTODYCD) > 0 THEN
            select count(custodycd) into v_count from CFMAST WHERE CUSTODYCD  = trim(rec.CUSTODYCD) AND STATUS <> 'C';
            IF v_count = 0 THEN
              UPDATE tblimpi177 SET deltd='Y' , errmsg =errmsg||' Error: Trading account does not belong to the Broker !'
              WHERE fileid=v_fileid and custodycd = trim(rec.custodycd);
              p_err_code := -930112;
              p_err_message:= 'Trading account invalid!';
              EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        ELSE
             UPDATE tblimpi177 SET deltd='Y' , errmsg =errmsg||' Error: Custody is null or empty !'
              WHERE fileid=v_fileid and custodycd = trim(rec.custodycd);
              p_err_code := -930112;
              p_err_message:= 'Custody is null or empty!';
              EXIT;
        END IF;

        --Check ma ck nam giu
        IF rec.symbol IS NOT NULL  and REC.qtty > 0 THEN
            select count(*) into v_count from SEMAST SE,CFMAST CF,SBSECURITIES SB
            WHERE SB.CODEID=SE.CODEID
            AND CF.CUSTID=SE.AFACCTNO AND CF.CUSTODYCD=TRIM(REC.CUSTODYCD)
            AND SB.SYMBOL=REC.SYMBOL
            AND CF.STATUS <> 'C';

            IF v_count = 0 THEN
              UPDATE tblimpi177 SET deltd='Y' , errmsg =errmsg||' Error: Symbol is invalid!'
              WHERE fileid=v_fileid and autoid = rec.autoid;
              p_err_code := -930112;
              p_err_message:= 'Symbol is invalid!';
              EXIT;
            else
                select count(*) into v_count from SEMAST SE,CFMAST CF,SBSECURITIES SB
                WHERE SB.CODEID=SE.CODEID
                AND CF.CUSTID=SE.AFACCTNO AND CF.CUSTODYCD=TRIM(REC.CUSTODYCD)
                AND SB.SYMBOL=REC.SYMBOL
                AND SE.TRADE > REC.qtty
                AND CF.STATUS <> 'C';
                IF v_count = 0 THEN
                    UPDATE tblimpi177 SET deltd='Y' , errmsg =errmsg||' [-400005]: Not enough balance! '
                      WHERE fileid=v_fileid and autoid = rec.autoid;
                      p_err_code := -400005;
                      p_err_message:= 'Not enough balance!';
                      EXIT;
                ELSE
                    p_err_code := 0;
                    p_err_message:= 'Sucessfull!';
                END IF;
            END IF;
         ELSE
             UPDATE tblimpi177 SET deltd='Y' , errmsg =errmsg||' Error: Symbol is null or empty !'
              WHERE fileid=v_fileid and custodycd = trim(rec.custodycd);
              p_err_code := -930112;
              p_err_message:= 'Symbol is null or empty!';
              EXIT;
        END IF;

        --Check CTCK
        IF REC.company IS NOT NULL THEN
            select COUNT(*) INTO v_count
                from FABROKERAGE BR,FAMEMBERS M
                where BR.BRKID = M.AUTOID
                    and BR.CUSTODYCD = trim(REC.custodycd)
                    AND M.shortname  = trim(REC.company)
                    and m.roles='BRK';

            IF v_count = 0 THEN
                UPDATE tblimpi177 SET deltd='Y' , errmsg =errmsg||'Error: Broker company is invalid or Trading account does not belong to the Boker !'
                WHERE fileid=v_fileid and autoid = rec.autoid;
                p_err_code := -930112;
                p_err_message:= 'Broker company is invalid!';
                EXIT;
            ELSE
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;

            -- Check broker + telephone
            SELECT COUNT(*) INTO V_COUNT
                FROM FAMEMBERSEXTRA BR,FAMEMBERS M
                WHERE BR.MEMBERID = M.AUTOID
                    AND M.ROLES='BRK'
                    AND M.SHORTNAME  = TRIM(REC.COMPANY)
                    AND BR.EXTRACD='B' AND TRIM(EXTRAVAL) = TRIM(REC.BROKER);
            IF v_count = 0 THEN
                UPDATE tblimpi177 SET deltd='Y' , errmsg =errmsg||'Error: Broker is invalid!'
                WHERE fileid=v_fileid and autoid = rec.autoid;
                p_err_code := -930112;
                p_err_message:= 'Broker is invalid!';
                EXIT;
            ELSE
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;

            SELECT COUNT(*) INTO V_COUNT
                FROM FAMEMBERSEXTRA BR,FAMEMBERS M
                WHERE BR.MEMBERID = M.AUTOID
                    AND M.ROLES='BRK'
                    AND M.SHORTNAME  = TRIM(REC.COMPANY)
                    AND BR.EXTRACD='I' AND TRIM(EXTRAVAL) = TRIM(REC.TELEPHONE);
            IF v_count = 0 THEN
                UPDATE tblimpi177 SET deltd='Y' , errmsg =errmsg||'Error: Telephone is invalid!'
                WHERE fileid=v_fileid and autoid = rec.autoid;
                p_err_code := -930112;
                p_err_message:= 'Telephone is invalid!';
                EXIT;
            ELSE
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        ELSE
             UPDATE tblimpi177 SET deltd='Y' , errmsg =errmsg||' Error: Broker company is null or empty !'
              WHERE fileid=v_fileid and custodycd = trim(rec.custodycd);
              p_err_code := -930112;
              p_err_message:= 'Broker company is null or empty!';
              EXIT;
        END IF;
    END LOOP;
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI177');

exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_FILLTER_TBLI177');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILLTER_TBLI177;

PROCEDURE PR_TBLI177(p_tlid in varchar2, p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
/*
    Xu ly khi import lenh tu file 1 cua VSD
*/
v_count NUMBER;
v_custodycd VARCHAR2(20);
v_codeid varchar2(100);
v_exception EXCEPTION;
v_fileid VARCHAR2(100);
v_seacctno varchar2(100);
globalid_bank  varchar2(100);
L_txnum varchar2(100);
v_memberid varchar2(100);
l_iserr  VARCHAR2(10);
  v_status varchar2(1);
  v_deltd  varchar2(1);
  v_errmsg varchar2(200);
  v_brname   varchar2(200);
  v_brphone  varchar2(200);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_TBLI177');
    v_fileid := p_fileid;
        -- Check So du tai khoan tien
        FOR REC IN
        (SELECT * FROM tblimpi177  WHERE fileid=v_fileid and errmsg IS NULL and (status <> 'E' OR status IS NULL) )
        loop
            select autoid into v_memberid from FAMEMBERS where shortname = rec.company and roles='BRK';
            select acctno into v_seacctno from semast se, cfmast cf, sbsecurities sb
            where se.custid=cf.custid and cf.custodycd=rec.custodycd and sb.codeid=se.codeid
            and sb.symbol=rec.symbol;
            select autoid into v_brname from famembersextra where memberid= v_memberid and extraval=rec.BROKER;
            select autoid into v_brphone from famembersextra where memberid= v_memberid and extraval=rec.TELEPHONE;
            begin
                 --hold CK : pck_bankapi.se_hold
                 --hold tien: pck_bankapi.Bank_holdbalance
                pck_bankapi.se_hold(
                      v_seacctno, -- tk ddmast (acctno)
                      v_memberid, -- ctck dat lenh
                      v_brname, -- moi gioi dat lenh
                      v_brphone, --- so dien thoai moi gioi dat lenh
                      rec.qtty,  --- so tien
                      rec.description, -- dien giai
                      p_tlid, -- nguoi lap giao dich
                      P_ERR_CODE );

            end;
            if P_ERR_CODE <> systemnums.C_SUCCESS then
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                v_status:='E';
                v_deltd:='Y';
                v_errmsg:= p_err_code||':'||cspks_system.fn_get_errmsg(p_err_code);
                p_err_message:= p_err_message;
                l_iserr :='Y';
                ROLLBACK;
                Update tblimpi177 Set status=v_status,errmsg=v_errmsg, deltd =v_deltd Where autoid=rec.autoid;
                EXIT;
            else
                insert into hold_f8_by_import
                (custodycd,company, ddaccount, amount,broker,telephone, description,autoid, deltd, status, fileid)
                values
                (rec.custodycd,rec.company,v_seacctno,rec.qtty,rec.broker,rec.telephone,rec.description,rec.autoid,rec.deltd,'C',rec.fileid)
                ;
            end if;
        end loop;
    -- update trang thai filereport
  IF l_iserr = 'Y' THEN
    IF p_err_code = systemnums.C_SUCCESS OR p_err_code IS NULL  THEN
         p_err_code    := -100129; --Loi duyet file
    END IF;
    p_err_message := cspks_system.fn_get_errmsg(p_err_code);
    ROLLBACK;
    UPDATE TLLOG SET TXSTATUS = '2', deltd = 'Y' WHERE MSGACCT = P_fileid;
    --COMMIT;
    RETURN;
  ELSE
    Update tblimpi177 Set status= 'C',ERRMSG = 'Thanh cong'  Where  fileid = v_fileid;
    Insert into tblimpi177_HIST select * from tblimpi177 where  fileid = v_fileid ;
    DELETE from tblimpi177  where   fileid = v_fileid;
    p_err_code    := systemnums.C_SUCCESS;
    p_err_message := 'Sucessfull!';
  end if;
    plog.setendsection(pkgctx, 'PR_TBLI177');

exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_TBLI177');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_TBLI177;

PROCEDURE PR_CHECK_I078(p_tlid in varchar2, p_fileid in varchar2, p_err_code OUT varchar2, p_err_message OUT varchar2)
IS
v_count number;
BEGIN

    plog.setbeginsection(pkgctx, 'PR_CHECK_I078');
    update paymentcash_temp set status = 'E', errmsg = 'Do not import cash account not under management!'
    where (tradingaccount, banktransfers) not in (
        select custodycd, refcasaacct from ddmast where status NOT IN ('C')
    )
    and fileid = p_fileid;

    update paymentcash_temp set status = 'E', errmsg = 'Do not import cash account with closed status!'
    where (tradingaccount, banktransfers) in (
        select custodycd, refcasaacct from ddmast where status = 'C'
    )
    and NVL(status,'P') not in ('E')
    and fileid = p_fileid;

    update paymentcash_temp set status = 'E', errmsg = 'Do not import Amout<= 0!'
    where amount <= 0
    and NVL(status,'P') not in ('E')
    and fileid = p_fileid;

    update paymentcash_temp set status = 'E', errmsg = 'Do not import cash Transfer not under management!'
    where transfer NOT IN ('I','D')
    and NVL(status,'P') not in ('E')
    and fileid = p_fileid;

    update paymentcash_temp set status = 'E', errmsg = 'Balance is not enough!'
    where not exists (
        select 1 from ddmast where ddmast.refcasaacct = paymentcash_temp.banktransfers and ddmast.status not in ('C') and ddmast.balance >= paymentcash_temp.amount
    )
    and NVL(status,'P') not in ('E')
    and fileid = p_fileid;

    select count(1) into v_count from paymentcash_temp where status = 'E' and fileid = p_fileid;

    if v_count > 0 then
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
    end if;

    plog.setendsection(pkgctx, 'PR_CHECK_I078');

exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_CHECK_I078;

PROCEDURE PR_CHECK_R0061(p_tlid in varchar2, p_fileid in varchar2, p_err_code OUT varchar2, p_err_message OUT varchar2)
IS
v_count number;
BEGIN

    plog.setbeginsection(pkgctx, 'PR_CHECK_R0061');

    UPDATE PAYMENTCASH_R0061_TEMP set STATUS = 'E', ERRMSG = 'Trading account not found !'
    WHERE NOT EXISTS (
        SELECT 1 FROM DDMAST WHERE DDMAST.REFCASAACCT = PAYMENTCASH_R0061_TEMP.DEBANKACC AND DDMAST.STATUS NOT IN ('C')
    )
    AND FILEID = P_FILEID;

    UPDATE PAYMENTCASH_R0061_TEMP set STATUS = 'E', ERRMSG = 'Trading account invalid !'
    WHERE (
        SELECT COUNT(1) FROM DDMAST WHERE DDMAST.REFCASAACCT = PAYMENTCASH_R0061_TEMP.DEBANKACC AND DDMAST.STATUS NOT IN ('C')
    ) > 1
    AND NVL(STATUS,'P') NOT IN ('E')
    AND FILEID = P_FILEID;

    UPDATE PAYMENTCASH_R0061_TEMP set STATUS = 'E', ERRMSG = 'Do not import Amout <= 0!'
    WHERE SOTIEN <= 0
    AND NVL(STATUS,'P') NOT IN ('E')
    AND FILEID = P_FILEID;

    UPDATE PAYMENTCASH_R0061_TEMP set STATUS = 'E', ERRMSG = 'Do not import citad not under management!'
    WHERE UPPER(TENNH) not like '%SHINHAN%' AND NVL(FN_GETCITADBYKEYWORD(TENNH), 'xxx') = 'xxx'
    AND NVL(STATUS,'P') NOT IN ('E')
    AND FILEID = P_FILEID;

    UPDATE PAYMENTCASH_R0061_TEMP set STATUS = 'E', ERRMSG = 'Balance is not enough!'
    WHERE NOT EXISTS (
        SELECT 1 FROM DDMAST WHERE DDMAST.REFCASAACCT = PAYMENTCASH_R0061_TEMP.DEBANKACC AND DDMAST.STATUS NOT IN ('C') AND DDMAST.BALANCE >= PAYMENTCASH_R0061_TEMP.SOTIEN
    )
    AND NVL(STATUS,'P') NOT IN ('E')
    AND FILEID = P_FILEID;

    select count(1) into v_count from PAYMENTCASH_R0061_TEMP where status = 'E' and fileid = p_fileid;

    if v_count > 0 then
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
    end if;

    plog.setendsection(pkgctx, 'PR_CHECK_R0061');

exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_CHECK_R0061;

PROCEDURE PR_PAYMENTCASH_R0061(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2)
IS
    L_TXMSG       TX.MSG_RECTYPE;
    P_XMLMSG      VARCHAR2(4000);
    V_ERR_CODE    VARCHAR2(10);
    V_COUNT         NUMBER;
    V_CURRDATE    date;
    V_STRDESC     VARCHAR2(1000);
    V_STREN_DESC  VARCHAR2(1000);
    V_CUSTODYCD VARCHAR2(100);
    V_TRANSFER varchar2(10);
    V_FEETYPE varchar2(10);
    V_ACCTNO varchar2(50);
    V_CIFID varchar2(50);
    V_BANKNAME VARCHAR2(500);
    V_BANKBRANCH VARCHAR2(500);
    V_CITAD_SHV VARCHAR2(10);
    v_feeamt number;
    v_netamt number;
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_PAYMENTCASH_R0061');
    V_COUNT := 0;
    V_CURRDATE := getcurrdate;
    V_ERR_CODE := SYSTEMNUMS.C_SUCCESS;
    -------------------------------

    BEGIN
        SELECT TXDESC, EN_TXDESC
        INTO V_STRDESC, V_STREN_DESC
        FROM TLTX
        WHERE TLTXCD = '6639';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        V_STRDESC:= null;
        V_STREN_DESC:= null;
    END;

    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        := P_TLID;
    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID=L_TXMSG.TLID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.BRID:= null;
    END;
    ------------------------
    L_TXMSG.OFF_LINE    := 'N';
    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.c_txlogged;
    L_TXMSG.MSGSTS      := '0';
    L_TXMSG.OVRSTS      := '0';
    L_TXMSG.BATCHNAME   := 'DAY';
    L_TXMSG.TXDATE      := V_CURRDATE;
    L_TXMSG.BUSDATE     := V_CURRDATE;
    L_TXMSG.TLTXCD      := '6639';
    L_TXMSG.CCYUSAGE    := P_FILEID;
    L_TXMSG.OVRRQD      := '@00';
    L_TXMSG.NOSUBMIT    := '1';

    --send mail SHBVNEX-2061
    FOR V_SENDMAIL IN (SELECT FILEID FROM PAYMENTCASH_R0061_TEMP WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P' GROUP BY FILEID)
    LOOP
        NMPKS_EMS.PR_SENDINTERNALEMAIL('SELECT * FROM DUAL', 'EM44', '','N');
    END LOOP;

    FOR V_REC IN (SELECT * FROM PAYMENTCASH_R0061_TEMP WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P')
    LOOP

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM ----------------------
        BEGIN
            SELECT L_TXMSG.BRID || LPAD(seq_batchtxnum.nextval, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            L_TXMSG.TXNUM:= null;
        END;
        ----GET CUSTODYCD -------------------------------
        BEGIN
            SELECT CUSTODYCD, ACCTNO
            INTO V_CUSTODYCD, V_ACCTNO
            FROM DDMAST
            WHERE REFCASAACCT = V_REC.DEBANKACC
            AND STATUS NOT IN ('C');
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_CUSTODYCD := '';
        END;

        ----SET CIFID ----------------------
        BEGIN
            SELECT CIFID
            INTO V_CIFID
            FROM CFMAST
            WHERE CUSTODYCD = V_CUSTODYCD
            AND STATUS <> 'C';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_CIFID := '';
        END;

        -------------------------------------------------
        BEGIN
            SELECT VARVALUE
            INTO V_CITAD_SHV
            FROM SYSVAR
            WHERE VARNAME ='CITAD_SHINHAN';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_CITAD_SHV := '';
        END;
        /*
        IF FN_GETCITADBYKEYWORD(V_REC.TENNH) = V_CITAD_SHV THEN
            V_BANKNAME := 'Shinhan Bank VietNam';
        END IF;
        */
        BEGIN
            SELECT ST.BANKNAME, ST.BRANCHNAME
            INTO V_BANKNAME, V_BANKBRANCH
            FROM CRBBANKLIST ST
            WHERE CITAD = FN_GETCITADBYKEYWORD(V_REC.TENNH);
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_BANKNAME:= NULL;
            V_BANKBRANCH := NULL;
        END;

        SELECT COUNT(1)
        INTO V_COUNT
        FROM DUAL
        WHERE UPPER(V_REC.TENNH) LIKE '%SHINHAN%';

        IF V_COUNT > 0 THEN
            V_TRANSFER := 'I';
        ELSE
            V_TRANSFER := 'D';
        END IF;

        V_FEETYPE := '3';

        v_feeamt := fn_feecal_6639(V_TRANSFER, V_CUSTODYCD, V_REC.SOTIEN, V_FEETYPE);
        v_netamt := fn_net_amount(V_FEETYPE, V_REC.SOTIEN, V_FEEAMT);

        ----POSTINGDATE ----------------------
        l_txmsg.txfields('01').defname := 'POSTINGDATE';
        l_txmsg.txfields('01').TYPE := 'D';
        l_txmsg.txfields('01').VALUE := TO_CHAR(V_REC.NGAYTT,'DD/MM/RRRR');
        ----TRADINGACCT ----------------------
        l_txmsg.txfields('02').defname := 'TRADINGACCT';
        l_txmsg.txfields('02').TYPE := 'C';
        l_txmsg.txfields('02').VALUE := V_CUSTODYCD;
        ----ACCTNO ----------------------
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').TYPE := 'C';
        l_txmsg.txfields('03').VALUE := V_ACCTNO;
        ----PORFOLIO ----------------------
        l_txmsg.txfields('04').defname := 'PORFOLIO';
        l_txmsg.txfields('04').TYPE := 'C';
        l_txmsg.txfields('04').VALUE := V_CIFID;
        ----BALANCE ----------------------
        l_txmsg.txfields('05').defname := 'BALANCE';
        l_txmsg.txfields('05').TYPE := 'N';
        l_txmsg.txfields('05').VALUE := FN_GET_BALANCE_6639(V_ACCTNO);
        ----AVAILABLE ----------------------
        l_txmsg.txfields('06').defname := 'AVAILABLE';
        l_txmsg.txfields('06').TYPE := 'N';
        l_txmsg.txfields('06').VALUE := FN_GET_AVAILBALANCE_6639(V_ACCTNO);
        ----INSTRUCTION ----------------------
        l_txmsg.txfields('07').defname := 'INSTRUCTION';
        l_txmsg.txfields('07').TYPE := 'C';
        l_txmsg.txfields('07').VALUE := 'TARD';
        ----TRANSFER ----------------------
        l_txmsg.txfields('08').defname := 'TRANSFER';
        l_txmsg.txfields('08').TYPE := 'C';
        l_txmsg.txfields('08').VALUE := V_TRANSFER;
        ----CITAD ----------------------
        l_txmsg.txfields('09').defname := 'CITAD';
        l_txmsg.txfields('09').TYPE := 'C';
        l_txmsg.txfields('09').VALUE := fn_getcitadbykeyword(V_REC.TENNH);
        ----AMT ----------------------
        l_txmsg.txfields('10').defname := 'AMT';
        l_txmsg.txfields('10').TYPE := 'N';
        l_txmsg.txfields('10').VALUE := V_REC.SOTIEN;
        ----BANK ----------------------
        l_txmsg.txfields('11').defname := 'BANK';
        l_txmsg.txfields('11').TYPE := 'C';
        l_txmsg.txfields('11').VALUE := V_BANKNAME;
        ----BANKBRANCH ----------------------
        l_txmsg.txfields('12').defname := 'BANKBRANCH';
        l_txmsg.txfields('12').TYPE := 'C';
        l_txmsg.txfields('12').VALUE := V_BANKBRANCH;
        ----BANKACCTNO ----------------------
        l_txmsg.txfields('13').defname := 'BANKACCTNO';
        l_txmsg.txfields('13').TYPE := 'C';
        l_txmsg.txfields('13').VALUE := V_REC.BANKACC;
        ----NAME ----------------------
        l_txmsg.txfields('14').defname := 'NAME';
        l_txmsg.txfields('14').TYPE := 'C';
        l_txmsg.txfields('14').VALUE := V_REC.TENTHUHUONG;
        ----REFCONTRACT ----------------------
        l_txmsg.txfields('15').defname := 'REFCONTRACT';
        l_txmsg.txfields('15').TYPE := 'C';
        l_txmsg.txfields('15').VALUE := V_REC.SOTHCHIEU;
        ----FEETYPE ----------------------
        l_txmsg.txfields('16').defname := 'FEETYPE';
        l_txmsg.txfields('16').TYPE := 'C';
        l_txmsg.txfields('16').VALUE := V_FEETYPE;
        ----VALUEDATE ----------------------
        l_txmsg.txfields('17').defname := 'VALUEDATE';
        l_txmsg.txfields('17').TYPE := 'C';
        l_txmsg.txfields('17').VALUE := TO_CHAR(V_REC.NGAYTT,'DD/MM/RRRR');
        ----Fee AMT ----------------------
        l_txmsg.txfields('19').defname := 'Fee AMT';
        l_txmsg.txfields('19').TYPE := 'N';
        l_txmsg.txfields('19').VALUE := v_feeamt;
        ----Net AMT ----------------------
        l_txmsg.txfields('20').defname := 'Net AMT';
        l_txmsg.txfields('20').TYPE := 'N';
        l_txmsg.txfields('20').VALUE := v_netamt;
        ----DESC ----------------------
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').TYPE := 'C';
        l_txmsg.txfields('30').VALUE := SUBSTR(V_REC.NOIDUNG, 1, 200);
        --------------------------------------------------------------------------------

        p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
        IF TXPKS_#6639.fn_txProcess(p_xmlmsg, V_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
            
            P_ERR_CODE:=V_ERR_CODE;
            ROLLBACK;
            PLOG.SETENDSECTION(PKGCTX, 'pr_auto_6639');
            RETURN;
        ELSE
            UPDATE PAYMENTCASH_R0061_TEMP SET STATUS = 'C' WHERE AUTOID = V_REC.AUTOID AND FILEID = P_FILEID;
            UPDATE TLLOG
            SET TXSTATUS = TXSTATUSNUMS.C_TXPENDING
            WHERE TXDATE = TO_DATE(L_TXMSG.TXDATE,SYSTEMNUMS.C_DATE_FORMAT)
            AND TXNUM = L_TXMSG.TXNUM;
        END IF;
    END LOOP;

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'System error. Invalid file format';
        plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
        RETURN;
END PR_PAYMENTCASH_R0061;

PROCEDURE PR_CHECK_I088(p_tlid in varchar2, p_fileid in varchar2, p_err_code OUT varchar2, p_err_message OUT varchar2)
IS
v_count number;
BEGIN

    plog.setbeginsection(pkgctx, 'PR_CHECK_I088');
    v_count := 0;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Transaction Invalid!'
    WHERE TLTXCD NOT IN ('1407','1404','1405')
    AND FILEID = p_fileid;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import Trans.code not under management!'
    WHERE FILEID = p_fileid
    AND TRIM(TLTXCD) IS NULL;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import effect date invalid!'
    WHERE TLTXCD = '1407'
    AND FILEID = p_fileid
    AND TRIM(EFFECTDATE) IS NULL;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import Trading account not under management!'
    WHERE TLTXCD = '1407'
    AND FILEID = p_fileid
    AND (TRIM(TRADINGACCOUNT) IS NULL OR 0 = (SELECT COUNT(1)
                                        FROM CFMAST
                                        WHERE CFMAST.CUSTODYCD = TBL_I088.TRADINGACCOUNT
                                        AND CFMAST.STATUS <> 'C'));

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import Trading account with closed status!'
    WHERE TLTXCD = '1407'
    AND FILEID = p_fileid
    AND 1 = (SELECT COUNT(1)
            FROM CFMAST
            WHERE CFMAST.CUSTODYCD = TBL_I088.TRADINGACCOUNT
            AND CFMAST.STATUS = 'C');

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import securities not under management!'
    WHERE TLTXCD = '1407'
    AND FILEID = p_fileid
    AND (TRIM(SYMBOL) IS NULL OR 0 = (SELECT COUNT(1)
                                FROM SBSECURITIES SB, ISSUERS ISS
                                WHERE SB.REFCODEID IS NULL
                                AND SB.ISSUERID = ISS.ISSUERID
                                AND SB.SECTYPE <> '004'
                                AND SB.SYMBOL = TBL_I088.SYMBOL));

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import beneficiary bank invalid!'
    WHERE TLTXCD = '1407'
    AND FILEID = p_fileid
    AND TRIM(BANKNAME) IS NULL;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import bank account of issuer invalid!'
    WHERE TLTXCD = '1407'
    AND FILEID = p_fileid
    AND TRIM(BANKACCOUNT) IS NULL;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import bank account of issuer invalid!'
    WHERE TLTXCD = '1407'
    AND FILEID = p_fileid
    AND TRIM(ISSUERNAME) IS NULL;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import valueof <=0 or Null!'
    WHERE TLTXCD = '1407'
    AND FILEID = p_fileid
    AND NVL(VALUEOF, 0) <= 0;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import Agreement ID not under management!'
    WHERE TLTXCD in ('1404','1405')
    AND FILEID = p_fileid
    AND (TRIM(AGRID) IS NULL OR 0 = (SELECT COUNT(1)
                               FROM CRPHYSAGREE
                               WHERE CRPHYSAGREE.DELTD <>'Y'
                               AND CRPHYSAGREE.STATUS = 'A'
                               AND CRPHYSAGREE.CRPHYSAGREEID = TBL_I088.AGRID));

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import amount <=0 or Null!'
    WHERE FILEID = p_fileid
    AND NVL(QTTY, 0) <= 0;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import sender invalid!'
    WHERE TLTXCD = '1405'
    AND FILEID = p_fileid
    AND TRIM(SENDER) IS NULL;

    UPDATE TBL_I088 SET STATUS = 'E', ERRMSG = 'Do not import Receiver invalid!'
    WHERE TLTXCD = '1405'
    AND FILEID = p_fileid
    AND TRIM(RECEIVER) IS NULL;

    SELECT COUNT(1) INTO V_COUNT FROM TBL_I088 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    if v_count > 0 then
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
    end if;

    plog.setendsection(pkgctx, 'PR_CHECK_I088');

exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_CHECK_I088;

PROCEDURE PR_PROCNAME_I088(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2)
IS
    L_TXMSG       TX.MSG_RECTYPE;
    P_XMLMSG      VARCHAR2(4000);
    V_ERR_CODE    VARCHAR2(10);
    V_COUNT         NUMBER;
    V_CURRDATE    DATE;
    V_STRDESC     VARCHAR2(1000);
    V_STREN_DESC  VARCHAR2(1000);
    V_CODEID VARCHAR2(50);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_PROCNAME_I088');
    V_COUNT := 0;
    V_CURRDATE := getcurrdate;
    V_ERR_CODE := SYSTEMNUMS.C_SUCCESS;
    -------------------------------

    BEGIN
        SELECT TXDESC, EN_TXDESC
        INTO V_STRDESC, V_STREN_DESC
        FROM TLTX
        WHERE TLTXCD = '6639';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        V_STRDESC:= null;
        V_STREN_DESC:= null;
    END;

    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        := P_TLID;
    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID=L_TXMSG.TLID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.BRID:= null;
    END;
    ------------------------
    L_TXMSG.OFF_LINE    := 'N';
    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.c_txpending;
    L_TXMSG.MSGSTS      := '0';
    L_TXMSG.ovrrqd      := '@00'; --31/12/2020 SHBVNEX-1957 trung.luu: sinh gd cho duyet thieu thong tin
    L_TXMSG.OVRSTS      := '0';
    L_TXMSG.BATCHNAME   := 'DAY';
    L_TXMSG.TXDATE      := V_CURRDATE;
    L_TXMSG.BUSDATE     := V_CURRDATE;

    FOR V_REC IN (SELECT * FROM TBL_I088 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P')
    LOOP
        L_TXMSG.TLTXCD := V_REC.TLTXCD;
        ----SET TXNUM ----------------------
        BEGIN
            SELECT L_TXMSG.BRID || LPAD(seq_batchtxnum.nextval, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
        EXCEPTION WHEN OTHERS THEN
            SELECT L_TXMSG.BRID || LPAD(seq_batchtxnum.nextval, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
        END;

        IF V_REC.TLTXCD = '1407' THEN
            --25    S?   C
                 l_txmsg.txfields ('25').defname   := 'No';
                 l_txmsg.txfields ('25').TYPE      := 'C';
                 l_txmsg.txfields ('25').value      := V_REC.AGRNO;
            --28    S? H?p Ð?ng M?   C
                 l_txmsg.txfields ('28').defname   := 'ORIGIONAL_NO';
                 l_txmsg.txfields ('28').TYPE      := 'C';
                 l_txmsg.txfields ('28').value      := V_REC.CONTRACTNO;
            --24    Tên   C
                 l_txmsg.txfields ('24').defname   := 'NAME ';
                 l_txmsg.txfields ('24').TYPE      := 'C';
                 l_txmsg.txfields ('24').value      := V_REC.AGRNAME ;
            --14    Ngày t?o HÐ   D
                 l_txmsg.txfields ('14').defname   := 'CREATDATE';
                 l_txmsg.txfields ('14').TYPE      := 'C';
                 l_txmsg.txfields ('14').value      := TO_CHAR(V_CURRDATE, 'DD/MM/RRRR');
            --18    Ngày hi?u l?c HÐ   D
                 l_txmsg.txfields ('18').defname   := 'EFFDATE';
                 l_txmsg.txfields ('18').TYPE      := 'C';
                 l_txmsg.txfields ('18').value      := TO_CHAR(V_REC.EFFECTDATE, 'DD/MM/RRRR');
            FOR V_CF IN (SELECT * FROM CFMAST WHERE CUSTODYCD = V_REC.TRADINGACCOUNT AND STATUS <> 'C')
            LOOP
                --88    S? TK mua   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := V_CF.CUSTODYCD;
                --90    H? tên   C
                     l_txmsg.txfields ('90').defname   := 'FULLNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := V_CF.FULLNAME;
                --17    Mã TK   C
                     l_txmsg.txfields ('17').defname   := 'CUSTID';
                     l_txmsg.txfields ('17').TYPE      := 'C';
                     l_txmsg.txfields ('17').value      := V_CF.CUSTID;
                --03    S? ti?u kho?n   C
                     l_txmsg.txfields ('03').defname   := 'ACCTNO';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := V_CF.CUSTID;
            END LOOP;

            FOR V_SB IN (
                SELECT SB.CODEID,SB.ISSUERID,ISS.FULLNAME ISSUERNAME,SB.SYMBOL,SB.PARVALUE,SB.FOREIGNRATE,SB.ISSUEDATE,SB.EXPDATE,SB.INTCOUPON,SB.INTERESTDATE
                FROM SBSECURITIES SB, ISSUERS ISS
                WHERE SB.REFCODEID IS NULL
                AND SB.ISSUERID = ISS.ISSUERID
                AND SB.SECTYPE <> '004'
                AND SB.SYMBOL = V_REC.SYMBOL
            )
            LOOP
                L_TXMSG.CCYUSAGE := V_SB.CODEID;
                --29    Mã CK   C
                     l_txmsg.txfields ('29').defname   := 'SYMBOL';
                     l_txmsg.txfields ('29').TYPE      := 'C';
                     l_txmsg.txfields ('29').value      := V_SB.SYMBOL;
                --15    Mã CK   C
                     l_txmsg.txfields ('15').defname   := 'CODEID';
                     l_txmsg.txfields ('15').TYPE      := 'C';
                     l_txmsg.txfields ('15').value      := V_SB.CODEID;
                --23    TCPH   C
                     l_txmsg.txfields ('23').defname   := 'ISSUERID';
                     l_txmsg.txfields ('23').TYPE      := 'C';
                     l_txmsg.txfields ('23').value      := V_SB.ISSUERID;
                --22    Ngày phát hành   D
                     l_txmsg.txfields ('22').defname   := 'ISSUEDATE';
                     l_txmsg.txfields ('22').TYPE      := 'C';
                     l_txmsg.txfields ('22').value      := V_SB.ISSUEDATE;
                --19    Ngày d?n h?n   D
                     l_txmsg.txfields ('19').defname   := 'EXPDATE';
                     l_txmsg.txfields ('19').TYPE      := 'C';
                     l_txmsg.txfields ('19').value      := V_SB.EXPDATE;
                --20    Lãi su?t d?n h?n   N
                     l_txmsg.txfields ('20').defname   := 'INTCOUPON';
                     l_txmsg.txfields ('20').TYPE      := 'N';
                     l_txmsg.txfields ('20').value      := V_SB.INTCOUPON;
                --21    Co s? ngày tính lãi   C
                     l_txmsg.txfields ('21').defname   := 'INTERESTDATE';
                     l_txmsg.txfields ('21').TYPE      := 'C';
                     l_txmsg.txfields ('21').value      := V_SB.INTERESTDATE;
                --26    M?nh giá   N
                     l_txmsg.txfields ('26').defname   := 'PARVALUE';
                     l_txmsg.txfields ('26').TYPE      := 'N';
                     l_txmsg.txfields ('26').value      := V_SB.PARVALUE;
            END LOOP;
            --27    S? lu?ng   N
                 l_txmsg.txfields ('27').defname   := 'QTTY';
                 l_txmsg.txfields ('27').TYPE      := 'N';
                 l_txmsg.txfields ('27').value      := V_REC.QTTY;
            --10    Giá tr? physical   N
                 l_txmsg.txfields ('10').defname   := 'CLVALUE';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := V_REC.VALUEOF;
            --13    Mã CITAD   C
                 l_txmsg.txfields ('13').defname   := 'CITAD';
                 l_txmsg.txfields ('13').TYPE      := 'C';
                 l_txmsg.txfields ('13').value      := V_REC.CITADCODE;
            --12    NH th? hu?ng   C
                 l_txmsg.txfields ('12').defname   := 'BANKCODE';
                 l_txmsg.txfields ('12').TYPE      := 'C';
                 l_txmsg.txfields ('12').value      := V_REC.BANKNAME;
            --11    S? TK c?a TCPH   C
                 l_txmsg.txfields ('11').defname   := 'BANKACCTNO';
                 l_txmsg.txfields ('11').TYPE      := 'C';
                 l_txmsg.txfields ('11').value      := V_REC.BANKACCOUNT;
            --32    Tên ngu?i th? hu?ng   C
                 l_txmsg.txfields ('32').defname   := 'BNAME';
                 l_txmsg.txfields ('32').TYPE      := 'C';
                 l_txmsg.txfields ('32').value      := V_REC.ISSUERNAME;
            --31    S? h?p d?ng tái t?c   C
                 l_txmsg.txfields ('31').defname   := 'ROLLOVER_NO';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := V_REC.ROCONTRACTNO;
             --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := V_REC.MEMO;
             --99
                 l_txmsg.txfields ('99').defname   := 'PAYSTATUS';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := '';

                 SELECT DECODE(TRIM(V_REC.TRANTYPE), 'N', 'T', 'P')
                 INTO l_txmsg.txfields ('99').value
                 FROM DUAL;

            p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
            IF TXPKS_#1407.fn_txProcess(p_xmlmsg, V_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
                
                P_ERR_CODE:=V_ERR_CODE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PR_PROCNAME_I088');
                RETURN;
            ELSE
                UPDATE TBL_I088 SET STATUS = 'C' WHERE AUTOID = V_REC.AUTOID AND FILEID = P_FILEID;
            END IF;
        END IF;

        IF V_REC.TLTXCD = '1404' THEN
            --02    Mã tham chi?u h?p d?ng   C
                 l_txmsg.txfields ('02').defname   := 'CRPHYSAGREEID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := V_REC.AGRID;
             FOR V_CR IN (
                SELECT CR.CRPHYSAGREEID, CR.CUSTODYCD, CR.ACCTNO, CR.SYMBOL, CR.CODEID, CF.FULLNAME
                ,(CASE WHEN CRLOG.AQTTY IS NULL THEN CR.QTTY ELSE (CR.QTTY - CRLOG.AQTTY) END) REMQTTY
                FROM (SELECT * fROM CRPHYSAGREE WHERE DELTD <>'Y') CR, CFMAST CF,
                (SELECT CRL.CRPHYSAGREEID, SUM(CRL.QTTY) AQTTY FROM CRPHYSAGREE_LOG CRL WHERE CRL.TYPE = 'R' AND CRL.DELTD <> 'Y' GROUP BY CRL.CRPHYSAGREEID) CRLOG
                WHERE CR.CRPHYSAGREEID = CRLOG.CRPHYSAGREEID(+)
                AND CR.STATUS = 'A'
                AND CR.CUSTODYCD = CF.CUSTODYCD
                AND CR.CRPHYSAGREEID = V_REC.AGRID
            )
            LOOP
                L_TXMSG.CCYUSAGE := V_CR.CODEID;
                --09    Khách hàng   C
                     l_txmsg.txfields ('09').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('09').TYPE      := 'C';
                     l_txmsg.txfields ('09').value      := V_CR.CUSTODYCD;
                --90    H? tên   C
                     l_txmsg.txfields ('90').defname   := 'FULLNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := V_CR.FULLNAME;
                --04    Mã CK   C
                     l_txmsg.txfields ('04').defname   := 'SYMBOL';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := V_CR.SYMBOL;
                --01    Mã quy u?c   C
                     l_txmsg.txfields ('01').defname   := 'CODEID';
                     l_txmsg.txfields ('01').TYPE      := 'C';
                     l_txmsg.txfields ('01').value      := V_CR.CODEID;
                --55    SL physical c?n TT   N
                     l_txmsg.txfields ('55').defname   := 'SETQTTY';
                     l_txmsg.txfields ('55').TYPE      := 'N';
                     l_txmsg.txfields ('55').value      := V_CR.REMQTTY;
            END LOOP;
            --13    S? lu?ng c?n th?c hi?n   N
                 l_txmsg.txfields ('13').defname   := 'QTTY';
                 l_txmsg.txfields ('13').TYPE      := 'N';
                 l_txmsg.txfields ('13').value      := V_REC.QTTY;
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := V_REC.MEMO;
            p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
            IF TXPKS_#1404.fn_txProcess(p_xmlmsg, V_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
                
                P_ERR_CODE:=V_ERR_CODE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PR_PROCNAME_I088');
                RETURN;
            ELSE
                UPDATE TBL_I088 SET STATUS = 'C' WHERE AUTOID = V_REC.AUTOID AND FILEID = P_FILEID;
            END IF;
        END IF;

        IF V_REC.TLTXCD = '1405' THEN
            --01    Ngày giao d?ch   D
                 l_txmsg.txfields ('01').defname   := 'TXDATE';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := TO_CHAR(V_REC.POSTINGDATE, 'DD/MM/RRRR');
            --02    Mã tham chi?u h?p d?ng   C
                 l_txmsg.txfields ('02').defname   := 'CRPHYSAGREEID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := V_REC.AGRID;

            FOR V_CF IN (SELECT * FROM CFMAST WHERE CUSTODYCD = V_REC.TRADINGACCOUNT AND STATUS <> 'C')
            LOOP
                --88    Khách hàng   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := V_CF.CUSTODYCD;
                --90    H? tên   C
                     l_txmsg.txfields ('90').defname   := 'FULLNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := V_CF.FULLNAME;
            END LOOP;

            FOR V_SB IN (
                SELECT SB.CODEID,SB.ISSUERID,ISS.FULLNAME ISSUERNAME,SB.SYMBOL,SB.PARVALUE,SB.FOREIGNRATE,SB.ISSUEDATE,SB.EXPDATE,SB.INTCOUPON,SB.INTERESTDATE
                FROM SBSECURITIES SB, ISSUERS ISS
                WHERE SB.REFCODEID IS NULL
                AND SB.ISSUERID = ISS.ISSUERID
                AND SB.SECTYPE <> '004'
                AND SB.SYMBOL = V_REC.SYMBOL
            )
            LOOP
                L_TXMSG.CCYUSAGE := V_SB.CODEID;
                --03    Mã CK   C
                     l_txmsg.txfields ('03').defname   := 'CODEID';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := V_SB.CODEID;
            END LOOP;

            FOR V_CR IN (
                SELECT SB.CODEID, SB.INTERESTDATE, ISS.FULLNAME ISSUERNAME, CF.FULLNAME, CF.CUSTODYCD
                FROM (SELECT * fROM CRPHYSAGREE WHERE DELTD <> 'Y') CR, ISSUERS ISS, SBSECURITIES SB, CFMAST CF
                WHERE CR.ISSUERID = ISS.ISSUERID
                AND CR.CODEID = SB.CODEID
                AND CF.CUSTODYCD = CR.CUSTODYCD
                AND CR.STATUS = 'A'
                AND CR.QTTY > CR.REQTTY
                AND CR.CRPHYSAGREEID = V_REC.AGRID
            )
            LOOP
                L_TXMSG.CCYUSAGE := V_CR.CODEID;
                --88    Khách hàng   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := V_CR.CUSTODYCD;
                --90    H? tên   C
                     l_txmsg.txfields ('90').defname   := 'FULLNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := V_CR.FULLNAME;
                --03    Mã CK   C
                     l_txmsg.txfields ('03').defname   := 'CODEID';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := V_CR.CODEID;
            END LOOP;

            --15    SL trên h?p d?ng   N
                 l_txmsg.txfields ('15').defname   := 'CRQTTY';
                 l_txmsg.txfields ('15').TYPE      := 'N';
                 l_txmsg.txfields ('15').value      := FN_CHECK_CRQTTY_1405(V_REC.AGRID);
            --10    SL nh?p   N
                 l_txmsg.txfields ('10').defname   := 'QTTY';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := V_REC.QTTY;
            --11    Mã hi?u ch?ng t?   C
                 l_txmsg.txfields ('11').defname   := 'REFNO';
                 l_txmsg.txfields ('11').TYPE      := 'C';
                 l_txmsg.txfields ('11').value      := V_REC.DOCUMENTNO;
            --31    Ngu?i giao    C
                 l_txmsg.txfields ('31').defname   := 'SENDER';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := V_REC.SENDER;
            --32    Ngu?i nh?n   C
                 l_txmsg.txfields ('32').defname   := 'RECEIVER';
                 l_txmsg.txfields ('32').TYPE      := 'C';
                 l_txmsg.txfields ('32').value      := V_REC.RECEIVER;
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := V_REC.MEMO;

            p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
            IF TXPKS_#1405.fn_txProcess(p_xmlmsg, V_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
                
                P_ERR_CODE:=V_ERR_CODE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PR_PROCNAME_I088');
                RETURN;
            ELSE
                UPDATE TBL_I088 SET STATUS = 'C' WHERE AUTOID = V_REC.AUTOID AND FILEID = P_FILEID;
            END IF;
        END IF;
    END LOOP;

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'System error. Invalid file format';
        plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
        RETURN;
END PR_PROCNAME_I088;

PROCEDURE PR_CHECK_I099(p_tlid in varchar2, p_fileid in varchar2, p_err_code OUT varchar2, p_err_message OUT varchar2)
IS
v_count number;
BEGIN

    plog.setbeginsection(pkgctx, 'PR_CHECK_I099');
    v_count := 0;

    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import effect date invalid!'
    WHERE (TRIM(EFFDATE) IS NULL OR fn_isdate(EFFDATE) IS NULL)
    AND FILEID = p_fileid;

    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = ' Do not import Exprice date invalid!'
    WHERE FILEID = p_fileid
    AND (TRIM(EXPDATE) IS NULL OR fn_isdate(EXPDATE) IS NULL);

    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Trading account not under management!'
    WHERE FILEID = p_fileid
    AND (TRIM(CUSTODYCD) IS NULL OR 0 = (SELECT COUNT(1)
                                        FROM CFMAST
                                        WHERE CFMAST.CUSTODYCD = TBLIMPI099.CUSTODYCD
                                        AND CFMAST.STATUS <> 'C'));

    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Trading account with closed status!'
    WHERE FILEID = p_fileid
    AND 1 = (SELECT COUNT(1)
            FROM CFMAST
            WHERE CFMAST.CUSTODYCD = TBLIMPI099.CUSTODYCD
            AND CFMAST.STATUS = 'C');

    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Fee not under management!'
    WHERE FILEID = p_fileid
    AND (TRIM(FEECD) IS NULL OR 0 = (SELECT COUNT(1)
                                        FROM FEEMASTER
                                        WHERE FEEMASTER.FEECD = TBLIMPI099.FEECD));
    BEGIN
    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Min value <=0 or Null!'
    WHERE FILEID = p_fileid
    AND (TRIM(MINVAL) IS NULL OR TO_NUMBER(MINVAL) < 0);
    EXCEPTION WHEN OTHERS THEN
        UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Min value <=0 or Null!'
        WHERE FILEID = p_fileid and TRIM(MINVAL) <> '-';
    END;


    BEGIN
    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Max value <=0 or Null!'
    WHERE FILEID = p_fileid
    AND (TRIM(MAXVAL) IS NULL OR TO_NUMBER(MAXVAL) < 0);
    EXCEPTION WHEN OTHERS THEN
        UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Max value <=0 or Null!'
        WHERE FILEID = p_fileid and TRIM(MAXVAL) <> '-';
    END;

    BEGIN
    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import vat rate <=0 or Null!'
    WHERE FILEID = p_fileid
    AND (TRIM(VATRATE) IS NULL OR TO_NUMBER(VATRATE) < 0);
    EXCEPTION WHEN OTHERS THEN
        UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import vat rate <=0 or Null!'
        WHERE FILEID = p_fileid and TRIM(VATRATE) <> '-';
    END;

    BEGIN
    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Fee rate <=0 or Null!'
    WHERE FILEID = p_fileid
    AND (TRIM(FEERATE) IS NULL OR TO_NUMBER(FEERATE) < 0);
    EXCEPTION WHEN OTHERS THEN
        UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Fee rate <=0 or Null!'
        WHERE FILEID = p_fileid and TRIM(FEERATE) <> '-';
    END;

    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = ' Do not import Type <>"P" or "F" Or Null'
    WHERE FILEID = p_fileid
    AND (TRIM(FORP) IS NULL OR FORP NOT IN ('P','F'));

    BEGIN
    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Fee amount ( VAT- exclusive) invalid!'
    WHERE FILEID = p_fileid
    AND (TRIM(FEEVAL) IS NULL OR TO_NUMBER(FEEVAL) < 0);
    EXCEPTION WHEN OTHERS THEN
        UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Fee amount ( VAT- exclusive) invalid!'
        WHERE FILEID = p_fileid and TRIM(FEEVAL) <> '-';
    END;

    BEGIN
    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Fee amount ( VAT- inclusive) invalid!'
    WHERE FILEID = p_fileid
    AND (TRIM(FEEAMTVAL) IS NULL OR TO_NUMBER(FEEAMTVAL) < 0);
    EXCEPTION WHEN OTHERS THEN
        UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Fee amount ( VAT- inclusive) invalid!'
        WHERE FILEID = p_fileid and TRIM(FEEAMTVAL) <> '-';
    END;

    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Do not import Currency invalid or not under management!'
    WHERE FILEID = p_fileid
    AND (TRIM(CCYCD) IS NULL OR 0 = (SELECT COUNT(1)
                                        FROM ALLCODE
                                        WHERE ALLCODE.CDVAL = TBLIMPI099.CCYCD
                                        AND ALLCODE.CDNAME ='CCYCD' AND ALLCODE.CDTYPE='FA'));



    UPDATE TBLIMPI099 SET STATUS = 'E', ERRMSG = 'Duplicate fee schedule declared in the system!'
    WHERE FILEID = p_fileid
    AND (CUSTODYCD, FEECD) IN (SELECT CUSTODYCD, FEECD FROM CFFEEEXP WHERE CUSTODYCD = TBLIMPI099.CUSTODYCD AND FEECD = TBLIMPI099.FEECD);

    SELECT COUNT(1) INTO V_COUNT FROM TBLIMPI099 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    if v_count > 0 then
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
    end if;

    plog.setendsection(pkgctx, 'PR_CHECK_I099');

exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_CHECK_I099;

PROCEDURE PR_APR_I099(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2)
IS
    L_TXMSG       TX.MSG_RECTYPE;
    P_XMLMSG      VARCHAR2(4000);
    V_ERR_CODE    VARCHAR2(10);
    V_COUNT         NUMBER;
    v_autoid    varchar2(4);
    L_AUTOID    number;
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_APR_I099');
    SELECT MAX(TO_NUMBER(AUTOID)) + 1 INTO L_AUTOID FROM CFFEEEXP;
    FOR REC IN (SELECT * FROM TBLIMPI099 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P')
    LOOP
        SELECT COUNT(*) INTO V_COUNT FROM CFFEEEXP WHERE CUSTODYCD = REC.CUSTODYCD AND FEECD = REC.FEECD;
        IF V_COUNT = 0 THEN
            SELECT LPAD(NVL(L_AUTOID,'1'),4,'0') into v_autoid FROM DUAL;
            INSERT INTO CFFEEEXP (autoid, txdate,txnum,deltd,status,feecd,custodycd,effdate,expdate,
            minval,maxval,feeval,amcid,ccycd,vatrate,feeamtvat,forp,feerate)
            VALUES (v_autoid,NULL,NULL,'N','N',REC.FEECD,REC.CUSTODYCD,TO_DATE(REC.EFFDATE,'DD/MM/RRRR'),TO_DATE(REC.EXPDATE,'DD/MM/RRRR'),
            TO_NUMBER(DECODE(REC.MINVAL,'-','0',REC.MINVAL)),TO_NUMBER(DECODE(REC.MAXVAL,'-','0',REC.MAXVAL)),
            TO_NUMBER(DECODE(REC.FEEVAL,'-','0',REC.FEEVAL)),NULL,REC.CCYCD,
            TO_NUMBER(DECODE(REC.VATRATE,'-','0',REC.VATRATE)),TO_NUMBER(DECODE(REC.FEEAMTVAL,'-','0',REC.FEEAMTVAL)),
            REC.FORP,TO_NUMBER(DECODE(REC.FEERATE,'-','0',REC.FEERATE)));
            L_AUTOID:= L_AUTOID + 1;

            UPDATE TBLIMPI099 SET STATUS = 'C' WHERE AUTOID = REC.AUTOID AND FILEID = P_FILEID;
        ELSE
                P_ERR_CODE:='-107703';
                PLOG.ERROR(PKGCTX, ' Import I099 error ' || P_ERR_CODE || ':' || P_ERR_MESSAGE);
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PR_APR_I099');
                RETURN;
        END IF;
    END LOOP;
EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'System error. Invalid file format';
        plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
        RETURN;
END PR_APR_I099;

PROCEDURE PR_CHECK_I083(p_tlid in varchar2, p_fileid in varchar2, p_err_code OUT varchar2, p_err_message OUT varchar2)
IS
BEGIN

    plog.setbeginsection(pkgctx, 'PR_CHECK_I083');

    plog.setendsection(pkgctx, 'PR_CHECK_I083');

exception
when others then
    --rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_CHECK_I083;

PROCEDURE PR_PROCNAME_I083(P_TLID IN VARCHAR2, p_fileid in varchar2, P_ERR_CODE  OUT VARCHAR2,P_ERR_MESSAGE  OUT VARCHAR2)
IS
    V_TXDATE DATE;
    V_COUNT NUMBER;
    V_SQL VARCHAR2(4000);
BEGIN

    plog.setbeginsection(pkgctx, 'PR_PROCNAME_I083');
    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

    SELECT TRADE_DATE INTO V_TXDATE
    FROM TBLI083
    WHERE FILEID = P_FILEID
    GROUP BY TRADE_DATE;

    SELECT COUNT(1)
    INTO V_COUNT
    FROM BONDPRICING
    WHERE TXDATE = V_TXDATE;

    IF V_COUNT > 0 THEN
        V_SQL := 'UPDATE BONDPRICING SET ';
        FOR REC IN (
            SELECT TB.*, TM.VAL
            FROM TBLI083 TB, TBLI083_MAP TM
            WHERE TB.FILEID = P_FILEID
            AND NVL(TB.STATUS,'P') = 'P'
            AND UPPER(TB.PERIOD) = UPPER(TM.CONTENT)
        )
        LOOP
            V_SQL := V_SQL || REC.VAL || ' = ' || TO_CHAR(IS_NUMBER(REC.PARYIELD)/100,'FM999999999999990.9999999999999999999') || ', ';
        END LOOP;

        V_SQL := V_SQL || ' AUTOID = ' || P_FILEID || ', ';
        V_SQL := V_SQL || ' STATUS = ''A'', ';
        V_SQL := V_SQL || ' PSTATUS = NULL, ';
        V_SQL := V_SQL || ' FILEID = ''' || P_FILEID || ''', ';
        V_SQL := V_SQL || ' TLIDIMP = ''' || P_TLID || ''', ';
        V_SQL := V_SQL || ' TLIDOVR = ''' || P_TLID || ''', ';
        V_SQL := V_SQL || ' LASTCHANGE = systimestamp ';
        V_SQL := V_SQL || ' WHERE TXDATE = TO_DATE('''|| TO_CHAR(V_TXDATE,'DD/MM/RRRR') ||''',''DD/MM/RRRR'')';

        INSERT INTO BONDPRICING_HIST SELECT * FROM BONDPRICING WHERE TXDATE = V_TXDATE;
        EXECUTE IMMEDIATE V_SQL;
        UPDATE TBLI083 SET STATUS = 'C', ERRMSG = 'Sucessfull', TIMEAPR= systimestamp, TLIDOVR=P_TLID WHERE FILEID = P_FILEID;

    ELSE
        V_SQL := 'INSERT INTO BONDPRICING(';

        FOR REC IN (
            SELECT TB.*, TM.VAL
            FROM TBLI083 TB, TBLI083_MAP TM
            WHERE TB.FILEID = P_FILEID
            AND NVL(TB.STATUS,'P') = 'P'
            AND UPPER(TB.PERIOD) = UPPER(TM.CONTENT)
        )
        LOOP
            V_SQL := V_SQL || REC.VAL || ', ';
        END LOOP;

        V_SQL := V_SQL || 'AUTOID,TXDATE,STATUS,PSTATUS,FILEID,TLIDIMP,TLIDOVR) VALUES(';

        FOR REC IN (
            SELECT TB.*, TM.VAL
            FROM TBLI083 TB, TBLI083_MAP TM
            WHERE TB.FILEID = P_FILEID
            AND NVL(TB.STATUS,'P') = 'P'
            AND UPPER(TB.PERIOD) = UPPER(TM.CONTENT)
        )
        LOOP
            V_SQL := V_SQL || TO_CHAR(IS_NUMBER(REC.PARYIELD)/100,'FM999999999999990.9999999999999999999') || ', ';
        END LOOP;

        V_SQL := V_SQL || P_FILEID || ', ';
        V_SQL := V_SQL || 'TO_DATE('''|| TO_CHAR(V_TXDATE,'DD/MM/RRRR') ||''',''DD/MM/RRRR''), ''A'', NULL,';
        V_SQL := V_SQL || '''' || P_FILEID || ''', ';
        V_SQL := V_SQL || '''' || P_TLID || ''', ';
        V_SQL := V_SQL || '''' || P_TLID || ''') ';

        EXECUTE IMMEDIATE V_SQL;
        UPDATE TBLI083 SET STATUS = 'C', ERRMSG = 'Sucessfull', TIMEAPR = SYSTIMESTAMP, TLIDOVR = P_TLID WHERE FILEID = P_FILEID;
    END IF;

plog.setendsection(pkgctx, 'PR_PROCNAME_I083');

EXCEPTION
WHEN OTHERS THEN
    ROLLBACK;
    PLOG.ERROR ('PR_PROCNAME_I083 ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    p_err_code := errnums.C_SYSTEM_ERROR;
    P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
RETURN;
END PR_PROCNAME_I083;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_filemaster',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
