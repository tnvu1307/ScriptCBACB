SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_clearday_sec(pv_sectype IN VARCHAR2, pv_clearday in number)
--T10/2015 TTBT T+2:
--Ham check Chu ky thanh toan tren man hinh OD co = Chu ky TT tren sysvar hay k voi TH khac trai phieu?
--Neu co tra ve True, neu ko tra ve False
    RETURN varchar2 IS
    v_Result  varchar2(5);
    v_codeid varchar2(10);
    v_sectype varchar2(5);
    v_clearday number;
    v_sysclearday number;
    v_sybol_sectype varchar2(5);
BEGIN
    --v_codeid := nvl(pv_codeid,'--ALL--');
    v_codeid := '--ALL--';
    v_sectype := pv_sectype;
    v_clearday := pv_clearday;

    SELECT TO_NUMBER(NVL(MAX(VARVALUE),'0')) INTO V_SYSCLEARDAY FROM SYSVAR WHERE GRNAME LIKE 'OD' AND VARNAME='CLEARDAY' ;
    IF (v_clearday <> v_sysclearday) THEN
        IF (v_codeid = '--ALL--') THEN
          if (v_sectype not in ('444', '003', '006', '222')) THEN
            v_result := 'False';
          ELSE
            v_result := 'True' ;
          END IF;

         ELSE
            SELECT SECTYPE INTO V_SYBOL_SECTYPE FROM SBSECURITIES WHERE CODEID=V_CODEID AND ROWNUM<=1;
            IF (v_sectype not in ('444', '003', '006', '222') and v_sybol_sectype not in ('444', '003', '006', '222')) THEN
            v_result := 'False';
          ELSE
            v_result := 'True' ;
          END IF;

         END IF;
     ELSE
        v_result := 'True' ;
     END IF;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 'False';
END;
 
 
/
