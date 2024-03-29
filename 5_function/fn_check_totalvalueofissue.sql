SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_CHECK_TOTALVALUEOFISSUE(PV_VALUEOFISSUE IN VARCHAR2, PV_AUTOID IN VARCHAR2)
RETURN VARCHAR2
IS V_RESULT              VARCHAR2(10);
   V_TOTALVALUEOFISSUE   NUMBER:= 0;
   V_ISSUES_AUTOID       VARCHAR2(10):=NULL;
BEGIN
    V_ISSUES_AUTOID := PV_AUTOID;
    IF V_ISSUES_AUTOID IS NULL THEN --TRUONG HOP: THEM MOI
            V_RESULT := 'True';
    ELSE --TRUONG HOP: CHINH SUA
        BEGIN

            --TINH VALUEOFISSUE DA GAN VOI AUTOID
            SELECT SUM(VALUEOFISSUE) INTO V_TOTALVALUEOFISSUE
            FROM BONDISSUE
            WHERE ISSUESID = TO_NUMBER(V_ISSUES_AUTOID);
            ---
            IF (PV_VALUEOFISSUE < V_TOTALVALUEOFISSUE)
            THEN
                V_RESULT := 'False';
            ELSE
                V_RESULT := 'True';
            END IF;
        END;
    END IF;
    --
    RETURN V_RESULT;
    --
    EXCEPTION
    WHEN OTHERS THEN
    RETURN 'False';
END;
/
