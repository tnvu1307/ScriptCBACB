SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_CHECK_VALUEOFISSUE(PV_ISSUESID IN VARCHAR2, PV_VALUEOFISSUE IN VARCHAR2, PV_AUTOID IN VARCHAR2)
RETURN VARCHAR2
IS V_RESULT              VARCHAR2(10);
   V_VALUEOFISSUE_OLD    NUMBER:= 0;
   V_VALUEOFISSUE_MAX    NUMBER;
   V_VALUEOFISSUE_EDIT   NUMBER;
   V_BONDISSUE_AUTOID    VARCHAR2(10):=NULL;
BEGIN
    --LAY VALUEOFISSUE CUA DOT PHAT HANH TRAI PHIEU
    SELECT VALUEOFISSUE INTO V_VALUEOFISSUE_MAX
    FROM ISSUES
    WHERE AUTOID = PV_ISSUESID;
    --TINH TONG VALUEOFISSUE HIEN TAI CUA ISSUECODE
    SELECT SUM(VALUEOFISSUE) INTO V_VALUEOFISSUE_OLD
    FROM (
          SELECT AUTOID ISSUESID,0 VALUEOFISSUE FROM ISSUES
          UNION ALL
          SELECT ISSUESID,VALUEOFISSUE FROM BONDISSUE
         )
    WHERE ISSUESID = PV_ISSUESID
    GROUP BY ISSUESID;
    --KIEM TRA (V_VALUEOFISSUE_OLD + PV_VALUEOFISSUE) > (VALUEOFISSUE CUA DOT PHAT HANH TRAI PHIEU) CHUA?
    --> NEU LON HON: FALSE, NGUOC LAI: TRUE
    V_BONDISSUE_AUTOID := PV_AUTOID;
    IF V_BONDISSUE_AUTOID IS NULL THEN --TRUONG HOP: THEM MOI
        BEGIN
            IF ((V_VALUEOFISSUE_OLD + PV_VALUEOFISSUE) > (V_VALUEOFISSUE_MAX))
            THEN
                V_RESULT := 'False';
            ELSE
                V_RESULT := 'True';
            END IF;
        END;
    ELSE --TRUONG HOP: CHINH SUA
        BEGIN

            --TINH VALUEOFISSUE DA GAN VOI AUTOID
            SELECT VALUEOFISSUE INTO V_VALUEOFISSUE_EDIT
            FROM BONDISSUE
            WHERE AUTOID = TO_NUMBER(V_BONDISSUE_AUTOID);
            ---
            IF ((V_VALUEOFISSUE_OLD + PV_VALUEOFISSUE - V_VALUEOFISSUE_EDIT) > (V_VALUEOFISSUE_MAX))
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
