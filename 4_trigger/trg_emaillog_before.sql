SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_EMAILLOG_BEFORE 
 BEFORE
  INSERT
 ON emaillog
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
    diff NUMBER(20,8);
    v_ISTEST VARCHAR2(10);
    v_strEmail VARCHAR2(2000);
    v_strSMS VARCHAR2(2000);
    v_strSendType   varchar2(5);
    v_count     number;
BEGIN
    pr_error('SMS','Before');

    -- Xu ly dac biet, tai SHV chi gui cho nhan vien cua SHV ko gui tr?c tiep KH.
    /*
    Select count(1) into v_count from tlprofiles where INSTR(upper(trim(:NEWVAL.email)), upper(email)) > 0;
    IF v_count =0  THEN
        :newval.status := 'R';
        return;
    END IF;
    */

    BEGIN
        SELECT VARVALUE INTO v_ISTEST FROM SYSVAR WHERE VARNAME LIKE 'ISTEST' AND GRNAME='SYSTEM';
    EXCEPTION WHEN OTHERS THEN
        v_ISTEST := 'N';
    END;

    -- Neu la moi truong test
    --> Email ngoai DS dang ky --> khong gui --> chuyen TT Reject luon.
    IF v_ISTEST ='Y' THEN
        BEGIN
            SELECT VARVALUE INTO v_strEmail FROM SYSVAR WHERE VARNAME LIKE 'EMAILTEST' AND GRNAME='SYSTEM';
            SELECT VARVALUE INTO v_strSMS FROM SYSVAR WHERE VARNAME LIKE 'SMSTEST' AND GRNAME='SYSTEM';
        EXCEPTION WHEN OTHERS THEN
            v_strEmail := '';
            v_strSMS := '';
        END;

        BEGIN
            SELECT t.type INTO v_strSendType FROM TEMPLATES t WHERE t.code = :NEWVAL.templateid;

        EXCEPTION WHEN OTHERS THEN
            v_strSendType := 'E';
        END;


        If instr(upper(v_strEmail), upper(trim(:NEWVAL.email))) = 0 and v_strSendType like 'E' then
            :NEWVAL.STATUS :='R';
            :NEWVAL.NOTE := 'Not found in Test email list';
        end if;

        If instr(upper(v_strSMS), upper(trim(:NEWVAL.email))) = 0 and v_strSendType like 'S' then
            :NEWVAL.STATUS :='R';
            :NEWVAL.NOTE := 'Not found in Test mobile list';
        end if;
    END IF;

    IF :NEWVAL.EMAIL is null THEN
        :newval.status := 'R';
        :NEWVAL.NOTE := 'Email/Mobile is null';
    END IF;
END;
/
