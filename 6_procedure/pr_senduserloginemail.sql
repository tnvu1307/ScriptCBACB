SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_senduserloginemail(p_clause    in varchar2) IS
  l_username   VARCHAR2(1000);
  l_sql        VARCHAR2(1000);
  l_count      NUMBER;
  l_datasource VARCHAR2(1000);
  l_email      VARCHAR2(1000);
  l_url_reset  VARCHAR2(1000);
  l_key_reset  VARCHAR2(1000);
  v_timeout number;

BEGIN
  l_sql := 'select username from userlogin where ' || p_clause;
  EXECUTE IMMEDIATE l_sql INTO l_username;
  SELECT COUNT(1) INTO l_count FROM userlogin WHERE status = 'A' /*AND instr(pStatus, 'A') = 0*/ AND username = l_username;

  IF l_count = 1 THEN
    SELECT varvalue INTO l_url_reset FROM sysvar WHERE grname = 'FO' AND varname = 'URL_RESET_PASS';
    l_key_reset := genencryptpassword(to_char(SYSTIMESTAMP,'rrrrmmddhh24missFF'));
    l_url_reset := l_url_reset || l_key_reset;
    update reset_login_pass set STATUS = 'N' where USERNAME = l_username and STATUS= 'Y';
    INSERT INTO reset_login_pass(id, username, createdate, status)
    VALUES (l_key_reset, l_username, SYSDATE, 'Y');

    SELECT email INTO l_email FROM userlogin WHERE username = l_username AND status = 'A';
	select to_number(varvalue) into v_timeout from sysvar where varname='TIMEOUT_LINKACTIVE' and grname='FO';
    l_datasource := 'SELECT ''' || l_username || ''' username, ' ||
                     '''' || l_url_reset || ''' url_reset,''' ||  TO_CHAR(sysdate +(1/1440*v_timeout),'DD/MM/RRRR HH24:MI:SS') || ''' time from dual';
    nmpks_ems.InsertEmailLog(l_email,
                             '100E',
                             l_datasource,
                             l_username);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    plog.error('pr_SendUserLoginEmail::' || SQLERRM || dbms_utility.format_error_backtrace);
end pr_SendUserLoginEmail;
/
