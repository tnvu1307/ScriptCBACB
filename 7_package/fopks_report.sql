SET DEFINE OFF;
CREATE OR REPLACE PACKAGE fopks_report IS

  PROCEDURE pr_autoExecRptAuto;
  PROCEDURE pr_autoExecRptAuto (p_cycle    IN VARCHAR2);
  PROCEDURE CREATE_REPORT_REQ (PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                              pv_rptid IN VARCHAR2,
                              pv_str_rptparams IN VARCHAR2);

  PROCEDURE PRC_CREATE_RPT_REQUEST(p_reqid     IN VARCHAR2,
                                 p_rptid     in varchar2,
                                 p_rptparam  IN VARCHAR2,
                                 p_exptype   IN VARCHAR2,
                                 p_tlid      in VARCHAR2,
                                 p_isauto      in VARCHAR2  DEFAULT NULL,
                                 p_exportPath IN VARCHAR2 DEFAULT NULL,
                                 p_err_code  in out varchar2,
                                 p_err_param in out VARCHAR2);
 PROCEDURE PRC_CREATE_RPT_REQUEST_ONLINE(p_reqid     IN VARCHAR2,
                                 p_rptid     in varchar2,
                                 p_rptparam  IN VARCHAR2,
                                 p_exptype   IN VARCHAR2,
                                 p_tlid      in VARCHAR2,
                                 p_isauto      in VARCHAR2  DEFAULT NULL,
                                 p_exportPath IN VARCHAR2 DEFAULT NULL,
                                 p_err_code  in out varchar2,
                                 p_err_param in out VARCHAR2);
  PROCEDURE PRC_GET_RPT_REQUEST(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                   p_autoid        IN VARCHAR2,
                   p_type          IN VARCHAR2,  --A: Auto, M: Manual
                   p_codeid        IN VARCHAR2,
                   p_tradingdate   IN VARCHAR2,  --Ngay giao dich dd/mm/yyyy
                   p_rptid         IN VARCHAR2,  --Ma bao cao
                   p_tlid          in varchar2,
                   p_role          in varchar2,
                   p_Reflogid in varchar2,
                   p_err_code      in out varchar2,
                   p_err_param     in out varchar2);
PROCEDURE PRC_GET_LLIST_DATA(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                   p_querry          in varchar2,
                   p_tlid          in varchar2,
                   p_role          in varchar2,
                   p_Reflogid in varchar2,
                   p_err_code      in out varchar2,
                   p_err_param     in out varchar2);

END FOPKS_REPORT;
/


CREATE OR REPLACE PACKAGE BODY fopks_report IS
  -- Private variable declarations

  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

  FUNCTION fn_buildReportParam (p_rptid    VARCHAR2,
                               p_frDate    VARCHAR2,
                               p_toDate    VARCHAR2) RETURN VARCHAR2
  IS
  --l_rptParam    VARCHAR2(2000) := '(:l_refcursor, OPT => ''A'', BRID => ''0001''';
  l_rptParam    VARCHAR2(2000) := '(:l_refcursor, ''A'', ''0001''';
  l_paramvalue  VARCHAR2(100);

  BEGIN
    FOR rec IN (
      SELECT r.fldname, r.defval
      FROM rptfields r
      WHERE objname = p_rptid
      AND isparam = 'Y'
      ORDER BY odrnum
    ) LOOP
      IF rec.fldname = 'F_DATE' THEN
        l_paramvalue := p_frDate;
      ELSIF rec.fldname = 'T_DATE' THEN
        l_paramvalue := p_toDate;
      ELSIF rec.defval = '<$BUSDATE>' THEN
        l_paramvalue := p_toDate;
      ELSE
        l_paramvalue := rec.defval;
      END IF;

      --l_rptParam := l_rptParam || ',' || rec.fldname || ' => ''' || l_paramvalue || '''';
      l_rptParam := l_rptParam || ',''' || l_paramvalue || '''';

    END LOOP;

    l_rptParam := l_rptParam || ')';
    RETURN l_rptParam;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN '';
  END;
  PROCEDURE pr_autoExecRptAuto
  IS
  BEGIN
    pr_autoExecRptAuto('D');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
  END;

  PROCEDURE pr_autoExecRptAuto (p_cycle    IN VARCHAR2)
  IS
  l_currDate   DATE;
  l_strCurrDate VARCHAR2(10);
  l_currTime   VARCHAR2(10);
  l_checkTime  DATE;
  l_rptParam   rptlogs.rptparam%TYPE;
  l_strFrdate  VARCHAR2(10);
  l_err_code   VARCHAR2(100);
  l_err_param  VARCHAR2(1000);
  l_exportPath VARCHAR2(100);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_autoExecRptAuto');
    l_currDate  := getcurrdate;
    l_strCurrDate := TO_CHAR(l_currDate, 'dd/mm/rrrr');
    l_currTime  := TO_CHAR(SYSDATE, 'hh24:mi:ss');
    l_checkTime := SYSDATE;

IF p_cycle = 'D' THEN
    FOR rec IN (
      SELECT cf.rptid, cf.filetype, cf.createtime
      FROM rptgencfg cf, rptmaster rpt
      WHERE cf.rptid NOT IN (SELECT r.rptid FROM RPTGENCFG_RUN_LOG r WHERE r.log_date = TO_DATE(SYSDATE))
      AND cf.rptid = rpt.rptid
      AND cf.cycle_cret = 'D' AND TO_DATE(NVL(cf.createtime,'00:00'), 'hh24:mi') <= l_checkTime
    ) LOOP

      IF rec.createtime > '15:00' THEN
        l_rptParam := fn_buildReportParam (rec.rptid, l_strCurrDate, l_strCurrDate);
      ELSE
        l_strFrdate := cspks_system.fn_get_sysvar('SYSTEM', 'PREVDATE');
        l_rptParam := fn_buildReportParam (rec.rptid, l_strFrdate, l_strFrdate);
      END IF;

      l_exportPath := TO_CHAR(getcurrdate, 'rrrrmmdd') || '/' || rec.rptid;

      PRC_CREATE_RPT_REQUEST(p_reqid     => '',
                           p_rptid     => rec.rptid,
                           p_rptparam  => l_rptParam,
                           p_exptype   => rec.filetype,
                           p_tlid      => '0000',
                           p_isauto    => 'Y',
                           p_exportPath => l_exportPath,
                           p_err_code  => l_err_code,
                           p_err_param => l_err_param);
      INSERT INTO RPTGENCFG_RUN_LOG(RPTID, LOG_DATE) VALUES (rec.rptid, TO_DATE(SYSDATE));
    END LOOP;
ELSIF p_cycle = 'M' THEN
  l_strFrdate := TO_CHAR(TRUNC(l_currDate, 'MM'), 'dd/mm/rrrr');

  FOR rec IN (
      SELECT cf.rptid, cf.filetype, cf.createtime
      FROM rptgencfg cf, rptmaster rpt
      WHERE cf.rptid NOT IN (SELECT r.rptid FROM RPTGENCFG_RUN_LOG r WHERE r.log_date = TO_DATE(SYSDATE))
      AND cf.rptid = rpt.rptid
      AND cf.cycle_cret = 'M'
    ) LOOP
      l_rptParam := fn_buildReportParam (rec.rptid, l_strFrdate, l_strCurrDate);
      l_exportPath := TO_CHAR(getcurrdate, 'rrrrmmdd') || '/' || rec.rptid;

      PRC_CREATE_RPT_REQUEST(p_reqid     => '',
                           p_rptid     => rec.rptid,
                           p_rptparam  => l_rptParam,
                           p_exptype   => rec.filetype,
                           p_tlid      => '0000',
                           p_isauto    => 'Y',
                           p_exportPath => l_exportPath,
                           p_err_code  => l_err_code,
                           p_err_param => l_err_param);
      INSERT INTO RPTGENCFG_RUN_LOG(RPTID, LOG_DATE) VALUES (rec.rptid, TO_DATE(SYSDATE));

    END LOOP;
END IF;
    plog.setEndSection(pkgctx, 'pr_autoExecRptAuto');

  EXCEPTION
    WHEN OTHERS THEN
      
      plog.setEndSection(pkgctx, 'pr_autoExecRptAuto');
  END;

  PROCEDURE CREATE_REPORT_REQ (
        PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
        pv_rptid IN VARCHAR2,
        pv_str_rptparams IN VARCHAR2
  )
  IS
    l_sql VARCHAR2(4000);
  BEGIN
        plog.setbeginsection (pkgctx, 'CREATE_REPORT_REQ');
        --goi thu tuc lay du lieu bao cao
        l_sql :='BEGIN ' || pv_rptid || pv_str_rptparams || '; END;';
        EXECUTE IMMEDIATE l_sql USING IN OUT PV_REFCURSOR;
        plog.setendsection (pkgctx, 'CREATE_REPORT_REQ');
  EXCEPTION
    WHEN OTHERS THEN
       plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'CREATE_REPORT_REQ');
  END;

  PROCEDURE PRC_CREATE_RPT_REQUEST(
                           p_reqid     IN VARCHAR2,
                           p_rptid     in varchar2,
                           p_rptparam  IN VARCHAR2,
                           p_exptype   IN VARCHAR2,
                           p_tlid      in VARCHAR2,
                           p_isauto    in VARCHAR2 DEFAULT NULL,
                           p_exportPath IN VARCHAR2 DEFAULT NULL,
                           p_err_code  in out varchar2,
                           p_err_param in out VARCHAR2)
  IS
    l_rptlogs     varchar2(100);
    l_export_path VARCHAR2(1000);
  BEGIN

    plog.setBeginSection(pkgctx, 'PRC_CREATE_RPT_REQUEST');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    l_rptlogs := seq_rptlogs.NEXTVAL;
    IF p_exportPath IS NULL OR length(l_export_path) = 0 THEN
      l_export_path := 'C:\SmartMassEmail\Reports\' || TO_CHAR(getcurrdate,'yyyymmdd') || '\' || l_rptlogs;
    ELSE
      l_export_path := 'C:\SmartMassEmail\Reports\' || p_exportPath;
    END IF;


    INSERT INTO  rptlogs(autoid,reqid,rptid,rptparam,status,subuserid,exportpath,priority,txdate,exptype,refemaillog,isauto)
    VALUES(l_rptlogs,p_reqid,p_rptid,p_rptparam,'P',p_tlid,l_export_path,'Y',getcurrdate,p_exptype,NULL,p_isauto);

    plog.setEndSection(pkgctx, 'PRC_CREATE_RPT_REQUEST');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, 'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'PRC_CREATE_RPT_REQUEST');
  END;
 PROCEDURE PRC_CREATE_RPT_REQUEST_ONLINE(
                           p_reqid     IN VARCHAR2,
                           p_rptid     in varchar2,
                           p_rptparam  IN VARCHAR2,
                           p_exptype   IN VARCHAR2,
                           p_tlid      in VARCHAR2,
                           p_isauto    in VARCHAR2 DEFAULT NULL,
                           p_exportPath IN VARCHAR2 DEFAULT NULL,
                           p_err_code  in out varchar2,
                           p_err_param in out VARCHAR2)
  IS
    l_rptlogs     varchar2(100);
    l_export_path VARCHAR2(1000);
  BEGIN

    plog.setBeginSection(pkgctx, 'PRC_CREATE_RPT_REQUEST_ONLINE');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    l_rptlogs := seq_rptlogs.NEXTVAL;



    INSERT INTO  rptlogs(autoid,reqid,rptid,rptparam,status,subuserid,exportpath,priority,txdate,exptype,refemaillog,isauto)
    VALUES(l_rptlogs,p_reqid,p_rptid,p_rptparam,'P',p_tlid,l_export_path,'Y',getcurrdate,p_exptype,NULL,p_isauto);

    plog.setEndSection(pkgctx, 'PRC_CREATE_RPT_REQUEST_ONLINE');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, 'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'PRC_CREATE_RPT_REQUEST_ONLINE');
  END;
PROCEDURE PRC_GET_RPT_REQUEST(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                   p_autoid        IN VARCHAR2,
                   p_type          IN VARCHAR2,  --A: Auto, M: Manual
                   p_codeid        IN VARCHAR2,
                   p_tradingdate   IN VARCHAR2,  --Ngay giao dich dd/mm/yyyy
                   p_rptid         IN VARCHAR2,  --Ma bao cao
                   p_tlid          in varchar2,
                   p_role          in varchar2,
                   p_Reflogid in varchar2,
                   p_err_code      in out varchar2,
                   p_err_param     in out varchar2)
IS
  l_count NUMBER;
  L_mbid VARCHAR2(100);
  v_param VARCHAR2(500);
  l_rptid varchar(10);

BEGIN
  plog.setBeginSection(pkgctx, 'PRC_GET_RPT_REQUEST');
  p_err_code  := systemnums.C_SUCCESS;
  p_err_param := 'SUCCESS';
  v_param := 'PRC_GET_RPT_REQUEST()' || 'p_autoid:' || p_autoid
                                     || 'p_type:' || p_type
                                     || 'p_codeid:' || p_codeid
                                     || 'p_tradingdate:' || p_tradingdate
                                     || ';p_rptid=' || p_rptid
                                     || 'p_tlid:' || p_tlid
                                     || 'p_codeid:' || p_codeid
                                     || ';p_role=' ||p_role
                                     || ';p_reflogid=' || p_reflogid;
  


 IF p_rptid IS NULL OR length(p_rptid) = 0 THEN
        l_rptid:='%';
     else
        l_rptid:=p_rptid;
     end if;

  IF p_autoid IS NULL OR p_autoid='' THEN

  OPEN P_REFCURSOR FOR
 SELECT RM.DESCRIPTION,RL.AUTOID,RL.REQID,RL.RPTID,RL.RPTPARAM,RL.STATUS STATUSVAL,RL.SUBUSERID TLID
      ,RL.REFRPTFILE,TO_CHAR(RL.CRTDATETIME, 'DD/MM/YYYY HH24:MI:SS') CRTDATETIME,RL.NOTE , RL.TXDATE, 'N' ISCA, NVL(RL.ISSIGNOFF,'N') ISSIGNOFF,
     '' TRADINGID,
      ' ' SYMBOL,
      getcurrdate() TRADINGDATE,TO_CHAR(RL.CRTDATETIME, 'YYYYMMDD HH24:MI:SS') ORDERBY_DATETIME,
      NVL(RL.DELTD,'N') DELTD,RM.RPTID||' - ' || RM.DESCRIPTION REPORTNAME,RM.RPTID||' - ' || RM.en_DESCRIPTION REPORTNAME_EN,a1.cdcontent status,a1.en_cdcontent status_en
      FROM RPTLOGS RL,
      RPTMASTER RM,allcode a1
      WHERE RM.RPTID = RL.RPTID AND RL.status = a1.cdval
       AND a1.cdtype ='CB' AND a1.cdname='RPTSTATUS'
       and RL.SUBUSERID=P_TLID
       AND RL.RPTID LIKE l_rptid
         ORDER BY tO_CHAR(RL.CRTDATETIME, 'YYYYMMDD HH24:MI:SS') DESC;
ELSE
  OPEN P_REFCURSOR FOR
 SELECT RM.DESCRIPTION,RL.AUTOID,RL.REQID,RL.RPTID,RL.RPTPARAM,RL.STATUS STATUSVAL,RL.SUBUSERID TLID
      ,RL.REFRPTFILE,TO_CHAR(RL.CRTDATETIME, 'DD/MM/YYYY HH24:MI:SS') CRTDATETIME,RL.NOTE , RL.TXDATE, 'N' ISCA, NVL(RL.ISSIGNOFF,'N') ISSIGNOFF,
     '' TRADINGID,
      ' ' SYMBOL,
      getcurrdate() TRADINGDATE,TO_CHAR(RL.CRTDATETIME, 'YYYYMMDD HH24:MI:SS') ORDERBY_DATETIME,
      NVL(RL.DELTD,'N') DELTD,RM.RPTID||' - ' || RM.DESCRIPTION REPORTNAME,a1.en_cdcontent status
      FROM RPTLOGS RL,
      RPTMASTER RM,allcode a1
      WHERE RM.RPTID = RL.RPTID AND RL.status = a1.cdval
       AND a1.cdtype ='CB' AND a1.cdname='RPTSTATUS'
       and RL.SUBUSERID=P_TLID
       AND RL.AUTOID=p_autoid;


  END IF;
  plog.setEndSection(pkgctx, 'PRC_GET_RPT_REQUEST');
exception
  when others then
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error(pkgctx,
               'Err: ' || sqlerrm || ' Trace: ' ||
               dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'PRC_GET_RPT_REQUEST');
END;
PROCEDURE PRC_GET_LLIST_DATA(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                   p_querry          in varchar2,
                   p_tlid          in varchar2,
                   p_role          in varchar2,
                   p_Reflogid in varchar2,
                   p_err_code      in out varchar2,
                   p_err_param     in out varchar2)
IS
  l_count NUMBER;
BEGIN
  plog.setBeginSection(pkgctx, 'PRC_GET_LLIST_DATA');
  p_err_code  := systemnums.C_SUCCESS;
  p_err_param := 'SUCCESS';
  Open p_refcursor FOR p_querry;

      --SELECT autoid,reqid,rptid,rptparam,status,subuserid tlid
      --,refrptfile,crtdatetime,note FROM rptlogs;

  plog.setEndSection(pkgctx, 'PRC_GET_LLIST_DATA');
exception
  when others then
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error(pkgctx,
               'Err: ' || sqlerrm || ' Trace: ' ||
               dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'PRC_GET_LLIST_DATA');
END;
begin
  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('FOPKS_REPORT',
                      plevel        => nvl(logrow.loglevel, 30),
                      plogtable     => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert        => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace        => (nvl(logrow.log4trace, 'N') = 'Y'));
end FOPKS_REPORT;
/
