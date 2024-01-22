SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_send_email (
  functionname in VARCHAR2,
  errordesc in varchar2
) IS
    v_localemailist  VARCHAR2(1000);
    v_outeremailist  VARCHAR2(1000);
    efid_SEQ  varchar2(1000);
    v_content   varchar2(1000);
    v_strBody   clob;
    seq_email number;
    v_receivername varchar2(500);
    v_sql           varchar2(4000);
    v_return_code   varchar2(100);
    v_return_msg    varchar2(500);
    v_err_code      varchar2(100);
     v_SUBJECT      varchar2(100);
BEGIN
    v_localemailist        :='a@b.com;';
    v_outeremailist:='';
    v_receivername:='IT Team';

    v_content         := 'select '''||functionname||' '||errordesc ||''' l_content from dual';
    seq_email       := seq_emaillog.NEXTVAL;
    v_SUBJECT:='AUTO NOTIFICATION: Fiin alert error !';
    v_strBody:='<h4>Dear '||v_receivername||' !</h4><p>FIIN got error'||functionname||':'||errordesc ||'</p>';


    INSERT INTO emaillog (autoid,email,datasource,status,createtime,templateid,note, refid)
        VALUES(seq_email,v_localemailist,v_content,'A',systimestamp,'999E','', efid_SEQ);

    for rec in(
            select REGEXP_SUBSTR(v_outeremailist,'[^;]+',1,LEVEL) email
                from dual connect by REGEXP_SUBSTR(v_outeremailist,'[^;]+',1,level) is not null)
    loop
        efid_SEQ           := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');
        insert into EMAILOG_OUT(seq , receivername ,  receivermail ,    subject ,  strBody)
        values(efid_SEQ, v_receivername, rec.email, v_SUBJECT, v_strBody);
        v_sql :='BEGIN SP_NVSCHEDULEACCEPT_API_GEN@REPAY_MAIL(:v_SEQ, :v_RECEIVER_NM, :v_RECEIVER,:v_SUBJECT, :v_JONMUN, :V_FILE_PATH1, :v_RTN_CD, :v_RTN_MSG, :v_ER_CD); END;';
        EXECUTE IMMEDIATE v_sql  USING efid_SEQ, v_receivername, rec.email, v_SUBJECT, v_strBody, '', out v_return_code, out v_return_msg, out v_err_code;
        update EMAILOG_OUT set return_code=v_return_code, return_msg= v_return_msg, err_code= v_err_code where seq=efid_SEQ;
    end loop;
commit;
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
      RAISE ERRNUMS.E_SYSTEM_ERROR;
END;
/
