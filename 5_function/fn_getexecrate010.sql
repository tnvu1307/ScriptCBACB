SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GETEXECRATE010(pv_CAMASTID IN VARCHAR2, pv_TYPERATE IN VARCHAR2,
                        pv_DEVIDENTRATE IN VARCHAR2, pv_DEVIDENTVALUE IN VARCHAR2) RETURN NUMBER IS
    -- PURPOSE: TY LE CHIA TUNG DOT
    -- MODIFICATION HISTORY
    -- PERSON      DATE         COMMENTS
    -- ---------   ------       -------------------------------------------
    -- TRUONGLD   27/05/2015     CREATED
    v_Return number(20,3);
    v_CAMASTID  VARCHAR2(20);
    v_TYPERATE  VARCHAR2(10);
    v_DEVIDENTRATE number(20,3);
    v_DEVIDENTVALUE number(20,3);

    v_CA_DEVIDENTRATE number(20,3);
    v_CA_DEVIDENTVALUE number(20,3);
    v_EXERATE number(20,4);
    v_EXERATED number(20,4);
BEGIN

    v_CAMASTID :=  REPLACE(pv_CAMASTID,'.','');
    v_TYPERATE := pv_TYPERATE;
    v_DEVIDENTRATE := pv_DEVIDENTRATE;
    v_DEVIDENTVALUE := pv_DEVIDENTVALUE;

    BEGIN
        Select nvl(Sum(execrate),0) into v_EXERATED from camastdtl WHERE DELTD <> 'Y' AND CAMASTID = v_CAMASTID and status = 'C';
    EXCEPTION
        WHEN OTHERS THEN v_EXERATED := 0;
    END;


    dbms_output.put_line('v_TYPERATE:' || v_TYPERATE);
    dbms_output.put_line('v_CAMASTID:' || v_CAMASTID);
    dbms_output.put_line('v_DEVIDENTRATE:' || v_DEVIDENTRATE);
    dbms_output.put_line('pv_DEVIDENTVALUE:' || pv_DEVIDENTVALUE);

    If v_TYPERATE = 'R' Then -- Chia theo gia tri
        SELECT DEVIDENTRATE INTO v_CA_DEVIDENTRATE FROM CAMAST WHERE CAMASTID = v_CAMASTID;
        v_EXERATE := v_DEVIDENTRATE / v_CA_DEVIDENTRATE;
    ElsIf v_TYPERATE = 'V' Then -- Chia theo ty le
        SELECT DEVIDENTVALUE INTO v_CA_DEVIDENTVALUE FROM CAMAST WHERE CAMASTID = v_CAMASTID;
        v_EXERATE := v_DEVIDENTVALUE / v_CA_DEVIDENTVALUE;
    End If;

    v_EXERATE := v_EXERATE * 100;
    If v_EXERATED + v_EXERATE >= 100 Then
       v_Return := 100 - v_EXERATED;
    Else
       v_Return := v_EXERATE;
    End If;

    dbms_output.put_line('v_CA_DEVIDENTRATE:' || v_CA_DEVIDENTRATE);
    dbms_output.put_line('v_CA_DEVIDENTVALUE:' || v_CA_DEVIDENTVALUE);
    dbms_output.put_line('v_EXERATED:' || v_EXERATED);
    dbms_output.put_line('v_EXERATE:' || v_EXERATE);
    dbms_output.put_line('v_Return:' || v_Return);

    RETURN nvl(v_Return,0);

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
/
