SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getDepoFeeVal (pv_SecType varchar2 , pv_date date)
return NUMBER
is
v_value number;
begin
    if pv_SecType='TP' then --Trai phieu
        select feeamt / lotday into v_value from cifeedef where valdate = (select max(valdate) valdate from cifeedef where valdate <= pv_date) and rownum=1
        and DECODE(SECTYPE,'001','111','002','111','007','111','008','111','003','222','006','222','111','111','')  ='222';
    ELSE--Co phieu
        select feeamt / lotday into v_value from cifeedef where valdate = (select max(valdate) valdate from cifeedef where valdate <= pv_date) and rownum=1
        and DECODE(SECTYPE,'001','111','002','111','007','111','008','111','003','222','006','222','111','111','')  ='111';
    end if;
    return v_value;
exception when others then
    if pv_SecType='TP' then
        return 0.2/30;
    else
        return 0.4/30;
    end if;
end;
/
