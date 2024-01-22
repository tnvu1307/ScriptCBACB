SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od6005 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   PV_SYMBOL              IN       VARCHAR2, /*Ma chung khoan*/
   F_DATE                 IN       VARCHAR2, /*Tu ngay bao cao ky nay*/
   T_DATE                 IN       VARCHAR2 /*Den ngay bao cao ky nay*/
   )AUTHID CURRENT_USER
IS
    -- Bao cao thong ke danh mcc luu ky cua nha dau tu nuoc ngoai(IV)
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY      07-11-2019           created
    -- NAM.LY      10-12-2019           LAST UPDATED
    V_STROPTION         VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate_Previous date;
    v_ToDate_Previous   date;
    v_FromDate          date;
    v_ToDate            date;
    v_Symbol            varchar2(80);
    v_strsqlcmd         varchar2(32767);
    v_count_itemcd int;
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
    if (PV_SYMBOL = 'ALL' or PV_SYMBOL is null) then
        v_Symbol := '%';
    else
        v_Symbol := PV_SYMBOL;
    end if;
    v_FromDate               :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate                 :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    DELETE FROM MIS_ITEM_OD6005_RESULTS
    WHERE GROUPID='OD6005'
          AND FDATE      = v_FromDate
          AND TDATE      = v_ToDate;
    COMMIT;
    FOR REC IN(
       SELECT * FROM MIS_ITEMS_NEW WHERE GROUPID = 'OD6005' ORDER BY SERIAL
       )
       LOOP
           V_STRSQLCMD:= REPLACE(UPPER(REC.SQLCMD),'@FDATE',v_FromDate);
           V_STRSQLCMD:= REPLACE(UPPER(V_STRSQLCMD),'@TDATE',v_ToDate);
           V_STRSQLCMD:= REPLACE(UPPER(V_STRSQLCMD),'@PV_SYMBOL',v_Symbol);
           IF LENGTH(V_STRSQLCMD) > 0 THEN
              BEGIN
                EXECUTE IMMEDIATE V_STRSQLCMD;
                COMMIT;
                EXCEPTION
              WHEN OTHERS
               THEN
               --DBMS_OUTPUT.PUT_LINE('OD6005 ERROR');
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
              END;
           END IF;
       END LOOP;
    FOR CHECK_ITEMCD IN (
                SELECT *
                FROM MIS_ITEMS_NEW WHERE GROUPID='OD6005')
    LOOP
            SELECT COUNT(*)  INTO v_count_itemcd
            FROM MIS_ITEM_OD6005_RESULTS
            WHERE FDATE = v_FromDate
                  AND TDATE = v_ToDate
                  AND ITEMCD = CHECK_ITEMCD.ITEMCD;
            IF (v_count_itemcd = 0 )
            THEN
                BEGIN
                    INSERT INTO MIS_ITEM_OD6005_RESULTS (SUBBRID,GROUPID,ITEMCD,FDATE,TDATE,QTTY,SYMBOL,AMT,EXECQTTY_BUY,EXECAMT_BUY,EXECQTTY_SELL,EXECAMT_SELL,EXECQTTY_BUY_NET,EXECAMT_BUY_NET)
                    SELECT '0001' SUBBRID,
                            'OD6005' GROUPID,
                            CHECK_ITEMCD.ITEMCD ITEMCD,
                            v_FromDate FDATE,
                            v_ToDate TDATE,
                            0 QTTY,
                            '' SYMBOL,
                            0 AMT,
                            0 EXECQTTY_BUY,
                            0 EXECAMT_BUY,
                            0 EXECQTTY_SELL,
                            0 EXECAMT_SELL,
                            0 EXECQTTY_BUY_NET,
                            0 EXECAMT_BUY_NET
                        FROM DUAL;
                END;
            END IF;
    END LOOP;
    --
    UPDATE MIS_ITEM_OD6005_RESULTS
    SET GROUP1 =  SUBSTR(ITEMCD,0,1)
    WHERE GROUPID='OD6005'
    AND FDATE      = v_FromDate
    AND TDATE      = v_ToDate;
    --
    UPDATE MIS_ITEM_OD6005_RESULTS
    SET GROUP2 =  ITEMCD
    WHERE GROUPID='OD6005'
    AND SUBSTR(ITEMCD,0,1) IN ('B','F')
    AND FDATE      = v_FromDate
    AND TDATE      = v_ToDate;
    --
    UPDATE MIS_ITEM_OD6005_RESULTS
    SET GROUP2 =  ''
    WHERE GROUPID='OD6005'
    AND LENGTH(ITEMCD) = 1
    AND FDATE      = v_FromDate
    AND TDATE      = v_ToDate;
    -- MAIN REPORT
    OPEN PV_REFCURSOR FOR
                SELECT ITEM.ITEMCD,
                       ITEM.ITEMNAME GROUP1_NAME,
                       ITEM1.ITEMNAME GROUP2_NAME,
                       TO_NUMBER(RESULTS.QTTY) QTTY,
                       RESULTS.SYMBOL,
                       TO_NUMBER(RESULTS.AMT) AMT,
                       TO_NUMBER(RESULTS.EXECQTTY_BUY) EXECQTTY_BUY,
                       TO_NUMBER(RESULTS.EXECAMT_BUY) EXECAMT_BUY,
                       TO_NUMBER(RESULTS.EXECQTTY_SELL) EXECQTTY_SELL,
                       TO_NUMBER(RESULTS.EXECAMT_SELL) EXECAMT_SELL,
                       TO_NUMBER(RESULTS.EXECQTTY_BUY) - TO_NUMBER(RESULTS.EXECQTTY_SELL) EXECQTTY_BUY_NET,
                       TO_NUMBER(RESULTS.EXECAMT_BUY) - TO_NUMBER(RESULTS.EXECAMT_SELL) EXECAMT_BUY_NET,
                       RESULTS.GROUP1,
                       RESULTS.GROUP2
                FROM MIS_ITEM_OD6005_RESULTS RESULTS RIGHT JOIN MIS_ITEMS_NEW ITEM ON  ITEM.ITEMCD = RESULTS.GROUP1 AND RESULTS.GROUPID = ITEM.GROUPID
                                                     LEFT JOIN MIS_ITEMS_NEW ITEM1 ON  ITEM1.ITEMCD = RESULTS.GROUP2 AND RESULTS.GROUPID = ITEM1.GROUPID
                WHERE ITEM.GROUPID = 'OD6005'
                    AND ITEM.VISIBLE = 'Y'
                    AND RESULTS.FDATE      = v_FromDate
                    AND RESULTS.TDATE      = v_ToDate;
EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('OD6005 ERROR');
   
      RETURN;
END;
/
