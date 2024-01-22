SET DEFINE OFF;
CREATE OR REPLACE PACKAGE fopks_tx IS

  /* ----------------------------------------------------------------------------------------------------
  ** (c) 2017 by Financial Software Solutions. JSC.
  ----------------------------------------------------------------------------------------------------*/
  Procedure PRC_GETUSSEARCH(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                            p_TellerId varchar2,
                            p_role varchar2,
                            p_SearchFilter varchar2);

    Procedure PRC_TXPROCESS4FUND(p_updatemode varchar2,
                             p_txnum      varchar2 ,
                             p_txdate     varchar2,
                             p_tlid       varchar2,
                             P_level      varchar2,
                             p_err_code   in out varchar2,
                             p_err_param  out varchar2);

    PROCEDURE PRC_GET_LIST_CASCHD(P_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                                           P_CUSTODYCD   IN VARCHAR2,
                                           P_CUSNAME   IN VARCHAR2,
                                           P_SYMBOL   IN VARCHAR2,
                                           P_CATYPE   IN VARCHAR2,
                                           P_CASTATUS   IN VARCHAR2,
                                           P_DATE_TYPE   IN VARCHAR2,
                                           P_FROM_DATE    IN VARCHAR2,
                                           P_TO_DATE    IN VARCHAR2,
                                           P_USERNAME        IN VARCHAR2,
                                           P_ROLE        IN VARCHAR2,
                                           P_ERR_CODE    IN OUT VARCHAR2,
                                           P_ERR_MSG     IN OUT VARCHAR2);

    PROCEDURE PRC_GET_LIST_3383(P_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                                       P_CUSTODYCD        IN VARCHAR2,
                                       P_CUSNAME        IN VARCHAR2,
                                       P_CAMASTID        IN VARCHAR2,
                                       P_SYMBOL        IN VARCHAR2,
                                       P_OPTSYMBOL        IN VARCHAR2,
                                       P_TLID        IN VARCHAR2,
                                       P_ROLE        IN VARCHAR2,
                                       P_ERR_CODE    IN OUT VARCHAR2,
                                       P_ERR_MSG     IN OUT VARCHAR2);

    procedure pr_auto_3383_web(
        p_camastid varchar2,
        p_custodycd varchar2,
        p_refcustodycd varchar2,
        p_qtty      number,
        p_qtty_wft      number,
        p_price     number,
        p_taxrate   number,
        p_notransct varchar2,
        p_valuedate      varchar2,
         p_tomemcus       varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     );

    procedure prc_get_list_3384(p_refcursor   in out pkg_report.ref_cursor,
                                   p_fundsymbol  in varchar2,
                                   p_valuedate   in varchar2,
                                   p_camastid    in varchar2,
                                   p_tlid        in varchar2,
                                   p_role        in varchar2,
                                   p_err_code    in out varchar2,
                                   p_err_msg     in out varchar2);

    procedure pr_auto_3384_web( p_camastid       varchar2,
                            p_custodycd      varchar2,
                            p_qtty           number,
                            p_valuedate      varchar2,
                            p_tlid           varchar2,
                            p_reftransid     out varchar2,
                            p_err_code       in out varchar2,
                            p_err_msg        in out varchar2);

    PROCEDURE PRC_GET_LIST_3386(P_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                                       P_CUSTODYCD        IN VARCHAR2,
                                       P_CUSNAME        IN VARCHAR2,
                                       P_CAMASTID        IN VARCHAR2,
                                       P_SYMBOL        IN VARCHAR2,
                                       P_TLID        IN VARCHAR2,
                                       P_ROLE        IN VARCHAR2,
                                       P_ERR_CODE    IN OUT VARCHAR2,
                                       P_ERR_MSG     IN OUT VARCHAR2);

    procedure pr_auto_3386_web(
        p_autoid      varchar2,
        p_custodycd varchar2,
        p_qtty      number,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     );

    PROCEDURE PRC_GET_LIST_3327(P_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                                       P_CUSTODYCD        IN VARCHAR2,
                                       P_CUSNAME        IN VARCHAR2,
                                       P_CAMASTID        IN VARCHAR2,
                                       P_SYMBOL        IN VARCHAR2,
                                       P_TOSYMBOL        IN VARCHAR2,
                                       P_TLID        IN VARCHAR2,
                                       P_ROLE        IN VARCHAR2,
                                       P_ERR_CODE    IN OUT VARCHAR2,
                                       P_ERR_MSG     IN OUT VARCHAR2);

    procedure pr_auto_3327_web(
        p_camastid varchar2,
        p_custodycd varchar2,
        p_qtty      number,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     );

    procedure pr_auto_5501_web(
        p_custodycd      varchar2,
        p_description varchar2,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     );

    procedure pr_auto_5502_web(
        p_custodycd      varchar2,
        p_camastid varchar2,
        p_qtty number,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     );
    procedure pr_log_username(p_txmsg in tx.msg_rectype, p_username varchar2, p_mode varchar2);

    procedure pr_auto_5503_web(
        p_TXDATE      varchar2,
        p_TYPE varchar2,
        p_SYMBOL varchar2,
        p_ISSNAME varchar2,
        p_CONTRACTNO varchar2,
        p_AUTHNAME varchar2,
        p_IDCODE varchar2,
        p_REASON varchar2,
        p_CUSTODYCD varchar2,
        p_FULLNAME varchar2,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     );

    procedure pr_auto_3300_web(
        p_custodycd      varchar2,
        p_camastid varchar2,
        p_qtty number,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     );

    PROCEDURE PRC_GETUSSEARCH2(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_TellerId varchar2,
                    p_role varchar2,
                    p_SearchFilter varchar2,
                    p_FDate varchar2,
                    p_TDate varchar2
    );

 FUNCTION fn_get_lookup_value(p_value varchar2,
                             p_llist  varchar2) return string ;
 FUNCTION fn_get_TAGLIST_value(p_txnum varchar2,
  p_txdate date,
  p_value varchar2,
  p_tagfield  varchar2,
  p_taglist  varchar2  )return string ;
  PROCEDURE PRC_GET_TRANSACT(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_txnum varchar2,
                    p_txdate varchar2,
                    p_TellerId varchar2,
                    p_role varchar2,
                    p_reflogid varchar2,
                    p_err_code in out varchar2,
                    p_err_param in out varchar2);
  PROCEDURE GETLISTUSERNAME(
    p_tlid in varchar2,
    p_listusername OUT varchar2

    );
  PROCEDURE PRC_GET_STOCKS_NEW(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_SYMBOL       in varchar2,
                     p_err_code      IN OUT VARCHAR2,
                     p_err_param     IN OUT VARCHAR2);
    procedure pr_auto_1721_web(
        p_custodycd varchar2,
        p_tranacctno varchar2,
        p_receacctno varchar2,
        p_amount number,
        p_valuedate      varchar2,
        p_description  varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     );
 END FOPKS_TX;
/


CREATE OR REPLACE PACKAGE BODY fopks_tx is
  -- Private variable declarations
  C_TLID_ONLINE_FA CONSTANT VARCHAR2(10) := '0001';
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
  -- Function and procedure implementations
  -- Function and procedure implementations
  PROCEDURE PRC_GETUSSEARCH(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_TellerId varchar2,
                    p_role varchar2,
                    p_SearchFilter varchar2)
  IS
        TellerId VARCHAR2(100);
        BranchId VARCHAR2(100);
        SearchFilter VARCHAR2(100);
        v_sql clob;
        v_tablelog varchar2(20);
        v_tablelogfld varchar2(20);
        v_Searchlft varchar2(4000);
        v_mbcode varchar2(20);
  Begin

        SearchFilter:= p_SearchFilter;
        BranchId:='0001';
        TellerId:=p_TellerId;
        --PR_GETUSSEARCH_front(PV_REFCURSOR,p_TellerId,'0001',p_SearchFilter);
        begin
            if instr(SearchFilter,'TLLOG.TXDATE') <> 0 then
                v_tablelog := 'TLLOG';
                v_tablelogfld := 'TLLOGFLD';
            else
                v_tablelog:= 'TLLOG';
                v_tablelogfld := 'TLLOGFLD';
            end if;

                v_sql:='SELECT *
                        FROM
                        (
                            SELECT CF.FULLNAME CFFULLNAME, CF.CUSTODYCD IDAFACCTNO, SB.CODEID, TX.EN_TXDESC NAMENV, L.CAREBYGRP, L.AUTOID, L.DELTD, L.TXNUM, TO_CHAR(L.TXDATE,''DD/MM/RRRR'') TXDATE,
                                   L.BUSDATE, L.BRID, L.TLTXCD || ''-'' || TX.EN_TXDESC TLTXCD, A0.EN_CDCONTENT TXSTATUS, NVL(L.TXDESC, TX.TXDESC) TXDESC, L.MSGACCT ACCTNO, L.MSGAMT AMT, L.TLID, L.CHKID, L.OFFID,
                                   (
                                        CASE WHEN L.TXSTATUS IN (''7'',''P'') THEN ''4''
                                             WHEN L.TXSTATUS = ''4'' AND L.TLTXCD = ''6639'' THEN ''1''
                                             ELSE L.TXSTATUS END
                                   ) TXSTATUSCD,
                                   NVL(UC.USER_CREATED,''____'') TLNAME, NVL(UC.USER_APPR,''____'') CHKNAME,
                                   L.CREATEDT, NVL(L.TXTIME,L.OFFTIME) TXTIME, L.OFFTIME, '''' LVEL, '''' DSTATUS, '''' PARENTTABLE, '''' PARENTVALUE, '''' PARENTKEY, '''' CHILTABLE,
                                   '''' CHILDVALUE, '''' CHILDKEY, '''' MODULCODE, CF.CUSTODYCD CUSTODYCD, CF.FULLNAME FUNDNAME ,''CB'' APPMODE, TO_CHAR(UC.TIME_CREATED,''HH24:MI:SS'') TIME_CREATED, TO_CHAR(UC.TIME_APPR,''HH24:MI:SS'') TIME_APPR
                            FROM (SELECT * FROM ' || v_tablelog || ' WHERE BATCHNAME = ''DAY'') L,
                                 (SELECT * FROM ALLCODE WHERE CDNAME = ''TXSTATUS'' AND CDTYPE = ''SY'') A0,
                                 ONLREQUESTLOG_USER UC, USERLOGIN U, CFMAST CF, SBSECURITIES SB, TLTX TX
                            WHERE L.TLID = ''6868''
                            AND L.CCYUSAGE = SB.CODEID(+)
                            AND L.CFCUSTODYCD = CF.CUSTODYCD(+)
                            AND L.TLTXCD = TX.TLTXCD
                            AND L.TXNUM = UC.TXNUM(+) AND L.TXDATE = UC.TXDATE(+)
                            AND (
                                CASE WHEN L.TLTXCD = ''8800'' THEN (
                                      select case when  count(*)>0 then 0 else 1 end a
                                      from import_online_temp temp,
                                           (select listcustodycd||'';''||custodycd listcs from userlogin where username ='''||P_TELLERID||''') l
                                       where fileid = l.msgacct and instr(l.listcs,temp.custodycd) = 0
                                      )
                                     ELSE (CASE WHEN INSTR(U.LISTCUSTODYCD,CF.CUSTODYCD) > 0 OR U.CUSTODYCD = CF.CUSTODYCD THEN 1 ELSE 0 END)
                                END
                            ) = 1
                            AND A0.CDVAL = (CASE WHEN L.DELTD=''Y'' THEN ''9''
                                                 WHEN L.TXSTATUS =''P'' THEN ''4''
                                                 WHEN L.TXSTATUS =''4'' AND L.TLTXCD = ''6639'' THEN ''1''
                                                 WHEN (L.TXSTATUS =''4'' AND L.OVRRQS <> ''0'' AND L.OVRRQS <> ''@00'' AND L.CHKID IS NOT NULL AND L.OFFID IS NULL) THEN ''10'' ELSE L.TXSTATUS END)
                            AND L.TXSTATUS NOT IN (''0'')
                            AND U.USERNAME = ''' || P_TELLERID || '''
                        )
                        WHERE 0 = 0';

            --dbms_output.put_line('v_sql:' || v_sql);
            v_Searchlft:=SearchFilter;
            v_Searchlft:=v_Searchlft|| ' order by decode(TXSTATUSCD,''4'',''-1'',TXSTATUSCD),createdt desc';

            IF length(SearchFilter)>0 then
                v_sql := v_sql || ' AND ' || v_Searchlft;
            ELSE
                  v_sql := v_sql || ' ' || v_Searchlft;
            end if;

            open PV_REFCURSOR for v_sql;
        EXCEPTION
          WHEN others THEN -- caution handles all exceptions
           plog.error('ERROR: ' || SQLERRM || dbms_utility.format_error_backtrace);
        end;
        plog.setendsection (pkgctx, 'PRC_GETUSSEARCH');
  End;

    Procedure PRC_TXPROCESS4FUND(p_updatemode varchar2,
                             p_txnum      varchar2 ,
                             p_txdate     varchar2,
                             p_tlid       varchar2,
                             P_level      varchar2,
                             p_err_code   in out varchar2,
                             p_err_param  out varchar2)
    IS
        l_tllog tllog%rowtype;
        pv_refcursor pkg_report.ref_cursor;
        v_param varchar2(2000);
        v_txstatus varchar2(10);
        p_sqlcommand VARCHAR2(4000);
        l_txmsg tx.msg_rectype;
        p_xmlmsg varchar2(32767);
        l_fldname varchar2(100);
        l_defname varchar2(100);
        l_fldtype char(1);
        v_txstatus6639 varchar2(10);
        v_tltxcd varchar2(10);
    BEGIN
        plog.setbeginsection (pkgctx, 'PRC_TXPROCESS4FUND');
        v_param:=' PRC_TXPROCESS4FUND(): p_updatemode = '||p_updatemode||';p_txnum = '||p_txnum||';p_txdate = '||p_txdate||';p_tlid = '||p_tlid||';P_level = '||P_level;
        plog.debug(pkgctx,'Begin '||v_param );

        p_err_code:=systemnums.C_SUCCESS;
        p_err_param:='SUCCESS';



        For vc in (
            Select tltxcd,txstatus txstatus6639,txnum, (CASE WHEN txstatus = 'P' THEN '4' ELSE txstatus END) txstatus
            From tllog
            Where txnum=p_txnum AND TXDATE = to_date(p_txdate,systemnums.c_date_format)
        )
        LOOP
                v_txstatus:=vc.txstatus;
                v_txstatus6639:=vc.txstatus6639;
                v_tltxcd:=vc.tltxcd;
        End loop;

        IF p_updatemode in ('A','R','D') and v_txstatus not in ('4','0','P') THEN
            p_err_code:=-930100;
            Raise  errnums.E_BIZ_RULE_INVALID;
        End if;

        IF p_updatemode in ('A','R','D') and v_txstatus6639=txstatusnums.c_txpending  AND v_tltxcd = '6639' THEN
              p_err_code:=-930100;
              Raise  errnums.E_BIZ_RULE_INVALID;
         END IF;

         IF p_updatemode = 'R' THEN
            UPDATE tllog SET txstatus = txstatusnums.c_txrejected WHERE txnum=p_txnum AND TXDATE = to_date(p_txdate,systemnums.c_date_format);
            plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
            RETURN;
        END IF;
        OPEN pv_refcursor FOR
            select *
            from tllog
            where txnum=p_txnum and txdate= to_date(p_txdate,systemnums.c_date_format);
        LOOP
        FETCH pv_refcursor
        INTO l_tllog;
        EXIT WHEN pv_refcursor%NOTFOUND;
            BEGIN
                if l_tllog.deltd = 'Y' then
                    p_err_code:=errnums.C_SA_CANNOT_DELETETRANSACTION;
                    plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
                    RETURN;
                end if;

                l_txmsg.msgtype     := 'T';
                l_txmsg.local       := 'N';
                l_txmsg.tlid        := l_tllog.tlid;
                l_txmsg.offid       := '6868';
                l_txmsg.off_line    := l_tllog.off_line;
                l_txmsg.WSNAME      := l_tllog.WSNAME;
                l_txmsg.IPADDRESS   := l_tllog.IPADDRESS;
                l_txmsg.txstatus    := '4';--l_tllog.txstatus;
                l_txmsg.msgsts      := '0';
                l_txmsg.ovrsts      := '0';
                l_txmsg.batchname   := 'DAY';
                l_txmsg.txdate      := to_date(l_tllog.txdate,systemnums.c_date_format);
                l_txmsg.busdate     := to_date(l_tllog.busdate,systemnums.c_date_format);
                l_txmsg.txnum       := l_tllog.txnum;
                l_txmsg.tltxcd      := l_tllog.tltxcd;
                l_txmsg.brid        := l_tllog.brid;
                IF p_updatemode = 'A' AND l_tllog.tltxcd = '6639' THEN
                    UPDATE TLLOG SET TXSTATUS = TXSTATUSNUMS.C_TXPENDING
                    WHERE TXNUM = L_TLLOG.TXNUM
                    AND TXDATE = TO_DATE(L_TLLOG.TXDATE ,SYSTEMNUMS.C_DATE_FORMAT);

                    PR_LOG_USERNAME(l_txmsg, p_tlid, 'A');

                    --send mail SHBVNEX-2061
                    NMPKS_EMS.PR_SENDINTERNALEMAIL('SELECT * FROM DUAL', 'EM44', '','N');

                    plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
                    RETURN;
                END IF;


                If p_updatemode = 'Z' then
                    l_txmsg.deltd := txnums.C_DELTD_TXDELETED;
                Else
                    l_txmsg.deltd := txnums.C_DELTD_TXNORMAL;
                End if;

                for rec in
                (
                    select *
                    from tllogfld
                    where txnum=p_txnum
                    and txdate= to_date(p_txdate,systemnums.c_date_format)
                )
                LOOP
                    begin
                        select fldname, defname, fldtype
                        into l_fldname, l_defname, l_fldtype
                        from fldmaster
                        where objname=l_tllog.tltxcd and FLDNAME=rec.FLDCD;

                        l_txmsg.txfields (l_fldname).defname   := l_defname;
                        l_txmsg.txfields (l_fldname).TYPE      := l_fldtype;

                        if l_fldtype = 'C' then
                            l_txmsg.txfields (l_fldname).VALUE     := rec.CVALUE;
                        elsif l_fldtype = 'N' then
                            l_txmsg.txfields (l_fldname).VALUE     := rec.NVALUE;
                        else
                            l_txmsg.txfields (l_fldname).VALUE     := rec.CVALUE;
                        end if;
                    exception when others then
                       Raise errnums.E_BIZ_RULE_INVALID;
                    end;
                end loop;

                p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);

                p_sqlcommand := '
                BEGIN
                    IF txpks_#'|| l_tllog.tltxcd ||'.fn_TxProcess (:p_xmlmsg, :p_err_code, :p_err_param) <> systemnums.c_success THEN
                        ROLLBACK;
                    END IF;
                END;
                ';

                EXECUTE IMMEDIATE p_sqlcommand USING IN OUT p_xmlmsg, IN OUT p_err_code, OUT p_err_param;
                IF p_err_code = TO_CHAR(systemnums.c_success) or p_err_code is null THEN
                    UPDATE ONLREQUESTLOG SET USER_APPR = p_tlid, TIME_APPR = SYSDATE WHERE TXDATE = to_date(p_txdate,systemnums.c_date_format) AND TXNUM = p_txnum;
                    PR_LOG_USERNAME(l_txmsg, p_tlid, 'A');
                    p_err_code := systemnums.c_success;
                END IF;

            EXCEPTION when others THEN
                plog.error (pkgctx, SQLERRM ||  dbms_utility.format_error_backtrace);
                p_err_code := errnums.C_HOST_VOUCHER_NOT_FOUND;
                Raise errnums.E_BIZ_RULE_INVALID;
            end;
            plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
        END LOOP;
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
              plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
               
              plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
              RETURN ;
    END PRC_TXPROCESS4FUND;

    PROCEDURE PRC_GET_LIST_CASCHD(P_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                                           P_CUSTODYCD   IN VARCHAR2,
                                           P_CUSNAME   IN VARCHAR2,
                                           P_SYMBOL   IN VARCHAR2,
                                           P_CATYPE   IN VARCHAR2,
                                           P_CASTATUS   IN VARCHAR2,
                                           P_DATE_TYPE   IN VARCHAR2,
                                           P_FROM_DATE    IN VARCHAR2,
                                           P_TO_DATE    IN VARCHAR2,
                                           P_USERNAME        IN VARCHAR2,
                                           P_ROLE        IN VARCHAR2,
                                           P_ERR_CODE    IN OUT VARCHAR2,
                                           P_ERR_MSG     IN OUT VARCHAR2)
    AS
        V_PARAM         VARCHAR2(4000);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        V_CASTATUS      VARCHAR2(20);
        V_SQL           VARCHAR2(4000);
    BEGIN
        P_ERR_CODE  := SYSTEMNUMS.C_SUCCESS;
        P_ERR_MSG   := 'SUCCESS';

        IF UPPER(P_CASTATUS) = 'ALL' THEN
            V_CASTATUS := '%%';
        ELSE
            V_CASTATUS := UPPER(P_CASTATUS);
        END IF;


        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_USERNAME;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
        END;

        V_SQL := 'SELECT CFMAST.CUSTODYCD,
                 CAMAST.CAMASTID,
                 CAMAST.SYMBOL,
                 A1.CDCONTENT CATYPE, A1.EN_CDCONTENT CATYPE_EN,
                 (CASE WHEN CAMAST.CATYPE = ''014'' THEN CAMAST.RIGHTOFFRATE ELSE CAMAST.RATE END) RATE, --ti le
                 CAMAST.DEVIDENTVALUE, --so tien phan bo
                 (CASE WHEN
                    (CAMAST.CATYPE IN (''014'',''023'') AND CAMAST.STATUS NOT IN (''P'',''N'',''A''))
                    OR
                    (INSTR(CAMAST.PSTATUS,''S'') > 0 OR CAMAST.STATUS = ''S'') THEN CASCHD.BALANCE ELSE 0 END) BALANCE,
                 CAMAST.MEETINGPLACE, --noi hop
                 TO_CHAR(CAMAST.FRDATETRANSFER,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') FRDATETRANSFER, --ngay bat dau chuyen
                 TO_CHAR(CAMAST.TODATETRANSFER,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') TODATETRANSFER, --ngay ket thuc chuyen
                 TO_CHAR(CAMAST.BEGINDATE,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') BEGINDATE,  --ngay bat dau dang ky
                 TO_CHAR(CAMAST.INSDEADLINE,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') INSDEADLINE, --ngay ket thuc dang ky/ han chot dat mua
                 TO_CHAR(CAMAST.RIGHTTRANSDL,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') RIGHTTRANSDL, -- ngay han chot
                 TO_CHAR(CAMAST.DUEDATE,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') DUEDATE, --ngay cat tien
                 (CASE WHEN CAMAST.CATYPE = ''023'' THEN '''' ELSE TO_CHAR(CAMAST.DEBITDATE,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') END) DEBITDATE, --ngay cat tien kh
                 TO_CHAR(CAMAST.ACTIONDATE,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') ACTIONDATE, --ngay phan bo du kien
                 CAMAST.MEETINGDATETIME, --ngay hop
                 CAMAST.INSTRUCTION INSTRUCTION, --ngay cuoi nhan y kien
                 TO_CHAR(CAMAST.KHQDATE,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') KHQDATE, --ngay gd k huong quyen
                 TO_CHAR(CAMAST.REPORTDATE,''' || SYSTEMNUMS.C_DATE_FORMAT || ''') REPORTDATE --ngay dk cuoi cung
            FROM V_CAMAST_CANCELLED CAMAST, CFMAST, AFMAST, SBSECURITIES,
                 (SELECT * FROM ALLCODE WHERE CDNAME = ''CATYPE'') A1,
                 (
                    SELECT CS.CAMASTID, CS.AFACCTNO, CS.DELTD, (CASE WHEN CA.CATYPE = ''023'' THEN CS.TRADE ELSE CS.BALANCE + CS.PBALANCE + CS.OUTBALANCE END) BALANCE FROM CASCHD CS, CAMAST CA WHERE CS.CAMASTID = CA.CAMASTID
                    UNION ALL
                    SELECT CAMASTID, AFACCTNO, DELTD, 0 BALANCE FROM CASCHD_LIST WHERE CAMASTID NOT IN (SELECT CAMASTID FROM CASCHD WHERE DELTD <> ''Y'' GROUP BY CAMASTID)
                 ) CASCHD
            WHERE CAMAST.VALUE = CASCHD.CAMASTID
            AND CASCHD.AFACCTNO = AFMAST.ACCTNO
            AND AFMAST.CUSTID = CFMAST.CUSTID
            AND CAMAST.CATYPE = A1.CDVAL
            AND CAMAST.CODEID = SBSECURITIES.CODEID
            AND SBSECURITIES.TRADEPLACE <> ''003''
            AND CASCHD.DELTD <> ''Y''
            AND CAMAST.DELTD <> ''Y''
            AND (INSTR(''' || V_LISTCUSTODYCD || ''', CFMAST.CUSTODYCD) >0 OR CFMAST.CUSTODYCD = ''' || V_CUSTODYCD|| ''')
            AND CFMAST.CUSTODYCD LIKE NVL(''' || P_CUSTODYCD || ''',''%%'')
            AND CFMAST.FULLNAME LIKE NVL(''' || P_CUSNAME || ''',''%%'')
            AND CAMAST.SYMBOL LIKE NVL(''' || P_SYMBOL || ''',''%%'')
            AND CAMAST.CATYPE LIKE NVL(''' || P_CATYPE || ''',''%%'')
            ';
        IF UPPER(P_CASTATUS) IN ('ALL','C') THEN
            V_SQL := V_SQL || 'AND CAMAST.STATUS LIKE ''' || V_CASTATUS || ''' ';
        ELSE
            V_SQL := V_SQL || 'AND CAMAST.STATUS <> ''C'' ';
        END IF;

        IF P_DATE_TYPE = '1' THEN
            V_SQL := V_SQL || 'AND CAMAST.KHQDATE BETWEEN TO_DATE(''' || P_FROM_DATE || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || ''') AND TO_DATE(''' || P_TO_DATE || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || ''') ';
        ELSIF P_DATE_TYPE = '2' THEN
            V_SQL := V_SQL || 'AND CAMAST.REPORTDATE BETWEEN TO_DATE(''' || P_FROM_DATE || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || ''') AND TO_DATE(''' || P_TO_DATE || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || ''') ';
        ELSE
            V_SQL := V_SQL || 'AND CAMAST.ACTIONDATE BETWEEN TO_DATE(''' || P_FROM_DATE || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || ''') AND TO_DATE(''' || P_TO_DATE || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || ''') ';
        END IF;

        OPEN P_REFCURSOR FOR V_SQL;

    EXCEPTION
        WHEN OTHERS THEN
             P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
             PLOG.ERROR(PKGCTX,'P_CDTYPE: ' || ' ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
    END PRC_GET_LIST_CASCHD;

    PROCEDURE PRC_GET_LIST_3383(P_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                                       P_CUSTODYCD        IN VARCHAR2,
                                       P_CUSNAME        IN VARCHAR2,
                                       P_CAMASTID        IN VARCHAR2,
                                       P_SYMBOL        IN VARCHAR2,
                                       P_OPTSYMBOL        IN VARCHAR2,
                                       P_TLID        IN VARCHAR2,
                                       P_ROLE        IN VARCHAR2,
                                       P_ERR_CODE    IN OUT VARCHAR2,
                                       P_ERR_MSG     IN OUT VARCHAR2)
    AS
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
    BEGIN

        P_ERR_CODE  := SYSTEMNUMS.C_SUCCESS;
        P_ERR_MSG   := 'SUCCESS';

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        OPEN P_REFCURSOR FOR
            SELECT CA.AUTOID, CF.CUSTODYCD, CF.FULLNAME, CA.CAMASTID, SB.SYMBOL, C.OPTSYMBOL, C.RIGHTOFFRATE, C.EXPRICE,
                   CA.PBALANCE + CA.BALANCE + CA.OUTBALANCE - CA.INBALANCE MAXBALANCE, --SL QUYEN DUOC HUONG
                   CA.BALANCE, --SL QUYEN DK DAT MUA
                   (CA.PBALANCE - NVL(CAN.QTTY,0) - CA.QTTYCANCEL) PBALANCE --SL QUYEN CON LAI
            FROM CAMAST C, CASCHD CA, CFMAST CF, AFMAST AF, SBSECURITIES SB,
            (
                SELECT CAMASTID, CUSTODYCD, SUM(QTTY) QTTY FROM CACANCEL GROUP BY CAMASTID, CUSTODYCD
            ) CAN
            WHERE CF.CUSTID = AF.CUSTID
            AND AF.ACCTNO = CA.AFACCTNO
            AND CA.CAMASTID = C.CAMASTID
            AND SB.CODEID = C.CODEID
            AND CA.STATUS IN('V','S','M')
            AND CA.DELTD <>'Y'
            AND C.STATUS IN ('V','S','M')
            AND C.CATYPE = '014'
            AND C.TRFLIMIT = 'Y'
            AND CA.PBALANCE - CA.QTTYCANCEL > 0
            AND C.FRDATETRANSFER <= GETCURRDATE
            AND C.TODATETRANSFER >= GETCURRDATE
            AND (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) >0 OR CF.CUSTODYCD = V_CUSTODYCD)
            AND CF.CUSTODYCD LIKE NVL(P_CUSTODYCD,'%%')
            AND CF.FULLNAME LIKE NVL(P_CUSNAME,'%%')
            AND C.CAMASTID LIKE NVL(P_CAMASTID,'%%')
            AND SB.SYMBOL LIKE NVL(P_SYMBOL,'%%')
            AND C.OPTSYMBOL LIKE NVL(P_OPTSYMBOL,'%%')
            AND CA.CAMASTID = CAN.CAMASTID (+)
            AND CF.CUSTODYCD = CAN.CUSTODYCD (+);
    EXCEPTION
        WHEN OTHERS THEN
             P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
             PLOG.ERROR(PKGCTX,'P_CDTYPE: ' || ' ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
    END PRC_GET_LIST_3383;

    procedure pr_auto_3383_web(
        p_camastid varchar2,
        p_custodycd varchar2,
        p_refcustodycd varchar2,
        p_qtty      number,
        p_qtty_wft      number,
        p_price     number,
        p_taxrate   number,
        p_notransct varchar2,
        p_valuedate      varchar2,
        p_tomemcus       varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     ) is
        l_txmsg          tx.msg_rectype;
        v_strcurrdate    varchar2(20);
        v_tlid           varchar2(5);
        v_xmlmsg_string  varchar2(5000);
        v_txdesc         varchar2(500);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        V_REF_IDCODE    VARCHAR2(100);
        V_REF_IDDATE    DATE;
        V_REF_IDPLACE    VARCHAR2(500);
        V_REF_FULLNAME  VARCHAR2(500);
        V_REF_ADDRESS   VARCHAR2(500);
        V_REF_COUNTRY   VARCHAR2(500);
        V_DEPOSITID     VARCHAR2(100);
        v_ddmast         varchar2(20);
        v_ref_ddmast         varchar2(20);
        v_err_code varchar2(20);
    BEGIN
        plog.setbeginsection (pkgctx, 'pr_auto_3383_web');

        p_err_code := errnums.c_system_error;

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        select to_date (varvalue, systemnums.c_date_format)
        into v_strcurrdate
        from sysvar
        where grname = 'SYSTEM' and varname = 'CURRDATE';

        --SELECT EN_TXDESC into v_txdesc FROM TLTX WHERE TLTXCD = '3383';
        v_txdesc := 'Right transfer';

        select sys_context ('USERENV', 'HOST'), sys_context ('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        begin
            select tlid into v_tlid from cfmast where custodycd = p_custodycd;
        exception
            when no_data_found then
                 v_tlid:= null;
        end;

        begin
            select brid
            into l_txmsg.brid
            from tlprofiles where tlid = v_tlid;
        exception
            when no_data_found then
               l_txmsg.brid:= null;
        end;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        :='6868';
        ------------------------
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txlogged;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
        l_txmsg.tltxcd      := '3383';
        l_txmsg.nosubmit    := '1';
        l_txmsg.ovrrqd      := '@0';

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
            when no_data_found then
                 l_txmsg.txnum:= null;
        end;

        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';
        for rec in
        (
            SELECT CA.AUTOID, CF.CUSTODYCD, CF.FULLNAME, CA.CAMASTID, SB.SYMBOL, C.OPTSYMBOL, C.RIGHTOFFRATE, C.EXPRICE,
                   CA.PBALANCE + CA.BALANCE + CA.OUTBALANCE - CA.INBALANCE MAXBALANCE, --SL QUYEN DUOC HUONG
                   CA.BALANCE, --SL QUYEN DK DAT MUA
                   (CA.PBALANCE - NVL(CAN.QTTY,0) - CA.QTTYCANCEL) PBALANCE, --SL QUYEN CON LAI
                   CA.AFACCTNO || C.CODEID SEACCTNO, NVL(GETBALDEFAVL(CA.AFACCTNO),0) BALDEFAVL, M.VARVALUE FROMCUSADD, CF.CIFID,
                   C.TRFLIMIT, SB.TRADEPLACE, ISS.FULLNAME ISSNAME,
                   NVL(CALOG.TRADE,0) - NVL(CALOG.INTRADE,0) PTRADE, NVL(CALOG.BLOCKED,0) - NVL(CALOG.INBLOCKED,0) PBLOCKED,
                   SB2.SYMBOL TOSYMBOL, ISS2.FULLNAME TOISSNAME, A1.CDCONTENT COUNTRY, CF.FULLNAME CUSTNAME, CF.ADDRESS, CF.IDPLACE,
                   (CASE WHEN CF.COUNTRY = '234' THEN CF.IDCODE ELSE CF.TRADINGCODE END) LICENSE,
                   (CASE WHEN CF.COUNTRY = '234' THEN CF.IDDATE ELSE CF.TRADINGCODEDT END) IDDATE,
                   CF.MCUSTODYCD,
                   CA.PBALANCE-CA.INBALANCE QTTY, CA.PBALANCE- CA.INBALANCE PQTTY
            FROM CAMAST C, CASCHD CA, CFMAST CF, AFMAST AF, SBSECURITIES SB, ISSUERS ISS, SBSECURITIES SB2, ISSUERS ISS2,
            (
                SELECT CAMASTID, CUSTODYCD, SUM(QTTY) QTTY FROM CACANCEL GROUP BY CAMASTID, CUSTODYCD
            ) CAN,
            (
                SELECT * FROM CASCHD_LOG WHERE DELTD = 'N'
            ) CALOG,
            (
                SELECT * FROM ALLCODE WHERE CDNAME = 'COUNTRY' AND CDTYPE = 'CF'
            ) A1,
            (
                SELECT VARVALUE FROM SYSVAR WHERE VARNAME LIKE '%ISSUERMEMBER%'
            ) M
            WHERE CF.CUSTID = AF.CUSTID
            AND AF.ACCTNO = CA.AFACCTNO
            AND CA.CAMASTID = C.CAMASTID
            AND SB.CODEID = C.CODEID
            AND ISS.ISSUERID = SB.ISSUERID
            AND NVL(C.TOCODEID, C.CODEID) = SB2.CODEID
            AND SB2.ISSUERID = ISS2.ISSUERID
            AND CA.STATUS IN('V','S','M')
            AND CA.DELTD <>'Y'
            AND C.STATUS IN ('V','S','M')
            AND C.CATYPE = '014'
            AND C.TRFLIMIT = 'Y'
            AND CA.PBALANCE - CA.QTTYCANCEL > 0
            AND C.FRDATETRANSFER <= GETCURRDATE
            AND C.TODATETRANSFER >= GETCURRDATE
            AND (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) >0 OR CF.CUSTODYCD = V_CUSTODYCD)
            AND CA.CAMASTID = CAN.CAMASTID (+)
            AND CF.CUSTODYCD = CAN.CUSTODYCD (+)
            AND CA.CAMASTID = CALOG.CAMASTID(+)
            AND CA.AFACCTNO = CALOG.AFACCTNO(+)
            AND CF.COUNTRY = A1.CDVAL(+)
            AND CF.CUSTODYCD = P_CUSTODYCD
            AND C.CAMASTID = P_CAMASTID
        )
        loop
            BEGIN
                SELECT CF.FULLNAME, CF.ADDRESS, CF.IDCODE, CF.IDDATE, CF.IDPLACE, A1.CDCONTENT COUNTRY
                INTO V_REF_FULLNAME, V_REF_ADDRESS, V_REF_IDCODE, V_REF_IDDATE, V_REF_IDPLACE, V_REF_COUNTRY
                FROM CFMAST CF, ALLCODE A1
                WHERE CF.CUSTODYCD = P_REFCUSTODYCD
                AND A1.CDVAL = CF.COUNTRY
                AND A1.CDTYPE = 'CF'
                AND A1.CDNAME = 'COUNTRY'
                AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                 --p_err_code := '-200104';
                 --return;
                 V_REF_FULLNAME := '';
                 V_REF_ADDRESS := '';
                 V_REF_IDCODE := '';
                 V_REF_IDDATE := '';
                 V_REF_IDPLACE := '';
                 V_REF_COUNTRY := '';
            END;

            BEGIN
                SELECT D.DEPOSITID INTO V_DEPOSITID
                FROM SYSVAR S, DEPOSIT_MEMBER D
                WHERE S.VARVALUE = D.SHORTNAME
                AND S.VARNAME = 'COMPANYCD';
            EXCEPTION WHEN NO_DATA_FOUND THEN
                 V_DEPOSITID := '629';
            END;

            BEGIN
                SELECT DD.ACCTNO INTO v_ddmast
                FROM DDMAST DD
                WHERE DD.STATUS <> 'C'
                AND DD.ISDEFAULT='Y'
                AND DD.CUSTODYCD = SUBSTR(REC.CUSTODYCD,1,10)
                AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                 p_err_code := '-900058';
                 return;
            END;

            BEGIN
                SELECT DD.ACCTNO INTO v_ref_ddmast
                FROM DDMAST DD
                WHERE DD.STATUS <> 'C'
                AND DD.ISDEFAULT='Y'
                AND DD.CUSTODYCD = SUBSTR(P_REFCUSTODYCD,1,10)
                AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                 --p_err_code := '-900058';
                 --return;
                 v_ref_ddmast := '';
            END;


            --03    S? t?kho?n ghi n?   C
                 l_txmsg.txfields ('03').defname   := 'ACCTNO';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.SEACCTNO;
            --06    M?? ki?n   C
                 l_txmsg.txfields ('06').defname   := 'CAMASTID';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.CAMASTID;
            --07    S? LK ngu?i nh?n   C
                 l_txmsg.txfields ('07').defname   := 'TOACCTNO';
                 l_txmsg.txfields ('07').TYPE      := 'C';
                 l_txmsg.txfields ('07').value      := P_REFCUSTODYCD;
            --08    TVLK ngu?i nh?n   C
                 l_txmsg.txfields ('08').defname   := 'TOMEMCUS';
                 l_txmsg.txfields ('08').TYPE      := 'C';
                 l_txmsg.txfields ('08').value      := p_tomemcus;
            --09    M?ich CA   C
                 l_txmsg.txfields ('09').defname   := 'AUTOID';
                 l_txmsg.txfields ('09').TYPE      := 'C';
                 l_txmsg.txfields ('09').value      := rec.AUTOID;
            --11    Bi?u ph? C
                 l_txmsg.txfields ('11').defname   := 'FEECD';
                 l_txmsg.txfields ('11').TYPE      := 'C';
                 l_txmsg.txfields ('11').value      := '777777';
            --12    Ph?huy?n nhu?ng   N
                 l_txmsg.txfields ('12').defname   := 'FEEAMT';
                 l_txmsg.txfields ('12').TYPE      := 'N';
                 l_txmsg.txfields ('12').value      := fn_getfee3383(0,'777777',NVL(p_qtty,0) + NVL(p_qtty_wft,0),rec.CAMASTID,0);
            --13    Gi?huy?n nhu?ng   N
                 l_txmsg.txfields ('13').defname   := 'TRANFERPRICE';
                 l_txmsg.txfields ('13').TYPE      := 'N';
                 l_txmsg.txfields ('13').value      := NVL(p_price,0);
            --14    T? l? thu?   N
                 l_txmsg.txfields ('14').defname   := 'TAXRATE';
                 l_txmsg.txfields ('14').TYPE      := 'N';
                 l_txmsg.txfields ('14').value      := NVL(p_taxrate, 0.10);
            --15    Thu? chuy?n nhu?ng   N
                 l_txmsg.txfields ('15').defname   := 'TAXAMT';
                 l_txmsg.txfields ('15').TYPE      := 'N';
                 l_txmsg.txfields ('15').value      := fn_CalTaxByRate3383(NVL(p_taxrate, 0.10), NVL(p_price,0), NVL(p_qtty,0) + NVL(p_qtty_wft,0));
            --16    C? ti?n   C
                 l_txmsg.txfields ('16').defname   := 'THGOMONEY';
                 l_txmsg.txfields ('16').TYPE      := 'C';
                 l_txmsg.txfields ('16').value      := 'N';
            --17    S? du kh? d?ng   N
                 l_txmsg.txfields ('17').defname   := 'BALDEFAVL';
                 l_txmsg.txfields ('17').TYPE      := 'N';
                 l_txmsg.txfields ('17').value      := rec.BALDEFAVL;
            --18    Gi?r? chuy?n nhu?ng   N
                 l_txmsg.txfields ('18').defname   := 'TRANFERAMOUNT';
                 l_txmsg.txfields ('18').TYPE      := 'N';
                 l_txmsg.txfields ('18').value      := (NVL(p_qtty,0) + NVL(p_qtty_wft,0)) * NVL(p_price,0);
            --19    T?kho?n ti?n t?   C
                 l_txmsg.txfields ('19').defname   := 'DDACCTNO';
                 l_txmsg.txfields ('19').TYPE      := 'C';
                 l_txmsg.txfields ('19').value      := v_ddmast;
            --21    SL quy?n chuy?n   N
                 l_txmsg.txfields ('21').defname   := 'AMT';
                 l_txmsg.txfields ('21').TYPE      := 'N';
                 l_txmsg.txfields ('21').value      := NVL(p_qtty,0) + NVL(p_qtty_wft,0);
            --22    SL quy?n t?i da chuy?n   N
                 l_txmsg.txfields ('22').defname   := 'MAMT';
                 l_txmsg.txfields ('22').TYPE      := 'N';
                 l_txmsg.txfields ('22').value      := rec.PQTTY;
            --23    SL quy?n c??i   N
                 l_txmsg.txfields ('23').defname   := 'RAMT';
                 l_txmsg.txfields ('23').TYPE      := 'N';
                 l_txmsg.txfields ('23').value      := rec.PQTTY - (NVL(p_qtty,0) + NVL(p_qtty_wft,0));
            --24    S? h?p d?ng chuy?n nhu?ng   C
                 l_txmsg.txfields ('24').defname   := 'NOTRANSCT';
                 l_txmsg.txfields ('24').TYPE      := 'C';
                 l_txmsg.txfields ('24').value      := p_notransct;
            --25    TVLK b?chuy?n   C
                 l_txmsg.txfields ('25').defname   := 'FROMCUSADD';
                 l_txmsg.txfields ('25').TYPE      := 'C';
                 l_txmsg.txfields ('25').value      := rec.FROMCUSADD;
            --26    S? TK ti?n c?a ngu?i nh?n   C
                 l_txmsg.txfields ('26').defname   := 'REMOACCOUNT';
                 l_txmsg.txfields ('26').TYPE      := 'C';
                 l_txmsg.txfields ('26').value      := v_ref_ddmast;
            --27    M?ITAD c?a ngu?i nh?n   C
                 l_txmsg.txfields ('27').defname   := 'CITAD';
                 l_txmsg.txfields ('27').TYPE      := 'C';
                 l_txmsg.txfields ('27').value      := '';
            --28    M?H NH   T
                 l_txmsg.txfields ('28').defname   := 'CIFID';
                 l_txmsg.txfields ('28').TYPE      := 'T';
                 l_txmsg.txfields ('28').value      := rec.CIFID;
            --30    M?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := v_txdesc;
            --31    ??c chuy?n nhu?ng kh?  C
                 l_txmsg.txfields ('31').defname   := 'TRFLIMIT';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := rec.TRFLIMIT;
            --36    S? TK luu k?   C
                 l_txmsg.txfields ('36').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('36').TYPE      := 'C';
                 l_txmsg.txfields ('36').value      := rec.CUSTODYCD;
            --37    Noi d?t   C
                 l_txmsg.txfields ('37').defname   := 'TRADEPLACE';
                 l_txmsg.txfields ('37').TYPE      := 'C';
                 l_txmsg.txfields ('37').value      := rec.TRADEPLACE;
            --38    T?ch?ng kho?  C
                 l_txmsg.txfields ('38').defname   := 'ISSNAME';
                 l_txmsg.txfields ('38').TYPE      := 'C';
                 l_txmsg.txfields ('38').value      := rec.ISSNAME;
            --41    G?i d?n   C
                 l_txmsg.txfields ('41').defname   := 'SENDTO';
                 l_txmsg.txfields ('41').TYPE      := 'C';
                 l_txmsg.txfields ('41').value      := '001';
            --50    SL quy?n CK GD   N
                 l_txmsg.txfields ('50').defname   := 'PTRADE';
                 l_txmsg.txfields ('50').TYPE      := 'N';
                 l_txmsg.txfields ('50').value      := rec.PTRADE;
            --51    SL quy?n chuy?n CK GD   N
                 l_txmsg.txfields ('51').defname   := 'OUTPTRADE';
                 l_txmsg.txfields ('51').TYPE      := 'N';
                 l_txmsg.txfields ('51').value      := NVL(p_qtty,0);
            --52    SL quy?n CK HCCN   N
                 l_txmsg.txfields ('52').defname   := 'PBLOCKED';
                 l_txmsg.txfields ('52').TYPE      := 'N';
                 l_txmsg.txfields ('52').value      := rec.PBLOCKED;
            --53    SL quy?n chuy?n CK HCCN   N
                 l_txmsg.txfields ('53').defname   := 'OUTPBLOCKED';
                 l_txmsg.txfields ('53').TYPE      := 'N';
                 l_txmsg.txfields ('53').value      := NVL(p_qtty_wft,0);
            --60    M?K mua   C
                 l_txmsg.txfields ('60').defname   := 'TOSYMBOL';
                 l_txmsg.txfields ('60').TYPE      := 'C';
                 l_txmsg.txfields ('60').value      := rec.SYMBOL;
            --61    T?CK mua   C
                 l_txmsg.txfields ('61').defname   := 'TOISSNAME';
                 l_txmsg.txfields ('61').TYPE      := 'C';
                 l_txmsg.txfields ('61').value      := rec.TOISSNAME;
            --62    M?K nh?n   C
                 l_txmsg.txfields ('62').defname   := 'TOCODEID';
                 l_txmsg.txfields ('62').TYPE      := 'C';
                 l_txmsg.txfields ('62').value      := rec.TOSYMBOL;
            --80    Qu?c t?ch   C
                 l_txmsg.txfields ('80').defname   := 'COUNTRY';
                 l_txmsg.txfields ('80').TYPE      := 'C';
                 l_txmsg.txfields ('80').value      := rec.COUNTRY;
            --81    Qu?c t?ch   C
                 l_txmsg.txfields ('81').defname   := 'COUNTRY2';
                 l_txmsg.txfields ('81').TYPE      := 'C';
                 l_txmsg.txfields ('81').value      := V_REF_COUNTRY;
            --85    TVLK b?nh?n   C
                 l_txmsg.txfields ('85').defname   := 'TOCUSADD';
                 l_txmsg.txfields ('85').TYPE      := 'C';
                 l_txmsg.txfields ('85').value      := fn_getdepmembername(V_DEPOSITID);
            --88    MCUSTODYCD   C
                 l_txmsg.txfields ('88').defname   := 'MCUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := REC.MCUSTODYCD;
            --90    H? t?  C
                 l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.CUSTNAME;
            --91    ?a ch?   C
                 l_txmsg.txfields ('91').defname   := 'ADDRESS';
                 l_txmsg.txfields ('91').TYPE      := 'C';
                 l_txmsg.txfields ('91').value      := rec.ADDRESS;
            --92    CMND/GPKD   C
                 l_txmsg.txfields ('92').defname   := 'LICENSE';
                 l_txmsg.txfields ('92').TYPE      := 'C';
                 l_txmsg.txfields ('92').value      := rec.LICENSE;
            --93    Ng?c?p   C
                 l_txmsg.txfields ('93').defname   := 'IDDATE';
                 l_txmsg.txfields ('93').TYPE      := 'C';
                 l_txmsg.txfields ('93').value      := rec.IDDATE;
            --94    Noi c?p   C
                 l_txmsg.txfields ('94').defname   := 'IDPLACE';
                 l_txmsg.txfields ('94').TYPE      := 'C';
                 l_txmsg.txfields ('94').value      := rec.IDPLACE;
            --95    H? t?  C
                 l_txmsg.txfields ('95').defname   := 'CUSTNAME2';
                 l_txmsg.txfields ('95').TYPE      := 'C';
                 l_txmsg.txfields ('95').value      := V_REF_FULLNAME;
            --96    ?a ch?   C
                 l_txmsg.txfields ('96').defname   := 'ADDRESS2';
                 l_txmsg.txfields ('96').TYPE      := 'C';
                 l_txmsg.txfields ('96').value      := V_REF_ADDRESS;
            --97    S? gi?y t?   C
                 l_txmsg.txfields ('97').defname   := 'LICENSE2';
                 l_txmsg.txfields ('97').TYPE      := 'C';
                 l_txmsg.txfields ('97').value      := V_REF_IDCODE;
            --98    Ng?c?p   D
                 l_txmsg.txfields ('98').defname   := 'IDDATE2';
                 l_txmsg.txfields ('98').TYPE      := 'D';
                 l_txmsg.txfields ('98').value      := V_REF_IDDATE;
            --99    Noi c?p   C
                 l_txmsg.txfields ('99').defname   := 'IDPLACE2';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := V_REF_IDPLACE;


            v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
            if txpks_#3383.fn_txProcess(v_xmlmsg_string, v_err_code, p_err_msg) <> systemnums.c_success then
                  
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_3383_web');
                 return;
            end if;

            PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');
            p_err_code := systemnums.C_SUCCESS;
            fopks_sa.pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end loop;
        plog.setendsection(pkgctx, 'pr_auto_3383_web');

    exception
        when others then
            plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' ||dbms_utility.format_error_backtrace);
            plog.setendsection(pkgctx, 'pr_auto_3383_web');
            p_err_code := errnums.c_system_error;
    end;

    PROCEDURE PRC_GET_LIST_3386(P_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                                       P_CUSTODYCD        IN VARCHAR2,
                                       P_CUSNAME        IN VARCHAR2,
                                       P_CAMASTID        IN VARCHAR2,
                                       P_SYMBOL        IN VARCHAR2,
                                       P_TLID        IN VARCHAR2,
                                       P_ROLE        IN VARCHAR2,
                                       P_ERR_CODE    IN OUT VARCHAR2,
                                       P_ERR_MSG     IN OUT VARCHAR2)
    AS
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
    BEGIN

        P_ERR_CODE  := SYSTEMNUMS.C_SUCCESS;
        P_ERR_MSG   := 'SUCCESS';

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        OPEN P_REFCURSOR FOR
            SELECT CAR.AUTOID, CF.CUSTODYCD, CF.FULLNAME, CA.CAMASTID, SB.SYMBOL, CA.RIGHTOFFRATE, CA.EXPRICE, CS.PBALANCE + CS.BALANCE + CS.OUTBALANCE - CS.INBALANCE MAXBALANCE,
                   CS.PBALANCE - NVL(CAN.QTTY,0) - CS.QTTYCANCEL PBALANCE, CAR.BALANCE REG_BALANCE, CA.OPTSYMBOL
            FROM CAMAST CA, CASCHD CS, CFMAST CF, SBSECURITIES SB, CAREGISTER CAR,
            (
                SELECT CAMASTID, CUSTODYCD, SUM(QTTY) QTTY FROM CACANCEL GROUP BY CAMASTID, CUSTODYCD
            ) CAN
            WHERE CAR.CAMASTID = CA.CAMASTID
            AND CAR.CAMASTID = CS.CAMASTID
            AND CAR.AFACCTNO = CS.AFACCTNO
            AND CF.CUSTODYCD = CAR.CUSTODYCD
            AND CA.CODEID = SB.CODEID
            AND CS.STATUS IN( 'M','A','S')
            AND CS.DELTD <> 'Y'
            AND CA.DELTD <> 'Y'
            AND CA.CATYPE = '014'
            AND CAR.BALANCE > 0
            --AND TO_CHAR(CA.INSDEADLINE,'DD/MM/RRRR') <= TO_CHAR(GETCURRDATE,'DD/MM/RRRR')
            AND (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) >0 OR CF.CUSTODYCD = V_CUSTODYCD)
            AND CF.CUSTODYCD LIKE NVL(P_CUSTODYCD,'%%')
            AND CF.FULLNAME LIKE NVL(P_CUSNAME,'%%')
            AND CA.CAMASTID LIKE NVL(P_CAMASTID,'%%')
            AND SB.SYMBOL LIKE NVL(P_SYMBOL,'%%')
            AND CA.CAMASTID = CAN.CAMASTID (+)
            AND CF.CUSTODYCD = CAN.CUSTODYCD (+);

    EXCEPTION
        WHEN OTHERS THEN
             P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
             PLOG.ERROR(PKGCTX,'P_CDTYPE: ' || ' ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
    END PRC_GET_LIST_3386;

    PROCEDURE PRC_GET_LIST_3384(p_refcursor   in out pkg_report.ref_cursor,
                                           p_fundsymbol  in varchar2,
                                           p_valuedate   in varchar2,
                                           p_camastid    in varchar2,
                                           p_tlid        in varchar2,
                                           p_role        in varchar2,
                                           p_err_code    in out varchar2,
                                           p_err_msg     in out varchar2)
    as
        v_param         varchar2(4000);
        v_custodycd     varchar2(20);
        v_listcustodycd varchar2(4000);
        v_role          varchar2(10);
    begin

        plog.debug(pkgctx, 'prc_get_list_3384');
        p_err_code  := systemnums.c_success;
        p_err_msg   := 'SUCCESS';

        begin
            select custodycd,listcustodycd,role
            into v_custodycd,v_listcustodycd,v_role
            from userlogin
            where username = p_tlid;
        exception
            when others then
                 v_custodycd := '';
                 v_listcustodycd:='';
                 v_role:='';
        end;

        open p_refcursor for
            SELECT V.ABC, V.AUTOID, V.CUSTODYCD, CF.CIFID, V.FULLNAME, V.AFACCTNO, V.AFACCTNO TRFACCTNO, REPLACE(V.CAMASTID,'.','') CAMASTID, V.SYMBOL,
            V.CODEID, V.TRADE, V.MAXBALANCE, (V.BALANCE + NVL(CAN.QTTY,0)) BALANCE, (V.PBALANCE - NVL(CAN.QTTY,0)) PBALANCE, V.INBALANCE, V.OUTBALANCE, V.QTTY, V.MAXQTTY, V.AVLQTTY, V.SUQTTY BUYQTTY, V.CUSTNAME, V.IDCODE,
            V.IDPLACE, V.ADDRESS, V.IDDATE, V.AAMT, V.OPTCODEID, V.OPTSYMBOL, V.ISCOREBANK,
            V.COREBANK, A1.CDCONTENT STATUS, V.SEACCTNO, V.OPTSEACCTNO, V.ISSNAME,
            V.PARVALUE, V.REPORTDATE, V.ACTIONDATE, V.EXPRICE, RIGHTOFFRATE,
            V.EN_DESCRIPTION, V.DESCRIPTION, A2.CDCONTENT CATYPE, V.BALDEFOVD CIBALANCE, V.PHONE, V.BANKACCTNO, V.BANKNAME, V.SYMBOL_ORG, V.ISINCODE, GRP.GRPID, GRP.GRPNAME CAREBY
            FROM VW_STRADE_CA_RIGHTOFF_3384 V, TLGROUPS GRP, ALLCODE A1,  ALLCODE A2, CFMAST CF,
            (
                SELECT CAMASTID, CUSTODYCD, SUM(QTTY) QTTY FROM CACANCEL GROUP BY CAMASTID, CUSTODYCD
            ) CAN
            WHERE V.CAREBY = GRP.GRPID
            AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS'
            AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'CATYPE'
            AND A1.CDVAL = V.STATUS
            AND V.CATYPE = A2.CDVAL
            AND CF.CUSTODYCD = V.CUSTODYCD
            AND REPLACE(V.CAMASTID,'.','') = CAN.CAMASTID (+)
            AND V.CUSTODYCD = CAN.CUSTODYCD (+)
            AND V.SYMBOL LIKE  NVL(P_FUNDSYMBOL,'%%')
            AND REPLACE(V.CAMASTID,'.','') LIKE NVL(REPLACE(P_CAMASTID,'.',''),'%%')
            AND (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) >0 OR CF.CUSTODYCD = V_CUSTODYCD);

        plog.setendsection(pkgctx, 'prc_get_list_3384');
    exception
        when others then
             p_err_code := errnums.c_system_error;
             plog.error(pkgctx,'prc_get_list_3384: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
             plog.setendsection(pkgctx, 'prc_get_list_3384');
    end;

    procedure pr_auto_3384_web(
        p_camastid       varchar2,
        p_custodycd      varchar2,
        p_qtty           number,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     ) is
        l_txmsg          tx.msg_rectype;
        v_strcurrdate    varchar2(20);
        v_strdesc        varchar2(1000);
        v_stren_desc     varchar2(1000);
        v_tltxcd         varchar2(10);
        p_xmlmsg         varchar2(4000);
        v_param          varchar2(1000);
        p_err_message    varchar2(500);
        l_txnum          varchar2(20);
        v_tlid           varchar2(5);
        v_xmlmsg_string  varchar2(5000);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        v_err_code varchar2(20);
        v_ddacctno  varchar2(30);
    BEGIN
        plog.setbeginsection (pkgctx, 'pr_auto_3384_web');

        p_reftransid :='';

        p_err_code := errnums.c_system_error;

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        select to_date (varvalue, systemnums.c_date_format)
        into v_strcurrdate
        from sysvar
        where grname = 'SYSTEM' and varname = 'CURRDATE';

        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        :='6868';

        begin
            select tlid into v_tlid from cfmast where custodycd = p_custodycd;
        exception
            when no_data_found then
                 v_tlid:= null;
        end;

        select sys_context ('USERENV', 'HOST'),
                 sys_context ('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        begin
            select brid
            into l_txmsg.brid
            from tlprofiles where tlid = v_tlid;
        exception
            when no_data_found then
               l_txmsg.brid:= null;
        end;
        ------------------------
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txlogged;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
        l_txmsg.tltxcd      := '3384';
        l_txmsg.nosubmit    := '1';
        l_txmsg.ovrrqd      := '@0';

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
            when no_data_found then
                 l_txmsg.txnum:= null;
        end;

        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';
        for rec in
        (
            SELECT V.ABC, V.AUTOID, V.CUSTODYCD, CF.CIFID, V.FULLNAME, V.AFACCTNO, V.AFACCTNO TRFACCTNO, REPLACE(V.CAMASTID,'.','') CAMASTID, V.SYMBOL,
            V.CODEID, V.TRADE, V.MAXBALANCE, (V.BALANCE + NVL(CAN.QTTY,0)) BALANCE, (V.PBALANCE - NVL(CAN.QTTY,0)) PBALANCE, V.INBALANCE, V.OUTBALANCE, V.QTTY, V.MAXQTTY, V.AVLQTTY, V.SUQTTY BUYQTTY, V.CUSTNAME, V.IDCODE,
            V.IDPLACE, V.ADDRESS, V.IDDATE, V.AAMT, V.OPTCODEID, V.OPTSYMBOL, V.ISCOREBANK,
            V.COREBANK, A1.CDCONTENT STATUS, V.SEACCTNO, V.OPTSEACCTNO, V.ISSNAME,
            V.PARVALUE, V.REPORTDATE, V.ACTIONDATE, V.EXPRICE, RIGHTOFFRATE,
            V.EN_DESCRIPTION, V.DESCRIPTION, A2.CDCONTENT CATYPE, V.BALDEFOVD CIBALANCE, V.PHONE, V.BANKACCTNO, V.BANKNAME, V.SYMBOL_ORG, V.ISINCODE, GRP.GRPID, GRP.GRPNAME CAREBY,
            V.MCUSTODYCD
            FROM VW_STRADE_CA_RIGHTOFF_3384 V, TLGROUPS GRP, ALLCODE A1,  ALLCODE A2, CFMAST CF,
            (
                SELECT CAMASTID, CUSTODYCD, SUM(QTTY) QTTY FROM CACANCEL GROUP BY CAMASTID, CUSTODYCD
            ) CAN
            WHERE V.CAREBY = GRP.GRPID
            AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS'
            AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'CATYPE'
            AND A1.CDVAL = V.STATUS
            AND V.CATYPE = A2.CDVAL
            AND CF.CUSTODYCD = V.CUSTODYCD
            AND REPLACE(V.CAMASTID,'.','') = CAN.CAMASTID (+)
            AND V.CUSTODYCD = CAN.CUSTODYCD (+)
            AND (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) >0 OR CF.CUSTODYCD = V_CUSTODYCD)
            AND REPLACE(V.CAMASTID,'.','') = REPLACE(P_CAMASTID,'.','')
            AND CF.CUSTODYCD = P_CUSTODYCD
        )
        loop

            BEGIN
                SELECT DD.ACCTNO INTO V_DDACCTNO
                FROM DDMAST DD, CFMAST CF
                WHERE CF.CUSTID = DD.CUSTID
                AND DD.STATUS <> 'C'
                AND DD.ISDEFAULT = 'Y'
                AND CF.CUSTODYCD = P_CUSTODYCD
                AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                  
                 p_err_code := '-900058';
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_3384_web');
                 return;
            END;

            ----AUTOID---------------------
            l_txmsg.txfields('01').defname := 'AUTOID';
            l_txmsg.txfields('01').type    := 'C';
            l_txmsg.txfields('01').value   := REC.AUTOID;
            ----CAMASTID---------------------
            l_txmsg.txfields('02').defname := 'CAMASTID';
            l_txmsg.txfields('02').type    := 'C';
            l_txmsg.txfields('02').value   := P_CAMASTID;
            ----AFACCTNO---------------------
            l_txmsg.txfields('03').defname := 'AFACCTNO';
            l_txmsg.txfields('03').type    := 'C';
            l_txmsg.txfields('03').value   := REC.AFACCTNO;
            ----SYMBOL
            l_txmsg.txfields('04').defname := 'SYMBOL';
            l_txmsg.txfields('04').type    := 'C';
            l_txmsg.txfields('04').value   := REC.SYMBOL;
            ----EXPRICE
            l_txmsg.txfields('05').defname := 'EXPRICE';
            l_txmsg.txfields('05').type    := 'N';
            l_txmsg.txfields('05').value   := REC.EXPRICE;
            ----SEACCTNO
            l_txmsg.txfields('06').defname := 'SEACCTNO';
            l_txmsg.txfields('06').type    := 'C';
            l_txmsg.txfields('06').value   := REC.SEACCTNO;
            ----BALANCE----------------------
            l_txmsg.txfields('07').defname := 'BALANCE';
            l_txmsg.txfields('07').type    := 'N';
            l_txmsg.txfields('07').value   := REC.MAXBALANCE;
            ----FULLNAME
            l_txmsg.txfields('08').defname := 'FULLNAME';
            l_txmsg.txfields('08').type    := 'C';
            l_txmsg.txfields('08').value   := REC.FULLNAME;
            ----OPTSEACCTNO
            l_txmsg.txfields('09').defname := 'OPTSEACCTNO';
            l_txmsg.txfields('09').type    := 'C';
            l_txmsg.txfields('09').value   := REC.OPTSEACCTNO;
            ----AMT
            l_txmsg.txfields('10').defname := 'AMT';
            l_txmsg.txfields('10').type    := 'N';
            l_txmsg.txfields('10').value   := FN_GET_AMT_3384(P_CAMASTID, p_qtty, REC.EXPRICE);
            ----TASKCD
            l_txmsg.txfields('16').defname := 'TASKCD';
            l_txmsg.txfields('16').type    := 'C';
            l_txmsg.txfields('16').value   := null;
            ----MAXQTTY
            l_txmsg.txfields('20').defname := 'MAXQTTY';
            l_txmsg.txfields('20').type    := 'N';
            l_txmsg.txfields('20').value   := REC.MAXQTTY ;
            ----QTTY
            l_txmsg.txfields('21').defname := 'QTTY';
            l_txmsg.txfields('21').type    := 'N';
            l_txmsg.txfields('21').value   := FN_GET_QTTY_3384(P_CAMASTID, p_qtty);
            ----PARVALUE
            l_txmsg.txfields('22').defname := 'PARVALUE';
            l_txmsg.txfields('22').type    := 'N';
            l_txmsg.txfields('22').value   := REC.PARVALUE;
            ----REPORTDATE
            l_txmsg.txfields('23').defname := 'REPORTDATE';
            l_txmsg.txfields('23').type    := 'D';
            l_txmsg.txfields('23').value   := REC.REPORTDATE;
            ----CODEID
            l_txmsg.txfields('24').defname := 'CODEID';
            l_txmsg.txfields('24').type    := 'C';
            l_txmsg.txfields('24').value   := REC.CODEID;
            ----AVLQTTY
            l_txmsg.txfields('25').defname := 'AVLQTTY';
            l_txmsg.txfields('25').type    := 'N';
            l_txmsg.txfields('25').value   := REC.AVLQTTY;
            ----BUYQTTY
            l_txmsg.txfields('26').defname := 'BUYQTTY';
            l_txmsg.txfields('26').type    := 'N';
            l_txmsg.txfields('26').value   := REC.BUYQTTY;
            ----DESCRIPTION
            l_txmsg.txfields('30').defname := 'DESCRIPTION';
            l_txmsg.txfields('30').type    := 'C';
            l_txmsg.txfields('30').value   :=  REC.DESCRIPTION;
            ----DDACCTNO
            l_txmsg.txfields('31').defname := 'DDACCTNO';
            l_txmsg.txfields('31').type    := 'C';
            l_txmsg.txfields('31').value   := V_DDACCTNO;
            ----STATUS
            l_txmsg.txfields('40').defname := 'STATUS';
            l_txmsg.txfields('40').type    := 'C';
            l_txmsg.txfields('40').value   := 'M';
            ----ISCOREBANK
            l_txmsg.txfields('60').defname := 'ISCOREBANK';
            l_txmsg.txfields('60').type    := 'C';
            l_txmsg.txfields('60').value   := REC.ISCOREBANK;
            ----PHONE
            l_txmsg.txfields('70').defname := 'PHONE';
            l_txmsg.txfields('70').type    := 'C';
            l_txmsg.txfields('70').value   := REC.PHONE;
            ----SYMBOL_ORG
            l_txmsg.txfields('71').defname := 'SYMBOL_ORG';
            l_txmsg.txfields('71').type    := 'C';
            l_txmsg.txfields('71').value   := REC.SYMBOL_ORG;
            ----BALANCE
            l_txmsg.txfields('80').defname := 'BALANCE';
            l_txmsg.txfields('80').type    := 'N';
            l_txmsg.txfields('80').value   := REC.BALANCE;
            ----CAQTTY
            l_txmsg.txfields('81').defname := 'BUYQTTY';
            l_txmsg.txfields('81').type    := 'N';
            l_txmsg.txfields('81').value   := p_qtty;
            ----MCUSTODYCD
            l_txmsg.txfields('88').defname := 'MCUSTODYCD';
            l_txmsg.txfields('88').type    := 'C';
            l_txmsg.txfields('88').value   := REC.MCUSTODYCD;
            ----CUSTNAME
            l_txmsg.txfields('90').defname := 'CUSTNAME';
            l_txmsg.txfields('90').type    := 'C';
            l_txmsg.txfields('90').value   := REC.CUSTNAME;
            ----ADDRESS
            l_txmsg.txfields('91').defname := 'ADDRESS';
            l_txmsg.txfields('91').type    := 'C';
            l_txmsg.txfields('91').value   := REC.ADDRESS;
              ----LICENSE
            l_txmsg.txfields('92').defname := 'LICENSE';
            l_txmsg.txfields('92').type    := 'C';
            l_txmsg.txfields('92').value   := REC.IDCODE;
              ----IDDATE
            l_txmsg.txfields('93').defname := 'IDDATE';
            l_txmsg.txfields('93').type    := 'D';
            l_txmsg.txfields('93').value   := REC.IDDATE;
            ----IDPLACE
            l_txmsg.txfields('94').defname := 'IDPLACE';
            l_txmsg.txfields('94').type    := 'C';
            l_txmsg.txfields('94').value   := REC.IDPLACE;
            ----ISSNAME
            l_txmsg.txfields('95').defname := 'ISSNAME';
            l_txmsg.txfields('95').type    := 'C';
            l_txmsg.txfields('95').value   := REC.ISSNAME;
            ----CUSTODYCD---------------------
            l_txmsg.txfields('96').defname := 'CUSTODYCD';
            l_txmsg.txfields('96').type    := 'C';
            l_txmsg.txfields('96').value   := REC.CUSTODYCD;
            ----CIFID---------------------
            l_txmsg.txfields('97').defname := 'CIFID';
            l_txmsg.txfields('97').type    := 'C';
            l_txmsg.txfields('97').value   := REC.CIFID;


            v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
            p_err_code := txpks_#3384.fn_txProcess(v_xmlmsg_string, v_err_code, p_err_message);
            if p_err_code <>systemnums.c_success then
                 plog.error(pkgctx,v_param || ' run ' || v_tltxcd || ' got ' || v_err_code || ':' || p_err_message);
                 p_err_msg :=p_err_message;
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_3384_web');
                 return;
            end if;

            PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');
            p_err_code := systemnums.C_SUCCESS;
            fopks_sa.pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end loop;
        plog.setendsection(pkgctx, 'pr_auto_3384_web');

     exception
        when others then
            v_err_code := errnums.c_system_error;
            plog.error(pkgctx,
                       ' Err: ' || sqlerrm || ' Trace: ' ||
                       dbms_utility.format_error_backtrace);
            plog.error(pkgctx, ' Exception: ' || v_param);
            plog.setendsection(pkgctx, 'pr_auto_3384_web');
            p_err_code   := v_err_code;
    end;

    procedure pr_auto_3386_web(
        p_autoid      varchar2,
        p_custodycd varchar2,
        p_qtty      number,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     ) is
        l_txmsg          tx.msg_rectype;
        v_strcurrdate    varchar2(20);
        v_tlid           varchar2(5);
        v_xmlmsg_string  varchar2(5000);
        v_txdesc         varchar2(500);
        v_ddmast         varchar2(20);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        v_err_code varchar2(20);
    BEGIN
        plog.setbeginsection (pkgctx, 'pr_auto_3386_web');

        p_err_code := errnums.c_system_error;

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        select to_date (varvalue, systemnums.c_date_format)
        into v_strcurrdate
        from sysvar
        where grname = 'SYSTEM' and varname = 'CURRDATE';

        SELECT EN_TXDESC into v_txdesc FROM TLTX WHERE TLTXCD = '3386';

        select sys_context ('USERENV', 'HOST'), sys_context ('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        begin
            select tlid into v_tlid from cfmast where custodycd = p_custodycd;
        exception
            when no_data_found then
                 v_tlid:= null;
        end;

        begin
            select brid
            into l_txmsg.brid
            from tlprofiles where tlid = v_tlid;
        exception
            when no_data_found then
               l_txmsg.brid:= null;
        end;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        :='6868';
        ------------------------
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txlogged;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
        l_txmsg.tltxcd      := '3386';
        l_txmsg.nosubmit    := '1';
        l_txmsg.ovrrqd      := '@0';

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
            when no_data_found then
                 l_txmsg.txnum:= null;
        end;

        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

        for rec in
        (

            SELECT CA.ISINCODE, CS.CAMASTID, CF.CIFID, CS.AUTOID, CAR.CUSTODYCD, CS.AFACCTNO, SYM_ORG.SYMBOL SYMBOL_ORG, SYM.SYMBOL,
                   A1.CDCONTENT STATUS, CS.PBALANCE - NVL(CAN.QTTY, 0) - CS.QTTYCANCEL PBALANCE, CAR.BALANCE, CAR.QTTY MAXQTTY, CAR.QTTY,
                   CS.NMQTTY, CAR.QTTY * CA.EXPRICE AAMT, CA.EXPRICE, SYM.PARVALUE, CA.DESCRIPTION, A2.CDCONTENT CATYPE,
                   CAR.SEACCTNO, CAR.OPTSEACCTNO, ISS.FULLNAME, CA.REPORTDATE, CA.TOCODEID CODEID, CAR.AUTOID REFCODE, 'N' CONNECTS, 'YES' COREBANK, '1' ISCOREBANK,
                   CF.FULLNAME CUSTNAME, CF.ADDRESS, CF.IDCODE LICENSE, CF.IDDATE, CF.IDPLACE
            FROM CAREGISTER CAR, CAMAST CA, CASCHD CS, AFMAST AF, SBSECURITIES SYM_ORG, SBSECURITIES SYM,
                 ALLCODE A2, ALLCODE A1, ISSUERS ISS, CFMAST CF,
                 (
                    SELECT CAMASTID, CUSTODYCD, SUM(QTTY) QTTY FROM CACANCEL GROUP BY CAMASTID, CUSTODYCD
                 ) CAN
            WHERE CAR.CAMASTID = CA.CAMASTID
            AND CAR.CAMASTID = CS.CAMASTID
            AND CAR.AFACCTNO = CS.AFACCTNO
            AND CAR.AFACCTNO = AF.ACCTNO
            AND CA.CODEID = SYM_ORG.CODEID
            AND CS.DELTD <> 'Y'
            AND NVL(CA.TOCODEID,CA.CODEID) = SYM.CODEID
            AND CA.CATYPE = A2.CDVAL AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'CATYPE'
            AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CS.STATUS
            AND ISS.ISSUERID = SYM.ISSUERID
            AND CAR.DELTD = 'N' AND CA.CATYPE = '014'
            AND CAR.QTTY - CAR.CANCELQTTY > 0
            AND CS.STATUS IN( 'M','A','S')
            AND CF.CUSTODYCD = CAR.CUSTODYCD
            AND CF.CUSTODYCD = CAN.CUSTODYCD (+)
            AND CA.CAMASTID = CAN.CAMASTID (+)
            AND CAR.AUTOID = p_autoid
            AND (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) >0 OR CF.CUSTODYCD = V_CUSTODYCD)
            AND CF.CUSTODYCD LIKE NVL(P_CUSTODYCD,'%%')


        )
        loop
            BEGIN
                SELECT DD.ACCTNO INTO v_ddmast
                FROM DDMAST DD
                WHERE DD.STATUS <> 'C'
                AND DD.ISDEFAULT='Y'
                AND DD.CUSTODYCD = SUBSTR(REC.CUSTODYCD,1,10)
                AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                 p_err_code := '-900058';
                 return;
            END;

            --01    M??ch CA   C
                 l_txmsg.txfields ('01').defname   := 'AUTOID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.AUTOID;
            --02    M?A   C
                 l_txmsg.txfields ('02').defname   := 'CAMASTID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.CAMASTID;
            --03    S? Ti?u kho?n   C
                 l_txmsg.txfields ('03').defname   := 'AFACCTNO';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.AFACCTNO;
            --04    CK nh?n   C
                 l_txmsg.txfields ('04').defname   := 'SYMBOL';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.SYMBOL;
            --05    Gi? N
                 l_txmsg.txfields ('05').defname   := 'EXPRICE';
                 l_txmsg.txfields ('05').TYPE      := 'N';
                 l_txmsg.txfields ('05').value      := rec.EXPRICE;
            --06    S? Ti?u kho?n CK   C
                 l_txmsg.txfields ('06').defname   := 'SEACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.SEACCTNO;
            --07    S? CK dang k?   N
                 l_txmsg.txfields ('07').defname   := 'BALANCE';
                 l_txmsg.txfields ('07').TYPE      := 'N';
                 l_txmsg.txfields ('07').value      := 0;
            --08    T?ch?ng kho?  C
                 l_txmsg.txfields ('08').defname   := 'FULLNAME';
                 l_txmsg.txfields ('08').TYPE      := 'C';
                 l_txmsg.txfields ('08').value      := rec.FULLNAME;
            --09    S? Ti?u kho?n CK ph?sinh   C
                 l_txmsg.txfields ('09').defname   := 'OPTSEACCTNO';
                 l_txmsg.txfields ('09').TYPE      := 'C';
                 l_txmsg.txfields ('09').value      := rec.OPTSEACCTNO;
            --14    T?kho?n ti?n t?   C
                 l_txmsg.txfields ('14').defname   := 'DDACCTNO';
                 l_txmsg.txfields ('14').TYPE      := 'C';
                 l_txmsg.txfields ('14').value      := v_ddmast;
            --16    V? vi?c   C
                 l_txmsg.txfields ('16').defname   := 'TASKCD';
                 l_txmsg.txfields ('16').TYPE      := 'C';
                 l_txmsg.txfields ('16').value      := '';
            --20    SL h?y t?i da   N
                 l_txmsg.txfields ('20').defname   := 'MAXQTTY';
                 l_txmsg.txfields ('20').TYPE      := 'N';
                 l_txmsg.txfields ('20').value      := rec.MAXQTTY;
            --21    S? ch?ng kho?h?y d?t mua   N
                 l_txmsg.txfields ('21').defname   := 'QTTY';
                 l_txmsg.txfields ('21').TYPE      := 'N';
                 l_txmsg.txfields ('21').value      := FN_GET_QTTY_3386(rec.CAMASTID, p_qtty);
            --22    M?nh gi? N
                 l_txmsg.txfields ('22').defname   := 'PARVALUE';
                 l_txmsg.txfields ('22').TYPE      := 'N';
                 l_txmsg.txfields ('22').value      := rec.PARVALUE;
            --23    Ng?dang k? cu?i   C
                 l_txmsg.txfields ('23').defname   := 'REPORTDATE';
                 l_txmsg.txfields ('23').TYPE      := 'C';
                 l_txmsg.txfields ('23').value      := rec.REPORTDATE;
            --24    M?h?ng kho?  C
                 l_txmsg.txfields ('24').defname   := 'CODEID';
                 l_txmsg.txfields ('24').TYPE      := 'C';
                 l_txmsg.txfields ('24').value      := rec.CODEID;
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := v_txdesc;
            --60    C?i corebank kh?   N
                 l_txmsg.txfields ('60').defname   := 'ISCOREBANK';
                 l_txmsg.txfields ('60').TYPE      := 'N';
                 l_txmsg.txfields ('60').value      := rec.ISCOREBANK;
            --71    CK ch?t   C
                 l_txmsg.txfields ('71').defname   := 'SYMBOL_ORG';
                 l_txmsg.txfields ('71').TYPE      := 'C';
                 l_txmsg.txfields ('71').value      := rec.SYMBOL_ORG;
            --80    SL quy?n t?i da c?? h?y   N
                 l_txmsg.txfields ('80').defname   := 'MAXBALANCE';
                 l_txmsg.txfields ('80').TYPE      := 'N';
                 l_txmsg.txfields ('80').value      := rec.BALANCE;
            --81    SL quy?n h?y th?c hi?n   N
                 l_txmsg.txfields ('81').defname   := 'CAQTTY';
                 l_txmsg.txfields ('81').TYPE      := 'N';
                 l_txmsg.txfields ('81').value      := p_qtty;
            --90    H? t?  C
                 l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.CUSTNAME;
            --91    ?a ch?   C
                 l_txmsg.txfields ('91').defname   := 'ADDRESS';
                 l_txmsg.txfields ('91').TYPE      := 'C';
                 l_txmsg.txfields ('91').value      := rec.ADDRESS;
            --92    CMND/GPKD   C
                 l_txmsg.txfields ('92').defname   := 'LICENSE';
                 l_txmsg.txfields ('92').TYPE      := 'C';
                 l_txmsg.txfields ('92').value      := rec.LICENSE;
            --93    Ng?c?p   C
                 l_txmsg.txfields ('93').defname   := 'IDDATE';
                 l_txmsg.txfields ('93').TYPE      := 'C';
                 l_txmsg.txfields ('93').value      := rec.IDDATE;
            --94    Noi c?p   C
                 l_txmsg.txfields ('94').defname   := 'IDPLACE';
                 l_txmsg.txfields ('94').TYPE      := 'C';
                 l_txmsg.txfields ('94').value      := rec.IDPLACE;
            --96    S? TK luu k?   C
                 l_txmsg.txfields ('96').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('96').TYPE      := 'C';
                 l_txmsg.txfields ('96').value      := rec.CUSTODYCD;
            --97    M?ang k?   C
                 l_txmsg.txfields ('97').defname   := 'REFCODE';
                 l_txmsg.txfields ('97').TYPE      := 'C';
                 l_txmsg.txfields ('97').value      := rec.REFCODE;
            --98    K?t n?i VSD?   C
                 l_txmsg.txfields ('98').defname   := 'CONNECT';
                 l_txmsg.txfields ('98').TYPE      := 'C';
                 l_txmsg.txfields ('98').value      := REC.CONNECTS;
            --99    M?H t?i NH   C
                 l_txmsg.txfields ('99').defname   := 'CIFID';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := rec.CIFID;

            v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
            if txpks_#3386.fn_txProcess(v_xmlmsg_string, v_err_code, p_err_msg) <> systemnums.c_success then
                 plog.error(pkgctx,' run 3386 got ' || v_err_code || ':' || p_err_msg);
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_3386_web');
                 return;
            end if;

            PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');
            p_err_code := systemnums.C_SUCCESS;
            fopks_sa.pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end loop;
        plog.setendsection(pkgctx, 'pr_auto_3386_web');

    exception
        when others then
            plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' ||dbms_utility.format_error_backtrace);
            plog.setendsection(pkgctx, 'pr_auto_3386_web');
            p_err_code := errnums.c_system_error;
    end;

    PROCEDURE PRC_GET_LIST_3327(P_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                                       P_CUSTODYCD        IN VARCHAR2,
                                       P_CUSNAME        IN VARCHAR2,
                                       P_CAMASTID        IN VARCHAR2,
                                       P_SYMBOL        IN VARCHAR2,
                                       P_TOSYMBOL        IN VARCHAR2,
                                       P_TLID        IN VARCHAR2,
                                       P_ROLE        IN VARCHAR2,
                                       P_ERR_CODE    IN OUT VARCHAR2,
                                       P_ERR_MSG     IN OUT VARCHAR2)
    AS
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
    BEGIN

        P_ERR_CODE  := SYSTEMNUMS.C_SUCCESS;
        P_ERR_MSG   := 'SUCCESS';

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        OPEN P_REFCURSOR FOR
            SELECT V.*, V.TRADE - V.QTTYBOND QTTY2
            FROM V_CA3327 V
            WHERE (INSTR(V_LISTCUSTODYCD, V.CUSTODYCD) >0 OR V.CUSTODYCD = V_CUSTODYCD)
            AND V.CUSTODYCD LIKE NVL(P_CUSTODYCD,'%%')
            AND V.FULLNAME LIKE NVL(P_CUSNAME,'%%')
            AND V.CAMASTID LIKE NVL(P_CAMASTID,'%%')
            AND V.SYMBOL LIKE NVL(P_SYMBOL,'%%')
            AND V.TOSYMBOL LIKE NVL(P_TOSYMBOL,'%%');
    EXCEPTION
        WHEN OTHERS THEN
             P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
             PLOG.ERROR(PKGCTX,'P_CDTYPE: ' || ' ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
    END PRC_GET_LIST_3327;

    procedure pr_auto_3327_web(
        p_camastid varchar2,
        p_custodycd varchar2,
        p_qtty      number,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     ) is
        l_txmsg          tx.msg_rectype;
        v_strcurrdate    varchar2(20);
        v_tlid           varchar2(5);
        v_xmlmsg_string  varchar2(5000);
        v_txdesc         varchar2(500);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        v_err_code varchar2(20);
    BEGIN
        plog.setbeginsection (pkgctx, 'pr_auto_3383_web');

        p_err_code := errnums.c_system_error;

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        select to_date (varvalue, systemnums.c_date_format)
        into v_strcurrdate
        from sysvar
        where grname = 'SYSTEM' and varname = 'CURRDATE';

        SELECT EN_TXDESC into v_txdesc FROM TLTX WHERE TLTXCD = '3327';

        select sys_context ('USERENV', 'HOST'), sys_context ('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        begin
            select tlid into v_tlid from cfmast where custodycd = p_custodycd;
        exception
            when no_data_found then
                 v_tlid:= null;
        end;

        begin
            select brid
            into l_txmsg.brid
            from tlprofiles where tlid = v_tlid;
        exception
            when no_data_found then
               l_txmsg.brid:= null;
        end;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        :='6868';
        ------------------------
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txlogged;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
        l_txmsg.tltxcd      := '3327';
        l_txmsg.nosubmit    := '1';
        l_txmsg.ovrrqd      := '@0';

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
            when no_data_found then
                 l_txmsg.txnum:= null;
        end;

        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';
        for rec in
        (
            SELECT V.*
            FROM V_CA3327 V
            WHERE (INSTR(V_LISTCUSTODYCD, V.CUSTODYCD) >0 OR V.CUSTODYCD = V_CUSTODYCD)
            AND V.CUSTODYCD LIKE NVL(P_CUSTODYCD,'%%')
            AND V.CAMASTID = p_camastid
        )
        loop


            --01    M??ch CA   C
                 l_txmsg.txfields ('01').defname   := 'AUTOID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.AUTOID;
            --02    M?? ki?n   C
                 l_txmsg.txfields ('02').defname   := 'CAMASTID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.CAMASTID;
            --03    S? Ti?u kho?n   C
                 l_txmsg.txfields ('03').defname   := 'AFACCTNO';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.AFACCTNO;
            --04    M?K ch?t   C
                 l_txmsg.txfields ('04').defname   := 'SYMBOL';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.SYMBOL;
            --05    M?K dang k?   C
                 l_txmsg.txfields ('05').defname   := 'TOSYMBOL';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.TOSYMBOL;
            --08    H? t?  C
                 l_txmsg.txfields ('08').defname   := 'FULLNAME';
                 l_txmsg.txfields ('08').TYPE      := 'C';
                 l_txmsg.txfields ('08').value      := rec.FULLNAME;
            --09    S? lu?ng tr?phi?u chuy?n d?i   N
                 l_txmsg.txfields ('09').defname   := 'QTTYBOND';
                 l_txmsg.txfields ('09').TYPE      := 'N';
                 l_txmsg.txfields ('09').value      := p_qtty;
            --10    SL dang k?   N
                 l_txmsg.txfields ('10').defname   := 'QTTY';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := fn_gen_bondconvert(rec.CAMASTID, p_qtty);
            --11    H? th?c chi tr?   T
                 l_txmsg.txfields ('11').defname   := 'FORMOFPAYMENT';
                 l_txmsg.txfields ('11').TYPE      := 'T';
                 l_txmsg.txfields ('11').value      := rec.FORMOFPAYMENT;
            --21    M?K dang k?   C
                 l_txmsg.txfields ('21').defname   := 'TOCODEID';
                 l_txmsg.txfields ('21').TYPE      := 'C';
                 l_txmsg.txfields ('21').value      := rec.TOCODEID;
            --24    M?K ch?t   C
                 l_txmsg.txfields ('24').defname   := 'CODEID';
                 l_txmsg.txfields ('24').TYPE      := 'C';
                 l_txmsg.txfields ('24').value      := rec.CODEID;
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := v_txdesc;
            --88    MCUSTODYCD   C
                 l_txmsg.txfields ('88').defname   := 'MCUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := REC.MCUSTODYCD;
            --96    S? TK luu k?   C
                 l_txmsg.txfields ('96').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('96').TYPE      := 'C';
                 l_txmsg.txfields ('96').value      := rec.CUSTODYCD;
            --97    M?H t?i NH   C
                 l_txmsg.txfields ('97').defname   := 'CIFID';
                 l_txmsg.txfields ('97').TYPE      := 'C';
                 l_txmsg.txfields ('97').value      := rec.CIFID;


            v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
            if txpks_#3327.fn_txProcess(v_xmlmsg_string, v_err_code, p_err_msg) <> systemnums.c_success then
                 plog.error(pkgctx,' run 3327 got ' || v_err_code || ':' || p_err_msg);
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_3327_web');
                 return;
            end if;

            PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');

            p_err_code := systemnums.C_SUCCESS;
            fopks_sa.pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end loop;
        plog.setendsection(pkgctx, 'pr_auto_3327_web');

    exception
        when others then
            plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' ||dbms_utility.format_error_backtrace);
            plog.setendsection(pkgctx, 'pr_auto_3327_web');
            p_err_code := errnums.c_system_error;
    end;

    procedure pr_auto_5501_web(
        p_custodycd      varchar2,
        p_description varchar2,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     ) is
        l_txmsg          tx.msg_rectype;
        v_strcurrdate    varchar2(20);
        v_tlid           varchar2(5);
        v_xmlmsg_string  varchar2(5000);
        v_txdesc         varchar2(500);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        v_err_code varchar2(20);
        v_status varchar2(10);
    BEGIN
        plog.setbeginsection (pkgctx, 'pr_auto_5501_web');

        p_err_code := errnums.c_system_error;

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        select to_date (varvalue, systemnums.c_date_format)
        into v_strcurrdate
        from sysvar
        where grname = 'SYSTEM' and varname = 'CURRDATE';

        SELECT EN_TXDESC into v_txdesc FROM TLTX WHERE TLTXCD = '5501';

        select sys_context ('USERENV', 'HOST'), sys_context ('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        begin
            select tlid into v_tlid from cfmast where custodycd = p_custodycd;
        exception
            when no_data_found then
                 v_tlid:= null;
        end;

        begin
            select brid
            into l_txmsg.brid
            from tlprofiles where tlid = v_tlid;
        exception
            when no_data_found then
               l_txmsg.brid:= null;
        end;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        :='6868';
        ------------------------
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txlogged;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
        l_txmsg.tltxcd      := '5501';
        l_txmsg.nosubmit    := '1';
        l_txmsg.ovrrqd      := '@0';

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
            when no_data_found then
                 l_txmsg.txnum:= null;
        end;

        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

        for rec in
        (
            SELECT *
            FROM CFMAST CF
            WHERE (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) >0 OR CF.CUSTODYCD = V_CUSTODYCD)
            AND CF.CUSTODYCD LIKE NVL(P_CUSTODYCD,'%%')
        )
        loop
            --88    S? t?kho?n luu k?   T
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'T';
                 l_txmsg.txfields ('88').value      := P_CUSTODYCD;
            --31    N?dung   C
                 l_txmsg.txfields ('31').defname   := 'DESCRIPTION';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := p_description;
            --01    N?dung   C
                 l_txmsg.txfields ('01').defname   := 'TLID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := p_tlid;
            --30    M?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := v_txdesc;

            v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);

            if txpks_#5501.fn_txProcess(v_xmlmsg_string, v_err_code, p_err_msg) <> systemnums.c_success then
                 plog.error(pkgctx,' run 5501 got ' || v_err_code || ':' || p_err_msg);
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_5501_web');
                 return;
            end if;

            PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');

            p_err_code := systemnums.C_SUCCESS;

            fopks_sa.pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);

        end loop;
        plog.setendsection(pkgctx, 'pr_auto_5501_web');

    exception
        when others then
            plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' ||dbms_utility.format_error_backtrace);
            plog.setendsection(pkgctx, 'pr_auto_5501_web');
            p_err_code := errnums.c_system_error;
    end;

    procedure pr_auto_5502_web(
        p_custodycd      varchar2,
        p_camastid varchar2,
        p_qtty number,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     ) is
        l_txmsg          tx.msg_rectype;
        v_strcurrdate    varchar2(20);
        v_tlid           varchar2(5);
        v_xmlmsg_string  varchar2(5000);
        v_txdesc         varchar2(500);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        v_err_code varchar2(20);
    BEGIN
        plog.setbeginsection (pkgctx, 'pr_auto_5502_web');

        p_err_code := errnums.c_system_error;

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        select to_date (varvalue, systemnums.c_date_format)
        into v_strcurrdate
        from sysvar
        where grname = 'SYSTEM' and varname = 'CURRDATE';

        SELECT EN_TXDESC into v_txdesc FROM TLTX WHERE TLTXCD = '5502';

        select sys_context ('USERENV', 'HOST'), sys_context ('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        begin
            select tlid into v_tlid from cfmast where custodycd = p_custodycd;
        exception
            when no_data_found then
                 v_tlid:= null;
        end;

        begin
            select brid
            into l_txmsg.brid
            from tlprofiles where tlid = v_tlid;
        exception
            when no_data_found then
               l_txmsg.brid:= null;
        end;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        :='6868';
        ------------------------
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txlogged;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
        l_txmsg.tltxcd      := '5502';
        l_txmsg.nosubmit    := '1';
        l_txmsg.ovrrqd      := '@0';

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
            when no_data_found then
                 l_txmsg.txnum:= null;
        end;

        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

        for rec in
        (
            SELECT CF.CUSTODYCD, CF.FULLNAME, CA.CAMASTID, CA.EXPRICE, CA.RIGHTOFFRATE, CS.BALANCE + CS.PBALANCE TOTALBALANCE, CS.PBALANCE, CS.BALANCE,
                SB1.SYMBOL, SB2.SYMBOL OPTSYMBOL, CA.CODEID
            FROM CAMAST CA, CASCHD CS, AFMAST AF, CFMAST CF, SBSECURITIES SB1, SBSECURITIES SB2
            WHERE CA.CAMASTID = CS.CAMASTID
            AND CS.AFACCTNO = AF.ACCTNO
            AND AF.CUSTID = CF.CUSTID
            AND CA.CODEID = SB1.CODEID
            AND NVL(CA.TOCODEID,CA.CODEID) = SB2.CODEID
            AND (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) > 0 OR CF.CUSTODYCD = V_CUSTODYCD)
            AND CF.CUSTODYCD LIKE NVL(P_CUSTODYCD,'%%')
            AND CA.CAMASTID = p_camastid
            AND CS.DELTD <> 'Y'
            AND CS.STATUS IN( 'M','A','S')
            AND CA.DELTD <> 'Y'
            AND CA.CATYPE = '014'
            AND ROWNUM = 1
        )
        loop
            --03    M?? ki?n   C
                 l_txmsg.txfields ('03').defname   := 'CAMASTID';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.CAMASTID;
            --04    M?h?ng kho?  C
                 l_txmsg.txfields ('04').defname   := 'SYMBOL';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.SYMBOL;
            --05    Gi? N
                 l_txmsg.txfields ('05').defname   := 'EXPRICE';
                 l_txmsg.txfields ('05').TYPE      := 'N';
                 l_txmsg.txfields ('05').value      := rec.EXPRICE;
            --06    SL quy?n du?c hu?ng   N
                 l_txmsg.txfields ('06').defname   := 'TOTALBALANCE';
                 l_txmsg.txfields ('06').TYPE      := 'N';
                 l_txmsg.txfields ('06').value      := rec.TOTALBALANCE;
            --07    SL t?i da du?c dang k? th?c hi?n   N
                 l_txmsg.txfields ('07').defname   := 'MAXBALANCE';
                 l_txmsg.txfields ('07').TYPE      := 'N';
                 l_txmsg.txfields ('07').value      := rec.PBALANCE;
            --08    SL quy?n da~ dang ky?   N
                 l_txmsg.txfields ('08').defname   := 'BALANCE';
                 l_txmsg.txfields ('08').TYPE      := 'N';
                 l_txmsg.txfields ('08').value      := rec.BALANCE;
            --09    SL quy?n c??i   N
                 l_txmsg.txfields ('09').defname   := 'PBALANCE';
                 l_txmsg.txfields ('09').TYPE      := 'N';
                 l_txmsg.txfields ('09').value      := rec.PBALANCE;
            --10    SL quy?n dang k? th?c hi?n   N
                 l_txmsg.txfields ('10').defname   := 'QTTY';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := p_qtty;
            --11    T? l? quy?n/CP du?c mua   C
                 l_txmsg.txfields ('11').defname   := 'RIGHTOFFRATE';
                 l_txmsg.txfields ('11').TYPE      := 'C';
                 l_txmsg.txfields ('11').value      := rec.RIGHTOFFRATE;
            --24    M?K quy?n   C
                 l_txmsg.txfields ('24').defname   := 'OPTSYMBOL';
                 l_txmsg.txfields ('24').TYPE      := 'C';
                 l_txmsg.txfields ('24').value      := rec.OPTSYMBOL;
            --30    M?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := v_txdesc;
            --88    S? t?kho?n luu k?   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --90    H? t?  C
                 l_txmsg.txfields ('90').defname   := 'FULLNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.FULLNAME;

            v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
            if txpks_#5502.fn_txProcess(v_xmlmsg_string, v_err_code, p_err_msg) <> systemnums.c_success then
                 plog.error(pkgctx,' run 5502 got ' || v_err_code || ':' || p_err_msg);
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_5502_web');
                 return;
            end if;

            --log req
            INSERT INTO ONLREQUESTLOG (AUTOID,TLTXCD,CUSTODYCD,CODEID,QTTY,USER_CREATED,TIME_CREATED,USER_APPR,TIME_APPR,TXDATE,TXNUM,STATUS,DESCRIPTION)
            VALUES(seq_ONLREQUESTLOG.NEXTVAL,'5502',P_CUSTODYCD,REC.CODEID,p_qtty,p_tlid,SYSDATE,NULL,NULL,l_txmsg.TXDATE,l_txmsg.TXNUM,'P','');

            PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');
            p_err_code := systemnums.C_SUCCESS;
            fopks_sa.pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end loop;
        plog.setendsection(pkgctx, 'pr_auto_5502_web');

    exception
        when others then
            plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' ||dbms_utility.format_error_backtrace);
            plog.setendsection(pkgctx, 'pr_auto_5502_web');
            p_err_code := errnums.c_system_error;
    end;

    PROCEDURE PR_LOG_USERNAME(P_TXMSG IN TX.MSG_RECTYPE, P_USERNAME VARCHAR2, P_MODE VARCHAR2) IS
    BEGIN
        IF P_MODE = 'C' THEN
            INSERT INTO ONLREQUESTLOG_USER(TXDATE, TXNUM, USER_CREATED, TIME_CREATED)
            VALUES(TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT), P_TXMSG.TXNUM, P_USERNAME, SYSDATE);
        ELSIF P_MODE = 'A' THEN
            UPDATE ONLREQUESTLOG_USER SET USER_APPR = P_USERNAME, TIME_APPR = SYSDATE WHERE TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT) AND TXNUM = P_TXMSG.TXNUM;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX,' ERR: ' || SQLERRM || ' TRACE: ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_LOG_USERNAME');
    END;

    procedure pr_auto_5503_web(
        p_TXDATE      varchar2,
        p_TYPE varchar2,
        p_SYMBOL varchar2,
        p_ISSNAME varchar2,
        p_CONTRACTNO varchar2,
        p_AUTHNAME varchar2,
        p_IDCODE varchar2,
        p_REASON varchar2,
        p_CUSTODYCD varchar2,
        p_FULLNAME varchar2,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     ) is
        l_txmsg          tx.msg_rectype;
        v_strcurrdate    varchar2(20);
        v_tlid           varchar2(5);
        v_xmlmsg_string  varchar2(5000);
        v_txdesc         varchar2(500);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        v_codeid        VARCHAR2(20);
        v_err_code varchar2(20);
    BEGIN
        plog.setbeginsection (pkgctx, 'pr_auto_5503_web');

        p_err_code := errnums.c_system_error;

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        select to_date (varvalue, systemnums.c_date_format)
        into v_strcurrdate
        from sysvar
        where grname = 'SYSTEM' and varname = 'CURRDATE';

        SELECT EN_TXDESC into v_txdesc FROM TLTX WHERE TLTXCD = '5503';

        select sys_context ('USERENV', 'HOST'), sys_context ('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        l_txmsg.brid        := '0001';
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        :='6868';
        ------------------------
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txlogged;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
        l_txmsg.tltxcd      := '5503';
        l_txmsg.nosubmit    := '1';
        l_txmsg.ovrrqd      := '@0';

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
            when no_data_found then
                 l_txmsg.txnum:= null;
        end;

        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

        for rec in
        (
            SELECT to_date(p_TXDATE,systemnums.c_date_format) TXDATE, p_TYPE TYPE, p_SYMBOL SYMBOL, p_ISSNAME ISSNAME,
                   p_CONTRACTNO CONTRACTNO, p_AUTHNAME AUTHNAME, p_IDCODE IDCODE, p_REASON REASON, p_FULLNAME FULLNAME,
                   p_CUSTODYCD CUSTODYCD
            FROM DUAL
        )
        loop
            --01    N?dung   C
                 l_txmsg.txfields ('01').defname   := 'TLID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := p_tlid;
            --02    S? h?p d?ng   C
                 l_txmsg.txfields ('02').defname   := 'CONTRACTNO';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.CONTRACTNO;
            --04    M?h?ng kho?  C
                 l_txmsg.txfields ('04').defname   := 'SYMBOL';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.SYMBOL;
            --05    CMND/GPKD   C
                 l_txmsg.txfields ('05').defname   := 'IDCODE';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.IDCODE;
            --06    T?ngu?i ?y quy?n   T
                 l_txmsg.txfields ('06').defname   := 'AUTHNAME';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.AUTHNAME;
            --20    Ng?giao d?ch   D
                 l_txmsg.txfields ('20').defname   := 'TXDATE';
                 l_txmsg.txfields ('20').TYPE      := 'D';
                 l_txmsg.txfields ('20').value      := rec.TXDATE;
            --21    Lo?i   C
                 l_txmsg.txfields ('21').defname   := 'TYPE';
                 l_txmsg.txfields ('21').TYPE      := 'C';
                 l_txmsg.txfields ('21').value      := rec.TYPE;
            /*--30    M?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := v_txdesc;*/
            --31    L? do   C
                 l_txmsg.txfields ('31').defname   := 'REASON';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := rec.REASON;
            --79    T?ch?ng kho?  C
                 l_txmsg.txfields ('79').defname   := 'ISSNAME';
                 l_txmsg.txfields ('79').TYPE      := 'C';
                 l_txmsg.txfields ('79').value      := rec.ISSNAME;
             --88    S? t?kho?n luu k?   T
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'T';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
             --90    H? t?  C
                 l_txmsg.txfields ('90').defname   := 'FULLNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.FULLNAME;

            v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
            if txpks_#5503.fn_txProcess(v_xmlmsg_string, v_err_code, p_err_msg) <> systemnums.c_success then
                 plog.error(pkgctx,' run 5503 got ' || v_err_code || ':' || p_err_msg);
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_5503_web');
                 return;
            end if;

            PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');
            p_err_code := systemnums.C_SUCCESS;
            fopks_sa.pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end loop;
        plog.setendsection(pkgctx, 'pr_auto_5503_web');

    exception
        when others then
            plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' ||dbms_utility.format_error_backtrace);
            plog.setendsection(pkgctx, 'pr_auto_5503_web');
            p_err_code := errnums.c_system_error;
    end;

    procedure pr_auto_3300_web(
        p_custodycd      varchar2,
        p_camastid varchar2,
        p_qtty number,
        p_valuedate      varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     ) is
        l_txmsg          tx.msg_rectype;
        v_strcurrdate    varchar2(20);
        v_tlid           varchar2(5);
        v_xmlmsg_string  varchar2(5000);
        v_txdesc         varchar2(500);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        v_err_code varchar2(20);
    BEGIN
        plog.setbeginsection (pkgctx, 'pr_auto_3383_web');

        p_err_code := errnums.c_system_error;

        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        select to_date (varvalue, systemnums.c_date_format)
        into v_strcurrdate
        from sysvar
        where grname = 'SYSTEM' and varname = 'CURRDATE';

        SELECT EN_TXDESC into v_txdesc FROM TLTX WHERE TLTXCD = '3300';

        select sys_context ('USERENV', 'HOST'), sys_context ('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        begin
            select tlid into v_tlid from cfmast where custodycd = p_custodycd;
        exception
            when no_data_found then
                 v_tlid:= null;
        end;

        begin
            select brid
            into l_txmsg.brid
            from tlprofiles where tlid = v_tlid;
        exception
            when no_data_found then
               l_txmsg.brid:= null;
        end;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        :='6868';
        ------------------------
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txlogged;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
        l_txmsg.tltxcd      := '3300';
        l_txmsg.nosubmit    := '1';
        l_txmsg.ovrrqd      := '@0';

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
            when no_data_found then
                 l_txmsg.txnum:= null;
        end;

        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';
        for rec in
        (
            SELECT CF.CUSTODYCD, CF.FULLNAME, CA.CAMASTID, CA.EXPRICE, CA.RIGHTOFFRATE, CS.PBALANCE - NVL(CAN.QTTY,0) PBALANCE, CS.BALANCE,
                SB1.SYMBOL, SB2.SYMBOL OPTSYMBOL, CA.CODEID, CF.CIFID
            FROM CAMAST CA, CASCHD CS, AFMAST AF, CFMAST CF, SBSECURITIES SB1, SBSECURITIES SB2,
            (
                SELECT CAMASTID, CUSTODYCD, SUM(QTTY) QTTY FROM CACANCEL GROUP BY CAMASTID, CUSTODYCD
            ) CAN
            WHERE CA.CAMASTID = CS.CAMASTID
            AND CS.AFACCTNO = AF.ACCTNO
            AND AF.CUSTID = CF.CUSTID
            AND CA.CODEID = SB1.CODEID
            AND NVL(CA.TOCODEID,CA.CODEID) = SB2.CODEID
            AND (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) > 0 OR CF.CUSTODYCD = V_CUSTODYCD)
            AND CF.CUSTODYCD LIKE NVL(P_CUSTODYCD,'%%')
            AND CA.CAMASTID = p_camastid
            AND CS.DELTD <> 'Y'
            --AND CS.STATUS IN( 'M','A','S')
            AND CA.DELTD <> 'Y'
            AND CA.CATYPE = '014'
            AND CA.CAMASTID = CAN.CAMASTID (+)
            AND CF.CUSTODYCD = CAN.CUSTODYCD (+)
            AND ROWNUM = 1
        )
        loop


            --03    M?? ki?n quy?n   C
                 l_txmsg.txfields ('03').defname   := 'CAMASTID';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.CAMASTID;
            --88    S?a`i khoa?n luu ky?   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --90    T?t?kho?n   C
                 l_txmsg.txfields ('90').defname   := 'FULLNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.FULLNAME;
            --83    M?H t?i NH   C
                 l_txmsg.txfields ('83').defname   := 'CIFID';
                 l_txmsg.txfields ('83').TYPE      := 'C';
                 l_txmsg.txfields ('83').value      := rec.CIFID;
            --04    M?h?ng kho?ch?t   C
                 l_txmsg.txfields ('04').defname   := 'SYMBOL';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.SYMBOL;
            --01    M?h?ng kho?ch?t   C
                 l_txmsg.txfields ('01').defname   := 'CODEID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.CODEID;
            --12    Ma~ chu?ng khoa?n nh?   C
                 l_txmsg.txfields ('12').defname   := 'SYMBOLRE';
                 l_txmsg.txfields ('12').TYPE      := 'C';
                 l_txmsg.txfields ('12').value      := rec.OPTSYMBOL;
            --14    SL quy?n t?i da du?c dang k? h?y   N
                 l_txmsg.txfields ('14').defname   := 'MAXQTTY';
                 l_txmsg.txfields ('14').TYPE      := 'N';
                 l_txmsg.txfields ('14').value      := rec.PBALANCE;
            --15    SL quy?n c??i du?c dang k? h?y   N
                 l_txmsg.txfields ('15').defname   := 'REMQTTY';
                 l_txmsg.txfields ('15').TYPE      := 'N';
                 l_txmsg.txfields ('15').value      := rec.PBALANCE - p_qtty;
            --10    SL quy? dang ky? hu?y   N
                 l_txmsg.txfields ('10').defname   := 'QTTY';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := p_qtty;
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := v_txdesc;


            v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
            if txpks_#3300.fn_txProcess(v_xmlmsg_string, v_err_code, p_err_msg) <> systemnums.c_success then
                 plog.error(pkgctx,' run 3300 got ' || v_err_code || ':' || p_err_msg);
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_3300_web');
                 return;
            end if;

            PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');

            p_err_code := systemnums.C_SUCCESS;
            fopks_sa.pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end loop;
        plog.setendsection(pkgctx, 'pr_auto_3300_web');

    exception
        when others then
            plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' ||dbms_utility.format_error_backtrace);
            plog.setendsection(pkgctx, 'pr_auto_3300_web');
            p_err_code := errnums.c_system_error;
    end;

    PROCEDURE PRC_GETUSSEARCH2(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_TellerId varchar2,
                    p_role varchar2,
                    p_SearchFilter varchar2,
                    p_FDate varchar2,
                    p_TDate varchar2
    )
    IS
    TellerId VARCHAR2(100);
    BranchId VARCHAR2(100);
    SearchFilter VARCHAR2(100);
    v_sql clob;
    v_tablelog varchar2(500);
    v_tablelogfld varchar2(500);
    v_Searchlft varchar2(4000);
    v_mbcode varchar2(20);
    Begin

        SearchFilter:= p_SearchFilter;
        BranchId:='0001';
        TellerId:=p_TellerId;
        --PR_GETUSSEARCH_front(PV_REFCURSOR,p_TellerId,'0001',p_SearchFilter);
        begin
            v_tablelog := '(SELECT * FROM vw_tllog_all WHERE TXDATE BETWEEN TO_DATE(''' || p_FDate || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || ''') AND TO_DATE(''' || p_TDate || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || '''))';
            v_tablelogfld := '(SELECT * FROM vw_tllogfld_all WHERE TXDATE BETWEEN TO_DATE(''' || p_FDate || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || ''') AND TO_DATE(''' || p_TDate || ''',''' || SYSTEMNUMS.C_DATE_FORMAT || '''))';

            v_sql:='SELECT *
                    FROM
                    (
                        SELECT CF.FULLNAME CFFULLNAME, CF.CUSTODYCD IDAFACCTNO, SB.CODEID, TX.EN_TXDESC NAMENV, L.CAREBYGRP, L.AUTOID, L.DELTD, L.TXNUM, TO_CHAR(L.TXDATE,''DD/MM/RRRR'') TXDATE,
                               L.BUSDATE, L.BRID, L.TLTXCD || ''-'' || TX.EN_TXDESC TLTXCD, A0.EN_CDCONTENT TXSTATUS, NVL(L.TXDESC, TX.TXDESC) TXDESC, L.MSGACCT ACCTNO, L.MSGAMT AMT, L.TLID, L.CHKID, L.OFFID,
                               (
                                    CASE WHEN L.TXSTATUS IN (''7'',''P'') THEN ''4''
                                         WHEN L.TXSTATUS = ''4'' AND L.TLTXCD = ''6639'' THEN ''1''
                                         ELSE L.TXSTATUS END
                               ) TXSTATUSCD,
                               NVL(UC.USER_CREATED,''____'') TLNAME, NVL(UC.USER_APPR,''____'') CHKNAME,
                               L.CREATEDT, NVL(L.TXTIME,L.OFFTIME) TXTIME, L.OFFTIME, '''' LVEL, '''' DSTATUS, '''' PARENTTABLE, '''' PARENTVALUE, '''' PARENTKEY, '''' CHILTABLE,
                               '''' CHILDVALUE, '''' CHILDKEY, '''' MODULCODE, CF.CUSTODYCD CUSTODYCD, CF.FULLNAME FUNDNAME ,''CB'' APPMODE, TO_CHAR(UC.TIME_CREATED,''HH24:MI:SS'') TIME_CREATED, TO_CHAR(UC.TIME_APPR,''HH24:MI:SS'') TIME_APPR
                        FROM (SELECT * FROM ' || v_tablelog || ' WHERE BATCHNAME = ''DAY'') L,
                             (SELECT * FROM ALLCODE WHERE CDNAME = ''TXSTATUS'' AND CDTYPE = ''SY'') A0,
                             ONLREQUESTLOG_USER UC, USERLOGIN U, CFMAST CF, SBSECURITIES SB, TLTX TX
                        WHERE L.TLID = ''6868''
                        AND L.CCYUSAGE = SB.CODEID(+)
                        AND L.CFCUSTODYCD = CF.CUSTODYCD(+)
                        AND L.TLTXCD = TX.TLTXCD
                        AND L.TXNUM = UC.TXNUM(+) AND L.TXDATE = UC.TXDATE(+)
                        AND (
                            CASE WHEN L.TLTXCD = ''5503'' THEN (CASE WHEN U.USERNAME = UC.USER_CREATED THEN 1 ELSE 0 END)
                                 WHEN L.TLTXCD = ''8800'' THEN (
                                      select case when  count(*)>0 then 0 else 1 end a
                                      from import_online_temp temp,
                                           (select listcustodycd||'';''||custodycd listcs from userlogin where username ='''||P_TELLERID||''') l
                                       where fileid = l.msgacct and instr(l.listcs,temp.custodycd) = 0
                                      )
                                 ELSE (CASE WHEN INSTR(U.LISTCUSTODYCD,CF.CUSTODYCD) > 0 OR U.CUSTODYCD = CF.CUSTODYCD THEN 1 ELSE 0 END)
                            END
                        ) = 1
                        AND A0.CDVAL = (CASE WHEN L.DELTD=''Y'' THEN ''9''
                                             WHEN L.TXSTATUS =''P'' THEN ''4''
                                             WHEN L.TXSTATUS =''4'' AND L.TLTXCD = ''6639'' THEN ''1''
                                             WHEN (L.TXSTATUS =''4'' AND L.OVRRQS <> ''0'' AND L.OVRRQS <> ''@00'' AND L.CHKID IS NOT NULL AND L.OFFID IS NULL) THEN ''10'' ELSE L.TXSTATUS END)
                        AND L.TXSTATUS NOT IN (''0'')
                        AND U.USERNAME = ''' || P_TELLERID || '''
                    )
                    WHERE 0 = 0';

            --dbms_output.put_line('v_sql:' || v_sql);
            v_Searchlft:=SearchFilter;
            v_Searchlft:=v_Searchlft|| ' order by decode(TXSTATUSCD,''4'',''-1'',TXSTATUSCD),createdt desc';
            IF length(SearchFilter)>0 then
                v_sql := v_sql || ' AND ' || v_Searchlft;
            ELSE
                  v_sql := v_sql || ' ' || v_Searchlft;
            end if;

            open PV_REFCURSOR for v_sql;
        EXCEPTION
          WHEN others THEN -- caution handles all exceptions
           plog.error('ERROR: ' || SQLERRM || dbms_utility.format_error_backtrace);
        end;
        plog.setendsection (pkgctx, 'PRC_GETUSSEARCH');
    End;

FUNCTION fn_getvalFromSQL(p_strSQL IN VARCHAR2,p_fldname IN VARCHAR2) RETURN VARCHAR2
IS
l_return varchar2(1000);
l_count NUMBER;
l_refcursor pkg_report.ref_cursor;
v_desc_tab dbms_sql.desc_tab;
v_cursor_number NUMBER;
v_columns NUMBER;
v_number_value NUMBER;
v_varchar_value VARCHAR(200);
v_date_value DATE;
l_fldname varchar2(100);
BEGIN
    l_return :='';
    OPEN l_refcursor FOR p_strSQL;
    v_cursor_number := dbms_sql.to_cursor_number(l_refcursor);
    dbms_sql.describe_columns(v_cursor_number, v_columns, v_desc_tab);
    --define colums
    FOR i IN 1 .. v_desc_tab.COUNT LOOP
            IF v_desc_tab(i).col_type = dbms_types.typecode_number THEN
            --Number
                dbms_sql.define_column(v_cursor_number, i, v_number_value);
            ELSIF v_desc_tab(i).col_type = dbms_types.typecode_varchar
                OR  v_desc_tab(i).col_type = dbms_types.typecode_char THEN
            --Varchar, char
                dbms_sql.define_column(v_cursor_number, i, v_varchar_value,200);
            ELSIF v_desc_tab(i).col_type = dbms_types.typecode_date THEN
            --Date,
               dbms_sql.define_column(v_cursor_number, i, v_date_value);
            END IF;
    END LOOP;
    WHILE dbms_sql.fetch_rows(v_cursor_number) > 0 LOOP
        FOR i IN 1 .. v_desc_tab.COUNT LOOP
              l_fldname :=  v_desc_tab(i).col_name;
              IF l_fldname = p_fldname THEN
                  IF v_desc_tab(i).col_type = dbms_types.typecode_number THEN
                       dbms_sql.column_value(v_cursor_number, i, v_number_value);
                       l_return := to_char(v_number_value);
                  ELSIF  v_desc_tab(i).col_type = dbms_types.typecode_varchar
                    OR  v_desc_tab(i).col_type = dbms_types.typecode_char
                    THEN
                       dbms_sql.column_value(v_cursor_number, i, v_varchar_value);
                       l_return := v_varchar_value;
                  ELSIF v_desc_tab(i).col_type = dbms_types.typecode_date THEN
                       dbms_sql.column_value(v_cursor_number, i, v_date_value);
                       l_return:=to_char(v_date_value,'DD/MM/RRRR');
                  END IF;
                  RETURN l_return;
              END IF;
        END LOOP;
    END LOOP;
    RETURN l_return;
EXCEPTION WHEN OTHERS THEN
    RETURN '';
END;

PROCEDURE PRC_GET_TRANSACT(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_txnum varchar2,
                    p_txdate varchar2,
                    p_TellerId varchar2,
                    p_role varchar2,
                    p_reflogid varchar2,
                    p_err_code in out varchar2,
                    p_err_param in out varchar2)
  is
    v_txdate DATE;
    v_tltxcd varchar2(100);
    v_refid varchar2(100);
    v_sql   varchar2(5000);
    v_CAMASTID varchar2(100);
    v_FileID   varchar2(100);
    v_CustID   varchar2(100);
    v_dbcode   varchar2(100);
    v_GetTltxcd   varchar2(100);
    v_Acctype VARCHAR2(100);
    v_AutoID varchar2(100);
    v_filecode varchar2(30);
  Begin
        plog.setbeginsection (pkgctx, 'PRC_GET_TRANSACT');
         

        p_err_code:=systemnums.C_SUCCESS;
        p_err_param:='Sucssess';
        v_txdate:=to_date(p_txdate,'DD/MM/RRRR');
     BEGIN
       SELECT tltxcd INTO v_tltxcd  FROM vw_tllog_all t WHERE t.txnum=p_txnum AND t.txdate=v_txdate;
     END;
     IF v_tltxcd NOT IN ('8800') THEN
      Open PV_REFCURSOR for
         select t.tltxcd,t.txnum,t.txdate,tf.autoid,
            f.caption,
            f.en_caption,
            case
                when f.ctltype<>'M' and length(f.llist)>5 and TAGFIELD is null then
                    fn_get_lookup_value(decode(f.datatype,'N',to_char(tf.nvalue),tf.cvalue),f.llist)
                when f.ctltype<>'M' and  TAGFIELD is not null and f.taglist is not null then
                    fn_get_TAGLIST_value(p_txnum,getcurrdate,decode(f.datatype,'N',to_char(tf.nvalue),tf.cvalue),tagfield,f.taglist)
                when f.ctltype='M' and length(f.llist)>5 and TAGFIELD is null then
                    decode(f.datatype,'N',to_char(tf.nvalue),tf.cvalue) ||'|'||fn_get_lookup_value(decode(f.datatype,'N',to_char(tf.nvalue),tf.cvalue),f.llist)
                when f.ctltype='M' and  TAGFIELD is not null and f.taglist is not null then
                    decode(f.datatype,'N',to_char(tf.nvalue),tf.cvalue)||'|'||fn_get_TAGLIST_value(p_txnum,getcurrdate,decode(f.datatype,'N',to_char(tf.nvalue),tf.cvalue),tagfield,f.taglist)
                Else decode(f.datatype,'N',to_char(tf.nvalue),tf.cvalue)
            end fvalue
            ,f.odrnum
            ,f.mandatory
            ,f.datatype
            ,F.fldformat
            ,f.fldwidth
            ,'NORMAL' type
           -- ,f.ctltype,f.llist,f.tagfield,f.taglist,length(f.llist)
        from vw_tllogfld_all tf, vw_tllog_all t , fldmaster f
        where t.txnum=tf.txnum
        and t.txdate=tf.txdate
        and t.tltxcd=f.objname
        and tf.fldcd=f.fldname
        and f.visible='Y' and NVL(F.CHAINNAME, '###') NOT IN ('NOVISIBLEWEB') --k hien thi khi duyet
        and t.txnum=p_txnum
        and t.txdate=v_txdate
        and ( ( (f.objname='3383') and f.defname not in ('NOTRANSCT','REMOACCOUNT','CITAD','CUSTNAME2','LICENSE2','IDDATE','IDDATE2','IDPLACE','IDPLACE2','ADDRESS','ADDRESS2','$FEECD','TRADEPLACE','COUNTRY','COUNTRY2'))
            or (f.objname <> '3383') and 1=1)
        order by odrnum;
   ELSIF v_tltxcd ='8800' THEN
        SELECT cvalue INTO v_filecode FROM tllogfld t WHERE t.fldcd ='16' AND t.txnum=p_txnum AND t.txdate=v_txdate;
        SELECT cvalue INTO v_FileID FROM tllogfld t WHERE t.fldcd ='15' AND t.txnum=p_txnum AND t.txdate=v_txdate;

        if v_filecode = 'I069' then
            SELECT searchcmdsql INTO v_sql FROM search WHERE searchcode  ='IMP8864ONLINE';
        ELSIF v_filecode = 'I072' then
         SELECT searchcmdsql INTO v_sql FROM search WHERE searchcode  ='IMP8894ONLINE';
          ELSIF v_filecode = 'I073' then
         SELECT searchcmdsql INTO v_sql FROM search WHERE searchcode  ='I073_IMP8864ONLINE';
        ELSIF v_filecode = 'I078' then
         SELECT searchcmdsql INTO v_sql FROM search WHERE searchcode  ='IMP6639_I078ONLINE';
        ELSIF v_filecode = 'R0061' then
         SELECT searchcmdsql INTO v_sql FROM search WHERE searchcode  ='IMP6639_R0061ONLINE';
       ELSIF v_filecode = 'I079' then
         SELECT searchcmdsql INTO v_sql FROM search WHERE searchcode  ='IMP6639_I079ONLINE';
       ELSIF v_filecode = 'I080' then
         SELECT searchcmdsql INTO v_sql FROM search WHERE searchcode  ='IMP6639_I080ONLINE';
        end if;

        v_sql:= v_sql||' AND  fileid =  '''|| v_FileID||'''';
       plog.debug(pkgctx,' v_sql: ' || v_sql );
      Open PV_REFCURSOR FOR v_sql;

     END IF;

     plog.setendsection (pkgctx, 'PRC_GET_TRANSACT');
   EXCEPTION
    WHEN OTHERS
       THEN
          p_err_code := errnums.C_SYSTEM_ERROR;
          plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
          plog.setendsection (pkgctx, 'PRC_GET_TRANSACT');
          RETURN ;
  End;
FUNCTION fn_get_lookup_value(p_value varchar2,
                             p_llist  varchar2
                                          )
  return string is
  v_sql varchar2(3000);
  l_return varchar2(2000);
BEGIN
  v_sql:='Select DISPLAY From ('||p_LLIST||') where VALUE='''||p_value||'''';
--  dbms_output.put_line('fn_get_lookup_value: v_sql = '||v_sql);
  l_return:=fn_getvalFromSQL(v_sql,'DISPLAY') ;
--  dbms_output.put_line('fn_get_lookup_value: l_return = '||l_return);
  If l_return is null or length(l_return)=0 then
    return p_value;
  Else
    return l_return;
  End if;
Exception
  when others then
 -- dbms_output.put_line(' fn_get_lookup_value: Exception ');
   return p_value;
end;
FUNCTION fn_get_TAGLIST_value(p_txnum varchar2,
                              p_txdate date,
                              p_value varchar2,
                              p_tagfield  varchar2,
                              p_taglist  varchar2  )return string is
    v_sql varchar2(3000);
  l_return varchar2(2000);
  v_tagfieldvalue varchar2(1000);
BEGIN
plog.setbeginsection (pkgctx, 'fn_get_TAGLIST_value');
  For vc in( select t.tltxcd,t.txnum,t.txdate,tf.autoid,
            decode(f.datatype,'N',to_char(tf.nvalue),tf.cvalue)  fvalue
        from tllogfld tf, tllog t , fldmaster f
        where t.txnum=tf.txnum
        and t.txdate=tf.txdate
        and t.tltxcd=f.objname
        and tf.fldcd=f.fldname
        and t.txnum=p_txnum
        and t.txdate=p_txdate
        and tf.fldcd=p_tagfield)
  Loop
    v_tagfieldvalue:=vc.fvalue;
  End loop;
  v_sql:=REPLACE(p_tagLIST,'<$TAGFIELD>',v_tagfieldvalue);
  v_sql:='Select EN_DISPLAY From ('||v_sql||') where VALUE='''||p_value||'''';
--  dbms_output.put_line('fn_get_TAGLIST_value: v_sql = '||v_sql);
  l_return:=fn_getvalFromSQL(v_sql,'EN_DISPLAY') ;
--  dbms_output.put_line('fn_get_TAGLIST_value: l_return = '||l_return);
  plog.setendsection (pkgctx, 'fn_get_TAGLIST_value');
  If l_return is null or length(l_return)=0 then
    return p_value;
  Else
    return l_return;
  End if;

Exception
  when others then
  --  dbms_output.put_line(' fn_get_lookup_value: Exception ');
    plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
   plog.setendsection (pkgctx, 'fn_get_TAGLIST_value');
  return p_value;

end;
PROCEDURE GETLISTUSERNAME(
    p_tlid in varchar2,
    p_listusername OUT varchar2
    )
IS
v_username_check VARCHAR2(20);
v_listcustodycd varchar2(5000);
v_length   NUMBER;
v_role VARCHAR2(10);
v_countvalid NUMBER;
v_countCustodycd NUMBER;
v_select_string    VARCHAR2(2000);
v_listcustodycd_check            VARCHAR2(2000);
csr                SYS_REFCURSOR;
l_sql_query varchar2(3000);
v_listUsername  VARCHAR2(2000);
v_custodycd            VARCHAR2(20);
BEGIN

    plog.setbeginsection(pkgctx, 'CHECLVALIDIMPORT');
    v_custodycd:= '';
    v_listUsername:=p_tlid;
    v_length:=0;
    Begin
    select custodycd,listcustodycd,role,to_number(length(listcustodycd))
        into v_custodycd,v_listcustodycd,v_role,v_length
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
         v_length:=0;
    End;
    select count(1) into v_countCustodycd from  (
            SELECT trim(regexp_substr(v_listcustodycd, '[^;]+', 1, LEVEL)) str
            FROM dual
            CONNECT BY regexp_substr(v_listcustodycd , '[^;]+', 1, LEVEL) IS NOT NULL
            )   ;


-- CHECK So TKLK
begin
        v_select_string   := 'select username,listcustodycd from userlogin where username <> '''|| p_tlid||''' and status=''A'' and length(listcustodycd)='|| v_length ||'';
        OPEN csr FOR v_select_string;
loop
FETCH  csr INTO  v_username_check,v_listcustodycd_check;
 exit when csr%notfound;
        --Check So TKLK
               select count(1) into v_countvalid from  (
            SELECT trim(regexp_substr(v_listcustodycd, '[^;]+', 1, LEVEL)) str
            FROM dual
            CONNECT BY regexp_substr(v_listcustodycd , '[^;]+', 1, LEVEL) IS NOT NULL
            union
            SELECT trim(regexp_substr(v_listcustodycd_check, '[^;]+', 1, LEVEL)) str
            FROM dual
            CONNECT BY regexp_substr(v_listcustodycd_check , '[^;]+', 1, LEVEL) IS NOT NULL
            )   ;
         IF v_countvalid = v_countCustodycd then
              v_listUsername:= v_listUsername || ',' || v_username_check;

         END IF;
    END LOOP;
    end;
    p_listusername:=v_listUsername;
     

    return;
    plog.setendsection(pkgctx, 'GETLISTUSERNAME');
exception
when others then
    rollback;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'GETLISTUSERNAME');
RETURN;
END GETLISTUSERNAME;
PROCEDURE PRC_GET_STOCKS_NEW(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_SYMBOL       in varchar2,
                     p_err_code      IN OUT VARCHAR2,
                     p_err_param     IN OUT VARCHAR2) AS
  l_CFICODE varchar2(20);
  v_param  varchar2(4000);
  BEGIN

    plog.setBeginSection(pkgctx, 'PRC_GET_STOCKS_NEW');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

     --plog.setBeginSection(pkgctx, 'PRC_GET_STOCKS');
     v_param:='PRC_GET_STOCKS_NEW P_SYMBOL= '||P_SYMBOL
                             ;

   OPEN p_refcursor FOR
        select * from(
            select l.* ,  a.en_cdcontent cficode from (
                SELECT s.symbol CDVAL,s.symbol EN_CDCONTENT,s.symbol CDCONTENT,s.symbol||' - '||i.fullname CDCONTENTFULLNAME,
                    s.symbol||' - '||i.en_fullname EN_CDCONTENTFULLNAME,'M' pricetypeval,'Market' pricetype,' ' unitpriceval,
                    ' ' unitprice,s.isincode,s.sectype ,
                       CASE WHEN s.sectype ='006' AND s.bondtype = '005' THEN 'DB'
                                WHEN s.sectype ='006' AND s.bondtype = '001' THEN 'GB'
                                WHEN s.sectype ='006' AND s.bondtype = '002' THEN 'MB'
                                WHEN s.sectype ='006' AND s.bondtype = '003' THEN 'GO'
                                WHEN s.sectype ='006' AND s.bondtype = '004' THEN 'DC'
                                WHEN s.sectype ='015' AND s.coveredwarranttype ='C' THEN 'CC'
                                WHEN s.sectype ='015' AND s.coveredwarranttype ='P' THEN 'CP'
                                WHEN s.sectype ='001' THEN 'ES'
                                WHEN s.sectype ='002' THEN 'EP'
                                WHEN s.sectype ='008' THEN 'EF'
                                WHEN s.sectype ='009' THEN 'TD'
                                WHEN s.sectype ='011' THEN 'CW'
                                WHEN s.sectype ='012' THEN 'BB'
                                WHEN s.sectype ='013' THEN 'CD'
                                ELSE 'ES' END cficodeval,
                        CASE WHEN s.tradeplace ='001' THEN 'HSX' WHEN s.tradeplace ='002' THEN 'HNX'
                                WHEN s.tradeplace ='003' THEN 'OTC' WHEN s.tradeplace ='005' THEN 'UPCOM'
                                WHEN s.tradeplace ='006' THEN 'WFT' WHEN s.tradeplace ='010' THEN 'GBX' ELSE 'HNX' END exchange

                     FROM sbsecurities s,issuers i,sbcurrency sb
                      WHERE s.issuerid = i.issuerid and s.status='Y' and s.ccycd = sb.ccycd) l,allcode a
                       where a.cdname = 'CFICODE' and a.cdtype = 'SB' and a.cdval = l.cficodeval
                        union all
                          select 'Currency' || c.shortcd CDVAL,c.shortcd EN_CDCONTENT,c.shortcd CDCONTENT,c.shortcd||' - '||c.ccyname CDCONTENTFULLNAME,c.shortcd||' - '||c.ccyname EN_CDCONTENTFULLNAME,
                            'C' pricetypeval,'Currency' pricetype,'VND' unitpriceval,'VND' unitprice,' ' isincode,' ' sectype,' ' cficodeval,' ' exchange,' ' cficode
                            from sbcurrency c
                            where c.active='Y' and shortcd in('VND','USD')
                            ) k where k.cdval=P_SYMBOL;


    plog.setEndSection(pkgctx, 'PRC_GET_STOCKS_NEW');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_STOCKS_NEW');
  END PRC_GET_STOCKS_NEW;

  procedure pr_auto_1721_web(
        p_custodycd varchar2,
        p_tranacctno varchar2,
        p_receacctno varchar2,
        p_amount number,
        p_valuedate      varchar2,
        p_description  varchar2,
        p_tlid           varchar2,
        p_reftransid     out varchar2,
        p_err_code       in out varchar2,
        p_err_msg        in out varchar2
     ) is
        l_txmsg          tx.msg_rectype;
        v_strcurrdate    varchar2(20);
        v_tlid           varchar2(5);
        v_xmlmsg_string  varchar2(5000);
        v_txdesc         varchar2(500);
        V_CUSTODYCD     VARCHAR2(20);
        V_LISTCUSTODYCD VARCHAR2(4000);
        v_codeid        VARCHAR2(20);
        v_err_code varchar2(20);
        l_cr_ccycd    VARCHAR2(100);
        l_dr_ccycd    VARCHAR2(100);
    BEGIN
        plog.setbeginsection (pkgctx, 'pr_auto_1721_web');
        p_err_code := errnums.c_system_error;
        --begin them check ma loi -150010
        SELECT ccycd INTO l_cr_ccycd FROM ddmast WHERE acctno = p_receacctno;
        SELECT ccycd INTO l_dr_ccycd FROM ddmast WHERE acctno = p_tranacctno;
        IF NOT ((l_cr_ccycd = 'VND' OR l_dr_ccycd = 'VND')
                AND (l_cr_ccycd <> 'VND' OR l_dr_ccycd <> 'VND')) THEN

            plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' ||dbms_utility.format_error_backtrace);
            plog.setendsection(pkgctx, 'pr_auto_1721_web');
            p_err_code := '-150010';
            return;
        END IF;
        --end them check ma loi -150010
        BEGIN
            SELECT CUSTODYCD,LISTCUSTODYCD
            INTO V_CUSTODYCD,V_LISTCUSTODYCD
            FROM USERLOGIN
            WHERE USERNAME = P_TLID;
        EXCEPTION
            WHEN OTHERS THEN
                 V_CUSTODYCD := '';
                 V_LISTCUSTODYCD:='';
        END;

        select to_date (varvalue, systemnums.c_date_format)
        into v_strcurrdate
        from sysvar
        where grname = 'SYSTEM' and varname = 'CURRDATE';

        SELECT EN_TXDESC into v_txdesc FROM TLTX WHERE TLTXCD = '1721';

        select sys_context ('USERENV', 'HOST'), sys_context ('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        l_txmsg.brid        := '0001';
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        :='6868';
        ------------------------
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txlogged;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
        l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
        l_txmsg.tltxcd      := '1721';
        l_txmsg.nosubmit    := '1';
        l_txmsg.ovrrqd      := '@0';

        --------------------------SET CAC FIELD GIAO DICH-------------------------------
        ----SET TXNUM
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
            when no_data_found then
                 l_txmsg.txnum:= null;
        end;

        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

        for rec in
        (
            SELECT P_CUSTODYCD CUSTODYCD, P_TRANACCTNO TRANACCTNO, P_RECEACCTNO RECEACCTNO, P_AMOUNT AMOUNT
            FROM DUAL
        )
        loop
            --04    TRANACCTNO
                 l_txmsg.txfields ('04').defname   := 'TRANACCTNO';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.TRANACCTNO;
            --04    RECEACCTNO
                 l_txmsg.txfields ('06').defname   := 'RECEACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.RECEACCTNO;
            --10    AMOUNT
                 l_txmsg.txfields ('10').defname   := 'AMOUNT';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.AMOUNT;
            --30    DESC
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := p_description;
            --88    CUSTODYCD
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;

            v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
            if txpks_#1721.fn_txProcess(v_xmlmsg_string, v_err_code, p_err_msg) <> systemnums.c_success then
                 plog.error(pkgctx,' run 1721 got ' || v_err_code || ':' || p_err_msg);
                 rollback;
                 plog.setendsection(pkgctx, 'pr_auto_1721_web');
                 return;
            end if;

            PR_LOG_USERNAME(l_txmsg, p_tlid, 'C');
            p_err_code := systemnums.C_SUCCESS;
            fopks_sa.pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end loop;
        plog.setendsection(pkgctx, 'pr_auto_1721_web');

    exception
        when others then
            plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' ||dbms_utility.format_error_backtrace);
            plog.setendsection(pkgctx, 'pr_auto_1721_web');
            p_err_code := errnums.c_system_error;
    end;

begin
  -- Initialization
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('FOPKS_TX',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));

end FOPKS_TX;
/
