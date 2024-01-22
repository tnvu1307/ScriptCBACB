SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GENINSERT_NAMLY (P_TABLENAME VARCHAR2, P_TYPE VARCHAR2)
RETURN VARCHAR2
IS
  L_SOURCE VARCHAR2(32000);
  L_COUNT  NUMBER := 0;
BEGIN

    --
    FOR REC IN (
                SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, COUNT(COLUMN_ID) OVER (PARTITION BY 1) TOTAL_COLUMN
                FROM ALL_TAB_COLS
                WHERE TABLE_NAME = P_TABLENAME AND
                      OWNER IN (SELECT SYS_CONTEXT('USERENV','CURRENT_SCHEMA') FROM DUAL)
                ORDER BY COLUMN_ID
               )
   LOOP
       L_COUNT := L_COUNT + 1;
       --
       IF (L_COUNT = 1) THEN
          L_SOURCE := 'INSERT INTO '||P_TABLENAME||' (';
       END IF;
       --
       L_SOURCE := L_SOURCE|| ''||REC.COLUMN_NAME||'';
       --
       IF (L_COUNT < REC.TOTAL_COLUMN) THEN
          L_SOURCE := L_SOURCE||',';
       ELSE
          L_SOURCE := L_SOURCE|| ')';
       END IF;
   END LOOP;
   --
   L_COUNT := 0;
   FOR REC IN (
                SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, COUNT(COLUMN_ID) OVER (PARTITION BY 1) TOTAL_COLUMN
                FROM ALL_TAB_COLS
                WHERE TABLE_NAME = P_TABLENAME AND
                      OWNER IN (SELECT SYS_CONTEXT('USERENV','CURRENT_SCHEMA') FROM DUAL)
                ORDER BY COLUMN_ID
               )
   LOOP
       --
       L_COUNT := L_COUNT + 1;
       IF (P_TYPE ='VALUES') THEN
          L_SOURCE := L_SOURCE||CHR(10);
          IF (L_COUNT = 1) THEN
             L_SOURCE := L_SOURCE||'VALUES'||' ('|| CHR(10);
          END IF;
          L_SOURCE := L_SOURCE||'         ''''';
          IF (L_COUNT < REC.TOTAL_COLUMN) THEN
             L_SOURCE := L_SOURCE||',';
          END IF;
          L_SOURCE := L_SOURCE||'--'||REC.COLUMN_NAME||' -------'||REC.DATA_TYPE||'('||REC.DATA_LENGTH||')';
          --
          IF (L_COUNT = REC.TOTAL_COLUMN) THEN
             L_SOURCE := L_SOURCE||CHR(10)|| '       )';
          END IF;
       ELSE
          L_SOURCE := L_SOURCE||CHR(10);
          IF (L_COUNT = 1) THEN
             L_SOURCE := L_SOURCE||'SELECT'||' '|| CHR(10);
          END IF;
          L_SOURCE := L_SOURCE||'         ''''';
          IF (L_COUNT < REC.TOTAL_COLUMN) THEN
             L_SOURCE := L_SOURCE||',';
          END IF;
          L_SOURCE := L_SOURCE||'--'||REC.COLUMN_NAME||' -------'||REC.DATA_TYPE||'('||REC.DATA_LENGTH||')';
          --
          IF (L_COUNT = REC.TOTAL_COLUMN) THEN
             L_SOURCE := L_SOURCE||CHR(10)|| 'FROM ';
          END IF;
       END IF;
   END LOOP;
   RETURN L_SOURCE;
END;
/
