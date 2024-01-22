SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE insertccemail
    (      --p_autoid number,
           --p_email varchar2,
           p_templateid varchar2,
           p_messagetype varchar2,
           p_datasource varchar2,
           --p_status VARCHAR2,
           --p_createtime date,
           --p_SENTTIME date,
           p_afacctno varchar2,
           p_NOTE varchar2,
           p_typesms varchar2,
           p_language_type varchar2
    )
IS
    l_emailbroker varchar2(50);
    l_smsbroker   varchar2(50);
    l_brokercustid  varchar2(50);
    l_templateid    varchar2(10);
    l_usercustid    varchar2(10);
    l_brokerafacctno varchar2(10);

    l_countstt NUMBER;
    l_status varchar2(5);
BEGIN
    l_templateid := p_templateid;
    --pr_error('secmast_CV', 'error:' || p_afacctno);
    SELECT count(cf.status)
    INTO l_countstt
    FROM cfmast cf, afmast af
    WHERE cf.custid = af.custid
    AND af.acctno = p_afacctno;
    l_status:='A';
    IF l_countstt > 0 THEN

        --IF l_templateid IN ('114E','106E','106S', '108E', '105E','107E') THEN
            SELECT custid INTO l_usercustid FROM afmast WHERE acctno = p_afacctno;
           -- pr_error('secmast_CV', 'l_usercustid:' || l_usercustid);

            BEGIN
                select substr(reacctno,1,10) INTO l_brokercustid
                from reaflnk ra, recflnk rc
                where ra.refrecflnkid = rc.autoid
                    and ra.afacctno = l_usercustid
                    and ra.status = 'A' and rc.status = 'A'
                    and rownum <=1;

                EXCEPTION
                WHEN OTHERS THEN
                    l_brokercustid := '';
            END;
           -- pr_error('secmast_CV', 'l_brokercustid:' || l_brokercustid);
            IF LENGTH(l_brokercustid) > 0 THEN
                --pr_error('secmast_CV', 'vao check:' || l_brokercustid);
                BEGIN
                    SELECT f.mobilesms, f.emailbr, --f.email,
                     max(nvl(af.acctno,'')) acctno
                        INTO l_smsbroker, l_emailbroker, l_brokerafacctno
                    FROM vw_cfmast_sms f, afmast af
                    WHERE f.custid = l_brokercustid
                          AND f.custid = af.custid (+)
                    group BY f.mobilesms, f.emailbr; --f.email;
                    --pr_error('secmast_CV', 'error:' || l_smsbroker);
                    --pr_error('secmast_CV', 'error:' || l_emailbroker);
                END;
                IF p_messagetype = 'S' AND length(l_smsbroker) > 0 THEN

                    --pr_error('secmast_CV', 'error:' || l_smsbroker);
                    insert into emaillog (AUTOID, EMAIL, TEMPLATEID, DATASOURCE, STATUS, CREATETIME, SENTTIME, AFACCTNO, NOTE, TYPESMS, CREATETYPE,TXDATE,language_type)
                    values (seq_emaillog.nextval, l_smsbroker, p_templateid, p_datasource, l_status, sysdate, null, p_afacctno, p_NOTE, p_typesms,'C',getcurrdate,p_language_type);

                ELSIF p_messagetype = 'E' AND length(l_emailbroker) > 0 THEN

                    insert into emaillog (AUTOID, EMAIL, TEMPLATEID, DATASOURCE, STATUS, CREATETIME, SENTTIME, AFACCTNO, NOTE, TYPESMS, CREATETYPE,TXDATE,language_type)
                    values (seq_emaillog.nextval, l_emailbroker, p_templateid, p_datasource, l_status, sysdate, null, p_afacctno, p_NOTE, p_typesms,'C',getcurrdate,p_language_type);


                END IF;
            --ELSE
            --
            --     RETURN;
            --END IF;
        END IF;
    END IF;
EXCEPTION
   WHEN OTHERS THEN

            pr_error('Insertccemail', 'error:' || SQLERRM || to_char(dbms_utility.format_error_backtrace));
            ---raise;
END;
 
 
/
