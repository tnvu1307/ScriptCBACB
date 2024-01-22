SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_re_icrate(strACCTNO IN varchar2, p_BASEDACR number, P_REVENUE NUMBER)
  RETURN  number
  IS
  l_COMMISION  number(20,4);
  l_BASEDACR  number(20,4);
  l_AUTOID    number(20,0);
  l_ACTYPE    VARCHAR2(4);
  l_RULETYPE  VARCHAR2(10);
  l_PERIOD    VARCHAR2(10);
  l_ICTYPE    VARCHAR2(10);
  l_DELTA    number(20,4);
  l_FLAT    number(20,4);
  l_ICRATE    number(20,4);
  l_MINVAL    number(20,4);
  l_MAXVAL    number(20,4);
  l_FLRATE    number(20,4);
  l_CERATE    number(20,4);
  v_baseacr number(20,4);
  v_revenue number(20,4);
  l_result number(20,4);
BEGIN
  l_result :=0;
  l_BASEDACR:=p_BASEDACR;
    --GET REMAST ATRIBUTES
    SELECT  TYP.ACTYPE,
    IC.AUTOID, IC.RULETYPE, IC.PERIOD, IC.ICTYPE, IC.ICFLAT, IC.ICRATE, IC.MINVAL, IC.MAXVAL, IC.FLRATE, IC.CERATE
    into  l_ACTYPE, l_AUTOID, l_RULETYPE, l_PERIOD, l_ICTYPE, l_FLAT, l_ICRATE, l_MINVAL, l_MAXVAL, l_FLRATE, l_CERATE
    FROM REMAST MST, RETYPE TYP, ICCFTYPEDEF IC
  WHERE MST.ACCTNO = strACCTNO AND MST.ACTYPE=TYP.ACTYPE
    AND IC.MODCODE='RE' AND IC.EVENTCODE='CALFEECOMM' AND IC.ICCFSTATUS='A' AND IC.ACTYPE=MST.ACTYPE;

  if l_RULETYPE='S' OR l_RULETYPE='F' then
            if l_ICTYPE='F' then
              l_result := l_FLAT;
            elsif l_ICTYPE='P' then
              l_result := l_ICRATE;
            end if;
  elsif l_RULETYPE='T' then
      l_DELTA:=0;
       Begin
        SELECT DELTA INTO l_DELTA
        FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
          AND ACTYPE=l_ACTYPE AND l_BASEDACR>=FRAMT AND l_BASEDACR<=TOAMT;
       EXCEPTION
       when OTHERS then
           l_DELTA:=0;
       End;

        l_result := (l_ICRATE+l_DELTA);


  elsif l_RULETYPE='C' then
         v_baseacr:=p_BASEDACR;
         v_revenue:=P_REVENUE;
         l_COMMISION:=0;
         l_DELTA:=0;
         Begin
             SELECT count(1) into  l_DELTA
             FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
             AND ACTYPE=l_ACTYPE;
         EXCEPTION
         when OTHERS then
           l_DELTA:=0;
         End;

         IF l_DELTA=0 then -- khong khai bao tier
             l_result:= l_ICRATE;
         Else
             For vc in(SELECT framt, toamt,delta
                       FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
                       AND ACTYPE=l_ACTYPE
                       --and framt >=p_BASEDACR
                       ORDER BY framt ) loop
                 If v_baseacr >0  then
                    l_result:=(l_ICRATE+vc.DELTA);
                    v_baseacr:=v_baseacr-least(v_baseacr,vc.toamt  - vc.framt);
                 End if;
             End loop;
         end if;
  end if;

    RETURN l_result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
/
