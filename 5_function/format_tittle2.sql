SET DEFINE OFF;
CREATE OR REPLACE FUNCTION format_tittle2 ( InputString IN VARCHAR2 )
RETURN  varchar2

IS
N_Index          NUMBER;
N_Index2          NUMBER;
N_Index3         NUMBER;
v_Char           CHAR(10);
V_PrevChar       CHAR(10);
v_nextChar       CHAR(10);
V_OutputString   VARCHAR(255);
V_OutputString2 VARCHAR(255);
V_length        NUMBER;
V_length2       NUMBER;
v_InputString   VARCHAR(255);
v_debug VARCHAR(255);
v_dem VARCHAR(255);
v_String VARCHAR(30000);
BEGIN
v_debug:=0;
v_InputString:=trim(InputString);
V_OutputString:=v_InputString;
V_OutputString2:=v_InputString;
N_Index:=  1;
V_length:= length(v_InputString);
v_dem:=0;

/*FOR X IN (SELECT RPTID FROM RPTMASTER WHERE RPTID LIKE InputString||'%' AND
                                            VISIBLE LIKE 'Y' ORDER BY RPTID )
    LOOP
        v_dem:=v_dem+1;
        v_String:=v_String||','||X.RPTID;
        IF V_DEM IN(10,20,30,40,50,60,70)
        THEN
            v_String:=v_String||'
            ';
        END IF;
    END LOOP;*/

WHILE N_Index <= V_length
LOOP
   --v_debug:=v_debug+1;
            v_Char     := substr(V_OutputString, N_Index, 1);
            v_nextChar:=substr(V_OutputString, N_Index+1, 1);
            --if v_char = upper(v_char) then V_debug:=v_char; end if;
            if v_char = upper(v_char) and v_char not in (' ',';', ':', '!', '?', '.', '_', '-', '&', '"', '(',')')
            and ASCII(v_char)<=122 and ASCII(v_char)>=65 and v_nextChar not in (' ',')')
            then
                v_string:=v_char;
                N_Index2:=N_Index;
                while v_nextChar not in (' ',')')
                loop
                    v_string:=replace((v_string||v_nextChar),chr(32), '');
                    --v_debug:=v_debug||','||v_string;
                    N_Index2:=N_Index2+1;
                    v_nextChar:=substr(V_OutputString, N_Index2+1, 1);
                    v_dem:=v_dem+1;
                end loop;
                v_debug:=upper(v_String);
                if upper(v_String) in ('A/THQ','TH','CP','VSD/6036','B/THQ','TP','CP','SO','VSD','CK','CI','CA','DS','TK','GD','TCPH','TNCN','NG','HOSE','SGDCK','SP','DSKH','KK','A/LK','HNX','SMS','TT','UBCK','EXCEL','QTRR','UTTB','UNC','DF','CALL','TRIGGER','GL','MR+BL','T0','MM/yyyy','GDKQ','NV','MG','QL','FO','PL','TTBT','CCQ','ATO','NVKD','VSD/3011','VSD/3071','B/LK','VSD/3014','TTLK','REPO','BO','Q-DK','THQ')
                then

                        V_OutputString2:=STUFF(V_OutputString2,N_Index,LENGTH(v_String),upper(v_String));
                end if;
                for x in (select word from upcase_word)
                loop
                  if (upper(v_String)=upper(x.word)) then
                        V_OutputString2:=STUFF(V_OutputString2,N_Index,LENGTH(v_String),upper(v_String));
                  end if;
                end loop;
                N_Index:=N_Index2;
            end if;
            N_Index:=N_Index+1;


END LOOP;
--v_debug:=V_OutputString2||v_debug;
RETURN v_String;
    EXCEPTION
    WHEN others THEN return v_String ;

END;
 
 
 
 
/
