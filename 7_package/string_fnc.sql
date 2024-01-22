SET DEFINE OFF;
CREATE OR REPLACE PACKAGE string_fnc
IS

TYPE t_array IS TABLE OF VARCHAR2(1000)
   INDEX BY BINARY_INTEGER;

FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;
FUNCTION SplitAndCount(p_in_string VARCHAR2, p_delim VARCHAR2, p_TotalItem Out VARCHAR2) RETURN t_array;
END;
 
 
 
 
/


CREATE OR REPLACE PACKAGE BODY string_fnc
IS
   FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array
   IS
        i       number :=0;
        pos     number :=0;
        lv_str  varchar2(1000) := p_in_string;
        strings t_array;
   BEGIN
      pos := instr(lv_str,p_delim,1,1);
      WHILE ( pos != 0) LOOP
         i := i + 1;
         strings(i) := substr(lv_str,1,pos-1);
         lv_str := substr(lv_str,pos+1,length(lv_str));
         pos := instr(lv_str,p_delim,1,1);
         IF pos = 0 THEN
            strings(i+1) := lv_str;
         END IF;
      END LOOP;
      RETURN strings;
   END SPLIT;

   FUNCTION SplitAndCount(p_in_string VARCHAR2, p_delim VARCHAR2, p_TotalItem Out VARCHAR2) RETURN t_array
       IS
        i       number :=0;
        pos     number :=0;
        lv_str  varchar2(3500) := p_in_string;
        strings t_array;
        l_Count number :=0;
    BEGIN

       /*
       13/11/2013 - TRUONGLD ADD
       THEM FUNCTION TRA VE THONG TIN SO PHAN TU TRONG MANG
       */
       -- determine first chuck of string
       pos := instr(lv_str,p_delim,1,1);
       -- while there are chunks left, loop
       WHILE ( pos != 0) LOOP
          -- increment counter
          i := i + 1;
          l_Count := i;
          -- create array element for chuck of string
          strings(i) := substr(lv_str,1,pos-1);
          dbms_output.put_line('Data:' || strings(i));
          -- remove chunk from string
          lv_str := substr(lv_str,pos+1,length(lv_str));
          -- determine next chunk
          pos := instr(lv_str,p_delim,1,1);
          -- no last chunk, add to array
          IF pos = 0 THEN
             strings(i+1) := lv_str;
          END IF;
       END LOOP;
       -- return array
       p_TotalItem := l_Count;
       dbms_output.put_line('Count:' || l_Count);
       RETURN strings;
    END SplitAndCount;

END;
/
