SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_update_mobile(
  pv_strFrom IN VARCHAR2, pv_strTo IN VARCHAR2)
  RETURN VARCHAR2 IS
  v_Result varchar2(2);
  l_currdate    date;
  l_lengthFrom  NUMBER;
  l_autoid      number;
BEGIN

    v_Result := '0';

    l_currdate := getcurrdate();
    l_lengthFrom := length(trim(pv_strFrom));

    for rec in (
            select  cf.custid, cf.custodycd,
                cf.mobile mobile_old,
                (case when cf.mobile is not null and LENGTH(trim(cf.mobile)) >= 11
                            and SUBSTR(trim(replace(replace(replace(replace(cf.mobile,' '),'.'),'+'),'84','0')),0,l_lengthFrom) = trim(pv_strFrom)
                    then pv_strTo || SUBSTR(trim(replace(replace(replace(replace(cf.mobile,' '),'.'),'+'),'84','0')),l_lengthFrom+1)
                    else cf.mobile end ) mobile_new,
                cf.mobilesms mobilesms_old,
                (case when cf.mobilesms is not null and LENGTH(trim(cf.mobilesms)) >= 11
                            and SUBSTR(trim(replace(replace(replace(replace(cf.mobilesms,' '),'.'),'+'),'84','0')),0,l_lengthFrom) = trim(pv_strFrom)
                    then pv_strTo || SUBSTR(trim(replace(replace(replace(replace(cf.mobilesms,' '),'.'),'+'),'84','0')),l_lengthFrom+1)
                    else cf.mobilesms end ) mobilesms_new
            from cfmast cf
            where  (cf.mobile is not null and LENGTH(trim(cf.mobile)) >= 11
                    and SUBSTR(trim(replace(replace(replace(replace(cf.mobile,' '),'.'),'+'),'84','0')),0,l_lengthFrom) = trim(pv_strFrom)
                    ) or (
                        cf.mobilesms is not null and LENGTH(trim(cf.mobilesms)) >= 11
                        and SUBSTR(trim(replace(replace(replace(replace(cf.mobilesms,' '),'.'),'+'),'84','0')),0,l_lengthFrom) = trim(pv_strFrom)
                    )
        ) loop
            l_autoid := seq_mobilechange_log.nextval;
            insert into mobilechange_log(autoid, txdate, fromNum, toNum, custid, custodycd, mobile_old, mobile_new, mobilesms_old, mobilesms_new)
            values( l_autoid, l_currdate, pv_strFrom, pv_strTo, rec.custid, rec.custodycd, rec.mobile_old, rec.mobile_new,
                rec.mobilesms_old, rec.mobilesms_new);

            update cfmast
            set mobile = rec.mobile_new,
                mobilesms = rec.mobilesms_new
            where custid = rec.custid;
        end loop;

    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN

            plog.error ('fn_update_mobile.error:'|| SQLERRM  || dbms_utility.format_error_backtrace);

            return '-1';
        END;
/
