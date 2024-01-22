SET DEFINE OFF;
CREATE OR REPLACE FUNCTION format_tittle3 ( InputString IN VARCHAR2 )
RETURN  varchar2

IS
N_Index          NUMBER;
v_Char           CHAR(255);
V_PrevChar       CHAR(255);
v_nextChar       CHAR(255);
V_OutputString   VARCHAR(255);
V_OutputString2 VARCHAR(255);
V_length        NUMBER;
--V_length2       NUMBER;
v_InputString   VARCHAR(255);
--v_debug VARCHAR(2550);
--v_dem VARCHAR(255);
v_String VARCHAR(255);
v_temp varchar(50);
 BEGIN
--v_debug:=0;
v_InputString:=format_tittle(InputString);
V_OutputString:=v_InputString;
V_OutputString2:=v_InputString;
N_Index:=  1;
V_length:= length(v_InputString);

--v_dem:=0;
WHILE N_Index <= V_length
LOOP
   --v_debug:=v_debug+1;
            v_Char     := substr(V_OutputString, N_Index, 1);
            v_nextChar:=substr(V_OutputString, N_Index+1, 1);
            --if v_char = upper(v_char) then V_debug:=v_char; end if;
            --if (ASCII(v_char) BETWEEN 65 AND 122) and (ASCII(v_nextChar) BETWEEN 65 AND 122)
            if v_Char not in (';', ':', '!', '?', '.', '_', '-','?','?', '&', '"', '(',')','/','\',',')
                --and (ASCII(v_Char)not BETWEEN 48 AND 57)
            and v_nextChar not in (';', ':', '!', '?', '.', '_', '-','?','?', '&', '"', '(',')','/','\',',')

            then
                v_string:=v_char;

                while v_nextChar not in (' ',';', ':', '!', '?', '.', '_','-','?','?', '&', '"', '(',')','/','\',',')

                loop
                    v_string:=replace((v_string||v_nextChar),chr(32), '');
                    --v_debug:=v_debug||','||v_string;
                    N_Index:=N_Index+1;
                    v_nextChar:=substr(V_OutputString, N_Index+1, 1);
                    --v_dem:=v_dem+1;
                end loop;

              for x in (select word from upcase_word)
                loop
                  if (upper(v_String)=upper(x.word)) then
                        V_OutputString2:=STUFF(V_OutputString2,N_Index-LENGTH(v_String)+1,LENGTH(v_String),upper(v_String));
                        --v_debug:=v_debug||','||upper(v_String);

                  end if;
                end loop;

            end if;
            N_Index:=N_Index+1;


END LOOP;

RETURN V_OutputString2;
    EXCEPTION
    WHEN others THEN return v_InputString ;

END;
 
 
 
 
/
