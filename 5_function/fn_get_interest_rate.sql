SET DEFINE OFF;
CREATE OR REPLACE function fn_get_interest_rate(P_CRPHYSAGREEID VARCHAR2, P_EFFDATE VARCHAR2)
return number
is
v_effdatemain DATE; --Ngay ky hop dong
v_effdate  DATE;  --Ngay ky phu luc
v_minperiod number; --thoi gian nam giu toi thieu
v_commitperiod number;  --thoi gian cam ket nam giu
v_intpremature number;  --laai truoc han
v_intcoupon number; --lai den han
v_crphysagreeid varchar2(20);
begin
  v_effdate := TO_DATE( p_effdate,systemnums.C_DATE_FORMAT);
  v_CRPHYSAGREEID := p_crphysagreeid;

  SELECT CR.EFFDATE, SB.MINPERIOD, SB.COMMITPERIOD, SB.INTPREMATURE, SB.INTCOUPON
  INTO v_effdatemain, v_minperiod, v_commitperiod, v_intpremature, v_intcoupon
  from CRPHYSAGREE CR, SBSECURITIES SB
  WHERE CR.CODEID=SB.CODEID
  and cr.crphysagreeid = v_crphysagreeid;

  if v_effdate < (v_effdatemain + nvl(v_minperiod,0)) then
     return 0;
  elsif v_effdate < (v_effdatemain + nvl(v_commitperiod,0)) then
     return v_intpremature;
  elsif v_effdate >= (v_effdatemain + nvl(v_commitperiod,0)) then
     return v_intcoupon;
  end if;

EXCEPTION
    WHEN OTHERS THEN
        return 0;
end;
/
