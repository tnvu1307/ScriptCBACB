SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_advdesc(pv_RATE In VARCHAR2, pv_CATYPE IN VARCHAR2,pv_RATE2 IN VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(250);
    v_strLeft VARCHAR2(250);
    v_strRight VARCHAR2(250);
BEGIN
    if(pv_CATYPE='011') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= v_strLeft || ' Owned shares ' ||  v_strRight || ' resultant shares ';
    ELSIF (pv_CATYPE='014') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= v_strLeft || ' Owned shares entitled  ' ||  v_strRight || ' rights, ';

        v_strLeft:= substr(pv_RATE2,0,instr(pv_RATE2,'/') - 1);
        v_strRight:= substr(pv_RATE2,instr(pv_RATE2,'/') + 1,length(pv_RATE2));
        v_Result:= v_Result || v_strLeft || ' buy ' ||  v_strRight || ' resultant shares ';

    ELSIF (pv_CATYPE='017') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= v_strLeft || ' Owned bonds ' ||  v_strRight || ' resultant shares ';

    ELSIF (pv_CATYPE='020') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= v_strLeft || ' Owned shares ' ||  v_strRight || ' resultant shares ';

    ELSIF (pv_CATYPE='021') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= v_strLeft || ' Owned shares ' ||  v_strRight || ' resultant shares ';

    ELSIF (pv_CATYPE='005') THEN
        --v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        --v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= 'Annual General Meeting';

    ELSIF (pv_CATYPE='006') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= v_strLeft || ' Owned shares ' ||  v_strRight || ' voting rights ';
    ELSIF (pv_CATYPE='022') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= v_strLeft || ' Owned shares ' ||  v_strRight || ' voting rights ';

    ELSIF (pv_CATYPE='023') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= v_strLeft || ' Owned bonds  ' ||  v_strRight || ' resultant shares ';

    ELSIF (pv_CATYPE='028') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= v_strLeft || ' Owned shares ' ||  v_strRight || ' voting rights ';
    ELSIF (pv_CATYPE='040') THEN
        v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
        v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
        v_Result:= 'The owner of ' || v_strLeft || ' bonds has the right to resell ' || v_strRight || ' bonds';

    END IF;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
