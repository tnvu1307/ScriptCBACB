SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE OD6002 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE_PREVIOUS        IN       VARCHAR2, /*Tu ngay bao cao ky truoc*/
   T_DATE_PREVIOUS        IN       VARCHAR2, /*den ngay bao cao ky truoc*/
   F_DATE                 IN       VARCHAR2, /*Tu ngay bao cao ky nay*/
   T_DATE                 IN       VARCHAR2 /*den ngay bao cao ky nay*/
   )AUTHID CURRENT_USER
IS
    -- Bao cao thong ke danh mcc luu ky cua nha dau tu nuoc ngoai(I)
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY      30-10-2019           created
    V_STROPTION         VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate_Previous date;
    v_ToDate_Previous   date;
    v_FromDate          date;
    v_ToDate            date;
    v_strsqlcmd         varchar2(4000);
    v_count_itemcd int;
     v_count_subitemcd int;
     pkgctx   plog.log_ctx;
BEGIN
    V_STROPTION := OPT;
    if V_STROPTION = 'A' then
        V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        V_STRBRID := substr(BRID,1,2) || '__' ;
    else
        V_STRBRID:= BRID;
    end if;

    v_FromDate_Previous      :=     TO_DATE(F_DATE_PREVIOUS, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate_Previous        :=     TO_DATE(T_DATE_PREVIOUS, SYSTEMNUMS.C_DATE_FORMAT);
    v_FromDate               :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate                 :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    DELETE FROM MIS_ITEM_NEW_RESULTS
    WHERE GROUPID='OD6002'
          AND FDATE_PREV = v_FromDate_Previous
          AND TDATE_PREV = v_ToDate_Previous
          AND FDATE      = v_FromDate
          AND TDATE      = v_ToDate;
    COMMIT;

    FOR REC IN(
       SELECT * FROM MIS_ITEMS_NEW WHERE GROUPID = 'OD6002' ORDER BY SERIAL
       )
       LOOP
           V_STRSQLCMD:= REPLACE(UPPER(REC.SQLCMD),'@FDATE_PREV',v_FromDate_Previous);
           V_STRSQLCMD:= REPLACE(UPPER(V_STRSQLCMD),'@TDATE_PREV',v_ToDate_Previous);
           V_STRSQLCMD:= REPLACE(UPPER(V_STRSQLCMD),'@FDATE_THIS',v_FromDate);
           V_STRSQLCMD:= REPLACE(UPPER(V_STRSQLCMD),'@TDATE_THIS',v_ToDate);
           IF LENGTH(V_STRSQLCMD) > 0 THEN
              BEGIN
                EXECUTE IMMEDIATE V_STRSQLCMD;
                COMMIT;
                EXCEPTION
              WHEN OTHERS
               THEN
               --DBMS_OUTPUT.PUT_LINE('OD6002 ERROR');
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
              END;
           END IF;
       END LOOP;


    FOR CHECK_ITEMCD IN (
                SELECT *
                FROM MIS_ITEMS_NEW WHERE GROUPID = 'OD6002')
    LOOP
            SELECT COUNT(*)  INTO v_count_itemcd
            FROM MIS_ITEM_NEW_RESULTS
            WHERE FDATE_PREV = v_FromDate_Previous
                        AND TDATE_PREV = v_ToDate_Previous
                        AND FDATE      = v_FromDate
                       AND TDATE      = v_ToDate
                       AND ITEMCD = CHECK_ITEMCD.ITEMCD;
--
--            IF (v_count_itemcd > 0 AND SUBSTR(CHECK_ITEMCD.ITEMCD,0,1) NOT IN ('B','C'))
--            THEN
--                BEGIN
--                    INSERT INTO MIS_ITEM_NEW_RESULTS (SUBBRID,GROUPID,ITEMCD,AMTTYPE,ITEMVALUE,FDATE,TDATE,FDATE_PREV,TDATE_PREV,QTTY,PREV_QTTY,SYMBOL)
--                    SELECT '0001' SUBBRID,
--                                'OD6002' GROUPID,
--                                CHECK_ITEMCD.ITEMCD ITEMCD,
--                                '' AMTTYPE,
--                                '' ITEMVALUE,
--                                v_FromDate FDATE,
--                                v_ToDate TDATE,
--                                v_FromDate_Previous FDATE_PREV,
--                                v_ToDate_Previous TDATE_PREV,
--                                0 QTTY,
--                                0 PREV_QTTY,
--                                '' SYMBOL
--                        FROM DUAL;
--                END;
--            END IF;

            --IF (v_count_itemcd = 0 AND SUBSTR(CHECK_ITEMCD.ITEMCD,0,1) NOT IN ('B','C'))
            IF (v_count_itemcd = 0 )
            THEN
                BEGIN
                    INSERT INTO MIS_ITEM_NEW_RESULTS (SUBBRID,GROUPID,ITEMCD,AMTTYPE,ITEMVALUE,FDATE,TDATE,FDATE_PREV,TDATE_PREV,QTTY,PREV_QTTY,SYMBOL)
                    SELECT '0001' SUBBRID,
                                'OD6002' GROUPID,
                                CHECK_ITEMCD.ITEMCD ITEMCD,
                                '' AMTTYPE,
                                '' ITEMVALUE,
                                v_FromDate FDATE,
                                v_ToDate TDATE,
                                v_FromDate_Previous FDATE_PREV,
                                v_ToDate_Previous TDATE_PREV,
                                0 QTTY,
                                0 PREV_QTTY,
                                '' SYMBOL
                        FROM DUAL;
                END;
            END IF;

--            IF (v_count_itemcd = 0 AND SUBSTR(CHECK_ITEMCD.ITEMCD,0,1) IN ('B','C'))
--            THEN
--                BEGIN
--                    INSERT INTO MIS_ITEM_NEW_RESULTS (SUBBRID,GROUPID,ITEMCD,AMTTYPE,ITEMVALUE,FDATE,TDATE,FDATE_PREV,TDATE_PREV,QTTY,PREV_QTTY,SYMBOL)
--                    SELECT '0001' SUBBRID,
--                                'OD6002' GROUPID,
--                                CHECK_ITEMCD.ITEMCD ITEMCD,
--                                '' AMTTYPE,
--                                '' ITEMVALUE,
--                                v_FromDate FDATE,
--                                v_ToDate TDATE,
--                                v_FromDate_Previous FDATE_PREV,
--                                v_ToDate_Previous TDATE_PREV,
--                                0 QTTY,
--                                0 PREV_QTTY,
--                                '' SYMBOL
--                        FROM DUAL;
--                END;
--            END IF;
    END LOOP;

--    -- A. TIN PHIEU
--
--    -- B. TRAI PHIEU
--    UPDATE MIS_ITEM_NEW_RESULTS
--    SET QTTY = (SELECT SUM(TO_NUMBER(R.QTTY))
--                        FROM MIS_ITEM_NEW_RESULTS R
--                        WHERE R.GROUPID='OD6002' AND R.ITEMCD IN ('B1','B2','B3')
--                                                 AND R.FDATE_PREV = v_FromDate_Previous
--                                                 AND R.TDATE_PREV = v_ToDate_Previous
--                                                 AND R.FDATE      = v_FromDate
--                                                 AND R.TDATE      = v_ToDate
--                    )
--    WHERE GROUPID='OD6002' AND ITEMCD = 'B';
--
--    UPDATE MIS_ITEM_NEW_RESULTS
--    SET PREV_QTTY = (SELECT SUM(TO_NUMBER(R.PREV_QTTY))
--                        FROM MIS_ITEM_NEW_RESULTS R
--                        WHERE R.GROUPID='OD6002' AND R.ITEMCD IN ('B1','B2','B3')
--                                                 AND R.FDATE_PREV = v_FromDate_Previous
--                                                 AND R.TDATE_PREV = v_ToDate_Previous
--                                                 AND R.FDATE      = v_FromDate
--                                                 AND R.TDATE      = v_ToDate
--                    )
--    WHERE GROUPID='OD6002' AND ITEMCD = 'B';
--
--    -- C. CO PHIEU
--    UPDATE MIS_ITEM_NEW_RESULTS
--    SET QTTY = (SELECT SUM(TO_NUMBER(R.QTTY))
--                        FROM MIS_ITEM_NEW_RESULTS R
--                        WHERE R.GROUPID='OD6002' AND R.ITEMCD IN ('C1','C2','C3')
--                                                 AND R.FDATE_PREV = v_FromDate_Previous
--                                                 AND R.TDATE_PREV = v_ToDate_Previous
--                                                 AND R.FDATE      = v_FromDate
--                                                 AND R.TDATE      = v_ToDate
--                    )
--    WHERE GROUPID='OD6002' AND ITEMCD = 'C';
--
--    UPDATE MIS_ITEM_NEW_RESULTS
--    SET PREV_QTTY = (SELECT SUM(TO_NUMBER(R.PREV_QTTY))
--                        FROM MIS_ITEM_NEW_RESULTS R
--                        WHERE R.GROUPID='OD6002' AND R.ITEMCD IN ('C1','C2','C3')
--                                                 AND R.FDATE_PREV = v_FromDate_Previous
--                                                 AND R.TDATE_PREV = v_ToDate_Previous
--                                                 AND R.FDATE      = v_FromDate
--                                                 AND R.TDATE      = v_ToDate
--                    )
--    WHERE GROUPID='OD6002' AND ITEMCD = 'C';

    --
    UPDATE MIS_ITEM_NEW_RESULTS
    SET GROUP1 =  SUBSTR(ITEMCD,0,1)
    WHERE GROUPID='OD6002'
    AND FDATE_PREV = v_FromDate_Previous
    AND TDATE_PREV = v_ToDate_Previous
    AND FDATE      = v_FromDate
    AND TDATE      = v_ToDate;

    UPDATE MIS_ITEM_NEW_RESULTS
    SET GROUP2 =  ITEMCD
    WHERE GROUPID='OD6002'
    AND SUBSTR(ITEMCD,0,1) IN ('B','C')
    AND FDATE_PREV = v_FromDate_Previous
    AND TDATE_PREV = v_ToDate_Previous
    AND FDATE      = v_FromDate
    AND TDATE      = v_ToDate;

    UPDATE MIS_ITEM_NEW_RESULTS
    SET GROUP2 =  ''
    WHERE GROUPID='OD6002'
    AND LENGTH(ITEMCD) = 1
    AND FDATE_PREV = v_FromDate_Previous
    AND TDATE_PREV = v_ToDate_Previous
    AND FDATE      = v_FromDate
    AND TDATE      = v_ToDate;
    -- MAIN REPORT
    OPEN PV_REFCURSOR FOR
                SELECT ITEM.ITEMCD, ITEM.ITEMNAME GROUP1_NAME, ITEM1.ITEMNAME GROUP2_NAME, TO_NUMBER(RESULTS.QTTY) QTTY,
                       TO_NUMBER(RESULTS.PREV_QTTY) PREV_QTTY, RESULTS.SYMBOL, ITEM.FONTTYPE, RESULTS.GROUP1, RESULTS.GROUP2,
                       RESULTS.QTTY - RESULTS.PREV_QTTY QTTY_DIFF
                FROM MIS_ITEM_NEW_RESULTS RESULTS 
                LEFT JOIN MIS_ITEMS_NEW ITEM ON  ITEM.ITEMCD = RESULTS.GROUP1 AND RESULTS.GROUPID = ITEM.GROUPID
                LEFT JOIN MIS_ITEMS_NEW ITEM1 ON  ITEM1.ITEMCD = RESULTS.GROUP2 AND RESULTS.GROUPID = ITEM1.GROUPID
                WHERE ITEM.GROUPID = 'OD6002'
                    AND ITEM.VISIBLE = 'Y'
                    --AND LENGTH(RESULTS.ITEMCD) = 3
                    AND RESULTS.FDATE_PREV = v_FromDate_Previous
                    AND RESULTS.TDATE_PREV = v_ToDate_Previous
                    AND RESULTS.FDATE      = v_FromDate
                    AND RESULTS.TDATE      = v_ToDate;

EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('OD6002 ERROR');
   
      RETURN;
END;
/
