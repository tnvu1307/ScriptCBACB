SET DEFINE OFF;
CREATE OR REPLACE PACKAGE gwpkg_sendsms
IS
    FUNCTION fnc_sendsms (pin_phonenumber   IN     VARCHAR2,
                          pin_message       IN     VARCHAR2)
        RETURN CHAR;
    ----------------------- Main Procedure/Function ----------------------------
    PROCEDURE job_sendsms;
END;                                                           -- Package spec
 
 
/


CREATE OR REPLACE PACKAGE BODY gwpkg_sendsms
IS
    FUNCTION fnc_sendsms (pin_phonenumber   IN VARCHAR2,
                          pin_message       IN VARCHAR2)
        RETURN CHAR
    IS
        tmpmessage   VARCHAR2 (100);
        tmp char(1);
    BEGIN
        --DBMS_OUTPUT.put_line (pin_phonenumber);

        --tmp := fnc_phs_sendsms@remotesmsdb(pin_phonenumber,pin_message,tmpmessage);
        pr_error('cresult: ', tmp);
        pr_error('cresult: ', tmpmessage);
        --tmp := 'S';
        RETURN tmp;
    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.put_line ('LOI:' || SQLERRM);
            ROLLBACK;
            RETURN 'E';
    END;                                           -- END FUNCTION fnc_sendsms

    ----------------------- Main Procedure/Function ----------------------------
    PROCEDURE job_sendsms
    IS
        cresult   CHAR;
    BEGIN
        FOR rec
        IN (SELECT   el.autoid,
                     TRIM(el.email) email,
                     TRIM(el.email) emailsend,
                     el.datasource,
                     ts.subject,
                     el.status
              FROM   templates ts, emaillog el
             WHERE       ts.code = el.templateid
                     AND el.status = 'A'
                     AND ts.TYPE = 'S'
                     AND TS.isactive ='Y' -- Chi gui nhung mau active
                     AND TRIM(el.email) IS NOT NULL)
        LOOP
            BEGIN
                if length(rec.emailsend) < 10 or (length(rec.emailsend)=10 and rec.emailsend like '84%') then
                    UPDATE   emaillog
                       SET   status = 'R', note = 'Invalid format mobile number'
                     WHERE       autoid = rec.autoid
                             AND email = rec.email
                             AND status = 'A';
                else
                    cresult := fnc_sendsms (rec.emailsend, rec.datasource);
                    pr_error('cresult: ', cresult);

                    UPDATE   emaillog
                       SET   status = cresult,
                             senttime = sysdate
                     WHERE       autoid = rec.autoid
                             AND email = rec.email
                             AND status = 'A';
                end if;
            EXCEPTION
                WHEN OTHERS
                THEN
                    DBMS_OUTPUT.put_line ('LOI:' || SQLERRM);

                    UPDATE   emaillog
                       SET   status = 'E', senttime = SYSDATE
                     WHERE       autoid = rec.autoid
                             AND email = rec.email
                             AND status = 'A';
            END;

            COMMIT;
        END LOOP;
    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.put_line ('LOI:' || SQLERRM);
            pr_error('cresult: ', dbms_utility.format_error_backtrace);
    END;
END;
/
