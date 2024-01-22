SET DEFINE OFF;
CREATE OR REPLACE PACKAGE fopks_file IS

  /* ----------------------------------------------------------------------------------------------------
  ** (c) 2019 by Financial Software Solutions. JSC.
  ** All API for Import file from web
  ----------------------------------------------------------------------------------------------------*/

  procedure PRC_FILEMASTER(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_cmdid in varchar2,
                    p_tlid in varchar2,
                    p_role in VARCHAR2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
 procedure PRC_FILEMAP(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_filecode in varchar2,
                    p_tlid in varchar2,
                    p_role in varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
 Procedure PRC_PRE_CHECK(p_filecode in varchar2,
                            p_fileid OUT VARCHAR2,
                          p_tlid in varchar2,
                          p_role in varchar2,
                          p_err_code      in out varchar2,
                          p_err_param     in out varchar2);
  procedure PRC_AFTER_CHECK (
                        p_filecode in varchar2,
                        p_fileid in varchar2,
                        p_tlid in varchar2,
                        p_role in varchar2,
                           p_reftransid  IN  OUT VARCHAR2,
                        p_err_code      in out varchar2,
                        p_err_param     in out varchar2);
Procedure PRC_GETIMPORTDATA(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                        p_fileID   IN  varchar2,
                        p_filecode in varchar2,
                        p_tlid in varchar2,
                        p_role in varchar2,
                        p_err_code      in out varchar2,
                        p_err_param     in out varchar2);
Procedure PRC_TXPROCESS4FUND(p_updatemode varchar2,
                          p_txnum varchar2 ,
                          p_txdate varchar2,
                          p_tlid varchar2,
                          P_level VARCHAR2,
                          p_err_code in out varchar2,
                          p_err_param out varchar2);
  procedure prc_txprocess4cb(p_reftransid varchar2,
                            p_tlid varchar2,
                            p_err_code in out varchar2,
                            p_err_param out varchar2
  ) ;
PROCEDURE CHECLVALIDIMPORT(  p_filecode in varchar2,
    p_fileid in varchar2,
    p_tlid in varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    );
PROCEDURE insert_online_temp(  p_filecode in varchar2,
    p_fileid in varchar2,
    p_tlid in varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    );
PROCEDURE rebuildStringETF(  p_list in varchar2,
    p_newlist OUT varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    );
procedure pr_check_time_online( p_result out varchar2, p_err_code in out varchar2, p_err_param in out varchar2);
PROCEDURE PR_AUTO_FILLER(p_tlid in varchar2, p_tableName in varchar2, p_filecode in varchar2, p_fileid  IN varchar2, p_err_code OUT varchar2, p_err_message OUT varchar2);
 END fopks_file;
/


CREATE OR REPLACE PACKAGE BODY fopks_file is
  -- Private variable declarations

  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
    procedure PRC_FILEMASTER(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_cmdid in varchar2,
                    p_tlid in varchar2,
                    p_role in varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
      v_modecode varchar2(50);
  begin

    plog.setBeginSection(pkgctx, 'PRC_FILEMASTER');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    Open p_refcursor for
    Select f.*
    From filemaster f, focmdmenu m
    Where   m.cmdid=p_cmdid
        and f.filecode <>  'I002'
     --   AND M.mktdomain = F.cmdcode 101040

           AND CASE WHEN M.CMDID = '001040' AND F.FILECODE = 'I072' THEN 1
                    WHEN M.CMDID = '001021' AND F.FILECODE = 'I069' THEN 1
                    WHEN M.CMDID = '001030' AND F.FILECODE IN ('I078','R0061') THEN 1
                    WHEN M.CMDID = '101090' AND F.FILECODE IN ('R0061') THEN 1
                    WHEN M.CMDID = '001160' AND F.FILECODE = 'I073' THEN 1
                    --WHEN M.CMDID = '001030' AND F.FILECODE = 'I079' THEN 1
                    --WHEN M.CMDID = '001030' AND F.FILECODE = 'I080' THEN 1
                    ELSE 0 END   = 1;
    plog.setEndSection(pkgctx, 'PRC_FILEMASTER');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_FILEMASTER');
  end PRC_FILEMASTER;
  procedure PRC_FILEMAP(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_filecode in varchar2,
                    p_tlid in varchar2,
                    p_role in varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
    v_filecode varchar2(50);
  begin

    plog.setBeginSection(pkgctx, 'PRC_FILEMAP');
    If p_filecode is null or length(p_filecode)=0 then
        v_filecode:='%';
    Else
        v_filecode:=p_filecode;
    End if;

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    Open p_refcursor for
    SELECT FM.*, F.IMPBYINDEX
    FROM FILEMASTER F, FILEMAP FM
    WHERE F.FILECODE = FM.FILECODE
    AND FM.FILECODE LIKE V_FILECODE
    ORDER BY FM.LSTODR;

    plog.setEndSection(pkgctx, 'PRC_FILEMAP');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_FILEMAP');
  end PRC_FILEMAP;

Procedure PRC_PRE_CHECK(p_filecode in varchar2,
                      p_fileid OUT VARCHAR2,
                      p_tlid in varchar2,
                      p_role in varchar2,
                      p_err_code      in out varchar2,
                      p_err_param     in out varchar2
) as
    v_tablename varchar2(200);
    v_dbcode varchar2(20);
    v_mbid varchar2(20);
    v_sql VARCHAR2(3000);
    v_param VARCHAR2(3000);
    v_timeonline varchar2(5);
Begin
    plog.setBeginSection(pkgctx, 'prc_pre_check');
    v_param:='PRC_PRE_CHECK()||filecode = '||p_filecode
                         ||';p_tlid = '||p_tlid
                         ||';p_fileid = '||p_fileid
                         ||';p_role = '||p_tlid;


    p_err_code:=systemnums.C_SUCCESS;
    p_err_param:='Success';
    v_dbcode:='0001';
    v_mbid:='0001';
    v_tablename:='xx';

    For vc in(Select * from filemaster where filecode=p_filecode)
    Loop
        v_tablename:=vc.tablename;
    End loop;

    SELECT seq_fileimport.NEXTVAL INTO  p_fileid FROM dual ;
    pr_check_time_online(v_timeonline,p_err_code,p_err_param);
    p_err_param:=cspks_system.fn_get_errmsg(p_err_code);
    plog.setEndSection(pkgctx, 'PRC_PRE_CHECK');

Exception
when others then
    p_err_code := errnums.c_system_error;
    p_err_param:=cspks_system.fn_get_errmsg(p_err_code);
    plog.error(pkgctx,'exception '|| v_param);
    plog.error(pkgctx,'err: ' || sqlerrm || ' trace: ' || dbms_utility.format_error_backtrace );
    plog.setendsection(pkgctx, 'prc_pre_check');
end prc_pre_check;

procedure prc_after_check(
                        p_filecode in varchar2,
                        p_fileid in varchar2,
                        p_tlid in varchar2,
                        p_role in varchar2,
                        p_reftransid  in  out varchar2,
                        p_err_code      in out varchar2,
                        p_err_param     in out varchar2
) as
    v_param varchar2(3000);
    v_tlid varchar2(4);
    v_custodycd varchar2(20);
    v_requestid varchar2(200);
    v_currdate  date;
    v_autoid    number;
    v_tablename varchar2(50);
    l_sql_query varchar2(3000);
    v_otpcheck  varchar2(5);
begin
    plog.setbeginsection(pkgctx, 'prc_after_check');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    Begin
        select varvalue into v_otpcheck  from sysvar where varname='OTPCHECK';
    exception
    when others
        then v_otpcheck := 'N';
    End;

    /*
    select custodycd
        into v_custodycd
    from userlogin
    where username = p_tlid;*/


-- Check du lieu
    --if p_filecode = 'I069' then
        CHECLVALIDIMPORT(p_filecode,p_fileid, p_tlid,p_err_code, p_err_param);
        if P_ERR_CODE <> systemnums.C_SUCCESS then
            p_err_param := cspks_system.fn_get_errmsg(p_err_code);

            plog.setendsection (pkgctx, 'CHECLVALIDIMPORT');
            return;
        end if;
    --end if;
    -- End check

    v_currdate := getcurrdate;
    v_autoid := seq_borqslog.nextval;
    p_reftransid := to_char(systimestamp, 'yyyymmddhh24missff') || v_autoid;
    insert into borqslog (autoid,createddt,rqssrc,rqstyp,requestid,status,txdate,txnum,errnum,errmsg,last_change,msgacct,msgamt,description,keyvalue,msgqtty,feedbackmsg,extdate)
    select v_autoid, sysdate createddt, 'I' rqssrc, p_filecode rqstyp, p_reftransid requestid, 'P' status, getcurrdate txdate,
            '' txnum, '' errnum, '' errmsg, systimestamp last_change,
            '' msgacct,0 msgamt,'' description,p_fileid keyvalue,0 msgqtty,'' feedbackmsg,v_currdate extdate
    from dual;

    /*
    if p_filecode = 'I069' then
        update odmastcust_temp
        set autoid = seq_imp_temp.nextval,
            tlidimp = p_tlid,
            deltd = 'N'
            where fileid = p_fileid;
    ELSIF p_filecode = 'I072' then
      update ETFRESULT_TEMP
        set autoid = seq_imp_temp.nextval,
            tlidimp = p_tlid
            where fileid = p_fileid;
     ELSIF p_filecode = 'I078' then
      update PAYMENTCASH_TEMP
        set autoid = seq_imp_temp.nextval,
            tlidimp = p_tlid
            where fileid = p_fileid;
      ELSIF p_filecode = 'I079' then
      update PAYMENTINSTRUCTION_TARD_ETFEX
        set autoid = seq_imp_temp.nextval,
            tlidimp = p_tlid
            where fileid = p_fileid;
     ELSIF p_filecode = 'I080' then
      update PAYMENTINSTRUCTION_TAEX
        set autoid = seq_imp_temp.nextval,
            tlidimp = p_tlid
            where fileid = p_fileid;
    end if;
    */
    begin
    select tablename into v_tablename from filemaster where filecode=p_filecode;
     exception
          when no_data_found then
            v_tablename:= null;
    end;

    if v_tablename is not null then
        l_sql_query:= ' update '|| v_tablename|| ' set autoid = seq_imp_temp.nextval,tlidimp ='''|| p_tlid|| ''' where fileid ='''|| p_fileid||'''';

        execute immediate l_sql_query;
    end if;

    v_param:='PRC_AFTER_CHECK()||filecode = '||p_filecode
                     ||';custodycd = '||v_custodycd
                     ||';p_role = '||p_tlid;
                         plog.error(pkgctx,'Begin '||v_param);

    --if  v_otpcheck='Y' then
    --fopks_sa.pr_generate_otp('IMP',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_param);
    --end if;
    If p_err_code = systemnums.C_SUCCESS then
        insert_online_temp(p_filecode,p_fileid, p_tlid,p_err_code, p_err_param);
        p_err_param :=cspks_system.fn_get_errmsg(p_err_code);

        plog.setEndSection(pkgctx, 'PRC_AFTER_CHECK');
        return;
    End if;
    /*
    CASE
          when p_filecode='I072' then
            --do anything
            CSPKS_FILEMASTER.PR_ETFRESULT_TEMP(v_tlid, p_err_code, p_err_param);
          when p_filecode='I069' then
            --do anything
           update ODMASTCUST_TEMP set iscompare='N' where fileid=p_fileid;
          CSPKS_FILEMASTER.PR_FILLTER_TBLI069(v_tlid, p_err_code, p_err_param);
          else
            p_err_code:=-100131;
    End case;
    */
    p_err_param:=cspks_system.fn_get_errmsg(p_err_code);

    plog.setEndSection(pkgctx, 'PRC_AFTER_CHECK');
  exception
    when others then
        p_err_code := errnums.C_SYSTEM_ERROR;
        p_err_param:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx,'Exception '||v_param ||' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
        plog.setendsection(pkgctx, 'prc_after_check');
  end prc_after_check;


 Procedure PRC_GETIMPORTDATA(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                        p_fileID   IN  varchar2,
                        p_filecode in varchar2,
                        p_tlid in varchar2,
                        p_role in varchar2,
                        p_err_code      in out varchar2,
                        p_err_param     in out varchar2) as
    v_sql varchar2(3000);
    v_tablename varchar2(100);
    v_param varchar2(2000);
    v_mbid varchar2(20);
    v_text_column varchar2(3000);
  begin

    plog.setBeginSection(pkgctx, 'PRC_GETIMPORTDATA');
     v_param:='PRC_GETIMPORTDATA()||filecode = '||p_filecode
                             ||';p_fileID = '||p_fileID
                             ||';p_tlid = '||p_tlid
                             ||';p_role = '||p_tlid;

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    v_tablename:='xx';
    v_mbid:='000001';

    For vc in(Select * from filemaster where filecode=p_filecode)
    Loop
        v_tablename:=vc.tablename;
    End loop;
    If v_tablename<>'xx' then

        --ThanhNV sua: Lay column theo ten khai bao trong filemap:
        --v_sql:='Select * from '||v_tablename;
        /*
         v_sql:='';
         FOR i IN (SELECT tblrowname || ' as "' || fielddesc ||'"' col FROM filemap WHERE  filecode = p_filecode AND  visible ='Y' ORDER BY  lstodr)
         LOOP
           IF v_sql IS NULL THEN
              v_sql:= i.COL;
           ELSE
              v_sql:=v_sql ||', '||i.COL;
           END IF;
         END LOOP;
           v_sql:='SELECT ' || v_sql ||' FROM '||v_tablename ;
           --dbms_output.put_line('v_sql '||v_sql);
           --
         */
         --build string from record
        select listagg(tblrowname,', ') within group(order by LSTODR asc) into v_text_column
        from filemap where filecode =p_filecode order by LSTODR asc;
        v_text_column:='errmsg,'||v_text_column;
        v_sql:='Select ' ||v_text_column|| ' from '||v_tablename||' I where  I.fileid = '''||p_fileID||'''';

        Open p_REFCURSOR for v_sql;
    Else
        p_err_code:=-100131;
        p_err_param:=cspks_system.fn_get_errmsg(p_err_code);
    End if;

    plog.setEndSection(pkgctx, 'PRC_GETIMPORTDATA');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GETIMPORTDATA');
  end PRC_GETIMPORTDATA;
  Procedure PRC_TXPROCESS4FUND(p_updatemode varchar2,
                          p_txnum varchar2 ,
                          p_txdate varchar2,
                          p_tlid varchar2,
                          P_level VARCHAR2,
                          p_err_code in out varchar2,
                          p_err_param out varchar2)
    IS
       l_txmsg               tx.msg_rectype;
       l_err_param           varchar2(300);
       l_tllog               tllog%rowtype;
       l_fldname             varchar2(100);
       l_defname             varchar2(100);
       l_fldtype             char(1);
       l_return              number(20,0);
       pv_refcursor            pkg_report.ref_cursor;
       l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;
       p_xmlmsg        varchar2(4000);
       v_sql varchar2(1000);
       v_param varchar2(2000);
       v_txstatus varchar2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'PRC_TXPROCESS4FUND');
    v_param:=' PRC_TXPROCESS4FUND(): p_updatemode = '||p_updatemode||
                                       ';p_txnum = '||p_txnum||
                                       ';p_txdate = '||p_txdate||
                                       ';p_tlid = '||p_tlid||
                                       ';P_level = '||P_level;
    plog.debug(pkgctx,'Begin '||v_param );
    p_err_code:=systemnums.C_SUCCESS;
    p_err_param:='SUCCESS';
    For vc in (Select txnum, txstatus
                  From tllog
                  Where txnum=p_txnum
                  )
    LOOP
            v_txstatus:=vc.txstatus;
    End loop;
    IF p_updatemode in ('A','R','D') and v_txstatus not in ('4','0') THEN
            p_err_code:=-100030;
            Raise  errnums.E_BIZ_RULE_INVALID;
    End if;

    OPEN pv_refcursor FOR
        select * from tllog
        where txnum=p_txnum ;
        --getcurrdate;--(p_txdate,systemnums.c_date_format);
    LOOP
    FETCH pv_refcursor
    INTO l_tllog;
    EXIT WHEN pv_refcursor%NOTFOUND;
        if l_tllog.deltd='Y' then
        p_err_code:=errnums.C_SA_CANNOT_DELETETRANSACTION;
        plog.setendsection (pkgctx, 'fn_txrevert');
            RETURN ;
        end if;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := l_tllog.tlid;
        l_txmsg.offid        := p_tlid;
        l_txmsg.off_line    := l_tllog.off_line;
        L_TXMSG.WSNAME      := l_tllog.WSNAME;
        L_TXMSG.IPADDRESS   := L_tllog.IPADDRESS;
        l_txmsg.deltd       := txnums.C_DELTD_TXNORMAL;
        l_txmsg.txstatus    := l_tllog.txstatus;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate:=to_date(l_tllog.txdate,systemnums.c_date_format);
        l_txmsg.busdate:=to_date(l_tllog.busdate,systemnums.c_date_format);
        l_txmsg.txnum:=l_tllog.txnum;
        l_txmsg.tltxcd:=l_tllog.tltxcd;
        l_txmsg.brid:=l_tllog.brid;

        for rec in
        (
            select * from tllogfld
            where txnum=p_txnum  --getcurrdate--to_date(p_txdate,systemnums.c_date_format)
        )
        LOOP
            begin
                select fldname, defname, fldtype
                into l_fldname, l_defname, l_fldtype
                from fldmaster
                where objname=l_tllog.tltxcd and FLDNAME=rec.FLDCD;

                l_txmsg.txfields (l_fldname).defname   := l_defname;
                l_txmsg.txfields (l_fldname).TYPE      := l_fldtype;

                if l_fldtype='C' then
                    l_txmsg.txfields (l_fldname).VALUE     := rec.CVALUE;
                elsif   l_fldtype='N' then
                    l_txmsg.txfields (l_fldname).VALUE     := rec.NVALUE;
                else
                    l_txmsg.txfields (l_fldname).VALUE     := rec.CVALUE;
                end if;
                plog.debug (pkgctx,'field: ' || l_fldname || ' value:' || to_char(l_txmsg.txfields (l_fldname).VALUE));
            exception when others then
               l_err_param:=0;
            end;
        end loop;

        p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);

        If  l_tllog.tltxcd='6639' then
           IF txpks_#6639.fn_TxProcess (p_xmlmsg,p_err_code,p_err_param) <> systemnums.c_success
           THEN

               ROLLBACK;
               plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
               RETURN ;
           END IF;
         END IF;

        plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
        return ;
    END LOOP;
       p_err_code:=errnums.C_HOST_VOUCHER_NOT_FOUND;
       plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
       Raise  errnums.E_BIZ_RULE_INVALID;

EXCEPTION
       WHEN errnums.E_BIZ_RULE_INVALID
       THEN
          FOR I IN (
               SELECT ERRDESC,EN_ERRDESC FROM deferror
               WHERE ERRNUM= p_err_code
          ) LOOP
               p_err_param := i.errdesc;
          END LOOP;
          plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
          RETURN ;
    WHEN OTHERS
       THEN
          p_err_code := errnums.C_SYSTEM_ERROR;


          plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
          RETURN ;
END PRC_TXPROCESS4FUND;


procedure prc_txprocess4cb(p_reftransid varchar2,
                          p_tlid varchar2,
                          p_err_code in out varchar2,
                          p_err_param out varchar2
) is
    l_txmsg         tx.msg_rectype;
    v_currdate      date;
    l_txnum         varchar2(20);
    v_strdesc       varchar2(1000);
    v_stren_desc    varchar2(1000);
    v_tltxcd        varchar2(10);
    v_param         varchar2(1000);
    v_filecode      varchar2(100);
    v_fileid        varchar2(1000);
    p_xmlmsg        varchar2(4000);
BEGIN

    plog.setbeginsection (pkgctx, 'prc_txprocess4cb');
    p_err_code    := systemnums.c_success;
    p_err_param := 'SUCCESS';

    V_TLTXCD := '8800';
    ------------------------
    begin
        select txdesc, en_txdesc
            into v_strdesc, v_stren_desc
        from tltx
    where tltxcd = v_tltxcd;
        exception
          when no_data_found then
            v_strdesc:= null;
            v_stren_desc:= null;
    end;

    v_currdate := getcurrdate;

    ------------------------
    /*begin
        select systemnums.c_batch_prefixed || lpad (seq_txnum.nextval, 8, '0')
        into l_txnum
        from dual;
    exception
          when no_data_found then
            l_txnum:= null;
    end;*/

    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';


    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------
   -- L_TXMSG.TLID := p_tlid;
    L_TXMSG.TLID := '6868';
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
    L_TXMSG.TXDATE      := v_currdate;
    L_TXMSG.BUSDATE     := v_currdate;
    L_TXMSG.TLTXCD      := V_TLTXCD;
    L_TXMSG.NOSUBMIT    := '1';
    L_TXMSG.OVRRQD      := '@0';

    --------------------------set cac field giao dich-------------------------------
    ----set txnum
    begin
        select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
        from dual;
    exception
        when no_data_found then
           l_txmsg.txnum:= null;
    end;

    Begin
        select rqstyp, keyvalue into v_filecode, v_fileid
        from borqslog where requestid = p_reftransid;
    exception
        when no_data_found then
            v_filecode := '';
            v_fileid := '';
    End;

    if v_fileid = '' then
         p_err_code := errnums.c_system_error;
        -- Cho nay dinh nghia ma loi sau.

        plog.setendsection(pkgctx, 'prc_txprocess4cb');
        return ;
    Else
          --16    M?ile   C
        l_txmsg.txfields ('16').defname   := 'FILEIDCODE';
        l_txmsg.txfields ('16').TYPE      := 'C';
        l_txmsg.txfields ('16').value      := v_filecode;

        --15    M?  C
        l_txmsg.txfields ('15').defname   := 'FILEID';
        l_txmsg.txfields ('15').TYPE      := 'C';
        l_txmsg.txfields ('15').value      := v_fileid;

        --30    Di?n gi?i   C
        l_txmsg.txfields ('30').defname   := 'DES';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := v_stren_desc;

            --99    USERNAME   C
        l_txmsg.txfields ('99').defname   := 'USERNAME';
        l_txmsg.txfields ('99').TYPE      := 'C';
        l_txmsg.txfields ('99').value      := p_tlid;

        p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);

        BEGIN
            IF txpks_#8800.fn_txprocess (p_xmlmsg,
                                             p_err_code,
                                             p_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                                      'got error 8800: ' || p_err_code
               );
               ROLLBACK;
               RETURN;
            ELSE
                fopks_tx.PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');
                UPDATE TLLOG SET TXSTATUS = 'P' WHERE TXNUM = L_TXMSG.TXNUM AND TXDATE = L_TXMSG.TXDATE;
            END IF;
        END;
    End if;

    plog.setendsection(pkgctx, 'prc_txprocess4cb');
exception
    when others then
        p_err_code := errnums.c_system_error;
        plog.error(pkgctx,' err: ' || sqlerrm || ' trace: ' || dbms_utility.format_error_backtrace);
        plog.error(pkgctx, ' exception: ' || v_param);
        plog.setendsection(pkgctx, 'prc_txprocess4cb');
end;
PROCEDURE CHECLVALIDIMPORT(  p_filecode in varchar2,
    p_fileid in varchar2,
    p_tlid in varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    )
IS
v_custodycd VARCHAR2(20);
v_listcustodycd varchar2(5000);
v_role VARCHAR2(10);
v_countvalid NUMBER;
v_fileid VARCHAR2(20);
v_tablename VARCHAR2(30);
v_columnCustodycd VARCHAR2(50);
v_select_string    VARCHAR2(2000);
v_custodycd_check            VARCHAR2(20);
v_special_custodycd   VARCHAR2(20);
csr                SYS_REFCURSOR;
l_sql_query varchar2(3000);
BEGIN

    plog.setbeginsection(pkgctx, 'CHECLVALIDIMPORT');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_message := 'SUCCESS';
    v_custodycd:= '';
    v_fileid := p_fileid;
    v_columnCustodycd:=null;

    Begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception when others then
        v_custodycd := '';
        v_listcustodycd:='';
        v_role:='';
    End;

    select tablename into v_tablename from filemaster where FILECODE=p_filecode;
    if p_filecode in ('I069','I073') then --SHBVNEX-2271 trung.luu
        v_columnCustodycd:='st_code';
    ELSIF p_filecode='I072' then
        v_columnCustodycd:='custodycd';
    ELSIF p_filecode='I078' then
        v_columnCustodycd:='TRADINGACCOUNT';
    ELSIF p_filecode='R0061' then
        v_columnCustodycd:='DEBANKACC';
    ELSIF p_filecode='I079' then
        v_columnCustodycd:='banktransfers';
    ELSIF p_filecode='I080' then
        v_columnCustodycd:='banktransfers';
    end if;

    -- CHECK So TKLK
    if v_columnCustodycd is not null  then
        IF p_filecode in('I079','I080') then
            v_select_string := 'SELECT nvl(ci.custodycd,' || v_columnCustodycd ||'),' || v_columnCustodycd ||' FROM ' || v_tablename || ', ddmast ci WHERE fileid='''|| v_fileid||''' and errmsg IS NULL and ' || v_columnCustodycd ||'=ci.refcasaacct(+) ';
        elsif p_filecode in('R0061') then
            v_select_string := 'SELECT NVL(DD.CUSTODYCD, DT.' || v_columnCustodycd || '), ' || v_columnCustodycd || ' FROM ' || v_tablename || ' DT, (SELECT * FROM DDMAST WHERE STATUS NOT IN (''C'')) DD WHERE DT.DEBANKACC = DD.REFCASAACCT(+) AND DT.FILEID = '''|| v_fileid||''' AND ERRMSG IS NULL ';
        elsif p_filecode in('I073') then
            v_select_string := 'select nvl(cf.custodycd,'||v_columnCustodycd ||'), cf.custodycd ' ||' from cfmast cf, ' || v_tablename ||' v where '||v_columnCustodycd||' = substr(cf.custodycd,5,10) and fileid = '''||v_fileid|| '''';
        ELSE
            v_select_string := 'SELECT ' || v_columnCustodycd || ','' '' special_custodycd  FROM ' || v_tablename || ' WHERE fileid='''|| v_fileid||''' and errmsg IS NULL';
        END IF;


        OPEN csr FOR v_select_string;
        loop FETCH  csr INTO  v_custodycd_check,v_special_custodycd;
        exit when csr%notfound;
            --Check So TKLK
            select count(1) into v_countvalid from dual where v_custodycd_check in (
                SELECT trim(regexp_substr(v_listcustodycd, '[^;]+', 1, LEVEL)) str
                FROM dual
                CONNECT BY regexp_substr(v_listcustodycd , '[^;]+', 1, LEVEL) IS NOT NULL
            ) or v_custodycd_check = v_custodycd;
            IF v_countvalid = 0 then
                IF p_filecode in('I079','I080') then
                    l_sql_query:='UPDATE '|| v_tablename ||' SET errmsg =errmsg|| ''Error: Do not import account trading not under management!'' WHERE fileid='''||v_fileid||''' and  '||v_columnCustodycd||'='''||v_special_custodycd||'''';
                else
                    l_sql_query:='UPDATE '|| v_tablename ||' SET errmsg =errmsg|| ''Error: Do not import account trading not under management!'' WHERE fileid='''||v_fileid||''' and  '||v_columnCustodycd||'='''||v_custodycd_check||'''';
                end if;
                execute immediate l_sql_query;
                p_err_code := '-930019';
                p_err_message:= 'Do not import account trading not under management!';
                EXIT;
            else
                p_err_code := 0;
                p_err_message:= 'Sucessfull!';
            END IF;
        END LOOP;
    end if;

    IF p_err_code = 0 THEN
        PR_AUTO_FILLER(p_tlid, v_tablename, p_filecode, v_fileid, p_err_code, p_err_message);
    END IF;

    return;
    plog.setendsection(pkgctx, 'CHECLVALIDIMPORT');
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'CHECLVALIDIMPORT');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END CHECLVALIDIMPORT;
PROCEDURE insert_online_temp(  p_filecode in varchar2,
    p_fileid in varchar2,
    p_tlid in varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    )
IS
v_fileid VARCHAR2(20);
v_tablename VARCHAR2(30);
v_columnCustodycd VARCHAR2(50);
l_sql_query varchar2(3000);
BEGIN

    plog.setbeginsection(pkgctx, 'insert_online_temp');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_message := 'SUCCESS';
    v_fileid := p_fileid;
    v_columnCustodycd:=null;


        select tablename into v_tablename from filemaster where FILECODE=p_filecode;
        if p_filecode='I069' then
            v_columnCustodycd:='st_code';
        ELSIF p_filecode='I073' then
            v_columnCustodycd:='st_code';
        ELSIF p_filecode='I072' then
            v_columnCustodycd:='custodycd';
        ELSIF p_filecode='I078' then
            v_columnCustodycd:='TRADINGACCOUNT';
        ELSIF p_filecode='I079' then
            v_columnCustodycd:='banktransfers';
        ELSIF p_filecode='I080' then
            v_columnCustodycd:='banktransfers';
        end if;

-- CHECK So TKLK
if v_columnCustodycd is not null  then
        BEGIN
         IF p_filecode in('I079','I080') then
         l_sql_query:='INSERT INTO IMPORT_ONLINE_TEMP(AUTOID,custodycd,tlidimp,filecode,fileid)
            SELECT seq_IMPORT_ONLINE_TEMP.nextval,NVL(ci.CUSTODYCD,'|| v_columnCustodycd ||') custodycd,'''|| p_tlid ||''' tlidimp,'''|| p_filecode ||''' filecode,fileid FROM '|| v_tablename ||',DDMAST CI
            WHERE fileid='''|| v_fileid ||''' AND '|| v_columnCustodycd ||'= ci.refcasaacct(+)';
         ELSE
            l_sql_query:='INSERT INTO IMPORT_ONLINE_TEMP(AUTOID,custodycd,tlidimp,filecode,fileid)
            SELECT seq_IMPORT_ONLINE_TEMP.nextval,'|| v_columnCustodycd ||' custodycd,'''|| p_tlid ||''' tlidimp,'''|| p_filecode ||''' filecode,fileid FROM '|| v_tablename ||'
            WHERE fileid='''|| v_fileid ||'''';
         END IF;


              execute immediate l_sql_query;
        END;
 end if;
    return;
    plog.setendsection(pkgctx, 'insert_online_temp');
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'insert_online_temp');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END insert_online_temp;
PROCEDURE rebuildStringETF(  p_list in varchar2,
    p_newlist OUT varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    )
IS
v_string VARCHAR2(4000);
csr                SYS_REFCURSOR;
l_sql_query varchar2(3000);
v_new_list VARCHAR2(100);
v_final_list VARCHAR2(4000);
BEGIN

    plog.setbeginsection(pkgctx, 'rebuildStringETF');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_message := 'SUCCESS';

 FOR V_REC IN (

 SELECT trim(regexp_substr(p_list,  '[^#]+', 1, LEVEL)) str
                              FROM dual
                              CONNECT BY regexp_substr(p_list ,  '[^#]+' , 1, LEVEL) IS NOT NULL
                              )
    LOOP
    begin
        SELECT regexp_replace(V_REC.str, SUBSTR(V_REC.str,0,iNSTR(V_REC.str, '|')-1) , codeid,1,1) into v_new_list
        FROM sbsecurities
        where SUBSTR(V_REC.str,0,iNSTR(V_REC.str, '|')-1)=symbol;
        v_final_list:=v_final_list||v_new_list ||'#';
       end;

     END LOOP;
    p_newlist:=v_final_list;
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'rebuildStringETF');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END rebuildStringETF;
procedure pr_check_time_online( p_result out varchar2, p_err_code in out varchar2, p_err_param in out varchar2)
is
    /*
    Input
        p_id: id KH duoc cap
        p_username: User dang nhap
    Output:
        p_err_code: Ma loi
        p_err_param: Mo ta loi
    */
 v_beginTime varchar2(10);
  v_endTime varchar2(10);
  v_beginTimeCast number;
  v_endTimeCast number;
begin
    p_err_code      := '0';
    p_err_param      := 'Success';
    plog.setbeginsection (pkgctx, 'pr_check_time_online');

    Begin
    select varvalue into v_beginTime from sysvar where varname='BEGIN_TIME_ONLINE' and grname='FO';
    select varvalue into v_endTime from sysvar where varname='END_TIME_ONLINE' and grname='FO';

     SELECT 24  * (to_date(v_beginTime, 'HH24:MI:SS') - TRUNC(to_date(v_beginTime, 'HH24:MI:SS'))),
            24  * (to_date(v_endTime, 'HH24:MI:SS') - TRUNC(to_date(v_endTime, 'HH24:MI:SS'))) into v_beginTimeCast,v_endTimeCast
      FROM dual;
      exception
    when others
        then
            v_beginTimeCast:=0;
            v_endTimeCast:=16;
     end;

    IF ( sysdate >= trunc(sysdate)+v_beginTimeCast/24 and sysdate <= trunc(sysdate)+v_endTimeCast/24) THEN
        p_result:='Y';
    else
        p_result:='N';
        p_err_code:='-202002';
    end if;
    plog.setendsection (pkgctx, 'pr_check_time_online');
exception
when others
   then
      p_err_code := errnums.c_system_error;
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_check_time_online');
      raise errnums.e_system_error;
end pr_check_time_online;

PROCEDURE PR_AUTO_FILLER(p_tlid in varchar2, p_tableName in varchar2, p_filecode in varchar2, p_fileid  IN varchar2, p_err_code OUT varchar2, p_err_message OUT varchar2)
IS
l_sql_query VARCHAR2(1000);
l_procfillter varchar2(50);
BEGIN
    plog.setbeginsection(pkgctx, 'PR_AUTO_FILLER');
    if p_tableName='' then
        p_err_code := 0;
        p_err_message:= 'Sucessfull!';
        return;
    end if;

    select procfillter into l_procfillter
    from filemaster where filecode = p_filecode;

    --Goi ham xu ly check validate
    if length(nvl(l_procfillter,'')) <> 0 then
        l_sql_query:=' UPDATE ' || p_tableName  || '  SET TLIDIMP =''' || LPAD(p_tlid, 4, '0') || ''', TXTIME = SYSTIMESTAMP, IMPSTATUS =''Y'', OVRSTATUS=''N'', AUTOID = seq_imp_temp.nextval where fileid = ''' || p_fileid || '''';
        execute immediate l_sql_query;

        l_sql_query:=' BEGIN cspks_filemaster.'||l_procfillter||'(:p_tlid, :p_fileid, :p_err_code, :p_err_message); END;';
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

begin
  -- Initialization
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('fopks_file',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));

end fopks_file;
/
