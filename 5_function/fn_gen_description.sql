SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_description(pv_CATYPE In VARCHAR2, pv_OPTSYMBOL IN VARCHAR2,pv_REPORTDATE IN VARCHAR2,
                                              pv_DEVIDENTRATE in VARCHAR2,pv_DEVIDENTVALUE IN VARCHAR2,pv_TYPERATE IN VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(1000);

BEGIN
    if(pv_CATYPE='010') THEN
             if(pv_TYPERATE='R') THEN -- chia theo ti le
             v_result:= 'Cash dividend, '||pv_OPTSYMBOL||', ' || 'record date on ' || pv_REPORTDATE || ', rate ' ||pv_DEVIDENTRATE || '%';
             ELSE
             v_result:= 'Cash dividend, '||pv_OPTSYMBOL||', ' || 'record date on ' || pv_REPORTDATE || ', value ' ||pv_DEVIDENTVALUE;
             END IF;
    elsif(pv_CATYPE='011') THEN
             if(pv_TYPERATE='R') THEN -- chia theo ti le
             v_result:= 'Stock dividend, '||pv_OPTSYMBOL||', ' || 'record date on ' || pv_REPORTDATE || ', rate ' ||pv_DEVIDENTRATE || '%';
             ELSE
             v_result:= 'Stock dividend, '||pv_OPTSYMBOL||', ' || 'record date on ' || pv_REPORTDATE || ', rate ' ||pv_DEVIDENTVALUE;
             END IF;
    elsif(pv_CATYPE='021') THEN
             if(pv_TYPERATE='R') THEN -- chia theo ti le
             v_result:= 'Bonus issue, '||pv_OPTSYMBOL||', ' || 'record date on ' || pv_REPORTDATE || ', rate ' ||pv_DEVIDENTRATE || '%';
             ELSE
             v_result:= 'Bonus issue, '||pv_OPTSYMBOL||', ' || 'record date on ' || pv_REPORTDATE || ', rate ' ||pv_DEVIDENTVALUE;
             END IF;
    END if;
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 'A';
END;
/
