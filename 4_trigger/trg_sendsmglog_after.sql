SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_SENDSMGLOG_AFTER 
 AFTER
 INSERT
 ON SENDMSGLOG
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
declare
  l_datasource   varchar2(4000);
  l_custody_code cfmast.custodycd%type;
  l_fullname     cfmast.fullname%type;
  l_callday      VARCHAR2(100);
  l_numberContract VARCHAR2(100);
  l_opendate     VARCHAR2(100);
  /*
  l_acctno       afmast.acctno%type;
  l_rlsdate      lnmast.rlsdate%type;
  l_SECAMOUNT    V_GETGRPDEALFORMULAR.TADF%type;
  l_LOANAMT    V_GETGRPDEALFORMULAR.DDF%type;
  l_CURRLNRATE   V_GETGRPDEALFORMULAR.RTTDF%type;
  l_LNRATE       DFGROUP.MRATE%type;
  l_ADDAMOUNT    V_GETGRPDEALFORMULAR.ODSELLDF%type;
  l_LOANTYPE     varchar2(10);
  */
  -- Private variable declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
begin
  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('TRG_SENDSMGLOG_AFTER',
                      plevel                => nvl(logrow.loglevel, 30),
                      plogtable             => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert                => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace                => (nvl(logrow.log4trace, 'N') = 'Y'));

  plog.setBeginSection(pkgctx, 'TRG_SENDSMGLOG_AFTER');
  if :new.searchcode = 'DD0003' and :new.sendvia = 'E' then
    nmpks_ems.pr_sendInternalEmail(p_datasource => :NEW.MSGBODY, p_template_id => 'EM10');
  end IF;

  plog.setEndSection(pkgctx, 'TRG_SENDSMGLOG_AFTER');
exception
  when others then
    plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'TRG_SENDSMGLOG_AFTER');
end TRG_SENDSMGLOG_AFTER;
/
